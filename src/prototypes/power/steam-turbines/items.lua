local fluid_helpers = require("prototypes.power.fluid-helpers")
local fluid_constants = require("prototypes.power.fluid-constants")

local function reset_steam_turbine_icon(item)
  item.icon = "__base__/graphics/icons/steam-turbine.png"
  item.icon_size = 64
  item.icons = nil
end

data.raw.item["steam-turbine"].order = "b[steam-power]-b[steam-turbine-1]"
data.raw.item["steam-turbine"].subgroup = "aer_steam-turbine"
fluid_helpers.set_description(data.raw.item["steam-turbine"], fluid_helpers.boiler_description(fluid_constants.steel.pipeline_extent))
advanced_power_apply_steel_icon_tint(data.raw.item["steam-turbine"])

local steam_turbine_mk2 = util.table.deepcopy(data.raw.item["steam-turbine"])
steam_turbine_mk2.name = "aer_rubber-lined-steam-turbine"
steam_turbine_mk2.subgroup = "aer_steam-turbine"
steam_turbine_mk2.order = "b[steam-power]-b[steam-turbine-2]"
steam_turbine_mk2.place_result = "aer_rubber-lined-steam-turbine"
fluid_helpers.set_description(steam_turbine_mk2, fluid_helpers.boiler_description(fluid_constants.rubber_lined.pipeline_extent))
reset_steam_turbine_icon(steam_turbine_mk2)
advanced_power_apply_rubber_lined_icon_tint(steam_turbine_mk2)
data:extend({steam_turbine_mk2})

local steam_turbine_mk3 = util.table.deepcopy(data.raw.item["steam-turbine"])
steam_turbine_mk3.name = "aer_reinforced-steam-turbine"
steam_turbine_mk3.subgroup = "aer_steam-turbine"
steam_turbine_mk3.order = "b[steam-power]-b[steam-turbine-3]"
steam_turbine_mk3.place_result = "aer_reinforced-steam-turbine"
fluid_helpers.set_description(steam_turbine_mk3, fluid_helpers.boiler_description(fluid_constants.reinforced.pipeline_extent))
reset_steam_turbine_icon(steam_turbine_mk3)
fluid_helpers.apply_reinforced_icon_tint(steam_turbine_mk3)
data:extend({steam_turbine_mk3})
