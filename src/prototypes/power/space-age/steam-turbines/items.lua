-- Space Age steam turbine tier. Its recipe needs foundation and
-- superconductor. The reinforced tier below it survives a base-game load by
-- substituting refined concrete and low-density structure.

local fluid_helpers = require("prototypes.power.fluid-helpers")
local fluid_constants = require("prototypes.power.fluid-constants")
local function reset_steam_turbine_icon(item)
  item.icon = "__base__/graphics/icons/steam-turbine.png"
  item.icon_size = 64
  item.icons = nil
end

local steam_turbine_mk4 = util.table.deepcopy(data.raw.item["steam-turbine"])
steam_turbine_mk4.name = "aer_foundation-steam-turbine"
steam_turbine_mk4.subgroup = "aer_steam-turbine"
steam_turbine_mk4.order = "b[steam-power]-b[steam-turbine-4]"
steam_turbine_mk4.place_result = "aer_foundation-steam-turbine"
fluid_helpers.set_description(steam_turbine_mk4, fluid_helpers.boiler_description(fluid_constants.foundation.pipeline_extent))
reset_steam_turbine_icon(steam_turbine_mk4)
fluid_helpers.apply_foundation_icon_tint(steam_turbine_mk4)
data:extend({steam_turbine_mk4})
