local constants = {
  -- Every heat exchanger tier starts working at the same network temperature,
  -- rather than each tier raising its own floor. A higher tier will therefore
  -- run on a network built for a lower one -- it just produces that network's
  -- cooler steam while consuming its own tier's larger energy draw. Upgrading
  -- the exchanger without upgrading the heat source is a real loss, so the
  -- upgrade path has to be thought through rather than followed blindly.
  heat_exchanger_min_working_temperature = 300,

  -- How far a lightly loaded run should reach before it drops below optimal.
  -- Shrinking with tier is deliberate: a bigger reactor is meant to be harder
  -- to lay out, not merely bigger. Gradient is derived from this rather than
  -- set directly, so the design intent is what appears in the source.
  --
  -- These are light-load figures. Real runs are shorter, because the drop per
  -- tile is min_temperature_gradient plus a component proportional to the heat
  -- flowing through -- measured at roughly +2.7 degrees/tile per 80 MW on a
  -- tier 1 pipe. Heavier spokes reach less far.
  heat_tier_optimal_reach = {
    mk1 = 25,
    mk2 = 22.5,
    mk3 = 20,
    mk4 = 17.5,
  },

  -- Throughput deliberately grows more slowly than exchanger draw, which runs
  -- 1 : 1.8 : 2.5 : 3.2. Capacity outrunning demand is what made higher tiers
  -- easier to lay out; keeping it behind demand is what makes the same tileable
  -- layout lose efficiency as the tiers rise, while still producing more power.
  heat_tier_max_transfer = {
    mk1 = "1GW",
    mk2 = "1.4GW",
    mk3 = "1.7GW",
    mk4 = "1.9GW",
  },

  -- A reactor's ceiling sits this far above the optimal of the exchanger tier
  -- that matches it, so optimal is 80 percent of the ceiling rather than the
  -- 50 percent it was before.
  reactor_optimal_fraction = 0.8,

  -- The optimal temperature of each heat exchanger tier. Every other heat
  -- temperature in the mod derives from these, so a tier cannot drift out of
  -- step with its own reactor or pipe.
  heat_tier_optimal = {
    mk1 = 500,
    mk2 = 650,
    mk3 = 800,
    mk4 = 1000,
  },

  iron = {
    pipeline_extent = 24,
  },
  steel = {
    pipeline_extent = 64,
    icon_tint = { r = 0.5, g = 0.72, b = 1.0, a = 0.48 },
  },
  rubber_lined = {
    pipeline_extent = 96,
    icon_tint = { r = 0.08, g = 0.08, b = 0.08, a = 0.58 },
    entity_tint = { r = 0.42, g = 0.42, b = 0.42, a = 1 },
  },
  reinforced = {
    pipeline_extent = 192,
    icon_tint = { r = 0.22, g = 0.74, b = 0.34, a = 0.22 },
    entity_tint = { r = 0.72, g = 0.86, b = 0.74, a = 1 },
    resistances = {
      { type = "fire", percent = 100 },
      { type = "cold", percent = 100 },
      { type = "acid", percent = 80 },
      { type = "poison", percent = 80 },
      { type = "explosion", percent = 70 },
      { type = "physical", percent = 60 },
      { type = "impact", percent = 60 },
      { type = "electric", percent = 50 },
      { type = "laser", percent = 50 },
    },
  },
  foundation = {
    pipeline_extent = 512,
    icon_tint = { r = 0.82, g = 0.94, b = 1.0, a = 0.28 },
    entity_tint = { r = 0.86, g = 0.92, b = 0.96, a = 1 },
    resistances = {
      { type = "fire", percent = 100 },
      { type = "cold", percent = 100 },
      { type = "acid", percent = 85 },
      { type = "poison", percent = 85 },
      { type = "explosion", percent = 80 },
      { type = "physical", percent = 70 },
      { type = "impact", percent = 70 },
      { type = "electric", percent = 60 },
      { type = "laser", percent = 60 },
    },
  },
}

-- Each tier's heat network ceiling, shared by the reactor that produces the heat
-- and the pipe that carries it. Matching them is what makes a pipe tier a
-- requirement rather than an option: a pipe is a node in the network like any
-- other, so a lower-tier pipe caps the whole network at its own maximum.
constants.heat_tier_ceiling = {}
for tier, optimal in pairs(constants.heat_tier_optimal) do
  constants.heat_tier_ceiling[tier] = optimal / constants.reactor_optimal_fraction
end

-- Degrees lost per pipe tile, at light load. The engine treats this as a floor
-- rather than a fixed rate, so it is the best case a run can achieve.
constants.heat_tier_gradient = {}
for tier, optimal in pairs(constants.heat_tier_optimal) do
  constants.heat_tier_gradient[tier] =
    (constants.heat_tier_ceiling[tier] - optimal) / constants.heat_tier_optimal_reach[tier]
end

return constants
