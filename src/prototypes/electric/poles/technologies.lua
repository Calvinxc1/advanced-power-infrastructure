local medium_pole_technology_icon = "__advanced-power-infrastructure__/graphics/technology/medium-electric-pole.png"
local big_pole_technology_icon = "__advanced-power-infrastructure__/graphics/technology/big-electric-pole.png"
local substation_technology_icon = "__advanced-power-infrastructure__/graphics/technology/electric-substation.png"

local function use_locale(technology)
    technology.localised_name = nil
    technology.localised_description = nil
    technology.hidden = false
    technology.enabled = true
    technology.upgrade = false
end

local function use_locale_and_icon(technology, icon)
    use_locale(technology)
    technology.icon = icon
    technology.icon_size = 256
    technology.icons = nil
end

data.raw.technology["electric-energy-distribution-1"].localised_name = {"technology-name.electric-energy-distribution-1"}
data.raw.technology["electric-energy-distribution-1"].localised_description = {"technology-description.electric-energy-distribution-1"}
data.raw.technology["electric-energy-distribution-2"].localised_name = {"technology-name.electric-energy-distribution-2"}
data.raw.technology["electric-energy-distribution-2"].localised_description = {"technology-description.electric-energy-distribution-2"}

local small_pole_mk2 = util.table.deepcopy(data.raw.technology["electric-energy-distribution-1"])
small_pole_mk2.name = "aer_improved-electric-poles"
use_locale(small_pole_mk2)
small_pole_mk2.effects = {
    {type = "unlock-recipe", recipe = "aer_small-electric-pole-2"},
}
small_pole_mk2.prerequisites = {
    "logistic-science-pack",
}
small_pole_mk2.unit.count = 50
small_pole_mk2.unit.ingredients = {
    {"automation-science-pack", 1},
    {"logistic-science-pack", 1},
}
small_pole_mk2.unit.time = 20
small_pole_mk2.order = "c-e-a-2"
small_pole_mk2.upgrade = false
data:extend({small_pole_mk2})

data.raw.technology["electric-energy-distribution-1"].prerequisites =
    data.raw.technology["electric-energy-distribution-1"].prerequisites or {}
table.insert(data.raw.technology["electric-energy-distribution-1"].prerequisites, "aer_improved-electric-poles")

-- local distribution: medium poles into substations
local medium_pole_mk2 = util.table.deepcopy(data.raw.technology["electric-energy-distribution-1"])
medium_pole_mk2.name = "aer_local-energy-distribution-improved"
use_locale_and_icon(medium_pole_mk2, medium_pole_technology_icon)
medium_pole_mk2.effects = {
    {type = "unlock-recipe", recipe = "aer_medium-electric-pole-2"},
}
medium_pole_mk2.prerequisites = {
    "electric-energy-distribution-1",
    "chemical-science-pack",
}
medium_pole_mk2.unit.count = 75
medium_pole_mk2.unit.ingredients = {
    {"automation-science-pack", 1},
    {"logistic-science-pack", 1},
    {"chemical-science-pack", 1},
}
medium_pole_mk2.unit.time = 30
medium_pole_mk2.order = "c-e-b-2"
medium_pole_mk2.upgrade = false
data:extend({medium_pole_mk2})

local substation_mk2 = util.table.deepcopy(data.raw.technology["electric-energy-distribution-2"])
substation_mk2.name = "aer_improved-local-energy-distribution-improved"
use_locale_and_icon(substation_mk2, substation_technology_icon)
substation_mk2.effects = {
    {type = "unlock-recipe", recipe = "aer_substation-2"},
}
substation_mk2.prerequisites = {
    "electric-energy-distribution-2",
    "aer_local-energy-distribution-advanced",
    "advanced-circuit",
}
substation_mk2.unit.count = 150
substation_mk2.unit.ingredients = {
    {"automation-science-pack", 1},
    {"logistic-science-pack", 1},
    {"chemical-science-pack", 1},
    {"production-science-pack", 1},
    {"utility-science-pack", 1},
}
substation_mk2.unit.time = 45
substation_mk2.order = "c-e-b-3"
substation_mk2.upgrade = false
data:extend({substation_mk2})

local medium_pole_mk3 = util.table.deepcopy(data.raw.technology["electric-energy-distribution-1"])
medium_pole_mk3.name = "aer_local-energy-distribution-advanced"
use_locale_and_icon(medium_pole_mk3, medium_pole_technology_icon)
medium_pole_mk3.effects = {
    {type = "unlock-recipe", recipe = "aer_medium-electric-pole-3"},
}
medium_pole_mk3.prerequisites = {
    "aer_local-energy-distribution-improved",
    "production-science-pack",
    "utility-science-pack",
}
medium_pole_mk3.unit.count = 100
medium_pole_mk3.unit.ingredients = {
    {"automation-science-pack", 1},
    {"logistic-science-pack", 1},
    {"chemical-science-pack", 1},
    {"production-science-pack", 1},
    {"utility-science-pack", 1},
}
medium_pole_mk3.unit.time = 30
medium_pole_mk3.order = "c-e-b-4"
medium_pole_mk3.upgrade = false
data:extend({medium_pole_mk3})

