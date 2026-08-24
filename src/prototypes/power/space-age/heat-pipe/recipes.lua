-- Space Age heat pipe tiers. mk3 needs holmium plate and tungsten plate; mk4
-- adds foundation and superconductor. Holmium has no base-game equivalent, so
-- the ladder stops at mk2 without Space Age.

local heat_pipe_mk3 = util.table.deepcopy(data.raw.recipe["heat-pipe"])
heat_pipe_mk3.name = "aer_heat-pipe-3"
heat_pipe_mk3.enabled = false
heat_pipe_mk3.ingredients = {
  { type = "item", name = "aer_heat-pipe-2", amount = 1 },
  { type = "item", name = "tungsten-plate", amount = 20 },
  { type = "item", name = "holmium-plate", amount = 10 },
  { type = "item", name = "supercapacitor", amount = 2 },
}
heat_pipe_mk3.results = {
  { type = "item", name = "aer_heat-pipe-3", amount = 1 },
}
data:extend({ heat_pipe_mk3 })
local heat_pipe_mk4 = util.table.deepcopy(data.raw.recipe["heat-pipe"])
heat_pipe_mk4.name = "aer_heat-pipe-4"
heat_pipe_mk4.enabled = false
heat_pipe_mk4.ingredients = {
  { type = "item", name = "aer_heat-pipe-3", amount = 1 },
  { type = "item", name = "foundation", amount = 1 },
  { type = "item", name = "holmium-plate", amount = 10 },
  { type = "item", name = "superconductor", amount = 5 },
}
heat_pipe_mk4.results = {
  { type = "item", name = "aer_heat-pipe-4", amount = 1 },
}
data:extend({ heat_pipe_mk4 })
