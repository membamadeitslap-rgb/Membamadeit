"""Spider-Man paper-puppet artwork as SVG (one image per paper piece, front + back), rendered to PNG.
python3 spiderman.py <outdir>   -> <outdir>/*.svg and *.png (PNG via headless Chromium / Playwright)
Each piece is drawn as a cut-out: white paper border, thick ink outline, cel-shaded fills, curved webbing.
"""
import math, os, sys, subprocess, json

OUT = sys.argv[1] if len(sys.argv) > 1 else "out"
os.makedirs(OUT, exist_ok=True)
RED, RED_D, RED_L = "#c8202e", "#8e1220", "#e2414c"
BLUE, BLUE_D, BLUE_L = "#2a4fb0", "#18306f", "#4a72d6"
INK, PAPER = "#15151a", "#fbfaf6"


def web(cx, cy, spokes, radii, reach, bend=0.06, a0=0.0, width=2.2, sag=0.86, squash=1.0):
    """Curved spider-web: slightly bowed spokes + sagging rings, as one SVG path string."""
    d = []
    ang = [a0 + i * 2 * math.pi / spokes for i in range(spokes)]
    for a in ang:
        ex, ey = cx + math.cos(a) * reach, cy + math.sin(a) * reach * squash
        mx, my = (cx + ex) / 2, (cy + ey) / 2
        nx, ny = -math.sin(a), math.cos(a)
        d.append(f"M{cx:.1f} {cy:.1f}Q{mx + nx * reach * bend:.1f} {my + ny * reach * bend:.1f} {ex:.1f} {ey:.1f}")
    for r in radii:
        for i, a in enumerate(ang):
            b = ang[(i + 1) % spokes] + (2 * math.pi if i == spokes - 1 else 0)
            m = (a + b) / 2
            p0 = (cx + math.cos(a) * r, cy + math.sin(a) * r * squash)
            p1 = (cx + math.cos(b) * r, cy + math.sin(b) * r * squash)
            c = (cx + math.cos(m) * r * sag, cy + math.sin(m) * r * sag * squash)
            d.append(f"M{p0[0]:.1f} {p0[1]:.1f}Q{c[0]:.1f} {c[1]:.1f} {p1[0]:.1f} {p1[1]:.1f}")
    return f'<path d="{"".join(d)}" fill="none" stroke="{INK}" stroke-width="{width}" stroke-linecap="round"/>'


def cutout(path, fill, ink=9, border=22, extra=""):
    """Paper cut-out: white border + ink outline drawn behind the fill."""
    return (f'<path d="{path}" fill="{PAPER}" stroke="{PAPER}" stroke-width="{border * 2 + ink}" stroke-linejoin="round"/>'
            f'<path d="{path}" fill="none" stroke="#c9c7c0" stroke-width="{border * 2 + ink + 3}" stroke-linejoin="round" opacity="0.5"/>'
            f'<path d="{path}" fill="{PAPER}" stroke="{PAPER}" stroke-width="{border * 2 + ink}" stroke-linejoin="round"/>'
            f'<path d="{path}" fill="{fill}" stroke="{INK}" stroke-width="{ink}" stroke-linejoin="round"/>{extra}')


def grad(id_, light, mid, dark, x1=0.15, y1=0.1, x2=0.95, y2=0.9):
    return (f'<linearGradient id="{id_}" x1="{x1}" y1="{y1}" x2="{x2}" y2="{y2}">'
            f'<stop offset="0" stop-color="{light}"/><stop offset="0.45" stop-color="{mid}"/><stop offset="1" stop-color="{dark}"/></linearGradient>')


def svg(w, h, body, defs=""):
    return (f'<svg xmlns="http://www.w3.org/2000/svg" width="{w}" height="{h}" viewBox="0 0 {w} {h}">'
            f'<defs>{grad("gRed", RED_L, RED, RED_D)}{grad("gBlue", BLUE_L, BLUE, BLUE_D)}{defs}</defs>{body}</svg>')


