-- Space Age boiler tier. Its recipe needs superconductor, and its research
-- is gated on electromagnetic science, so it has no base-game form.

local fluid_constants = require("prototypes.power.fluid-constants")
local fluid_helpers = require("prototypes.power.fluid-helpers")
local function tint_boiler_structure(boiler, tint)
  for _, picture in pairs(boiler.pictures or {}) do
    if picture.structure then
      advanced_power_tint_sprite_layers(picture.structure.layers, tint)
    end
    if picture.patch then
      picture.patch.tint = tint
    end
  end
end

local boiler_mk4 = util.table.deepcopy(data.raw["boiler"]["boiler"])
boiler_mk4.target_temperature = 350
boiler_mk4.energy_consumption = "7.2MW"
boiler_mk4.name = "aer_holmium-reinforced-boiler"
boiler_mk4.minable.result =  "aer_holmium-reinforced-boiler"
boiler_mk4.fast_replaceable_group = "boiler"
boiler_mk4.next_upgrade = nil
boiler_mk4.energy_source.effectivity = 1.3
fluid_helpers.set_fluid_box_extent(boiler_mk4.fluid_box, fluid_constants.reinforced.pipeline_extent)
fluid_helpers.set_fluid_box_extent(boiler_mk4.output_fluid_box, fluid_constants.reinforced.pipeline_extent)
fluid_helpers.set_description(boiler_mk4, fluid_helpers.boiler_description(fluid_constants.reinforced.pipeline_extent))
advanced_power_apply_holmium_icon_tint(boiler_mk4)
tint_boiler_structure(boiler_mk4, holmium_tier_entity_tint)
data:extend({boiler_mk4})

-- Re-point the base ladder's top tier now that a tier above it exists.
data.raw["boiler"]["aer_rubber-lined-boiler"].next_upgrade = "aer_holmium-reinforced-boiler"
