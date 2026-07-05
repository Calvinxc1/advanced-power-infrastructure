local constants = require("prototypes.fluid.constants")

local helpers = {}

function helpers.apply_steel_icon_tint(prototype)
  if prototype and prototype.icon then
    prototype.icons = {
      { icon = prototype.icon, icon_size = prototype.icon_size or 64 },
      { icon = prototype.icon, icon_size = prototype.icon_size or 64, tint = constants.steel.icon_tint },
    }
    prototype.icon = nil
    prototype.icon_size = nil
  end
end

function helpers.apply_low_pressure_steel_icon_tint(prototype)
  if prototype and prototype.icon then
    prototype.icons = {
      { icon = prototype.icon, icon_size = prototype.icon_size or 64 },
      { icon = prototype.icon, icon_size = prototype.icon_size or 64, tint = constants.steel.icon_tint },
      { icon = prototype.icon, icon_size = prototype.icon_size or 64, tint = constants.low_pressure_steel.icon_tint },
    }
    prototype.icon = nil
    prototype.icon_size = nil
  end
end

function helpers.apply_heat_resistant_icon_tint(prototype)
  if prototype and prototype.icon then
    prototype.icons = {
      { icon = prototype.icon, icon_size = prototype.icon_size or 64 },
      { icon = prototype.icon, icon_size = prototype.icon_size or 64, tint = constants.heat_resistant.icon_tint },
    }
    prototype.icon = nil
    prototype.icon_size = nil
  end
end

function helpers.apply_tungsten_icon_tint(prototype)
  if prototype and prototype.icon then
    prototype.icons = {
      { icon = prototype.icon, icon_size = prototype.icon_size or 64 },
      { icon = prototype.icon, icon_size = prototype.icon_size or 64, tint = constants.steel.icon_tint },
      { icon = prototype.icon, icon_size = prototype.icon_size or 64, tint = constants.tungsten.icon_tint },
    }
    prototype.icon = nil
    prototype.icon_size = nil
  end
end

function helpers.apply_reinforced_icon_tint(prototype)
  if prototype and prototype.icon then
    prototype.icons = {
      { icon = prototype.icon, icon_size = prototype.icon_size or 64 },
      { icon = prototype.icon, icon_size = prototype.icon_size or 64, tint = constants.reinforced.icon_tint },
    }
    prototype.icon = nil
    prototype.icon_size = nil
  end
end

function helpers.apply_foundation_icon_tint(prototype)
  if prototype and prototype.icon then
    prototype.icons = {
      { icon = prototype.icon, icon_size = prototype.icon_size or 64 },
      { icon = prototype.icon, icon_size = prototype.icon_size or 64, tint = constants.foundation.icon_tint },
    }
    prototype.icon = nil
    prototype.icon_size = nil
  end
end

function helpers.apply_high_pressure_foundation_icon_tint(prototype)
  if prototype and prototype.icon then
    prototype.icons = {
      { icon = prototype.icon, icon_size = prototype.icon_size or 64 },
      { icon = prototype.icon, icon_size = prototype.icon_size or 64, tint = constants.foundation.icon_tint },
      { icon = prototype.icon, icon_size = prototype.icon_size or 64, tint = constants.high_pressure_foundation.icon_tint },
    }
    prototype.icon = nil
    prototype.icon_size = nil
  elseif prototype and prototype.icons then
    local source = prototype.icons[1]
    table.insert(prototype.icons, {
      icon = source.icon,
      icon_size = source.icon_size or 64,
      tint = constants.high_pressure_foundation.icon_tint,
    })
  end
end

function helpers.apply_rubber_lined_icon_tint(prototype)
  if prototype and prototype.icon then
    prototype.icons = {
      { icon = prototype.icon, icon_size = prototype.icon_size or 64 },
      { icon = prototype.icon, icon_size = prototype.icon_size or 64, tint = constants.rubber_lined.icon_tint },
    }
    prototype.icon = nil
    prototype.icon_size = nil
  end
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

