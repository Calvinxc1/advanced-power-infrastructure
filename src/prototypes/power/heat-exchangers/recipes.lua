data.raw.recipe["heat-exchanger"].ingredients = {
  { type = "item", name = "steel-plate", amount = 10 },
  { type = "item", name = "copper-plate", amount = 20 },
  { type = "item", name = "aer_steel-pipe", amount = 10 },
}

local heat_exchanger_mk2 = util.table.deepcopy(data.raw.recipe["heat-exchanger"])
heat_exchanger_mk2.name = "aer_heat-exchanger-2"
heat_exchanger_mk2.enabled = false
heat_exchanger_mk2.category = "crafting-with-fluid"
heat_exchanger_mk2.ingredients = {
  { type = "item", name = "heat-exchanger", amount = 1 },
  { type = "item", name = "aer_rubber-lined-pipe", amount = 10 },
  { type = "item", name = "processing-unit", amount = 2 },
  { type = "fluid", name = "lubricant", amount = 50 },
}
heat_exchanger_mk2.results = {
  { type = "item", name = "aer_heat-exchanger-2", amount = 1 }
}
data:extend({heat_exchanger_mk2})

local heat_exchanger_mk3 = util.table.deepcopy(data.raw.recipe["heat-exchanger"])
heat_exchanger_mk3.name = "aer_heat-exchanger-3"
heat_exchanger_mk3.enabled = false
heat_exchanger_mk3.ingredients = {
  { type = "item", name = "aer_heat-exchanger-2", amount = 1 },
  { type = "item", name = "aer_reinforced-pipe", amount = 10 },
  { type = "item", name = "tungsten-plate", amount = 50 },
  { type = "item", name = "carbon-fiber", amount = 10 },
}
heat_exchanger_mk3.results = {
  { type = "item", name = "aer_heat-exchanger-3", amount = 1 }
}
data:extend({heat_exchanger_mk3})

local heat_exchanger_mk4 = util.table.deepcopy(data.raw.recipe["heat-exchanger"])
heat_exchanger_mk4.name = "aer_heat-exchanger-4"
heat_exchanger_mk4.enabled = false
heat_exchanger_mk4.ingredients = {
  { type = "item", name = "aer_heat-exchanger-3", amount = 1 },
  { type = "item", name = "aer_foundation-pipe", amount = 10 },
  { type = "item", name = "foundation", amount = 2 },
  { type = "item", name = "carbon-fiber", amount = 20 },
  { type = "item", name = "superconductor", amount = 10 },
}
heat_exchanger_mk4.results = {
  { type = "item", name = "aer_heat-exchanger-4", amount = 1 }
}
data:extend({heat_exchanger_mk4})
