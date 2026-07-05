local fluid_helpers = require("prototypes.fluid.helpers")

data.raw["reactor"]["nuclear-reactor"].fast_replaceable_group = "nuclear-reactor"
data.raw["reactor"]["nuclear-reactor"].next_upgrade = "aer_nuclear-reactor-2"

local function reset_to_base_reactor_graphics(reactor)
  reactor.lower_layer_picture = {
    filename = "__base__/graphics/entity/nuclear-reactor/reactor-pipes.png",
    width = 320,
    height = 316,
    scale = 0.5,
    shift = util.by_pixel(-1, -5),
  }
  reactor.heat_lower_layer_picture = apply_heat_pipe_glow {
    filename = "__base__/graphics/entity/nuclear-reactor/reactor-pipes-heated.png",
    width = 320,
    height = 316,
    scale = 0.5,
    shift = util.by_pixel(-0.5, -4.5),
  }
  reactor.picture = {
    layers = {
      {
        filename = "__base__/graphics/entity/nuclear-reactor/reactor.png",
        width = 302,
        height = 318,
        scale = 0.5,
        shift = util.by_pixel(-5, -7),
      },
      {
        filename = "__base__/graphics/entity/nuclear-reactor/reactor-shadow.png",
        width = 525,
        height = 323,
        scale = 0.5,
        shift = { 1.625, 0 },
        draw_as_shadow = true,
      },
    },
  }
  reactor.working_light_picture = {
    filename = "__base__/graphics/entity/nuclear-reactor/reactor-lights-color.png",
    blend_mode = "additive",
    draw_as_glow = true,
    width = 320,
    height = 320,
    scale = 0.5,
    shift = { -0.03125, -0.1875 },
  }
  reactor.heat_buffer.heat_picture = apply_heat_pipe_glow {
    filename = "__base__/graphics/entity/nuclear-reactor/reactor-heated.png",
    width = 216,
    height = 256,
    scale = 0.5,
    shift = util.by_pixel(3, -6.5),
  }
  reactor.connection_patches_connected = {
    sheet = {
      filename = "__base__/graphics/entity/nuclear-reactor/reactor-connect-patches.png",
      width = 64,
      height = 64,
      variation_count = 12,
      scale = 0.5,
    },
  }
  reactor.connection_patches_disconnected = {
    sheet = {
      filename = "__base__/graphics/entity/nuclear-reactor/reactor-connect-patches.png",
      width = 64,
      height = 64,
      variation_count = 12,
      y = 64,
      scale = 0.5,
    },
  }
  reactor.heat_connection_patches_connected = {
    sheet = apply_heat_pipe_glow {
      filename = "__base__/graphics/entity/nuclear-reactor/reactor-connect-patches-heated.png",
      width = 64,
      height = 64,
      variation_count = 12,
      scale = 0.5,
    },
  }
  reactor.heat_connection_patches_disconnected = {
    sheet = apply_heat_pipe_glow {
      filename = "__base__/graphics/entity/nuclear-reactor/reactor-connect-patches-heated.png",
      width = 64,
      height = 64,
      variation_count = 12,
      y = 64,
      scale = 0.5,
    },
  }
end

local reactor_mk2 = util.table.deepcopy(data.raw["reactor"]["nuclear-reactor"])
reactor_mk2.consumption = "80MW"
reactor_mk2.max_health = 1500
reactor_mk2.heat_buffer.max_temperature = 1300
reactor_mk2.heat_buffer.specific_heat = "30MJ"
reactor_mk2.name = "aer_nuclear-reactor-2"
reactor_mk2.minable.result =  "aer_nuclear-reactor-2"
reactor_mk2.fast_replaceable_group = "nuclear-reactor"
reactor_mk2.next_upgrade = "aer_nuclear-reactor-3"
reset_to_base_reactor_graphics(reactor_mk2)
advanced_power_apply_rubber_lined_icon_tint(reactor_mk2)
fluid_helpers.apply_rubber_lined_entity_tint(reactor_mk2)
data:extend({reactor_mk2})

local reactor_mk3 = util.table.deepcopy(data.raw["reactor"]["nuclear-reactor"])
reactor_mk3.consumption = "120MW"
reactor_mk3.max_health = 2000
reactor_mk3.heat_buffer.max_temperature = 1600
reactor_mk3.heat_buffer.specific_heat = "45MJ"
reactor_mk3.name = "aer_nuclear-reactor-3"
reactor_mk3.minable.result = "aer_nuclear-reactor-3"
reactor_mk3.fast_replaceable_group = "nuclear-reactor"
reactor_mk3.next_upgrade = "aer_nuclear-reactor-4"
fluid_helpers.set_resistances(reactor_mk3, require("prototypes.fluid.constants").reinforced.resistances)
reset_to_base_reactor_graphics(reactor_mk3)
fluid_helpers.apply_reinforced_icon_tint(reactor_mk3)
fluid_helpers.apply_reinforced_entity_tint(reactor_mk3)
data:extend({reactor_mk3})

local reactor_mk4 = util.table.deepcopy(data.raw["reactor"]["nuclear-reactor"])
reactor_mk4.consumption = "160MW"
reactor_mk4.max_health = 2500
reactor_mk4.heat_buffer.max_temperature = 2200
reactor_mk4.heat_buffer.specific_heat = "60MJ"
reactor_mk4.name = "aer_nuclear-reactor-4"
reactor_mk4.minable.result = "aer_nuclear-reactor-4"
reactor_mk4.fast_replaceable_group = "nuclear-reactor"
reactor_mk4.next_upgrade = nil
fluid_helpers.set_resistances(reactor_mk4, require("prototypes.fluid.constants").foundation.resistances)
reset_to_base_reactor_graphics(reactor_mk4)
fluid_helpers.apply_foundation_icon_tint(reactor_mk4)
fluid_helpers.apply_foundation_entity_tint(reactor_mk4)
data:extend({reactor_mk4})
