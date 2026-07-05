#!/usr/bin/env python3
from pathlib import Path
import os

from PIL import Image, ImageEnhance


ROOT = Path(__file__).resolve().parents[1]
FACTORIO_DATA = Path(
    os.environ.get(
        "FACTORIO_DATA_PATH",
        "/home/jcherry/Games/steam/steamapps/common/Factorio/data",
    )
)
BASE_ICONS = FACTORIO_DATA / "base/graphics/icons"
OUT = ROOT / "src/graphics/technology"

STEEL_TINT = (0.5, 0.72, 1.0, 0.62)
STEEL_BRIGHTNESS = 1.12
RUBBER_LINED_BRIGHTNESS = 0.62
RUBBER_LINED_CONTRAST = 1.2
REINFORCED_TINT = (0.22, 0.74, 0.34, 0.22)
FOUNDATION_TINT = (0.82, 0.94, 1.0, 0.28)
FOUNDATION_BRIGHTNESS = 1.08
HOLMIUM_TINT = (0.92, 0.42, 0.95, 0.42)
HOLMIUM_BRIGHTNESS = 1.08


def load_icon(name):
    image = Image.open(BASE_ICONS / name).convert("RGBA")
    return image.crop((0, 0, 64, 64))


def steel_icon(name):
    base = load_icon(name)
    return tint_overlay_icon(base, STEEL_TINT, STEEL_BRIGHTNESS)


def tint_overlay_icon(base, tint, brightness=1.0):
    tinted = Image.new("RGBA", base.size)
    src = base.load()
    dst = tinted.load()
    for y in range(base.height):
        for x in range(base.width):
            r, g, b, a = src[x, y]
            dst[x, y] = (
                int(r * tint[0]),
                int(g * tint[1]),
                int(b * tint[2]),
                int(a * tint[3]),
            )
    composed = Image.new("RGBA", base.size, (0, 0, 0, 0))
    composed.alpha_composite(base)
    composed.alpha_composite(tinted)
    return ImageEnhance.Brightness(composed).enhance(brightness)


def rubber_lined_icon(name):
    base = load_icon(name)
    darkened = ImageEnhance.Brightness(base).enhance(RUBBER_LINED_BRIGHTNESS)
    return ImageEnhance.Contrast(darkened).enhance(RUBBER_LINED_CONTRAST)


def reinforced_icon(name):
    base = load_icon(name)
    return tint_overlay_icon(base, REINFORCED_TINT)


def foundation_icon(name):
    base = load_icon(name)
    return tint_overlay_icon(base, FOUNDATION_TINT, FOUNDATION_BRIGHTNESS)


def holmium_icon(name):
    base = load_icon(name)
    return tint_overlay_icon(base, HOLMIUM_TINT, HOLMIUM_BRIGHTNESS)


def alpha_bbox(image):
    return image.getchannel("A").getbbox()


def fit_icon(image, max_size):
    bbox = alpha_bbox(image)
    if bbox:
        image = image.crop(bbox)
    scale = min(max_size[0] / image.width, max_size[1] / image.height)
    size = (round(image.width * scale), round(image.height * scale))
    return image.resize(size, Image.Resampling.LANCZOS)


def paste_center(canvas, image, center):
    x = round(center[0] - image.width / 2)
    y = round(center[1] - image.height / 2)
    canvas.alpha_composite(image, (x, y))


def save_single(name, source_icon, max_size=(210, 210), center=(128, 128)):
    canvas = Image.new("RGBA", (256, 256), (0, 0, 0, 0))
    icon = fit_icon(steel_icon(source_icon), max_size)
    paste_center(canvas, icon, center)
    canvas.save(OUT / name)


def save_single_rubber_lined(name, source_icon, max_size=(210, 210), center=(128, 128)):
    canvas = Image.new("RGBA", (256, 256), (0, 0, 0, 0))
    icon = fit_icon(rubber_lined_icon(source_icon), max_size)
    paste_center(canvas, icon, center)
    canvas.save(OUT / name)


def save_single_reinforced(name, source_icon, max_size=(210, 210), center=(128, 128)):
    canvas = Image.new("RGBA", (256, 256), (0, 0, 0, 0))
    icon = fit_icon(reinforced_icon(source_icon), max_size)
    paste_center(canvas, icon, center)
    canvas.save(OUT / name)


def save_single_foundation(name, source_icon, max_size=(210, 210), center=(128, 128)):
    canvas = Image.new("RGBA", (256, 256), (0, 0, 0, 0))
    icon = fit_icon(foundation_icon(source_icon), max_size)
    paste_center(canvas, icon, center)
    canvas.save(OUT / name)


def save_single_holmium(name, source_icon, max_size=(210, 210), center=(128, 128)):
    canvas = Image.new("RGBA", (256, 256), (0, 0, 0, 0))
    icon = fit_icon(holmium_icon(source_icon), max_size)
    paste_center(canvas, icon, center)
    canvas.save(OUT / name)


def main():
    OUT.mkdir(parents=True, exist_ok=True)
    save_single("steel-boilers.png", "boiler.png", max_size=(214, 214))
    save_single("steel-steam-engines.png", "steam-engine.png", max_size=(214, 214))
    save_single_rubber_lined("rubber-lined-boilers.png", "boiler.png", max_size=(214, 214))
    save_single_rubber_lined("rubber-lined-steam-engines.png", "steam-engine.png", max_size=(214, 214))
    save_single_rubber_lined("rubber-lined-steam-turbines.png", "steam-turbine.png", max_size=(214, 214))
    save_single_rubber_lined("rubber-lined-heat-exchangers.png", "heat-boiler.png", max_size=(214, 214))
    save_single_rubber_lined("rubber-lined-heat-pipes.png", "heat-pipe.png", max_size=(214, 214))
    save_single_rubber_lined("rubber-lined-nuclear-reactors.png", "nuclear-reactor.png", max_size=(214, 214))
    save_single_reinforced("reinforced-steam-turbines.png", "steam-turbine.png", max_size=(214, 214))
    save_single_reinforced("reinforced-heat-exchangers.png", "heat-boiler.png", max_size=(214, 214))
    save_single_reinforced("reinforced-heat-pipes.png", "heat-pipe.png", max_size=(214, 214))
    save_single_reinforced("reinforced-nuclear-reactors.png", "nuclear-reactor.png", max_size=(214, 214))
    save_single_foundation("foundation-steam-turbines.png", "steam-turbine.png", max_size=(214, 214))
    save_single_foundation("foundation-heat-exchangers.png", "heat-boiler.png", max_size=(214, 214))
    save_single_foundation("foundation-heat-pipes.png", "heat-pipe.png", max_size=(214, 214))
    save_single_foundation("foundation-nuclear-reactors.png", "nuclear-reactor.png", max_size=(214, 214))
    save_single_holmium("holmium-reinforced-boilers.png", "boiler.png", max_size=(214, 214))
    save_single_holmium("holmium-steam-engines.png", "steam-engine.png", max_size=(214, 214))


if __name__ == "__main__":
    main()
