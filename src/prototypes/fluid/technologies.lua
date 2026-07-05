local helpers = require("prototypes.fluid.helpers")

local function make_steel_fluid_technology(name, icon, effects, order)
  local technology = util.table.deepcopy(data.raw.technology["fluid-handling"])
  technology.name = name
  technology.icon = icon
  technology.icon_size = 256
  technology.prerequisites = {
    "steel-processing",
    "fluid-handling",
  }
  technology.effects = effects
  technology.unit = {
    count = 100,
    ingredients = {
      { "automation-science-pack", 1 },
      { "logistic-science-pack", 1 },
    },
    time = 30,
  }
  technology.upgrade = true
  technology.order = order
  return technology
end

local function make_rubber_lined_fluid_technology(name, icon, prerequisites, effects, order)
  local technology = util.table.deepcopy(data.raw.technology["fluid-handling"])
  technology.name = name
  technology.icon = icon
  technology.icon_size = 256
  technology.icons = nil
  technology.prerequisites = prerequisites
  technology.effects = effects
  technology.unit = {
    count = 250,
    ingredients = {
      { "automation-science-pack", 1 },
      { "logistic-science-pack", 1 },
      { "chemical-science-pack", 1 },
    },
    time = 30,
  }
  technology.upgrade = true
  technology.order = order
  return technology
end

local function make_low_pressure_steel_fluid_technology(name, icon, prerequisites, effects, order)
  local technology = util.table.deepcopy(data.raw.technology["fluid-handling"])
  technology.name = name
  technology.icon = icon
  technology.icon_size = 256
  technology.icons = nil
  technology.prerequisites = prerequisites
  technology.effects = effects
  technology.unit = {
    count = 250,
    ingredients = {
      { "automation-science-pack", 1 },
      { "logistic-science-pack", 1 },
      { "chemical-science-pack", 1 },
      { "space-science-pack", 1 },
    },
    time = 30,
  }
  technology.upgrade = true
  technology.order = order
  return technology
end

