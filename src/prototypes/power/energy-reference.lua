-- Records every tier's energy and temperature figures as this mod sets them,
-- at the end of its data stage, so prototypes/power/energy-scale.lua can rebuild
-- them in data-final-fixes after an overhaul has changed the vanilla tiers.
--
-- The data stage runs every mod in one Lua state, so a global carries the
-- record from data.lua to data-final-fixes.lua. Nothing here changes a prototype.

local tiers = {
  exchangers = { "heat-exchanger", "aer_heat-exchanger-2", "aer_heat-exchanger-3", "aer_heat-exchanger-4" },
  boilers = { "boiler", "aer_steel-boiler", "aer_rubber-lined-boiler", "aer_holmium-reinforced-boiler" },
  turbines = { "steam-turbine", "aer_rubber-lined-steam-turbine", "aer_reinforced-steam-turbine", "aer_foundation-steam-turbine" },
  engines = { "steam-engine", "aer_steel-steam-engine", "aer_rubber-lined-steam-engine", "aer_holmium-steam-engine" },
  reactors = { "nuclear-reactor", "aer_nuclear-reactor-2", "aer_nuclear-reactor-3", "aer_nuclear-reactor-4" },
  heat_pipes = { "heat-pipe", "aer_heat-pipe-2", "aer_heat-pipe-3", "aer_heat-pipe-4" },
  solar_panels = { "solar-panel", "aer_holmium-solar-panel", "aer_cryogenic-solar-panel" },
  accumulators = { "accumulator", "aer_holmium-accumulator", "aer_cryogenic-accumulator" },
}

local reference = { tiers = tiers, steam_heat_capacity = data.raw.fluid["steam"].heat_capacity }

reference.exchangers = {}
for _, name in ipairs(tiers.exchangers) do
  local boiler = data.raw.boiler[name]
  if boiler then
    reference.exchangers[name] = {
      energy_consumption = boiler.energy_consumption,
      target_temperature = boiler.target_temperature,
      min_working_temperature = boiler.energy_source.min_working_temperature,
      max_temperature = boiler.energy_source.max_temperature,
      specific_heat = boiler.energy_source.specific_heat,
      max_transfer = boiler.energy_source.max_transfer,
    }
  end
end

reference.boilers = {}
for _, name in ipairs(tiers.boilers) do
  local boiler = data.raw.boiler[name]
  if boiler then
    reference.boilers[name] = {
      energy_consumption = boiler.energy_consumption,
      target_temperature = boiler.target_temperature,
    }
  end
end

local function generators(names)
  local result = {}
  for _, name in ipairs(names) do
    local generator = data.raw.generator[name]
    if generator then
      result[name] = {
        fluid_usage_per_tick = generator.fluid_usage_per_tick,
        maximum_temperature = generator.maximum_temperature,
        max_power_output = generator.max_power_output,
        effectivity = generator.effectivity,
      }
    end
  end
  return result
end
reference.turbines = generators(tiers.turbines)
reference.engines = generators(tiers.engines)

reference.reactors = {}
for _, name in ipairs(tiers.reactors) do
  local reactor = data.raw.reactor[name]
  if reactor then
    reference.reactors[name] = {
      consumption = reactor.consumption,
      neighbour_bonus = reactor.neighbour_bonus,
      max_temperature = reactor.heat_buffer.max_temperature,
      specific_heat = reactor.heat_buffer.specific_heat,
      max_transfer = reactor.heat_buffer.max_transfer,
    }
  end
end

reference.heat_pipes = {}
for _, name in ipairs(tiers.heat_pipes) do
  local pipe = data.raw["heat-pipe"][name]
  if pipe then
    reference.heat_pipes[name] = {
      max_temperature = pipe.heat_buffer.max_temperature,
      specific_heat = pipe.heat_buffer.specific_heat,
      max_transfer = pipe.heat_buffer.max_transfer,
      min_temperature_gradient = pipe.heat_buffer.min_temperature_gradient,
    }
  end
end

reference.solar_panels = {}
for _, name in ipairs(tiers.solar_panels) do
  local panel = data.raw["solar-panel"][name]
  if panel then
    reference.solar_panels[name] = { production = panel.production }
  end
end

reference.accumulators = {}
for _, name in ipairs(tiers.accumulators) do
  local accumulator = data.raw.accumulator[name]
  if accumulator then
    reference.accumulators[name] = {
      buffer_capacity = accumulator.energy_source.buffer_capacity,
      input_flow_limit = accumulator.energy_source.input_flow_limit,
      output_flow_limit = accumulator.energy_source.output_flow_limit,
    }
  end
end

AER_ENERGY_REFERENCE = reference
