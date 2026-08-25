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
