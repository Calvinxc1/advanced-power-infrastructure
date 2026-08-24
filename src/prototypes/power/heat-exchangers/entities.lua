local constants = require("prototypes.power.fluid-constants")
local fluid_helpers = require("prototypes.power.fluid-helpers")

data.raw["boiler"]["heat-exchanger"].fast_replaceable_group = "heat-exchanger"
data.raw["boiler"]["heat-exchanger"].next_upgrade = "aer_heat-exchanger-2"
fluid_helpers.set_prototype_fluid_boxes_extent(data.raw["boiler"]["heat-exchanger"], constants.steel.pipeline_extent)
fluid_helpers.set_description(data.raw["boiler"]["heat-exchanger"], fluid_helpers.boiler_description(constants.steel.pipeline_extent))
advanced_power_apply_steel_icon_tint(data.raw["boiler"]["heat-exchanger"])

local heat_exchanger_mk2 = util.table.deepcopy(data.raw["boiler"]["heat-exchanger"])
heat_exchanger_mk2.energy_consumption = "18MW"
heat_exchanger_mk2.target_temperature = 650
heat_exchanger_mk2.max_health = 500
heat_exchanger_mk2.name = "aer_heat-exchanger-2"
heat_exchanger_mk2.minable.result =  "aer_heat-exchanger-2"
heat_exchanger_mk2.fast_replaceable_group = "heat-exchanger"
heat_exchanger_mk2.next_upgrade = "aer_heat-exchanger-3"
heat_exchanger_mk2.energy_source.min_working_temperature = 650
heat_exchanger_mk2.energy_source.minimum_glow_temperature = 500
heat_exchanger_mk2.energy_source.max_temperature = 1300
heat_exchanger_mk2.energy_source.specific_heat = "2MJ"
heat_exchanger_mk2.energy_source.max_transfer = "4GW"
fluid_helpers.set_prototype_fluid_boxes_extent(heat_exchanger_mk2, constants.rubber_lined.pipeline_extent)
fluid_helpers.set_description(heat_exchanger_mk2, fluid_helpers.boiler_description(constants.rubber_lined.pipeline_extent))
heat_exchanger_mk2.icon = "__base__/graphics/icons/heat-boiler.png"
heat_exchanger_mk2.icon_size = 64
heat_exchanger_mk2.icons = nil
advanced_power_apply_rubber_lined_icon_tint(heat_exchanger_mk2)
fluid_helpers.apply_rubber_lined_entity_tint(heat_exchanger_mk2)
data:extend({heat_exchanger_mk2})

local heat_exchanger_mk3 = util.table.deepcopy(data.raw["boiler"]["heat-exchanger"])
heat_exchanger_mk3.energy_consumption = "25MW"
heat_exchanger_mk3.target_temperature = 800
heat_exchanger_mk3.max_health = 650
heat_exchanger_mk3.name = "aer_heat-exchanger-3"
heat_exchanger_mk3.minable.result = "aer_heat-exchanger-3"
heat_exchanger_mk3.fast_replaceable_group = "heat-exchanger"
-- Terminates the base-game ladder. prototypes/power/space-age/heat-exchangers/entities.lua
-- re-points this at its Space Age tier when that tier exists, so the chain is
-- correct in both loads without depending on load order.
heat_exchanger_mk3.next_upgrade = nil
heat_exchanger_mk3.energy_source.min_working_temperature = 800
heat_exchanger_mk3.energy_source.minimum_glow_temperature = 650
heat_exchanger_mk3.energy_source.max_temperature = 1600
heat_exchanger_mk3.energy_source.specific_heat = "3MJ"
heat_exchanger_mk3.energy_source.max_transfer = "6GW"
fluid_helpers.set_prototype_fluid_boxes_extent(heat_exchanger_mk3, constants.reinforced.pipeline_extent)
fluid_helpers.set_description(heat_exchanger_mk3, fluid_helpers.boiler_description(constants.reinforced.pipeline_extent))
fluid_helpers.set_resistances(heat_exchanger_mk3, constants.reinforced.resistances)
heat_exchanger_mk3.icon = "__base__/graphics/icons/heat-boiler.png"
heat_exchanger_mk3.icon_size = 64
heat_exchanger_mk3.icons = nil
fluid_helpers.apply_reinforced_icon_tint(heat_exchanger_mk3)
fluid_helpers.apply_reinforced_entity_tint(heat_exchanger_mk3)
data:extend({heat_exchanger_mk3})
