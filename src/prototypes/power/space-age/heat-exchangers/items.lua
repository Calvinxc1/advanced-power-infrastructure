-- Space Age heat exchanger tier. Its recipe needs foundation and
-- superconductor. The tier below it survives a base-game load by substituting
-- refined concrete and low-density structure.

local fluid_helpers = require("prototypes.power.fluid-helpers")
local fluid_constants = require("prototypes.power.fluid-constants")

local heat_exchanger_mk4 = util.table.deepcopy(data.raw.item["heat-exchanger"])
heat_exchanger_mk4.name = "aer_heat-exchanger-4"
heat_exchanger_mk4.subgroup = "aer_heat-exchanger"
heat_exchanger_mk4.order = "b[steam-power]-a[heat-exchanger-4]"
heat_exchanger_mk4.place_result = "aer_heat-exchanger-4"
fluid_helpers.set_description(heat_exchanger_mk4, fluid_helpers.boiler_description(fluid_constants.foundation.pipeline_extent))
heat_exchanger_mk4.icon = "__base__/graphics/icons/heat-boiler.png"
heat_exchanger_mk4.icon_size = 64
heat_exchanger_mk4.icons = nil
fluid_helpers.apply_foundation_icon_tint(heat_exchanger_mk4)
data:extend({heat_exchanger_mk4})
