-- Rebuilds every power tier after overhauls have edited the vanilla tiers this
-- mod adopts as its first rung. Runs in data-final-fixes, after the mods this
-- one loads after have finished, from the figures
-- prototypes/power/energy-reference.lua recorded at the end of its data stage.
--
-- Krastorio 2 rescales the whole steam and nuclear economy: its reactor makes
-- 250 MW, its heat exchanger draws 50 MW, its turbine makes 10 MW, and a unit of
-- steam carries 0.5 kJ per degree rather than 0.2. It also moves temperatures:
-- exchanger and turbine to 415 degrees, the exchanger's working floor to 415.
--
-- Energy follows the overhaul; temperature stays this mod's. Each family's
-- scale is whatever the overhaul made of its first rung, and every tier keeps
-- its multiplier over that rung:
--
--   heat      exchanger draw          exchangers, and the specific heat and
--                                      max_transfer of every exchanger, reactor
--                                      and heat pipe
--   reactor   reactor consumption      reactor output
--   boiler    boiler consumption       fuel boiler draw
--   turbine   turbine output           turbine output
--   engine    steam engine output      steam engine output
--   solar     solar panel output       solar panel output (Space Age tiers)
--   storage   accumulator capacity     accumulator capacity
--   flow      accumulator flow limit   accumulator charge and discharge rate
--
-- Heat buffers scale with the exchanger draw rather than the reactor output
-- because they carry the exchangers' heat: scaling draw, specific heat and
-- max_transfer together leaves a loaded run's temperature profile unchanged
-- (the energy_scale experiment in tests/harness/aer-measure: within 0.6
-- degrees at 13 tiles under 5x). So every reach figure in
-- docs/nuclear-heat-guide.md holds under an overhaul. Krastorio 2's own heat
-- pipe (6 MJ, 6 GW) would run three degrees warm; an unscaled one 87 cold.
--
-- Temperatures -- targets, working floors, ceilings, the per-tile gradient --
-- and the neighbour bonus (which control.lua pays) are set back to this mod's.
-- Generators keep their steam temperatures and have their steam use corrected
-- for the overhaul's steam heat capacity, so each makes its scaled output.
--
-- In a load with no overhaul every scale is 1 and every figure is the one this
-- mod set, so nothing changes.

local fluid_helpers = require("prototypes.power.fluid-helpers")

local reference = AER_ENERGY_REFERENCE
if not reference then
  return
end

local UNITS = { [""] = 1, k = 1e3, M = 1e6, G = 1e9 }

local function amount(value)
  local number, prefix = string.match(value or "", "^([%d%.]+)%s*([kMG]?)[WJ]$")
  return number and tonumber(number) * UNITS[prefix] or nil
end

-- The reference string itself when nothing scales, so an unchanged load keeps
-- the exact text this mod wrote.
local function scaled(value, factor, unit)
  if factor == 1 or not value then
    return value
  end
  local total = amount(value) * factor
  for _, prefix in ipairs({ "G", "M", "k" }) do
    if total >= UNITS[prefix] then
      return ("%g%s%s"):format(total / UNITS[prefix], prefix, unit)
    end
  end
  return ("%g%s"):format(total, unit)
end

local steam = data.raw.fluid["steam"]
local heat_capacity = amount(steam.heat_capacity)
local reference_heat_capacity = amount(reference.steam_heat_capacity)
local ambient = steam.default_temperature or 15

-- A generator's rated output: steam per tick times the energy a unit carries
-- above ambient, capped by max_power_output where one is set.
local function generator_output(generator, capacity)
  local output = generator.fluid_usage_per_tick * 60 * capacity
    * (generator.maximum_temperature - ambient) * (generator.effectivity or 1)
  local cap = amount(generator.max_power_output)
  return cap and math.min(cap, output) or output
end

local function ratio(final, recorded)
  if not (final and recorded) or recorded == 0 then
    return 1
  end
  local value = final / recorded
  -- Rounding noise from string round-trips is not a scale.
  return math.abs(value - 1) < 1e-9 and 1 or value
end

local mk1 = {
  exchanger = data.raw.boiler["heat-exchanger"],
  reactor = data.raw.reactor["nuclear-reactor"],
  boiler = data.raw.boiler["boiler"],
  turbine = data.raw.generator["steam-turbine"],
  engine = data.raw.generator["steam-engine"],
}

local scale = {
  heat = ratio(amount(mk1.exchanger.energy_consumption),
    amount(reference.exchangers["heat-exchanger"].energy_consumption)),
  reactor = ratio(amount(mk1.reactor.consumption),
    amount(reference.reactors["nuclear-reactor"].consumption)),
  boiler = ratio(amount(mk1.boiler.energy_consumption),
    amount(reference.boilers["boiler"].energy_consumption)),
  turbine = ratio(generator_output(mk1.turbine, heat_capacity),
    generator_output(reference.turbines["steam-turbine"], reference_heat_capacity)),
  engine = ratio(generator_output(mk1.engine, heat_capacity),
    generator_output(reference.engines["steam-engine"], reference_heat_capacity)),
}

