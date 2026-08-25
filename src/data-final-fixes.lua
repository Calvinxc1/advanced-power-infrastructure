require("prototypes.power.steam-temperature")
require("prototypes.power.steam-pairing-descriptions")

for name, heat_pipe in pairs(data.raw["heat-pipe"] or {}) do
  if string.sub(name, 1, 4) == "QHP-" then
    heat_pipe.next_upgrade = nil
  end
end
