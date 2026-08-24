local constants = require("prototypes.power.fluid-constants")
local fluid_helpers = require("prototypes.power.fluid-helpers")

local fusion_reactor = data.raw.item["fusion-reactor"]
fusion_reactor.subgroup = "aer_fusion-power"
fusion_reactor.order = "a[fusion-reactor-1]"
fusion_reactor.localised_description = fluid_helpers.boiler_description(constants.steel.pipeline_extent)

local fusion_generator = data.raw.item["fusion-generator"]
fusion_generator.subgroup = "aer_fusion-power"
fusion_generator.order = "b[fusion-generator-1]"
fusion_generator.localised_description = fluid_helpers.boiler_description(constants.steel.pipeline_extent)

local fusion_reactor_mk2 = util.table.deepcopy(fusion_reactor)
fusion_reactor_mk2.name = "aer_fusion-reactor-2"
fusion_reactor_mk2.order = "a[fusion-reactor-2]"
fusion_reactor_mk2.place_result = "aer_fusion-reactor-2"
fusion_reactor_mk2.localised_description = fluid_helpers.boiler_description(constants.foundation.pipeline_extent)
fluid_helpers.apply_foundation_icon_tint(fusion_reactor_mk2)

local fusion_generator_mk2 = util.table.deepcopy(fusion_generator)
fusion_generator_mk2.name = "aer_fusion-generator-2"
fusion_generator_mk2.order = "b[fusion-generator-2]"
fusion_generator_mk2.place_result = "aer_fusion-generator-2"
fusion_generator_mk2.localised_description = fluid_helpers.boiler_description(constants.foundation.pipeline_extent)
fluid_helpers.apply_foundation_icon_tint(fusion_generator_mk2)

data:extend({
  fusion_reactor_mk2,
  fusion_generator_mk2,
})
