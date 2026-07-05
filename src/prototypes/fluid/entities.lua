local constants = require("prototypes.fluid.constants")
local helpers = require("prototypes.fluid.helpers")

local steel = constants.steel
local low_pressure_steel = constants.low_pressure_steel
local heat_resistant = constants.heat_resistant
local tungsten = constants.tungsten
local reinforced = constants.reinforced
local foundation = constants.foundation
local high_pressure_foundation = constants.high_pressure_foundation
local rubber_lined = constants.rubber_lined

local steel_pipe = util.table.deepcopy(data.raw.pipe.pipe)
steel_pipe.name = "aer_steel-pipe"
steel_pipe.minable.result = "aer_steel-pipe"
steel_pipe.max_health = 150
helpers.disallow_space_platforms_and_vulcanus(steel_pipe)
helpers.apply_steel_icon_tint(steel_pipe)
helpers.set_fluid_box_extent(steel_pipe.fluid_box, steel.pipeline_extent)
steel_pipe.next_upgrade = "aer_rubber-lined-pipe"
helpers.set_description(steel_pipe, helpers.pipe_description(steel.pipeline_extent))
data:extend({ steel_pipe })

local steel_pipe_to_ground = util.table.deepcopy(data.raw["pipe-to-ground"]["pipe-to-ground"])
steel_pipe_to_ground.name = "aer_steel-pipe-to-ground"
steel_pipe_to_ground.minable.result = "aer_steel-pipe-to-ground"
steel_pipe_to_ground.max_health = 200
helpers.disallow_space_platforms_and_vulcanus(steel_pipe_to_ground)
helpers.apply_steel_icon_tint(steel_pipe_to_ground)
helpers.set_underground_distance(steel_pipe_to_ground, steel.underground_distance)
helpers.set_fluid_box_extent(steel_pipe_to_ground.fluid_box, steel.pipeline_extent)
steel_pipe_to_ground.next_upgrade = "aer_rubber-lined-pipe-to-ground"
helpers.set_description(
  steel_pipe_to_ground,
  helpers.underground_pipe_description(steel.pipeline_extent, steel.underground_distance)
)
data:extend({ steel_pipe_to_ground })

local steel_offshore_pump = util.table.deepcopy(data.raw["offshore-pump"]["offshore-pump"])
steel_offshore_pump.name = "aer_steel-offshore-pump"
steel_offshore_pump.minable.result = "aer_steel-offshore-pump"
steel_offshore_pump.max_health = 200
helpers.disallow_space_platforms_and_vulcanus(steel_offshore_pump)
steel_offshore_pump.pumping_speed = steel.pumping_speed
helpers.apply_steel_icon_tint(steel_offshore_pump)
helpers.set_fluid_box_extent(steel_offshore_pump.fluid_box, steel.pipeline_extent)
steel_offshore_pump.next_upgrade = "aer_rubber-lined-offshore-pump"
helpers.set_description(
  steel_offshore_pump,
  helpers.offshore_pump_description(steel.pipeline_extent)
)
data:extend({ steel_offshore_pump })

local steel_pump = util.table.deepcopy(data.raw.pump.pump)
steel_pump.name = "aer_steel-pump"
steel_pump.minable.result = "aer_steel-pump"
steel_pump.max_health = 200
helpers.disallow_space_platforms_and_vulcanus(steel_pump)
steel_pump.pumping_speed = steel.pumping_speed
steel_pump.next_upgrade = "aer_rubber-lined-pump"
helpers.apply_steel_icon_tint(steel_pump)
helpers.set_description(steel_pump, helpers.pump_description())
data:extend({ steel_pump })

local low_pressure_steel_pipe = util.table.deepcopy(data.raw.pipe.pipe)
low_pressure_steel_pipe.name = "aer_low-pressure-steel-pipe"
low_pressure_steel_pipe.minable.result = "aer_low-pressure-steel-pipe"
low_pressure_steel_pipe.max_health = 150
helpers.allow_only_space_platforms(low_pressure_steel_pipe)
helpers.apply_low_pressure_steel_icon_tint(low_pressure_steel_pipe)
helpers.apply_low_pressure_steel_entity_tint(low_pressure_steel_pipe)
helpers.set_fluid_box_extent(low_pressure_steel_pipe.fluid_box, low_pressure_steel.pipeline_extent)
low_pressure_steel_pipe.next_upgrade = "aer_foundation-pipe"
helpers.set_description(low_pressure_steel_pipe, helpers.pipe_description(low_pressure_steel.pipeline_extent))
data:extend({ low_pressure_steel_pipe })

