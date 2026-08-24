-- Space Age reactor tiers. Both need holmium plate, and the top tier also
-- needs lithium plate, so neither has a base-game form.

local fluid_helpers = require("prototypes.power.fluid-helpers")

local reactor_mk3 = util.table.deepcopy(data.raw.item["nuclear-reactor"])
reactor_mk3.name = "aer_nuclear-reactor-3"
reactor_mk3.subgroup = "aer_nuclear-power"
reactor_mk3.order = "a[nuclear-reactor-3]"
reactor_mk3.place_result = "aer_nuclear-reactor-3"
fluid_helpers.apply_reinforced_icon_tint(reactor_mk3)
data:extend({reactor_mk3})
local reactor_mk4 = util.table.deepcopy(data.raw.item["nuclear-reactor"])
reactor_mk4.name = "aer_nuclear-reactor-4"
reactor_mk4.subgroup = "aer_nuclear-power"
reactor_mk4.order = "a[nuclear-reactor-4]"
reactor_mk4.place_result = "aer_nuclear-reactor-4"
fluid_helpers.apply_foundation_icon_tint(reactor_mk4)
data:extend({reactor_mk4})
