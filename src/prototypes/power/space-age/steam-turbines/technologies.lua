-- Space Age steam turbine tier. Its recipe needs foundation and
-- superconductor. The reinforced tier below it survives a base-game load by
-- substituting refined concrete and low-density structure.

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

local steam_turbine_mk4 = util.table.deepcopy(data.raw.technology["nuclear-power"])
steam_turbine_mk4.name = "aer_foundation-steam-turbine"
steam_turbine_mk4.icon = "__advanced-power-infrastructure__/graphics/technology/foundation-steam-turbines.png"
steam_turbine_mk4.icon_size = 256
steam_turbine_mk4.icons = nil
steam_turbine_mk4.prerequisites = optional_dependencies.prerequisites(
  {
    "aer_reinforced-steam-turbine",
    "afi_foundation-pipe-infrastructure",
    "afi_foundation-pump-infrastructure",
  },
  {
    "aer_reinforced-steam-turbine",
    "foundation",
  }
)
steam_turbine_mk4.effects = {
  { type = "unlock-recipe", recipe = "aer_foundation-steam-turbine" },
}
steam_turbine_mk4.unit.count = 5000
steam_turbine_mk4.unit.ingredients = {
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
steam_turbine_mk4.unit.time = 30
steam_turbine_mk4.upgrade = true
steam_turbine_mk4.order = "[steam-turbine]-4"
data:extend({steam_turbine_mk4})
