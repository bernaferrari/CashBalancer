"""Draws the app icon: an allocation ring shaped like a C, with the slice above
its target hatched. Writes the SVG masters to assets/icon.

    python3 tool/make_icon.py
"""
import math
from pathlib import Path

W = H = 1024
CX, CY = 530, 512
R, STROKE = 236, 150
RI, RO = R - STROKE / 2, R + STROKE / 2
OPEN = 40  # half-angle of the C's mouth, degrees
GAP = 22  # parallel gap between slices, px
RC = 22  # inner corner radius, px
GREEN, AMBER, INDIGO = "#10B981", "#F59E0B", "#6366F1"
SHARES = [(0.46, GREEN), (0.32, AMBER), (0.22, INDIGO)]
EXCESS = 0.11  # of the whole ring, hatched at the end of amber
# Android keeps only the center 66 of 108 dp of an adaptive icon visible.
ADAPTIVE_SCALE = 0.84


def pt(deg, r):
    a = math.radians(deg)
    return CX + r * math.cos(a), CY + r * math.sin(a)


def inset(deg, d, r, toward):
    """Angle on radius r whose distance to the radial line at deg is d."""
    return deg + toward * math.degrees(math.asin(d / r))


def sector(a, b, ri, ro, da, db):
    """Annular slice from angle a down to b; edges pushed inward by da / db px."""
    ao, ai = inset(a, da, ro, -1), inset(a, da, ri, -1)
    bo, bi = inset(b, db, ro, 1), inset(b, db, ri, 1)
    large = lambda x, y: 1 if abs(x - y) > 180 else 0
    (x1, y1), (x2, y2) = pt(ao, ro), pt(bo, ro)
    (x3, y3), (x4, y4) = pt(bi, ri), pt(ai, ri)
    return (
        f"M{x1:.1f},{y1:.1f} A{ro:.1f},{ro:.1f} 0 {large(ao, bo)} 0 {x2:.1f},{y2:.1f} "
        f"L{x3:.1f},{y3:.1f} A{ri:.1f},{ri:.1f} 0 {large(ai, bi)} 1 {x4:.1f},{y4:.1f} Z"
    )


def rounded(a, b, da, db, color):
    """A slice with RC-rounded corners: shrink by RC, then stroke back out."""
    d = sector(a, b, RI + RC, RO - RC, da + RC, db + RC)
    return (
        f'<path d="{d}" stroke-width="{2 * RC}" stroke-linejoin="round" '
        f'fill="{color}" stroke="{color}"/>'
    )


def icon(dark=False, background=True, scale=1.0, mono=None, art=True):
    """mono: paint every slice in this one color (Android themed icons)."""
    bg0, bg1 = ("#2E2A25", "#171512") if dark else ("#FFF8EF", "#F3E8D8")
    paint = (lambda c: mono) if mono else (lambda c: c)
    start, end = -OPEN, -(360 - OPEN)
    total = start - end
    joints = [start]
    for share, _ in SHARES:
        joints.append(joints[-1] - total * share)

    parts = [
        f'<svg xmlns="http://www.w3.org/2000/svg" width="{W}" height="{H}" viewBox="0 0 {W} {H}">',
        "  <defs>",
        '    <radialGradient id="bg" cx="0.3" cy="0.2" r="1">',
        f'      <stop offset="0" stop-color="{bg0}"/>',
        f'      <stop offset="1" stop-color="{bg1}"/>',
        "    </radialGradient>",
        '    <pattern id="hatch" width="46" height="46" patternUnits="userSpaceOnUse" patternTransform="rotate(45)">',
        f'      <rect width="46" height="46" fill="{paint(AMBER)}" fill-opacity="0.3"/>',
        f'      <rect width="22" height="46" fill="{paint(AMBER)}"/>',
        "    </pattern>",
    ]
    body = []
    for i, (share, color) in enumerate(SHARES):
        a, b = joints[i], joints[i + 1]
        # Slice ends at the mouth reach under the round caps.
        da = -RC if i == 0 else GAP / 2
        db = -RC if i == len(SHARES) - 1 else GAP / 2
        if color == AMBER:
            parts.append('    <mask id="amber">')
            parts.append("      " + rounded(a, b, da, db, "#fff"))
            parts.append("    </mask>")
            cut = b + total * EXCESS
            body.append('  <g mask="url(#amber)">')
            body.append(f'    <path d="{sector(a + 5, cut, RI - 4, RO + 4, 0, 0)}" fill="{paint(AMBER)}"/>')
            body.append(f'    <path d="{sector(cut, b - 5, RI - 4, RO + 4, 0, 0)}" fill="url(#hatch)"/>')
            body.append("  </g>")
        else:
            body.append("  " + rounded(a, b, da, db, paint(color)))
    for deg, color in ((start, SHARES[0][1]), (end, SHARES[-1][1])):
        x, y = pt(deg, R)
        body.append(f'  <circle cx="{x:.1f}" cy="{y:.1f}" r="{STROKE / 2}" fill="{paint(color)}"/>')

    parts.append("  </defs>")
    if background:
        parts.append(f'  <rect width="{W}" height="{H}" fill="url(#bg)"/>')
    if not art:
        pass
    elif scale != 1:
        parts.append(f'  <g transform="translate(512 512) scale({scale}) translate(-512 -512)">')
        parts += body
        parts.append("  </g>")
    else:
        parts += body
    parts.append("</svg>")
    return "\n".join(parts) + "\n"


if __name__ == "__main__":
    out = Path(__file__).resolve().parent.parent / "assets" / "icon"
    out.mkdir(parents=True, exist_ok=True)
    files = {
        "app_icon.svg": icon(),
        "app_icon_dark.svg": icon(dark=True),
        "app_icon_foreground.svg": icon(background=False),
        "adaptive_foreground.svg": icon(background=False, scale=ADAPTIVE_SCALE),
        "adaptive_background.svg": icon(art=False),
        "adaptive_monochrome.svg": icon(background=False, scale=ADAPTIVE_SCALE, mono="#000000"),
        "maskable.svg": icon(scale=ADAPTIVE_SCALE),
    }
    for name, svg in files.items():
        (out / name).write_text(svg)
