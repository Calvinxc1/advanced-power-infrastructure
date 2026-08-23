-- Steam produced above `FluidPrototype::max_temperature` is treated as a distinct fluid by the
-- engine, so pipes carrying it refuse to connect to steam consumers ("Cannot connect pipelines
-- with different fluids"), and `GeneratorPrototype::maximum_temperature` is clamped by the same
-- ceiling when the engine derives `max_power_output`. Raise the ceiling to cover every steam
-- temperature this mod produces or consumes.

local steam_producers = {
  "heat-exchanger",
  "aer_heat-exchanger-2",
  "aer_heat-exchanger-3",
  "aer_heat-exchanger-4",
  "boiler",
  "aer_steel-boiler",
  "aer_rubber-lined-boiler",
  "aer_holmium-reinforced-boiler",
}

local steam_consumers = {
  "steam-turbine",
  "aer_rubber-lined-steam-turbine",
  "aer_reinforced-steam-turbine",
  "aer_foundation-steam-turbine",
  "steam-engine",
  "aer_steel-steam-engine",
  "aer_rubber-lined-steam-engine",
  "aer_holmium-steam-engine",
}

local steam = data.raw.fluid["steam"]
if not steam then
  return
end

local required = steam.max_temperature or steam.default_temperature or 0

for _, name in ipairs(steam_producers) do
  local boiler = data.raw.boiler[name]
  if boiler and boiler.output_fluid_box and boiler.output_fluid_box.filter == "steam" then
    required = math.max(required, boiler.target_temperature or 0)
  end
end

for _, name in ipairs(steam_consumers) do
  local generator = data.raw.generator[name]
  if generator and generator.fluid_box and generator.fluid_box.filter == "steam" then
    required = math.max(required, generator.maximum_temperature or 0)
  end
end

steam.max_temperature = required
