local fluid_helpers = require("prototypes.power.fluid-helpers")
local fluid_constants = require("prototypes.power.fluid-constants")

data.raw.item["heat-exchanger"].order = "b[steam-power]-a[heat-exchanger-1]"
data.raw.item["heat-exchanger"].subgroup = "aer_heat-exchanger"
fluid_helpers.set_description(data.raw.item["heat-exchanger"], fluid_helpers.boiler_description(fluid_constants.steel.pipeline_extent))
advanced_power_apply_steel_icon_tint(data.raw.item["heat-exchanger"])

local heat_exchanger_mk2 = util.table.deepcopy(data.raw.item["heat-exchanger"])
heat_exchanger_mk2.name = "aer_heat-exchanger-2"
heat_exchanger_mk2.subgroup = "aer_heat-exchanger"
heat_exchanger_mk2.order= "b[steam-power]-a[heat-exchanger-2]"
heat_exchanger_mk2.place_result = "aer_heat-exchanger-2"
fluid_helpers.set_description(heat_exchanger_mk2, fluid_helpers.boiler_description(fluid_constants.rubber_lined.pipeline_extent))
heat_exchanger_mk2.icon = "__base__/graphics/icons/heat-boiler.png"
heat_exchanger_mk2.icon_size = 64
heat_exchanger_mk2.icons = nil
advanced_power_apply_rubber_lined_icon_tint(heat_exchanger_mk2)
data:extend({heat_exchanger_mk2})

local heat_exchanger_mk3 = util.table.deepcopy(data.raw.item["heat-exchanger"])
heat_exchanger_mk3.name = "aer_heat-exchanger-3"
heat_exchanger_mk3.subgroup = "aer_heat-exchanger"
heat_exchanger_mk3.order = "b[steam-power]-a[heat-exchanger-3]"
heat_exchanger_mk3.place_result = "aer_heat-exchanger-3"
fluid_helpers.set_description(heat_exchanger_mk3, fluid_helpers.boiler_description(fluid_constants.reinforced.pipeline_extent))
heat_exchanger_mk3.icon = "__base__/graphics/icons/heat-boiler.png"
heat_exchanger_mk3.icon_size = 64
heat_exchanger_mk3.icons = nil
fluid_helpers.apply_reinforced_icon_tint(heat_exchanger_mk3)
data:extend({heat_exchanger_mk3})