local low_pressure_steel_pipe_to_ground = util.table.deepcopy(data.raw["pipe-to-ground"]["pipe-to-ground"])
low_pressure_steel_pipe_to_ground.name = "aer_low-pressure-steel-pipe-to-ground"
low_pressure_steel_pipe_to_ground.minable.result = "aer_low-pressure-steel-pipe-to-ground"
low_pressure_steel_pipe_to_ground.max_health = 200
helpers.allow_only_space_platforms(low_pressure_steel_pipe_to_ground)
helpers.apply_low_pressure_steel_icon_tint(low_pressure_steel_pipe_to_ground)
helpers.apply_low_pressure_steel_entity_tint(low_pressure_steel_pipe_to_ground)
helpers.set_underground_distance(low_pressure_steel_pipe_to_ground, low_pressure_steel.underground_distance)
helpers.set_fluid_box_extent(low_pressure_steel_pipe_to_ground.fluid_box, low_pressure_steel.pipeline_extent)
low_pressure_steel_pipe_to_ground.next_upgrade = "aer_foundation-pipe-to-ground"
helpers.set_description(
  low_pressure_steel_pipe_to_ground,
  helpers.underground_pipe_description(low_pressure_steel.pipeline_extent, low_pressure_steel.underground_distance)
)
data:extend({ low_pressure_steel_pipe_to_ground })

local low_pressure_steel_pump = util.table.deepcopy(data.raw.pump.pump)
low_pressure_steel_pump.name = "aer_low-pressure-steel-pump"
low_pressure_steel_pump.minable.result = "aer_low-pressure-steel-pump"
low_pressure_steel_pump.max_health = 200
helpers.allow_only_space_platforms(low_pressure_steel_pump)
low_pressure_steel_pump.pumping_speed = low_pressure_steel.pumping_speed
low_pressure_steel_pump.next_upgrade = "aer_foundation-pump"
helpers.apply_low_pressure_steel_icon_tint(low_pressure_steel_pump)
helpers.apply_low_pressure_steel_entity_tint(low_pressure_steel_pump)
helpers.set_description(low_pressure_steel_pump, helpers.pump_description())
data:extend({ low_pressure_steel_pump })

local heat_resistant_pipe = util.table.deepcopy(data.raw.pipe.pipe)
heat_resistant_pipe.name = "aer_heat-resistant-pipe"
heat_resistant_pipe.minable.result = "aer_heat-resistant-pipe"
heat_resistant_pipe.max_health = 150
helpers.allow_only_vulcanus(heat_resistant_pipe)
helpers.apply_heat_resistant_icon_tint(heat_resistant_pipe)
helpers.apply_heat_resistant_entity_tint(heat_resistant_pipe)
helpers.set_fluid_box_extent(heat_resistant_pipe.fluid_box, heat_resistant.pipeline_extent)
heat_resistant_pipe.next_upgrade = "aer_tungsten-pipe"
helpers.set_description(heat_resistant_pipe, helpers.pipe_description(heat_resistant.pipeline_extent))
data:extend({ heat_resistant_pipe })

local heat_resistant_pipe_to_ground = util.table.deepcopy(data.raw["pipe-to-ground"]["pipe-to-ground"])
heat_resistant_pipe_to_ground.name = "aer_heat-resistant-pipe-to-ground"
heat_resistant_pipe_to_ground.minable.result = "aer_heat-resistant-pipe-to-ground"
heat_resistant_pipe_to_ground.max_health = 200
helpers.allow_only_vulcanus(heat_resistant_pipe_to_ground)
helpers.apply_heat_resistant_icon_tint(heat_resistant_pipe_to_ground)
helpers.apply_heat_resistant_entity_tint(heat_resistant_pipe_to_ground)
helpers.set_underground_distance(heat_resistant_pipe_to_ground, heat_resistant.underground_distance)
helpers.set_fluid_box_extent(heat_resistant_pipe_to_ground.fluid_box, heat_resistant.pipeline_extent)
heat_resistant_pipe_to_ground.next_upgrade = "aer_tungsten-pipe-to-ground"
helpers.set_description(
  heat_resistant_pipe_to_ground,
  helpers.underground_pipe_description(heat_resistant.pipeline_extent, heat_resistant.underground_distance)
)
data:extend({ heat_resistant_pipe_to_ground })

