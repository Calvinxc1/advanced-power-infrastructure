if mods["PowerOverload"] then
    data.raw["electric-pole"]["po-huge-electric-pole"].maximum_wire_distance = 40
    data.raw["electric-pole"]["po-huge-electric-pole"].fast_replaceable_group = "huge-electric-pole"

    local huge_pole_mk2_entity = util.table.deepcopy(data.raw["electric-pole"]["po-huge-electric-pole"])
    huge_pole_mk2_entity.name = "aer_huge-electric-pole-2"
    huge_pole_mk2_entity.minable.result = "aer_huge-electric-pole-2"
    huge_pole_mk2_entity.maximum_wire_distance = 48
    huge_pole_mk2_entity.fast_replaceable_group = "huge-electric-pole"

    local huge_pole_mk3_entity = util.table.deepcopy(data.raw["electric-pole"]["po-huge-electric-pole"])
    huge_pole_mk3_entity.name = "aer_huge-electric-pole-3"
    huge_pole_mk3_entity.minable.result = "aer_huge-electric-pole-3"
    huge_pole_mk3_entity.maximum_wire_distance = 56
    huge_pole_mk3_entity.fast_replaceable_group = "huge-electric-pole"

    local huge_pole_mk4_entity = util.table.deepcopy(data.raw["electric-pole"]["po-huge-electric-pole"])
    huge_pole_mk4_entity.name = "aer_huge-electric-pole-4"
    huge_pole_mk4_entity.minable.result = "aer_huge-electric-pole-4"
    huge_pole_mk4_entity.maximum_wire_distance = 64
    huge_pole_mk4_entity.fast_replaceable_group = "huge-electric-pole"

    data:extend{huge_pole_mk2_entity, huge_pole_mk3_entity, huge_pole_mk4_entity}
end