function helpers.apply_rubber_lined_entity_tint(prototype)
  if not prototype then
    return
  end
  tint_sprite_table(prototype.pictures, constants.rubber_lined.entity_tint)
  tint_sprite_table(prototype.picture, constants.rubber_lined.entity_tint)
  tint_sprite_table(prototype.graphics_set, constants.rubber_lined.entity_tint)
  tint_sprite_table(prototype.animations, constants.rubber_lined.entity_tint)
  tint_sprite_table(prototype.horizontal_animation, constants.rubber_lined.entity_tint)
  tint_sprite_table(prototype.vertical_animation, constants.rubber_lined.entity_tint)
end

function helpers.apply_low_pressure_steel_entity_tint(prototype)
  if not prototype then
    return
  end
  tint_sprite_table(prototype.pictures, constants.low_pressure_steel.entity_tint)
  tint_sprite_table(prototype.picture, constants.low_pressure_steel.entity_tint)
  tint_sprite_table(prototype.graphics_set, constants.low_pressure_steel.entity_tint)
  tint_sprite_table(prototype.animations, constants.low_pressure_steel.entity_tint)
  tint_sprite_table(prototype.horizontal_animation, constants.low_pressure_steel.entity_tint)
  tint_sprite_table(prototype.vertical_animation, constants.low_pressure_steel.entity_tint)
end

function helpers.apply_heat_resistant_entity_tint(prototype)
  if not prototype then
    return
  end
  tint_sprite_table(prototype.pictures, constants.heat_resistant.entity_tint)
  tint_sprite_table(prototype.picture, constants.heat_resistant.entity_tint)
  tint_sprite_table(prototype.graphics_set, constants.heat_resistant.entity_tint)
  tint_sprite_table(prototype.animations, constants.heat_resistant.entity_tint)
  tint_sprite_table(prototype.horizontal_animation, constants.heat_resistant.entity_tint)
  tint_sprite_table(prototype.vertical_animation, constants.heat_resistant.entity_tint)
end

function helpers.apply_tungsten_entity_tint(prototype)
  if not prototype then
    return
  end
  tint_sprite_table(prototype.pictures, constants.tungsten.entity_tint)
  tint_sprite_table(prototype.picture, constants.tungsten.entity_tint)
  tint_sprite_table(prototype.graphics_set, constants.tungsten.entity_tint)
  tint_sprite_table(prototype.animations, constants.tungsten.entity_tint)
  tint_sprite_table(prototype.horizontal_animation, constants.tungsten.entity_tint)
  tint_sprite_table(prototype.vertical_animation, constants.tungsten.entity_tint)
end

function helpers.apply_reinforced_entity_tint(prototype)
  if not prototype then
    return
  end
  tint_sprite_table(prototype.pictures, constants.reinforced.entity_tint)
  tint_sprite_table(prototype.picture, constants.reinforced.entity_tint)
  tint_sprite_table(prototype.graphics_set, constants.reinforced.entity_tint)
  tint_sprite_table(prototype.animations, constants.reinforced.entity_tint)
  tint_sprite_table(prototype.horizontal_animation, constants.reinforced.entity_tint)
  tint_sprite_table(prototype.vertical_animation, constants.reinforced.entity_tint)
end

function helpers.apply_foundation_entity_tint(prototype)
  if not prototype then
    return
  end
  tint_sprite_table(prototype.pictures, constants.foundation.entity_tint)
  tint_sprite_table(prototype.picture, constants.foundation.entity_tint)
  tint_sprite_table(prototype.graphics_set, constants.foundation.entity_tint)
  tint_sprite_table(prototype.animations, constants.foundation.entity_tint)
  tint_sprite_table(prototype.horizontal_animation, constants.foundation.entity_tint)
  tint_sprite_table(prototype.vertical_animation, constants.foundation.entity_tint)
