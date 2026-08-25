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

-- #10 wants the neighbour bonus paid per heat connection rather than per
-- neighbour: three connections a side, a third of the bonus each, so a reactor
-- offset until only two line up earns two thirds.
--
-- Whether that is expressible at all comes down to one undocumented question:
-- does the engine sum neighbour_bonus once per connection point that finds a
-- neighbour, or once per distinct neighbouring reactor? Per point and the
-- design works. Per reactor and three points are worth the same as one, and the
-- whole approach has to be abandoned before any balance work starts.
--
-- This variant answers it. Vanilla defines one connection per side at the
-- midpoint; this defines three, at the same offsets as the reactor's own heat
-- connections, with a third of the bonus each. If the engine pays per point, a
-- flush pair still reads 1.0 -- the same as vanilla today, which is what would
-- keep every balance figure on the heat-chain branch intact.
local per_connection = table.deepcopy(data.raw.reactor["nuclear-reactor"])
per_connection.name = "aerm_reactor-per-connection"
per_connection.next_upgrade = nil
per_connection.minable = {mining_time = 0.5, result = "nuclear-reactor"}
per_connection.neighbour_bonus = 1 / 3

local connections = {}
for _, side in ipairs({
  {direction = 0,  axis = "y", edge = -2.5},
  {direction = 8,  axis = "y", edge = 2.5},
  {direction = 4,  axis = "x", edge = 2.5},
  {direction = 12, axis = "x", edge = -2.5},
}) do
  for _, along in ipairs({-2, 0, 2}) do
    local position
    if side.axis == "y" then
      position = {along, side.edge}
    else
      position = {side.edge, along}
    end
    connections[#connections + 1] = {
      location = {position = position, direction = side.direction},
      category = "nuclear-reactor",
      neighbour_category = {"nuclear-reactor"},
    }
  end
end
per_connection.neighbour_connectable = {connections = connections}

data:extend({per_connection})

-- The per-connection variant showed the engine counting once per neighbouring
-- reactor, however many points pair up. One possibility remains before the
-- prototype route is exhausted: the dedupe might be per category pair rather
-- than per entity. If each of the three points on a side pairs through its own
-- category, the engine might see three relationships instead of one.
--
-- Categories are positional, so a point at offset -2 on one reactor meets a
-- point at offset -2 on its neighbour, and both carry the same category.
local per_category = table.deepcopy(data.raw.reactor["nuclear-reactor"])
per_category.name = "aerm_reactor-per-category"
per_category.next_upgrade = nil
per_category.minable = {mining_time = 0.5, result = "nuclear-reactor"}
per_category.neighbour_bonus = 1 / 3

local categories = {[-2] = "aerm-nr-low", [0] = "aerm-nr-mid", [2] = "aerm-nr-high"}
local connections = {}
for _, side in ipairs({
  {direction = 0,  axis = "y", edge = -2.5},
  {direction = 8,  axis = "y", edge = 2.5},
  {direction = 4,  axis = "x", edge = 2.5},
  {direction = 12, axis = "x", edge = -2.5},
}) do
  for _, along in ipairs({-2, 0, 2}) do
    local position
    if side.axis == "y" then
      position = {along, side.edge}
    else
      position = {side.edge, along}
    end
    connections[#connections + 1] = {
      location = {position = position, direction = side.direction},
      category = categories[along],
      neighbour_category = {categories[along]},
    }
  end
end
per_category.neighbour_connectable = {connections = connections}

data:extend({per_category})

-- Flow cap probes. max_transfer caps how much heat a pipe will move at once,
-- and the shipped tiers now sit close enough to real spoke draw that it will
-- bind in play -- so what a bound cap looks like matters, and had never been
-- looked at.
--
-- The temperature gradient is turned right down on these so that any sag along
-- the run is the cap rather than distance. Ceilings are raised so nothing
-- clips.
for _, megawatts in ipairs({50, 150, 2000}) do
  local pipe = table.deepcopy(data.raw["heat-pipe"]["heat-pipe"])
  pipe.name = "aerm_flow-" .. megawatts
  pipe.next_upgrade = nil
  pipe.minable = {mining_time = 0.1, result = "heat-pipe"}
  pipe.heat_buffer.max_temperature = 1000
  pipe.heat_buffer.min_temperature_gradient = 0.1
  pipe.heat_buffer.max_transfer = megawatts .. "MW"
  data:extend({pipe})
end
