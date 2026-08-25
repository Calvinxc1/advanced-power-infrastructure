
local optional_dependencies = require("prototypes.power.optional-dependencies")

local boiler_mk2 = util.table.deepcopy(data.raw.technology["steel-processing"])
boiler_mk2.name = "aer_steel-boiler"
boiler_mk2.icon = "__advanced-power-infrastructure__/graphics/technology/steel-boilers.png"
boiler_mk2.icon_size = 256
boiler_mk2.icons = nil
boiler_mk2.prerequisites = optional_dependencies.prerequisites(
  {
    "afi_steel-pipe-infrastructure",
    "flammables",
  },
  {
    "steel-processing",
    "flammables",
  }
)
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
boiler_mk3.prerequisites = optional_dependencies.prerequisites(
  {
    "afi_rubber-lined-pipe-infrastructure",
    "aer_steel-boiler",
    "lubricant",
    "chemical-science-pack",
    "production-science-pack",
  },
  {
    "aer_steel-boiler",
    "lubricant",
    "production-science-pack",
  }
)
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
