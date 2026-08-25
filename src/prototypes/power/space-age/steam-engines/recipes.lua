-- Space Age steam engine tier. Its recipe needs holmium plate and
-- superconductor, neither of which has a base-game equivalent.

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
