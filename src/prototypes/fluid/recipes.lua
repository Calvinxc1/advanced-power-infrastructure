local steel_pipe_recipe = util.table.deepcopy(data.raw.recipe.pipe)
steel_pipe_recipe.name = "aer_steel-pipe"
steel_pipe_recipe.enabled = false
steel_pipe_recipe.ingredients = {
  { type = "item", name = "pipe", amount = 1 },
  { type = "item", name = "steel-plate", amount = 1 },
}
steel_pipe_recipe.results = {
  { type = "item", name = "aer_steel-pipe", amount = 1 },
}
data:extend({ steel_pipe_recipe })

local steel_pipe_to_ground_recipe = util.table.deepcopy(data.raw.recipe["pipe-to-ground"])
steel_pipe_to_ground_recipe.name = "aer_steel-pipe-to-ground"
steel_pipe_to_ground_recipe.enabled = false
steel_pipe_to_ground_recipe.ingredients = {
  { type = "item", name = "pipe-to-ground", amount = 2 },
  { type = "item", name = "steel-plate", amount = 4 },
}
steel_pipe_to_ground_recipe.results = {
  { type = "item", name = "aer_steel-pipe-to-ground", amount = 2 },
}
data:extend({ steel_pipe_to_ground_recipe })

local steel_offshore_pump_recipe = util.table.deepcopy(data.raw.recipe["offshore-pump"])
steel_offshore_pump_recipe.name = "aer_steel-offshore-pump"
steel_offshore_pump_recipe.enabled = false
steel_offshore_pump_recipe.ingredients = {
  { type = "item", name = "offshore-pump", amount = 1 },
  { type = "item", name = "steel-plate", amount = 5 },
  { type = "item", name = "engine-unit", amount = 1 },
}
steel_offshore_pump_recipe.results = {
  { type = "item", name = "aer_steel-offshore-pump", amount = 1 },
}
data:extend({ steel_offshore_pump_recipe })

local steel_pump_recipe = util.table.deepcopy(data.raw.recipe.pump)
steel_pump_recipe.name = "aer_steel-pump"
steel_pump_recipe.enabled = false
steel_pump_recipe.ingredients = {
  { type = "item", name = "pump", amount = 1 },
  { type = "item", name = "steel-plate", amount = 5 },
  { type = "item", name = "engine-unit", amount = 1 },
}
steel_pump_recipe.results = {
  { type = "item", name = "aer_steel-pump", amount = 1 },
}
data:extend({ steel_pump_recipe })

local low_pressure_steel_pipe_recipe = util.table.deepcopy(data.raw.recipe.pipe)
low_pressure_steel_pipe_recipe.name = "aer_low-pressure-steel-pipe"
low_pressure_steel_pipe_recipe.enabled = false
low_pressure_steel_pipe_recipe.ingredients = {
  { type = "item", name = "aer_steel-pipe", amount = 5 },
  { type = "item", name = "low-density-structure", amount = 1 },
}
low_pressure_steel_pipe_recipe.results = {
  { type = "item", name = "aer_low-pressure-steel-pipe", amount = 5 },
}
data:extend({ low_pressure_steel_pipe_recipe })

local low_pressure_steel_pipe_to_ground_recipe = util.table.deepcopy(data.raw.recipe["pipe-to-ground"])
low_pressure_steel_pipe_to_ground_recipe.name = "aer_low-pressure-steel-pipe-to-ground"
low_pressure_steel_pipe_to_ground_recipe.enabled = false
low_pressure_steel_pipe_to_ground_recipe.ingredients = {
  { type = "item", name = "aer_steel-pipe-to-ground", amount = 2 },
  { type = "item", name = "low-density-structure", amount = 1 },
}
low_pressure_steel_pipe_to_ground_recipe.results = {
  { type = "item", name = "aer_low-pressure-steel-pipe-to-ground", amount = 2 },
}
data:extend({ low_pressure_steel_pipe_to_ground_recipe })

