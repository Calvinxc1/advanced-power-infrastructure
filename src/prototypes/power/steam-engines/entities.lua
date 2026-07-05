local fluid_constants = require("prototypes.power.fluid-constants")
local fluid_helpers = require("prototypes.power.fluid-helpers")

local base_steam_engine = data.raw["generator"]["steam-engine"]
base_steam_engine.fast_replaceable_group = "steam-engine"
base_steam_engine.next_upgrade = "aer_steel-steam-engine"
fluid_helpers.set_prototype_fluid_boxes_extent(base_steam_engine, fluid_constants.iron.pipeline_extent)
fluid_helpers.set_description(base_steam_engine, fluid_helpers.boiler_description(fluid_constants.iron.pipeline_extent))

local steam_engine_mk2 = util.table.deepcopy(data.raw["generator"]["steam-engine"])
steam_engine_mk2.name = "aer_steel-steam-engine"
steam_engine_mk2.fluid_usage_per_tick = 0.625
steam_engine_mk2.maximum_temperature = 225
steam_engine_mk2.max_health = 500
steam_engine_mk2.minable.result = "aer_steel-steam-engine"
steam_engine_mk2.next_upgrade = "aer_rubber-lined-steam-engine"
fluid_helpers.set_prototype_fluid_boxes_extent(steam_engine_mk2, fluid_constants.steel.pipeline_extent)
fluid_helpers.set_description(steam_engine_mk2, fluid_helpers.boiler_description(fluid_constants.steel.pipeline_extent))
advanced_power_apply_steel_icon_tint(steam_engine_mk2)
advanced_power_tint_sprite_layers(steam_engine_mk2.horizontal_animation.layers, steel_tier_entity_tint)
advanced_power_tint_sprite_layers(steam_engine_mk2.vertical_animation.layers, steel_tier_entity_tint)
data:extend({steam_engine_mk2})

local steam_engine_mk3 = util.table.deepcopy(data.raw["generator"]["steam-engine"])
steam_engine_mk3.name = "aer_rubber-lined-steam-engine"
steam_engine_mk3.fluid_usage_per_tick = 0.8
steam_engine_mk3.maximum_temperature = 290
steam_engine_mk3.max_health = 600
steam_engine_mk3.minable.result = "aer_rubber-lined-steam-engine"
steam_engine_mk3.next_upgrade = "aer_holmium-steam-engine"
fluid_helpers.set_prototype_fluid_boxes_extent(steam_engine_mk3, fluid_constants.rubber_lined.pipeline_extent)
fluid_helpers.set_description(steam_engine_mk3, fluid_helpers.boiler_description(fluid_constants.rubber_lined.pipeline_extent))
advanced_power_apply_rubber_lined_icon_tint(steam_engine_mk3)
advanced_power_tint_sprite_layers(steam_engine_mk3.horizontal_animation.layers, rubber_lined_tier_entity_tint)
advanced_power_tint_sprite_layers(steam_engine_mk3.vertical_animation.layers, rubber_lined_tier_entity_tint)
data:extend({steam_engine_mk3})

local steam_engine_mk4 = util.table.deepcopy(data.raw["generator"]["steam-engine"])
steam_engine_mk4.name = "aer_holmium-steam-engine"
steam_engine_mk4.fluid_usage_per_tick = 1
steam_engine_mk4.maximum_temperature = 350
steam_engine_mk4.max_health = 700
steam_engine_mk4.minable.result = "aer_holmium-steam-engine"
steam_engine_mk4.next_upgrade = nil
fluid_helpers.set_prototype_fluid_boxes_extent(steam_engine_mk4, fluid_constants.reinforced.pipeline_extent)
fluid_helpers.set_description(steam_engine_mk4, fluid_helpers.boiler_description(fluid_constants.reinforced.pipeline_extent))
advanced_power_apply_holmium_icon_tint(steam_engine_mk4)
advanced_power_tint_sprite_layers(steam_engine_mk4.horizontal_animation.layers, holmium_tier_entity_tint)
advanced_power_tint_sprite_layers(steam_engine_mk4.vertical_animation.layers, holmium_tier_entity_tint)
data:extend({steam_engine_mk4})
