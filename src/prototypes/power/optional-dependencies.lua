-- Resolves everything that differs between loads: whether Advanced Fluid
-- Infrastructure supplies its pipe and pump tiers, and whether Space Age
-- supplies its planet materials and science. Both flags are computed once here
-- and prototype files consume the resolvers below rather than branching on
-- `mods` themselves, so this file is the single auditable answer to "what
-- changes without Space Age?".
--
-- Whole tiers that only exist under Space Age are not handled here; they live
-- in prototypes/power/space-age/ and are required conditionally from
-- prototypes/power.lua.

local optional_dependencies = {}

optional_dependencies.has_advanced_fluid_infrastructure = mods["advanced-fluid-infrastructure"] ~= nil
optional_dependencies.has_space_age = mods["space-age"] ~= nil

local function ingredient(type, name, amount)
  return { type = type, name = name, amount = amount }
end

function optional_dependencies.item(name, amount)
  return { ingredient("item", name, amount) }
end

function optional_dependencies.fluid(name, amount)
  return { ingredient("fluid", name, amount) }
end

local function add_ingredient(result, indexes, source)
  local key = source.type .. ":" .. source.name
  local existing = indexes[key]
  if existing then
    existing.amount = existing.amount + source.amount
    return
  end

  local copy = util.table.deepcopy(source)
  indexes[key] = copy
  table.insert(result, copy)
end

function optional_dependencies.ingredients(...)
  local result = {}
  local indexes = {}

  for _, group in ipairs({ ... }) do
    for _, source in ipairs(group) do
      add_ingredient(result, indexes, source)
    end
  end

  return result
end

function optional_dependencies.pipe_ingredients(tier, amount)
  if optional_dependencies.has_advanced_fluid_infrastructure then
    return optional_dependencies.item("afi_" .. tier .. "-pipe", amount)
  end

  if tier == "steel" then
    return {
      ingredient("item", "pipe", amount),
      ingredient("item", "steel-plate", amount),
    }
  end

  if tier == "rubber-lined" then
    return {
      ingredient("item", "pipe", amount),
      ingredient("item", "plastic-bar", amount),
    }
  end

  if tier == "reinforced" then
    return optional_dependencies.ingredients(
      optional_dependencies.item("pipe", amount),
      optional_dependencies.tungsten_plate(amount),
      optional_dependencies.carbon_fiber(math.ceil(amount / 2))
    )
  end

  if tier == "foundation" then
    return {
      ingredient("item", "pipe", amount),
      ingredient("item", "foundation", math.ceil(amount / 10)),
      ingredient("item", "superconductor", math.ceil(amount / 2)),
    }
  end

  error("Unknown pipe tier: " .. tostring(tier))
end

function optional_dependencies.pump_ingredients(tier, amount)
  if optional_dependencies.has_advanced_fluid_infrastructure then
    return optional_dependencies.item("afi_" .. tier .. "-pump", amount)
  end

  if tier == "rubber-lined" then
    return {
      ingredient("item", "pump", amount),
      ingredient("item", "plastic-bar", amount * 5),
      ingredient("item", "advanced-circuit", amount * 2),
    }
  end

  if tier == "reinforced" then
    return optional_dependencies.ingredients(
      optional_dependencies.item("pump", amount),
      optional_dependencies.tungsten_plate(amount * 5),
      optional_dependencies.carbon_fiber(amount * 3),
      optional_dependencies.item("processing-unit", amount)
    )
  end

  if tier == "foundation" then
    return {
      ingredient("item", "pump", amount),
      ingredient("item", "foundation", amount),
      ingredient("item", "superconductor", amount * 2),
      ingredient("item", "processing-unit", amount * 2),
    }
  end

  error("Unknown pump tier: " .. tostring(tier))
end

-- Picks between a Space Age value and a base-game value. Used for technology
-- prerequisite lists and research units, which differ in gating rather than in
-- shape.
function optional_dependencies.select(space_age, fallback)
  if optional_dependencies.has_space_age then
    return space_age
  end

  return fallback
end

-- Flattens any number of prerequisite lists into one, dropping duplicates. The
-- two optional dependencies are independent axes, so callers build a list from
-- an Advanced Fluid Infrastructure part and a Space Age part.
function optional_dependencies.concat(...)
  local result = {}
  local seen = {}

  for _, group in ipairs({ ... }) do
    for _, name in ipairs(group) do
      if not seen[name] then
        seen[name] = true
        table.insert(result, name)
      end
    end
  end

  return result
end

-- The two reinforcement materials, matching the substitution Advanced Fluid
-- Infrastructure already makes for its own reinforced tier: Space Age uses the
-- Vulcanus and Gleba composites, the base game uses refined concrete and
-- low-density structure at the same quantities.
function optional_dependencies.tungsten_plate(amount)
  if optional_dependencies.has_space_age then
    return optional_dependencies.item("tungsten-plate", amount)
  end

  return optional_dependencies.item("refined-concrete", amount)
end

function optional_dependencies.carbon_fiber(amount)
  if optional_dependencies.has_space_age then
    return optional_dependencies.item("carbon-fiber", amount)
  end

  return optional_dependencies.item("low-density-structure", amount)
end

-- Science that gates the reinforced tier. Space Age routes it through Vulcanus
-- and Gleba; the base game drops those planets, so reinforced is gated on
-- purple and yellow science instead. concrete, which unlocks refined concrete,
-- is not implied by anything above it and so is named explicitly. This mirrors
-- afi_reinforced-pipe-infrastructure exactly.
function optional_dependencies.reinforced_science_prerequisites()
  return optional_dependencies.select(
    { "metallurgic-science-pack", "agricultural-science-pack" },
    { "production-science-pack", "utility-science-pack", "concrete" }
  )
end

function optional_dependencies.reinforced_unit_ingredients()
  return optional_dependencies.select(
    {
      { "automation-science-pack", 1 },
      { "logistic-science-pack", 1 },
      { "chemical-science-pack", 1 },
      { "space-science-pack", 1 },
      { "production-science-pack", 1 },
      { "utility-science-pack", 1 },
      { "metallurgic-science-pack", 1 },
      { "agricultural-science-pack", 1 },
    },
    {
      { "automation-science-pack", 1 },
      { "logistic-science-pack", 1 },
      { "chemical-science-pack", 1 },
      { "production-science-pack", 1 },
      { "utility-science-pack", 1 },
    }
  )
end

function optional_dependencies.prerequisites(advanced_fluid_infrastructure, fallback)
  if optional_dependencies.has_advanced_fluid_infrastructure then
    return advanced_fluid_infrastructure
  end

  return fallback
end

return optional_dependencies
