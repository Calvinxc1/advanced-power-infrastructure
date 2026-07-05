local function add_prerequisite(technology, prerequisite)
  technology.prerequisites = technology.prerequisites or {}
  for _, existing in pairs(technology.prerequisites) do
    if existing == prerequisite then
      return
    end
  end
  table.insert(technology.prerequisites, prerequisite)
end

add_prerequisite(data.raw.technology["nuclear-power"], "afi_steel-pipe-infrastructure")

local steam_turbine_mk2 = util.table.deepcopy(data.raw.technology["nuclear-power"])
steam_turbine_mk2.name = "aer_rubber-lined-steam-turbine"
steam_turbine_mk2.icon = "__advanced-power-infrastructure__/graphics/technology/rubber-lined-steam-turbines.png"
steam_turbine_mk2.icon_size = 256
steam_turbine_mk2.icons = nil
steam_turbine_mk2.prerequisites = {
  "nuclear-power",
  "afi_rubber-lined-pipe-infrastructure",
  "afi_rubber-lined-pump-infrastructure",
  "production-science-pack",
  "utility-science-pack",
}
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
steam_turbine_mk3.prerequisites = {
  "aer_rubber-lined-steam-turbine",
  "afi_reinforced-pipe-infrastructure",
  "afi_reinforced-pump-infrastructure",
  "metallurgic-science-pack",
  "agricultural-science-pack",
}
steam_turbine_mk3.effects = {
  { type = "unlock-recipe", recipe = "aer_reinforced-steam-turbine" },
}
steam_turbine_mk3.unit.count = 2500
steam_turbine_mk3.unit.ingredients = {
  {"automation-science-pack", 1},
  {"logistic-science-pack", 1},
  {"chemical-science-pack", 1},
  {"space-science-pack", 1},
  {"production-science-pack", 1},
  {"utility-science-pack", 1},
  {"metallurgic-science-pack", 1},
  {"agricultural-science-pack", 1},
}
steam_turbine_mk3.unit.time = 30
steam_turbine_mk3.upgrade = true
steam_turbine_mk3.order = "[steam-turbine]-3"
data:extend({steam_turbine_mk3})

local steam_turbine_mk4 = util.table.deepcopy(data.raw.technology["nuclear-power"])
steam_turbine_mk4.name = "aer_foundation-steam-turbine"
steam_turbine_mk4.icon = "__advanced-power-infrastructure__/graphics/technology/foundation-steam-turbines.png"
steam_turbine_mk4.icon_size = 256
steam_turbine_mk4.icons = nil
steam_turbine_mk4.prerequisites = {
  "aer_reinforced-steam-turbine",
  "afi_foundation-pipe-infrastructure",
  "afi_foundation-pump-infrastructure",
}
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
