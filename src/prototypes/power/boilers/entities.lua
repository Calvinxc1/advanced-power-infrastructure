data.raw["boiler"]["boiler"].fast_replaceable_group = "boiler"
data.raw["boiler"]["boiler"].next_upgrade = "aer_steel-boiler"

local function tint_boiler_structure(boiler, tint)
  for _, picture in pairs(boiler.pictures or {}) do
    if picture.structure then
      advanced_power_tint_sprite_layers(picture.structure.layers, tint)
    end
    if picture.patch then
      picture.patch.tint = tint
    end
  end
end

local boiler_mk2 = util.table.deepcopy(data.raw["boiler"]["boiler"])
boiler_mk2.target_temperature = 225
boiler_mk2.energy_consumption = "3MW"
boiler_mk2.name = "aer_steel-boiler"
boiler_mk2.minable.result =  "aer_steel-boiler"
boiler_mk2.fast_replaceable_group = "boiler"
boiler_mk2.next_upgrade = "aer_rubber-lined-boiler"
boiler_mk2.energy_source.effectivity = 1.1
advanced_power_apply_steel_icon_tint(boiler_mk2)
tint_boiler_structure(boiler_mk2, steel_tier_entity_tint)
data:extend({boiler_mk2})

local boiler_mk3 = util.table.deepcopy(data.raw["boiler"]["boiler"])
boiler_mk3.target_temperature = 290
boiler_mk3.energy_consumption = "4.8MW"
boiler_mk3.name = "aer_rubber-lined-boiler"
boiler_mk3.minable.result =  "aer_rubber-lined-boiler"
boiler_mk3.fast_replaceable_group = "boiler"
boiler_mk3.next_upgrade = "aer_holmium-reinforced-boiler"
boiler_mk3.energy_source.effectivity = 1.2
advanced_power_apply_rubber_lined_icon_tint(boiler_mk3)
tint_boiler_structure(boiler_mk3, rubber_lined_tier_entity_tint)
data:extend({boiler_mk3})

local boiler_mk4 = util.table.deepcopy(data.raw["boiler"]["boiler"])
boiler_mk4.target_temperature = 350
boiler_mk4.energy_consumption = "7.2MW"
boiler_mk4.name = "aer_holmium-reinforced-boiler"
boiler_mk4.minable.result =  "aer_holmium-reinforced-boiler"
boiler_mk4.fast_replaceable_group = "boiler"
boiler_mk4.next_upgrade = nil
boiler_mk4.energy_source.effectivity = 1.3
advanced_power_apply_holmium_icon_tint(boiler_mk4)
tint_boiler_structure(boiler_mk4, holmium_tier_entity_tint)
data:extend({boiler_mk4})


   
