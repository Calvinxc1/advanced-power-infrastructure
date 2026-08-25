local constants = require("prototypes.power.fluid-constants")
local fluid_helpers = require("prototypes.power.fluid-helpers")

data.raw["reactor"]["nuclear-reactor"].fast_replaceable_group = "nuclear-reactor"
data.raw["reactor"]["nuclear-reactor"].next_upgrade = "aer_nuclear-reactor-2"
-- Ceiling sits just above the steel exchanger's 500 optimal, rather than at
-- double it. Set before the tiers below deepcopy this prototype.
data.raw["reactor"]["nuclear-reactor"].heat_buffer.max_temperature =
  constants.heat_tier_ceiling.mk1

-- heat_buffer.max_transfer is deliberately left at vanilla's flat 10 GW on
-- every reactor tier, and is the only number in the heat chain that does not
-- scale. It never binds: a mk4 2x2 block pushes 1.92 GW against it, so making
-- it tier up would read as consistency without changing anything in play.
-- Reviewed under issue #14 and kept as a non-constraint on purpose.

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
-- Matches aer_heat-exchanger-2's 650 optimal.
reactor_mk2.heat_buffer.max_temperature = constants.heat_tier_ceiling.mk2
reactor_mk2.heat_buffer.specific_heat = "30MJ"
reactor_mk2.name = "aer_nuclear-reactor-2"
reactor_mk2.minable.result =  "aer_nuclear-reactor-2"
reactor_mk2.fast_replaceable_group = "nuclear-reactor"
-- Terminates the base-game ladder. prototypes/power/space-age/reactors/entities.lua
-- re-points this at its Space Age tier when that tier exists, so the chain is
-- correct in both loads without depending on load order.
reactor_mk2.next_upgrade = nil
reset_to_base_reactor_graphics(reactor_mk2)
advanced_power_apply_rubber_lined_icon_tint(reactor_mk2)
fluid_helpers.apply_rubber_lined_entity_tint(reactor_mk2)
data:extend({reactor_mk2})

-- The engine's neighbour bonus is switched off on every tier, and control.lua
-- pays a bonus per aligned heat connection instead. The engine pays once per
-- neighbouring reactor however many connections line up, which is exactly the
-- distinction this is built to make. See issue #10.
for _, reactor in ipairs({data.raw["reactor"]["nuclear-reactor"], reactor_mk2}) do
  reactor.neighbour_bonus = 0
  fluid_helpers.set_description(reactor,
    fluid_helpers.reactor_connection_description(constants.reactor_connection_bonus))
end