local low_pressure_steel_pump_recipe = util.table.deepcopy(data.raw.recipe.pump)
low_pressure_steel_pump_recipe.name = "aer_low-pressure-steel-pump"
low_pressure_steel_pump_recipe.enabled = false
low_pressure_steel_pump_recipe.ingredients = {
  { type = "item", name = "aer_steel-pump", amount = 1 },
  { type = "item", name = "low-density-structure", amount = 1 },
}
low_pressure_steel_pump_recipe.results = {
  { type = "item", name = "aer_low-pressure-steel-pump", amount = 1 },
}
data:extend({ low_pressure_steel_pump_recipe })

local heat_resistant_pipe_recipe = util.table.deepcopy(data.raw.recipe.pipe)
heat_resistant_pipe_recipe.name = "aer_heat-resistant-pipe"
heat_resistant_pipe_recipe.enabled = false
heat_resistant_pipe_recipe.ingredients = {
  { type = "item", name = "aer_steel-pipe", amount = 1 },
  { type = "item", name = "calcite", amount = 1 },
}
heat_resistant_pipe_recipe.results = {
  { type = "item", name = "aer_heat-resistant-pipe", amount = 1 },
}
data:extend({ heat_resistant_pipe_recipe })

local heat_resistant_pipe_to_ground_recipe = util.table.deepcopy(data.raw.recipe["pipe-to-ground"])
heat_resistant_pipe_to_ground_recipe.name = "aer_heat-resistant-pipe-to-ground"
heat_resistant_pipe_to_ground_recipe.enabled = false
heat_resistant_pipe_to_ground_recipe.ingredients = {
  { type = "item", name = "aer_steel-pipe-to-ground", amount = 2 },
  { type = "item", name = "calcite", amount = 2 },
}
heat_resistant_pipe_to_ground_recipe.results = {
  { type = "item", name = "aer_heat-resistant-pipe-to-ground", amount = 2 },
}
data:extend({ heat_resistant_pipe_to_ground_recipe })

local heat_resistant_pump_recipe = util.table.deepcopy(data.raw.recipe.pump)
heat_resistant_pump_recipe.name = "aer_heat-resistant-pump"
heat_resistant_pump_recipe.enabled = false
heat_resistant_pump_recipe.ingredients = {
  { type = "item", name = "aer_steel-pump", amount = 1 },
  { type = "item", name = "calcite", amount = 2 },
}
heat_resistant_pump_recipe.results = {
  { type = "item", name = "aer_heat-resistant-pump", amount = 1 },
}
data:extend({ heat_resistant_pump_recipe })

local tungsten_pipe_recipe = util.table.deepcopy(data.raw.recipe.pipe)
tungsten_pipe_recipe.name = "aer_tungsten-pipe"
tungsten_pipe_recipe.enabled = false
tungsten_pipe_recipe.ingredients = {
  { type = "item", name = "aer_heat-resistant-pipe", amount = 1 },
  { type = "item", name = "tungsten-plate", amount = 1 },
}
tungsten_pipe_recipe.results = {
  { type = "item", name = "aer_tungsten-pipe", amount = 1 },
}
data:extend({ tungsten_pipe_recipe })

local tungsten_pipe_to_ground_recipe = util.table.deepcopy(data.raw.recipe["pipe-to-ground"])
tungsten_pipe_to_ground_recipe.name = "aer_tungsten-pipe-to-ground"
tungsten_pipe_to_ground_recipe.enabled = false
tungsten_pipe_to_ground_recipe.ingredients = {
  { type = "item", name = "aer_heat-resistant-pipe-to-ground", amount = 2 },
  { type = "item", name = "tungsten-plate", amount = 2 },
}
tungsten_pipe_to_ground_recipe.results = {
  { type = "item", name = "aer_tungsten-pipe-to-ground", amount = 2 },
}
data:extend({ tungsten_pipe_to_ground_recipe })

