-- Space Age heat pipe tiers. mk3 needs holmium plate and tungsten plate; mk4
-- adds foundation and superconductor. Holmium has no base-game equivalent, so
-- the ladder stops at mk2 without Space Age.

local heat_pipe_mk3 = util.table.deepcopy(data.raw.technology["nuclear-power"])
heat_pipe_mk3.name = "aer_heat-pipe-3"
heat_pipe_mk3.localised_name = {"technology-name.aer_heat-pipe-3"}
heat_pipe_mk3.icon = "__advanced-power-infrastructure__/graphics/technology/reinforced-heat-pipes.png"
heat_pipe_mk3.icon_size = 256
heat_pipe_mk3.icons = nil
heat_pipe_mk3.prerequisites = {
  "aer_heat-pipe-2",
  "metallurgic-science-pack",
  "electromagnetic-science-pack",
}
heat_pipe_mk3.effects = {
  { type = "unlock-recipe", recipe = "aer_heat-pipe-3" },
}
heat_pipe_mk3.unit.count = 2500
heat_pipe_mk3.unit.ingredients = {
  {"automation-science-pack", 1},
  {"logistic-science-pack", 1},
  {"chemical-science-pack", 1},
  {"space-science-pack", 1},
  {"production-science-pack", 1},
  {"utility-science-pack", 1},
  {"metallurgic-science-pack", 1},
  {"electromagnetic-science-pack", 1},
}
heat_pipe_mk3.unit.time = 30
heat_pipe_mk3.upgrade = true
heat_pipe_mk3.order = "e-p-c-e"
data:extend({ heat_pipe_mk3 })
local heat_pipe_mk4 = util.table.deepcopy(data.raw.technology["nuclear-power"])
heat_pipe_mk4.name = "aer_heat-pipe-4"
heat_pipe_mk4.localised_name = {"technology-name.aer_heat-pipe-4"}
heat_pipe_mk4.icon = "__advanced-power-infrastructure__/graphics/technology/foundation-heat-pipes.png"
heat_pipe_mk4.icon_size = 256
heat_pipe_mk4.icons = nil
heat_pipe_mk4.prerequisites = {
  "aer_heat-pipe-3",
  "electromagnetic-science-pack",
  "foundation",
}
heat_pipe_mk4.effects = {
  { type = "unlock-recipe", recipe = "aer_heat-pipe-4" },
}
heat_pipe_mk4.unit.count = 5000
heat_pipe_mk4.unit.ingredients = {
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
heat_pipe_mk4.unit.time = 30
heat_pipe_mk4.upgrade = true
heat_pipe_mk4.order = "e-p-c-f"
data:extend({ heat_pipe_mk4 })
