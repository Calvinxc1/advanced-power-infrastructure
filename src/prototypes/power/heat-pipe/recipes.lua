local heat_pipe_mk2 = util.table.deepcopy(data.raw.recipe["heat-pipe"])
heat_pipe_mk2.name = "aer_heat-pipe-2"
heat_pipe_mk2.enabled = false
heat_pipe_mk2.categories = { "crafting-with-fluid" }
heat_pipe_mk2.ingredients = {
  { type = "item", name = "heat-pipe", amount = 1 },
  { type = "item", name = "steel-plate", amount = 10 },
  { type = "item", name = "copper-plate", amount = 20 },
  { type = "fluid", name = "lubricant", amount = 25 },
}
heat_pipe_mk2.results = {
  { type = "item", name = "aer_heat-pipe-2", amount = 1 },
}
data:extend({ heat_pipe_mk2 })