local solar_panel = data.raw["solar-panel"]["solar-panel"]
local accumulator = data.raw.accumulator["accumulator"]
local recorded_panel = reference.solar_panels["solar-panel"]
local recorded_accumulator = reference.accumulators["accumulator"]
scale.solar = ratio(amount(solar_panel and solar_panel.production),
  amount(recorded_panel and recorded_panel.production))
scale.storage = ratio(amount(accumulator and accumulator.energy_source.buffer_capacity),
  amount(recorded_accumulator and recorded_accumulator.buffer_capacity))
scale.flow = ratio(amount(accumulator and accumulator.energy_source.output_flow_limit),
  amount(recorded_accumulator and recorded_accumulator.output_flow_limit))

for name, recorded in pairs(reference.exchangers) do
  local boiler = data.raw.boiler[name]
  boiler.energy_consumption = scaled(recorded.energy_consumption, scale.heat, "W")
  boiler.target_temperature = recorded.target_temperature
  boiler.energy_source.min_working_temperature = recorded.min_working_temperature
  boiler.energy_source.max_temperature = recorded.max_temperature
  boiler.energy_source.specific_heat = scaled(recorded.specific_heat, scale.heat, "J")
  boiler.energy_source.max_transfer = scaled(recorded.max_transfer, scale.heat, "W")
end

for name, recorded in pairs(reference.boilers) do
  local boiler = data.raw.boiler[name]
  boiler.energy_consumption = scaled(recorded.energy_consumption, scale.boiler, "W")
  boiler.target_temperature = recorded.target_temperature
end

-- Steam use scales with output and inversely with what a unit of steam
-- carries, at the tier's own unchanged temperature.
local steam_factor = ratio(reference_heat_capacity, heat_capacity)
local function rebuild_generators(recorded_set, factor)
  for name, recorded in pairs(recorded_set) do
    local generator = data.raw.generator[name]
    local usage = factor * steam_factor
    generator.fluid_usage_per_tick = usage == 1 and recorded.fluid_usage_per_tick
      or recorded.fluid_usage_per_tick * usage
    generator.maximum_temperature = recorded.maximum_temperature
    generator.max_power_output = recorded.max_power_output
    generator.effectivity = recorded.effectivity
  end
end
rebuild_generators(reference.turbines, scale.turbine)
rebuild_generators(reference.engines, scale.engine)

for name, recorded in pairs(reference.reactors) do
  local reactor = data.raw.reactor[name]
  reactor.consumption = scaled(recorded.consumption, scale.reactor, "W")
  reactor.neighbour_bonus = recorded.neighbour_bonus
  reactor.heat_buffer.max_temperature = recorded.max_temperature
  reactor.heat_buffer.specific_heat = scaled(recorded.specific_heat, scale.heat, "J")
  reactor.heat_buffer.max_transfer = scaled(recorded.max_transfer, scale.heat, "W")
end

for name, recorded in pairs(reference.heat_pipes) do
  local pipe = data.raw["heat-pipe"][name]
  pipe.heat_buffer.max_temperature = recorded.max_temperature
  pipe.heat_buffer.min_temperature_gradient = recorded.min_temperature_gradient
  pipe.heat_buffer.specific_heat = scaled(recorded.specific_heat, scale.heat, "J")
  pipe.heat_buffer.max_transfer = scaled(recorded.max_transfer, scale.heat, "W")
  -- The tooltip states what the pipe carries and moves, so it follows.
  fluid_helpers.set_description(pipe, fluid_helpers.heat_pipe_description(pipe.heat_buffer))
  local item = data.raw.item[name]
  if item then
    fluid_helpers.set_description(item, fluid_helpers.heat_pipe_description(pipe.heat_buffer))
  end
end

-- Krastorio 2 raises the vanilla panel to 100 kW and accumulator to 10 MJ;
-- the Space Age solar and accumulator tiers keep their multiples of them.
for name, recorded in pairs(reference.solar_panels) do
  data.raw["solar-panel"][name].production = scaled(recorded.production, scale.solar, "W")
end

for name, recorded in pairs(reference.accumulators) do
  local source = data.raw.accumulator[name].energy_source
  source.buffer_capacity = scaled(recorded.buffer_capacity, scale.storage, "J")
  source.input_flow_limit = scaled(recorded.input_flow_limit, scale.flow, "W")
  source.output_flow_limit = scaled(recorded.output_flow_limit, scale.flow, "W")
end
