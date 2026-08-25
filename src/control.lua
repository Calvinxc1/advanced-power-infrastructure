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
-- The rewrite goes through set_fluid_segment_fluid, which sets the temperature
-- of a whole connected pipe network in one call. That is the only lever the API
-- offers: there is no way to address just the steam one machine made. So every
-- steam source feeding a rewritten segment has to be accounted for, or the
-- rewrite would hand an exchanger's temperature to steam it never produced.
--
-- See issue #11 for the measurements behind all of this.

-- Mixed steam sources -------------------------------------------------------
--
-- This mod ships eight steam sources between 165 and 1000 degrees, and nothing
-- stops a player plumbing a fuel boiler into the same header as a heat
-- exchanger. Since the rewrite necessarily covers a whole segment, a vanilla
-- boiler's 165 degree steam sharing a header with mk2 exchangers would come out
-- rewritten to 650 -- energy from nothing, at better than four times the value
-- of the coal that made it.
--
-- So every steam source votes, weighted by how much steam it actually makes.
-- Weighting by volume is not a nicety. A unit of steam is worth
-- heat_capacity * (temperature - 15), so a volume-weighted mean temperature is
-- exactly what conserves total energy, and it is the same answer the engine's
-- own blending would reach. That is what makes the rewrite honest rather than
-- generous: it changes which temperature the steam carries, never how much
-- energy the segment holds for a given production mix.
--
-- Rate has to be derived, since no prototype field reports steam output:
--
--     energy per tick * effectivity / (heat capacity * degrees above ambient)
--
-- which reproduces the known figures exactly -- 60/s for a vanilla boiler,
-- 103.09/s for a vanilla heat exchanger.
--
-- Only heat exchangers drive a rewrite. A segment fed by fuel boilers alone is
-- left entirely alone, because their steam already leaves at the temperature it
-- should, and the engine is a more accurate authority on it than this is.
--
-- One gap, accepted knowingly. Space Age's acid-neutralisation recipe makes 500
-- degree steam in a chemical plant, which no prototype field identifies as a
-- steam source: the plant's output box carries no filter and its recipe can
-- change at any moment. Watching every chemical plant to catch it would cost
-- more than the case is worth -- it lands on 500 exactly, which is identical to
-- tier 1 and so a no-op there, and it lives on Fulgora, which has no water to
-- run a reactor with.

-- Fluid storage 2 is a boiler's output box; a pipe has a single box at 1.
local OUTPUT_BOX = 2
local PIPE_BOX = 1

-- script.on_nth_tick keeps one handler per interval: registering a second for
-- the same interval replaces the first rather than adding to it. This file has
-- two periodic jobs -- the steam rewrite and the reactor panel refresh -- whose
-- intervals are independent constants, so nothing stops them landing on the
-- same number. When they do, the later registration silently deletes the
-- earlier one.
--
-- That is not hypothetical. Setting the rewrite to 30 to match the panel's 30
-- removed the rewrite entirely: no error, no crash, just steam that stopped
-- tapering. Registering through here instead makes the intervals free to be
-- anything, including equal.
local nth_tick_handlers = {}

local function every_nth_tick(interval, handler)
  local existing = nth_tick_handlers[interval]
  local combined = handler
  if existing then
    combined = function(event)
      existing(event)
      handler(event)
    end
  end
  nth_tick_handlers[interval] = combined
  script.on_nth_tick(interval, combined)
end

-- This file keeps two registries -- steam sources and reactors -- and both need
-- rebuilding on the same events. Collecting hooks here lets each half register
-- next to the code it belongs to, instead of one list at the top that has to
-- know about everything below it.
local rescan_hooks, built_hooks, removed_hooks = {}, {}, {}

