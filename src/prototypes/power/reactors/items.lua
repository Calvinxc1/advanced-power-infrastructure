data.raw.item["nuclear-reactor"].order = "a[nuclear-reactor-1]"
data.raw.item["nuclear-reactor"].subgroup = "aer_nuclear-power"

local reactor_mk2 = util.table.deepcopy(data.raw.item["nuclear-reactor"])
reactor_mk2.name = "aer_nuclear-reactor-2"
reactor_mk2.subgroup = "aer_nuclear-power"
reactor_mk2.order = "a[nuclear-reactor-2]"
reactor_mk2.place_result = "aer_nuclear-reactor-2"
advanced_power_apply_rubber_lined_icon_tint(reactor_mk2)
data:extend({reactor_mk2})
