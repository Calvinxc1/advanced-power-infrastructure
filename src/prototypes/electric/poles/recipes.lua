--small poles--
local small_electric_pole_mk2 = util.table.deepcopy(data.raw.recipe["small-electric-pole"])
small_electric_pole_mk2.name = "aer_small-electric-pole-2"
small_electric_pole_mk2.enabled = false
small_electric_pole_mk2.ingredients = {
  { type = "item", name = "small-electric-pole", amount = 2 },
  { type = "item", name = "electronic-circuit", amount = 2 },
  { type = "item", name = "copper-cable", amount = 2 },
}
small_electric_pole_mk2.results = {
  { type = "item", name = "aer_small-electric-pole-2", amount = 2 }
}
data:extend({small_electric_pole_mk2})

--medium poles--
local medium_electric_pole_mk2 = util.table.deepcopy(data.raw.recipe["medium-electric-pole"])
medium_electric_pole_mk2.name = "aer_medium-electric-pole-2"
medium_electric_pole_mk2.enabled = false
medium_electric_pole_mk2.ingredients = {
  { type = "item", name = "medium-electric-pole", amount = 1 },
  { type = "item", name = "steel-plate", amount = 1 },
  { type = "item", name = "copper-plate", amount = 2 },
}
medium_electric_pole_mk2.results = {
  { type = "item", name = "aer_medium-electric-pole-2", amount = 1 }
}
data:extend({medium_electric_pole_mk2})

local medium_electric_pole_mk3 = util.table.deepcopy(data.raw.recipe["medium-electric-pole"])
medium_electric_pole_mk3.name = "aer_medium-electric-pole-3"
medium_electric_pole_mk3.enabled = false
medium_electric_pole_mk3.ingredients = {
  { type = "item", name = "aer_medium-electric-pole-2", amount = 1 },
  { type = "item", name = "steel-plate", amount = 1 },
  { type = "item", name = "copper-plate", amount = 4 },
  { type = "item", name = "advanced-circuit", amount = 1 },
}
medium_electric_pole_mk3.results = {
  { type = "item", name = "aer_medium-electric-pole-3", amount = 1 }
}
data:extend({medium_electric_pole_mk3})

local medium_electric_pole_mk4 = util.table.deepcopy(data.raw.recipe["medium-electric-pole"])
medium_electric_pole_mk4.name = "aer_medium-electric-pole-4"
medium_electric_pole_mk4.enabled = false
medium_electric_pole_mk4.ingredients = {
  { type = "item", name = "aer_medium-electric-pole-3", amount = 1 },
  { type = "item", name = "steel-plate", amount = 1 },
  { type = "item", name = "copper-plate", amount = 2 },
  { type = "item", name = "processing-unit", amount = 1 },
  { type = "item", name = "low-density-structure", amount = 1 },
}
medium_electric_pole_mk4.results = {
  { type = "item", name = "aer_medium-electric-pole-4", amount = 1 }
}
data:extend({medium_electric_pole_mk4})

--big poles--
local big_electric_pole_mk2 = util.table.deepcopy(data.raw.recipe["big-electric-pole"])
big_electric_pole_mk2.name = "aer_big-electric-pole-2"
big_electric_pole_mk2.enabled = false
big_electric_pole_mk2.ingredients = {
  { type = "item", name = "big-electric-pole", amount = 1 },
  { type = "item", name = "steel-plate", amount = 3 },
  { type = "item", name = "copper-plate", amount = 3 },
}
big_electric_pole_mk2.results = {
  { type = "item", name = "aer_big-electric-pole-2", amount = 1 }
}
data:extend({big_electric_pole_mk2})

local big_electric_pole_mk3 = util.table.deepcopy(data.raw.recipe["big-electric-pole"])
big_electric_pole_mk3.name = "aer_big-electric-pole-3"
big_electric_pole_mk3.enabled = false
big_electric_pole_mk3.ingredients = {
  { type = "item", name = "aer_big-electric-pole-2", amount = 1 },
  { type = "item", name = "steel-plate", amount = 3 },
  { type = "item", name = "copper-plate", amount = 3 },
  { type = "item", name = "advanced-circuit", amount = 2 },
  { type = "item", name = "low-density-structure", amount = 1 },
}
big_electric_pole_mk3.results = {
  { type = "item", name = "aer_big-electric-pole-3", amount = 1 }
}
data:extend({big_electric_pole_mk3})

local big_electric_pole_mk4 = util.table.deepcopy(data.raw.recipe["big-electric-pole"])
big_electric_pole_mk4.name = "aer_big-electric-pole-4"
big_electric_pole_mk4.enabled = false
big_electric_pole_mk4.ingredients = {
  { type = "item", name = "aer_big-electric-pole-3", amount = 1 },
  { type = "item", name = "steel-plate", amount = 3 },
  { type = "item", name = "copper-plate", amount = 3 },
  { type = "item", name = "processing-unit", amount = 2 },
  { type = "item", name = "superconductor", amount = 2 },
}
big_electric_pole_mk4.results = {
  { type = "item", name = "aer_big-electric-pole-4", amount = 1 }
}
data:extend({big_electric_pole_mk4})

--substations--
local substation_mk2 = util.table.deepcopy(data.raw.recipe["substation"])
substation_mk2.name = "aer_substation-2"
substation_mk2.enabled = false
substation_mk2.ingredients = {
  { type = "item", name = "substation", amount = 1 },
  { type = "item", name = "advanced-circuit", amount = 2 },
  { type = "item", name = "steel-plate", amount = 10 },
  { type = "item", name = "copper-plate", amount = 5 },
}
substation_mk2.results = {
  { type = "item", name = "aer_substation-2", amount = 1 }
}
data:extend({substation_mk2})

local substation_mk3 = util.table.deepcopy(data.raw.recipe["substation"])
substation_mk3.name = "aer_substation-3"
substation_mk3.enabled = false
substation_mk3.ingredients = {
  { type = "item", name = "aer_substation-2", amount = 1 },
  { type = "item", name = "advanced-circuit", amount = 2 },
  { type = "item", name = "processing-unit", amount = 2 },
  { type = "item", name = "steel-plate", amount = 10 },
  { type = "item", name = "copper-plate", amount = 5 },
  { type = "item", name = "low-density-structure", amount = 2 },
}
substation_mk3.results = {
  { type = "item", name = "aer_substation-3", amount = 1 }
}
data:extend({substation_mk3})

local substation_mk4 = util.table.deepcopy(data.raw.recipe["substation"])
substation_mk4.name = "aer_substation-4"
substation_mk4.enabled = false
substation_mk4.ingredients = {
  { type = "item", name = "aer_substation-3", amount = 1 },
  { type = "item", name = "advanced-circuit", amount = 2 },
  { type = "item", name = "processing-unit", amount = 5 },
  { type = "item", name = "superconductor", amount = 10 },
  { type = "item", name = "quantum-processor", amount = 2 },
  { type = "item", name = "steel-plate", amount = 10 },
  { type = "item", name = "copper-plate", amount = 5 },
}
substation_mk4.results = {
  { type = "item", name = "aer_substation-4", amount = 1 }
}
data:extend({substation_mk4})
