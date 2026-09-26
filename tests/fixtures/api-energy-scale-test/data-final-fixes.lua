-- Invariants the heat chain keeps in every load, overhaul or not.
-- prototypes/power/energy-scale.lua scales each tier's energy to whatever an
-- overhaul made of the first rung (Krastorio 2's 50 MW exchanger, 250 MW
-- reactor, 0.5 kJ steam) and keeps this mod's temperatures, so none of these
-- depend on which overhaul is loaded. Values come from the mod's own constants
-- rather than being repeated here.

local constants = require("__advanced-power-infrastructure__/prototypes/power/fluid-constants")

local UNITS = { [""] = 1, k = 1e3, M = 1e6, G = 1e9 }
local function amount(value)
  local number, prefix = string.match(tostring(value or ""), "^([%d%.]+)%s*([kMG]?)[WJ]$")
  return number and tonumber(number) * UNITS[prefix] or nil
end

local function near(a, b)
  return math.abs(a - b) <= 1e-6 * math.max(1, math.abs(a), math.abs(b))
end

local tiers = {
  mk1 = { exchanger = "heat-exchanger", turbine = "steam-turbine", reactor = "nuclear-reactor", pipe = "heat-pipe" },
  mk2 = { exchanger = "aer_heat-exchanger-2", turbine = "aer_rubber-lined-steam-turbine", reactor = "aer_nuclear-reactor-2", pipe = "aer_heat-pipe-2" },
  mk3 = { exchanger = "aer_heat-exchanger-3", turbine = "aer_reinforced-steam-turbine", reactor = "aer_nuclear-reactor-3", pipe = "aer_heat-pipe-3" },
  mk4 = { exchanger = "aer_heat-exchanger-4", turbine = "aer_foundation-steam-turbine", reactor = "aer_nuclear-reactor-4", pipe = "aer_heat-pipe-4" },
}

local steam = data.raw.fluid["steam"]
local heat_capacity = amount(steam.heat_capacity)
local ambient = steam.default_temperature or 15

local function turbine_output(turbine)
  local output = turbine.fluid_usage_per_tick * 60 * heat_capacity
    * (turbine.maximum_temperature - ambient) * (turbine.effectivity or 1)
  local cap = amount(turbine.max_power_output)
  return cap and math.min(cap, output) or output
end

local turbines_per_exchanger
for tier, names in pairs(tiers) do
  local exchanger = data.raw.boiler[names.exchanger]
  if exchanger then
    local turbine = data.raw.generator[names.turbine]
    local reactor = data.raw.reactor[names.reactor]
    local pipe = data.raw["heat-pipe"][names.pipe]
    local draw = amount(exchanger.energy_consumption)
    local ceiling = constants.heat_tier_ceiling[tier]

    -- Temperatures are this mod's, whatever an overhaul set.
    assert(exchanger.target_temperature == constants.heat_tier_optimal[tier],
      names.exchanger .. " target " .. tostring(exchanger.target_temperature)
        .. ", expected " .. constants.heat_tier_optimal[tier])
    assert(exchanger.energy_source.min_working_temperature == constants.heat_exchanger_min_working_temperature,
      names.exchanger .. " works from " .. tostring(exchanger.energy_source.min_working_temperature)
        .. ", expected " .. constants.heat_exchanger_min_working_temperature)
    assert(turbine.maximum_temperature == constants.heat_tier_optimal[tier],
      names.turbine .. " maximum temperature " .. tostring(turbine.maximum_temperature))
    -- Without Space Age the reactor and pipe ladders stop at mk2 while the
    -- exchanger ladder reaches mk3, so each family is checked where it exists.
    if reactor then
      assert(reactor.heat_buffer.max_temperature == ceiling, names.reactor .. " ceiling")
      -- control.lua pays the neighbour bonus, so the engine's must stay off.
      assert(reactor.neighbour_bonus == 0,
        names.reactor .. " neighbour_bonus " .. tostring(reactor.neighbour_bonus) .. ", expected 0")
    end

    if pipe then
      assert(pipe.heat_buffer.max_temperature == ceiling, names.pipe .. " ceiling")
      assert(near(pipe.heat_buffer.min_temperature_gradient, constants.heat_tier_gradient[tier]),
        names.pipe .. " gradient")
      -- Heat buffers keep their ratio to the exchanger draw, which is what
      -- keeps a loaded run's temperature profile, and so every reach figure,
      -- intact.
      local expected_transfer = constants.heat_tier_reference_spoke[tier] * constants.heat_tier_flow_headroom[tier]
      assert(near(amount(pipe.heat_buffer.max_transfer) / draw, expected_transfer),
        names.pipe .. " max_transfer " .. tostring(pipe.heat_buffer.max_transfer)
          .. " is not " .. expected_transfer .. " exchanger draws (" .. exchanger.energy_consumption .. ")")
    end

    -- The same number of turbines per exchanger at every tier.
    local ratio = draw / turbine_output(turbine)
    turbines_per_exchanger = turbines_per_exchanger or ratio
    assert(math.abs(ratio - turbines_per_exchanger) < 0.01 * turbines_per_exchanger,
      tier .. " feeds " .. ratio .. " turbines per exchanger, mk1 feeds " .. turbines_per_exchanger)

    -- Steam this chain makes must be steam, not a distinct over-temperature fluid.
    assert(steam.max_temperature >= exchanger.target_temperature,
      "steam max_temperature " .. steam.max_temperature .. " is below " .. names.exchanger .. "'s target")
  end
end

-- The mk1 heat buffers scale with the mk1 draw by the factor the design
-- record fixes: 1 MJ of pipe per 10 MW of exchanger.
local mk1_draw = amount(data.raw.boiler["heat-exchanger"].energy_consumption)
local mk1_pipe = data.raw["heat-pipe"]["heat-pipe"]
assert(near(amount(mk1_pipe.heat_buffer.specific_heat) / mk1_draw, 1e6 / (constants.heat_tier_exchanger_draw.mk1 * 1e6)),
  "heat-pipe specific_heat " .. tostring(mk1_pipe.heat_buffer.specific_heat)
    .. " is out of step with the exchanger draw " .. tostring(data.raw.boiler["heat-exchanger"].energy_consumption))

-- The Space Age solar and accumulator tiers keep their multiples of the
-- vanilla panel and accumulator (src/prototypes/power/solar/entities.lua),
-- whatever an overhaul made of those.
local multiples = { holmium = 4, cryogenic = 8 }
local base_panel = data.raw["solar-panel"]["solar-panel"]
local base_accumulator = data.raw.accumulator["accumulator"]
for tier, multiple in pairs(multiples) do
  local panel = data.raw["solar-panel"]["aer_" .. tier .. "-solar-panel"]
  if panel then
    assert(near(amount(panel.production) / amount(base_panel.production), multiple),
      panel.name .. " makes " .. panel.production .. ", not " .. multiple .. "x " .. base_panel.production)
  end
  local accumulator = data.raw.accumulator["aer_" .. tier .. "-accumulator"]
  if accumulator then
    for _, field in ipairs({ "buffer_capacity", "input_flow_limit", "output_flow_limit" }) do
      assert(near(amount(accumulator.energy_source[field]) / amount(base_accumulator.energy_source[field]), multiple),
        accumulator.name .. " " .. field .. " is not " .. multiple .. "x the accumulator's")
    end
  end
end

log("api-energy-scale-test: heat-chain invariants hold")
