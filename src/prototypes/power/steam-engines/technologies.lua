local steam_engine_mk2 = util.table.deepcopy(data.raw.technology["steel-processing"])
steam_engine_mk2.name = "aer_steel-steam-engine"
steam_engine_mk2.icon = "__advanced-power-infrastructure__/graphics/technology/steel-steam-engines.png"
steam_engine_mk2.icon_size = 256
steam_engine_mk2.icons = nil
steam_engine_mk2.prerequisites = {
  "aer_steel-pump-infrastructure",
  "flammables",
}
steam_engine_mk2.effects ={
  {type = "unlock-recipe", recipe = "aer_steel-steam-engine"},
}
steam_engine_mk2.unit.count = 100
steam_engine_mk2.unit.ingredients = {
  {"automation-science-pack", 1},
  {"logistic-science-pack", 1},
}
steam_engine_mk2.unit.time = 30
steam_engine_mk2.upgrade = true
steam_engine_mk2.order = "[steam]-1"
data:extend({steam_engine_mk2})

local steam_engine_mk3 = util.table.deepcopy(data.raw.technology["steel-processing"])
steam_engine_mk3.name = "aer_rubber-lined-steam-engine"
steam_engine_mk3.icon = "__advanced-power-infrastructure__/graphics/technology/rubber-lined-steam-engines.png"
steam_engine_mk3.icon_size = 256
steam_engine_mk3.icons = nil
steam_engine_mk3.prerequisites = {
  "aer_rubber-lined-pump-infrastructure",
  "aer_steel-steam-engine",
  "lubricant",
  "chemical-science-pack",
  "production-science-pack",
}
steam_engine_mk3.effects = {
  {type = "unlock-recipe", recipe = "aer_rubber-lined-steam-engine"},
}
steam_engine_mk3.unit.count = 250
steam_engine_mk3.unit.ingredients = {
  {"automation-science-pack", 1},
  {"logistic-science-pack", 1},
  {"chemical-science-pack", 1},
  {"production-science-pack", 1},
}
steam_engine_mk3.unit.time = 30
steam_engine_mk3.upgrade = true
steam_engine_mk3.order = "[steam]-2"
data:extend({steam_engine_mk3})

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
