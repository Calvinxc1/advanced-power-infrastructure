local constants = {
  -- Every heat exchanger tier starts working at the same network temperature,
  -- rather than each tier raising its own floor. A higher tier will therefore
  -- run on a network built for a lower one -- it just produces that network's
  -- cooler steam while consuming its own tier's larger energy draw. Upgrading
  -- the exchanger without upgrading the heat source is a real loss, so the
  -- upgrade path has to be thought through rather than followed blindly.
  heat_exchanger_min_working_temperature = 300,

  -- Steam-producing and steam-consuming buildings are held to this pipeline
  -- extent at every tier, rather than inheriting their material tier's. Letting
  -- it rise with tier solved the plumbing problem the upper tiers are supposed
  -- to pose: a higher-tier run stopped needing pumps at all. Pinning it keeps
  -- power blocks compartmentalised and keeps pumps a real part of the layout.
  power_building_pipeline_extent = 64,

  -- Heat pipes need their own, stronger entity tints.
  --
  -- The shared per-material entity_tint values are built for large buildings,
  -- where a gentle multiplier reads clearly across a big sprite. A heat pipe is
  -- one tile, largely covered by its own connection graphics, and often half
  -- hidden under other entities -- the same multiplier does almost nothing. The
  -- rubber-lined value is worse still: r0.42 g0.42 b0.42 is pure grey, so
  -- against an already-grey pipe it darkens without shifting hue at all.
  --
  -- Hues follow each tier's established identity, taken from the icon tints so
  -- the crafting menu and the placed entity agree: rubber-lined dark, reinforced
  -- green, foundation pale blue. Saturation is raised to what a one-tile sprite
  -- actually needs. Tier 1 stays vanilla and untinted, which makes it the
  -- reference -- and it is the tier most likely to be the accidental bottleneck.
  heat_pipe_entity_tint = {
    rubber_lined = { r = 0.32, g = 0.30, b = 0.30, a = 1 },
    reinforced   = { r = 0.40, g = 0.90, b = 0.50, a = 1 },
    foundation   = { r = 0.60, g = 0.80, b = 1.00, a = 1 },
  },

  -- Turbines a single heat exchanger feeds, held constant at every tier.
  --
  -- Each tier's fluid_usage_per_tick is chosen to land on this ratio, since a
  -- generator's output is (optimal - 15) * fluid_usage_per_tick * steam heat
  -- capacity. Keeping it flat means the exchanger-to-turbine ratio learned at
  -- the steel tier stays true all the way up, so the difficulty lives in
  -- placement -- more exchangers, less reach -- rather than in relearning the
  -- local ratio at every tier.
  turbines_per_exchanger = 1.8,

  -- How far a lightly loaded run should reach before it drops below optimal.
  -- Gradient is derived from this rather than set directly, so the design
  -- intent is what appears in the source.
  --
  -- The decline has to outpace the temperature budget, which itself grows with
  -- tier. An earlier 25/22.5/20/17.5 did not: gradient and budget rose together
  -- and cancelled, leaving every tier about 65 degrees above optimal at the end
  -- of a 13 tile run. Same margin at every tier, dressed in bigger numbers.
  -- These values make the margin shrink and then go negative, so a spoke that
  -- worked at one tier does not simply keep working at the next.
  --
  -- These are light-load figures. Real runs are shorter, because the drop per
  -- tile is min_temperature_gradient plus a component proportional to the heat
  -- flowing through -- measured at roughly +2.7 degrees/tile per 80 MW on a
  -- tier 1 pipe. Heavier spokes reach less far.
  heat_tier_optimal_reach = {
    mk1 = 25,
    mk2 = 16,
    mk3 = 12,
    mk4 = 9,
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

  -- Every steam source and every steam consumer this mod owns or adopts.
  -- Shared, because more than one pass needs the same list and a second copy
  -- would be one tier away from disagreeing with the first.
  steam_producers = {
    "heat-exchanger",
    "aer_heat-exchanger-2",
    "aer_heat-exchanger-3",
    "aer_heat-exchanger-4",
    "boiler",
    "aer_steel-boiler",
    "aer_rubber-lined-boiler",
    "aer_holmium-reinforced-boiler",
  },

  steam_consumers = {
    "steam-turbine",
    "aer_rubber-lined-steam-turbine",
    "aer_reinforced-steam-turbine",
    "aer_foundation-steam-turbine",
    "steam-engine",
    "aer_steel-steam-engine",
    "aer_rubber-lined-steam-engine",
    "aer_holmium-steam-engine",
  },

  -- What one aligned heat connection between two reactors is worth.
  --
  -- A reactor has three heat connections a side, so two flush reactors line up
  -- all three and the pair is worth the full 100 percent vanilla pays -- every
  -- exchanger, turbine and reach figure derived from a flush 2x2 block is
  -- unchanged. Sliding one reactor along the shared edge breaks the alignment
  -- two tiles at a time, and the bonus falls with it.
  --
  -- The engine cannot express this. Its neighbour bonus is paid once per
  -- neighbouring reactor however many connection points pair up, and
  -- LuaEntity.neighbour_bonus is read only, so the prototypes carry a bonus of
  -- zero and control.lua pays it instead. See issue #10.
  reactor_connection_bonus = 1 / 3,

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