local heat_resistant_pump = util.table.deepcopy(data.raw.pump.pump)
heat_resistant_pump.name = "aer_heat-resistant-pump"
heat_resistant_pump.minable.result = "aer_heat-resistant-pump"
heat_resistant_pump.max_health = 200
helpers.allow_only_vulcanus(heat_resistant_pump)
heat_resistant_pump.pumping_speed = heat_resistant.pumping_speed
heat_resistant_pump.next_upgrade = "aer_tungsten-pump"
helpers.apply_heat_resistant_icon_tint(heat_resistant_pump)
helpers.apply_heat_resistant_entity_tint(heat_resistant_pump)
helpers.set_description(heat_resistant_pump, helpers.pump_description())
data:extend({ heat_resistant_pump })

local tungsten_pipe = util.table.deepcopy(data.raw.pipe.pipe)
tungsten_pipe.name = "aer_tungsten-pipe"
tungsten_pipe.minable.result = "aer_tungsten-pipe"
tungsten_pipe.max_health = 180
helpers.allow_only_vulcanus(tungsten_pipe)
helpers.apply_tungsten_icon_tint(tungsten_pipe)
helpers.apply_tungsten_entity_tint(tungsten_pipe)
helpers.set_fluid_box_extent(tungsten_pipe.fluid_box, tungsten.pipeline_extent)
tungsten_pipe.next_upgrade = "aer_reinforced-pipe"
helpers.set_description(tungsten_pipe, helpers.pipe_description(tungsten.pipeline_extent))
data:extend({ tungsten_pipe })

local tungsten_pipe_to_ground = util.table.deepcopy(data.raw["pipe-to-ground"]["pipe-to-ground"])
tungsten_pipe_to_ground.name = "aer_tungsten-pipe-to-ground"
tungsten_pipe_to_ground.minable.result = "aer_tungsten-pipe-to-ground"
tungsten_pipe_to_ground.max_health = 230
helpers.allow_only_vulcanus(tungsten_pipe_to_ground)
helpers.apply_tungsten_icon_tint(tungsten_pipe_to_ground)
helpers.apply_tungsten_entity_tint(tungsten_pipe_to_ground)
helpers.set_underground_distance(tungsten_pipe_to_ground, tungsten.underground_distance)
helpers.set_fluid_box_extent(tungsten_pipe_to_ground.fluid_box, tungsten.pipeline_extent)
tungsten_pipe_to_ground.next_upgrade = "aer_reinforced-pipe-to-ground"
helpers.set_description(
  tungsten_pipe_to_ground,
  helpers.underground_pipe_description(tungsten.pipeline_extent, tungsten.underground_distance)
)
data:extend({ tungsten_pipe_to_ground })

local tungsten_pump = util.table.deepcopy(data.raw.pump.pump)
tungsten_pump.name = "aer_tungsten-pump"
tungsten_pump.minable.result = "aer_tungsten-pump"
tungsten_pump.max_health = 240
helpers.allow_only_vulcanus(tungsten_pump)
tungsten_pump.pumping_speed = tungsten.pumping_speed
tungsten_pump.next_upgrade = "aer_reinforced-pump"
helpers.apply_tungsten_icon_tint(tungsten_pump)
helpers.apply_tungsten_entity_tint(tungsten_pump)
helpers.set_description(tungsten_pump, helpers.pump_description())
data:extend({ tungsten_pump })

local tungsten_offshore_pump = util.table.deepcopy(data.raw["offshore-pump"]["offshore-pump"])
tungsten_offshore_pump.name = "aer_tungsten-offshore-pump"
tungsten_offshore_pump.minable.result = "aer_tungsten-offshore-pump"
tungsten_offshore_pump.max_health = 240
helpers.allow_only_vulcanus(tungsten_offshore_pump)
tungsten_offshore_pump.pumping_speed = tungsten.pumping_speed
tungsten_offshore_pump.fluid_box.filter = "lava"
helpers.apply_tungsten_icon_tint(tungsten_offshore_pump)
helpers.apply_tungsten_entity_tint(tungsten_offshore_pump)
helpers.set_fluid_box_extent(tungsten_offshore_pump.fluid_box, tungsten.pipeline_extent)
tungsten_offshore_pump.next_upgrade = "aer_reinforced-offshore-pump"
helpers.set_description(
  tungsten_offshore_pump,
  helpers.lava_offshore_pump_description(tungsten.pipeline_extent)
)
data:extend({ tungsten_offshore_pump })