# ---------------- HEAD ----------------
HEAD = ("M200 34 C292 34 352 104 352 206 C352 296 318 372 276 426 C254 454 228 470 200 470 "
        "C172 470 146 454 124 426 C82 372 48 296 48 206 C48 104 108 34 200 34 Z")


def lens(side, k=0.78):
    # teardrop lens sweeping up and out from the bridge of the nose (k scales it around the lens center)
    s = 1 if side > 0 else -1
    def X(x): return 200 + s * (82 + (x - 82) * k)
    def Y(y): return 255 + (y - 255) * k
    path = (f"M{X(18)} {Y(300)} C{X(14)} {Y(262)} {X(40)} {Y(214)} {X(88)} {Y(192)} C{X(120)} {Y(178)} {X(150)} {Y(186)} {X(146)} {Y(214)} "
            f"C{X(140)} {Y(256)} {X(104)} {Y(300)} {X(62)} {Y(318)} C{X(40)} {Y(326)} {X(20)} {Y(318)} {X(18)} {Y(300)} Z")
    hi = (f"M{X(60)} {Y(236)} C{X(78)} {Y(214)} {X(104)} {Y(204)} {X(122)} {Y(206)}")
    return (f'<path d="{path}" fill="{INK}" stroke="{INK}" stroke-width="22" stroke-linejoin="round"/>'
            f'<path d="{path}" fill="url(#gLens)" stroke="{INK}" stroke-width="6" stroke-linejoin="round"/>'
            f'<path d="{hi}" fill="none" stroke="#ffffff" stroke-width="7" stroke-linecap="round" opacity="0.9"/>')


def head(front):
    defs = ('<clipPath id="hc"><path d="' + HEAD + '"/></clipPath>'
            '<radialGradient id="gHead" cx="0.35" cy="0.3" r="0.8"><stop offset="0" stop-color="#ec4a55"/>'
            f'<stop offset="0.55" stop-color="{RED}"/><stop offset="1" stop-color="{RED_D}"/></radialGradient>'
            '<linearGradient id="gLens" x1="0" y1="0" x2="1" y2="1"><stop offset="0" stop-color="#ffffff"/><stop offset="1" stop-color="#cfd8e6"/></linearGradient>')
    if front:
        w = web(200, 300, 16, [40, 78, 118, 160, 204, 250], 330, bend=0.05, a0=-math.pi / 2, width=2.4, squash=1.08)
        detail = "".join(lens(s) for s in (-1, 1))
    else:
        w = web(200, 150, 16, [36, 74, 114, 156, 200, 248, 296], 380, bend=0.05, a0=-math.pi / 2, width=2.4, squash=1.15)
        detail = ""
    body = cutout(HEAD, "url(#gHead)", ink=10, extra=f'<g clip-path="url(#hc)">{w}</g>{detail}'
                  f'<path d="{HEAD}" fill="none" stroke="{INK}" stroke-width="10" stroke-linejoin="round"/>')
    return svg(400, 504, body, defs)


# ---------------- TORSO (chest to belt) ----------------
TORSO = ("M60 40 C120 18 280 18 340 40 C368 50 372 80 366 120 C356 190 330 250 306 300 C296 330 296 360 300 392 "
         "C302 420 290 444 262 450 L138 450 C110 444 98 420 100 392 C104 360 104 330 94 300 C70 250 44 190 34 120 "
         "C28 80 32 50 60 40 Z")
CHEST = ("M66 46 C124 28 276 28 334 46 C350 56 350 88 340 118 C318 170 276 206 250 244 C236 266 232 290 232 312 "
         "L168 312 C168 290 164 266 150 244 C124 206 82 170 60 118 C50 88 50 56 66 46 Z")
BELT = "M108 360 C170 352 230 352 292 360 L296 430 C230 440 170 440 104 430 Z"


