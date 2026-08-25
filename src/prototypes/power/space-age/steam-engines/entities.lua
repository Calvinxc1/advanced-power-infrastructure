-- Space Age steam engine tier. Its recipe needs holmium plate and
-- superconductor, neither of which has a base-game equivalent.

local fluid_constants = require("prototypes.power.fluid-constants")
local fluid_helpers = require("prototypes.power.fluid-helpers")

local steam_engine_mk4 = util.table.deepcopy(data.raw["generator"]["steam-engine"])
steam_engine_mk4.name = "aer_holmium-steam-engine"
steam_engine_mk4.fluid_usage_per_tick = 1
steam_engine_mk4.maximum_temperature = 350
steam_engine_mk4.max_health = 700
steam_engine_mk4.minable.result = "aer_holmium-steam-engine"
steam_engine_mk4.next_upgrade = nil
fluid_helpers.set_prototype_fluid_boxes_extent(steam_engine_mk4, fluid_constants.power_building_pipeline_extent)
fluid_helpers.set_description(steam_engine_mk4, fluid_helpers.boiler_description(fluid_constants.power_building_pipeline_extent))
advanced_power_apply_holmium_icon_tint(steam_engine_mk4)
advanced_power_apply_entity_tint(steam_engine_mk4, holmium_tier_entity_tint)
data:extend({steam_engine_mk4})

-- Re-point the base ladder's top tier now that a tier above it exists.
data.raw["generator"]["aer_rubber-lined-steam-engine"].next_upgrade = "aer_holmium-steam-engine"
