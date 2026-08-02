local function ingredient_amount(recipe, item_name)
  for _, ingredient in pairs(recipe.ingredients) do
    if ingredient.name == item_name then
      return ingredient.amount
    end
  end
  return nil
end

local heat_exchanger = data.raw.recipe["heat-exchanger"]
assert(heat_exchanger, "heat-exchanger recipe is missing")
assert(
  ingredient_amount(heat_exchanger, "pipe") == 10,
  "heat-exchanger recipe did not fall back to vanilla pipe without Advanced Fluid Infrastructure"
)
assert(
  ingredient_amount(heat_exchanger, "steel-plate") == 20,
  "heat-exchanger recipe steel-plate amount was not the expected fallback total"
    .. " (10 base + 10 pipe-fallback) without Advanced Fluid Infrastructure"
)
assert(
  ingredient_amount(heat_exchanger, "afi_steel-pipe") == nil,
  "heat-exchanger recipe referenced afi_steel-pipe without Advanced Fluid Infrastructure installed"
)

local steam_turbine_mk2 = data.raw.recipe["aer_rubber-lined-steam-turbine"]
assert(steam_turbine_mk2, "aer_rubber-lined-steam-turbine recipe is missing")
assert(
  ingredient_amount(steam_turbine_mk2, "pipe") == 20,
  "aer_rubber-lined-steam-turbine did not fall back to vanilla pipe without Advanced Fluid Infrastructure"
)
assert(
  ingredient_amount(steam_turbine_mk2, "pump") == 2,
  "aer_rubber-lined-steam-turbine did not fall back to vanilla pump without Advanced Fluid Infrastructure"
)
-- plastic-bar is contributed by both the pipe fallback (20) and the pump fallback (2 * 5 = 10),
-- and optional_dependencies.ingredients() sums same-name ingredients together.
assert(
  ingredient_amount(steam_turbine_mk2, "plastic-bar") == 30,
  "aer_rubber-lined-steam-turbine plastic-bar amount was not the expected fallback total"
    .. " (20 pipe-fallback + 10 pump-fallback) without Advanced Fluid Infrastructure"
)
assert(
  ingredient_amount(steam_turbine_mk2, "advanced-circuit") == 4,
  "aer_rubber-lined-steam-turbine did not fall back to advanced-circuit for the pump tier"
    .. " without Advanced Fluid Infrastructure"
)
assert(
  ingredient_amount(steam_turbine_mk2, "afi_rubber-lined-pipe") == nil,
  "aer_rubber-lined-steam-turbine referenced afi_rubber-lined-pipe without Advanced Fluid Infrastructure installed"
)
assert(
  ingredient_amount(steam_turbine_mk2, "afi_rubber-lined-pump") == nil,
  "aer_rubber-lined-steam-turbine referenced afi_rubber-lined-pump without Advanced Fluid Infrastructure installed"
)