def narrow(path, k=0.8, cx=200):
    """Scale a path's x coordinates toward cx (keeps stroke widths even, unlike an SVG transform)."""
    import re
    toks = re.findall(r"[A-Za-z]|-?\d+\.?\d*", path)
    out, i, cmd = [], 0, None
    nums = []
    for t in toks:
        if t.isalpha():
            cmd = t; out.append(t); nums = []
        else:
            nums.append(float(t))
            if len(nums) % 2 == 1: out.append(f"{cx + (float(t) - cx) * k:.1f}")
            else: out.append(t)
    return " ".join(out)


TORSO, CHEST, BELT = narrow(TORSO), narrow(CHEST), narrow(BELT)


def spider(cx, cy, s):
    legs = [
        [(8, -30), (60, -70), (128, -96)], [(10, -18), (78, -34), (150, -30)],
        [(10, 8), (80, 30), (130, 92)], [(8, 24), (52, 84), (82, 160)],
    ]
    out = []
    for sx in (-1, 1):
        for L in legs:
            pts = [(cx + sx * x * s, cy + y * s) for x, y in L]
            out.append(f'<path d="M{pts[0][0]:.1f} {pts[0][1]:.1f}Q{pts[1][0]:.1f} {pts[1][1]:.1f} {pts[2][0]:.1f} {pts[2][1]:.1f}" '
                       f'fill="none" stroke="{INK}" stroke-width="{7 * s:.1f}" stroke-linecap="round"/>')
    out.append(f'<ellipse cx="{cx}" cy="{cy - 22 * s:.1f}" rx="{14 * s:.1f}" ry="{18 * s:.1f}" fill="{INK}"/>')
    out.append(f'<path d="M{cx} {cy - 8 * s:.1f} C{cx + 24 * s:.1f} {cy:.1f} {cx + 22 * s:.1f} {cy + 56 * s:.1f} {cx} {cy + 74 * s:.1f} '
               f'C{cx - 22 * s:.1f} {cy + 56 * s:.1f} {cx - 24 * s:.1f} {cy:.1f} {cx} {cy - 8 * s:.1f} Z" fill="{INK}"/>')
    return "".join(out)


def torso(front):
    defs = (f'<clipPath id="cc"><path d="{CHEST}"/></clipPath><clipPath id="bc"><path d="{BELT}"/></clipPath><clipPath id="tc"><path d="{TORSO}"/></clipPath>')
    cy = 118 if front else 130
    w = web(200, cy, 14, [34, 68, 104, 142, 182, 224], 300, bend=0.05, a0=-math.pi / 2, width=2.2, squash=1.0)
    belt_web = "".join(f'<path d="M{200 + (110 + i * 23 - 200) * 0.8:.1f} 352 L{200 + (108 + i * 23.5 - 200) * 0.8:.1f} 440" stroke="{INK}" stroke-width="2.2"/>' for i in range(9)) + \
        f'<path d="M100 396 C170 404 230 404 300 396" fill="none" stroke="{INK}" stroke-width="2.2"/>'
    shading = (f'<path d="{narrow("M300 60 C350 90 340 200 300 290 C290 330 290 380 296 430 L262 446 C270 380 272 320 286 270 C318 190 326 110 300 60 Z")}" fill="{BLUE_D}" opacity="0.55"/>'
               f'<path d="{narrow("M84 70 C64 110 74 170 96 220")}" fill="none" stroke="{BLUE_L}" stroke-width="8" stroke-linecap="round" opacity="0.7"/>')
    muscles = "" if not front else (
        f'<path d="M200 150 L200 300" stroke="{INK}" stroke-width="3" opacity="0.5"/>'
        f'<path d="M130 120 C160 150 180 156 200 150 C220 156 240 150 270 120" fill="none" stroke="{INK}" stroke-width="3" opacity="0.45"/>')
    body = cutout(TORSO, "url(#gBlue)", ink=10, extra=
                  shading +
                  f'<path d="{CHEST}" fill="url(#gRed)" stroke="{INK}" stroke-width="5"/>'
                  f'<g clip-path="url(#cc)">{w}<path d="{narrow("M290 60 C320 120 280 200 240 260 L232 312 L250 312 C262 240 330 150 300 60 Z")}" fill="{RED_D}" opacity="0.4"/></g>'
                  f'<path d="{BELT}" fill="url(#gRed)" stroke="{INK}" stroke-width="5"/><g clip-path="url(#bc)">{belt_web}</g>'
                  + muscles + '<g clip-path="url(#tc)">' + spider(200, 150 if front else 168, 0.85 if front else 1.25) + '</g>' +
                  f'<path d="{TORSO}" fill="none" stroke="{INK}" stroke-width="10" stroke-linejoin="round"/>')
    return svg(400, 480, body, defs)


