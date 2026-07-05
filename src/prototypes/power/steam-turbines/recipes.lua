data.raw.recipe["steam-turbine"].ingredients = {
  { type = "item", name = "iron-gear-wheel", amount = 50 },
  { type = "item", name = "copper-plate", amount = 50 },
  { type = "item", name = "aer_steel-pipe", amount = 20 },
}

local steam_turbine_mk2 = util.table.deepcopy(data.raw.recipe["steam-turbine"])
steam_turbine_mk2.name = "aer_rubber-lined-steam-turbine"
steam_turbine_mk2.enabled = false
steam_turbine_mk2.category = "crafting-with-fluid"
steam_turbine_mk2.ingredients = {
  { type = "item", name = "steam-turbine", amount = 1 },
  { type = "item", name = "aer_rubber-lined-pipe", amount = 20 },
  { type = "item", name = "aer_rubber-lined-pump", amount = 2 },
  { type = "item", name = "processing-unit", amount = 5 },
  { type = "fluid", name = "lubricant", amount = 100 },
}
steam_turbine_mk2.results = {
  { type = "item", name = "aer_rubber-lined-steam-turbine", amount = 1 }
}
data:extend({steam_turbine_mk2})

local steam_turbine_mk3 = util.table.deepcopy(data.raw.recipe["steam-turbine"])
steam_turbine_mk3.name = "aer_reinforced-steam-turbine"
steam_turbine_mk3.enabled = false
steam_turbine_mk3.ingredients = {
  { type = "item", name = "aer_rubber-lined-steam-turbine", amount = 1 },
  { type = "item", name = "aer_reinforced-pipe", amount = 20 },
  { type = "item", name = "aer_reinforced-pump", amount = 2 },
  { type = "item", name = "tungsten-plate", amount = 20 },
  { type = "item", name = "carbon-fiber", amount = 10 },
}
steam_turbine_mk3.results = {
  { type = "item", name = "aer_reinforced-steam-turbine", amount = 1 }
}
data:extend({steam_turbine_mk3})

local steam_turbine_mk4 = util.table.deepcopy(data.raw.recipe["steam-turbine"])
steam_turbine_mk4.name = "aer_foundation-steam-turbine"
steam_turbine_mk4.enabled = false
steam_turbine_mk4.ingredients = {
  { type = "item", name = "aer_reinforced-steam-turbine", amount = 1 },
  { type = "item", name = "aer_foundation-pipe", amount = 20 },
  { type = "item", name = "aer_foundation-pump", amount = 2 },
  { type = "item", name = "foundation", amount = 2 },
  { type = "item", name = "superconductor", amount = 10 },
}
steam_turbine_mk4.results = {
  { type = "item", name = "aer_foundation-steam-turbine", amount = 1 }
}
data:extend({steam_turbine_mk4})
