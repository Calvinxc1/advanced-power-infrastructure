local optional_dependencies = {}

optional_dependencies.has_advanced_fluid_infrastructure = mods["advanced-fluid-infrastructure"] ~= nil

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
    return {
      ingredient("item", "pipe", amount),
      ingredient("item", "tungsten-plate", amount),
      ingredient("item", "carbon-fiber", math.ceil(amount / 2)),
    }
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
    return {
      ingredient("item", "pump", amount),
      ingredient("item", "tungsten-plate", amount * 5),
      ingredient("item", "carbon-fiber", amount * 3),
      ingredient("item", "processing-unit", amount),
    }
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

function optional_dependencies.prerequisites(advanced_fluid_infrastructure, fallback)
  if optional_dependencies.has_advanced_fluid_infrastructure then
    return advanced_fluid_infrastructure
  end

  return fallback
end

return optional_dependencies
