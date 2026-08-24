-- Space Age heat exchanger tier. Its recipe needs foundation and
-- superconductor. The tier below it survives a base-game load by substituting
-- refined concrete and low-density structure.

local optional_dependencies = require("prototypes.power.optional-dependencies")

local heat_exchanger_mk4 = util.table.deepcopy(data.raw.technology["nuclear-power"])
heat_exchanger_mk4.name = "aer_heat-exchanger-4"
heat_exchanger_mk4.localised_name = {"technology-name.aer_heat-exchanger-4"}
heat_exchanger_mk4.icon = "__advanced-power-infrastructure__/graphics/technology/foundation-heat-exchangers.png"
heat_exchanger_mk4.icon_size = 256
heat_exchanger_mk4.icons = nil
heat_exchanger_mk4.prerequisites = optional_dependencies.prerequisites(
  {
    "aer_heat-exchanger-3",
    "afi_foundation-pipe-infrastructure",
  },
  {
    "aer_heat-exchanger-3",
    "foundation",
  }
)
heat_exchanger_mk4.effects = {
  { type = "unlock-recipe", recipe = "aer_heat-exchanger-4" },
}
heat_exchanger_mk4.unit.count = 5000
heat_exchanger_mk4.unit.ingredients = {
  {"automation-science-pack", 1},
  {"logistic-science-pack", 1},
  {"chemical-science-pack", 1},
  {"space-science-pack", 1},
  {"production-science-pack", 1},
  {"utility-science-pack", 1},
  {"metallurgic-science-pack", 1},
  {"agricultural-science-pack", 1},
  {"electromagnetic-science-pack", 1},
  {"cryogenic-science-pack", 1},
}
heat_exchanger_mk4.unit.time = 30
heat_exchanger_mk4.upgrade = true
heat_exchanger_mk4.order = "e-p-b-f"
data:extend({heat_exchanger_mk4})
