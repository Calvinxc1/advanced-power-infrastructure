-- Headless measurement harness for heat-chain behaviour Wube does not document.
--
-- Emits "AERM <experiment>|<key>=<value>|..." lines to the log, which
-- scripts/factorio-measure.sh extracts and tests/test_heat_chain_measurements.py
-- asserts against. Never shipped with the mod.

local SURFACE = 1
local experiments = {}

local function emit(experiment, fields)
  local parts = {}
  for _, pair in ipairs(fields) do
    parts[#parts + 1] = ("%s=%s"):format(pair[1], tostring(pair[2]))
  end
  log(("AERM %s|%s"):format(experiment, table.concat(parts, "|")))
end

local function surface() return game.surfaces[SURFACE] end

-- defines.entity_status values are opaque integers; report the name so the
-- record is unambiguous without consulting the enum.
local function status_name(value)
  for name, candidate in pairs(defines.entity_status) do
    if candidate == value then return name end
  end
  return ("unknown(%s)"):format(tostring(value))
end

local function place(name, x, y)
  return surface().create_entity{
    name = name, position = {x, y}, force = game.forces.player,
  }
end

local function fuel(entity)
  entity.insert{name = "uranium-fuel-cell", count = 50}
  return entity
end

-- Experiment 1 -------------------------------------------------------------
-- What does LuaEntity.neighbour_bonus return: the per-neighbour prototype
-- value, or the aggregate across all neighbours?
experiments.neighbour_bonus = {
  setup = function(state)
    state.solo = fuel(place("nuclear-reactor", 0, 0))
    state.pair = {fuel(place("nuclear-reactor", 100, 0)), fuel(place("nuclear-reactor", 105, 0))}
    state.block = {}
    for i, pos in ipairs({{50, 0}, {55, 0}, {50, 5}, {55, 5}}) do
      state.block[i] = fuel(place("nuclear-reactor", pos[1], pos[2]))
    end
  end,
  sample = function(state, tick)
    if tick ~= 120 then return end
    emit("neighbour_bonus", {
      {"prototype_bonus", state.solo.prototype.neighbour_bonus},
      {"solo", state.solo.neighbour_bonus},
      {"inline_pair", state.pair[1].neighbour_bonus},
      {"block_corner", state.block[1].neighbour_bonus},
    })
  end,
}

-- Experiment 2 -------------------------------------------------------------
-- specific_heat: joules per degree, per entity? Drive a lone reactor with a
-- known heat output and measure the temperature slope. C = P / (dT/dt).
experiments.specific_heat = {
  setup = function(state)
    state.reactor = fuel(place("nuclear-reactor", 200, 0))
    state.samples = {}
  end,
  sample = function(state, tick)
    if tick % 60 ~= 0 or tick < 120 or tick > 360 then return end
    state.samples[#state.samples + 1] = {tick = tick, temp = state.reactor.temperature}
    if tick ~= 360 then return end

    local first, last = state.samples[1], state.samples[#state.samples]
    local per_second = (last.temp - first.temp) / ((last.tick - first.tick) / 60)
    emit("specific_heat", {
      {"consumption_w", state.reactor.prototype.get_max_energy_usage()},
      {"neighbour_bonus", state.reactor.neighbour_bonus},
      {"declared_specific_heat", state.reactor.prototype.heat_buffer_prototype.specific_heat},
      {"observed_deg_per_second", ("%.4f"):format(per_second)},
      {"first_temp", first.temp}, {"last_temp", last.temp},
      {"ticks", last.tick - first.tick},
    })
  end,
}

-- Experiment 3 -------------------------------------------------------------
-- #11: will a heat buffer below target_temperature still drive a boiler, so
-- the hard cutoff becomes a throughput taper? Uses aerm_decoupled-exchanger
-- (min_working 400, target 650) pinned at a series of network temperatures.
--
-- No plumbing: water is injected and steam extracted directly each tick, so
-- throughput is bounded only by the heat available, never by pipes.
experiments.exchanger_threshold = {
  setup = function(state)
    state.rows = {}
    for i, temperature in ipairs({350, 450, 550, 650, 800}) do
      state.rows[#state.rows + 1] = {
        temperature = temperature,
        exchanger = place("aerm_decoupled-exchanger", 305, i * 12),
        steam = 0,
      }
    end
  end,
  sample = function(state, tick)
    for _, row in ipairs(state.rows) do
      local exchanger = row.exchanger
      -- Hold the buffer at the network temperature under test, keep water
      -- unlimited, and drain the steam so the output box never saturates.
      exchanger.temperature = row.temperature
      exchanger.insert_fluid{name = "water", amount = 240}
      -- Fluid storage 2 is the boiler output box.
      local removed = exchanger.remove_fluid(2, 10000)
      local amount = type(removed) == "table" and removed.amount or (removed or 0)
      row.steam = row.steam + (amount or 0)
      row.last_status = exchanger.status
    end

    if tick ~= 600 then return end

    for _, row in ipairs(state.rows) do
      local proto = row.exchanger.prototype
      local buffer = proto.heat_buffer_prototype
      emit("exchanger_threshold", {
        {"network_temperature", row.temperature},
        {"min_working_temperature", buffer and buffer.min_working_temperature or "nil"},
        {"target_temperature", proto.target_temperature},
        {"status", status_name(row.last_status)},
        {"steam_total", ("%.2f"):format(row.steam)},
        {"steam_per_second", ("%.3f"):format(row.steam / (600 / 60))},
      })
    end
  end,
}

-- Experiment 4 -------------------------------------------------------------
-- #11, the regime that actually matters. Experiment 3 pins the buffer, which
-- supplies unlimited energy and so measures only the best case. Here the
-- buffer starts hot and is never topped up, so throughput is bounded by stored
-- energy -- the real constraint when a network dips.
--
-- If sustained output falls off gradually as the buffer drains, the taper #11
-- wants exists after all; it is just energy-driven rather than temperature-
-- driven. If output stays flat and then stops dead, the cliff is real.
experiments.exchanger_drain = {
  setup = function(state)
    state.rows = {}
    for i, temperature in ipairs({450, 650, 900}) do
      state.rows[#state.rows + 1] = {
        start_temperature = temperature,
        exchanger = place("aerm_decoupled-exchanger", 405, i * 12),
        buckets = {},
      }
    end
    state.primed = false
  end,
  sample = function(state, tick)
    if not state.primed then
      state.primed = true
      for _, row in ipairs(state.rows) do
        row.exchanger.temperature = row.start_temperature
      end
      return
    end

    for _, row in ipairs(state.rows) do
      local exchanger = row.exchanger
      exchanger.insert_fluid{name = "water", amount = 240}
      local removed = exchanger.remove_fluid(2, 10000)
      local amount = type(removed) == "table" and removed.amount or (removed or 0)

      -- Bucket production per second so the decay curve is visible.
      local bucket = math.floor(tick / 60) + 1
      row.buckets[bucket] = (row.buckets[bucket] or 0) + (amount or 0)
      row.last_temperature = exchanger.temperature
      row.last_status = exchanger.status
    end

    if tick ~= 480 then return end

    for _, row in ipairs(state.rows) do
      local curve = {}
      for bucket = 1, 8 do
        curve[#curve + 1] = ("%.1f"):format(row.buckets[bucket] or 0)
      end
      emit("exchanger_drain", {
        {"start_temperature", row.start_temperature},
        {"end_temperature", ("%.1f"):format(row.last_temperature or -1)},
        {"end_status", status_name(row.last_status)},
        {"steam_per_second_curve", table.concat(curve, ",")},
      })
    end
  end,
}

-- Experiment 5 -------------------------------------------------------------
-- What happens when steam of different temperatures meets in one pipe? This
-- mod ships eight steam sources from 165 to 1000 degrees, so the answer
-- decides whether tiers can share a pipe network at all.
experiments.steam_mixing = {
  setup = function(state)
    state.cases = {
      {label = "equal_500_1000", parts = {{500, 100}, {1000, 100}}},
      {label = "mostly_cold_500x3_1000", parts = {{500, 300}, {1000, 100}}},
      {label = "mostly_hot_500_1000x3", parts = {{500, 100}, {1000, 300}}},
      {label = "three_way_165_500_1000", parts = {{165, 100}, {500, 100}, {1000, 100}}},
    }
    for i, case in ipairs(state.cases) do
      case.tank = place("storage-tank", 500 + i * 6, 0)
    end
  end,
  sample = function(state, tick)
    if tick ~= 120 then return end

    for _, case in ipairs(state.cases) do
      local weighted, total = 0, 0
      for _, part in ipairs(case.parts) do
        local temperature, amount = part[1], part[2]
        case.tank.insert_fluid{name = "steam", amount = amount, temperature = temperature}
        weighted = weighted + temperature * amount
        total = total + amount
      end

      local fluid = case.tank.get_fluid(1)
      emit("steam_mixing", {
        {"case", case.label},
        {"inserted_total", total},
        {"weighted_average", ("%.1f"):format(weighted / total)},
        {"result_fluid", fluid and fluid.name or "none"},
        {"result_amount", fluid and ("%.1f"):format(fluid.amount) or "0"},
        {"result_temperature", fluid and ("%.1f"):format(fluid.temperature or -1) or "n/a"},
      })
    end
  end,
}

-- Driver -------------------------------------------------------------------
local state = {}
local started = false

script.on_event(defines.events.on_tick, function(event)
  if not started then
    started = true
    surface().always_day = true
    log("AERM_BEGIN")
    for name, experiment in pairs(experiments) do
      state[name] = {}
      local ok, err = pcall(experiment.setup, state[name])
      if not ok then emit("setup_error", {{"experiment", name}, {"error", err}}) end
    end
    return
  end

  for name, experiment in pairs(experiments) do
    local ok, err = pcall(experiment.sample, state[name], event.tick)
    if not ok then emit("sample_error", {{"experiment", name}, {"error", err}}) end
  end

  if event.tick == 660 then
    log("AERM_END")
    script.on_event(defines.events.on_tick, nil)
  end
end)