data:extend({
  make_steel_fluid_technology(
    "aer_steel-pipe-infrastructure",
    "__advanced-power-infrastructure__/graphics/technology/steel-fluid-pipes.png",
    {
      { type = "unlock-recipe", recipe = "aer_steel-pipe" },
      { type = "unlock-recipe", recipe = "aer_steel-pipe-to-ground" },
    },
    "d-a-a"
  ),
  make_steel_fluid_technology(
    "aer_steel-pump-infrastructure",
    "__advanced-power-infrastructure__/graphics/technology/steel-fluid-pumps.png",
    {
      { type = "unlock-recipe", recipe = "aer_steel-offshore-pump" },
      { type = "unlock-recipe", recipe = "aer_steel-pump" },
    },
    "d-a-b"
  ),
  make_low_pressure_steel_fluid_technology(
    "aer_low-pressure-steel-pipe-infrastructure",
    "__advanced-power-infrastructure__/graphics/technology/low-pressure-steel-fluid-pipes.png",
    {
      "aer_steel-pipe-infrastructure",
      "low-density-structure",
      "space-science-pack",
    },
    {
      { type = "unlock-recipe", recipe = "aer_low-pressure-steel-pipe" },
      { type = "unlock-recipe", recipe = "aer_low-pressure-steel-pipe-to-ground" },
    },
    "d-a-c"
  ),
  make_low_pressure_steel_fluid_technology(
    "aer_low-pressure-steel-pump-infrastructure",
    "__advanced-power-infrastructure__/graphics/technology/low-pressure-steel-fluid-pumps.png",
    {
      "aer_steel-pump-infrastructure",
      "low-density-structure",
      "space-science-pack",
    },
    {
      { type = "unlock-recipe", recipe = "aer_low-pressure-steel-pump" },
    },
    "d-a-d"
  ),
  make_rubber_lined_fluid_technology(
    "aer_rubber-lined-pipe-infrastructure",
    "__advanced-power-infrastructure__/graphics/technology/rubber-lined-fluid-pipes.png",
    {
      "aer_steel-pipe-infrastructure",
      "plastics",
      "lubricant",
      "chemical-science-pack",
    },
    {
      { type = "unlock-recipe", recipe = "aer_rubber-lined-pipe" },
      { type = "unlock-recipe", recipe = "aer_rubber-lined-pipe-to-ground" },
    },
    "d-a-e"
  ),
  make_rubber_lined_fluid_technology(
    "aer_rubber-lined-pump-infrastructure",
    "__advanced-power-infrastructure__/graphics/technology/rubber-lined-fluid-pumps.png",
    {
      "aer_steel-pump-infrastructure",
      "plastics",
      "lubricant",
      "chemical-science-pack",
    },
    {
      { type = "unlock-recipe", recipe = "aer_rubber-lined-offshore-pump" },
      { type = "unlock-recipe", recipe = "aer_rubber-lined-pump" },
    },
    "d-a-f"
  ),
  {
    type = "technology",
    name = "aer_tungsten-pipe-infrastructure",
    icon = "__advanced-power-infrastructure__/graphics/technology/tungsten-fluid-pipes.png",
    icon_size = 256,
    prerequisites = {
      "metallurgic-science-pack",
      "aer_steel-pipe-infrastructure",
    },
    effects = {
      { type = "unlock-recipe", recipe = "aer_tungsten-pipe" },
      { type = "unlock-recipe", recipe = "aer_tungsten-pipe-to-ground" },
    },
    unit = {
      count = 500,
      ingredients = {
        { "automation-science-pack", 1 },
        { "logistic-science-pack", 1 },
        { "chemical-science-pack", 1 },
        { "space-science-pack", 1 },
        { "metallurgic-science-pack", 1 },
      },
      time = 45,
    },
    upgrade = true,
    order = "d-a-g",
  },
  {
    type = "technology",
    name = "aer_tungsten-pump-infrastructure",
    icon = "__advanced-power-infrastructure__/graphics/technology/tungsten-fluid-pumps.png",
    icon_size = 256,
    prerequisites = {
      "metallurgic-science-pack",
      "aer_steel-pump-infrastructure",
    },
    effects = {
      { type = "unlock-recipe", recipe = "aer_tungsten-offshore-pump" },
      { type = "unlock-recipe", recipe = "aer_tungsten-pump" },
    },
    unit = {
      count = 500,
      ingredients = {
        { "automation-science-pack", 1 },
        { "logistic-science-pack", 1 },
        { "chemical-science-pack", 1 },
        { "space-science-pack", 1 },
        { "metallurgic-science-pack", 1 },
      },
      time = 45,
    },
    upgrade = true,
    order = "d-a-h",
  },
  {
    type = "technology",
    name = "aer_reinforced-pipe-infrastructure",
    icon = "__advanced-power-infrastructure__/graphics/technology/reinforced-fluid-pipes.png",
    icon_size = 256,
    prerequisites = {
      "aer_rubber-lined-pipe-infrastructure",
      "aer_tungsten-pipe-infrastructure",
      "carbon-fiber",
    },
    effects = {
      { type = "unlock-recipe", recipe = "aer_reinforced-pipe" },
      { type = "unlock-recipe", recipe = "aer_reinforced-pipe-to-ground" },
    },
    unit = {
      count = 1000,
      ingredients = {
        { "automation-science-pack", 1 },
        { "logistic-science-pack", 1 },
        { "chemical-science-pack", 1 },
        { "space-science-pack", 1 },
        { "metallurgic-science-pack", 1 },
        { "agricultural-science-pack", 1 },
      },
      time = 60,
    },
    upgrade = true,
    order = "d-a-i",
  },
  {
    type = "technology",
    name = "aer_reinforced-pump-infrastructure",
    icon = "__advanced-power-infrastructure__/graphics/technology/reinforced-fluid-pumps.png",
    icon_size = 256,
    prerequisites = {
      "aer_rubber-lined-pump-infrastructure",
      "aer_tungsten-pump-infrastructure",
      "carbon-fiber",
    },
    effects = {
      { type = "unlock-recipe", recipe = "aer_reinforced-offshore-pump" },
      { type = "unlock-recipe", recipe = "aer_reinforced-pump" },
    },
    unit = {
      count = 1000,
      ingredients = {
        { "automation-science-pack", 1 },
        { "logistic-science-pack", 1 },
        { "chemical-science-pack", 1 },
        { "space-science-pack", 1 },
        { "metallurgic-science-pack", 1 },
        { "agricultural-science-pack", 1 },
      },
      time = 60,
    },
    upgrade = true,
    order = "d-a-j",
  },
  {
    type = "technology",
    name = "aer_foundation-pipe-infrastructure",
    icon = "__advanced-power-infrastructure__/graphics/technology/foundation-fluid-pipes.png",
    icon_size = 256,
    prerequisites = {
      "aer_reinforced-pipe-infrastructure",
      "aer_low-pressure-steel-pipe-infrastructure",
      "foundation",
    },
    effects = {
      { type = "unlock-recipe", recipe = "aer_foundation-pipe" },
      { type = "unlock-recipe", recipe = "aer_foundation-pipe-to-ground" },
    },
    unit = {
      count = 2500,
      ingredients = {
        { "automation-science-pack", 1 },
        { "logistic-science-pack", 1 },
        { "chemical-science-pack", 1 },
        { "space-science-pack", 1 },
        { "metallurgic-science-pack", 1 },
        { "agricultural-science-pack", 1 },
        { "cryogenic-science-pack", 1 },
      },
      time = 60,
    },
    upgrade = true,
    order = "d-a-k",
  },
  {
    type = "technology",
    name = "aer_foundation-pump-infrastructure",
    icon = "__advanced-power-infrastructure__/graphics/technology/foundation-fluid-pumps.png",
    icon_size = 256,
    prerequisites = {
      "aer_reinforced-pump-infrastructure",
      "aer_low-pressure-steel-pump-infrastructure",
      "foundation",
      "electromagnetic-plant",
      "lithium-processing",
    },
    effects = {
      { type = "unlock-recipe", recipe = "aer_foundation-offshore-pump" },
      { type = "unlock-recipe", recipe = "aer_foundation-pump" },
    },
    unit = {
      count = 2500,
      ingredients = {
        { "automation-science-pack", 1 },
        { "logistic-science-pack", 1 },
        { "chemical-science-pack", 1 },
        { "space-science-pack", 1 },
        { "metallurgic-science-pack", 1 },
        { "agricultural-science-pack", 1 },
        { "cryogenic-science-pack", 1 },
      },
      time = 60,
    },
    upgrade = true,
    order = "d-a-l",
  },
  {
    type = "technology",
    name = "aer_high-pressure-foundation-pumping",
    icon = "__advanced-power-infrastructure__/graphics/technology/high-pressure-foundation-fluid-pumps.png",
    icon_size = 256,
    prerequisites = {
      "aer_foundation-pump-infrastructure",
      "promethium-science-pack",
      "quantum-processor",
    },
    effects = {
      { type = "unlock-recipe", recipe = "aer_high-pressure-foundation-offshore-pump" },
      { type = "unlock-recipe", recipe = "aer_high-pressure-foundation-pump" },
    },
    unit = {
      count = 5000,
      ingredients = {
        { "automation-science-pack", 1 },
        { "logistic-science-pack", 1 },
        { "chemical-science-pack", 1 },
        { "production-science-pack", 1 },
        { "utility-science-pack", 1 },
        { "space-science-pack", 1 },
        { "metallurgic-science-pack", 1 },
        { "agricultural-science-pack", 1 },
        { "electromagnetic-science-pack", 1 },
        { "cryogenic-science-pack", 1 },
        { "promethium-science-pack", 1 },
      },
      time = 120,
    },
    upgrade = true,
    order = "d-a-m",
  },
})

helpers.add_unlock("steam-power", "pipe")
helpers.add_unlock("steam-power", "pipe-to-ground")
helpers.add_unlock("steam-power", "offshore-pump")
helpers.add_unlock("calcite-processing", "aer_heat-resistant-pipe")
helpers.add_unlock("calcite-processing", "aer_heat-resistant-pipe-to-ground")
helpers.add_unlock("calcite-processing", "aer_heat-resistant-pump")
