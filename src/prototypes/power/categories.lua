local optional_dependencies = require("prototypes.power.optional-dependencies")

-- One subgroup per power chain, so each occupies its own crafting menu row and
-- runs left to right in family then tier order. Vanilla puts boilers, engines,
-- turbines, exchangers, heat pipes, reactors, solar panels and accumulators all
-- in a single `energy` row, which the tiers this mod adds make unreadable.
--
-- The grouping follows vanilla's own order-string convention, which already
-- separates b[steam-power], f[nuclear-energy], d[solar-panel] and
-- e[accumulator].
--
-- The `b-a-*` prefix is reserved for this mod. Vanilla's `energy` subgroup
-- sorts at `b`, so these rows sit immediately after it. Advanced Energy Grid
-- takes `d-a-*` and Advanced Fluid Infrastructure `d-b-*`, both in the
-- logistics group; keeping each mod inside its own prefix means no two can
-- interleave their rows.
data:extend({
  {
    type = "item-subgroup",
    name = "aer_steam-power",
    group = "production",
    order = "b-a-a",
  },
  {
    type = "item-subgroup",
    name = "aer_nuclear-power",
    group = "production",
    order = "b-a-b",
  },
  {
    type = "item-subgroup",
    name = "aer_solar-power",
    group = "production",
    order = "b-a-c",
  },
})

-- Every member of this row is a fusion tier, and those exist only under Space
-- Age, so in a base-game load the subgroup would have nothing in it.
if optional_dependencies.has_space_age then
  data:extend({
    {
      type = "item-subgroup",
      name = "aer_fusion-power",
      group = "production",
      order = "b-a-d",
    },
  })
end
