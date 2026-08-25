-- Shared by the base-game tier and the Space Age tiers in
-- prototypes/power/space-age/heat-pipe/, which are built the same way and
-- differ only in their materials and research gating.

local fluid_helpers = require("prototypes.power.fluid-helpers")

local helpers = {}

function helpers.make_heat_pipe(name, minable_result, heat, next_upgrade, tint, resistances)
  local heat_pipe = util.table.deepcopy(data.raw["heat-pipe"]["heat-pipe"])
  heat_pipe.name = name
  heat_pipe.minable.result = minable_result
  heat_pipe.fast_replaceable_group = "heat-pipe"
  heat_pipe.next_upgrade = next_upgrade
  heat_pipe.minimum_glow_temperature = heat.minimum_glow_temperature
  heat_pipe.heat_buffer.max_temperature = heat.max_temperature
  heat_pipe.heat_buffer.specific_heat = heat.specific_heat
  heat_pipe.heat_buffer.max_transfer = heat.max_transfer
  heat_pipe.heat_buffer.min_temperature_gradient = heat.min_temperature_gradient
  if tint then
    tint(heat_pipe)
  end
  if resistances then
    fluid_helpers.set_resistances(heat_pipe, resistances)
  end
  return heat_pipe
end

function helpers.make_heat_pipe_item(name, order, place_result, tint)
  local item = util.table.deepcopy(data.raw.item["heat-pipe"])
  item.name = name
  item.subgroup = "aer_nuclear-power"
  item.order = order
  item.place_result = place_result
  if tint then
    tint(item)
  end
  return item
end

return helpers
