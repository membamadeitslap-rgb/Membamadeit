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


def lens(side):
    # teardrop lens sweeping up and out from the bridge of the nose
    s = 1 if side > 0 else -1
    def X(x): return 200 + s * x
    path = (f"M{X(18)} 300 C{X(14)} 262 {X(40)} 214 {X(88)} 192 C{X(120)} 178 {X(150)} 186 {X(146)} 214 "
            f"C{X(140)} 256 {X(104)} 300 {X(62)} 318 C{X(40)} 326 {X(20)} 318 {X(18)} 300 Z")
    hi = (f"M{X(60)} 236 C{X(78)} 214 {X(104)} 204 {X(122)} 206")
    return (f'<path d="{path}" fill="{INK}" stroke="{INK}" stroke-width="30" stroke-linejoin="round"/>'
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
    defs = (f'<clipPath id="cc"><path d="{CHEST}"/></clipPath><clipPath id="bc"><path d="{BELT}"/></clipPath>')
    cy = 118 if front else 130
    w = web(200, cy, 14, [34, 68, 104, 142, 182, 224], 300, bend=0.05, a0=-math.pi / 2, width=2.2, squash=1.0)
    belt_web = "".join(f'<path d="M{110 + i * 23} 352 L{108 + i * 23.5} 440" stroke="{INK}" stroke-width="2.2"/>' for i in range(9)) + \
        f'<path d="M100 396 C170 404 230 404 300 396" fill="none" stroke="{INK}" stroke-width="2.2"/>'
    shading = (f'<path d="M300 60 C350 90 340 200 300 290 C290 330 290 380 296 430 L262 446 C270 380 272 320 286 270 C318 190 326 110 300 60 Z" fill="{BLUE_D}" opacity="0.55"/>'
               f'<path d="M84 70 C64 110 74 170 96 220" fill="none" stroke="{BLUE_L}" stroke-width="8" stroke-linecap="round" opacity="0.7"/>')
    muscles = "" if not front else (
        f'<path d="M200 150 L200 300" stroke="{INK}" stroke-width="3" opacity="0.5"/>'
        f'<path d="M130 120 C160 150 180 156 200 150 C220 156 240 150 270 120" fill="none" stroke="{INK}" stroke-width="3" opacity="0.45"/>')
    body = cutout(TORSO, "url(#gBlue)", ink=10, extra=
                  shading +
                  f'<path d="{CHEST}" fill="url(#gRed)" stroke="{INK}" stroke-width="5"/>'
                  f'<g clip-path="url(#cc)">{w}<path d="M290 60 C320 120 280 200 240 260 L232 312 L250 312 C262 240 330 150 300 60 Z" fill="{RED_D}" opacity="0.4"/></g>'
                  f'<path d="{BELT}" fill="url(#gRed)" stroke="{INK}" stroke-width="5"/><g clip-path="url(#bc)">{belt_web}</g>'
                  + muscles + spider(200, 150 if front else 168, 0.85 if front else 1.25) +
                  f'<path d="{TORSO}" fill="none" stroke="{INK}" stroke-width="10" stroke-linejoin="round"/>')
    return svg(400, 480, body, defs)


# ---------------- ARM (shoulder to fist) / LEG (hip to boot) ----------------
ARM = ("M40 40 C40 14 140 14 140 40 L138 200 C144 230 140 260 132 300 L124 400 C150 410 156 470 128 486 "
       "C100 500 50 500 30 482 C8 460 22 412 48 400 L42 300 C34 260 30 230 40 200 Z")
FORE = "M40 196 C60 186 120 186 138 196 C144 230 140 260 132 300 L124 400 C110 406 64 406 48 400 L42 300 C34 260 30 230 40 196 Z"
FIST = "M48 400 C64 392 112 392 124 400 C150 410 156 470 128 486 C100 500 50 500 30 482 C8 460 22 412 48 400 Z"
CAP = "M40 40 C40 14 140 14 140 40 L140 92 C110 104 70 104 40 92 Z"


def grid_lines(x0, x1, y0, y1, cols, rows, curve=8):
    d = []
    for i in range(1, cols):
        x = x0 + (x1 - x0) * i / cols
        d.append(f"M{x:.1f} {y0}C{x + 4:.1f} {(y0 * 2 + y1) / 3:.1f} {x - 4:.1f} {(y0 + y1 * 2) / 3:.1f} {x:.1f} {y1}")
    for j in range(1, rows):
        y = y0 + (y1 - y0) * j / rows
        d.append(f"M{x0} {y:.1f}Q{(x0 + x1) / 2:.1f} {y + curve:.1f} {x1} {y:.1f}")
    return f'<path d="{"".join(d)}" fill="none" stroke="{INK}" stroke-width="2.4"/>'


def arm():
    defs = f'<clipPath id="fc"><path d="{FORE}"/><path d="{FIST}"/></clipPath>'
    body = cutout(ARM, "url(#gBlue)", ink=9, extra=
                  f'<path d="M110 40 C130 80 132 150 124 196 L96 196 C112 150 112 90 110 40 Z" fill="{BLUE_D}" opacity="0.5"/>'
                  f'<path d="{CAP}" fill="url(#gRed)" stroke="{INK}" stroke-width="5"/>'
                  f'<path d="{FORE}" fill="url(#gRed)" stroke="{INK}" stroke-width="5"/><path d="{FIST}" fill="url(#gRed)" stroke="{INK}" stroke-width="5"/>'
                  f'<g clip-path="url(#fc)">{grid_lines(20, 150, 190, 500, 4, 10)}<path d="M104 200 C120 260 116 340 108 400 L124 400 C134 330 140 260 130 200 Z" fill="{RED_D}" opacity="0.45"/></g>'
                  f'<path d="M58 430 C70 420 92 420 104 432" fill="none" stroke="{INK}" stroke-width="3"/>'
                  f'<path d="{ARM}" fill="none" stroke="{INK}" stroke-width="9" stroke-linejoin="round"/>')
    return svg(180, 520, body, defs)


LEG = ("M24 30 C24 10 156 10 156 30 L150 250 C150 290 140 340 136 400 L138 500 C170 506 178 548 150 556 "
       "L30 556 C14 548 18 506 40 500 L44 400 C40 340 30 290 30 250 Z")
SHIN = "M30 250 C60 262 120 262 150 250 C150 290 140 340 136 400 L138 500 C170 506 178 548 150 556 L30 556 C14 548 18 506 40 500 L44 400 C40 340 30 290 30 250 Z"


def leg():
    defs = f'<clipPath id="sc"><path d="{SHIN}"/></clipPath>'
    body = cutout(LEG, "url(#gBlue)", ink=9, extra=
                  f'<path d="M120 30 C146 90 146 190 138 250 L110 256 C124 190 126 90 120 30 Z" fill="{BLUE_D}" opacity="0.5"/>'
                  f'<path d="{SHIN}" fill="url(#gRed)" stroke="{INK}" stroke-width="5"/>'
                  f'<g clip-path="url(#sc)">{grid_lines(14, 170, 252, 556, 4, 10)}<path d="M112 262 C128 330 122 420 118 500 L140 500 C140 420 150 330 146 262 Z" fill="{RED_D}" opacity="0.45"/></g>'
                  f'<path d="M24 546 L156 546 L152 558 L28 558 Z" fill="{BLUE}" stroke="{INK}" stroke-width="4"/>'
                  f'<path d="{LEG}" fill="none" stroke="{INK}" stroke-width="9" stroke-linejoin="round"/>')
    return svg(180, 580, body, defs)


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
