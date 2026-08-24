local optional_dependencies = require("prototypes.power.optional-dependencies")

data:extend({
  {
    type = "item-subgroup",
    name = "aer_steam-boiler",
    group = "production",
    order = "b-a",
  },
  {
    type = "item-subgroup",
    name = "aer_steam-engine",
    group = "production",
    order = "b-b",
  },
  {
    type = "item-subgroup",
    name = "aer_steam-turbine",
    group = "production",
    order = "b-c",
  },
  {
    type = "item-subgroup",
    name = "aer_heat-exchanger",
    group = "production",
    order = "b-c",
  },
  {
    type = "item-subgroup",
    name = "aer_heat-pipe",
    group = "production",
    order = "b-c",
  },
  {
    type = "item-subgroup",
    name = "aer_nuclear-reactor",
    group = "production",
    order = "d-a",
  },
})

-- Every member of this subgroup is a fusion tier, and those exist only under
-- Space Age, so in a base-game load the subgroup would have nothing in it.
if optional_dependencies.has_space_age then
  data:extend({
    {
      type = "item-subgroup",
      name = "aer_fusion-power",
      group = "production",
      order = "d-b",
    },
  })
end
