local constants = require("prototypes.power.fluid-constants")
local fluid_helpers = require("prototypes.power.fluid-helpers")
local heat_pipe_helpers = require("prototypes.power.heat-pipe.helpers")

local base_heat_pipe = data.raw["heat-pipe"]["heat-pipe"]
base_heat_pipe.fast_replaceable_group = "heat-pipe"
base_heat_pipe.next_upgrade = "aer_heat-pipe-2"
-- Set before any tier is built: make_heat_pipe deepcopies this prototype, so
-- every tier inherits the gradient from here.
base_heat_pipe.heat_buffer.min_temperature_gradient = constants.heat_tier_gradient.mk1
-- Capped at the tier it carries. A pipe is a node in the heat network, so a
-- lower-tier pipe throttles the whole run to its own maximum -- which is what
-- makes each reactor tier actually require its matching pipe.
base_heat_pipe.heat_buffer.max_temperature = constants.heat_tier_ceiling.mk1
base_heat_pipe.heat_buffer.max_transfer = constants.heat_tier_max_transfer.mk1
fluid_helpers.set_description(base_heat_pipe,
  fluid_helpers.heat_pipe_description(base_heat_pipe.heat_buffer))

-- Terminates the base-game ladder. prototypes/power/space-age/heat-pipe/entities.lua
-- re-points this at mk3 when that tier exists, so the chain is correct in both
-- loads without depending on load order.
local heat_pipe_mk2 = heat_pipe_helpers.make_heat_pipe(
  "aer_heat-pipe-2",
  "aer_heat-pipe-2",
  {
    minimum_glow_temperature = 500,
    max_temperature = constants.heat_tier_ceiling.mk2,
    specific_heat = "2MJ",
    max_transfer = constants.heat_tier_max_transfer.mk2,
    min_temperature_gradient = constants.heat_tier_gradient.mk2,
  },
  nil,
  fluid_helpers.apply_rubber_lined_heat_pipe_tint
)
heat_pipe_mk2.max_health = 300

data:extend({ heat_pipe_mk2 })
