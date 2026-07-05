local fusion_reactor_mk2 = util.table.deepcopy(data.raw.recipe["fusion-reactor"])
fusion_reactor_mk2.name = "aer_fusion-reactor-2"
fusion_reactor_mk2.enabled = false
fusion_reactor_mk2.energy_required = 90
fusion_reactor_mk2.ingredients = {
  { type = "item", name = "fusion-reactor", amount = 1 },
  { type = "item", name = "foundation", amount = 20 },
  { type = "item", name = "superconductor", amount = 400 },
  { type = "item", name = "quantum-processor", amount = 500 },
}
fusion_reactor_mk2.results = {
  { type = "item", name = "aer_fusion-reactor-2", amount = 1 },
}

local fusion_generator_mk2 = util.table.deepcopy(data.raw.recipe["fusion-generator"])
fusion_generator_mk2.name = "aer_fusion-generator-2"
fusion_generator_mk2.enabled = false
fusion_generator_mk2.energy_required = 45
fusion_generator_mk2.ingredients = {
  { type = "item", name = "fusion-generator", amount = 1 },
  { type = "item", name = "foundation", amount = 10 },
  { type = "item", name = "superconductor", amount = 200 },
  { type = "item", name = "quantum-processor", amount = 100 },
}
fusion_generator_mk2.results = {
  { type = "item", name = "aer_fusion-generator-2", amount = 1 },
}

data:extend({
  fusion_reactor_mk2,
  fusion_generator_mk2,
})
