local fluid_helpers = require("prototypes.power.fluid-helpers")
local heat_pipe_helpers = require("prototypes.power.heat-pipe.helpers")

data.raw.item["heat-pipe"].order = "b[heat-pipe-1]"
data.raw.item["heat-pipe"].subgroup = "aer_nuclear-power"

local heat_pipe_mk2 = heat_pipe_helpers.make_heat_pipe_item(
  "aer_heat-pipe-2",
  "b[steam-power]-a[heat-pipe-2]",
  "aer_heat-pipe-2",
  fluid_helpers.apply_rubber_lined_icon_tint
)

data:extend({ heat_pipe_mk2 })
