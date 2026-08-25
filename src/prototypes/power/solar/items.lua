local solar_helpers = require("prototypes.power.solar.helpers")

-- Vanilla leaves solar panels and accumulators in the shared `energy` row.
-- Move them, and their tiers, into this mod's solar row so the family reads as
-- one progression starting at its vanilla tier.
data.raw.item["solar-panel"].subgroup = "aer_solar-power"
data.raw.item["solar-panel"].order = "a[solar-panel-1]"
data.raw.item.accumulator.subgroup = "aer_solar-power"
data.raw.item.accumulator.order = "b[accumulator-1]"

local solar_panel_mk2 = util.table.deepcopy(data.raw.item["solar-panel"])
solar_panel_mk2.name = "aer_holmium-solar-panel"
solar_panel_mk2.place_result = "aer_holmium-solar-panel"
solar_panel_mk2.order = "a[solar-panel-2]"
solar_panel_mk2.subgroup = "aer_solar-power"
solar_helpers.apply_holmium_icon_tint(solar_panel_mk2)
data:extend({ solar_panel_mk2 })

local solar_panel_mk3 = util.table.deepcopy(data.raw.item["solar-panel"])
solar_panel_mk3.name = "aer_cryogenic-solar-panel"
solar_panel_mk3.place_result = "aer_cryogenic-solar-panel"
solar_panel_mk3.order = "a[solar-panel-3]"
solar_panel_mk3.subgroup = "aer_solar-power"
solar_helpers.apply_cryogenic_icon_tint(solar_panel_mk3)
data:extend({ solar_panel_mk3 })

local accumulator_mk2 = util.table.deepcopy(data.raw.item.accumulator)
accumulator_mk2.name = "aer_holmium-accumulator"
accumulator_mk2.place_result = "aer_holmium-accumulator"
accumulator_mk2.order = "b[accumulator-2]"
accumulator_mk2.subgroup = "aer_solar-power"
solar_helpers.apply_holmium_icon_tint(accumulator_mk2)
data:extend({ accumulator_mk2 })

local accumulator_mk3 = util.table.deepcopy(data.raw.item.accumulator)
accumulator_mk3.name = "aer_cryogenic-accumulator"
accumulator_mk3.place_result = "aer_cryogenic-accumulator"
accumulator_mk3.order = "b[accumulator-3]"
accumulator_mk3.subgroup = "aer_solar-power"
solar_helpers.apply_cryogenic_icon_tint(accumulator_mk3)
data:extend({ accumulator_mk3 })