local tungsten_pump_recipe = util.table.deepcopy(data.raw.recipe.pump)
tungsten_pump_recipe.name = "aer_tungsten-pump"
tungsten_pump_recipe.enabled = false
tungsten_pump_recipe.ingredients = {
  { type = "item", name = "aer_heat-resistant-pump", amount = 1 },
  { type = "item", name = "tungsten-plate", amount = 5 },
}
tungsten_pump_recipe.results = {
  { type = "item", name = "aer_tungsten-pump", amount = 1 },
}
data:extend({ tungsten_pump_recipe })

local tungsten_offshore_pump_recipe = util.table.deepcopy(data.raw.recipe["offshore-pump"])
tungsten_offshore_pump_recipe.name = "aer_tungsten-offshore-pump"
tungsten_offshore_pump_recipe.enabled = false
tungsten_offshore_pump_recipe.ingredients = {
  { type = "item", name = "aer_steel-offshore-pump", amount = 1 },
  { type = "item", name = "tungsten-plate", amount = 5 },
}
tungsten_offshore_pump_recipe.results = {
  { type = "item", name = "aer_tungsten-offshore-pump", amount = 1 },
}
data:extend({ tungsten_offshore_pump_recipe })

local rubber_lined_pipe_recipe = util.table.deepcopy(data.raw.recipe.pipe)
rubber_lined_pipe_recipe.name = "aer_rubber-lined-pipe"
rubber_lined_pipe_recipe.enabled = false
rubber_lined_pipe_recipe.category = "crafting-with-fluid"
rubber_lined_pipe_recipe.ingredients = {
  { type = "item", name = "aer_steel-pipe", amount = 1 },
  { type = "item", name = "plastic-bar", amount = 1 },
  { type = "fluid", name = "lubricant", amount = 5 },
}
rubber_lined_pipe_recipe.results = {
  { type = "item", name = "aer_rubber-lined-pipe", amount = 1 },
}
data:extend({ rubber_lined_pipe_recipe })

local rubber_lined_pipe_to_ground_recipe = util.table.deepcopy(data.raw.recipe["pipe-to-ground"])
rubber_lined_pipe_to_ground_recipe.name = "aer_rubber-lined-pipe-to-ground"
rubber_lined_pipe_to_ground_recipe.enabled = false
rubber_lined_pipe_to_ground_recipe.category = "crafting-with-fluid"
rubber_lined_pipe_to_ground_recipe.ingredients = {
  { type = "item", name = "aer_steel-pipe-to-ground", amount = 2 },
  { type = "item", name = "plastic-bar", amount = 4 },
  { type = "fluid", name = "lubricant", amount = 20 },
}
rubber_lined_pipe_to_ground_recipe.results = {
  { type = "item", name = "aer_rubber-lined-pipe-to-ground", amount = 2 },
}
data:extend({ rubber_lined_pipe_to_ground_recipe })

local rubber_lined_offshore_pump_recipe = util.table.deepcopy(data.raw.recipe["offshore-pump"])
rubber_lined_offshore_pump_recipe.name = "aer_rubber-lined-offshore-pump"
rubber_lined_offshore_pump_recipe.enabled = false
rubber_lined_offshore_pump_recipe.category = "crafting-with-fluid"
rubber_lined_offshore_pump_recipe.ingredients = {
  { type = "item", name = "aer_steel-offshore-pump", amount = 1 },
  { type = "item", name = "plastic-bar", amount = 5 },
  { type = "fluid", name = "lubricant", amount = 30 },
}
rubber_lined_offshore_pump_recipe.results = {
  { type = "item", name = "aer_rubber-lined-offshore-pump", amount = 1 },
}
data:extend({ rubber_lined_offshore_pump_recipe })

