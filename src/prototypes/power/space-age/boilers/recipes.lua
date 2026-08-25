-- Space Age boiler tier. Its recipe needs superconductor, and its research
-- is gated on electromagnetic science, so it has no base-game form.

local boiler_mk4 = util.table.deepcopy(data.raw.recipe["boiler"])
boiler_mk4.name = "aer_holmium-reinforced-boiler"
boiler_mk4.enabled = false
boiler_mk4.categories = { "crafting-with-fluid" }
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
