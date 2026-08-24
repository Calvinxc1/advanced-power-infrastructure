local heat_pipe_mk2 = util.table.deepcopy(data.raw.technology["nuclear-power"])
heat_pipe_mk2.name = "aer_heat-pipe-2"
heat_pipe_mk2.localised_name = {"technology-name.aer_heat-pipe-2"}
heat_pipe_mk2.icon = "__advanced-power-infrastructure__/graphics/technology/rubber-lined-heat-pipes.png"
heat_pipe_mk2.icon_size = 256
heat_pipe_mk2.icons = nil
heat_pipe_mk2.prerequisites = {
  "nuclear-power",
  "production-science-pack",
  "utility-science-pack",
}
heat_pipe_mk2.effects = {
  { type = "unlock-recipe", recipe = "aer_heat-pipe-2" },
}
heat_pipe_mk2.unit.count = 1000
heat_pipe_mk2.unit.ingredients = {
  {"automation-science-pack", 1},
  {"logistic-science-pack", 1},
  {"chemical-science-pack", 1},
  {"production-science-pack", 1},
  {"utility-science-pack", 1},
}
heat_pipe_mk2.unit.time = 30
heat_pipe_mk2.upgrade = true
heat_pipe_mk2.order = "e-p-c-d"
data:extend({ heat_pipe_mk2 })
