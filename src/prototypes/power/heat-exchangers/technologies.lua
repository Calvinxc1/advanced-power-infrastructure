
local optional_dependencies = require("prototypes.power.optional-dependencies")

local heat_exchanger_mk2 = util.table.deepcopy(data.raw.technology["nuclear-power"])
heat_exchanger_mk2.name = "aer_heat-exchanger-2"
heat_exchanger_mk2.localised_name = {"technology-name.aer_heat-exchanger-2"}
heat_exchanger_mk2.icon = "__advanced-power-infrastructure__/graphics/technology/rubber-lined-heat-exchangers.png"
heat_exchanger_mk2.icon_size = 256
heat_exchanger_mk2.icons = nil
heat_exchanger_mk2.prerequisites = optional_dependencies.prerequisites(
  {
    "nuclear-power",
    "afi_rubber-lined-pipe-infrastructure",
    "production-science-pack",
    "utility-science-pack",
  },
  {
    "nuclear-power",
    "lubricant",
    "production-science-pack",
    "utility-science-pack",
  }
)
heat_exchanger_mk2.effects = {
  { type = "unlock-recipe", recipe = "aer_heat-exchanger-2" },
}
heat_exchanger_mk2.unit.count = 1000
heat_exchanger_mk2.unit.ingredients = {
  {"automation-science-pack", 1},
  {"logistic-science-pack", 1},
  {"chemical-science-pack", 1},
  {"production-science-pack", 1},
  {"utility-science-pack", 1}
}
heat_exchanger_mk2.unit.time = 30
heat_exchanger_mk2.upgrade = true
heat_exchanger_mk2.order = "e-p-b-d"
data:extend({heat_exchanger_mk2})

local heat_exchanger_mk3 = util.table.deepcopy(data.raw.technology["nuclear-power"])
heat_exchanger_mk3.name = "aer_heat-exchanger-3"
heat_exchanger_mk3.localised_name = {"technology-name.aer_heat-exchanger-3"}
heat_exchanger_mk3.icon = "__advanced-power-infrastructure__/graphics/technology/reinforced-heat-exchangers.png"
heat_exchanger_mk3.icon_size = 256
heat_exchanger_mk3.icons = nil
-- The two optional dependencies are independent axes: Advanced Fluid
-- Infrastructure decides whether the pipe tier is named as a prerequisite,
-- Space Age decides which science gates the tier.
heat_exchanger_mk3.prerequisites = optional_dependencies.concat(
  optional_dependencies.prerequisites(
    {
      "aer_heat-exchanger-2",
      "afi_reinforced-pipe-infrastructure",
    },
    {
      "aer_heat-exchanger-2",
    }
  ),
  optional_dependencies.reinforced_science_prerequisites()
)
heat_exchanger_mk3.effects = {
  { type = "unlock-recipe", recipe = "aer_heat-exchanger-3" },
}
heat_exchanger_mk3.unit.count = 2500
heat_exchanger_mk3.unit.ingredients = optional_dependencies.reinforced_unit_ingredients()
heat_exchanger_mk3.unit.time = 30
heat_exchanger_mk3.upgrade = true
heat_exchanger_mk3.order = "e-p-b-e"
data:extend({heat_exchanger_mk3})
