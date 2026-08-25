local constants = require("prototypes.power.fluid-constants")
local optional_dependencies = require("prototypes.power.optional-dependencies")

local helpers = {}

local function apply_icon_tint(prototype, tint)
  if prototype and prototype.icon then
    prototype.icons = {
      { icon = prototype.icon, icon_size = prototype.icon_size or 64 },
      { icon = prototype.icon, icon_size = prototype.icon_size or 64, tint = tint },
    }
    prototype.icon = nil
    prototype.icon_size = nil
  end
end

function helpers.apply_rubber_lined_icon_tint(prototype)
  apply_icon_tint(prototype, constants.rubber_lined.icon_tint)
end

function helpers.apply_reinforced_icon_tint(prototype)
  apply_icon_tint(prototype, constants.reinforced.icon_tint)
end

function helpers.apply_foundation_icon_tint(prototype)
  apply_icon_tint(prototype, constants.foundation.icon_tint)
end

local function tint_sprite(sprite, tint)
  if not sprite or sprite.draw_as_shadow then
    return
  end
  if sprite.layers then
    for _, layer in pairs(sprite.layers) do
      tint_sprite(layer, tint)
    end
  elseif sprite.filename or sprite.filenames or sprite.stripes then
    sprite.tint = tint
  end
end

local function tint_sprite_table(sprite_table, tint)
  if not sprite_table then
    return
  end
  tint_sprite(sprite_table, tint)
  for _, value in pairs(sprite_table) do
    if type(value) == "table" then
      tint_sprite_table(value, tint)
    end
  end
end

local function apply_entity_tint(prototype, tint)
  if not prototype then
    return
  end
  tint_sprite_table(prototype.pictures, tint)
  tint_sprite_table(prototype.picture, tint)
  tint_sprite_table(prototype.graphics_set, tint)
  tint_sprite_table(prototype.animations, tint)
  tint_sprite_table(prototype.horizontal_animation, tint)
  tint_sprite_table(prototype.vertical_animation, tint)

  -- A heat pipe carries none of the sprite fields above: its graphics live in
  -- connection_sprites, one entry per junction shape. Without this the tint is
  -- a silent no-op and every tier renders identically once placed, which
  -- matters because a single low-tier pipe throttles a whole run and there is
  -- no other way to spot it.
  --
  -- heat_glow_sprites is deliberately left alone. That layer is the temperature
  -- readout, and tinting it would corrupt the one cue that already works.
  tint_sprite_table(prototype.connection_sprites, tint)
end

function helpers.apply_rubber_lined_entity_tint(prototype)
  apply_entity_tint(prototype, constants.rubber_lined.entity_tint)
end

function helpers.apply_reinforced_entity_tint(prototype)
  apply_entity_tint(prototype, constants.reinforced.entity_tint)
end

function helpers.apply_foundation_entity_tint(prototype)
  apply_entity_tint(prototype, constants.foundation.entity_tint)
end

-- Heat pipe variants of the above, using the stronger dedicated tints. See
-- fluid-constants.heat_pipe_entity_tint for why they differ.
function helpers.apply_rubber_lined_heat_pipe_tint(prototype)
  apply_entity_tint(prototype, constants.heat_pipe_entity_tint.rubber_lined)
end

function helpers.apply_reinforced_heat_pipe_tint(prototype)
  apply_entity_tint(prototype, constants.heat_pipe_entity_tint.reinforced)
end

function helpers.apply_foundation_heat_pipe_tint(prototype)
  apply_entity_tint(prototype, constants.heat_pipe_entity_tint.foundation)
end

function helpers.set_fluid_box_extent(fluid_box, extent)
  if optional_dependencies.has_advanced_fluid_infrastructure and fluid_box then
    fluid_box.max_pipeline_extent = extent
  end
end

local function set_fluid_boxes_extent(fluid_boxes, extent)
  if not fluid_boxes then
    return
  end
  for _, fluid_box in pairs(fluid_boxes) do
    helpers.set_fluid_box_extent(fluid_box, extent)
  end
end

function helpers.set_prototype_fluid_boxes_extent(prototype, extent)
  if not prototype then
    return
  end
  helpers.set_fluid_box_extent(prototype.fluid_box, extent)
  helpers.set_fluid_box_extent(prototype.input_fluid_box, extent)
  helpers.set_fluid_box_extent(prototype.output_fluid_box, extent)
  set_fluid_boxes_extent(prototype.fluid_boxes, extent)
end

function helpers.set_description(prototype, description)
  if prototype and description then
    prototype.localised_description = description
  end
end

function helpers.set_resistances(prototype, resistances)
  if not prototype or not resistances then
    return
  end

  local filtered = {}
  for _, resistance in ipairs(resistances) do
    if data.raw["damage-type"][resistance.type] then
      table.insert(filtered, util.table.deepcopy(resistance))
    end
  end

  prototype.resistances = filtered
end

function helpers.boiler_description(extent)
  if not optional_dependencies.has_advanced_fluid_infrastructure then
    return nil
  end

  return { "description.aer_boiler-fluid-stats", tostring(extent) }