end

function helpers.apply_high_pressure_foundation_entity_tint(prototype)
  if not prototype then
    return
  end
  tint_sprite_table(prototype.pictures, constants.high_pressure_foundation.entity_tint)
  tint_sprite_table(prototype.picture, constants.high_pressure_foundation.entity_tint)
  tint_sprite_table(prototype.graphics_set, constants.high_pressure_foundation.entity_tint)
  tint_sprite_table(prototype.animations, constants.high_pressure_foundation.entity_tint)
  tint_sprite_table(prototype.horizontal_animation, constants.high_pressure_foundation.entity_tint)
  tint_sprite_table(prototype.vertical_animation, constants.high_pressure_foundation.entity_tint)
end

function helpers.set_fluid_box_extent(fluid_box, extent)
  if fluid_box then
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

function helpers.set_underground_distance(pipe_to_ground, distance)
  local connections = pipe_to_ground.fluid_box and pipe_to_ground.fluid_box.pipe_connections
  if connections then
    for _, connection in pairs(connections) do
      if connection.connection_type == "underground" then
        connection.max_underground_distance = distance
      end
    end
  end
end

function helpers.set_description(prototype, description)
  if prototype then
    prototype.localised_description = description
  end
end

function helpers.set_resistances(prototype, resistances)
  if prototype then
    prototype.resistances = util.table.deepcopy(resistances)
  end
end

function helpers.append_description(prototype, description)
  if not prototype then
    return
  end
  if prototype.localised_description then
    prototype.localised_description = { "", prototype.localised_description, "\n", description }
  else
    prototype.localised_description = description
  end
end

function helpers.allow_only_space_platforms(prototype)
  if prototype then
    prototype.surface_conditions = {
      { property = "gravity", min = 0, max = 0 },
    }
  end
end

function helpers.disallow_space_platforms(prototype)
  if prototype then
    prototype.surface_conditions = {
      { property = "gravity", min = 1 },
    }
  end
end

function helpers.allow_only_vulcanus(prototype)
  if prototype then
    prototype.surface_conditions = {
      { property = "pressure", min = 4000, max = 4000 },
    }
  end
end

function helpers.disallow_space_platforms_and_vulcanus(prototype)
  if prototype then
    prototype.surface_conditions = {
      { property = "gravity", min = 1 },
      { property = "pressure", max = 3999 },
    }
  end
end

function helpers.pipe_description(extent)
  return { "description.aer_pipeline-extent", tostring(extent) }
end

function helpers.underground_pipe_description(extent, underground_distance)
  return { "description.aer_underground-pipeline-extent", tostring(extent), tostring(underground_distance) }
end

function helpers.offshore_pump_description(extent)
  return { "description.aer_offshore-pump-fluid-stats", tostring(extent) }
end

function helpers.lava_offshore_pump_description(extent)
  return { "description.aer_lava-offshore-pump-fluid-stats", tostring(extent) }
end

function helpers.pump_description()
  return { "description.aer_pump-fluid-stats" }
end

function helpers.boiler_description(extent)
  return { "description.aer_boiler-fluid-stats", tostring(extent) }
end

function helpers.add_unlock(technology_name, recipe_name)
  local technology = data.raw.technology[technology_name]
  if technology then
    technology.effects = technology.effects or {}
    table.insert(technology.effects, { type = "unlock-recipe", recipe = recipe_name })
  end
end

function helpers.patch_boiler_extent(boiler_name, extent)
  local boiler = data.raw.boiler[boiler_name]
  if boiler then
    helpers.set_fluid_box_extent(boiler.fluid_box, extent)
    helpers.set_fluid_box_extent(boiler.output_fluid_box, extent)
    helpers.set_description(boiler, helpers.boiler_description(extent))
  end
  helpers.set_description(data.raw.item[boiler_name], helpers.boiler_description(extent))
end

return helpers
