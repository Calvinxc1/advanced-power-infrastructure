local solar_helpers = require("prototypes.power.solar.helpers")

local solar_panel_mk2 = util.table.deepcopy(data.raw.item["solar-panel"])
solar_panel_mk2.name = "aer_holmium-solar-panel"
solar_panel_mk2.place_result = "aer_holmium-solar-panel"
solar_panel_mk2.order = "d[solar-panel]-b[holmium-solar-panel]"
solar_helpers.apply_holmium_icon_tint(solar_panel_mk2)
data:extend({ solar_panel_mk2 })

local solar_panel_mk3 = util.table.deepcopy(data.raw.item["solar-panel"])
solar_panel_mk3.name = "aer_cryogenic-solar-panel"
solar_panel_mk3.place_result = "aer_cryogenic-solar-panel"
solar_panel_mk3.order = "d[solar-panel]-c[cryogenic-solar-panel]"
solar_helpers.apply_cryogenic_icon_tint(solar_panel_mk3)
data:extend({ solar_panel_mk3 })

local accumulator_mk2 = util.table.deepcopy(data.raw.item.accumulator)
accumulator_mk2.name = "aer_holmium-accumulator"
accumulator_mk2.place_result = "aer_holmium-accumulator"
accumulator_mk2.order = "e[accumulator]-b[holmium-accumulator]"
solar_helpers.apply_holmium_icon_tint(accumulator_mk2)
data:extend({ accumulator_mk2 })

local accumulator_mk3 = util.table.deepcopy(data.raw.item.accumulator)
accumulator_mk3.name = "aer_cryogenic-accumulator"
accumulator_mk3.place_result = "aer_cryogenic-accumulator"
accumulator_mk3.order = "e[accumulator]-c[cryogenic-accumulator]"
solar_helpers.apply_cryogenic_icon_tint(accumulator_mk3)
data:extend({ accumulator_mk3 })
