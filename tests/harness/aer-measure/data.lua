-- Test-only prototypes. These exist to answer research questions that cannot be
-- asked of the shipped prototypes, and are never loaded outside the harness.

-- #11 asks whether min_working_temperature and target_temperature can be
-- decoupled, turning the hard cutoff into a throughput taper. The shipped
-- exchangers set them equal, so a decoupled variant is required to find out.
local decoupled = table.deepcopy(data.raw.boiler["aer_heat-exchanger-2"])
decoupled.name = "aerm_decoupled-exchanger"
decoupled.next_upgrade = nil
decoupled.energy_source.min_working_temperature = 400
decoupled.target_temperature = 650

data:extend({decoupled})

-- Does mode = "heat-fluid-inside" let steam temperature track the heat network,
-- instead of being pinned to a fixed target_temperature? Steam is the working
-- fluid because water caps at 100 degrees and cannot carry the range.
local superheater = table.deepcopy(data.raw.boiler["aer_heat-exchanger-2"])
superheater.name = "aerm_superheater"
superheater.next_upgrade = nil
superheater.mode = "heat-fluid-inside"
superheater.target_temperature = nil
superheater.energy_source.min_working_temperature = 400
superheater.fluid_box.filter = "steam"
superheater.output_fluid_box.filter = "steam"

data:extend({superheater})

-- Distance cost. min_temperature_gradient is undocumented by Wube -- empty
-- description in both prototype-api.json and runtime-api.json -- and this mod
-- never sets it, so every heat entity runs on the engine default of 1. These
-- variants exist to find out what the field actually does to the temperature
-- profile along a pipe run, which is what would make exchanger placement a
-- spatial decision rather than a free one.
for _, gradient in ipairs({1, 3, 5, 10, 20}) do
  local probe = table.deepcopy(data.raw["heat-pipe"]["heat-pipe"])
  probe.name = "aerm_gradient-" .. gradient
  probe.next_upgrade = nil
  probe.minable = nil
  probe.heat_buffer.min_temperature_gradient = gradient
  data:extend({probe})
end

-- Distance is currently free: heat reaches the far end of any run at full
-- temperature. min_temperature_gradient is the one field that could make length
-- cost something, and Wube documents it nowhere, so these variants exist to
-- measure what it actually does. See issue #14.
for _, gradient in ipairs({1, 5, 10, 25, 50}) do
  local pipe = table.deepcopy(data.raw["heat-pipe"]["heat-pipe"])
  pipe.name = "aerm_gradient-" .. gradient
  pipe.next_upgrade = nil
  pipe.minable = {mining_time = 0.1, result = "heat-pipe"}
  pipe.heat_buffer.min_temperature_gradient = gradient
  data:extend({pipe})
end
