local constants = require("prototypes.fluid.constants")
local helpers = require("prototypes.fluid.helpers")

local production_machine_extent = constants.steel.pipeline_extent

local prototype_types = {
  "assembling-machine",
  "furnace",
  "mining-drill",
  "rocket-silo",
}

local function has_fluid_boxes(prototype)
  return prototype.fluid_box
    or prototype.input_fluid_box
    or prototype.output_fluid_box
    or prototype.fluid_boxes
end

local function patch_machine(prototype)
  if not has_fluid_boxes(prototype) then
    return
  end
  helpers.set_prototype_fluid_boxes_extent(prototype, production_machine_extent)
  helpers.append_description(prototype, helpers.pipe_description(production_machine_extent))
end

for _, prototype_type in pairs(prototype_types) do
  for _, prototype in pairs(data.raw[prototype_type] or {}) do
    patch_machine(prototype)
  end
end
