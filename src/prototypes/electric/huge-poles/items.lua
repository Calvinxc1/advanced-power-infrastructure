if mods["PowerOverload"] then
    local huge_pole_mk2_item = util.table.deepcopy(data.raw.item["po-huge-electric-pole"])
    huge_pole_mk2_item.subgroup = "aer_poles"
    huge_pole_mk2_item.name = "aer_huge-electric-pole-2"
    huge_pole_mk2_item.place_result = "aer_huge-electric-pole-2"

    local huge_pole_mk3_item = util.table.deepcopy(data.raw.item["po-huge-electric-pole"])
    huge_pole_mk3_item.subgroup = "aer_poles"
    huge_pole_mk3_item.name = "aer_huge-electric-pole-3"
    huge_pole_mk3_item.place_result = "aer_huge-electric-pole-3"

    local huge_pole_mk4_item = util.table.deepcopy(data.raw.item["po-huge-electric-pole"])
    huge_pole_mk4_item.subgroup = "aer_poles"
    huge_pole_mk4_item.name = "aer_huge-electric-pole-4"
    huge_pole_mk4_item.place_result = "aer_huge-electric-pole-4"

    data:extend{huge_pole_mk2_item, huge_pole_mk3_item, huge_pole_mk4_item}
end
