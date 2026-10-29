"""Batman paper-puppet artwork (classic comic suit: grey + dark blue-black, yellow oval bat, cape). python3 batman.py <outdir>"""
import sys, os
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from kit import *

OUT = sys.argv[1]
GREY, GREY_D, GREY_L = "#8d929c", "#5c616b", "#b4b9c2"
DARK, DARK_D, DARK_L = "#2a3146", "#151a28", "#46506c"
YEL, YEL_D = "#f3c63a", "#c4931a"
SKIN, SKIN_D = "#efc39b", "#c9946c"
DEFS = grad("gGr", GREY_L, GREY, GREY_D) + grad("gDk", DARK_L, DARK, DARK_D) + grad("gSk", "#f8d6b4", SKIN, SKIN_D) + grad("gY", "#ffe27a", YEL, YEL_D)
SEAM = f'stroke="{INK}" stroke-width="3" fill="none" stroke-linecap="round"'

COWL = ("M200 40 C286 40 340 100 342 190 C344 250 336 300 326 344 C306 330 282 306 262 300 L138 300 C118 306 94 330 74 344 "
        "C64 300 56 250 58 190 C60 100 114 40 200 40 Z")  # face opening rises to the nose, cowl comes down over the cheeks
EARS = "M92 120 L104 6 L150 66 Z M308 120 L296 6 L250 66 Z"
JAW = ("M78 300 C90 360 120 420 156 452 C176 468 224 468 244 452 C280 420 310 360 322 300 Z")


def bat(cx, cy, s, fill):
    """Classic bat symbol: wings with scalloped bottom edge, small pointed ears."""
    def P(x, y): return f"{cx + x * s:.1f} {cy + y * s:.1f}"
    d = (f"M{P(-104, -4)} C{P(-80, -20)} {P(-50, -26)} {P(-28, -20)} L{P(-18, -38)} L{P(-10, -18)} L{P(10, -18)} L{P(18, -38)} L{P(28, -20)} "
         f"C{P(50, -26)} {P(80, -20)} {P(104, -4)} C{P(86, 2)} {P(74, 12)} {P(70, 26)} C{P(60, 12)} {P(46, 10)} {P(34, 24)} "
         f"C{P(26, 12)} {P(12, 12)} {P(0, 34)} C{P(-12, 12)} {P(-26, 12)} {P(-34, 24)} C{P(-46, 10)} {P(-60, 12)} {P(-70, 26)} "
         f"C{P(-74, 12)} {P(-86, 2)} {P(-104, -4)} Z")  # classic bat: smooth wing tops, pointed ears, scalloped bottom
    return f'<path d="{d}" fill="{fill}" stroke-linejoin="round"/>'


def head(front):
    b = (f'<path d="{EARS}" fill="url(#gDk)" stroke="{PAPER}" stroke-width="53" stroke-linejoin="round"/>'
         + cutout(JAW if front else JAW, "url(#gSk)" if front else "url(#gDk)", ink=10)
         + cutout(COWL, "url(#gDk)", ink=10)
         + f'<path d="{EARS}" fill="url(#gDk)" stroke="{INK}" stroke-width="9" stroke-linejoin="round"/>')
    if front:
        for s in (-1, 1):  # narrow white angry eyes, scowling brow line
            d = f"M{200 + s * 28} 232 L{200 + s * 104} 214 L{200 + s * 96} 246 L{200 + s * 34} 252 Z"
            b += f'<path d="{d}" fill="#ffffff" stroke="{INK}" stroke-width="6" stroke-linejoin="round"/>'
        b += f'<path d="M150 188 L200 210 L250 188" {SEAM}/>'
        b += f'<path d="M168 400 C186 392 214 392 232 400" stroke="{INK}" stroke-width="6" fill="none" stroke-linecap="round"/>'  # stern mouth
        b += f'<path d="M196 430 L204 430" {SEAM}/><path d="M150 360 C160 380 170 390 180 396" stroke="{SKIN_D}" stroke-width="4" fill="none"/>'
    return svg(400, 504, b, DEFS)


