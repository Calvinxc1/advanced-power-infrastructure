data.raw.item["boiler"].order = "b[steam-power]-a[boiler-1]"
data.raw.item["boiler"].subgroup = "aer_steam-boiler"

local boiler_mk2 = util.table.deepcopy(data.raw.item["boiler"])
boiler_mk2.name = "aer_steel-boiler"
boiler_mk2.subgroup = "aer_steam-boiler"
boiler_mk2.order= "b[steam-power]-a[boiler-2]"
boiler_mk2.place_result = "aer_steel-boiler"
advanced_power_apply_steel_icon_tint(boiler_mk2)
data:extend({boiler_mk2})

local boiler_mk3 = util.table.deepcopy(data.raw.item["boiler"])
boiler_mk3.name = "aer_rubber-lined-boiler"
boiler_mk3.subgroup = "aer_steam-boiler"
boiler_mk3.order= "b[steam-power]-a[boiler-3]"
boiler_mk3.place_result = "aer_rubber-lined-boiler"
advanced_power_apply_rubber_lined_icon_tint(boiler_mk3)
data:extend({boiler_mk3})

local boiler_mk4 = util.table.deepcopy(data.raw.item["boiler"])
boiler_mk4.name = "aer_holmium-reinforced-boiler"
boiler_mk4.subgroup = "aer_steam-boiler"
boiler_mk4.order= "b[steam-power]-a[boiler-4]"
boiler_mk4.place_result = "aer_holmium-reinforced-boiler"
advanced_power_apply_holmium_icon_tint(boiler_mk4)
data:extend({boiler_mk4})
