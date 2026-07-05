local fluid_helpers = require("prototypes.power.fluid-helpers")

data.raw.item["nuclear-reactor"].order = "c[nuclear-reactor-1]"
data.raw.item["nuclear-reactor"].subgroup = "aer_nuclear-reactor"

local reactor_mk2 = util.table.deepcopy(data.raw.item["nuclear-reactor"])
reactor_mk2.name = "aer_nuclear-reactor-2"
reactor_mk2.subgroup = "aer_nuclear-reactor"
reactor_mk2.order= "c[nuclear-reactor-2]"
reactor_mk2.place_result = "aer_nuclear-reactor-2"
advanced_power_apply_rubber_lined_icon_tint(reactor_mk2)
data:extend({reactor_mk2})

local reactor_mk3 = util.table.deepcopy(data.raw.item["nuclear-reactor"])
reactor_mk3.name = "aer_nuclear-reactor-3"
reactor_mk3.subgroup = "aer_nuclear-reactor"
reactor_mk3.order = "c[nuclear-reactor-3]"
reactor_mk3.place_result = "aer_nuclear-reactor-3"
fluid_helpers.apply_reinforced_icon_tint(reactor_mk3)
data:extend({reactor_mk3})

local reactor_mk4 = util.table.deepcopy(data.raw.item["nuclear-reactor"])
reactor_mk4.name = "aer_nuclear-reactor-4"
reactor_mk4.subgroup = "aer_nuclear-reactor"
reactor_mk4.order = "c[nuclear-reactor-4]"
reactor_mk4.place_result = "aer_nuclear-reactor-4"
fluid_helpers.apply_foundation_icon_tint(reactor_mk4)
data:extend({reactor_mk4})
