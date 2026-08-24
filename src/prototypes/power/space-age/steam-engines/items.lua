-- Space Age steam engine tier. Its recipe needs holmium plate and
-- superconductor, neither of which has a base-game equivalent.

local fluid_constants = require("prototypes.power.fluid-constants")
local fluid_helpers = require("prototypes.power.fluid-helpers")

local steam_engine_mk4 = util.table.deepcopy(data.raw.item["steam-engine"])
steam_engine_mk4.name = "aer_holmium-steam-engine"
steam_engine_mk4.subgroup = "aer_steam-power"
steam_engine_mk4.order = "b[steam-engine-4]"
steam_engine_mk4.place_result = "aer_holmium-steam-engine"
fluid_helpers.set_description(steam_engine_mk4, fluid_helpers.boiler_description(fluid_constants.reinforced.pipeline_extent))
advanced_power_apply_holmium_icon_tint(steam_engine_mk4)
data:extend({steam_engine_mk4})
