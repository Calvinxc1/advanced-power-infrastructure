local fusion_reactor_2 = util.table.deepcopy(data.raw.technology["fusion-reactor"])
fusion_reactor_2.name = "aer_promethium-fusion-reactor"
fusion_reactor_2.localised_name = {"technology-name.aer_promethium-fusion-reactor"}
fusion_reactor_2.icon = "__space-age__/graphics/technology/fusion-reactor.png"
fusion_reactor_2.icon_size = 256
fusion_reactor_2.icons = nil
fusion_reactor_2.prerequisites = {
  "fusion-reactor",
  "promethium-science-pack",
  "foundation",
}
fusion_reactor_2.effects = {
  { type = "unlock-recipe", recipe = "aer_fusion-reactor-2" },
}
fusion_reactor_2.unit.count = 10000
fusion_reactor_2.unit.ingredients = {
  {"automation-science-pack", 1},
  {"logistic-science-pack", 1},
  {"chemical-science-pack", 1},
  {"production-science-pack", 1},
  {"utility-science-pack", 1},
  {"space-science-pack", 1},
  {"metallurgic-science-pack", 1},
  {"agricultural-science-pack", 1},
  {"electromagnetic-science-pack", 1},
  {"cryogenic-science-pack", 1},
  {"promethium-science-pack", 1},
}
fusion_reactor_2.unit.time = 120
fusion_reactor_2.upgrade = true
fusion_reactor_2.order = "g[fusion-energy]-c[reactor]"

local fusion_generator_2 = util.table.deepcopy(data.raw.technology["fusion-reactor"])
fusion_generator_2.name = "aer_promethium-fusion-generator"
fusion_generator_2.localised_name = {"technology-name.aer_promethium-fusion-generator"}
fusion_generator_2.icon = "__space-age__/graphics/technology/fusion-reactor.png"
fusion_generator_2.icon_size = 256
fusion_generator_2.icons = nil
fusion_generator_2.prerequisites = {
  "aer_promethium-fusion-reactor",
}
fusion_generator_2.effects = {
  { type = "unlock-recipe", recipe = "aer_fusion-generator-2" },
}
fusion_generator_2.unit.count = 10000
fusion_generator_2.unit.ingredients = {
  {"automation-science-pack", 1},
  {"logistic-science-pack", 1},
  {"chemical-science-pack", 1},
  {"production-science-pack", 1},
  {"utility-science-pack", 1},
  {"space-science-pack", 1},
  {"metallurgic-science-pack", 1},
  {"agricultural-science-pack", 1},
  {"electromagnetic-science-pack", 1},
  {"cryogenic-science-pack", 1},
  {"promethium-science-pack", 1},
}
fusion_generator_2.unit.time = 120
fusion_generator_2.upgrade = true
fusion_generator_2.order = "g[fusion-energy]-d[generator]"

data:extend({
  fusion_reactor_2,
  fusion_generator_2,
})
