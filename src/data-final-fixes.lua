for name, heat_pipe in pairs(data.raw["heat-pipe"] or {}) do
  if string.sub(name, 1, 4) == "QHP-" then
    heat_pipe.next_upgrade = nil
  end
end

if mods["RampantArsenalFork"] then
  local rampant_reinforced_pipes = {
    ["reinforced-pipe-rampant-arsenal"] = true,
    ["reinforced-pipe-to-ground-rampant-arsenal"] = true,
  }

  local function ingredient_or_result_references_removed_pipe(entry)
    return entry and rampant_reinforced_pipes[entry.name]
  end

  local function recipe_references_removed_pipe(recipe)
    for _, ingredient in pairs(recipe.ingredients or {}) do
      if ingredient_or_result_references_removed_pipe(ingredient) then
        return true
      end
    end
    for _, result in pairs(recipe.results or {}) do
      if ingredient_or_result_references_removed_pipe(result) then
        return true
      end
    end
    return recipe.result and rampant_reinforced_pipes[recipe.result]
  end

  for name in pairs(rampant_reinforced_pipes) do
    if data.raw.pipe then
      data.raw.pipe[name] = nil
    end
    if data.raw["pipe-to-ground"] then
      data.raw["pipe-to-ground"][name] = nil
    end
    if data.raw.item then
      data.raw.item[name] = nil
    end
    if data.raw.recipe then
      data.raw.recipe[name] = nil
    end
  end

  for name, recipe in pairs(data.raw.recipe or {}) do
    if recipe_references_removed_pipe(recipe) then
      data.raw.recipe[name] = nil
    end
  end

  for _, technology in pairs(data.raw.technology or {}) do
    local effects = technology.effects
    if effects then
      for index = #effects, 1, -1 do
        local effect = effects[index]
        if effect.type == "unlock-recipe" and rampant_reinforced_pipes[effect.recipe] then
          table.remove(effects, index)
        end
      end
    end
  end

  if data.raw.technology then
    data.raw.technology["rampant-arsenal-technology-reinforced-pipes"] = nil
  end
end
