-- Technology corrections that depend on where every mod, this one included,
-- left its unlocks. Runs in data-final-fixes, after the mods this one loads
-- after have moved theirs.

local function add_prerequisite(technology, prerequisite_name)
  technology.prerequisites = technology.prerequisites or {}
  for _, existing in pairs(technology.prerequisites) do
    if existing == prerequisite_name then
      return
    end
  end
  table.insert(technology.prerequisites, prerequisite_name)
end

local function unlocks(technology_name)
  local recipes = {}
  for _, effect in pairs(data.raw.technology[technology_name].effects or {}) do
    if effect.type == "unlock-recipe" then
      table.insert(recipes, effect.recipe)
    end
  end
  return recipes
end

local function requires(technology, ancestor_name, visited)
  visited = visited or {}
  for _, prerequisite_name in pairs(technology.prerequisites or {}) do
    if prerequisite_name == ancestor_name then
      return true
    end
    local prerequisite = data.raw.technology[prerequisite_name]
    if prerequisite and not visited[prerequisite_name] then
      visited[prerequisite_name] = true
      if requires(prerequisite, ancestor_name, visited) then
        return true
      end
    end
  end
  return false
end

-- Every recipe that produces an item, and the technologies that unlock each
-- recipe. Hidden recipes are not a way to make anything: Space Age's
-- recycling recipes, for one, return a lithium-sulfur battery from anything
-- built with one, and recycling comes before electromagnetic science.
local producers, unlockers = {}, {}
for recipe_name, recipe in pairs(data.raw.recipe) do
  for _, result in pairs(not recipe.hidden and recipe.results or {}) do
    if result.name then
      producers[result.name] = producers[result.name] or {}
      table.insert(producers[result.name], recipe_name)
    end
  end
end
for technology_name, technology in pairs(data.raw.technology) do
  for _, effect in pairs(technology.effects or {}) do
    if effect.type == "unlock-recipe" then
      unlockers[effect.recipe] = unlockers[effect.recipe] or {}
      table.insert(unlockers[effect.recipe], technology_name)
    end
  end
end

-- The technology to wait on for an ingredient, or nil when the technology
-- already can make it: some recipe for it is enabled from the start or
-- unlocked by this technology or one it requires, or nothing crafts it at all
-- (a mined resource). Otherwise it is the technology unlocking the recipe
-- named after the item, as overhauls name their main recipe, provided that
-- technology does not itself come after this one.
local function missing_unlock(technology_name, item_name)
  local recipes = producers[item_name]
  if not recipes then
    return nil
  end
  local technology = data.raw.technology[technology_name]
  for _, recipe_name in pairs(recipes) do
    local recipe = data.raw.recipe[recipe_name]
    local unlocked_by = unlockers[recipe_name] or {}
    if #unlocked_by == 0 and recipe.enabled ~= false then
      return nil
    end
    for _, unlocker in pairs(unlocked_by) do
      if unlocker == technology_name or requires(technology, unlocker) then
        return nil
      end
    end
  end
  local main = unlockers[item_name] and unlockers[item_name][1]
  if main and not requires(data.raw.technology[main], technology_name) then
    return main
  end
  return nil
end

-- Each of this mod's technologies waits on whatever unlocks its recipes'
-- ingredients, unless it already does. In every load the steel boiler is built
-- from a steel furnace, which advanced material processing unlocks; under
-- Space Age the reinforced tiers take carbon fiber; Space Exploration moves
-- boilers, steam engines and electronic circuits onto technologies of its own.
for technology_name, technology in pairs(data.raw.technology) do
  if string.sub(technology_name, 1, 4) == "aer_" then
    for _, recipe_name in pairs(unlocks(technology_name)) do
      local recipe = data.raw.recipe[recipe_name]
      for _, ingredient in pairs(recipe and recipe.ingredients or {}) do
        local unlocker = missing_unlock(technology_name, ingredient.name)
        if unlocker then
          add_prerequisite(technology, unlocker)
        end
      end
    end
  end
end
