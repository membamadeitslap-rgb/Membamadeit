"""Iron Man paper-puppet artwork (classic red/gold armor). python3 ironman.py <outdir>"""
import sys, os
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from kit import *

OUT = sys.argv[1]
RED, RED_D, RED_L = "#b81d26", "#7c0f17", "#e0404a"
GOLD, GOLD_D, GOLD_L = "#e2b33c", "#a77a1c", "#ffe08a"
GLOW = "#dff7ff"
DEFS = (grad("gR", RED_L, RED, RED_D) + grad("gG", GOLD_L, GOLD, GOLD_D) +
        '<radialGradient id="gArc" cx="0.5" cy="0.5" r="0.5"><stop offset="0" stop-color="#ffffff"/><stop offset="0.45" stop-color="#bff3ff"/>'
        '<stop offset="0.8" stop-color="#3fc4ff"/><stop offset="1" stop-color="#1a6fb5"/></radialGradient>'
        '<filter id="glow" x="-50%" y="-50%" width="200%" height="200%"><feGaussianBlur stdDeviation="7"/></filter>')
SEAM = f'stroke="{INK}" stroke-width="3" fill="none" stroke-linecap="round"'

HELM = ("M200 34 C290 34 344 96 344 190 C344 260 330 320 312 372 L286 430 C268 458 236 470 200 470 "
        "C164 470 132 458 114 430 L88 372 C70 320 56 260 56 190 C56 96 110 34 200 34 Z")
FACE = ("M126 150 C150 132 250 132 274 150 L282 250 C284 300 272 350 254 392 L238 430 C226 446 174 446 162 430 "
        "L146 392 C128 350 116 300 118 250 Z")


def head(front):
    b = cutout(HELM, "url(#gR)", ink=10)
    if front:
        b += f'<path d="{FACE}" fill="url(#gG)" stroke="{INK}" stroke-width="6"/>'
        b += f'<path d="M150 170 C180 160 220 160 250 170" {SEAM}/><path d="M200 172 L200 236" {SEAM}/>'  # brow ridge + center seam
        for s in (-1, 1):  # angular glowing eye slits
            pts = [(22, 242), (94, 226), (96, 252), (26, 264)]
            d = "M" + " L".join(f"{200 + s * x} {y}" for x, y in pts) + " Z"
            b += f'<path d="{d}" fill="#4fd2ff" filter="url(#glow)" opacity="0.9"/><path d="{d}" fill="{GLOW}" stroke="{INK}" stroke-width="4"/>'
            b += f'<path d="M{200 + s * 92} 300 C{200 + s * 84} 340 {200 + s * 70} 372 {200 + s * 54} 396" {SEAM}/>'  # cheek seams
            b += f'<circle cx="{200 + s * 138}" cy="246" r="22" fill="url(#gG)" stroke="{INK}" stroke-width="4"/>'  # ear discs
        b += f'<path d="M168 384 L232 384" stroke="{INK}" stroke-width="5" stroke-linecap="round"/>'  # mouth slit
    else:
        b += f'<path d="M200 40 L200 300" {SEAM}/><path d="M90 230 C140 250 260 250 310 230" {SEAM}/><path d="M110 360 C160 380 240 380 290 360" {SEAM}/>'
        for s in (-1, 1): b += f'<circle cx="{200 + s * 138}" cy="246" r="22" fill="url(#gG)" stroke="{INK}" stroke-width="4"/>'
    b += outline(HELM, 10)
    return svg(400, 504, b, DEFS)


