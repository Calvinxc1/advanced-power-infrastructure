local constants = require("prototypes.power.fluid-constants")

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

function helpers.boiler_description(extent)
  return { "description.aer_boiler-fluid-stats", tostring(extent) }
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
