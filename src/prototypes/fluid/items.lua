local constants = require("prototypes.fluid.constants")
local helpers = require("prototypes.fluid.helpers")

local iron = constants.iron
local steel = constants.steel
local low_pressure_steel = constants.low_pressure_steel
local heat_resistant = constants.heat_resistant
local tungsten = constants.tungsten
local reinforced = constants.reinforced
local foundation = constants.foundation
local high_pressure_foundation = constants.high_pressure_foundation
local rubber_lined = constants.rubber_lined

data.raw.item.pipe.order = "a[pipe]-a[iron-pipe]"
data.raw.item["pipe-to-ground"].order = "a[pipe]-b[iron-pipe-to-ground]"
data.raw.item["offshore-pump"].order = "b[fluid]-a[offshore-pump-1]"
data.raw.item.pump.order = "b[fluid]-b[pump-1]"
helpers.set_description(data.raw.item.pipe, helpers.pipe_description(iron.pipeline_extent))
helpers.set_description(
  data.raw.item["pipe-to-ground"],
  helpers.underground_pipe_description(iron.pipeline_extent, iron.underground_distance)
)
helpers.set_description(
  data.raw.item["offshore-pump"],
  helpers.offshore_pump_description(iron.pipeline_extent)
)
helpers.set_description(data.raw.item.pump, helpers.pump_description())

local steel_pipe_item = util.table.deepcopy(data.raw.item.pipe)
steel_pipe_item.name = "aer_steel-pipe"
steel_pipe_item.place_result = "aer_steel-pipe"
steel_pipe_item.order = "a[pipe]-a[steel-pipe]"
helpers.apply_steel_icon_tint(steel_pipe_item)
helpers.set_description(steel_pipe_item, helpers.pipe_description(steel.pipeline_extent))
data:extend({ steel_pipe_item })

local steel_pipe_to_ground_item = util.table.deepcopy(data.raw.item["pipe-to-ground"])
steel_pipe_to_ground_item.name = "aer_steel-pipe-to-ground"
steel_pipe_to_ground_item.place_result = "aer_steel-pipe-to-ground"
steel_pipe_to_ground_item.order = "a[pipe]-b[steel-pipe-to-ground]"
helpers.apply_steel_icon_tint(steel_pipe_to_ground_item)
helpers.set_description(
  steel_pipe_to_ground_item,
  helpers.underground_pipe_description(steel.pipeline_extent, steel.underground_distance)
)
data:extend({ steel_pipe_to_ground_item })

local steel_offshore_pump_item = util.table.deepcopy(data.raw.item["offshore-pump"])
steel_offshore_pump_item.name = "aer_steel-offshore-pump"
steel_offshore_pump_item.place_result = "aer_steel-offshore-pump"
steel_offshore_pump_item.order = "b[fluid]-a[offshore-pump-2]"
helpers.apply_steel_icon_tint(steel_offshore_pump_item)
helpers.set_description(
  steel_offshore_pump_item,
  helpers.offshore_pump_description(steel.pipeline_extent)
)
data:extend({ steel_offshore_pump_item })

local steel_pump_item = util.table.deepcopy(data.raw.item.pump)
steel_pump_item.name = "aer_steel-pump"
steel_pump_item.place_result = "aer_steel-pump"
steel_pump_item.order = "b[fluid]-b[pump-2]"
helpers.apply_steel_icon_tint(steel_pump_item)
helpers.set_description(steel_pump_item, helpers.pump_description())
data:extend({ steel_pump_item })

local low_pressure_steel_pipe_item = util.table.deepcopy(data.raw.item.pipe)
low_pressure_steel_pipe_item.name = "aer_low-pressure-steel-pipe"
low_pressure_steel_pipe_item.place_result = "aer_low-pressure-steel-pipe"
low_pressure_steel_pipe_item.order = "a[pipe]-a[low-pressure-steel-pipe]"
helpers.apply_low_pressure_steel_icon_tint(low_pressure_steel_pipe_item)
helpers.set_description(low_pressure_steel_pipe_item, helpers.pipe_description(low_pressure_steel.pipeline_extent))
data:extend({ low_pressure_steel_pipe_item })

local low_pressure_steel_pipe_to_ground_item = util.table.deepcopy(data.raw.item["pipe-to-ground"])
low_pressure_steel_pipe_to_ground_item.name = "aer_low-pressure-steel-pipe-to-ground"
low_pressure_steel_pipe_to_ground_item.place_result = "aer_low-pressure-steel-pipe-to-ground"
low_pressure_steel_pipe_to_ground_item.order = "a[pipe]-b[low-pressure-steel-pipe-to-ground]"
helpers.apply_low_pressure_steel_icon_tint(low_pressure_steel_pipe_to_ground_item)
helpers.set_description(
  low_pressure_steel_pipe_to_ground_item,
  helpers.underground_pipe_description(low_pressure_steel.pipeline_extent, low_pressure_steel.underground_distance)
)
data:extend({ low_pressure_steel_pipe_to_ground_item })

