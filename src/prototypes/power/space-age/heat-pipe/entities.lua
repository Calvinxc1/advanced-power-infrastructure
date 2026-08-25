-- Space Age heat pipe tiers. mk3 needs holmium plate and tungsten plate; mk4
-- adds foundation and superconductor. Holmium has no base-game equivalent, so
-- the ladder stops at mk2 without Space Age.

local fluid_helpers = require("prototypes.power.fluid-helpers")
local constants = require("prototypes.power.fluid-constants")
local heat_pipe_helpers = require("prototypes.power.heat-pipe.helpers")

local heat_pipe_mk3 = heat_pipe_helpers.make_heat_pipe(
  "aer_heat-pipe-3",
  "aer_heat-pipe-3",
  {
    minimum_glow_temperature = 650,
    max_temperature = constants.heat_tier_ceiling.mk3,
    specific_heat = "3MJ",
    max_transfer = constants.heat_tier_max_transfer.mk3,
    min_temperature_gradient = constants.heat_tier_gradient.mk3,
  },
  "aer_heat-pipe-4",
  fluid_helpers.apply_reinforced_entity_tint,
  constants.reinforced.resistances
)
heat_pipe_mk3.max_health = 350

local heat_pipe_mk4 = heat_pipe_helpers.make_heat_pipe(
  "aer_heat-pipe-4",
  "aer_heat-pipe-4",
  {
    minimum_glow_temperature = 850,
    max_temperature = constants.heat_tier_ceiling.mk4,
    specific_heat = "4MJ",
    max_transfer = constants.heat_tier_max_transfer.mk4,
    min_temperature_gradient = constants.heat_tier_gradient.mk4,
  },
  nil,
  fluid_helpers.apply_foundation_entity_tint,
  constants.foundation.resistances
)
heat_pipe_mk4.max_health = 400

data:extend({ heat_pipe_mk3, heat_pipe_mk4 })

-- Re-point the base ladder's top tier now that a tier above it exists.
data.raw["heat-pipe"]["aer_heat-pipe-2"].next_upgrade = "aer_heat-pipe-3"
