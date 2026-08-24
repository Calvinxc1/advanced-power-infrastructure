-- Space Age heat pipe tiers. mk3 needs holmium plate and tungsten plate; mk4
-- adds foundation and superconductor. Holmium has no base-game equivalent, so
-- the ladder stops at mk2 without Space Age.

local fluid_helpers = require("prototypes.power.fluid-helpers")
local heat_pipe_helpers = require("prototypes.power.heat-pipe.helpers")

local heat_pipe_mk3 = heat_pipe_helpers.make_heat_pipe_item(
  "aer_heat-pipe-3",
  "b[steam-power]-a[heat-pipe-3]",
  "aer_heat-pipe-3",
  fluid_helpers.apply_reinforced_icon_tint
)

local heat_pipe_mk4 = heat_pipe_helpers.make_heat_pipe_item(
  "aer_heat-pipe-4",
  "b[steam-power]-a[heat-pipe-4]",
  "aer_heat-pipe-4",
  fluid_helpers.apply_foundation_icon_tint
)

data:extend({ heat_pipe_mk3, heat_pipe_mk4 })
