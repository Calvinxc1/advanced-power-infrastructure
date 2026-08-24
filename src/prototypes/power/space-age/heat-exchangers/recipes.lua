-- Space Age heat exchanger tier. Its recipe needs foundation and
-- superconductor. The tier below it survives a base-game load by substituting
-- refined concrete and low-density structure.

local optional_dependencies = require("prototypes.power.optional-dependencies")

local heat_exchanger_mk4 = util.table.deepcopy(data.raw.recipe["heat-exchanger"])
heat_exchanger_mk4.name = "aer_heat-exchanger-4"
heat_exchanger_mk4.enabled = false
heat_exchanger_mk4.ingredients = optional_dependencies.ingredients(
  optional_dependencies.item("aer_heat-exchanger-3", 1),
  optional_dependencies.pipe_ingredients("foundation", 10),
  optional_dependencies.item("foundation", 2),
  optional_dependencies.item("carbon-fiber", 20),
  optional_dependencies.item("superconductor", 10)
)
heat_exchanger_mk4.results = {
  { type = "item", name = "aer_heat-exchanger-4", amount = 1 }
}
data:extend({heat_exchanger_mk4})