local function on_rescan(hook) rescan_hooks[#rescan_hooks + 1] = hook end
local function on_built(hook) built_hooks[#built_hooks + 1] = hook end
local function on_removed(hook) removed_hooks[#removed_hooks + 1] = hook end

local function run_hooks(hooks, entity)
  for _, hook in ipairs(hooks) do hook(entity) end
end

script.on_init(function() run_hooks(rescan_hooks) end)
script.on_configuration_changed(function() run_hooks(rescan_hooks) end)

local build_events = {
  defines.events.on_built_entity,
  defines.events.on_robot_built_entity,
  defines.events.on_space_platform_built_entity,
  defines.events.script_raised_built,
  defines.events.script_raised_revive,
}
for _, event in pairs(build_events) do
  if event then
    script.on_event(event, function(data) run_hooks(built_hooks, data.entity) end)
  end
end

-- Cloning names its new entity destination rather than entity, so it cannot
-- join the loop above. Surface cloning is an editor and scripted-mod path
-- rather than a player one, but a clone that never reaches a registry is
-- invisible until the next configuration change.
if defines.events.on_entity_cloned then
  script.on_event(defines.events.on_entity_cloned, function(data)
    run_hooks(built_hooks, data.destination)
  end)
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
    script.on_event(event, function(data) run_hooks(removed_hooks, data.entity) end)
  end
end

local PRODUCERS = {
  -- follows-heat: output temperature tracks the heat network, so these drive
  -- the rewrite. The steel tier is vanilla's own heat exchanger, which this mod
  -- adopts as tier 1 -- it carries the steel tint, the steel pipeline extent,
  -- and next_upgrade into mk2 -- so it gets the same passthrough as the rest.
  ["heat-exchanger"] = "follows-heat",
  ["aer_heat-exchanger-2"] = "follows-heat",
  ["aer_heat-exchanger-3"] = "follows-heat",
  ["aer_heat-exchanger-4"] = "follows-heat",

  -- fixed: output temperature is whatever the prototype says, always. These
  -- never trigger a rewrite; they only claim their share of a segment they
  -- happen to share with an exchanger.
  ["boiler"] = "fixed",
  ["aer_steel-boiler"] = "fixed",
  ["aer_rubber-lined-boiler"] = "fixed",
  ["aer_holmium-reinforced-boiler"] = "fixed",
}

-- prototype name -> {follows_heat, min_working, target, rate}, resolved once per
-- prototype rather than per entity per pass. false marks a prototype that
-- cannot be resolved, so the work is not repeated for it either.
local specs = {}

-- unit_number -> the pipe carrying this source's output segment.
--
-- A machine's own fluidbox is never part of a fluid segment -- segments are a
-- pipe-network construct -- so the rewrite has to go through the pipe the
-- machine feeds. Derived state only, so it is a plain local rather than
-- storage, and is rebuilt naturally after a load.
local output_pipes = {}

local function spec_for(entity)
  local name = entity.name
  local cached = specs[name]
  if cached ~= nil then return cached or nil end

  local prototype = entity.prototype
  local steam = prototypes.fluid["steam"]
  local target = prototype.target_temperature
  local degrees = target and steam and (target - steam.default_temperature)
  if not degrees or degrees <= 0 then
    specs[name] = false
    return nil
  end

  -- A burner's effectivity multiplies fuel energy on its way into the steam.
  -- The holmium boiler runs at 1.3, so ignoring it would understate that
  -- boiler's share of a shared header by nearly a third.
  local burner = prototype.burner_prototype
  local buffer = prototype.heat_buffer_prototype

  cached = {
    follows_heat = PRODUCERS[name] == "follows-heat",
    min_working = buffer and buffer.min_working_temperature or 0,
    target = target,
    -- Units of steam per tick. Only the ratio between sources on one segment is
    -- ever used, so the tick basis never needs converting to seconds.
    rate = prototype.get_max_energy_usage() * ((burner and burner.effectivity) or 1)
      / (steam.heat_capacity * degrees),
  }
  specs[name] = cached
  return cached
end

-- The two statuses that mean a machine has steam to speak for: it is making
-- some, or it made some and the pipe it fills has backed up. Everything else --
-- out of fuel, out of water, heat network gone cold -- has no claim on the
-- segment at all.
--
-- Measured rather than assumed, because heat is only half of what an exchanger
-- needs and buffer temperature alone cannot see the other half. A hot exchanger
-- with no water reports no_input_fluid and makes nothing; letting it vote on
-- buffer temperature alone would hand its full production weight to steam it is
-- not producing, and against a fuel boiler that genuinely is, that promotes the
-- boiler's cold steam -- the same bug this branch already fixed once, coming
-- back through a different door. See the exchanger_producing experiment.
local PRODUCING = {
  [defines.entity_status.working] = true,
  [defines.entity_status.full_output] = true,
}

-- The temperature this source is putting into its pipe right now, or nil when
-- it has no claim on the segment.
local function producing_temperature(entity, spec)
  if not PRODUCING[entity.status] then return nil end

  -- A fuel boiler's steam always leaves at its target.
  if not spec.follows_heat then return spec.target end

  -- An exchanger's steam follows its heat network, clamped so it never emits steam
  -- hotter than optimal. The min_working floor is redundant against the status
  -- check -- a cold exchanger reports low_temperature -- and is kept as a guard
  -- on a backed-up exchanger whose network then goes cold, a combination the
  -- status measurements did not cover.
  local buffer = entity.temperature
  if not buffer or buffer < spec.min_working then return nil end
  if buffer > spec.target then return spec.target end
  return buffer
end

local function track(entity)
  if entity and entity.valid and PRODUCERS[entity.name] then
    storage.producers[entity.unit_number] = entity
  end
end

local function forget(entity)
  if entity and entity.unit_number then
    storage.producers[entity.unit_number] = nil
    -- The pipe cache is keyed by unit_number, and unit numbers are never
    -- reused. Left behind, an entry for a mined machine is never visited
    -- again -- the pass below only reaches keys still in the registry -- so it
    -- would hold a dead reference for the rest of the session.
    output_pipes[entity.unit_number] = nil
  end
end

-- Rebuild the registry from scratch. Used on init and on configuration change,
-- so an existing save picks up machines built before this mod version.
local function rescan()
  storage.producers = {}
  -- Superseded by storage.producers, which covers fuel boilers as well. Only
  -- ever present in a save from a development build of this branch.
  storage.exchangers = nil

  -- Only ask for prototypes this load actually has. The mk4 exchanger and the
  -- holmium boiler are Space Age only, and find_entities_filtered errors on an
  -- unknown name rather than ignoring it.
  local names = {}
  for name in pairs(PRODUCERS) do
    if prototypes.entity[name] then names[#names + 1] = name end
  end
  if #names == 0 then return end

  for _, surface in pairs(game.surfaces) do
    for _, entity in pairs(surface.find_entities_filtered{name = names}) do
      track(entity)
    end
  end
end

on_rescan(rescan)
on_built(track)
on_removed(forget)

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

-- The write is per segment, but deciding what to write costs a handful of
-- engine calls per steam source, every one of which is paid whether or not
-- anything moved. A reactor's core temperature changes by fractions of a degree
-- per tick, so a rewrite at 60 Hz spends that work re-asserting a number that
-- has barely moved.
--
-- The interval is not only a smoothness knob. Between two rewrites the engine
-- keeps making steam at its own pinned target, so a fraction of every segment
-- is untapered at any moment, and that fraction grows with the interval.
-- Measured on a mixed rig whose correction should land on 394.2 (see the
-- mixed_steam_blend experiment):
--
--     interval   segment mean   sawtooth   taper applied
--        6            395.8        4.9         98.4%
--       20            399.1       17.0         95.2%
--       30            401.4       25.6         93.0%
--       60            408.0       51.5         86.5%
--
-- The error always favours the player: steam is hotter than intended, never
-- colder. 30 ticks keeps 93% of the taper for a thirtieth of what every tick
-- cost, which is the point on that curve where both sides are still cheap --
-- half the sawtooth of 60 ticks for twice a cost that is already small.
--
-- Note that this equals PANEL_REFRESH_TICKS, which is safe only because both
-- jobs register through every_nth_tick. Registering either directly with
-- script.on_nth_tick would delete the other.
local PASSTHROUGH_INTERVAL_TICKS = 30

every_nth_tick(PASSTHROUGH_INTERVAL_TICKS, function()
  local producers = storage.producers
  if not producers or not next(producers) then return end

  -- Collect what each segment should carry: the volume-weighted mean of the
  -- temperatures its running sources are feeding into it.
  local weighted, weight, driven, representative = {}, {}, {}, {}

  for unit_number, entity in pairs(producers) do
    if not entity.valid then
      producers[unit_number] = nil
      output_pipes[unit_number] = nil
    else
      local spec = spec_for(entity)
      local temperature = spec and producing_temperature(entity, spec)
      if temperature then
        local pipe = output_pipe_for(entity)
        if pipe then
          local segment = pipe.get_fluid_segment_id(PIPE_BOX)
          weighted[segment] = (weighted[segment] or 0) + temperature * spec.rate
          weight[segment] = (weight[segment] or 0) + spec.rate
          -- A segment with no exchanger on it is already carrying the right
          -- temperature and is left alone entirely.
          if spec.follows_heat then driven[segment] = true end
          representative[segment] = pipe
        end
      end
    end
  end

  for segment, total in pairs(weighted) do
    local pipe = driven[segment] and representative[segment]
    if pipe and pipe.valid then
      local fluid = pipe.get_fluid_segment_fluid(PIPE_BOX)
      if fluid and fluid.amount > 0 then
        pipe.set_fluid_segment_fluid(PIPE_BOX, {
          name = fluid.name,
          amount = fluid.amount,
          temperature = total / weight[segment],
        })
      end
    end
  end
end)

-- Reactor neighbour bonus ---------------------------------------------------
--
-- Vanilla pays a reactor's neighbour bonus once per adjacent reactor, and pays
-- it in full or not at all: a single tile of offset between two reactors takes
-- the entire bonus away. Here it is paid per heat connection instead. A reactor
-- has three connections a side, each worth a third, so two flush reactors line
-- up all three and are worth the same 100% vanilla pays -- every exchanger,
-- turbine and reach figure derived from a flush 2x2 block is untouched -- while
-- sliding one along the shared edge costs a third at a time.
--
-- Measured before any of this was written, because none of it is documented:
--
--   * The engine pays once per neighbouring reactor, however many connection
--     points pair up. Three connections a side, at a third each, still read
--     0.333 for a flush pair rather than 1.0. Giving each point its own
--     category does not split it either -- the dedupe is per entity.
--   * LuaEntity.neighbour_bonus is read only, so the number cannot simply be
--     computed here and handed back to the engine.
--
-- What is left is to switch the engine's bonus off in the prototypes and add
-- the heat here. That is the same mechanism the engine uses -- a reactor's
-- bonus is extra heat in its buffer -- and two measurements make it safe:
-- writing above max_temperature is clamped by the engine rather than erroring,
-- and an unfuelled reactor still accepts a temperature write, which is why the
-- status gate below is mandatory rather than defensive.
--
-- Connections must line up exactly. Since they sit two tiles apart, an offset
-- of one tile lines up none of them and pays nothing, while an offset of two
-- pays two thirds. Chosen deliberately over a rule based on how much the
-- reactors overlap; the alignment is the thing being modelled.

local REACTORS = {
  ["nuclear-reactor"] = true,
  ["aer_nuclear-reactor-2"] = true,
  ["aer_nuclear-reactor-3"] = true,
  ["aer_nuclear-reactor-4"] = true,
}

local CONNECTION_BONUS = 1 / 3

-- Two reactors are neighbours when their footprints are flush along one axis
-- and overlap on the other. Sizes come from the prototype rather than a
-- constant so a tier that changed shape would still be measured correctly.
local reactor_specs = {}

local function reactor_spec(entity)
  local name = entity.name
  local cached = reactor_specs[name]
  if cached ~= nil then return cached or nil end

  local prototype = entity.prototype
  local buffer = prototype.heat_buffer_prototype
  if not buffer or not buffer.connections then
    reactor_specs[name] = false
    return nil
  end

  -- Group the heat connections by the side they sit on, keeping the offset
  -- along that side. North and south run along x, east and west along y.
  local sides = {}
  for _, connection in pairs(buffer.connections) do
    local direction, position = connection.direction, connection.position
    -- A MapPosition read back from a prototype may arrive named or indexed, so
    -- accept both rather than depending on which.
    local x = position and (position.x or position[1])
    local y = position and (position.y or position[2])
    if direction and x and y then
      local along = (direction == defines.direction.north
                     or direction == defines.direction.south) and x or y
      sides[direction] = sides[direction] or {}
      sides[direction][along] = true
    end
  end

  cached = {
    width = prototype.tile_width,
    height = prototype.tile_height,
    sides = sides,
    specific_heat = buffer.specific_heat,
    energy_per_tick = prototype.get_max_energy_usage(),
  }
  reactor_specs[name] = cached
  return cached
end

-- How many of this reactor's connections on `side` meet one of the other's on
-- the facing side, given how far the two are offset along that edge.
local function aligned_connections(spec, other_spec, side, facing, offset)
  local mine = spec.sides[side]
  local theirs = other_spec.sides[facing]
  if not (mine and theirs) then return 0 end

  local count = 0
  for along in pairs(mine) do
    if theirs[along - offset] then count = count + 1 end
  end
  return count
end

local function connections_between(entity, other)
  local spec, other_spec = reactor_spec(entity), reactor_spec(other)
  if not (spec and other_spec) then return 0 end

  local dx = other.position.x - entity.position.x
  local dy = other.position.y - entity.position.y
  local flush_x = (spec.width + other_spec.width) / 2
  local flush_y = (spec.height + other_spec.height) / 2

  -- Flush along x: touching side to side, offset vertically.
  if math.abs(dx) == flush_x and math.abs(dy) < flush_y then
    local side = dx > 0 and defines.direction.east or defines.direction.west
    local facing = dx > 0 and defines.direction.west or defines.direction.east
    return aligned_connections(spec, other_spec, side, facing, dy)
  end

  -- Flush along y: stacked, offset horizontally.
  if math.abs(dy) == flush_y and math.abs(dx) < flush_x then
    local side = dy > 0 and defines.direction.south or defines.direction.north
    local facing = dy > 0 and defines.direction.north or defines.direction.south
    return aligned_connections(spec, other_spec, side, facing, dx)
  end

  return 0
end

local function bonus_for(entity)
  local spec = reactor_spec(entity)
  if not spec then return 0, 0, 0 end

  -- A neighbour can be no further than one full reactor away on either axis.
  local reach = math.max(spec.width, spec.height) + 1
  local position = entity.position
  local candidates = entity.surface.find_entities_filtered{
    type = "reactor",
    area = {
      {position.x - reach, position.y - reach},
      {position.x + reach, position.y + reach},
    },
  }

  local connections, neighbours = 0, 0
  for _, other in pairs(candidates) do
    if other.valid and other ~= entity and REACTORS[other.name] then
      local aligned = connections_between(entity, other)
      if aligned > 0 then
        connections = connections + aligned
        neighbours = neighbours + 1
      end
    end
  end

  return connections * CONNECTION_BONUS, connections, neighbours
end

-- Bonuses only change when a reactor is built or removed, so they are computed
-- then rather than on every pass. Building one changes its neighbours' bonuses
-- as well as its own, hence the sweep over everything in range.
local function refresh_bonus(entity)
  if not (entity and entity.valid and REACTORS[entity.name]) then return end
  local record = storage.reactors[entity.unit_number]
  if not record then
    record = {entity = entity}
    storage.reactors[entity.unit_number] = record
  end
  record.bonus, record.connections, record.neighbours = bonus_for(entity)
end

local function refresh_bonuses_near(entity)
  if not (entity and entity.valid) then return end
  local spec = reactor_spec(entity)
  local reach = ((spec and math.max(spec.width, spec.height)) or 5) + 1
  local position = entity.position
  for _, other in pairs(entity.surface.find_entities_filtered{
    type = "reactor",
    area = {
      {position.x - reach, position.y - reach},
      {position.x + reach, position.y + reach},
    },
  }) do
    refresh_bonus(other)
  end
end

local function track_reactor(entity)
  if entity and entity.valid and REACTORS[entity.name] then
    refresh_bonus(entity)
    refresh_bonuses_near(entity)
  end
end

local function forget_reactor(entity)
  if not (entity and entity.unit_number) then return end
  if storage.reactors then storage.reactors[entity.unit_number] = nil end
  -- The neighbours it was propping up have to be told before it is gone.
  refresh_bonuses_near(entity)
end

local function rescan_reactors()
  storage.reactors = {}
  local names = {}
  for name in pairs(REACTORS) do
    if prototypes.entity[name] then names[#names + 1] = name end
  end
  if #names == 0 then return end

  for _, surface in pairs(game.surfaces) do
    for _, entity in pairs(surface.find_entities_filtered{name = names}) do
      refresh_bonus(entity)
    end
  end
end

-- Paying the bonus. The engine gives a reactor `energy_per_tick` of heat while
-- it is burning fuel; this adds the same share again for every aligned
-- connection, as a temperature rise over the buffer's own specific heat.
--
-- Gated on working: an unfuelled reactor accepts a temperature write just as
-- readily as a running one, and paying a bonus to a reactor that is not
-- consuming fuel would be heat from nothing. A reactor already at its ceiling
-- reports working too, but the engine clamps the write, so the overflow is
-- discarded exactly as the engine discards its own.
on_rescan(rescan_reactors)
on_built(track_reactor)
on_removed(forget_reactor)

local BONUS_INTERVAL_TICKS = 30

every_nth_tick(BONUS_INTERVAL_TICKS, function()
  local reactors = storage.reactors
  if not reactors or not next(reactors) then return end

  for unit_number, record in pairs(reactors) do
    local entity = record.entity
    if not (entity and entity.valid) then
      reactors[unit_number] = nil
    elseif (record.bonus or 0) > 0
        and entity.status == defines.entity_status.working then
      local spec = reactor_spec(entity)
      if spec and spec.specific_heat > 0 then
        local energy = spec.energy_per_tick * record.bonus * BONUS_INTERVAL_TICKS
        entity.temperature = entity.temperature + energy / spec.specific_heat
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

-- REACTORS above serves both halves. Two copies would let a future tier reach
-- one and not the other, and the failure is quiet either way: a panel that
-- opens for a reactor the bonus never pays, or a reactor paid a bonus it cannot
-- show.

local function megawatts(watts)
  return string.format("%.1f MW", watts / 1000000)
end

-- Everything the panel reports about one reactor, as numbers.
--
-- Split out from the rows it renders so the figures can be read without a GUI.
-- The panel cannot be tested headless -- GUI events need a player and there is
-- no API to create one -- so the numbers are reachable through the remote
-- interface below and measured there instead. What stays untested is the widget
-- construction, not the arithmetic.
--
-- The bonus comes from this mod's own record rather than
-- LuaEntity.neighbour_bonus, which is now zero on every tier: the engine pays
-- nothing and control.lua pays everything. Falls back to computing it when a
-- reactor somehow is not in the registry, so the panel can never quietly report
-- a reactor as solo.
local function reactor_output(entity)
  local prototype = entity.prototype
  -- get_max_energy_usage is per tick; the reported figure is per second.
  local base = prototype.get_max_energy_usage() * 60

  local record = storage.reactors and storage.reactors[entity.unit_number]
  local bonus, connections, neighbours
  if record and record.bonus then
    bonus, connections, neighbours = record.bonus, record.connections, record.neighbours
  else
    bonus, connections, neighbours = bonus_for(entity)
  end
  bonus = bonus or 0

  return {
    base_output = base,
    neighbours = neighbours or 0,
    connections = connections or 0,
    bonus = bonus,
    current_output = base * (1 + bonus),
    temperature = entity.temperature or 0,
  }
end

-- Read-only, and the same values the panel renders rather than a second
-- calculation that could drift from it. The harness measures through this; any
-- other mod wanting a reactor's real output can too.
remote.add_interface("advanced-power-infrastructure", {
  reactor_output = function(unit_number)
    local record = storage.reactors and storage.reactors[unit_number]
    local entity = record and record.entity
    if not (entity and entity.valid) then return nil end
    return reactor_output(entity)
  end,
})

local function panel_rows(entity)
  local output = reactor_output(entity)
  return {
    {"aer-reactor-gui.base", megawatts(output.base_output)},
    {"aer-reactor-gui.neighbours", string.format("%d", output.neighbours)},
    {"aer-reactor-gui.connections", string.format("%d", output.connections)},
    {"aer-reactor-gui.bonus", string.format("+%d%%", math.floor(output.bonus * 100 + 0.5))},
    {"aer-reactor-gui.current", megawatts(output.current_output)},
    {"aer-reactor-gui.temperature", string.format("%.0f °C", output.temperature)},
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
every_nth_tick(PANEL_REFRESH_TICKS, function()
  for _, player in pairs(game.connected_players) do
    if player.gui.relative[REACTOR_PANEL] then
      refresh_panel(player)
    end
  end
end)
