local boiler_mk2 = util.table.deepcopy(data.raw.recipe["boiler"])
boiler_mk2.name = "aer_steel-boiler"
boiler_mk2.enabled = false
boiler_mk2.ingredients = {
  { type = "item", name = "boiler", amount = 1 },
  { type = "item", name = "steel-furnace", amount = 1 },
}
boiler_mk2.results = {
  { type = "item", name = "aer_steel-boiler", amount = 1 }
}
data:extend({boiler_mk2})

local boiler_mk3 = util.table.deepcopy(data.raw.recipe["boiler"])
boiler_mk3.name = "aer_rubber-lined-boiler"
boiler_mk3.enabled = false
boiler_mk3.category = "crafting-with-fluid"
boiler_mk3.ingredients = {
  { type = "item", name = "aer_steel-boiler", amount = 1 },
  { type = "item", name = "plastic-bar", amount = 10 },
  { type = "fluid", name = "lubricant", amount = 50 },
}
boiler_mk3.results = {
  { type = "item", name = "aer_rubber-lined-boiler", amount = 1 }
}
data:extend({boiler_mk3})

local boiler_mk4 = util.table.deepcopy(data.raw.recipe["boiler"])
boiler_mk4.name = "aer_holmium-reinforced-boiler"
boiler_mk4.enabled = false
boiler_mk4.category = "crafting-with-fluid"
boiler_mk4.ingredients = {
  { type = "item", name = "aer_rubber-lined-boiler", amount = 1 },
  { type = "item", name = "electric-furnace", amount = 5 },
  { type = "item", name = "superconductor", amount = 10 },
  { type = "fluid", name = "holmium-solution", amount = 100 },
}
boiler_mk4.results = {
  { type = "item", name = "aer_holmium-reinforced-boiler", amount = 1 }
}
data:extend({boiler_mk4})
