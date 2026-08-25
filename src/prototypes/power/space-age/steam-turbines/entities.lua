-- Space Age steam turbine tier. Its recipe needs foundation and
-- superconductor. The reinforced tier below it survives a base-game load by
-- substituting refined concrete and low-density structure.

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

local steam_turbine_mk4 = util.table.deepcopy(data.raw["generator"]["steam-turbine"])
steam_turbine_mk4.name = "aer_foundation-steam-turbine"
-- Less steam than mk2, and still the most powerful tier: 1000 degree steam
-- carries enough energy per unit that 1.08 of it beats 1.2 at 650.
steam_turbine_mk4.fluid_usage_per_tick = 1.08
steam_turbine_mk4.maximum_temperature = 1000
steam_turbine_mk4.max_health = 1000
steam_turbine_mk4.minable.result = "aer_foundation-steam-turbine"
steam_turbine_mk4.next_upgrade = nil
fluid_helpers.set_prototype_fluid_boxes_extent(steam_turbine_mk4, constants.power_building_pipeline_extent)
fluid_helpers.set_description(steam_turbine_mk4, fluid_helpers.boiler_description(constants.power_building_pipeline_extent))
fluid_helpers.set_resistances(steam_turbine_mk4, constants.foundation.resistances)
reset_steam_turbine_icon(steam_turbine_mk4)
fluid_helpers.apply_foundation_icon_tint(steam_turbine_mk4)
fluid_helpers.apply_foundation_entity_tint(steam_turbine_mk4)
data:extend({steam_turbine_mk4})

-- Re-point the base ladder's top tier now that a tier above it exists.
data.raw["generator"]["aer_reinforced-steam-turbine"].next_upgrade = "aer_foundation-steam-turbine"
