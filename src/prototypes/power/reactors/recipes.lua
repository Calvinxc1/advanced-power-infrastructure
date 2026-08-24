local reactor_mk2 = util.table.deepcopy(data.raw.recipe["nuclear-reactor"])
reactor_mk2.name = "aer_nuclear-reactor-2"
reactor_mk2.enabled = false
reactor_mk2.ingredients = {
  { type = "item", name = "nuclear-reactor", amount = 1 },
  { type = "item", name = "refined-concrete", amount = 500 },
  { type = "item", name = "steel-plate", amount = 250 },
  { type = "item", name = "advanced-circuit", amount = 250 },
  { type = "item", name = "processing-unit", amount = 50 },
}
reactor_mk2.results = {
  { type = "item", name = "aer_nuclear-reactor-2", amount = 1 }
}
data:extend({reactor_mk2})