local low_pressure_steel_pump_item = util.table.deepcopy(data.raw.item.pump)
low_pressure_steel_pump_item.name = "aer_low-pressure-steel-pump"
low_pressure_steel_pump_item.place_result = "aer_low-pressure-steel-pump"
low_pressure_steel_pump_item.order = "b[fluid]-b[pump-space]"
helpers.apply_low_pressure_steel_icon_tint(low_pressure_steel_pump_item)
helpers.set_description(low_pressure_steel_pump_item, helpers.pump_description())
data:extend({ low_pressure_steel_pump_item })

local heat_resistant_pipe_item = util.table.deepcopy(data.raw.item.pipe)
heat_resistant_pipe_item.name = "aer_heat-resistant-pipe"
heat_resistant_pipe_item.place_result = "aer_heat-resistant-pipe"
heat_resistant_pipe_item.order = "a[pipe]-a[heat-resistant-pipe]"
helpers.apply_heat_resistant_icon_tint(heat_resistant_pipe_item)
helpers.set_description(heat_resistant_pipe_item, helpers.pipe_description(heat_resistant.pipeline_extent))
data:extend({ heat_resistant_pipe_item })

local heat_resistant_pipe_to_ground_item = util.table.deepcopy(data.raw.item["pipe-to-ground"])
heat_resistant_pipe_to_ground_item.name = "aer_heat-resistant-pipe-to-ground"
heat_resistant_pipe_to_ground_item.place_result = "aer_heat-resistant-pipe-to-ground"
heat_resistant_pipe_to_ground_item.order = "a[pipe]-b[heat-resistant-pipe-to-ground]"
helpers.apply_heat_resistant_icon_tint(heat_resistant_pipe_to_ground_item)
helpers.set_description(
  heat_resistant_pipe_to_ground_item,
  helpers.underground_pipe_description(heat_resistant.pipeline_extent, heat_resistant.underground_distance)
)
data:extend({ heat_resistant_pipe_to_ground_item })

local heat_resistant_pump_item = util.table.deepcopy(data.raw.item.pump)
heat_resistant_pump_item.name = "aer_heat-resistant-pump"
heat_resistant_pump_item.place_result = "aer_heat-resistant-pump"
heat_resistant_pump_item.order = "b[fluid]-b[pump-vulcanus]"
helpers.apply_heat_resistant_icon_tint(heat_resistant_pump_item)
helpers.set_description(heat_resistant_pump_item, helpers.pump_description())
data:extend({ heat_resistant_pump_item })

local tungsten_pipe_item = util.table.deepcopy(data.raw.item.pipe)
tungsten_pipe_item.name = "aer_tungsten-pipe"
tungsten_pipe_item.place_result = "aer_tungsten-pipe"
tungsten_pipe_item.order = "a[pipe]-a[tungsten-pipe]"
helpers.apply_tungsten_icon_tint(tungsten_pipe_item)
helpers.set_description(tungsten_pipe_item, helpers.pipe_description(tungsten.pipeline_extent))
data:extend({ tungsten_pipe_item })

local tungsten_pipe_to_ground_item = util.table.deepcopy(data.raw.item["pipe-to-ground"])
tungsten_pipe_to_ground_item.name = "aer_tungsten-pipe-to-ground"
tungsten_pipe_to_ground_item.place_result = "aer_tungsten-pipe-to-ground"
tungsten_pipe_to_ground_item.order = "a[pipe]-b[tungsten-pipe-to-ground]"
helpers.apply_tungsten_icon_tint(tungsten_pipe_to_ground_item)
helpers.set_description(
  tungsten_pipe_to_ground_item,
  helpers.underground_pipe_description(tungsten.pipeline_extent, tungsten.underground_distance)
)
data:extend({ tungsten_pipe_to_ground_item })

local tungsten_pump_item = util.table.deepcopy(data.raw.item.pump)
tungsten_pump_item.name = "aer_tungsten-pump"
tungsten_pump_item.place_result = "aer_tungsten-pump"
tungsten_pump_item.order = "b[fluid]-b[pump-vulcanus-tungsten]"
helpers.apply_tungsten_icon_tint(tungsten_pump_item)
helpers.set_description(tungsten_pump_item, helpers.pump_description())
data:extend({ tungsten_pump_item })

