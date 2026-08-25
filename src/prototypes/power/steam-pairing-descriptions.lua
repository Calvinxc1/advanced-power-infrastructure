-- Says, on every steam machine, what temperature it makes or wants.
--
-- Each generator tier pairs exactly with a boiler or heat exchanger tier, and
-- nothing in game states the pairing. A player has no way to tell that a
-- foundation turbine on 500 degree steam is running at 49 percent -- it does not
-- stall, it does not warn, it just quietly produces half of what it should.
--
-- Runs in data-final-fixes so it sees the finished numbers, and reads every
-- figure from the prototype it is describing rather than from a table here, so
-- a tooltip cannot drift from the machine it belongs to. See issue #12.

local constants = require("prototypes.power.fluid-constants")
local fluid_helpers = require("prototypes.power.fluid-helpers")

-- The accept threshold, fluid_box.minimum_temperature, is deliberately not
-- stated. Every tier inherits vanilla's 100, so a line for it would be
-- identical on all eight and would say nothing about which tier pairs with
-- which.
local function describe(name, line)
  fluid_helpers.add_description_line(data.raw.item[name], line)
end

for _, name in ipairs(constants.steam_consumers) do
  local generator = data.raw.generator[name]
  if generator then
    local line = fluid_helpers.generator_optimal_description(generator.maximum_temperature)
    fluid_helpers.add_description_line(generator, line)
    describe(name, line)
  end
end

for _, name in ipairs(constants.steam_producers) do
  local boiler = data.raw.boiler[name]
  if boiler then
    -- A heat exchanger's steam follows the heat network; a fuel boiler's does
    -- not. The distinction is the energy source, not the name.
    local heated = boiler.energy_source and boiler.energy_source.type == "heat"
    local line = heated
      and fluid_helpers.exchanger_steam_description(boiler.target_temperature)
      or fluid_helpers.boiler_steam_description(boiler.target_temperature)
    fluid_helpers.add_description_line(boiler, line)
    describe(name, line)
  end
end
