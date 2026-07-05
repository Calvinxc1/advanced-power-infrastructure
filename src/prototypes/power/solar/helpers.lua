local helpers = {}

local holmium_icon_tint = { r = 0.92, g = 0.42, b = 0.95, a = 0.42 }
local holmium_entity_tint = { r = 0.9, g = 0.58, b = 0.95, a = 1 }
local cryogenic_icon_tint = { r = 0.72, g = 0.95, b = 1.0, a = 0.46 }
local cryogenic_entity_tint = { r = 0.72, g = 0.9, b = 1.0, a = 1 }

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
  tint_sprite_table(prototype.picture, tint)
  tint_sprite_table(prototype.overlay, tint)
  tint_sprite_table(prototype.chargable_graphics, tint)
  tint_sprite_table(prototype.water_reflection, tint)
end

function helpers.apply_holmium_icon_tint(prototype)
  apply_icon_tint(prototype, holmium_icon_tint)
end

function helpers.apply_holmium_entity_tint(prototype)
  apply_entity_tint(prototype, holmium_entity_tint)
end

function helpers.apply_cryogenic_icon_tint(prototype)
  apply_icon_tint(prototype, cryogenic_icon_tint)
end

function helpers.apply_cryogenic_entity_tint(prototype)
  apply_entity_tint(prototype, cryogenic_entity_tint)
end

return helpers
