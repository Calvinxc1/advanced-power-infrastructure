local solar_helpers = require("prototypes.power.solar.helpers")

local solar_panel_mk2 = util.table.deepcopy(data.raw["solar-panel"]["solar-panel"])
solar_panel_mk2.name = "aer_holmium-solar-panel"
solar_panel_mk2.minable.result = "aer_holmium-solar-panel"
solar_panel_mk2.max_health = 300
solar_panel_mk2.production = "240kW"
solar_panel_mk2.next_upgrade = "aer_cryogenic-solar-panel"
solar_helpers.apply_holmium_icon_tint(solar_panel_mk2)
solar_helpers.apply_holmium_entity_tint(solar_panel_mk2)
data.raw["solar-panel"]["solar-panel"].next_upgrade = "aer_holmium-solar-panel"
data:extend({ solar_panel_mk2 })

local solar_panel_mk3 = util.table.deepcopy(data.raw["solar-panel"]["solar-panel"])
solar_panel_mk3.name = "aer_cryogenic-solar-panel"
solar_panel_mk3.minable.result = "aer_cryogenic-solar-panel"
solar_panel_mk3.max_health = 400
solar_panel_mk3.production = "480kW"
solar_panel_mk3.next_upgrade = nil
solar_helpers.apply_cryogenic_icon_tint(solar_panel_mk3)
solar_helpers.apply_cryogenic_entity_tint(solar_panel_mk3)
data:extend({ solar_panel_mk3 })

local accumulator_mk2 = util.table.deepcopy(data.raw.accumulator.accumulator)
accumulator_mk2.name = "aer_holmium-accumulator"
accumulator_mk2.minable.result = "aer_holmium-accumulator"
accumulator_mk2.max_health = 250
accumulator_mk2.energy_source.buffer_capacity = "20MJ"
accumulator_mk2.energy_source.input_flow_limit = "1200kW"
accumulator_mk2.energy_source.output_flow_limit = "1200kW"
accumulator_mk2.next_upgrade = "aer_cryogenic-accumulator"
solar_helpers.apply_holmium_icon_tint(accumulator_mk2)
solar_helpers.apply_holmium_entity_tint(accumulator_mk2)
data.raw.accumulator.accumulator.next_upgrade = "aer_holmium-accumulator"
data:extend({ accumulator_mk2 })

local accumulator_mk3 = util.table.deepcopy(data.raw.accumulator.accumulator)
accumulator_mk3.name = "aer_cryogenic-accumulator"
accumulator_mk3.minable.result = "aer_cryogenic-accumulator"
accumulator_mk3.max_health = 350
accumulator_mk3.energy_source.buffer_capacity = "40MJ"
accumulator_mk3.energy_source.input_flow_limit = "2400kW"
accumulator_mk3.energy_source.output_flow_limit = "2400kW"
accumulator_mk3.next_upgrade = nil
solar_helpers.apply_cryogenic_icon_tint(accumulator_mk3)
solar_helpers.apply_cryogenic_entity_tint(accumulator_mk3)
data:extend({ accumulator_mk3 })
