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
