"""Robin paper-puppet artwork (Teen Titans look: red tunic + R emblem, green sleeves/gloves/pants, black boots,
yellow belt, domino mask, spiky black hair, black cape with yellow lining). python3 robin.py <outdir>"""
import sys, os
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from kit import *

OUT = sys.argv[1]
RED, RED_D, RED_L = "#c8262b", "#8a1418", "#e8484c"
GRN, GRN_D, GRN_L = "#3b9a3e", "#1f6424", "#62c065"
YEL, YEL_D = "#f5c838", "#c4931a"
BLK, BLK_L = "#1d1e24", "#3a3c46"
SKIN, SKIN_D = "#f1c8a0", "#cf9a70"
DEFS = (grad("gR", RED_L, RED, RED_D) + grad("gGn", GRN_L, GRN, GRN_D) + grad("gY", "#ffe27a", YEL, YEL_D) +
        grad("gB", BLK_L, BLK, "#0c0c10") + grad("gSk", "#fad9b8", SKIN, SKIN_D))
SEAM = f'stroke="{INK}" stroke-width="3" fill="none" stroke-linecap="round"'

FACE = ("M200 70 C282 70 330 130 330 214 C330 300 300 370 262 420 C242 446 222 460 200 460 C178 460 158 446 138 420 "
        "C100 370 70 300 70 214 C70 130 118 70 200 70 Z")
HAIR = ("M64 220 C50 160 70 96 120 60 L104 20 L156 44 L170 6 L206 40 L238 4 L250 46 L300 22 L286 66 C330 96 352 160 338 222 "
        "C320 170 300 140 270 128 C230 150 170 150 128 128 C98 140 80 170 64 220 Z")


def head(front):
    b = cutout(FACE, "url(#gSk)", ink=10)
    if front:
        # domino mask with white eye lenses
        b += f'<path d="M86 214 C110 186 170 190 200 210 C230 190 290 186 314 214 C306 250 280 268 248 262 C228 258 214 248 200 240 C186 248 172 258 152 262 C120 268 94 250 86 214 Z" fill="{BLK}" stroke="{INK}" stroke-width="6" stroke-linejoin="round"/>'
        for s in (-1, 1):
            b += f'<path d="M{200 + s * 34} 228 C{200 + s * 60} 212 {200 + s * 92} 212 {200 + s * 100} 226 C{200 + s * 92} 244 {200 + s * 56} 246 {200 + s * 34} 228 Z" fill="#ffffff" stroke="{INK}" stroke-width="4"/>'
        b += f'<path d="M190 300 C196 320 204 320 210 300" {SEAM}/>'  # nose
        b += f'<path d="M160 360 C180 384 220 384 240 360" stroke="{INK}" stroke-width="6" fill="none" stroke-linecap="round"/>'  # confident grin
        for s in (-1, 1): b += f'<ellipse cx="{200 + s * 120}" cy="250" rx="14" ry="26" fill="url(#gSk)" stroke="{INK}" stroke-width="4"/>'  # ears
        b += f'<path d="{HAIR}" fill="url(#gB)" stroke="{INK}" stroke-width="7" stroke-linejoin="round"/>'
    else:
        b += f'<path d="M66 260 C40 160 80 70 150 46 L136 6 L190 30 L210 0 L232 34 L276 8 L268 50 C330 80 360 170 334 260 C320 330 270 380 200 384 C130 380 80 330 66 260 Z" fill="url(#gB)" stroke="{INK}" stroke-width="7" stroke-linejoin="round"/>'
        b += f'<path d="M86 214 L120 220 M314 214 L280 220" stroke="{BLK}" stroke-width="12"/>'  # mask strap
    b += outline(FACE, 10) if front else ""
    return svg(400, 504, b, DEFS)