def torso(front):
    T = scale_x(TORSO, 0.84, 200)
    b = cutout(T, "url(#gR)", ink=10)
    b += f'<clipPath id="tc"><path d="{T}"/></clipPath><g clip-path="url(#tc)">'
    if front:
        # gold ab plating + belt, chest plate seams, arc reactor
        b += f'<path d="M150 230 C170 222 230 222 250 230 L262 372 L138 372 Z" fill="url(#gG)" stroke="{INK}" stroke-width="5"/>'
        for y in (266, 300, 336): b += f'<path d="M150 {y} L250 {y}" {SEAM}/>'
        b += f'<path d="M200 230 L200 372" {SEAM}/>'
        b += f'<path d="M86 96 C130 130 170 132 200 122 C230 132 270 130 314 96" {SEAM}/><path d="M100 160 C140 196 170 204 200 200 C230 204 260 196 300 160" {SEAM}/>'
        b += f'<path d="M110 380 L290 380 L294 446 L106 446 Z" fill="url(#gR)" stroke="{INK}" stroke-width="5"/><path d="M180 384 L220 384 L226 440 L174 440 Z" fill="url(#gG)" stroke="{INK}" stroke-width="4"/>'
    else:
        b += f'<path d="M200 40 L200 440" {SEAM}/><path d="M90 120 C150 150 250 150 310 120" {SEAM}/><path d="M120 250 C170 270 230 270 280 250" {SEAM}/>'
        for s in (-1, 1): b += f'<ellipse cx="{200 + s * 50}" cy="196" rx="22" ry="34" fill="#3a3d44" stroke="{INK}" stroke-width="4"/><ellipse cx="{200 + s * 50}" cy="196" rx="11" ry="20" fill="#7fe1ff" opacity="0.8"/>'
        b += f'<path d="M110 380 L290 380 L294 446 L106 446 Z" fill="url(#gR)" stroke="{INK}" stroke-width="5"/>'
    b += '</g>'
    if front:
        b += '<circle cx="200" cy="152" r="52" fill="#4fd2ff" filter="url(#glow)" opacity="0.9"/>'
        b += f'<circle cx="200" cy="152" r="38" fill="#9aa3ad" stroke="{INK}" stroke-width="6"/><circle cx="200" cy="152" r="27" fill="url(#gArc)" stroke="{INK}" stroke-width="3"/>'
    b += outline(T, 10)
    return svg(400, 480, b, DEFS)


def arm():
    A = scale_x(ARM, 1.1, 82)
    b = cutout(A, "url(#gR)", ink=8) + f'<clipPath id="ac"><path d="{A}"/></clipPath><g clip-path="url(#ac)">'
    b += f'<path d="M0 96 C40 108 124 108 170 96" {SEAM}/><path d="M0 150 L170 150" {SEAM}/>'
    b += f'<rect x="0" y="236" width="170" height="40" fill="url(#gG)"/><path d="M0 236 L170 236 M0 276 L170 276" stroke="{INK}" stroke-width="4"/>'  # gold elbow
    b += f'<rect x="0" y="300" width="170" height="160" fill="url(#gG)"/><path d="M0 300 L170 300" stroke="{INK}" stroke-width="4"/>'  # gold forearm
    b += f'<path d="M30 340 L130 340 M30 390 L130 390" {SEAM}/><path d="M0 460 L170 460" stroke="{INK}" stroke-width="5"/>'
    b += f'<path d="M40 500 C60 490 104 490 124 500" stroke="{INK}" stroke-width="4" fill="none"/>'
    for x in (58, 82, 106): b += f'<rect x="{x - 8}" y="494" width="16" height="12" rx="3" fill="url(#gG)" stroke="{INK}" stroke-width="2.5"/>'  # gold knuckles
    b += '</g>' + outline(A, 8)
    return svg(180, 600, b, DEFS)


def leg():
    b = cutout(LEG, "url(#gR)", ink=8) + f'<clipPath id="lc"><path d="{LEG}"/></clipPath><g clip-path="url(#lc)">'
    b += f'<path d="M24 60 L56 60 L60 270 L30 270 Z" fill="url(#gG)" stroke="{INK}" stroke-width="4"/>'  # gold thigh side panel
    b += f'<path d="M150 120 C110 140 80 140 40 120" {SEAM}/>'
    b += f'<path d="M50 286 C70 270 110 270 130 286 L136 340 C110 352 70 352 44 340 Z" fill="url(#gG)" stroke="{INK}" stroke-width="5"/>'  # knee
    b += f'<path d="M60 380 L120 380 L114 500 L66 500 Z" fill="url(#gG)" stroke="{INK}" stroke-width="4"/>'  # shin plate
    b += f'<path d="M0 520 L180 520" stroke="{INK}" stroke-width="5"/><path d="M30 560 C70 548 110 548 150 560" {SEAM}/>'
    b += f'<rect x="0" y="590" width="180" height="40" fill="#3a3d44"/><path d="M0 590 L180 590" stroke="{INK}" stroke-width="4"/>'
    b += '</g>' + outline(LEG, 8)
    return svg(180, 630, b, DEFS)


render(OUT, {"Head_Front": head(True), "Head_Back": head(False), "Torso_Front": torso(True), "Torso_Back": torso(False), "Arm": arm(), "Leg": leg()})
assemble(OUT, os.path.join(OUT, "preview.png"))
print("ok")
