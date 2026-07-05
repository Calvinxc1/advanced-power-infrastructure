if mods["PowerOverload"] then
    local huge_electric_pole_mk2_recipe = util.table.deepcopy(data.raw.recipe["po-huge-electric-pole"])
    huge_electric_pole_mk2_recipe.name = "aer_huge-electric-pole-2"
    huge_electric_pole_mk2_recipe.enabled = false
    huge_electric_pole_mk2_recipe.ingredients = {
      { type = "item", name = "po-huge-electric-pole", amount = 1 },
      { type = "item", name = "copper-plate", amount = 15 },
      { type = "item", name = "steel-plate", amount = 15 },
      { type = "item", name = "iron-stick", amount = 20 },
      { type = "item", name = "advanced-circuit", amount = 10 },
    }
    huge_electric_pole_mk2_recipe.results = {
      { type = "item", name = "aer_huge-electric-pole-2", amount = 1 }
    }

    local huge_electric_pole_mk3_recipe = util.table.deepcopy(data.raw.recipe["po-huge-electric-pole"])
    huge_electric_pole_mk3_recipe.name = "aer_huge-electric-pole-3"
    huge_electric_pole_mk3_recipe.enabled = false
    huge_electric_pole_mk3_recipe.ingredients = {
      { type = "item", name = "aer_huge-electric-pole-2", amount = 1 },
      { type = "item", name = "copper-plate", amount = 15 },
      { type = "item", name = "steel-plate", amount = 15 },
      { type = "item", name = "iron-stick", amount = 20 },
      { type = "item", name = "advanced-circuit", amount = 10 },
      { type = "item", name = "processing-unit", amount = 5 },
      { type = "item", name = "low-density-structure", amount = 5 },
      { type = "item", name = "superconductor", amount = 5 },
    }
    huge_electric_pole_mk3_recipe.results = {
      { type = "item", name = "aer_huge-electric-pole-3", amount = 1 }
    }

    local huge_electric_pole_mk4_recipe = util.table.deepcopy(data.raw.recipe["po-huge-electric-pole"])
    huge_electric_pole_mk4_recipe.name = "aer_huge-electric-pole-4"
    huge_electric_pole_mk4_recipe.enabled = false
    huge_electric_pole_mk4_recipe.ingredients = {
      { type = "item", name = "aer_huge-electric-pole-3", amount = 1 },
      { type = "item", name = "copper-plate", amount = 15 },
      { type = "item", name = "steel-plate", amount = 15 },
      { type = "item", name = "iron-stick", amount = 20 },
      { type = "item", name = "advanced-circuit", amount = 10 },
      { type = "item", name = "processing-unit", amount = 10 },
      { type = "item", name = "foundation", amount = 2 },
      { type = "item", name = "superconductor", amount = 10 },
      { type = "item", name = "quantum-processor", amount = 2 },
    }
    huge_electric_pole_mk4_recipe.results = {
      { type = "item", name = "aer_huge-electric-pole-4", amount = 1 }
    }

    data:extend{huge_electric_pole_mk2_recipe, huge_electric_pole_mk3_recipe, huge_electric_pole_mk4_recipe}
end
