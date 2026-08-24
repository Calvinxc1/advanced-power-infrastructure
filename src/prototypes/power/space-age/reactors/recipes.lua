-- Space Age reactor tiers. Both need holmium plate, and the top tier also
-- needs lithium plate, so neither has a base-game form.

local reactor_mk3 = util.table.deepcopy(data.raw.recipe["nuclear-reactor"])
reactor_mk3.name = "aer_nuclear-reactor-3"
reactor_mk3.enabled = false
reactor_mk3.ingredients = {
  { type = "item", name = "aer_nuclear-reactor-2", amount = 1 },
  { type = "item", name = "tungsten-plate", amount = 100 },
  { type = "item", name = "holmium-plate", amount = 50 },
  { type = "item", name = "supercapacitor", amount = 25 },
  { type = "item", name = "processing-unit", amount = 100 },
}
reactor_mk3.results = {
  { type = "item", name = "aer_nuclear-reactor-3", amount = 1 }
}
data:extend({reactor_mk3})
local reactor_mk4 = util.table.deepcopy(data.raw.recipe["nuclear-reactor"])
reactor_mk4.name = "aer_nuclear-reactor-4"
reactor_mk4.enabled = false
reactor_mk4.ingredients = {
  { type = "item", name = "aer_nuclear-reactor-3", amount = 1 },
  { type = "item", name = "lithium-plate", amount = 200 },
  { type = "item", name = "superconductor", amount = 100 },
  { type = "item", name = "tungsten-plate", amount = 250 },
}
reactor_mk4.results = {
  { type = "item", name = "aer_nuclear-reactor-4", amount = 1 }
}
data:extend({reactor_mk4})
