steel_tier_icon_tint = { r = 0.5, g = 0.72, b = 1.0, a = 0.48 }
steel_tier_entity_tint = { r = 0.62, g = 0.8, b = 1.0, a = 1 }
rubber_lined_tier_icon_tint = { r = 0.08, g = 0.08, b = 0.08, a = 0.58 }
rubber_lined_tier_entity_tint = { r = 0.42, g = 0.42, b = 0.42, a = 1 }
holmium_tier_icon_tint = { r = 0.92, g = 0.42, b = 0.95, a = 0.42 }
holmium_tier_entity_tint = { r = 0.9, g = 0.58, b = 0.95, a = 1 }

function advanced_power_apply_steel_icon_tint(prototype)
  if prototype and prototype.icon then
    prototype.icons = {
      { icon = prototype.icon, icon_size = prototype.icon_size or 64 },
      { icon = prototype.icon, icon_size = prototype.icon_size or 64, tint = steel_tier_icon_tint },
    }
    prototype.icon = nil
    prototype.icon_size = nil
  elseif prototype and prototype.icons then
    table.insert(prototype.icons, {
      icon = prototype.icons[1].icon,
      icon_size = prototype.icons[1].icon_size or 64,
      tint = steel_tier_icon_tint,
    })
  end
end

function advanced_power_apply_rubber_lined_icon_tint(prototype)
  if prototype and prototype.icon then
    prototype.icons = {
      { icon = prototype.icon, icon_size = prototype.icon_size or 64 },
      { icon = prototype.icon, icon_size = prototype.icon_size or 64, tint = rubber_lined_tier_icon_tint },
    }
    prototype.icon = nil
    prototype.icon_size = nil
  elseif prototype and prototype.icons then
    table.insert(prototype.icons, {
      icon = prototype.icons[1].icon,
      icon_size = prototype.icons[1].icon_size or 64,
      tint = rubber_lined_tier_icon_tint,
    })
  end
end

function advanced_power_apply_holmium_icon_tint(prototype)
  if prototype and prototype.icon then
    prototype.icons = {
      { icon = prototype.icon, icon_size = prototype.icon_size or 64 },
      { icon = prototype.icon, icon_size = prototype.icon_size or 64, tint = holmium_tier_icon_tint },
    }
    prototype.icon = nil
    prototype.icon_size = nil
  elseif prototype and prototype.icons then
    table.insert(prototype.icons, {
      icon = prototype.icons[1].icon,
      icon_size = prototype.icons[1].icon_size or 64,
      tint = holmium_tier_icon_tint,
    })
  end
end

function advanced_power_tint_sprite_layers(layers, tint)
  if layers then
    for _, layer in pairs(layers) do
      if not layer.draw_as_shadow then
        layer.tint = tint
      end
    end
  end
end

local function advanced_power_tint_sprite_table(sprite_table, tint)
  if not sprite_table then
    return
  end

  if sprite_table.draw_as_shadow then
    return
  end

  if sprite_table.layers then
    advanced_power_tint_sprite_layers(sprite_table.layers, tint)
  elseif sprite_table.filename or sprite_table.filenames or sprite_table.stripes then
    sprite_table.tint = tint
  end

  for _, value in pairs(sprite_table) do
    if type(value) == "table" then
      advanced_power_tint_sprite_table(value, tint)
    end
  end
end

function advanced_power_apply_entity_tint(prototype, tint)
  if not prototype then
    return
  end

  advanced_power_tint_sprite_table(prototype.pictures, tint)
  advanced_power_tint_sprite_table(prototype.picture, tint)
  advanced_power_tint_sprite_table(prototype.graphics_set, tint)
  advanced_power_tint_sprite_table(prototype.animations, tint)
  advanced_power_tint_sprite_table(prototype.horizontal_animation, tint)
  advanced_power_tint_sprite_table(prototype.vertical_animation, tint)
end
