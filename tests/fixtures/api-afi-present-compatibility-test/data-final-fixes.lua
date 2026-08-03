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
  ingredient_amount(heat_exchanger, "afi_steel-pipe") == 10,
  "heat-exchanger recipe did not use afi_steel-pipe with Advanced Fluid Infrastructure installed"
)
assert(
  ingredient_amount(heat_exchanger, "steel-plate") == 10,
  "heat-exchanger recipe steel-plate amount was not the expected base amount"
    .. " with Advanced Fluid Infrastructure installed"
)
assert(
  ingredient_amount(heat_exchanger, "pipe") == nil,
  "heat-exchanger recipe still referenced vanilla pipe with Advanced Fluid Infrastructure installed"
)

local steam_turbine_mk2 = data.raw.recipe["aer_rubber-lined-steam-turbine"]
assert(steam_turbine_mk2, "aer_rubber-lined-steam-turbine recipe is missing")
assert(
  ingredient_amount(steam_turbine_mk2, "afi_rubber-lined-pipe") == 20,
  "aer_rubber-lined-steam-turbine did not use afi_rubber-lined-pipe with Advanced Fluid Infrastructure installed"
)
assert(
  ingredient_amount(steam_turbine_mk2, "afi_rubber-lined-pump") == 2,
  "aer_rubber-lined-steam-turbine did not use afi_rubber-lined-pump with Advanced Fluid Infrastructure installed"
)
assert(
  ingredient_amount(steam_turbine_mk2, "pipe") == nil
    and ingredient_amount(steam_turbine_mk2, "pump") == nil
    and ingredient_amount(steam_turbine_mk2, "plastic-bar") == nil
    and ingredient_amount(steam_turbine_mk2, "advanced-circuit") == nil,
  "aer_rubber-lined-steam-turbine still referenced a vanilla fallback ingredient"
    .. " with Advanced Fluid Infrastructure installed"
)
