-- Headless measurement harness for heat-chain behaviour Wube does not document.
--
-- Emits "AERM <experiment>|<key>=<value>|..." lines to the log, which
-- scripts/factorio-measure.sh extracts and prints. Records are read by a person
-- rather than asserted against: these experiments answer design questions once,
-- and the answers are written into the code and docs that depend on them.
-- Never shipped with the mod.

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
  -- raise_built matters: without it the mod's own control.lua never sees these
  -- entities, and the harness would be testing a registry that stayed empty.
  return surface().create_entity{
    name = name, position = {x, y}, force = game.forces.player, raise_built = true,
  }
end

local function fuel(entity)
  entity.insert{name = "uranium-fuel-cell", count = 50}
  return entity
end

-- Attach a pipe to a machine's output fluid box.
--
-- LuaEntity.fluidbox is gone in 2.1 -- the fluid box API now hangs off the
-- entity directly -- so there is no get_pipe_connections to ask. Rather than
-- reason about footprints and connection offsets, try the candidate tiles and
-- keep the one the engine actually reports as a neighbour. A rig that guessed
-- wrong then reports nothing instead of reporting something misleading.
local function attach_pipe(entity, box_index)
  for _, offset in ipairs({{0, -1.5}, {0, -2}, {0, -2.5}, {0, -1}}) do
    local pipe = surface().create_entity{
      name = "pipe",
      position = {entity.position.x + offset[1], entity.position.y + offset[2]},
      force = game.forces.player,
    }
    if pipe then
      local neighbours = entity.fluidbox_neighbours
      for _, candidate in pairs((neighbours and neighbours[box_index]) or {}) do
        if candidate == pipe then return pipe end
      end
      pipe.destroy()
    end
  end
  return nil
end

-- Fill the straight line between two pipes so they share one fluid segment.
-- Returns false if they are not on a common row or column, which makes a rig
-- that silently failed to connect obvious in the record.
local function join_pipes(first, second)
  if not (first and second and first.valid and second.valid) then return false end
  local a, b = first.position, second.position
  if a.y ~= b.y and a.x ~= b.x then return false end

  local step = 1
  if a.x == b.x then
    if b.y < a.y then step = -1 end
    for y = a.y + step, b.y - step, step do
      surface().create_entity{name = "pipe", position = {a.x, y}, force = game.forces.player}
    end
  else
    if b.x < a.x then step = -1 end
    for x = a.x + step, b.x - step, step do
      surface().create_entity{name = "pipe", position = {x, a.y}, force = game.forces.player}
    end
  end
  return true
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

-- Experiment 6 -------------------------------------------------------------
-- The crux for the proposed design: when the heat buffer sits BELOW
-- target_temperature, what temperature is the steam that comes out?
--
-- If it tracks the buffer, output temperature scales with the network and
-- turbines taper smoothly. If it is pinned to target_temperature, the engine
-- manufactures heat it was never given, and the design needs another route.
experiments.output_temperature = {
  setup = function(state)
    state.rows = {}
    for i, temperature in ipairs({420, 500, 575, 650, 800, 1000}) do
      state.rows[#state.rows + 1] = {
        buffer_temperature = temperature,
        exchanger = place("aerm_decoupled-exchanger", 605, i * 12),
      }
    end
  end,
  sample = function(state, tick)
    for _, row in ipairs(state.rows) do
      row.exchanger.temperature = row.buffer_temperature
      row.exchanger.insert_fluid{name = "water", amount = 240}
      local produced = row.exchanger.get_fluid(2)
      if produced and produced.amount > 0 then
        row.output_temperature = produced.temperature
        row.output_fluid = produced.name
      end
      row.exchanger.remove_fluid(2, 10000)
    end

    if tick ~= 300 then return end

    for _, row in ipairs(state.rows) do
      emit("output_temperature", {
        {"buffer_temperature", row.buffer_temperature},
        {"target_temperature", row.exchanger.prototype.target_temperature},
        {"output_fluid", row.output_fluid or "none"},
        {"output_temperature", row.output_temperature
          and ("%.1f"):format(row.output_temperature) or "none"},
      })
    end
  end,
}

