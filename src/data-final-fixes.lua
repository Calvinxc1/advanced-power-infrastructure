-- The tier rebuild runs here, after every mod this one loads after has
-- finished: Space Exploration sets the vanilla heat pipe's transfer, and with
-- Krastorio 2 the steam heat capacity, in its own data-final-fixes. First, so
-- the passes after it read the rebuilt tiers.
require("prototypes.power.energy-scale")
require("prototypes.power.steam-temperature")
require("prototypes.power.steam-pairing-descriptions")
require("prototypes.power.technology-fixes")

for name, heat_pipe in pairs(data.raw["heat-pipe"] or {}) do
  if string.sub(name, 1, 4) == "QHP-" then
    heat_pipe.next_upgrade = nil
  end
end