local rubber_lined_pump_recipe = util.table.deepcopy(data.raw.recipe.pump)
rubber_lined_pump_recipe.name = "aer_rubber-lined-pump"
rubber_lined_pump_recipe.enabled = false
rubber_lined_pump_recipe.category = "crafting-with-fluid"
rubber_lined_pump_recipe.ingredients = {
  { type = "item", name = "aer_steel-pump", amount = 1 },
  { type = "item", name = "plastic-bar", amount = 5 },
  { type = "fluid", name = "lubricant", amount = 30 },
}
rubber_lined_pump_recipe.results = {
  { type = "item", name = "aer_rubber-lined-pump", amount = 1 },
}
data:extend({ rubber_lined_pump_recipe })

local reinforced_pipe_recipe = util.table.deepcopy(data.raw.recipe.pipe)
reinforced_pipe_recipe.name = "aer_reinforced-pipe"
reinforced_pipe_recipe.enabled = false
reinforced_pipe_recipe.ingredients = {
  { type = "item", name = "aer_rubber-lined-pipe", amount = 1 },
  { type = "item", name = "tungsten-plate", amount = 1 },
  { type = "item", name = "carbon-fiber", amount = 1 },
}
reinforced_pipe_recipe.results = {
  { type = "item", name = "aer_reinforced-pipe", amount = 1 },
}
data:extend({ reinforced_pipe_recipe })

local reinforced_pipe_to_ground_recipe = util.table.deepcopy(data.raw.recipe["pipe-to-ground"])
reinforced_pipe_to_ground_recipe.name = "aer_reinforced-pipe-to-ground"
reinforced_pipe_to_ground_recipe.enabled = false
reinforced_pipe_to_ground_recipe.ingredients = {
  { type = "item", name = "aer_rubber-lined-pipe-to-ground", amount = 2 },
  { type = "item", name = "tungsten-plate", amount = 4 },
  { type = "item", name = "carbon-fiber", amount = 4 },
}
reinforced_pipe_to_ground_recipe.results = {
  { type = "item", name = "aer_reinforced-pipe-to-ground", amount = 2 },
}
data:extend({ reinforced_pipe_to_ground_recipe })

local reinforced_offshore_pump_recipe = util.table.deepcopy(data.raw.recipe["offshore-pump"])
reinforced_offshore_pump_recipe.name = "aer_reinforced-offshore-pump"
reinforced_offshore_pump_recipe.enabled = false
reinforced_offshore_pump_recipe.ingredients = {
  { type = "item", name = "aer_rubber-lined-offshore-pump", amount = 1 },
  { type = "item", name = "tungsten-plate", amount = 5 },
  { type = "item", name = "carbon-fiber", amount = 5 },
}
reinforced_offshore_pump_recipe.results = {
  { type = "item", name = "aer_reinforced-offshore-pump", amount = 1 },
}
data:extend({ reinforced_offshore_pump_recipe })

local reinforced_pump_recipe = util.table.deepcopy(data.raw.recipe.pump)
reinforced_pump_recipe.name = "aer_reinforced-pump"
reinforced_pump_recipe.enabled = false
reinforced_pump_recipe.ingredients = {
  { type = "item", name = "aer_rubber-lined-pump", amount = 1 },
  { type = "item", name = "tungsten-plate", amount = 5 },
  { type = "item", name = "carbon-fiber", amount = 5 },
}
reinforced_pump_recipe.results = {
  { type = "item", name = "aer_reinforced-pump", amount = 1 },
}
data:extend({ reinforced_pump_recipe })

local foundation_pipe_recipe = util.table.deepcopy(data.raw.recipe.pipe)
foundation_pipe_recipe.name = "aer_foundation-pipe"
foundation_pipe_recipe.enabled = false
foundation_pipe_recipe.ingredients = {
  { type = "item", name = "aer_reinforced-pipe", amount = 5 },
  { type = "item", name = "foundation", amount = 1 },
}
foundation_pipe_recipe.results = {
  { type = "item", name = "aer_foundation-pipe", amount = 5 },
}
data:extend({ foundation_pipe_recipe })