-- Experiment 7 -------------------------------------------------------------
-- Can steam temperature track the heat network rather than being pinned to a
-- fixed target? Tests mode = "heat-fluid-inside", which heats the fluid in
-- place instead of converting it, against a series of pinned buffer values.
experiments.superheater = {
  setup = function(state)
    state.rows = {}
    for i, temperature in ipairs({450, 600, 800, 1000}) do
      state.rows[#state.rows + 1] = {
        buffer_temperature = temperature,
        boiler = place("aerm_superheater", 705, i * 12),
      }
    end
  end,
  sample = function(state, tick)
    for _, row in ipairs(state.rows) do
      row.boiler.temperature = row.buffer_temperature
      -- Feed cool steam in and see how hot it comes back out.
      row.boiler.insert_fluid{name = "steam", amount = 60, temperature = 165}
      for index = 1, 2 do
        local fluid = row.boiler.get_fluid(index)
        if fluid and fluid.amount > 0 then
          row["box" .. index] = ("%s@%.1f x%.1f"):format(
            fluid.name, fluid.temperature or -1, fluid.amount)
        end
      end
    end

    if tick ~= 420 then return end

    for _, row in ipairs(state.rows) do
      emit("superheater", {
        {"buffer_temperature", row.buffer_temperature},
        {"input_box", row.box1 or "empty"},
        {"output_box", row.box2 or "empty"},
        {"status", status_name(row.boiler.status)},
      })
    end
  end,
}

