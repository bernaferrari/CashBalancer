"""Writes every platform icon from the PNG masters in build/icon.

    python3 tool/make_icon.py
    (cd test/browser && node ../../tool/render_icons.cjs)
    python3 tool/export_icons.py   # needs Pillow
"""
from pathlib import Path

from PIL import Image, ImageDraw

ROOT = Path(__file__).resolve().parent.parent
MASTERS = ROOT / "build" / "icon"


def master(name):
    return Image.open(MASTERS / f"{name}.png").convert("RGBA")


def sized(im, size):
    return im.resize((size, size), Image.LANCZOS)


def opaque(im):
    flat = Image.new("RGB", im.size, (255, 248, 239))
    flat.paste(im, mask=im.split()[3])
    return flat


def rounded(im, radius=0.22):
    """Transparent corners, for surfaces that don't mask icons themselves."""
    big = 4 * im.width
    mask = Image.new("L", (big, big), 0)
    ImageDraw.Draw(mask).rounded_rectangle((0, 0, big - 1, big - 1), radius * big, fill=255)
    out = im.copy()
    out.putalpha(mask.resize(im.size, Image.LANCZOS))
    return out


def ios(icon):
    folder = ROOT / "ios/Runner/Assets.xcassets/AppIcon.appiconset"
    for f in folder.glob("*.png"):
        size = Image.open(f).size[0]
        opaque(sized(icon, size)).save(f)


def macos(icon):
    folder = ROOT / "macos/Runner/Assets.xcassets/AppIcon.appiconset"
    for f in folder.glob("*.png"):
        size = Image.open(f).size[0]
        sized(icon, size).save(f)


def android(icon, fg, bg, mono):
    res = ROOT / "android/app/src/main/res"
    for density, scale in {"mdpi": 1, "hdpi": 1.5, "xhdpi": 2, "xxhdpi": 3, "xxxhdpi": 4}.items():
        folder = res / f"mipmap-{density}"
        layer = round(108 * scale)
        sized(fg, layer).save(folder / "ic_launcher_foreground.png")
        opaque(sized(bg, layer)).save(folder / "ic_launcher_background.png")
        sized(mono, layer).save(folder / "ic_launcher_monochrome.png")
        rounded(sized(icon, round(48 * scale))).save(folder / "ic_launcher.png")


def web(icon, maskable):
    web = ROOT / "web"
    for size in (16, 32):
        rounded(sized(icon, size)).save(web / f"favicon-{size}x{size}.png")
    rounded(sized(icon, 32)).save(web / "favicon.png")
    rounded(sized(icon, 256)).save(web / "favicon.ico", sizes=[(16, 16), (32, 32), (48, 48)])
    for size in (192, 512):
        rounded(sized(icon, size)).save(web / f"icons/Icon-{size}.png")
        opaque(sized(maskable, size)).save(web / f"icons/Icon-maskable-{size}.png")
    opaque(sized(icon, 180)).save(web / "icons/apple-touch-icon.png")


if __name__ == "__main__":
    icon = master("app_icon")
    ios(icon)
    macos(master("macos"))
    sized(master("macos"), 256).save(ROOT / "assets/app_icon_rounded.png")
    android(icon, master("adaptive_foreground"), master("adaptive_background"), master("adaptive_monochrome"))
    web(icon, master("maskable"))
    opaque(icon).save(ROOT / "assets/app_icon.png")
    sized(master("app_icon_foreground"), 609).save(ROOT / "assets/icon.png")