def torso(front):
    T = scale_x(TORSO, 0.82, 200)
    b = cutout(T, "url(#gR)", ink=10) + f'<clipPath id="tc"><path d="{T}"/></clipPath><g clip-path="url(#tc)">'
    b += f'<path d="M100 400 L300 400 L300 480 L100 480 Z" fill="url(#gGn)"/>'  # green pants top
    b += f'<path d="M104 368 L296 368 L298 404 L102 404 Z" fill="url(#gY)" stroke="{INK}" stroke-width="5"/>'  # belt
    for x in range(124, 286, 32): b += f'<rect x="{x}" y="372" width="20" height="28" rx="4" fill="url(#gY)" stroke="{INK}" stroke-width="3"/>'
    b += f'<path d="M290 70 C326 110 318 220 292 300 L272 300 C296 220 304 120 290 70 Z" fill="{RED_D}" opacity="0.4"/>'
    if front:
        b += f'<path d="M200 60 L200 368" {SEAM}/>'  # tunic opening
        for y in (120, 170, 220, 270, 320): b += f'<path d="M188 {y} L212 {y}" stroke="{YEL_D}" stroke-width="5" stroke-linecap="round"/>'  # yellow clasps
    b += '</g>'
    if front:  # R emblem on the left chest (viewer's right)
        b += f'<circle cx="262" cy="128" r="36" fill="url(#gY)" stroke="{INK}" stroke-width="6"/><circle cx="262" cy="128" r="26" fill="{BLK}"/>'
        b += f'<text x="262" y="146" text-anchor="middle" font-family="Arial Black, Arial" font-weight="900" font-size="48" fill="{YEL}">R</text>'
    b += outline(T, 10)
    return svg(400, 480, b, DEFS)


def arm():
    A = scale_x(ARM, 1.0, 82)
    b = cutout(A, "url(#gGn)", ink=8) + f'<clipPath id="ac"><path d="{A}"/></clipPath><g clip-path="url(#ac)">'
    b += f'<path d="M0 0 H170 V110 C120 124 40 124 0 110 Z" fill="url(#gR)"/><path d="M0 110 C40 124 120 124 170 110" stroke="{INK}" stroke-width="5" fill="none"/>'  # red short sleeve
    b += f'<path d="M100 120 C122 170 122 210 112 240 L96 240 C106 210 108 170 100 120 Z" fill="{GRN_D}" opacity="0.5"/>'
    b += f'<path d="M0 360 C40 350 100 350 170 360 L170 600 L0 600 Z" fill="{GRN_D}"/><path d="M0 360 C40 350 100 350 170 360" stroke="{INK}" stroke-width="5" fill="none"/>'  # darker gloves
    b += f'<path d="M40 500 C60 490 104 490 124 500" stroke="{INK}" stroke-width="4" fill="none"/></g>' + outline(A, 8)
    return svg(180, 600, b, DEFS)


def leg():
    b = cutout(LEG, "url(#gGn)", ink=8) + f'<clipPath id="lc"><path d="{LEG}"/></clipPath><g clip-path="url(#lc)">'
    b += f'<path d="M118 30 C146 100 146 200 134 290 L112 292 C124 200 126 100 118 30 Z" fill="{GRN_D}" opacity="0.5"/>'
    b += f'<path d="M0 420 C40 408 140 408 180 420 L180 630 L0 630 Z" fill="url(#gB)"/><path d="M0 420 C40 408 140 408 180 420" stroke="{INK}" stroke-width="5" fill="none"/>'
    b += f'<path d="M30 560 C70 548 110 548 150 560 L156 600 L24 600 Z" fill="#8f949e" stroke="{INK}" stroke-width="4"/></g>'  # steel toe
    b += outline(LEG, 8)
    return svg(180, 630, b, DEFS)


CAPE = ("M90 20 C140 6 260 6 310 20 C340 120 360 320 372 520 L382 640 L18 640 L28 520 C40 320 60 120 90 20 Z")


def cape():
    b = '<g transform="translate(40 0)">' + cutout(CAPE, "url(#gB)", ink=9)
    b += f'<path d="M28 520 L18 640 L60 640 C52 560 52 420 70 200 Z" fill="url(#gY)" stroke="{INK}" stroke-width="5"/>'  # yellow lining flicks
    b += f'<path d="M372 520 L382 640 L340 640 C348 560 348 420 330 200 Z" fill="url(#gY)" stroke="{INK}" stroke-width="5"/></g>'
    return svg(480, 680, b, DEFS)


render(OUT, {"Head_Front": head(True), "Head_Back": head(False), "Torso_Front": torso(True), "Torso_Back": torso(False), "Arm": arm(), "Leg": leg(), "Cape": cape()})
assemble(OUT, os.path.join(OUT, "preview.png"))
print("ok")