local reinforced_pipe = util.table.deepcopy(data.raw.pipe.pipe)
reinforced_pipe.name = "aer_reinforced-pipe"
reinforced_pipe.minable.result = "aer_reinforced-pipe"
reinforced_pipe.max_health = 260
helpers.disallow_space_platforms(reinforced_pipe)
helpers.apply_reinforced_icon_tint(reinforced_pipe)
helpers.apply_reinforced_entity_tint(reinforced_pipe)
helpers.set_resistances(reinforced_pipe, reinforced.resistances)
helpers.set_fluid_box_extent(reinforced_pipe.fluid_box, reinforced.pipeline_extent)
reinforced_pipe.next_upgrade = "aer_foundation-pipe"
helpers.set_description(reinforced_pipe, helpers.pipe_description(reinforced.pipeline_extent))
data:extend({ reinforced_pipe })

local reinforced_pipe_to_ground = util.table.deepcopy(data.raw["pipe-to-ground"]["pipe-to-ground"])
reinforced_pipe_to_ground.name = "aer_reinforced-pipe-to-ground"
reinforced_pipe_to_ground.minable.result = "aer_reinforced-pipe-to-ground"
reinforced_pipe_to_ground.max_health = 320
helpers.disallow_space_platforms(reinforced_pipe_to_ground)
helpers.apply_reinforced_icon_tint(reinforced_pipe_to_ground)
helpers.apply_reinforced_entity_tint(reinforced_pipe_to_ground)
helpers.set_resistances(reinforced_pipe_to_ground, reinforced.resistances)
helpers.set_underground_distance(reinforced_pipe_to_ground, reinforced.underground_distance)
helpers.set_fluid_box_extent(reinforced_pipe_to_ground.fluid_box, reinforced.pipeline_extent)
reinforced_pipe_to_ground.next_upgrade = "aer_foundation-pipe-to-ground"
helpers.set_description(
  reinforced_pipe_to_ground,
  helpers.underground_pipe_description(reinforced.pipeline_extent, reinforced.underground_distance)
)
data:extend({ reinforced_pipe_to_ground })

local reinforced_offshore_pump = util.table.deepcopy(data.raw["offshore-pump"]["offshore-pump"])
reinforced_offshore_pump.name = "aer_reinforced-offshore-pump"
reinforced_offshore_pump.minable.result = "aer_reinforced-offshore-pump"
reinforced_offshore_pump.max_health = 330
helpers.disallow_space_platforms(reinforced_offshore_pump)
reinforced_offshore_pump.pumping_speed = reinforced.pumping_speed
helpers.apply_reinforced_icon_tint(reinforced_offshore_pump)
helpers.apply_reinforced_entity_tint(reinforced_offshore_pump)
helpers.set_resistances(reinforced_offshore_pump, reinforced.resistances)
helpers.set_fluid_box_extent(reinforced_offshore_pump.fluid_box, reinforced.pipeline_extent)
reinforced_offshore_pump.next_upgrade = "aer_foundation-offshore-pump"
helpers.set_description(
  reinforced_offshore_pump,
  helpers.offshore_pump_description(reinforced.pipeline_extent)
)
data:extend({ reinforced_offshore_pump })

local reinforced_pump = util.table.deepcopy(data.raw.pump.pump)
reinforced_pump.name = "aer_reinforced-pump"
reinforced_pump.minable.result = "aer_reinforced-pump"
reinforced_pump.max_health = 330
helpers.disallow_space_platforms(reinforced_pump)
reinforced_pump.pumping_speed = reinforced.pumping_speed
reinforced_pump.next_upgrade = "aer_foundation-pump"
helpers.apply_reinforced_icon_tint(reinforced_pump)
helpers.apply_reinforced_entity_tint(reinforced_pump)
helpers.set_resistances(reinforced_pump, reinforced.resistances)
helpers.set_description(reinforced_pump, helpers.pump_description())
data:extend({ reinforced_pump })

local foundation_pipe = util.table.deepcopy(data.raw.pipe.pipe)
foundation_pipe.name = "aer_foundation-pipe"
foundation_pipe.minable.result = "aer_foundation-pipe"
foundation_pipe.max_health = 360
helpers.apply_foundation_icon_tint(foundation_pipe)
helpers.apply_foundation_entity_tint(foundation_pipe)
helpers.set_resistances(foundation_pipe, foundation.resistances)
helpers.set_fluid_box_extent(foundation_pipe.fluid_box, foundation.pipeline_extent)
foundation_pipe.next_upgrade = nil
helpers.set_description(foundation_pipe, helpers.pipe_description(foundation.pipeline_extent))
data:extend({ foundation_pipe })

