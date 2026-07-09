local optional_dependencies = require("prototypes.power.optional-dependencies")

data.raw.recipe["steam-turbine"].ingredients = optional_dependencies.ingredients(
  optional_dependencies.item("iron-gear-wheel", 50),
  optional_dependencies.item("copper-plate", 50),
  optional_dependencies.pipe_ingredients("steel", 20)
)

local steam_turbine_mk2 = util.table.deepcopy(data.raw.recipe["steam-turbine"])
steam_turbine_mk2.name = "aer_rubber-lined-steam-turbine"
steam_turbine_mk2.enabled = false
steam_turbine_mk2.categories = { "crafting-with-fluid" }
steam_turbine_mk2.ingredients = optional_dependencies.ingredients(
  optional_dependencies.item("steam-turbine", 1),
  optional_dependencies.pipe_ingredients("rubber-lined", 20),
  optional_dependencies.pump_ingredients("rubber-lined", 2),
  optional_dependencies.item("processing-unit", 5),
  optional_dependencies.fluid("lubricant", 100)
)
steam_turbine_mk2.results = {
  { type = "item", name = "aer_rubber-lined-steam-turbine", amount = 1 }
}
data:extend({steam_turbine_mk2})

local steam_turbine_mk3 = util.table.deepcopy(data.raw.recipe["steam-turbine"])
steam_turbine_mk3.name = "aer_reinforced-steam-turbine"
steam_turbine_mk3.enabled = false
steam_turbine_mk3.ingredients = optional_dependencies.ingredients(
  optional_dependencies.item("aer_rubber-lined-steam-turbine", 1),
  optional_dependencies.pipe_ingredients("reinforced", 20),
  optional_dependencies.pump_ingredients("reinforced", 2),
  optional_dependencies.item("tungsten-plate", 20),
  optional_dependencies.item("carbon-fiber", 10)
)
steam_turbine_mk3.results = {
  { type = "item", name = "aer_reinforced-steam-turbine", amount = 1 }
}
data:extend({steam_turbine_mk3})

local steam_turbine_mk4 = util.table.deepcopy(data.raw.recipe["steam-turbine"])
steam_turbine_mk4.name = "aer_foundation-steam-turbine"
steam_turbine_mk4.enabled = false
steam_turbine_mk4.ingredients = optional_dependencies.ingredients(
  optional_dependencies.item("aer_reinforced-steam-turbine", 1),
  optional_dependencies.pipe_ingredients("foundation", 20),
  optional_dependencies.pump_ingredients("foundation", 2),
  optional_dependencies.item("foundation", 2),
  optional_dependencies.item("superconductor", 10)
)
steam_turbine_mk4.results = {
  { type = "item", name = "aer_foundation-steam-turbine", amount = 1 }
}
data:extend({steam_turbine_mk4})
