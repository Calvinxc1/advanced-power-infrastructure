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
boiler_mk3.categories = { "crafting-with-fluid" }
boiler_mk3.ingredients = {
  { type = "item", name = "aer_steel-boiler", amount = 1 },
  { type = "item", name = "plastic-bar", amount = 10 },
  { type = "fluid", name = "lubricant", amount = 50 },
}
boiler_mk3.results = {
  { type = "item", name = "aer_rubber-lined-boiler", amount = 1 }
}
data:extend({boiler_mk3})