local tungsten_offshore_pump_item = util.table.deepcopy(data.raw.item["offshore-pump"])
tungsten_offshore_pump_item.name = "aer_tungsten-offshore-pump"
tungsten_offshore_pump_item.place_result = "aer_tungsten-offshore-pump"
tungsten_offshore_pump_item.order = "b[fluid]-a[offshore-pump-vulcanus-tungsten]"
helpers.apply_tungsten_icon_tint(tungsten_offshore_pump_item)
helpers.set_description(
  tungsten_offshore_pump_item,
  helpers.lava_offshore_pump_description(tungsten.pipeline_extent)
)
data:extend({ tungsten_offshore_pump_item })

local reinforced_pipe_item = util.table.deepcopy(data.raw.item.pipe)
reinforced_pipe_item.name = "aer_reinforced-pipe"
reinforced_pipe_item.place_result = "aer_reinforced-pipe"
reinforced_pipe_item.order = "a[pipe]-a[reinforced-pipe]"
helpers.apply_reinforced_icon_tint(reinforced_pipe_item)
helpers.set_description(reinforced_pipe_item, helpers.pipe_description(reinforced.pipeline_extent))
data:extend({ reinforced_pipe_item })

local reinforced_pipe_to_ground_item = util.table.deepcopy(data.raw.item["pipe-to-ground"])
reinforced_pipe_to_ground_item.name = "aer_reinforced-pipe-to-ground"
reinforced_pipe_to_ground_item.place_result = "aer_reinforced-pipe-to-ground"
reinforced_pipe_to_ground_item.order = "a[pipe]-b[reinforced-pipe-to-ground]"
helpers.apply_reinforced_icon_tint(reinforced_pipe_to_ground_item)
helpers.set_description(
  reinforced_pipe_to_ground_item,
  helpers.underground_pipe_description(reinforced.pipeline_extent, reinforced.underground_distance)
)
data:extend({ reinforced_pipe_to_ground_item })

local reinforced_offshore_pump_item = util.table.deepcopy(data.raw.item["offshore-pump"])
reinforced_offshore_pump_item.name = "aer_reinforced-offshore-pump"
reinforced_offshore_pump_item.place_result = "aer_reinforced-offshore-pump"
reinforced_offshore_pump_item.order = "b[fluid]-a[offshore-pump-4]"
helpers.apply_reinforced_icon_tint(reinforced_offshore_pump_item)
helpers.set_description(
  reinforced_offshore_pump_item,
  helpers.offshore_pump_description(reinforced.pipeline_extent)
)
data:extend({ reinforced_offshore_pump_item })

local reinforced_pump_item = util.table.deepcopy(data.raw.item.pump)
reinforced_pump_item.name = "aer_reinforced-pump"
reinforced_pump_item.place_result = "aer_reinforced-pump"
reinforced_pump_item.order = "b[fluid]-b[pump-4]"
helpers.apply_reinforced_icon_tint(reinforced_pump_item)
helpers.set_description(reinforced_pump_item, helpers.pump_description())
data:extend({ reinforced_pump_item })

local foundation_pipe_item = util.table.deepcopy(data.raw.item.pipe)
foundation_pipe_item.name = "aer_foundation-pipe"
foundation_pipe_item.place_result = "aer_foundation-pipe"
foundation_pipe_item.order = "a[pipe]-a[foundation-pipe]"
helpers.apply_foundation_icon_tint(foundation_pipe_item)
helpers.set_description(foundation_pipe_item, helpers.pipe_description(foundation.pipeline_extent))
data:extend({ foundation_pipe_item })

local foundation_pipe_to_ground_item = util.table.deepcopy(data.raw.item["pipe-to-ground"])
foundation_pipe_to_ground_item.name = "aer_foundation-pipe-to-ground"
foundation_pipe_to_ground_item.place_result = "aer_foundation-pipe-to-ground"
foundation_pipe_to_ground_item.order = "a[pipe]-b[foundation-pipe-to-ground]"
helpers.apply_foundation_icon_tint(foundation_pipe_to_ground_item)
helpers.set_description(
  foundation_pipe_to_ground_item,
  helpers.underground_pipe_description(foundation.pipeline_extent, foundation.underground_distance)
)
data:extend({ foundation_pipe_to_ground_item })

local foundation_offshore_pump_item = util.table.deepcopy(data.raw.item["offshore-pump"])
foundation_offshore_pump_item.name = "aer_foundation-offshore-pump"
foundation_offshore_pump_item.place_result = "aer_foundation-offshore-pump"
foundation_offshore_pump_item.order = "b[fluid]-a[offshore-pump-5]"
helpers.apply_foundation_icon_tint(foundation_offshore_pump_item)
helpers.set_description(
  foundation_offshore_pump_item,
  helpers.offshore_pump_description(foundation.pipeline_extent)
)
data:extend({ foundation_offshore_pump_item })

