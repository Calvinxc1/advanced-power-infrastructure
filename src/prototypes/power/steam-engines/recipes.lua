local steam_engine_mk2 = util.table.deepcopy(data.raw.recipe["steam-engine"])
steam_engine_mk2.name = "aer_steel-steam-engine"
steam_engine_mk2.enabled = false
steam_engine_mk2.ingredients = {
  { type = "item", name = "steam-engine", amount = 1 },
  { type = "item", name = "steel-plate", amount = 5 },
  { type = "item", name = "copper-plate", amount = 10 },
  { type = "item", name = "electronic-circuit", amount = 5 },
}
steam_engine_mk2.results = {
  { type = "item", name = "aer_steel-steam-engine", amount = 1 }
}
-- steam_engine_mk2.expensive.enabled = false
-- steam_engine_mk2.expensive.ingredients =
-- {
--   {"steam-engine", 1},
--   {"steel-plate", 10},
--   {"copper-plate", 20},
--   {"electronic-circuit", 12}
-- }
-- steam_engine_mk2.expensive.result = "aer_steel-steam-engine"
data:extend({steam_engine_mk2})

local steam_engine_mk3 = util.table.deepcopy(data.raw.recipe["steam-engine"])
steam_engine_mk3.name = "aer_rubber-lined-steam-engine"
steam_engine_mk3.enabled = false
steam_engine_mk3.category = "crafting-with-fluid"
steam_engine_mk3.ingredients = {
  { type = "item", name = "aer_steel-steam-engine", amount = 1 },
  { type = "item", name = "advanced-circuit", amount = 5 },
  { type = "item", name = "plastic-bar", amount = 10 },
  { type = "fluid", name = "lubricant", amount = 50 },
}
steam_engine_mk3.results = {
  { type = "item", name = "aer_rubber-lined-steam-engine", amount = 1 }
}
-- steam_engine_mk3.expensive.enabled = false
-- steam_engine_mk3.expensive.ingredients =
-- {
--   {"aer_steel-steam-engine", 1},
--   {"advanced-circuit", 20},
--   {"steel-plate", 25},
--   {"iron-gear-wheel", 10},
-- }
-- steam_engine_mk3.expensive.result = "aer_rubber-lined-steam-engine"
data:extend({steam_engine_mk3})

local steam_engine_mk4 = util.table.deepcopy(data.raw.recipe["steam-engine"])
steam_engine_mk4.name = "aer_holmium-steam-engine"
steam_engine_mk4.enabled = false
steam_engine_mk4.ingredients = {
  { type = "item", name = "aer_rubber-lined-steam-engine", amount = 1 },
  { type = "item", name = "holmium-plate", amount = 10 },
  { type = "item", name = "superconductor", amount = 10 },
  { type = "item", name = "processing-unit", amount = 10 },
}
steam_engine_mk4.results = {
  { type = "item", name = "aer_holmium-steam-engine", amount = 1 }
}
-- steam_engine_mk4.expensive.enabled = false
-- steam_engine_mk4.expensive.result = "aer_holmium-steam-engine"
data:extend({steam_engine_mk4})