# ---------------- ARM (shoulder to gloved fist) / LEG (hip to boot) ----------------
ARM = ("M44 60 C42 22 120 18 124 58 C130 110 128 160 120 210 C118 230 116 246 118 262 C126 320 120 400 110 462 "
       "C126 470 132 500 128 530 C126 556 104 570 80 570 C54 570 34 558 32 532 C30 504 38 474 52 462 "
       "C44 400 38 330 42 262 C44 246 42 230 40 210 C36 160 38 110 44 60 Z")


def grid_lines(x0, x1, y0, y1, cols, rows, curve=8):
    d = []
    for i in range(1, cols):
        x = x0 + (x1 - x0) * i / cols
        d.append(f"M{x:.1f} {y0}C{x + 4:.1f} {(y0 * 2 + y1) / 3:.1f} {x - 4:.1f} {(y0 + y1 * 2) / 3:.1f} {x:.1f} {y1}")
    for j in range(1, rows):
        y = y0 + (y1 - y0) * j / rows
        d.append(f"M{x0} {y:.1f}Q{(x0 + x1) / 2:.1f} {y + curve:.1f} {x1} {y:.1f}")
    return f'<path d="{"".join(d)}" fill="none" stroke="{INK}" stroke-width="2.2"/>'


def arm():
    defs = (f'<clipPath id="ac"><path d="{ARM}"/></clipPath>')
    red_low = f'<rect x="0" y="256" width="160" height="330" fill="url(#gRed)"/>'
    cap = f'<path d="M0 0 H160 V96 C120 108 40 108 0 96 Z" fill="url(#gRed)"/>'
    body = cutout(ARM, "url(#gBlue)", ink=8, extra=
                  f'<g clip-path="url(#ac)">'
                  f'<path d="M100 60 C122 110 122 170 112 214 L96 214 C106 170 108 110 100 60 Z" fill="{BLUE_D}" opacity="0.5"/>'
                  f'{cap}<path d="M0 96 C40 108 120 108 160 96" fill="none" stroke="{INK}" stroke-width="5"/>'
                  f'{red_low}<path d="M0 256 C40 266 120 266 160 256" fill="none" stroke="{INK}" stroke-width="5"/>'
                  f'{grid_lines(30, 134, 260, 470, 4, 8, 6)}{grid_lines(30, 134, 10, 100, 4, 3, 6)}'
                  f'<path d="M98 270 C112 330 108 400 100 462 L116 462 C124 400 126 330 116 270 Z" fill="{RED_D}" opacity="0.45"/>'
                  f'<path d="M96 476 C112 490 116 520 108 552 L124 540 C132 510 126 486 110 470 Z" fill="{RED_D}" opacity="0.5"/>'
                  f'</g>'
                  # gloved fist: knuckle ridge, finger creases, thumb wrapped over the front
                  f'<path d="M40 500 C60 490 104 490 124 500" fill="none" stroke="{INK}" stroke-width="4" stroke-linecap="round"/>'
                  f'<path d="M62 498 L60 540 M82 496 L82 544 M102 498 L104 538" fill="none" stroke="{INK}" stroke-width="2.6" stroke-linecap="round" opacity="0.8"/>'
                  f'<path d="M40 520 C56 512 78 516 86 530 C82 546 60 552 42 546" fill="#d72b38" stroke="{INK}" stroke-width="4" stroke-linejoin="round"/>'
                  f'<path d="M36 466 C64 474 100 474 124 466" fill="none" stroke="{INK}" stroke-width="4"/>'
                  f'<path d="{ARM}" fill="none" stroke="{INK}" stroke-width="8" stroke-linejoin="round"/>')
    return svg(160, 600, body, defs)


