local fluid_helpers = require("prototypes.fluid.helpers")

data.raw.item["heat-pipe"].order = "b[steam-power]-a[heat-pipe-1]"
data.raw.item["heat-pipe"].subgroup = "aer_heat-pipe"

local function make_heat_pipe_item(name, order, place_result, tint)
  local item = util.table.deepcopy(data.raw.item["heat-pipe"])
  item.name = name
  item.subgroup = "aer_heat-pipe"
  item.order = order
  item.place_result = place_result
  if tint then
    tint(item)
  end
  return item
end

local heat_pipe_mk2 = make_heat_pipe_item(
  "aer_heat-pipe-2",
  "b[steam-power]-a[heat-pipe-2]",
  "aer_heat-pipe-2",
  fluid_helpers.apply_rubber_lined_icon_tint
)

local heat_pipe_mk3 = make_heat_pipe_item(
  "aer_heat-pipe-3",
  "b[steam-power]-a[heat-pipe-3]",
  "aer_heat-pipe-3",
  fluid_helpers.apply_reinforced_icon_tint
)

local heat_pipe_mk4 = make_heat_pipe_item(
  "aer_heat-pipe-4",
  "b[steam-power]-a[heat-pipe-4]",
  "aer_heat-pipe-4",
  fluid_helpers.apply_foundation_icon_tint
)

data:extend({
  heat_pipe_mk2,
  heat_pipe_mk3,
  heat_pipe_mk4,
})
