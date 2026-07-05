local solar_helpers = require("prototypes.power.solar.helpers")

local solar_panel_mk2 = util.table.deepcopy(data.raw.technology["solar-energy"])
solar_panel_mk2.name = "aer_holmium-solar-panel"
solar_panel_mk2.icons = nil
solar_helpers.apply_holmium_icon_tint(solar_panel_mk2)
solar_panel_mk2.prerequisites = {
  "solar-energy",
  "electromagnetic-science-pack",
  "electromagnetic-plant",
}
solar_panel_mk2.effects = {
  { type = "unlock-recipe", recipe = "aer_holmium-solar-panel" },
}
solar_panel_mk2.unit.count = 750
solar_panel_mk2.unit.ingredients = {
  { "automation-science-pack", 1 },
  { "logistic-science-pack", 1 },
  { "chemical-science-pack", 1 },
  { "space-science-pack", 1 },
  { "electromagnetic-science-pack", 1 },
}
solar_panel_mk2.unit.time = 60
solar_panel_mk2.upgrade = true
solar_panel_mk2.order = "a-h-a[solar-panel-2]"
data:extend({ solar_panel_mk2 })

local accumulator_mk2 = util.table.deepcopy(data.raw.technology["electric-energy-accumulators"])
accumulator_mk2.name = "aer_holmium-accumulator"
accumulator_mk2.icons = nil
solar_helpers.apply_holmium_icon_tint(accumulator_mk2)
accumulator_mk2.prerequisites = {
  "electric-energy-accumulators",
  "electromagnetic-science-pack",
  "electromagnetic-plant",
}
accumulator_mk2.effects = {
  { type = "unlock-recipe", recipe = "aer_holmium-accumulator" },
}
accumulator_mk2.unit.count = 1000
accumulator_mk2.unit.ingredients = {
  { "automation-science-pack", 1 },
  { "logistic-science-pack", 1 },
  { "chemical-science-pack", 1 },
  { "space-science-pack", 1 },
  { "electromagnetic-science-pack", 1 },
}
accumulator_mk2.unit.time = 60
accumulator_mk2.upgrade = true
accumulator_mk2.order = "a-h-b[accumulator-2]"
data:extend({ accumulator_mk2 })

local solar_panel_mk3 = util.table.deepcopy(data.raw.technology["solar-energy"])
solar_panel_mk3.name = "aer_cryogenic-solar-panel"
solar_panel_mk3.icons = nil
solar_helpers.apply_cryogenic_icon_tint(solar_panel_mk3)
solar_panel_mk3.prerequisites = {
  "aer_holmium-solar-panel",
  "quantum-processor",
}
solar_panel_mk3.effects = {
  { type = "unlock-recipe", recipe = "aer_cryogenic-solar-panel" },
}
solar_panel_mk3.unit.count = 1500
solar_panel_mk3.unit.ingredients = {
  { "automation-science-pack", 1 },
  { "logistic-science-pack", 1 },
  { "chemical-science-pack", 1 },
  { "production-science-pack", 1 },
  { "utility-science-pack", 1 },
  { "space-science-pack", 1 },
  { "electromagnetic-science-pack", 1 },
  { "cryogenic-science-pack", 1 },
}
solar_panel_mk3.unit.time = 60
solar_panel_mk3.upgrade = true
solar_panel_mk3.order = "a-i-a[solar-panel-3]"
data:extend({ solar_panel_mk3 })

local accumulator_mk3 = util.table.deepcopy(data.raw.technology["electric-energy-accumulators"])
accumulator_mk3.name = "aer_cryogenic-accumulator"
accumulator_mk3.icons = nil
solar_helpers.apply_cryogenic_icon_tint(accumulator_mk3)
accumulator_mk3.prerequisites = {
  "aer_holmium-accumulator",
  "quantum-processor",
}
accumulator_mk3.effects = {
  { type = "unlock-recipe", recipe = "aer_cryogenic-accumulator" },
}
accumulator_mk3.unit.count = 2000
accumulator_mk3.unit.ingredients = {
  { "automation-science-pack", 1 },
  { "logistic-science-pack", 1 },
  { "chemical-science-pack", 1 },
  { "production-science-pack", 1 },
  { "utility-science-pack", 1 },
  { "space-science-pack", 1 },
  { "electromagnetic-science-pack", 1 },
  { "cryogenic-science-pack", 1 },
}
accumulator_mk3.unit.time = 60
accumulator_mk3.upgrade = true
accumulator_mk3.order = "a-i-b[accumulator-3]"
data:extend({ accumulator_mk3 })
