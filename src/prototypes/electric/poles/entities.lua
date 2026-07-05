data.raw["electric-pole"]["small-electric-pole"].fast_replaceable_group = "electric-pole"
data.raw["electric-pole"]["small-electric-pole"].next_upgrade = "aer_small-electric-pole-2"
data.raw["electric-pole"]["big-electric-pole"].fast_replaceable_group = "big-electric-pole"
data.raw["electric-pole"]["big-electric-pole"].next_upgrade = "aer_big-electric-pole-2"
data.raw["electric-pole"]["substation"].fast_replaceable_group = "substation"
data.raw["electric-pole"]["substation"].next_upgrade = "aer_substation-2"
data.raw["electric-pole"]["medium-electric-pole"].maximum_wire_distance = 11
data.raw["electric-pole"]["medium-electric-pole"].next_upgrade = "aer_medium-electric-pole-2"

local small_electric_pole_mk2 = util.table.deepcopy(data.raw["electric-pole"]["small-electric-pole"])
small_electric_pole_mk2.maximum_wire_distance = 9
small_electric_pole_mk2.supply_area_distance = 3.5
small_electric_pole_mk2.name = "aer_small-electric-pole-2"
small_electric_pole_mk2.minable.result =  "aer_small-electric-pole-2"
small_electric_pole_mk2.fast_replaceable_group = "electric-pole"
small_electric_pole_mk2.next_upgrade = nil
data:extend({small_electric_pole_mk2})

local medium_electric_pole_mk2 = util.table.deepcopy(data.raw["electric-pole"]["medium-electric-pole"])
medium_electric_pole_mk2.maximum_wire_distance = 13
medium_electric_pole_mk2.supply_area_distance = 4.5
medium_electric_pole_mk2.name = "aer_medium-electric-pole-2"
medium_electric_pole_mk2.minable.result =  "aer_medium-electric-pole-2"
medium_electric_pole_mk2.fast_replaceable_group = "electric-pole"
medium_electric_pole_mk2.next_upgrade = "aer_medium-electric-pole-3"
data:extend({medium_electric_pole_mk2})

local medium_electric_pole_mk3 = util.table.deepcopy(data.raw["electric-pole"]["medium-electric-pole"])
medium_electric_pole_mk3.maximum_wire_distance = 15
medium_electric_pole_mk3.supply_area_distance = 5.5
medium_electric_pole_mk3.name = "aer_medium-electric-pole-3"
medium_electric_pole_mk3.minable.result =  "aer_medium-electric-pole-3"
medium_electric_pole_mk3.fast_replaceable_group = "electric-pole"
medium_electric_pole_mk3.next_upgrade = "aer_medium-electric-pole-4"
data:extend({medium_electric_pole_mk3})

local medium_electric_pole_mk4 = util.table.deepcopy(data.raw["electric-pole"]["medium-electric-pole"])
medium_electric_pole_mk4.maximum_wire_distance = 17
medium_electric_pole_mk4.supply_area_distance = 6.5
medium_electric_pole_mk4.name = "aer_medium-electric-pole-4"
medium_electric_pole_mk4.minable.result =  "aer_medium-electric-pole-4"
medium_electric_pole_mk4.fast_replaceable_group = "electric-pole"
medium_electric_pole_mk4.next_upgrade = nil
data:extend({medium_electric_pole_mk4})

local big_electric_pole_mk2 = util.table.deepcopy(data.raw["electric-pole"]["big-electric-pole"])
big_electric_pole_mk2.maximum_wire_distance = 38
big_electric_pole_mk2.supply_area_distance = 2
big_electric_pole_mk2.name = "aer_big-electric-pole-2"
big_electric_pole_mk2.minable.result =  "aer_big-electric-pole-2"
big_electric_pole_mk2.fast_replaceable_group = "big-electric-pole"
big_electric_pole_mk2.next_upgrade = "aer_big-electric-pole-3"
data:extend({big_electric_pole_mk2})

local big_electric_pole_mk3 = util.table.deepcopy(data.raw["electric-pole"]["big-electric-pole"])
big_electric_pole_mk3.maximum_wire_distance = 44
big_electric_pole_mk3.supply_area_distance = 2.25
big_electric_pole_mk3.name = "aer_big-electric-pole-3"
big_electric_pole_mk3.minable.result =  "aer_big-electric-pole-3"
big_electric_pole_mk3.fast_replaceable_group = "big-electric-pole"
big_electric_pole_mk3.next_upgrade = "aer_big-electric-pole-4"
data:extend({big_electric_pole_mk3})

local big_electric_pole_mk4 = util.table.deepcopy(data.raw["electric-pole"]["big-electric-pole"])
big_electric_pole_mk4.maximum_wire_distance = 50
big_electric_pole_mk4.supply_area_distance = 2.5
big_electric_pole_mk4.name = "aer_big-electric-pole-4"
big_electric_pole_mk4.minable.result =  "aer_big-electric-pole-4"
big_electric_pole_mk4.fast_replaceable_group = "big-electric-pole"
big_electric_pole_mk4.next_upgrade = nil
data:extend({big_electric_pole_mk4})

local substation_mk2 = util.table.deepcopy(data.raw["electric-pole"]["substation"])
substation_mk2.maximum_wire_distance = 20
substation_mk2.supply_area_distance = 10
substation_mk2.name = "aer_substation-2"
substation_mk2.minable.result =  "aer_substation-2"
substation_mk2.fast_replaceable_group = "substation"
substation_mk2.next_upgrade = "aer_substation-3"
data:extend({substation_mk2})

local substation_mk3 = util.table.deepcopy(data.raw["electric-pole"]["substation"])
substation_mk3.maximum_wire_distance = 22
substation_mk3.supply_area_distance = 11
substation_mk3.name = "aer_substation-3"
substation_mk3.minable.result =  "aer_substation-3"
substation_mk3.fast_replaceable_group = "substation"
substation_mk3.next_upgrade = "aer_substation-4"
data:extend({substation_mk3})

local substation_mk4 = util.table.deepcopy(data.raw["electric-pole"]["substation"])
substation_mk4.maximum_wire_distance = 24
substation_mk4.supply_area_distance = 12
substation_mk4.name = "aer_substation-4"
substation_mk4.minable.result =  "aer_substation-4"
substation_mk4.fast_replaceable_group = "substation"
substation_mk4.next_upgrade = nil
data:extend({substation_mk4})
