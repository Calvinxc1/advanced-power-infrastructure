local solar_panel_mk2 = util.table.deepcopy(data.raw.recipe["solar-panel"])
solar_panel_mk2.name = "aer_holmium-solar-panel"
solar_panel_mk2.enabled = false
solar_panel_mk2.energy_required = 20
solar_panel_mk2.ingredients = {
  { type = "item", name = "solar-panel", amount = 1 },
  { type = "item", name = "holmium-plate", amount = 4 },
  { type = "item", name = "superconductor", amount = 8 },
  { type = "item", name = "processing-unit", amount = 4 },
}
solar_panel_mk2.results = {
  { type = "item", name = "aer_holmium-solar-panel", amount = 1 },
}
data:extend({ solar_panel_mk2 })

local solar_panel_mk3 = util.table.deepcopy(data.raw.recipe["solar-panel"])
solar_panel_mk3.name = "aer_cryogenic-solar-panel"
solar_panel_mk3.enabled = false
solar_panel_mk3.energy_required = 30
solar_panel_mk3.ingredients = {
  { type = "item", name = "aer_holmium-solar-panel", amount = 1 },
  { type = "item", name = "quantum-processor", amount = 2 },
  { type = "item", name = "lithium-plate", amount = 8 },
  { type = "item", name = "superconductor", amount = 12 },
}
solar_panel_mk3.results = {
  { type = "item", name = "aer_cryogenic-solar-panel", amount = 1 },
}
data:extend({ solar_panel_mk3 })

local accumulator_mk2 = util.table.deepcopy(data.raw.recipe.accumulator)
accumulator_mk2.name = "aer_holmium-accumulator"
accumulator_mk2.enabled = false
accumulator_mk2.energy_required = 20
accumulator_mk2.ingredients = {
  { type = "item", name = "accumulator", amount = 1 },
  { type = "item", name = "supercapacitor", amount = 4 },
  { type = "item", name = "holmium-plate", amount = 4 },
  { type = "item", name = "advanced-circuit", amount = 5 },
}
accumulator_mk2.results = {
  { type = "item", name = "aer_holmium-accumulator", amount = 1 },
}
data:extend({ accumulator_mk2 })

local accumulator_mk3 = util.table.deepcopy(data.raw.recipe.accumulator)
accumulator_mk3.name = "aer_cryogenic-accumulator"
accumulator_mk3.enabled = false
accumulator_mk3.energy_required = 30
accumulator_mk3.ingredients = {
  { type = "item", name = "aer_holmium-accumulator", amount = 1 },
  { type = "item", name = "supercapacitor", amount = 8 },
  { type = "item", name = "quantum-processor", amount = 2 },
  { type = "item", name = "lithium-plate", amount = 8 },
}
accumulator_mk3.results = {
  { type = "item", name = "aer_cryogenic-accumulator", amount = 1 },
}
data:extend({ accumulator_mk3 })
