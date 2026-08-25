-- Space Age heat exchanger tier. Its recipe needs foundation and
-- superconductor. The tier below it survives a base-game load by substituting
-- refined concrete and low-density structure.

local constants = require("prototypes.power.fluid-constants")
local fluid_helpers = require("prototypes.power.fluid-helpers")

local heat_exchanger_mk4 = util.table.deepcopy(data.raw["boiler"]["heat-exchanger"])
heat_exchanger_mk4.energy_consumption = "32MW"
heat_exchanger_mk4.target_temperature = 1000
heat_exchanger_mk4.max_health = 800
heat_exchanger_mk4.name = "aer_heat-exchanger-4"
heat_exchanger_mk4.minable.result = "aer_heat-exchanger-4"
heat_exchanger_mk4.fast_replaceable_group = "heat-exchanger"
heat_exchanger_mk4.next_upgrade = nil
heat_exchanger_mk4.energy_source.min_working_temperature =
  constants.heat_exchanger_min_working_temperature
heat_exchanger_mk4.energy_source.minimum_glow_temperature = 850
heat_exchanger_mk4.energy_source.max_temperature = 2200
heat_exchanger_mk4.energy_source.specific_heat = "4MJ"
heat_exchanger_mk4.energy_source.max_transfer = "8GW"
fluid_helpers.set_prototype_fluid_boxes_extent(heat_exchanger_mk4, constants.foundation.pipeline_extent)
fluid_helpers.set_description(heat_exchanger_mk4, fluid_helpers.compose_description(
  fluid_helpers.heat_optimal_description(1000),
  fluid_helpers.heat_passthrough_description(),
  fluid_helpers.boiler_description(constants.foundation.pipeline_extent)))
fluid_helpers.set_resistances(heat_exchanger_mk4, constants.foundation.resistances)
heat_exchanger_mk4.icon = "__base__/graphics/icons/heat-boiler.png"
heat_exchanger_mk4.icon_size = 64
heat_exchanger_mk4.icons = nil
fluid_helpers.apply_foundation_icon_tint(heat_exchanger_mk4)
fluid_helpers.apply_foundation_entity_tint(heat_exchanger_mk4)
data:extend({heat_exchanger_mk4})

-- Re-point the base ladder's top tier now that a tier above it exists.
data.raw["boiler"]["aer_heat-exchanger-3"].next_upgrade = "aer_heat-exchanger-4"
