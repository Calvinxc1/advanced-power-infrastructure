local fluid_helpers = require("prototypes.fluid.helpers")

local reactor_mk2 = util.table.deepcopy(data.raw.technology["nuclear-power"])
reactor_mk2.name = "aer_nuclear-reactor-2"
reactor_mk2.localised_name = {"technology-name.aer_nuclear-reactor-2"}
reactor_mk2.icons = nil
advanced_power_apply_rubber_lined_icon_tint(reactor_mk2)
reactor_mk2.prerequisites = {
  "nuclear-power",
  "production-science-pack",
  "utility-science-pack",
}
reactor_mk2.effects = {
  { type = "unlock-recipe", recipe = "aer_nuclear-reactor-2" },
}
reactor_mk2.unit.count = 2500
reactor_mk2.unit.ingredients = {
  {"automation-science-pack", 1},
  {"logistic-science-pack", 1},
  {"chemical-science-pack", 1},
  {"production-science-pack", 1},
  {"utility-science-pack", 1}
}
reactor_mk2.unit.time = 30
reactor_mk2.upgrade = true
reactor_mk2.order = "[nuclear-reactor]-1"
data:extend({reactor_mk2})

local reactor_mk3 = util.table.deepcopy(data.raw.technology["nuclear-power"])
reactor_mk3.name = "aer_nuclear-reactor-3"
reactor_mk3.localised_name = {"technology-name.aer_nuclear-reactor-3"}
reactor_mk3.icons = nil
fluid_helpers.apply_reinforced_icon_tint(reactor_mk3)
reactor_mk3.prerequisites = {
  "aer_nuclear-reactor-2",
  "metallurgic-science-pack",
  "electromagnetic-science-pack",
}
reactor_mk3.effects = {
  { type = "unlock-recipe", recipe = "aer_nuclear-reactor-3" },
}
reactor_mk3.unit.count = 5000
reactor_mk3.unit.ingredients = {
  {"automation-science-pack", 1},
  {"logistic-science-pack", 1},
  {"chemical-science-pack", 1},
  {"space-science-pack", 1},
  {"production-science-pack", 1},
  {"utility-science-pack", 1},
  {"metallurgic-science-pack", 1},
  {"electromagnetic-science-pack", 1},
}
reactor_mk3.unit.time = 30
reactor_mk3.upgrade = true
reactor_mk3.order = "[nuclear-reactor]-2"
data:extend({reactor_mk3})

local reactor_mk4 = util.table.deepcopy(data.raw.technology["nuclear-power"])
reactor_mk4.name = "aer_nuclear-reactor-4"
reactor_mk4.localised_name = {"technology-name.aer_nuclear-reactor-4"}
reactor_mk4.icons = nil
fluid_helpers.apply_foundation_icon_tint(reactor_mk4)
reactor_mk4.prerequisites = {
  "aer_nuclear-reactor-3",
  "lithium-processing",
}
reactor_mk4.effects = {
  { type = "unlock-recipe", recipe = "aer_nuclear-reactor-4" },
}
reactor_mk4.unit.count = 10000
reactor_mk4.unit.ingredients = {
  {"automation-science-pack", 1},
  {"logistic-science-pack", 1},
  {"chemical-science-pack", 1},
  {"space-science-pack", 1},
  {"production-science-pack", 1},
  {"utility-science-pack", 1},
  {"metallurgic-science-pack", 1},
  {"agricultural-science-pack", 1},
  {"electromagnetic-science-pack", 1},
  {"cryogenic-science-pack", 1},
}
reactor_mk4.unit.time = 30
reactor_mk4.upgrade = true
reactor_mk4.order = "[nuclear-reactor]-3"
data:extend({reactor_mk4})
