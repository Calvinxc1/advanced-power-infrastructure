
local boiler_mk2 = util.table.deepcopy(data.raw.technology["steel-processing"])
boiler_mk2.name = "aer_steel-boiler"
boiler_mk2.icon = "__advanced-power-infrastructure__/graphics/technology/steel-boilers.png"
boiler_mk2.icon_size = 256
boiler_mk2.icons = nil
boiler_mk2.prerequisites = {
  "afi_steel-pipe-infrastructure",
  "flammables",
}
boiler_mk2.effects = {
  { type = "unlock-recipe", recipe = "aer_steel-boiler" },
}
boiler_mk2.unit.count = 100
boiler_mk2.unit.ingredients = {
  {"automation-science-pack", 1},
  {"logistic-science-pack", 1},
}
boiler_mk2.unit.time = 30
boiler_mk2.upgrade = true
boiler_mk2.order = "[boiler]-1"
data:extend({boiler_mk2})

local boiler_mk3 = util.table.deepcopy(data.raw.technology["steel-processing"])
boiler_mk3.name = "aer_rubber-lined-boiler"
boiler_mk3.icon = "__advanced-power-infrastructure__/graphics/technology/rubber-lined-boilers.png"
boiler_mk3.icon_size = 256
boiler_mk3.icons = nil
boiler_mk3.prerequisites = {
  "afi_rubber-lined-pipe-infrastructure",
  "aer_steel-boiler",
  "lubricant",
  "chemical-science-pack",
  "production-science-pack",
}
boiler_mk3.effects = {
  { type = "unlock-recipe", recipe = "aer_rubber-lined-boiler" },
}
boiler_mk3.unit.count = 250
boiler_mk3.unit.ingredients = {
  {"automation-science-pack", 1},
  {"logistic-science-pack", 1},
  {"chemical-science-pack", 1},
  {"production-science-pack", 1},
}
boiler_mk3.unit.time = 30
boiler_mk3.upgrade = true
boiler_mk3.order = "[boiler]-2"
data:extend({boiler_mk3})

local boiler_mk4 = util.table.deepcopy(data.raw.technology["steel-processing"])
boiler_mk4.name = "aer_holmium-reinforced-boiler"
boiler_mk4.icon = "__advanced-power-infrastructure__/graphics/technology/holmium-reinforced-boilers.png"
boiler_mk4.icon_size = 256
boiler_mk4.icons = nil
boiler_mk4.prerequisites = {
  "aer_rubber-lined-boiler",
  "holmium-processing",
  "electromagnetic-science-pack",
}
boiler_mk4.effects = {
  { type = "unlock-recipe", recipe = "aer_holmium-reinforced-boiler" },
}
boiler_mk4.unit.count = 500
boiler_mk4.unit.ingredients = {
  {"automation-science-pack", 1},
  {"logistic-science-pack", 1},
  {"chemical-science-pack", 1},
  {"space-science-pack", 1},
  {"electromagnetic-science-pack", 1},
}
boiler_mk4.unit.time = 30
boiler_mk4.upgrade = true
boiler_mk4.order = "[boiler]-3"
data:extend({boiler_mk4})
