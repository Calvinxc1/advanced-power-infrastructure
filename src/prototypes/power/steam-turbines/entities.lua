local constants = require("prototypes.power.fluid-constants")
local fluid_helpers = require("prototypes.power.fluid-helpers")

local function tint_steam_turbine(turbine, tint)
  advanced_power_apply_entity_tint(turbine, tint)
end

local function reset_steam_turbine_icon(turbine)
  turbine.icon = "__base__/graphics/icons/steam-turbine.png"
  turbine.icon_size = 64
  turbine.icons = nil
end

local steam_turbine_mk1 = data.raw["generator"]["steam-turbine"]
steam_turbine_mk1.fast_replaceable_group = "steam-turbine"
steam_turbine_mk1.next_upgrade = "aer_rubber-lined-steam-turbine"
fluid_helpers.set_prototype_fluid_boxes_extent(steam_turbine_mk1, constants.power_building_pipeline_extent)
fluid_helpers.set_description(steam_turbine_mk1, fluid_helpers.boiler_description(constants.power_building_pipeline_extent))
advanced_power_apply_steel_icon_tint(steam_turbine_mk1)
tint_steam_turbine(steam_turbine_mk1, steel_tier_entity_tint)

local steam_turbine_mk2 = util.table.deepcopy(data.raw["generator"]["steam-turbine"])
steam_turbine_mk2.name = "aer_rubber-lined-steam-turbine"
steam_turbine_mk2.fluid_usage_per_tick = 1.2
steam_turbine_mk2.maximum_temperature = 650
steam_turbine_mk2.max_health = 650
steam_turbine_mk2.minable.result = "aer_rubber-lined-steam-turbine"
steam_turbine_mk2.next_upgrade = "aer_reinforced-steam-turbine"
fluid_helpers.set_prototype_fluid_boxes_extent(steam_turbine_mk2, constants.power_building_pipeline_extent)
fluid_helpers.set_description(steam_turbine_mk2, fluid_helpers.boiler_description(constants.power_building_pipeline_extent))
reset_steam_turbine_icon(steam_turbine_mk2)
advanced_power_apply_rubber_lined_icon_tint(steam_turbine_mk2)
tint_steam_turbine(steam_turbine_mk2, rubber_lined_tier_entity_tint)
data:extend({steam_turbine_mk2})

local steam_turbine_mk3 = util.table.deepcopy(data.raw["generator"]["steam-turbine"])
steam_turbine_mk3.name = "aer_reinforced-steam-turbine"
-- Steam volume nearly stops climbing here. A turbine's output is temperature
-- times volume, and from this tier up the temperature does most of the work.
-- Holding volume back is what makes a block need more turbines each tier
-- rather than fewer, while the count still decelerates: +22.5, +14.4, +10.5.
steam_turbine_mk3.fluid_usage_per_tick = 1.28
steam_turbine_mk3.maximum_temperature = 800
steam_turbine_mk3.max_health = 800
steam_turbine_mk3.minable.result = "aer_reinforced-steam-turbine"
-- Terminates the base-game ladder. prototypes/power/space-age/steam-turbines/entities.lua
-- re-points this at its Space Age tier when that tier exists, so the chain is
-- correct in both loads without depending on load order.
steam_turbine_mk3.next_upgrade = nil
fluid_helpers.set_prototype_fluid_boxes_extent(steam_turbine_mk3, constants.power_building_pipeline_extent)
fluid_helpers.set_description(steam_turbine_mk3, fluid_helpers.boiler_description(constants.power_building_pipeline_extent))
fluid_helpers.set_resistances(steam_turbine_mk3, constants.reinforced.resistances)
reset_steam_turbine_icon(steam_turbine_mk3)
fluid_helpers.apply_reinforced_icon_tint(steam_turbine_mk3)
fluid_helpers.apply_reinforced_entity_tint(steam_turbine_mk3)
data:extend({steam_turbine_mk3})