end

-- The engine reports a reactor's own output, which is its standalone figure and
-- wrong for any real build -- a reactor in a flush 2x2 block produces three
-- times it. Only the connection rule is stated here; the live figure needs the
-- runtime panel in control.lua, since it depends on what is built beside it.
--
-- Read from the shared constant rather than from the prototype's own
-- neighbour_bonus, which is now zero: the engine pays nothing and control.lua
-- pays everything. See issue #10.
function helpers.reactor_connection_description(connection_bonus)
  if not connection_bonus or connection_bonus <= 0 then
    return nil
  end
  return {
    "description.aer_reactor-neighbour-note",
    string.format("%d", connection_bonus * 100),
  }
end

-- A heat pipe's three defining numbers, none of which the engine surfaces. The
-- per-tile loss is the one that decides layout, and the maximum matters because
-- a pipe is a node in the heat network: the lowest-tier pipe in a run caps the
-- whole run, with no error to say so.
function helpers.heat_pipe_description(heat_buffer)
  if not heat_buffer then
    return nil
  end
  return {
    "description.aer_heat-pipe-stats",
    string.format("%g", heat_buffer.max_temperature),
    tostring(heat_buffer.max_transfer),
    string.format("%.1f", heat_buffer.min_temperature_gradient),
  }
end

-- Joins description lines, skipping any that are absent. set_description
-- overwrites, and several of these lines are conditional -- the pipeline extent
-- only exists when Advanced Fluid Infrastructure is installed -- so anything
-- adding a line has to compose rather than assign.
function helpers.compose_description(...)
  local parts = {""}
  for index = 1, select("#", ...) do
    local part = select(index, ...)
    if part then
      if #parts > 1 then
        parts[#parts + 1] = "\n"
      end
      parts[#parts + 1] = part
    end
  end

  if #parts == 1 then
    return nil
  end
  return parts
end

-- Append a line to whatever a prototype already says, rather than replacing it.
-- set_description overwrites, and by the time these run a prototype may already
-- carry a pipeline extent line, a heat optimal line, or both.
function helpers.add_description_line(prototype, line)
  if not (prototype and line) then
    return
  end
  prototype.localised_description =
    helpers.compose_description(prototype.localised_description, line)
end

-- The number that decides whether a generator is earning its tier.
--
-- The engine labels this "Max. temperature", which is wrong in a way that costs
-- the player output: it is the temperature at which the generator reaches full
-- output, not a ceiling. Steam hotter than this is still accepted and still
-- consumed at the same rate -- scale_fluid_usage is false on every one of these
-- -- and the surplus heat is simply thrown away. A foundation turbine fed 500
-- degree steam runs at 49% and nothing in game says so.
--
-- The core label is left alone, decided under issue #12 rather than deferred.
-- [description] maximum-temperature is a single core key shared with heat
-- buffers, where "maximum" is the correct word -- a heat pipe really cannot
-- carry hotter -- so relabelling it to something accurate for generators would
-- make it wrong for heat pipes, including contradicting the heat pipe tooltips
-- this mod adds. Overriding it would also impose this mod's wording on every
-- other mod's generators.
--
-- So the misleading line stays and this one is added beneath it, which is why
-- this text explains what the number does rather than only stating it.
--
-- Still worth a look in game: if heat entities turn out not to render that key
-- at all, overriding it becomes safe and "optimal" becomes available.
function helpers.generator_optimal_description(temperature)
  if not temperature then
    return nil
  end
  return {"description.aer_generator-optimal-steam", tostring(temperature)}
end

-- The other half of the pairing: what a steam source actually produces, so the
-- tier a generator wants can be matched to the tier something makes.
function helpers.boiler_steam_description(temperature)
  if not temperature then
    return nil
  end
  return {"description.aer_boiler-steam-output", tostring(temperature)}
end

-- A heat exchanger is the exception. Its steam follows the heat network rather
-- than leaving at a fixed temperature, so stating a flat figure would be untrue
-- for most of the band it works across.
function helpers.exchanger_steam_description(temperature)
  if not temperature then
    return nil
  end
  return {"description.aer_exchanger-steam-output", tostring(temperature)}
end

-- The engine's "consumes heat" section reports min_working_temperature and the
-- buffer maximum, but never target_temperature -- which is the number that
-- decides whether the exchanger runs at full output. Surfaced here because
-- HeatEnergySource has no field for extending that section.
function helpers.heat_optimal_description(temperature)
  return {"description.aer_heat-optimal-temperature", tostring(temperature)}
end

function helpers.patch_boiler_extent(boiler_name, extent)
  local boiler = data.raw.boiler[boiler_name]
  if boiler then
    helpers.set_fluid_box_extent(boiler.fluid_box, extent)
    helpers.set_fluid_box_extent(boiler.output_fluid_box, extent)
    helpers.set_description(boiler, helpers.boiler_description(extent))
  end
end

return helpers
