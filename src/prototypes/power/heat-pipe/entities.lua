local fluid_helpers = require("prototypes.fluid.helpers")
local constants = require("prototypes.fluid.constants")

local base_heat_pipe = data.raw["heat-pipe"]["heat-pipe"]
base_heat_pipe.fast_replaceable_group = "heat-pipe"
base_heat_pipe.next_upgrade = "aer_heat-pipe-2"

local function make_heat_pipe(name, minable_result, heat, next_upgrade, tint, resistances)
  local heat_pipe = util.table.deepcopy(base_heat_pipe)
  heat_pipe.name = name
  heat_pipe.minable.result = minable_result
  heat_pipe.fast_replaceable_group = "heat-pipe"
  heat_pipe.next_upgrade = next_upgrade
  heat_pipe.minimum_glow_temperature = heat.minimum_glow_temperature
  heat_pipe.heat_buffer.max_temperature = heat.max_temperature
  heat_pipe.heat_buffer.specific_heat = heat.specific_heat
  heat_pipe.heat_buffer.max_transfer = heat.max_transfer
  if tint then
    tint(heat_pipe)
  end
  if resistances then
    fluid_helpers.set_resistances(heat_pipe, resistances)
  end
  return heat_pipe
end

local heat_pipe_mk2 = make_heat_pipe(
  "aer_heat-pipe-2",
  "aer_heat-pipe-2",
  {
    minimum_glow_temperature = 500,
    max_temperature = 1300,
    specific_heat = "2MJ",
    max_transfer = "4GW",
  },
  "aer_heat-pipe-3",
  fluid_helpers.apply_rubber_lined_entity_tint
)
heat_pipe_mk2.max_health = 300

local heat_pipe_mk3 = make_heat_pipe(
  "aer_heat-pipe-3",
  "aer_heat-pipe-3",
  {
    minimum_glow_temperature = 650,
    max_temperature = 1600,
    specific_heat = "3MJ",
    max_transfer = "6GW",
  },
  "aer_heat-pipe-4",
  fluid_helpers.apply_reinforced_entity_tint,
  constants.reinforced.resistances
)
heat_pipe_mk3.max_health = 350

local heat_pipe_mk4 = make_heat_pipe(
  "aer_heat-pipe-4",
  "aer_heat-pipe-4",
  {
    minimum_glow_temperature = 850,
    max_temperature = 2200,
    specific_heat = "4MJ",
    max_transfer = "8GW",
  },
  nil,
  fluid_helpers.apply_foundation_entity_tint,
  constants.foundation.resistances
)
heat_pipe_mk4.max_health = 400

data:extend({
  heat_pipe_mk2,
  heat_pipe_mk3,
  heat_pipe_mk4,
})
