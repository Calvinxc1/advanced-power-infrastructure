local optional_dependencies = require("prototypes.power.optional-dependencies")

data.raw.recipe["heat-exchanger"].ingredients = optional_dependencies.ingredients(
  optional_dependencies.item("steel-plate", 10),
  optional_dependencies.item("copper-plate", 20),
  optional_dependencies.pipe_ingredients("steel", 10)
)

local heat_exchanger_mk2 = util.table.deepcopy(data.raw.recipe["heat-exchanger"])
heat_exchanger_mk2.name = "aer_heat-exchanger-2"
heat_exchanger_mk2.enabled = false
heat_exchanger_mk2.category = "crafting-with-fluid"
heat_exchanger_mk2.ingredients = optional_dependencies.ingredients(
  optional_dependencies.item("heat-exchanger", 1),
  optional_dependencies.pipe_ingredients("rubber-lined", 10),
  optional_dependencies.item("processing-unit", 2),
  optional_dependencies.fluid("lubricant", 50)
)
heat_exchanger_mk2.results = {
  { type = "item", name = "aer_heat-exchanger-2", amount = 1 }
}
data:extend({heat_exchanger_mk2})

local heat_exchanger_mk3 = util.table.deepcopy(data.raw.recipe["heat-exchanger"])
heat_exchanger_mk3.name = "aer_heat-exchanger-3"
heat_exchanger_mk3.enabled = false
heat_exchanger_mk3.ingredients = optional_dependencies.ingredients(
  optional_dependencies.item("aer_heat-exchanger-2", 1),
  optional_dependencies.pipe_ingredients("reinforced", 10),
  optional_dependencies.item("tungsten-plate", 50),
  optional_dependencies.item("carbon-fiber", 10)
)
heat_exchanger_mk3.results = {
  { type = "item", name = "aer_heat-exchanger-3", amount = 1 }
}
data:extend({heat_exchanger_mk3})

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
