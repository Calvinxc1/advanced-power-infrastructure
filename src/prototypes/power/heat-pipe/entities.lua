local constants = require("prototypes.power.fluid-constants")
local fluid_helpers = require("prototypes.power.fluid-helpers")
local heat_pipe_helpers = require("prototypes.power.heat-pipe.helpers")

local base_heat_pipe = data.raw["heat-pipe"]["heat-pipe"]
base_heat_pipe.fast_replaceable_group = "heat-pipe"
base_heat_pipe.next_upgrade = "aer_heat-pipe-2"
-- Set before any tier is built: make_heat_pipe deepcopies this prototype, so
-- every tier inherits the gradient from here.
base_heat_pipe.heat_buffer.min_temperature_gradient =
  constants.heat_pipe_temperature_gradient

-- Terminates the base-game ladder. prototypes/power/space-age/heat-pipe/entities.lua
-- re-points this at mk3 when that tier exists, so the chain is correct in both
-- loads without depending on load order.
local heat_pipe_mk2 = heat_pipe_helpers.make_heat_pipe(
  "aer_heat-pipe-2",
  "aer_heat-pipe-2",
  {
    minimum_glow_temperature = 500,
    max_temperature = 1300,
    specific_heat = "2MJ",
    max_transfer = "4GW",
  },
  nil,
  fluid_helpers.apply_rubber_lined_entity_tint
)
heat_pipe_mk2.max_health = 300

data:extend({ heat_pipe_mk2 })