local foundation_pump_item = util.table.deepcopy(data.raw.item.pump)
foundation_pump_item.name = "aer_foundation-pump"
foundation_pump_item.place_result = "aer_foundation-pump"
foundation_pump_item.order = "b[fluid]-b[pump-5]"
helpers.apply_foundation_icon_tint(foundation_pump_item)
helpers.set_description(foundation_pump_item, helpers.pump_description())
data:extend({ foundation_pump_item })

local high_pressure_foundation_offshore_pump_item = util.table.deepcopy(data.raw.item["offshore-pump"])
high_pressure_foundation_offshore_pump_item.name = "aer_high-pressure-foundation-offshore-pump"
high_pressure_foundation_offshore_pump_item.place_result = "aer_high-pressure-foundation-offshore-pump"
high_pressure_foundation_offshore_pump_item.order = "b[fluid]-a[offshore-pump-6]"
helpers.apply_high_pressure_foundation_icon_tint(high_pressure_foundation_offshore_pump_item)
helpers.set_description(
  high_pressure_foundation_offshore_pump_item,
  helpers.offshore_pump_description(high_pressure_foundation.pipeline_extent)
)
data:extend({ high_pressure_foundation_offshore_pump_item })

local high_pressure_foundation_pump_item = util.table.deepcopy(data.raw.item.pump)
high_pressure_foundation_pump_item.name = "aer_high-pressure-foundation-pump"
high_pressure_foundation_pump_item.place_result = "aer_high-pressure-foundation-pump"
high_pressure_foundation_pump_item.order = "b[fluid]-b[pump-6]"
helpers.apply_high_pressure_foundation_icon_tint(high_pressure_foundation_pump_item)
helpers.set_description(high_pressure_foundation_pump_item, helpers.pump_description())
data:extend({ high_pressure_foundation_pump_item })

local rubber_lined_pipe_item = util.table.deepcopy(data.raw.item.pipe)
rubber_lined_pipe_item.name = "aer_rubber-lined-pipe"
rubber_lined_pipe_item.place_result = "aer_rubber-lined-pipe"
rubber_lined_pipe_item.order = "a[pipe]-a[rubber-lined-pipe]"
helpers.apply_rubber_lined_icon_tint(rubber_lined_pipe_item)
helpers.set_description(rubber_lined_pipe_item, helpers.pipe_description(rubber_lined.pipeline_extent))
data:extend({ rubber_lined_pipe_item })

local rubber_lined_pipe_to_ground_item = util.table.deepcopy(data.raw.item["pipe-to-ground"])
rubber_lined_pipe_to_ground_item.name = "aer_rubber-lined-pipe-to-ground"
rubber_lined_pipe_to_ground_item.place_result = "aer_rubber-lined-pipe-to-ground"
rubber_lined_pipe_to_ground_item.order = "a[pipe]-b[rubber-lined-pipe-to-ground]"
helpers.apply_rubber_lined_icon_tint(rubber_lined_pipe_to_ground_item)
helpers.set_description(
  rubber_lined_pipe_to_ground_item,
  helpers.underground_pipe_description(rubber_lined.pipeline_extent, rubber_lined.underground_distance)
)
data:extend({ rubber_lined_pipe_to_ground_item })

local rubber_lined_offshore_pump_item = util.table.deepcopy(data.raw.item["offshore-pump"])
rubber_lined_offshore_pump_item.name = "aer_rubber-lined-offshore-pump"
rubber_lined_offshore_pump_item.place_result = "aer_rubber-lined-offshore-pump"
rubber_lined_offshore_pump_item.order = "b[fluid]-a[offshore-pump-3]"
helpers.apply_rubber_lined_icon_tint(rubber_lined_offshore_pump_item)
helpers.set_description(
  rubber_lined_offshore_pump_item,
  helpers.offshore_pump_description(rubber_lined.pipeline_extent)
)
data:extend({ rubber_lined_offshore_pump_item })

local rubber_lined_pump_item = util.table.deepcopy(data.raw.item.pump)
rubber_lined_pump_item.name = "aer_rubber-lined-pump"
rubber_lined_pump_item.place_result = "aer_rubber-lined-pump"
rubber_lined_pump_item.order = "b[fluid]-b[pump-3]"
helpers.apply_rubber_lined_icon_tint(rubber_lined_pump_item)
helpers.set_description(rubber_lined_pump_item, helpers.pump_description())
data:extend({ rubber_lined_pump_item })
