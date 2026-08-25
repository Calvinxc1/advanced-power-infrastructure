return {
  -- Every heat exchanger tier starts working at the same network temperature,
  -- rather than each tier raising its own floor. A higher tier will therefore
  -- run on a network built for a lower one -- it just produces that network's
  -- cooler steam while consuming its own tier's larger energy draw. Upgrading
  -- the exchanger without upgrading the heat source is a real loss, so the
  -- upgrade path has to be thought through rather than followed blindly.
  heat_exchanger_min_working_temperature = 300,

  -- Degrees lost per pipe tile. Measured, not guessed: the engine applies
  -- this linearly, so reach in tiles is exactly
  --   (reactor max temperature - exchanger optimal) / gradient.
  -- The engine default of 1 makes distance effectively free, which is why a
  -- reactor block could grow an arbitrarily long arm at no cost.
  heat_pipe_temperature_gradient = 5,

  -- A reactor's ceiling sits this far above the optimal of the exchanger tier
  -- that matches it, so optimal is 80 percent of the ceiling rather than the
  -- 50 percent it was before.
  reactor_optimal_fraction = 0.8,

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