local foundation_pipe_to_ground = util.table.deepcopy(data.raw["pipe-to-ground"]["pipe-to-ground"])
foundation_pipe_to_ground.name = "aer_foundation-pipe-to-ground"
foundation_pipe_to_ground.minable.result = "aer_foundation-pipe-to-ground"
foundation_pipe_to_ground.max_health = 440
helpers.apply_foundation_icon_tint(foundation_pipe_to_ground)
helpers.apply_foundation_entity_tint(foundation_pipe_to_ground)
helpers.set_resistances(foundation_pipe_to_ground, foundation.resistances)
helpers.set_underground_distance(foundation_pipe_to_ground, foundation.underground_distance)
helpers.set_fluid_box_extent(foundation_pipe_to_ground.fluid_box, foundation.pipeline_extent)
foundation_pipe_to_ground.next_upgrade = nil
helpers.set_description(
  foundation_pipe_to_ground,
  helpers.underground_pipe_description(foundation.pipeline_extent, foundation.underground_distance)
)
data:extend({ foundation_pipe_to_ground })

local foundation_offshore_pump = util.table.deepcopy(data.raw["offshore-pump"]["offshore-pump"])
foundation_offshore_pump.name = "aer_foundation-offshore-pump"
foundation_offshore_pump.minable.result = "aer_foundation-offshore-pump"
foundation_offshore_pump.max_health = 460
foundation_offshore_pump.pumping_speed = foundation.pumping_speed
helpers.apply_foundation_icon_tint(foundation_offshore_pump)
helpers.apply_foundation_entity_tint(foundation_offshore_pump)
helpers.set_resistances(foundation_offshore_pump, foundation.resistances)
helpers.set_fluid_box_extent(foundation_offshore_pump.fluid_box, foundation.pipeline_extent)
foundation_offshore_pump.next_upgrade = "aer_high-pressure-foundation-offshore-pump"
helpers.set_description(
  foundation_offshore_pump,
  helpers.offshore_pump_description(foundation.pipeline_extent)
)
data:extend({ foundation_offshore_pump })

local foundation_pump = util.table.deepcopy(data.raw.pump.pump)
foundation_pump.name = "aer_foundation-pump"
foundation_pump.minable.result = "aer_foundation-pump"
foundation_pump.max_health = 460
foundation_pump.pumping_speed = foundation.pumping_speed
foundation_pump.next_upgrade = "aer_high-pressure-foundation-pump"
helpers.apply_foundation_icon_tint(foundation_pump)
helpers.apply_foundation_entity_tint(foundation_pump)
helpers.set_resistances(foundation_pump, foundation.resistances)
helpers.set_description(foundation_pump, helpers.pump_description())
data:extend({ foundation_pump })

local high_pressure_foundation_offshore_pump = util.table.deepcopy(foundation_offshore_pump)
high_pressure_foundation_offshore_pump.name = "aer_high-pressure-foundation-offshore-pump"
high_pressure_foundation_offshore_pump.minable.result = "aer_high-pressure-foundation-offshore-pump"
high_pressure_foundation_offshore_pump.max_health = 560
high_pressure_foundation_offshore_pump.pumping_speed = high_pressure_foundation.pumping_speed
high_pressure_foundation_offshore_pump.next_upgrade = nil
helpers.apply_high_pressure_foundation_icon_tint(high_pressure_foundation_offshore_pump)
helpers.apply_high_pressure_foundation_entity_tint(high_pressure_foundation_offshore_pump)
helpers.set_resistances(high_pressure_foundation_offshore_pump, foundation.resistances)
helpers.set_fluid_box_extent(high_pressure_foundation_offshore_pump.fluid_box, high_pressure_foundation.pipeline_extent)
helpers.set_description(
  high_pressure_foundation_offshore_pump,
  helpers.offshore_pump_description(high_pressure_foundation.pipeline_extent)
)
data:extend({ high_pressure_foundation_offshore_pump })

local high_pressure_foundation_pump = util.table.deepcopy(foundation_pump)
high_pressure_foundation_pump.name = "aer_high-pressure-foundation-pump"
high_pressure_foundation_pump.minable.result = "aer_high-pressure-foundation-pump"
high_pressure_foundation_pump.max_health = 560
high_pressure_foundation_pump.pumping_speed = high_pressure_foundation.pumping_speed
high_pressure_foundation_pump.next_upgrade = nil
helpers.apply_high_pressure_foundation_icon_tint(high_pressure_foundation_pump)
helpers.apply_high_pressure_foundation_entity_tint(high_pressure_foundation_pump)
helpers.set_resistances(high_pressure_foundation_pump, foundation.resistances)
helpers.set_description(high_pressure_foundation_pump, helpers.pump_description())
data:extend({ high_pressure_foundation_pump })

