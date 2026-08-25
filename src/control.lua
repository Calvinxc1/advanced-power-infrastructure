-- Steam temperature passthrough for this mod's heat exchangers.
--
-- A Factorio boiler always emits at exactly its target_temperature, however hot
-- or cold the heat network feeding it actually is. That makes a heat row snap
-- between full output and nothing, with no sense of the network warming up.
--
-- This restores that sense by rewriting the steam temperature to follow the
-- network:
--
--     steam = clamp(buffer_temperature, min_working_temperature, target)
--
-- Below min_working the engine already refuses to run. Between the two the
-- steam leaves at whatever the network is actually at, so turbines -- which
-- already scale their output linearly with steam temperature -- taper on their
-- own. At or above target the steam is clamped, so an exchanger never emits
-- steam hotter than optimal.
--
-- The rewrite goes through set_fluid_segment_fluid, which updates a whole
-- connected pipe network in one call, so the cost tracks the number of steam
-- networks rather than the number of exchangers. See issue #11 for the
-- measurements behind all of this.

-- Fluid storage 2 is a boiler's output box; a pipe has a single box at 1.
local OUTPUT_BOX = 2
local PIPE_BOX = 1

local TRACKED = {
  -- The steel tier is vanilla's own heat exchanger, which this mod adopts as
  -- tier 1 -- it carries the steel tint, the steel pipeline extent, and
  -- next_upgrade into mk2 -- so it gets the same passthrough as the rest.
  ["heat-exchanger"] = true,
  ["aer_heat-exchanger-2"] = true,
  ["aer_heat-exchanger-3"] = true,
  ["aer_heat-exchanger-4"] = true,
}

-- prototype name -> {min_working, target}, resolved once per prototype rather
-- than per entity per tick.
local limits = {}

-- unit_number -> the pipe carrying this exchanger's output segment.
--
-- A machine's own fluidbox is never part of a fluid segment -- segments are a
-- pipe-network construct -- so the rewrite has to go through the pipe the
-- exchanger feeds. Derived state only, so it is a plain local rather than
-- storage, and is rebuilt naturally after a load.
local output_pipes = {}

local function limits_for(entity)
  local name = entity.name
  local cached = limits[name]
  if cached then return cached end

  local prototype = entity.prototype
  local buffer = prototype.heat_buffer_prototype
  if not buffer or not prototype.target_temperature then return nil end

  cached = {
    min_working = buffer.min_working_temperature or 0,
    target = prototype.target_temperature,
  }
  limits[name] = cached
  return cached
end

local function track(entity)
  if entity and entity.valid and TRACKED[entity.name] then
    storage.exchangers[entity.unit_number] = entity
  end
end

local function forget(entity)
  if entity and entity.unit_number then
    storage.exchangers[entity.unit_number] = nil
    -- The pipe cache is keyed by unit_number, and unit numbers are never
    -- reused. Left behind, an entry for a mined exchanger is never visited
    -- again -- the scan below only reaches keys still in the registry -- so it
    -- would hold a dead reference for the rest of the session.
    output_pipes[entity.unit_number] = nil
  end
end