local foundation_pipe_to_ground_recipe = util.table.deepcopy(data.raw.recipe["pipe-to-ground"])
foundation_pipe_to_ground_recipe.name = "aer_foundation-pipe-to-ground"
foundation_pipe_to_ground_recipe.enabled = false
foundation_pipe_to_ground_recipe.ingredients = {
  { type = "item", name = "aer_reinforced-pipe-to-ground", amount = 2 },
  { type = "item", name = "foundation", amount = 1 },
}
foundation_pipe_to_ground_recipe.results = {
  { type = "item", name = "aer_foundation-pipe-to-ground", amount = 2 },
}
data:extend({ foundation_pipe_to_ground_recipe })

local foundation_offshore_pump_recipe = util.table.deepcopy(data.raw.recipe["offshore-pump"])
foundation_offshore_pump_recipe.name = "aer_foundation-offshore-pump"
foundation_offshore_pump_recipe.enabled = false
foundation_offshore_pump_recipe.ingredients = {
  { type = "item", name = "aer_reinforced-offshore-pump", amount = 1 },
  { type = "item", name = "foundation", amount = 1 },
  { type = "item", name = "superconductor", amount = 10 },
  { type = "item", name = "lithium-plate", amount = 5 },
}
foundation_offshore_pump_recipe.results = {
  { type = "item", name = "aer_foundation-offshore-pump", amount = 1 },
}
data:extend({ foundation_offshore_pump_recipe })

local foundation_pump_recipe = util.table.deepcopy(data.raw.recipe.pump)
foundation_pump_recipe.name = "aer_foundation-pump"
foundation_pump_recipe.enabled = false
foundation_pump_recipe.ingredients = {
  { type = "item", name = "aer_reinforced-pump", amount = 1 },
  { type = "item", name = "foundation", amount = 1 },
  { type = "item", name = "superconductor", amount = 5 },
  { type = "item", name = "lithium-plate", amount = 2 },
}
foundation_pump_recipe.results = {
  { type = "item", name = "aer_foundation-pump", amount = 1 },
}
data:extend({ foundation_pump_recipe })

local high_pressure_foundation_offshore_pump_recipe = util.table.deepcopy(data.raw.recipe["offshore-pump"])
high_pressure_foundation_offshore_pump_recipe.name = "aer_high-pressure-foundation-offshore-pump"
high_pressure_foundation_offshore_pump_recipe.enabled = false
high_pressure_foundation_offshore_pump_recipe.ingredients = {
  { type = "item", name = "aer_foundation-offshore-pump", amount = 1 },
  { type = "item", name = "superconductor", amount = 40 },
  { type = "item", name = "quantum-processor", amount = 10 },
  { type = "item", name = "promethium-asteroid-chunk", amount = 25 },
}
high_pressure_foundation_offshore_pump_recipe.results = {
  { type = "item", name = "aer_high-pressure-foundation-offshore-pump", amount = 1 },
}
data:extend({ high_pressure_foundation_offshore_pump_recipe })

local high_pressure_foundation_pump_recipe = util.table.deepcopy(data.raw.recipe.pump)
high_pressure_foundation_pump_recipe.name = "aer_high-pressure-foundation-pump"
high_pressure_foundation_pump_recipe.enabled = false
high_pressure_foundation_pump_recipe.ingredients = {
  { type = "item", name = "aer_foundation-pump", amount = 1 },
  { type = "item", name = "superconductor", amount = 20 },
  { type = "item", name = "quantum-processor", amount = 5 },
  { type = "item", name = "promethium-asteroid-chunk", amount = 10 },
}
high_pressure_foundation_pump_recipe.results = {
  { type = "item", name = "aer_high-pressure-foundation-pump", amount = 1 },
}
data:extend({ high_pressure_foundation_pump_recipe })