LEG = ("M26 30 C24 8 158 8 156 30 C160 120 150 210 140 290 C138 304 138 316 142 330 C156 390 148 450 132 520 "
       "C140 540 154 560 156 584 C158 600 150 608 138 608 L42 608 C30 608 22 600 24 584 C26 560 40 540 48 520 "
       "C32 450 26 390 40 330 C44 316 44 304 40 290 C30 210 22 120 26 30 Z")


def leg():
    defs = f'<clipPath id="lc"><path d="{LEG}"/></clipPath>'
    body = cutout(LEG, "url(#gBlue)", ink=8, extra=
                  f'<g clip-path="url(#lc)">'
                  f'<path d="M118 30 C146 100 146 200 134 290 L112 292 C124 200 126 100 118 30 Z" fill="{BLUE_D}" opacity="0.5"/>'
                  f'<rect x="0" y="300" width="180" height="320" fill="url(#gRed)"/>'
                  f'<path d="M0 300 C50 312 130 312 180 300" fill="none" stroke="{INK}" stroke-width="5"/>'
                  f'{grid_lines(26, 156, 304, 560, 4, 9, 7)}'
                  f'<path d="M112 330 C134 400 128 470 116 520 L132 520 C148 460 152 400 134 330 Z" fill="{RED_D}" opacity="0.45"/>'
                  f'<path d="M20 586 L160 586 L160 620 L20 620 Z" fill="{BLUE}"/><path d="M20 586 L160 586" stroke="{INK}" stroke-width="4"/>'
                  f'</g>'
                  # boot: ankle crease and a rounded toe cap
                  f'<path d="M48 520 C76 530 106 530 132 520" fill="none" stroke="{INK}" stroke-width="4"/>'
                  f'<path d="M44 562 C70 548 112 548 138 562" fill="none" stroke="{INK}" stroke-width="3.5"/>'
                  f'<path d="{LEG}" fill="none" stroke="{INK}" stroke-width="8" stroke-linejoin="round"/>')
    return svg(180, 630, body, defs)


files = {"Head_Front": head(True), "Head_Back": head(False), "Torso_Front": torso(True), "Torso_Back": torso(False), "Arm": arm(), "Leg": leg()}
for k, v in files.items():
    open(os.path.join(OUT, k + ".svg"), "w").write(v)

# rasterize with headless Chromium (Playwright), transparent background, 2x for crisp edges
js = """
const { chromium } = require('playwright'); const fs = require('fs'); const path = require('path');
(async () => { const b = await chromium.launch(); const p = await b.newPage({ deviceScaleFactor: 2 });
for (const f of JSON.parse(process.argv[2])) {
  const svg = fs.readFileSync(f, 'utf8'); const m = svg.match(/width="(\\d+)" height="(\\d+)"/);
  await p.setViewportSize({ width: +m[1], height: +m[2] });
  await p.setContent(`<html><body style="margin:0;background:transparent">${svg}</body></html>`);
  await p.screenshot({ path: f.replace(/\\.svg$/, '.png'), omitBackground: true, clip: { x: 0, y: 0, width: +m[1], height: +m[2] } });
} await b.close(); })();
"""
open(os.path.join(OUT, "_r.js"), "w").write(js)
subprocess.run(["node", os.path.join(OUT, "_r.js"), json.dumps([os.path.abspath(os.path.join(OUT, k + ".svg")) for k in files])], check=True)
os.remove(os.path.join(OUT, "_r.js"))
print("ok", list(files))
