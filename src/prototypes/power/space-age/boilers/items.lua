-- Space Age boiler tier. Its recipe needs superconductor, and its research
-- is gated on electromagnetic science, so it has no base-game form.

local fluid_constants = require("prototypes.power.fluid-constants")
local fluid_helpers = require("prototypes.power.fluid-helpers")

local boiler_mk4 = util.table.deepcopy(data.raw.item["boiler"])
boiler_mk4.name = "aer_holmium-reinforced-boiler"
boiler_mk4.subgroup = "aer_steam-power"
boiler_mk4.order = "a[boiler-4]"
boiler_mk4.place_result = "aer_holmium-reinforced-boiler"
fluid_helpers.set_description(boiler_mk4, fluid_helpers.boiler_description(fluid_constants.power_building_pipeline_extent))
advanced_power_apply_holmium_icon_tint(boiler_mk4)
data:extend({boiler_mk4})