-- Experiment 8 -------------------------------------------------------------
-- Can control.lua give steam a temperature that tracks the heat network?
--
-- set_fluid_segment_fluid writes a whole connected pipe network at once, so the
-- cost would scale with the number of steam networks rather than the number of
-- exchangers. Part A proves the segment write works and propagates. Part B
-- reports the exchanger's real pipe connection geometry so a wired rig can be
-- built without guessing at offsets.
experiments.segment_rewrite = {
  setup = function(state)
    -- Part A: a bare pipe run, no machine attached.
    state.pipes = {}
    for i = 1, 8 do
      state.pipes[i] = place("pipe", 800 + i, 0)
    end

    -- Part B: geometry of the exchanger's boxes.
    state.exchanger = place("aer_heat-exchanger-2", 805, 20)
  end,
  sample = function(state, tick)
    if tick == 60 then
      local head = state.pipes[1]
      head.insert_fluid{name = "steam", amount = 400, temperature = 650}

      local before = head.get_fluid_segment_fluid(1)
      state.before = before and ("%s@%.1f x%.1f"):format(
        before.name, before.temperature or -1, before.amount) or "empty"

      if before and before.amount > 0 then
        head.set_fluid_segment_fluid(1, {
          name = "steam", amount = before.amount, temperature = 500,
        })
      end

      local after = head.get_fluid_segment_fluid(1)
      state.after = after and ("%s@%.1f x%.1f"):format(
        after.name, after.temperature or -1, after.amount) or "empty"

      local far = state.pipes[8].get_fluid_segment_fluid(1)
      state.far_end = far and ("%s@%.1f x%.1f"):format(
        far.name, far.temperature or -1, far.amount) or "empty"
      state.same_segment = tostring(
        state.pipes[8].get_fluid_segment_id(1) == head.get_fluid_segment_id(1))
    end

    if tick ~= 120 then return end

    emit("segment_rewrite", {
      {"before_write", state.before or "n/a"},
      {"after_write", state.after or "n/a"},
      {"far_end", state.far_end or "n/a"},
      {"far_end_same_segment", state.same_segment or "n/a"},
    })

    -- Report the exchanger's connection geometry for the wired rig.
    for index = 1, 2 do
      local ok, connections = pcall(function()
        return state.exchanger.get_fluid_box_pipe_connections(index)
      end)
      if ok and connections then
        local described = {}
        for _, connection in ipairs(connections) do
          local target = connection.target_position or connection.position
          described[#described + 1] = target
            and ("(%.1f,%.1f)"):format(target.x, target.y) or "?"
        end
        emit("exchanger_geometry", {
          {"box_index", index},
          {"entity_position", ("(%.1f,%.1f)"):format(
            state.exchanger.position.x, state.exchanger.position.y)},
          {"has_segment", tostring(state.exchanger.has_fluid_segment(index))},
          {"connections", table.concat(described, " ")},
        })
      end
    end
  end,
}

-- Experiment 9 -------------------------------------------------------------
-- How fast does a rewritten segment drift back toward the boiler's fixed 650
-- output, and what does the rewrite actually cost?
--
-- Pipes are placed on the connection target the engine reports, rather than at
-- a guessed offset, because guessing it failed twice.
experiments.drift_and_cost = {
  setup = function(state)
    state.exchanger = place("aer_heat-exchanger-2", 905, 40)

    -- Ask the engine where the output box wants its pipe, then build there.
    state.pipes = {}
    local connections = state.exchanger.get_fluid_box_pipe_connections(2)
    for _, connection in ipairs(connections or {}) do
      local target = connection.target_position or connection.position
      if target then
        state.wired_at = ("(%.1f,%.1f)"):format(target.x, target.y)
        local step = (target.y < state.exchanger.position.y) and -1 or 1
        for i = 0, 5 do
          state.pipes[#state.pipes + 1] =
            surface().create_entity{
              name = "pipe",
              position = {target.x, target.y + step * i},
              force = game.forces.player,
            }
        end
      end
    end

    state.samples = {}
    -- A separate population, to time a realistic batch of segment writes.
    state.rigs = {}
    for i = 1, 50 do
      state.rigs[i] = place("pipe", 1000 + i * 2, 60)
      state.rigs[i].insert_fluid{name = "steam", amount = 100, temperature = 650}
    end
  end,
  sample = function(state, tick)
    local exchanger = state.exchanger
    exchanger.temperature = 900
    exchanger.insert_fluid{name = "water", amount = 240}

    if tick == 180 then
      state.connected = tostring(exchanger.has_fluid_segment(2))
      if exchanger.has_fluid_segment(2) then
        local current = exchanger.get_fluid_segment_fluid(2)
        state.before = current and ("%.1f x%.1f"):format(
          current.temperature or -1, current.amount) or "empty"
        if current and current.amount > 0 then
          exchanger.set_fluid_segment_fluid(2,
            {name = "steam", amount = current.amount, temperature = 500})
        end
      end
    end

    if tick > 180 and tick <= 300 and (tick - 180) % 15 == 0 then
      local now = exchanger.has_fluid_segment(2)
        and exchanger.get_fluid_segment_fluid(2) or nil
      state.samples[#state.samples + 1] =
        ("+%d:%.1f"):format(tick - 180, now and now.temperature or -1)
    end

    if tick == 320 then
      local profiler = helpers.create_profiler()
      for _, pipe in ipairs(state.rigs) do
        if pipe.valid and pipe.has_fluid_segment(1) then
          local fluid = pipe.get_fluid_segment_fluid(1)
          if fluid and fluid.amount > 0 then
            pipe.set_fluid_segment_fluid(1,
              {name = "steam", amount = fluid.amount, temperature = 520})
          end
        end
      end
      profiler.stop()
      log{"", "AERM_PROFILE writes=50 elapsed=", profiler}
    end

    if tick ~= 340 then return end
    emit("drift_and_cost", {
      {"wired_at", state.wired_at or "no connection reported"},
      {"output_connected", state.connected or "n/a"},
      {"segment_before_write", state.before or "n/a"},
      {"drift_after_write", table.concat(state.samples, " ")},
    })
  end,
}

-- Experiment 10 ------------------------------------------------------------
-- Drift, measured on a bare segment so no plumbing geometry is involved.
--
-- A mk2 exchanger produces 141.7 steam/second at a fixed 650 degrees, which is
-- 2.36 units per tick. Injecting exactly that into a segment held at 500
-- reproduces the drift a rewrite would have to fight, and shows how often the
-- rewrite must run to hold a target temperature.
experiments.drift_rate = {
  setup = function(state)
    state.cases = {}
    -- Vary the correction interval: every tick, every 6, every 30, never.
    for i, interval in ipairs({1, 6, 30, 0}) do
      local pipes = {}
      for j = 1, 10 do
        pipes[j] = place("pipe", 1200 + i * 20 + j, 100)
      end
      pipes[1].insert_fluid{name = "steam", amount = 400, temperature = 500}
      state.cases[#state.cases + 1] =
        {interval = interval, head = pipes[1], samples = {}}
    end
  end,
  sample = function(state, tick)
    for _, case in ipairs(state.cases) do
      local head = case.head
      if head.valid and head.has_fluid_segment(1) then
        -- The boiler's contribution: 2.36 units per tick at its fixed 650.
        head.insert_fluid{name = "steam", amount = 2.36, temperature = 650}

        -- Drain downstream demand so the segment does not simply fill up.
        head.remove_fluid_segment_fluid(1, 2.36)

        if case.interval > 0 and tick % case.interval == 0 then
          local fluid = head.get_fluid_segment_fluid(1)
          if fluid and fluid.amount > 0 then
            head.set_fluid_segment_fluid(1,
              {name = "steam", amount = fluid.amount, temperature = 500})
          end
        end

        if tick % 60 == 0 and tick <= 300 then
          local fluid = head.get_fluid_segment_fluid(1)
          case.samples[#case.samples + 1] =
            ("%.1f"):format(fluid and fluid.temperature or -1)
        end
      end
    end

    if tick ~= 360 then return end
    for _, case in ipairs(state.cases) do
      emit("drift_rate", {
        {"correction_interval_ticks", case.interval == 0 and "never" or case.interval},
        {"held_target", 500},
        {"temperature_each_second", table.concat(case.samples, ",")},
      })
    end
  end,
}

-- Experiment 11 ------------------------------------------------------------
-- End-to-end check of the shipped passthrough in src/control.lua: does steam
-- actually leave at clamp(buffer, min_working, target)?
experiments.passthrough = {
  setup = function(state)
    state.rows = {}
    -- Sweep both the steel tier (optimal 500) and mk2 (optimal 650) across a
    -- common 300 floor, so clamping is exercised at two different optima.
    local cases = {}
    for _, name in ipairs({"heat-exchanger", "aer_heat-exchanger-2"}) do
      for _, buffer in ipairs({250, 350, 500, 650, 900}) do
        cases[#cases + 1] = {name = name, buffer = buffer}
      end
    end

    for i, case in ipairs(cases) do
      local buffer = case.buffer
      local x = 1400 + i * 12
      local exchanger = place(case.name, x, 200)
      local row = {buffer = buffer, exchanger = exchanger, pipes = {}}

      local connections = exchanger.get_fluid_box_pipe_connections(2)
      row.connection_count = connections and #connections or 0
      for _, connection in ipairs(connections or {}) do
        local target = connection.target_position or connection.position
        if target then
          row.target = ("(%.1f,%.1f)"):format(target.x, target.y)
          for j = 0, 4 do
            local pipe = surface().create_entity{
              name = "pipe",
              position = {target.x, target.y - j},
              force = game.forces.player,
              raise_built = true,
            }
            row.pipes[#row.pipes + 1] = pipe
          end
        end
      end
      row.pipes_created = #row.pipes
      state.rows[#state.rows + 1] = row
    end
  end,
  sample = function(state, tick)
    for _, row in ipairs(state.rows) do
      row.exchanger.temperature = row.buffer
      row.exchanger.insert_fluid{name = "water", amount = 240}
    end

    if tick ~= 300 then return end

    for _, row in ipairs(state.rows) do
      local proto = row.exchanger.prototype
      local buffer_proto = proto.heat_buffer_prototype
      local connected = row.exchanger.has_fluid_segment(2)
      local fluid = connected and row.exchanger.get_fluid_segment_fluid(2) or nil
      local far = row.pipes[5] and row.pipes[5].valid
        and row.pipes[5].has_fluid_segment(1)
        and row.pipes[5].get_fluid_segment_fluid(1) or nil

      -- Where does the segment actually live, if not on the machine box?
      local neighbours = row.exchanger.fluidbox_neighbours
      local group = neighbours and neighbours[2]
      local probe = group and group[1]
      emit("segment_location", {
        {"buffer", row.buffer},
        {"machine_box_has_segment", tostring(row.exchanger.has_fluid_segment(2))},
        {"output_neighbour_count", group and #group or 0},
        {"neighbour_name", probe and probe.name or "none"},
        {"neighbour_has_segment", probe and tostring(probe.has_fluid_segment(1)) or "n/a"},
        {"neighbour_segment_temp", (probe and probe.has_fluid_segment(1)
          and probe.get_fluid_segment_fluid(1))
          and ("%.1f"):format(probe.get_fluid_segment_fluid(1).temperature or -1) or "none"},
      })

      emit("passthrough", {
        {"exchanger", row.exchanger.name},
        {"buffer", row.buffer},
        {"min_working", buffer_proto and buffer_proto.min_working_temperature or "nil"},
        {"target", proto.target_temperature},
        {"pipes_created", row.pipes_created},
        {"connection_target", row.target or "none"},
        {"output_connected", tostring(connected)},
        {"steam_at_exchanger", fluid and ("%.1f"):format(fluid.temperature or -1) or "none"},
        {"steam_at_pipe_end", far and ("%.1f"):format(far.temperature or -1) or "none"},
        {"status", status_name(row.exchanger.status)},
      })
    end
  end,
}

-- Experiment 12 ------------------------------------------------------------
-- What does min_temperature_gradient actually do to a heat run?
--
-- Distance is free today: heat reaches the far end of any length of pipe at
-- full temperature, so nothing stops a reactor block sprouting a 40-tile run.
-- If this field imposes a per-connection temperature cost, it is the lever that
-- makes exchangers want to stay near the reactor.
--
-- Uses a heat-interface pinned at 1000 rather than a reactor: it is 1x1 so the
-- run connects without hunting for heat ports, and pinning it removes warm-up
-- time from the measurement entirely.
experiments.gradient = {
  setup = function(state)
    state.runs = {}
    local variants = {
      {name = "heat-pipe", label = "default(1)"},
      {name = "aerm_gradient-5", label = "5"},
      {name = "aerm_gradient-10", label = "10"},
      {name = "aerm_gradient-25", label = "25"},
      {name = "aerm_gradient-50", label = "50"},
    }

    for i, variant in ipairs(variants) do
      local y = 300 + i * 30
      local run = {label = variant.label, pipes = {}}
      run.source = place("heat-interface", 0, y)

      for j = 1, 40 do
        run.pipes[j] = place(variant.name, j, y)
      end

      -- Constant draw at the far end, so heat must cross the whole run.
      run.load = place("aer_heat-exchanger-2", 43, y)
      state.runs[#state.runs + 1] = run
    end
  end,
  sample = function(state, tick)
    for _, run in ipairs(state.runs) do
      if run.source.valid then run.source.temperature = 1000 end
      if run.load.valid then run.load.insert_fluid{name = "water", amount = 240} end
    end

    -- Sample repeatedly: the first reading is a warm-up wavefront, not a
    -- steady state, and only convergence between samples proves equilibrium.
    if tick ~= 1800 and tick ~= 7200 and tick ~= 18000 then return end

    for _, run in ipairs(state.runs) do
      local profile = {}
      for _, index in ipairs({1, 2, 5, 10, 15, 20, 30, 40}) do
        local pipe = run.pipes[index]
        profile[#profile + 1] = ("%d:%s"):format(
          index, pipe and pipe.valid and ("%.0f"):format(pipe.temperature or -1) or "?")
      end
      emit("gradient", {
        {"seconds", tick / 60},
        {"min_temperature_gradient", run.label},
        {"profile", table.concat(profile, " ")},
        {"far_load", ("%.0f"):format(run.load.temperature or -1)},
        {"load_status", status_name(run.load.status)},
      })
    end
  end,
}

-- Experiment 13 ------------------------------------------------------------
-- Does feeding a run from two connections instead of one raise the far-end
-- temperature? Observed in play: a doubled tap read a few degrees hotter.
--
-- If parallel entry genuinely helps, it is a design lever -- players can spend
-- space near the reactor to buy reach. If it is only shortening the path, it is
-- an artefact of routing and should be described as such.
experiments.parallel_entry = {
  setup = function(state)
    state.cases = {}

    -- Single tap: source, then a straight chain.
    local single = {label = "single_tap", pipes = {}}
    single.source = place("heat-interface", 1200, 500)
    for j = 1, 20 do single.pipes[j] = place("heat-pipe", 1200 + j, 500) end
    state.cases[#state.cases + 1] = single

    -- Double tap: two pipes leave the source on different rows and rejoin,
    -- then the same straight chain. Path length to the join is equal.
    local double = {label = "double_tap", pipes = {}}
    double.source = place("heat-interface", 1200, 540)
    place("heat-pipe", 1201, 540)
    place("heat-pipe", 1200, 541)
    place("heat-pipe", 1201, 541)
    for j = 2, 20 do double.pipes[j] = place("heat-pipe", 1200 + j, 540) end
    double.pipes[1] = surface().find_entity("heat-pipe", {1201.5, 540.5})
    state.cases[#state.cases + 1] = double

    -- Wide trunk: the first four tiles are doubled, then a single chain.
    local trunk = {label = "wide_trunk", pipes = {}}
    trunk.source = place("heat-interface", 1200, 580)
    for j = 1, 4 do place("heat-pipe", 1200 + j, 581) end
    place("heat-pipe", 1200, 581)
    for j = 1, 20 do trunk.pipes[j] = place("heat-pipe", 1200 + j, 580) end
    state.cases[#state.cases + 1] = trunk
  end,
  sample = function(state, tick)
    for _, case in ipairs(state.cases) do
      if case.source.valid then case.source.temperature = 625 end
    end

    if tick ~= 17000 then return end
    for _, case in ipairs(state.cases) do
      local probe = case.pipes[20]
      local mid = case.pipes[10]
      emit("parallel_entry", {
        {"layout", case.label},
        {"tile_10", mid and mid.valid and ("%.2f"):format(mid.temperature) or "?"},
        {"tile_20", probe and probe.valid and ("%.2f"):format(probe.temperature) or "?"},
      })
    end
  end,
}

-- Experiment 14 ------------------------------------------------------------
-- Experiment 13 found no benefit to a doubled tap, but it used a pinned source
-- with no load, so nothing was ever throughput-limited. In play a doubled tap
-- reads hotter, and higher pipe tiers read hotter still with gradient held
-- constant -- which points at max_transfer rather than min_temperature_gradient.
--
-- This rig forces maximum flow: a source pinned hot at one end, a sink pinned
-- cold at the other, so heat moves as fast as the run allows. If max_transfer
-- is per connection, a doubled tap should now show a difference that
-- experiment 13 could not see.
experiments.throughput = {
  setup = function(state)
    state.cases = {}

    local function build(label, pipe_name, y, taps)
      local case = {label = label, pipes = {}, taps = taps}
      case.source = place("heat-interface", 1300, y)
      -- Extra parallel entries alongside the first two tiles.
      for tap = 2, taps do
        place(pipe_name, 1300, y + tap - 1)
        place(pipe_name, 1301, y + tap - 1)
      end
      for j = 1, 20 do case.pipes[j] = place(pipe_name, 1300 + j, y) end
      case.sink = place("heat-interface", 1321, y)
      state.cases[#state.cases + 1] = case
    end

    build("tier1_1tap", "heat-pipe", 700, 1)
    build("tier1_2tap", "heat-pipe", 740, 2)
    build("tier2_1tap", "aer_heat-pipe-2", 780, 1)
    build("tier3_1tap", "aer_heat-pipe-3", 820, 1)
    build("tier4_1tap", "aer_heat-pipe-4", 860, 1)
  end,
  sample = function(state, tick)
    for _, case in ipairs(state.cases) do
      if case.source.valid then case.source.temperature = 625 end
      -- Infinite sink: pinned cold, so the run carries all it can.
      if case.sink.valid then case.sink.temperature = 15 end
    end

    if tick ~= 17000 then return end
    for _, case in ipairs(state.cases) do
      local profile = {}
      for _, i in ipairs({1, 5, 10, 15, 20}) do
        local pipe = case.pipes[i]
        profile[#profile + 1] = ("%d:%s"):format(
          i, pipe and pipe.valid and ("%.2f"):format(pipe.temperature) or "?")
      end
      local proto = case.pipes[1].prototype.heat_buffer_prototype
      emit("throughput", {
        {"case", case.label},
        {"taps", case.taps},
        {"max_transfer", proto and proto.max_transfer or "?"},
        {"gradient", proto and proto.min_temperature_gradient or "?"},
        {"profile", table.concat(profile, " ")},
      })
    end
  end,
}

-- Experiment 15 ------------------------------------------------------------
-- Regression: an exchanger with no heat connection, sharing a steam pipe with
-- working ones, must not drag the steam temperature down.
--
-- Found in play. A dud sits at ambient, the passthrough clamped its intent up
-- to min_working, and that value was averaged in alongside real producers --
-- so exchangers making no steam at all voted on how hot the steam was.
experiments.dud_exchanger = {
  setup = function(state)
    state.rows = {}

    local function build(label, working, duds, y)
      local row = {label = label, working = {}, duds = {}}
      -- Working exchangers, buffers pinned at optimal.
      for i = 1, working do
        row.working[i] = place("aer_heat-exchanger-2", 1500 + i * 6, y)
      end
      -- Duds: same steam side, never given any heat.
      for i = 1, duds do
        row.duds[i] = place("aer_heat-exchanger-2", 1500 + (working + i) * 6, y)
      end
      state.rows[#state.rows + 1] = row
    end

    build("no_duds", 4, 0, 900)
    build("two_duds", 4, 2, 940)
    build("four_duds", 4, 4, 980)
  end,
  sample = function(state, tick)
    for _, row in ipairs(state.rows) do
      for _, exchanger in ipairs(row.working) do
        exchanger.temperature = 650
        exchanger.insert_fluid{name = "water", amount = 240}
      end
      -- Duds get water but no heat, exactly like a pipe-connected shell.
      for _, dud in ipairs(row.duds) do
        dud.insert_fluid{name = "water", amount = 240}
      end
    end

    if tick ~= 600 then return end
    for _, row in ipairs(state.rows) do
      local sample = row.working[1]
      local fluid = sample.get_fluid(2)
      emit("dud_exchanger", {
        {"case", row.label},
        {"working", #row.working},
        {"duds", #row.duds},
        {"dud_buffer", ("%.1f"):format(row.duds[1] and row.duds[1].temperature or -1)},
        {"steam_temperature", fluid and ("%.2f"):format(fluid.temperature or -1) or "none"},
      })
    end
  end,
}

-- Experiment 16 ------------------------------------------------------------
-- #14's outstanding measurement task: how long does a network take to reach
-- optimal from cold?
--
-- Matters more since pipe ceilings were pinned to reactor tiers, because
-- upgrading a pipe replaces the entity and the replacement starts at ambient.
-- A player upgrading a live array pays this time in lost output.
--
-- Measured on a lone fuelled reactor feeding a run of pipes, with no draw, so
-- the figure is the floor: a real array with exchangers running warms slower,
-- because they consume the heat that would otherwise be raising the network.
experiments.spin_up = {
  setup = function(state)
    state.rows = {}
    local tiers = {
      {label = "mk1", reactor = "nuclear-reactor",       pipe = "heat-pipe",       optimal = 500},
      {label = "mk2", reactor = "aer_nuclear-reactor-2", pipe = "aer_heat-pipe-2", optimal = 650},
      {label = "mk3", reactor = "aer_nuclear-reactor-3", pipe = "aer_heat-pipe-3", optimal = 800},
      {label = "mk4", reactor = "aer_nuclear-reactor-4", pipe = "aer_heat-pipe-4", optimal = 1000},
    }
    for i, tier in ipairs(tiers) do
      local y = 1100 + i * 20
      local row = {label = tier.label, optimal = tier.optimal, pipes = {}}
      -- Reactor alone, deliberately. Attaching a pipe run needs the reactor's
      -- heat ports, which sit at specific offsets rather than along the face,
      -- and three attempts to build onto them did not connect. The reactor is
      -- the dominant thermal mass anyway -- 10 MJ/degree against a pipe's 1 --
      -- and the network contribution is simple additive heat capacity, so the
      -- full figure is computed from this rather than measured with it.
      row.reactor = fuel(place(tier.reactor, 0, y))
      state.rows[#state.rows + 1] = row
    end
  end,
  sample = function(state, tick)
    for _, row in ipairs(state.rows) do
      if not row.reached_optimal and row.reactor.valid
         and (row.reactor.temperature or 0) >= row.optimal then
        row.reached_optimal = tick
      end
      if not row.reached_ceiling and row.reactor.valid then
        local ceiling = row.reactor.prototype.heat_buffer_prototype.max_temperature
        if (row.reactor.temperature or 0) >= ceiling - 1 then
          row.reached_ceiling = tick
        end
      end
    end

    if tick ~= 17900 then return end
    for _, row in ipairs(state.rows) do
      emit("spin_up", {
        {"tier", row.label},
        {"optimal", row.optimal},
        {"reactor_temp_at_end", ("%.0f"):format(row.reactor.temperature or -1)},
        {"seconds_to_optimal", row.reached_optimal
          and ("%.1f"):format(row.reached_optimal / 60) or "not reached"},
        {"seconds_to_ceiling", row.reached_ceiling
          and ("%.1f"):format(row.reached_ceiling / 60) or "not reached"},
      })
    end
  end,
}

-- Experiment 10 ------------------------------------------------------------
-- The mixed-source blend, and the accessors it rests on.
--
-- The passthrough rewrites a whole pipe segment, so any steam source sharing a
-- segment with a heat exchanger has its steam rewritten too. Weighting each
-- source by how much steam it actually makes is what keeps that honest, and the
-- weight has to be derived -- no prototype field reports steam output:
--
--     energy per tick * effectivity / (heat capacity * degrees above ambient)
--
-- Part 1 checks that derivation against figures already known from play: a
-- vanilla boiler makes 60 steam/s, a vanilla heat exchanger 103.09/s. It also
-- proves out every accessor the shipped code calls, since a nil field here is a
-- crash there.
--
-- Part 2 puts a vanilla boiler and an mk2 exchanger on one steam header and
-- reads what comes out. Three outcomes tell three different stories:
--   ~650  the boiler's steam was promoted -- energy from nothing
--   ~497  the volume-weighted blend, which is what the engine's own mixing
--         would have produced and what the shipped code aims for
--   ~165  the exchanger lost its vote, so the taper is broken instead
experiments.mixed_steam_blend = {
  setup = function(state)
    local steam = prototypes.fluid["steam"]
    state.steam_heat_capacity = steam.heat_capacity
    state.steam_base = steam.default_temperature

    state.rows = {}
    for _, name in ipairs({
      "boiler", "aer_steel-boiler", "aer_rubber-lined-boiler",
      "aer_holmium-reinforced-boiler", "heat-exchanger", "aer_heat-exchanger-2",
      "aer_heat-exchanger-3", "aer_heat-exchanger-4",
    }) do
      local prototype = prototypes.entity[name]
      if prototype then
        state.rows[#state.rows + 1] = {name = name, prototype = prototype}
      end
    end

    -- The exchanger is held at 500 rather than at its 650 target, which is what
    -- makes the reading decisive. At 650 every hypothesis lands on the same
    -- number and the rig proves nothing.
    --
    --   solo, no passthrough    650  the engine pins output to target
    --   solo, passthrough       500  the taper: steam follows the network
    --   mixed, no passthrough   496.8  the engine's own volume blend of 650 and 165
    --   mixed, promoted         500  cold steam handed the exchanger's temperature
    --   mixed, weighted blend   394.2  (60*165 + 129.92*500) / 189.92
    --
    -- Both machines face the same way at the same y, so their steam connections
    -- land on one row and a straight run of pipe joins them.
    state.boiler = place("boiler", 1000, 0)
    state.exchanger = place("aer_heat-exchanger-2", 1020, 0)
    state.boiler_pipe = attach_pipe(state.boiler, 2)
    state.exchanger_pipe = attach_pipe(state.exchanger, 2)
    state.joined = join_pipes(state.boiler_pipe, state.exchanger_pipe)
    state.boiler.insert{name = "coal", count = 50}

    -- Control: the same exchanger with nothing else on its segment.
    state.solo = place("aer_heat-exchanger-2", 1000, 40)
    state.solo_pipe = attach_pipe(state.solo, 2)
  end,
  sample = function(state, tick)
    -- Water drains as steam is made and the buffer drains with it, so both are
    -- topped up every tick to hold the rig at a steady production mix.
    for _, machine in ipairs({state.boiler, state.exchanger, state.solo}) do
      if machine and machine.valid then
        machine.insert_fluid{name = "water", amount = 200}
      end
    end
    for _, machine in ipairs({state.exchanger, state.solo}) do
      if machine and machine.valid then machine.temperature = 500 end
    end

    -- The rewrite runs on an interval, so between two writes the engine keeps
    -- adding steam at its own pinned target temperature. Trace the segment
    -- across several intervals to see how far it drifts back up in between:
    -- that drift is steam escaping the taper, and it is set by the interval.
    if tick >= 120 and tick <= 360 then
      local pipe = state.exchanger_pipe
      if pipe and pipe.valid and pipe.has_fluid_segment(1) then
        local fluid = pipe.get_fluid_segment_fluid(1)
        if fluid then
          state.trace = state.trace or {}
          state.trace[#state.trace + 1] = fluid.temperature or -1
        end
      end
    end

    if tick == 360 and state.trace and #state.trace > 0 then
      local low, high, total = math.huge, -math.huge, 0
      for _, value in ipairs(state.trace) do
        if value < low then low = value end
        if value > high then high = value end
        total = total + value
      end
      emit("blend_interval_drift", {
        {"samples", #state.trace},
        {"lowest", ("%.1f"):format(low)},
        {"highest", ("%.1f"):format(high)},
        {"mean", ("%.1f"):format(total / #state.trace)},
        {"sawtooth", ("%.1f"):format(high - low)},
      })
    end

    -- Sampled while the run is still filling. Once a segment backs up both
    -- machines stop producing, and a stalled rig measures nothing.
    if tick ~= 200 then return end

    for _, row in ipairs(state.rows) do
      local prototype = row.prototype
      local burner = prototype.burner_prototype
      local buffer = prototype.heat_buffer_prototype
      local effectivity = (burner and burner.effectivity) or 1
      local degrees = prototype.target_temperature - state.steam_base
      local per_tick = prototype.get_max_energy_usage() * effectivity
        / (state.steam_heat_capacity * degrees)
      emit("steam_rate", {
        {"producer", row.name},
        {"target", prototype.target_temperature},
        {"energy_per_tick", prototype.get_max_energy_usage()},
        {"effectivity", effectivity},
        {"has_burner", burner ~= nil},
        {"min_working", buffer and buffer.min_working_temperature or "none"},
        {"steam_per_second", ("%.2f"):format(per_tick * 60)},
      })
    end

    local function segment_of(pipe)
      if not (pipe and pipe.valid and pipe.has_fluid_segment(1)) then return "none", nil end
      return pipe.get_fluid_segment_id(1), pipe.get_fluid_segment_fluid(1)
    end

    local boiler_segment = segment_of(state.boiler_pipe)
    local exchanger_segment, mixed_fluid = segment_of(state.exchanger_pipe)
    local _, solo_fluid = segment_of(state.solo_pipe)

    emit("mixed_steam_blend", {
      -- Rig diagnostics first: a reading below means nothing if the two
      -- machines never reached one segment, or if either stopped producing.
      {"pipes_joined", state.joined},
      {"one_segment", boiler_segment == exchanger_segment},
      {"boiler_status", status_name(state.boiler.status)},
      {"exchanger_status", status_name(state.exchanger.status)},
      {"exchanger_buffer", ("%.0f"):format(state.exchanger.temperature or -1)},
      {"mixed_amount", mixed_fluid and ("%.1f"):format(mixed_fluid.amount) or "none"},
      {"mixed_temperature", mixed_fluid and ("%.1f"):format(mixed_fluid.temperature or -1) or "none"},
      {"solo_status", status_name(state.solo.status)},
      {"solo_amount", solo_fluid and ("%.1f"):format(solo_fluid.amount) or "none"},
      {"solo_temperature", solo_fluid and ("%.1f"):format(solo_fluid.temperature or -1) or "none"},
    })
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

  -- Must outlast the slowest experiment's sample tick.
  if event.tick == 18060 then
    log("AERM_END")
    script.on_event(defines.events.on_tick, nil)
  end
end)
