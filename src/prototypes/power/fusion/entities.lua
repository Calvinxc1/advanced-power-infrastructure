local constants = require("prototypes.fluid.constants")
local fluid_helpers = require("prototypes.fluid.helpers")

local fusion_reactor = data.raw["fusion-reactor"] and data.raw["fusion-reactor"]["fusion-reactor"]
local fusion_generator = data.raw["fusion-generator"] and data.raw["fusion-generator"]["fusion-generator"]

if fusion_reactor then
  fusion_reactor.next_upgrade = "aer_fusion-reactor-2"
  fluid_helpers.set_prototype_fluid_boxes_extent(fusion_reactor, constants.steel.pipeline_extent)
  fluid_helpers.set_description(fusion_reactor, fluid_helpers.boiler_description(constants.steel.pipeline_extent))
end

if fusion_generator then
  fusion_generator.next_upgrade = "aer_fusion-generator-2"
  fluid_helpers.set_prototype_fluid_boxes_extent(fusion_generator, constants.steel.pipeline_extent)
  fluid_helpers.set_description(fusion_generator, fluid_helpers.boiler_description(constants.steel.pipeline_extent))
end

local fusion_reactor_mk2 = util.table.deepcopy(fusion_reactor)
fusion_reactor_mk2.name = "aer_fusion-reactor-2"
fusion_reactor_mk2.minable.result = "aer_fusion-reactor-2"
fusion_reactor_mk2.next_upgrade = nil
fusion_reactor_mk2.power_input = "30MW"
fusion_reactor_mk2.max_fluid_usage = 8 / 60
fusion_reactor_mk2.max_health = 2000
fluid_helpers.set_prototype_fluid_boxes_extent(fusion_reactor_mk2, constants.foundation.pipeline_extent)
fluid_helpers.set_description(fusion_reactor_mk2, fluid_helpers.boiler_description(constants.foundation.pipeline_extent))
fluid_helpers.set_resistances(fusion_reactor_mk2, constants.foundation.resistances)
fluid_helpers.apply_foundation_icon_tint(fusion_reactor_mk2)
fluid_helpers.apply_foundation_entity_tint(fusion_reactor_mk2)

local fusion_generator_mk2 = util.table.deepcopy(fusion_generator)
fusion_generator_mk2.name = "aer_fusion-generator-2"
fusion_generator_mk2.minable.result = "aer_fusion-generator-2"
fusion_generator_mk2.next_upgrade = nil
fusion_generator_mk2.energy_source.output_flow_limit = "125MW"
fusion_generator_mk2.max_fluid_usage = 4 / 60
fusion_generator_mk2.max_health = 2000
fluid_helpers.set_prototype_fluid_boxes_extent(fusion_generator_mk2, constants.foundation.pipeline_extent)
fluid_helpers.set_description(fusion_generator_mk2, fluid_helpers.boiler_description(constants.foundation.pipeline_extent))
fluid_helpers.set_resistances(fusion_generator_mk2, constants.foundation.resistances)
fluid_helpers.apply_foundation_icon_tint(fusion_generator_mk2)
fluid_helpers.apply_foundation_entity_tint(fusion_generator_mk2)

data:extend({
  fusion_reactor_mk2,
  fusion_generator_mk2,
})