local rubber_lined_pipe = util.table.deepcopy(data.raw.pipe.pipe)
rubber_lined_pipe.name = "aer_rubber-lined-pipe"
rubber_lined_pipe.minable.result = "aer_rubber-lined-pipe"
rubber_lined_pipe.max_health = 180
helpers.disallow_space_platforms_and_vulcanus(rubber_lined_pipe)
helpers.apply_rubber_lined_icon_tint(rubber_lined_pipe)
helpers.apply_rubber_lined_entity_tint(rubber_lined_pipe)
helpers.set_fluid_box_extent(rubber_lined_pipe.fluid_box, rubber_lined.pipeline_extent)
rubber_lined_pipe.next_upgrade = "aer_reinforced-pipe"
helpers.set_description(rubber_lined_pipe, helpers.pipe_description(rubber_lined.pipeline_extent))
data:extend({ rubber_lined_pipe })

local rubber_lined_pipe_to_ground = util.table.deepcopy(data.raw["pipe-to-ground"]["pipe-to-ground"])
rubber_lined_pipe_to_ground.name = "aer_rubber-lined-pipe-to-ground"
rubber_lined_pipe_to_ground.minable.result = "aer_rubber-lined-pipe-to-ground"
rubber_lined_pipe_to_ground.max_health = 230
helpers.disallow_space_platforms_and_vulcanus(rubber_lined_pipe_to_ground)
helpers.apply_rubber_lined_icon_tint(rubber_lined_pipe_to_ground)
helpers.apply_rubber_lined_entity_tint(rubber_lined_pipe_to_ground)
helpers.set_underground_distance(rubber_lined_pipe_to_ground, rubber_lined.underground_distance)
helpers.set_fluid_box_extent(rubber_lined_pipe_to_ground.fluid_box, rubber_lined.pipeline_extent)
rubber_lined_pipe_to_ground.next_upgrade = "aer_reinforced-pipe-to-ground"
helpers.set_description(
  rubber_lined_pipe_to_ground,
  helpers.underground_pipe_description(rubber_lined.pipeline_extent, rubber_lined.underground_distance)
)
data:extend({ rubber_lined_pipe_to_ground })

local rubber_lined_offshore_pump = util.table.deepcopy(data.raw["offshore-pump"]["offshore-pump"])
rubber_lined_offshore_pump.name = "aer_rubber-lined-offshore-pump"
rubber_lined_offshore_pump.minable.result = "aer_rubber-lined-offshore-pump"
rubber_lined_offshore_pump.max_health = 240
helpers.disallow_space_platforms_and_vulcanus(rubber_lined_offshore_pump)
rubber_lined_offshore_pump.pumping_speed = rubber_lined.pumping_speed
helpers.apply_rubber_lined_icon_tint(rubber_lined_offshore_pump)
helpers.apply_rubber_lined_entity_tint(rubber_lined_offshore_pump)
helpers.set_fluid_box_extent(rubber_lined_offshore_pump.fluid_box, rubber_lined.pipeline_extent)
rubber_lined_offshore_pump.next_upgrade = "aer_reinforced-offshore-pump"
helpers.set_description(
  rubber_lined_offshore_pump,
  helpers.offshore_pump_description(rubber_lined.pipeline_extent)
)
data:extend({ rubber_lined_offshore_pump })

local rubber_lined_pump = util.table.deepcopy(data.raw.pump.pump)
rubber_lined_pump.name = "aer_rubber-lined-pump"
rubber_lined_pump.minable.result = "aer_rubber-lined-pump"
rubber_lined_pump.max_health = 240
helpers.disallow_space_platforms_and_vulcanus(rubber_lined_pump)
rubber_lined_pump.pumping_speed = rubber_lined.pumping_speed
rubber_lined_pump.next_upgrade = "aer_reinforced-pump"
helpers.apply_rubber_lined_icon_tint(rubber_lined_pump)
helpers.apply_rubber_lined_entity_tint(rubber_lined_pump)
helpers.set_description(rubber_lined_pump, helpers.pump_description())
data:extend({ rubber_lined_pump })
