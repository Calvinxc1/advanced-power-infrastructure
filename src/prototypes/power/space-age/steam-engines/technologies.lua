-- Space Age steam engine tier. Its recipe needs holmium plate and
-- superconductor, neither of which has a base-game equivalent.

local steam_engine_mk4 = util.table.deepcopy(data.raw.technology["steel-processing"])
steam_engine_mk4.name = "aer_holmium-steam-engine"
steam_engine_mk4.icon = "__advanced-power-infrastructure__/graphics/technology/holmium-steam-engines.png"
steam_engine_mk4.icon_size = 256
steam_engine_mk4.icons = nil
steam_engine_mk4.prerequisites = {
  "aer_rubber-lined-steam-engine",
  "holmium-processing",
  "processing-unit",
  "electromagnetic-science-pack",
}
steam_engine_mk4.effects = {
  {type = "unlock-recipe", recipe = "aer_holmium-steam-engine"},
}
steam_engine_mk4.unit.count = 500
steam_engine_mk4.unit.ingredients = {
  {"automation-science-pack", 1},
  {"logistic-science-pack", 1},
  {"chemical-science-pack", 1},
  {"space-science-pack", 1},
  {"electromagnetic-science-pack", 1},
}
steam_engine_mk4.unit.time = 30
steam_engine_mk4.upgrade = true
steam_engine_mk4.order = "[steam]-3"
data:extend({steam_engine_mk4})