-- Rebuild the registry from scratch. Used on init and on configuration change,
-- so an existing save picks up exchangers built before this mod version.
local function rescan()
  storage.exchangers = {}

  -- Only ask for prototypes this load actually has. The mk4 exchanger is Space
  -- Age only, and find_entities_filtered errors on an unknown name rather than
  -- ignoring it.
  local names = {}
  for name in pairs(TRACKED) do
    if prototypes.entity[name] then names[#names + 1] = name end
  end
  if #names == 0 then return end

  for _, surface in pairs(game.surfaces) do
    for _, entity in pairs(surface.find_entities_filtered{name = names}) do
      track(entity)
    end
  end
end

script.on_init(function()
  storage.exchangers = {}
  rescan()
end)

script.on_configuration_changed(rescan)

local build_events = {
  defines.events.on_built_entity,
  defines.events.on_robot_built_entity,
  defines.events.on_space_platform_built_entity,
  defines.events.script_raised_built,
  defines.events.script_raised_revive,
}
for _, event in pairs(build_events) do
  if event then
    script.on_event(event, function(data) track(data.entity) end)
  end
end

local remove_events = {
  defines.events.on_player_mined_entity,
  defines.events.on_robot_mined_entity,
  defines.events.on_space_platform_mined_entity,
  defines.events.on_entity_died,
  defines.events.script_raised_destroy,
}
for _, event in pairs(remove_events) do
  if event then
    script.on_event(event, function(data) forget(data.entity) end)
  end
end

local function output_pipe_for(entity)
  local cached = output_pipes[entity.unit_number]
  if cached and cached.valid and cached.has_fluid_segment(PIPE_BOX) then
    return cached
  end

  local neighbours = entity.fluidbox_neighbours
  local connected = neighbours and neighbours[OUTPUT_BOX]
  for _, candidate in pairs(connected or {}) do
    if candidate.valid and candidate.has_fluid_segment(PIPE_BOX) then
      output_pipes[entity.unit_number] = candidate
      return candidate
    end
  end

  output_pipes[entity.unit_number] = nil
  return nil
end

script.on_event(defines.events.on_tick, function()
  local exchangers = storage.exchangers
  if not exchangers or not next(exchangers) then return end

  -- Collect the temperature each segment should carry. Several exchangers can
  -- feed one segment, so average their intents -- that is what the engine's own
  -- volume blending would have produced anyway.
  local wanted, counts, representative = {}, {}, {}

  for unit_number, entity in pairs(exchangers) do
    if not entity.valid then
      exchangers[unit_number] = nil
      output_pipes[unit_number] = nil
    else
      local bounds = limits_for(entity)
      local buffer = bounds and entity.temperature
      -- Only exchangers that are actually producing get a say in the steam
      -- temperature. One below its working threshold -- no heat connection, or
      -- a network that has gone cold -- makes no steam at all, so averaging its
      -- intent in would drag the segment down on behalf of an exchanger
      -- contributing nothing to it.
      if buffer and buffer >= bounds.min_working then
        local pipe = output_pipe_for(entity)
        if pipe then
          local desired = buffer
          if desired > bounds.target then desired = bounds.target end

          local segment = pipe.get_fluid_segment_id(PIPE_BOX)
          wanted[segment] = (wanted[segment] or 0) + desired
          counts[segment] = (counts[segment] or 0) + 1
          representative[segment] = pipe
        end
      end
    end
  end

  for segment, total in pairs(wanted) do
    local pipe = representative[segment]
    if pipe.valid then
      local fluid = pipe.get_fluid_segment_fluid(PIPE_BOX)
      if fluid and fluid.amount > 0 then
        pipe.set_fluid_segment_fluid(PIPE_BOX, {
          name = fluid.name,
          amount = fluid.amount,
          temperature = total / counts[segment],
        })
      end
    end
  end
end)

-- Reactor heat output panel -------------------------------------------------
--
-- A reactor's real output is consumption * (1 + neighbour_bonus), and nothing
-- in game reports it. The prototype's own figure is the standalone one, which
-- is wrong for any real build: a reactor in a 2x2 block produces three times it.
--
-- localised_description cannot help here -- it is fixed at data stage and
-- read-only at runtime -- so the live figure needs a GUI. This one is attached
-- to the reactor's own window, which means it costs nothing until a player
-- opens a reactor, and nothing again once they close it.
--
-- LuaEntity.neighbour_bonus is the engine's own maintained value rather than
-- something recomputed here; the reactor already needs it every tick to produce
-- heat. See issue #10.

local REACTOR_PANEL = "aer_reactor_output"
local PANEL_REFRESH_TICKS = 30

local REACTORS = {
  ["nuclear-reactor"] = true,
  ["aer_nuclear-reactor-2"] = true,
  ["aer_nuclear-reactor-3"] = true,
  ["aer_nuclear-reactor-4"] = true,
}

local function megawatts(watts)
  return string.format("%.1f MW", watts / 1000000)
end

local function panel_rows(entity)
  local prototype = entity.prototype
  -- get_max_energy_usage is per tick; the tooltip figure is per second.
  local base = prototype.get_max_energy_usage() * 60
  local bonus = entity.neighbour_bonus or 0
  return {
    {"aer-reactor-gui.base", megawatts(base)},
    {"aer-reactor-gui.neighbours", string.format("%d", bonus)},
    {"aer-reactor-gui.bonus", string.format("+%d%%", bonus * 100)},
    {"aer-reactor-gui.current", megawatts(base * (1 + bonus))},
    {"aer-reactor-gui.temperature", string.format("%.0f °C", entity.temperature or 0)},
  }
end

local function refresh_panel(player)
  local frame = player.gui.relative[REACTOR_PANEL]
  local entity = player.opened
  if not frame then return false end
  if not (entity and entity.valid and entity.object_name == "LuaEntity"
          and REACTORS[entity.name]) then
    frame.destroy()
    return false
  end

  local table_element = frame.aer_reactor_table
  table_element.clear()
  for _, row in ipairs(panel_rows(entity)) do
    table_element.add{type = "label", caption = {row[1]}}
    local value = table_element.add{type = "label", caption = row[2]}
    value.style.font = "default-bold"
  end
  return true
end

local function open_panel(player, entity)
  local existing = player.gui.relative[REACTOR_PANEL]
  if existing then existing.destroy() end

  local frame = player.gui.relative.add{
    type = "frame",
    name = REACTOR_PANEL,
    caption = {"aer-reactor-gui.title"},
    direction = "vertical",
    anchor = {
      gui = defines.relative_gui_type.reactor_gui,
      position = defines.relative_gui_position.right,
    },
  }
  frame.add{type = "table", name = "aer_reactor_table", column_count = 2}
  refresh_panel(player)
end

script.on_event(defines.events.on_gui_opened, function(event)
  local entity = event.entity
  if not (entity and entity.valid and REACTORS[entity.name]) then return end
  local player = game.get_player(event.player_index)
  if player then open_panel(player, entity) end
end)

script.on_event(defines.events.on_gui_closed, function(event)
  local player = game.get_player(event.player_index)
  local frame = player and player.gui.relative[REACTOR_PANEL]
  if frame then frame.destroy() end
end)

-- Only runs while a panel is actually open. Neighbour bonus changes rarely, but
-- core temperature moves constantly, so a stale panel would be misleading.
script.on_nth_tick(PANEL_REFRESH_TICKS, function()
  for _, player in pairs(game.connected_players) do
    if player.gui.relative[REACTOR_PANEL] then
      refresh_panel(player)
    end
  end
end)