local substation_mk3 = util.table.deepcopy(data.raw.technology["electric-energy-distribution-2"])
substation_mk3.name = "aer_improved-local-energy-distribution-advanced"
use_locale_and_icon(substation_mk3, substation_technology_icon)
substation_mk3.effects = {
    {type = "unlock-recipe", recipe = "aer_substation-3"},
}
substation_mk3.prerequisites = {
    "aer_improved-local-energy-distribution-improved",
    "aer_local-energy-distribution-elite",
}
substation_mk3.unit.count = 200
substation_mk3.unit.ingredients = {
    {"automation-science-pack", 1},
    {"logistic-science-pack", 1},
    {"chemical-science-pack", 1},
    {"production-science-pack", 1},
    {"utility-science-pack", 1},
    {"space-science-pack", 1},
    {"electromagnetic-science-pack", 1},
}
substation_mk3.unit.time = 45
substation_mk3.order = "c-e-b-5"
substation_mk3.upgrade = false
data:extend({substation_mk3})

local medium_pole_mk4 = util.table.deepcopy(data.raw.technology["electric-energy-distribution-1"])
medium_pole_mk4.name = "aer_local-energy-distribution-elite"
use_locale_and_icon(medium_pole_mk4, medium_pole_technology_icon)
medium_pole_mk4.effects = {
    {type = "unlock-recipe", recipe = "aer_medium-electric-pole-4"},
}
medium_pole_mk4.prerequisites = {
    "aer_local-energy-distribution-advanced",
    "electromagnetic-science-pack",
}
medium_pole_mk4.unit.count = 150
medium_pole_mk4.unit.ingredients = {
    {"automation-science-pack", 1},
    {"logistic-science-pack", 1},
    {"chemical-science-pack", 1},
    {"production-science-pack", 1},
    {"utility-science-pack", 1},
    {"space-science-pack", 1},
    {"electromagnetic-science-pack", 1},
}
medium_pole_mk4.unit.time = 30
medium_pole_mk4.order = "c-e-b-6"
medium_pole_mk4.upgrade = false
data:extend({medium_pole_mk4})

local substation_mk4 = util.table.deepcopy(data.raw.technology["electric-energy-distribution-2"])
substation_mk4.name = "aer_improved-local-energy-distribution-elite"
use_locale_and_icon(substation_mk4, substation_technology_icon)
substation_mk4.effects = {
    {type = "unlock-recipe", recipe = "aer_substation-4"},
}
substation_mk4.prerequisites = {
    "aer_improved-local-energy-distribution-advanced",
    "cryogenic-science-pack",
    "quantum-processor",
}
substation_mk4.unit.count = 200
substation_mk4.unit.ingredients = {
    {"automation-science-pack", 1},
    {"logistic-science-pack", 1},
    {"chemical-science-pack", 1},
    {"production-science-pack", 1},
    {"utility-science-pack", 1},
    {"space-science-pack", 1},
    {"electromagnetic-science-pack", 1},
    {"cryogenic-science-pack", 1},
}
substation_mk4.unit.time = 45
substation_mk4.order = "c-e-b-7"
substation_mk4.upgrade = false
data:extend({substation_mk4})

-- transmission: big poles into huge poles when Power Overload is present
local big_pole_mk2 = util.table.deepcopy(data.raw.technology["electric-energy-distribution-1"])
big_pole_mk2.name = "aer_distance-power-transmission-improved"
use_locale_and_icon(big_pole_mk2, big_pole_technology_icon)
big_pole_mk2.effects = {
    {type = "unlock-recipe", recipe = "aer_big-electric-pole-2"},
}
big_pole_mk2.prerequisites = {
    "electric-energy-distribution-1",
    "chemical-science-pack",
}
big_pole_mk2.unit.count = 75
big_pole_mk2.unit.ingredients = {
    {"automation-science-pack", 1},
    {"logistic-science-pack", 1},
    {"chemical-science-pack", 1},
}
big_pole_mk2.unit.time = 30
big_pole_mk2.order = "c-e-c-2"
big_pole_mk2.upgrade = false
data:extend({big_pole_mk2})

local big_pole_mk3 = util.table.deepcopy(data.raw.technology["electric-energy-distribution-1"])
big_pole_mk3.name = "aer_distance-power-transmission-advanced"
use_locale_and_icon(big_pole_mk3, big_pole_technology_icon)
big_pole_mk3.effects = {
    {type = "unlock-recipe", recipe = "aer_big-electric-pole-3"},
}
big_pole_mk3.prerequisites = {
    "aer_distance-power-transmission-improved",
    "production-science-pack",
    "utility-science-pack",
}
big_pole_mk3.unit.count = 100
big_pole_mk3.unit.ingredients = {
    {"automation-science-pack", 1},
    {"logistic-science-pack", 1},
    {"chemical-science-pack", 1},
    {"production-science-pack", 1},
    {"utility-science-pack", 1},
}
big_pole_mk3.unit.time = 30
big_pole_mk3.order = "c-e-c-4"
big_pole_mk3.upgrade = false
data:extend({big_pole_mk3})

local big_pole_mk4 = util.table.deepcopy(data.raw.technology["electric-energy-distribution-1"])
big_pole_mk4.name = "aer_distance-power-transmission-elite"
use_locale_and_icon(big_pole_mk4, big_pole_technology_icon)
big_pole_mk4.effects = {
    {type = "unlock-recipe", recipe = "aer_big-electric-pole-4"},
}
big_pole_mk4.prerequisites = {
    "aer_distance-power-transmission-advanced",
    "electromagnetic-science-pack",
}
big_pole_mk4.unit.count = 150
big_pole_mk4.unit.ingredients = {
    {"automation-science-pack", 1},
    {"logistic-science-pack", 1},
    {"chemical-science-pack", 1},
    {"production-science-pack", 1},
    {"utility-science-pack", 1},
    {"space-science-pack", 1},
    {"electromagnetic-science-pack", 1},
}
big_pole_mk4.unit.time = 30
big_pole_mk4.order = "c-e-c-6"
big_pole_mk4.upgrade = false
data:extend({big_pole_mk4})
