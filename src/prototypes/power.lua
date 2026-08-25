local optional_dependencies = require("prototypes.power.optional-dependencies")

require("prototypes.power.categories")
require("prototypes.power.boilers")
require("prototypes.power.steam-engines")
require("prototypes.power.steam-turbines")
require("prototypes.power.heat-exchangers")
require("prototypes.power.heat-pipe")
require("prototypes.power.reactors")

-- Solar and fusion exist only under Space Age. Every solar and accumulator tier
-- is built from holmium, lithium, or quantum processors, and the fusion tiers
-- are built on Space Age's own fusion reactor and generator, so neither module
-- has a base-game form to fall back to.
--
-- The remaining modules keep their lower tiers in a base-game load and move
-- only their top tiers into prototypes/power/space-age/.
if optional_dependencies.has_space_age then
  require("prototypes.power.solar")
  require("prototypes.power.fusion")
  require("prototypes.power.space-age")
end