def torso(front):
    T = scale_x(TORSO, 0.95, 200)
    b = cutout(T, "url(#gGr)", ink=10) + f'<clipPath id="tc"><path d="{T}"/></clipPath><g clip-path="url(#tc)">'
    b += f'<path d="M290 70 C330 110 320 220 290 300 L270 300 C296 220 304 120 290 70 Z" fill="{GREY_D}" opacity="0.4"/>'
    b += f'<path d="M100 410 L300 410 L300 470 L100 470 Z" fill="url(#gDk)"/>'  # trunks
    b += f'<path d="M104 372 L296 372 L298 412 L102 412 Z" fill="url(#gY)" stroke="{INK}" stroke-width="5"/>'  # utility belt
    for x in range(118, 290, 28): b += f'<rect x="{x}" y="378" width="18" height="28" rx="5" fill="url(#gY)" stroke="{INK}" stroke-width="3"/>'
    b += '</g>'
    if front:
        b += f'<ellipse cx="200" cy="160" rx="92" ry="52" fill="url(#gY)" stroke="{INK}" stroke-width="6"/>' + bat(200, 162, 0.82, INK)
        b += f'<path d="M150 236 C170 250 230 250 250 236" {SEAM}/><path d="M200 220 L200 350" {SEAM}/>'
    else:
        b += bat(200, 160, 1.4, INK)
    b += outline(T, 10)
    return svg(400, 480, b, DEFS)


def arm():
    A = scale_x(ARM, 1.08, 82)
    b = cutout(A, "url(#gGr)", ink=8) + f'<clipPath id="ac"><path d="{A}"/></clipPath><g clip-path="url(#ac)">'
    b += f'<path d="M100 60 C122 110 122 170 112 214 L96 214 C106 170 108 110 100 60 Z" fill="{GREY_D}" opacity="0.45"/>'
    b += f'<path d="M0 330 C40 320 100 320 170 330 L170 600 L0 600 Z" fill="url(#gDk)"/><path d="M0 330 C40 320 100 320 170 330" stroke="{INK}" stroke-width="5" fill="none"/>'
    b += f'<path d="M40 500 C60 490 104 490 124 500" stroke="#7d86a3" stroke-width="4" fill="none"/></g>'
    for i in range(3):  # gauntlet fins on the outer edge
        y = 350 + i * 34
        b += f'<path d="M{34 - i} {y} L6 {y + 18} L{36 - i} {y + 26} Z" fill="url(#gDk)" stroke="{INK}" stroke-width="4" stroke-linejoin="round"/>'
    b += outline(A, 8)
    return svg(180, 600, b, DEFS)


def leg():
    b = cutout(LEG, "url(#gGr)", ink=8) + f'<clipPath id="lc"><path d="{LEG}"/></clipPath><g clip-path="url(#lc)">'
    b += f'<path d="M0 0 L180 0 L180 60 C120 80 60 80 0 60 Z" fill="url(#gDk)"/>'  # trunks
    b += f'<path d="M118 60 C146 120 146 200 134 290 L112 292 C124 200 126 120 118 60 Z" fill="{GREY_D}" opacity="0.45"/>'
    b += f'<path d="M0 400 C40 386 140 386 180 400 L180 630 L0 630 Z" fill="url(#gDk)"/><path d="M0 400 C40 386 140 386 180 400" stroke="{INK}" stroke-width="5" fill="none"/>'
    b += f'<path d="M30 420 C60 432 120 432 150 420" stroke="#7d86a3" stroke-width="3" fill="none"/></g>' + outline(LEG, 8)
    return svg(180, 630, b, DEFS)


CAPE = ("M70 20 C120 6 280 6 330 20 C370 120 400 320 420 560 L440 760 C410 740 380 780 350 760 C320 740 290 780 260 760 "
        "C230 740 200 780 170 760 C140 740 110 780 80 760 C50 740 20 780 -20 760 L0 560 C20 320 30 120 70 20 Z")


def cape():
    C2 = scale_x(CAPE, 1.0, 200).replace("-20", "-20")
    b = f'<g transform="translate(40 0)">' + cutout(C2, "url(#gDk)", ink=9) + \
        f'<path d="M200 30 L200 740 M120 40 C100 300 80 520 60 740 M280 40 C300 300 320 520 340 740" stroke="{DARK_D}" stroke-width="10" opacity="0.5" fill="none"/></g>'
    return svg(520, 820, b, DEFS)


render(OUT, {"Head_Front": head(True), "Head_Back": head(False), "Torso_Front": torso(True), "Torso_Back": torso(False), "Arm": arm(), "Leg": leg(), "Cape": cape()})
assemble(OUT, os.path.join(OUT, "preview.png"))
print("ok")
