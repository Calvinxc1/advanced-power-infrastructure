local constants = require("prototypes.fluid.constants")
local helpers = require("prototypes.fluid.helpers")

local iron = constants.iron

data.raw.pipe.pipe.fast_replaceable_group = "pipe"
helpers.disallow_space_platforms_and_vulcanus(data.raw.pipe.pipe)
helpers.set_fluid_box_extent(data.raw.pipe.pipe.fluid_box, iron.pipeline_extent)
data.raw.pipe.pipe.next_upgrade = "aer_steel-pipe"
helpers.set_description(data.raw.pipe.pipe, helpers.pipe_description(iron.pipeline_extent))

data.raw["pipe-to-ground"]["pipe-to-ground"].fast_replaceable_group = "pipe"
helpers.disallow_space_platforms_and_vulcanus(data.raw["pipe-to-ground"]["pipe-to-ground"])
helpers.set_underground_distance(data.raw["pipe-to-ground"]["pipe-to-ground"], iron.underground_distance)
helpers.set_fluid_box_extent(data.raw["pipe-to-ground"]["pipe-to-ground"].fluid_box, iron.pipeline_extent)
data.raw["pipe-to-ground"]["pipe-to-ground"].next_upgrade = "aer_steel-pipe-to-ground"
helpers.set_description(
  data.raw["pipe-to-ground"]["pipe-to-ground"],
  helpers.underground_pipe_description(iron.pipeline_extent, iron.underground_distance)
)

data.raw["offshore-pump"]["offshore-pump"].fast_replaceable_group = "offshore-pump"
helpers.disallow_space_platforms_and_vulcanus(data.raw["offshore-pump"]["offshore-pump"])
helpers.set_fluid_box_extent(data.raw["offshore-pump"]["offshore-pump"].fluid_box, iron.pipeline_extent)
data.raw["offshore-pump"]["offshore-pump"].pumping_speed = iron.pumping_speed
data.raw["offshore-pump"]["offshore-pump"].next_upgrade = "aer_steel-offshore-pump"
helpers.set_description(
  data.raw["offshore-pump"]["offshore-pump"],
  helpers.offshore_pump_description(iron.pipeline_extent)
)

data.raw.pump.pump.fast_replaceable_group = "pump"
helpers.disallow_space_platforms_and_vulcanus(data.raw.pump.pump)
data.raw.pump.pump.pumping_speed = iron.pumping_speed
data.raw.pump.pump.next_upgrade = "aer_steel-pump"
helpers.set_description(data.raw.pump.pump, helpers.pump_description())

helpers.patch_boiler_extent("boiler", iron.pipeline_extent)
helpers.patch_boiler_extent("aer_steel-boiler", constants.steel.pipeline_extent)
helpers.patch_boiler_extent("aer_rubber-lined-boiler", constants.rubber_lined.pipeline_extent)
helpers.patch_boiler_extent("aer_holmium-reinforced-boiler", constants.reinforced.pipeline_extent)
