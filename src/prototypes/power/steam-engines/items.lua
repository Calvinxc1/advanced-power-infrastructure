local fluid_constants = require("prototypes.power.fluid-constants")
local fluid_helpers = require("prototypes.power.fluid-helpers")

data.raw.item["steam-engine"].order = "b[steam-engine-1]"
data.raw.item["steam-engine"].subgroup = "aer_steam-power"
fluid_helpers.set_description(data.raw.item["steam-engine"], fluid_helpers.boiler_description(fluid_constants.iron.pipeline_extent))

local steam_engine_mk2 = util.table.deepcopy(data.raw.item["steam-engine"])
steam_engine_mk2.name = "aer_steel-steam-engine"
steam_engine_mk2.subgroup = "aer_steam-power"
steam_engine_mk2.order = "b[steam-engine-2]"
steam_engine_mk2.place_result = "aer_steel-steam-engine"
fluid_helpers.set_description(steam_engine_mk2, fluid_helpers.boiler_description(fluid_constants.steel.pipeline_extent))
advanced_power_apply_steel_icon_tint(steam_engine_mk2)
data:extend({steam_engine_mk2})

local steam_engine_mk3 = util.table.deepcopy(data.raw.item["steam-engine"])
steam_engine_mk3.name = "aer_rubber-lined-steam-engine"
steam_engine_mk3.subgroup = "aer_steam-power"
steam_engine_mk3.order = "b[steam-engine-3]"
steam_engine_mk3.place_result = "aer_rubber-lined-steam-engine"
fluid_helpers.set_description(steam_engine_mk3, fluid_helpers.boiler_description(fluid_constants.rubber_lined.pipeline_extent))
advanced_power_apply_rubber_lined_icon_tint(steam_engine_mk3)
data:extend({steam_engine_mk3})
