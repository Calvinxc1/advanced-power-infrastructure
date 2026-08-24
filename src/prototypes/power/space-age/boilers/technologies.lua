-- Space Age boiler tier. Its recipe needs superconductor, and its research
-- is gated on electromagnetic science, so it has no base-game form.

local boiler_mk4 = util.table.deepcopy(data.raw.technology["steel-processing"])
boiler_mk4.name = "aer_holmium-reinforced-boiler"
boiler_mk4.icon = "__advanced-power-infrastructure__/graphics/technology/holmium-reinforced-boilers.png"
boiler_mk4.icon_size = 256
boiler_mk4.icons = nil
boiler_mk4.prerequisites = {
  "aer_rubber-lined-boiler",
  "holmium-processing",
  "electromagnetic-science-pack",
}
boiler_mk4.effects = {
  { type = "unlock-recipe", recipe = "aer_holmium-reinforced-boiler" },
}
boiler_mk4.unit.count = 500
boiler_mk4.unit.ingredients = {
  {"automation-science-pack", 1},
  {"logistic-science-pack", 1},
  {"chemical-science-pack", 1},
  {"space-science-pack", 1},
  {"electromagnetic-science-pack", 1},
}
boiler_mk4.unit.time = 30
boiler_mk4.upgrade = true
boiler_mk4.order = "[boiler]-3"
data:extend({boiler_mk4})
