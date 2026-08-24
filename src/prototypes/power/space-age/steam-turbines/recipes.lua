-- Space Age steam turbine tier. Its recipe needs foundation and
-- superconductor. The reinforced tier below it survives a base-game load by
-- substituting refined concrete and low-density structure.

local optional_dependencies = require("prototypes.power.optional-dependencies")

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
