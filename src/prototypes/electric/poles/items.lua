data.raw.item["small-electric-pole"].order = "a[energy]-a[small-electric-pole-1]"
data.raw.item["small-electric-pole"].subgroup = "aer_poles"
data.raw.item["medium-electric-pole"].order = "a[energy]-b[medium-electric-pole-1]"
data.raw.item["medium-electric-pole"].subgroup = "aer_poles"
data.raw.item["big-electric-pole"].order = "a[energy]-c[big-electric-pole-1]"
data.raw.item["big-electric-pole"].subgroup = "aer_poles"
data.raw.item["substation"].order = "a[energy]-d[substation-1]"
data.raw.item["substation"].subgroup = "aer_poles"

local small_electric_pole_mk2 = util.table.deepcopy(data.raw.item["small-electric-pole"])
small_electric_pole_mk2.order = "a[energy]-a[aer_small-electric-pole-2]"
small_electric_pole_mk2.subgroup = "aer_poles"
small_electric_pole_mk2.name = "aer_small-electric-pole-2"
small_electric_pole_mk2.place_result = "aer_small-electric-pole-2"
data:extend({small_electric_pole_mk2})

local medium_electric_pole_mk2 = util.table.deepcopy(data.raw.item["medium-electric-pole"])
medium_electric_pole_mk2.order = "a[energy]-b[aer_medium-electric-pole-2]"
medium_electric_pole_mk2.subgroup = "aer_poles"
medium_electric_pole_mk2.name = "aer_medium-electric-pole-2"
medium_electric_pole_mk2.place_result = "aer_medium-electric-pole-2"
data:extend({medium_electric_pole_mk2})

local medium_electric_pole_mk3 = util.table.deepcopy(data.raw.item["medium-electric-pole"])
medium_electric_pole_mk3.order = "a[energy]-b[aer_medium-electric-pole-3]"
medium_electric_pole_mk3.subgroup = "aer_poles"
medium_electric_pole_mk3.name = "aer_medium-electric-pole-3"
medium_electric_pole_mk3.place_result = "aer_medium-electric-pole-3"
data:extend({medium_electric_pole_mk3})

local medium_electric_pole_mk4 = util.table.deepcopy(data.raw.item["medium-electric-pole"])
medium_electric_pole_mk4.order = "a[energy]-b[aer_medium-electric-pole-4]"
medium_electric_pole_mk4.subgroup = "aer_poles"
medium_electric_pole_mk4.name = "aer_medium-electric-pole-4"
medium_electric_pole_mk4.place_result = "aer_medium-electric-pole-4"
data:extend({medium_electric_pole_mk4})

local big_electric_pole_mk2 = util.table.deepcopy(data.raw.item["big-electric-pole"])
big_electric_pole_mk2.order = "a[energy]-c[aer_big-electric-pole-2]"
big_electric_pole_mk2.subgroup = "aer_poles"
big_electric_pole_mk2.name = "aer_big-electric-pole-2"
big_electric_pole_mk2.place_result = "aer_big-electric-pole-2"
data:extend({big_electric_pole_mk2})

local big_electric_pole_mk3 = util.table.deepcopy(data.raw.item["big-electric-pole"])
big_electric_pole_mk3.order = "a[energy]-c[aer_big-electric-pole-3]"
big_electric_pole_mk3.subgroup = "aer_poles"
big_electric_pole_mk3.name = "aer_big-electric-pole-3"
big_electric_pole_mk3.place_result = "aer_big-electric-pole-3"
data:extend({big_electric_pole_mk3})

local big_electric_pole_mk4 = util.table.deepcopy(data.raw.item["big-electric-pole"])
big_electric_pole_mk4.order = "a[energy]-c[aer_big-electric-pole-4]"
big_electric_pole_mk4.subgroup = "aer_poles"
big_electric_pole_mk4.name = "aer_big-electric-pole-4"
big_electric_pole_mk4.place_result = "aer_big-electric-pole-4"
data:extend({big_electric_pole_mk4})

local substation_mk2 = util.table.deepcopy(data.raw.item["substation"])
substation_mk2.order = "a[energy]-d[aer_substation-2]"
substation_mk2.subgroup = "aer_poles"
substation_mk2.name = "aer_substation-2"
substation_mk2.place_result = "aer_substation-2"
data:extend({substation_mk2})

local substation_mk3 = util.table.deepcopy(data.raw.item["substation"])
substation_mk3.order = "a[energy]-d[aer_substation-3]"
substation_mk3.subgroup = "aer_poles"
substation_mk3.name = "aer_substation-3"
substation_mk3.place_result = "aer_substation-3"
data:extend({substation_mk3})

local substation_mk4 = util.table.deepcopy(data.raw.item["substation"])
substation_mk4.order = "a[energy]-d[aer_substation-4]"
substation_mk4.subgroup = "aer_poles"
substation_mk4.name = "aer_substation-4"
substation_mk4.place_result = "aer_substation-4"
data:extend({substation_mk4})
