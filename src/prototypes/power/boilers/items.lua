local fluid_constants = require("prototypes.power.fluid-constants")
local fluid_helpers = require("prototypes.power.fluid-helpers")

data.raw.item["boiler"].order = "a[boiler-1]"
data.raw.item["boiler"].subgroup = "aer_steam-power"
fluid_helpers.set_description(data.raw.item["boiler"], fluid_helpers.boiler_description(fluid_constants.power_building_pipeline_extent))

local boiler_mk2 = util.table.deepcopy(data.raw.item["boiler"])
boiler_mk2.name = "aer_steel-boiler"
boiler_mk2.subgroup = "aer_steam-power"
boiler_mk2.order = "a[boiler-2]"
boiler_mk2.place_result = "aer_steel-boiler"
fluid_helpers.set_description(boiler_mk2, fluid_helpers.boiler_description(fluid_constants.power_building_pipeline_extent))
advanced_power_apply_steel_icon_tint(boiler_mk2)
data:extend({boiler_mk2})

local boiler_mk3 = util.table.deepcopy(data.raw.item["boiler"])
boiler_mk3.name = "aer_rubber-lined-boiler"
boiler_mk3.subgroup = "aer_steam-power"
boiler_mk3.order = "a[boiler-3]"
boiler_mk3.place_result = "aer_rubber-lined-boiler"
fluid_helpers.set_description(boiler_mk3, fluid_helpers.boiler_description(fluid_constants.power_building_pipeline_extent))
advanced_power_apply_rubber_lined_icon_tint(boiler_mk3)
data:extend({boiler_mk3})
