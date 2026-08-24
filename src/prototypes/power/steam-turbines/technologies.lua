local optional_dependencies = require("prototypes.power.optional-dependencies")

local function add_prerequisite(technology, prerequisite)
  technology.prerequisites = technology.prerequisites or {}
  for _, existing in pairs(technology.prerequisites) do
    if existing == prerequisite then
      return
    end
  end
  table.insert(technology.prerequisites, prerequisite)
end

if optional_dependencies.has_advanced_fluid_infrastructure then
  add_prerequisite(data.raw.technology["nuclear-power"], "afi_steel-pipe-infrastructure")
end

local steam_turbine_mk2 = util.table.deepcopy(data.raw.technology["nuclear-power"])
steam_turbine_mk2.name = "aer_rubber-lined-steam-turbine"
steam_turbine_mk2.icon = "__advanced-power-infrastructure__/graphics/technology/rubber-lined-steam-turbines.png"
steam_turbine_mk2.icon_size = 256
steam_turbine_mk2.icons = nil
steam_turbine_mk2.prerequisites = optional_dependencies.prerequisites(
  {
    "nuclear-power",
    "afi_rubber-lined-pipe-infrastructure",
    "afi_rubber-lined-pump-infrastructure",
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
steam_turbine_mk2.effects = {
  { type = "unlock-recipe", recipe = "aer_rubber-lined-steam-turbine" },
}
steam_turbine_mk2.unit.count = 1000
steam_turbine_mk2.unit.ingredients = {
  {"automation-science-pack", 1},
  {"logistic-science-pack", 1},
  {"chemical-science-pack", 1},
  {"production-science-pack", 1},
  {"utility-science-pack", 1},
}
steam_turbine_mk2.unit.time = 30
steam_turbine_mk2.upgrade = true
steam_turbine_mk2.order = "[steam-turbine]-2"
data:extend({steam_turbine_mk2})

local steam_turbine_mk3 = util.table.deepcopy(data.raw.technology["nuclear-power"])
steam_turbine_mk3.name = "aer_reinforced-steam-turbine"
steam_turbine_mk3.icon = "__advanced-power-infrastructure__/graphics/technology/reinforced-steam-turbines.png"
steam_turbine_mk3.icon_size = 256
steam_turbine_mk3.icons = nil
-- The two optional dependencies are independent axes: Advanced Fluid
-- Infrastructure decides whether the pipe and pump tiers are named as
-- prerequisites, Space Age decides which science gates the tier.
steam_turbine_mk3.prerequisites = optional_dependencies.concat(
  optional_dependencies.prerequisites(
    {
      "aer_rubber-lined-steam-turbine",
      "afi_reinforced-pipe-infrastructure",
      "afi_reinforced-pump-infrastructure",
    },
    {
      "aer_rubber-lined-steam-turbine",
    }
  ),
  optional_dependencies.reinforced_science_prerequisites()
)
steam_turbine_mk3.effects = {
  { type = "unlock-recipe", recipe = "aer_reinforced-steam-turbine" },
}
steam_turbine_mk3.unit.count = 2500
steam_turbine_mk3.unit.ingredients = optional_dependencies.reinforced_unit_ingredients()
steam_turbine_mk3.unit.time = 30
steam_turbine_mk3.upgrade = true
steam_turbine_mk3.order = "[steam-turbine]-3"
data:extend({steam_turbine_mk3})
