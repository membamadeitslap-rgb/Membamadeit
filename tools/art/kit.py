"""Shared paper-puppet art kit: cut-out pieces (white paper border + ink outline), gradients, shared body
silhouettes, SVG -> PNG rendering (headless Chromium) and a front/back assembly preview."""
import math, os, re, json, subprocess

INK, PAPER = "#15151a", "#fbfaf6"


def cutout(path, fill, ink=9, border=22, extra=""):
    return (f'<path d="{path}" fill="none" stroke="#c9c7c0" stroke-width="{border * 2 + ink + 3}" stroke-linejoin="round" opacity="0.5"/>'
            f'<path d="{path}" fill="{PAPER}" stroke="{PAPER}" stroke-width="{border * 2 + ink}" stroke-linejoin="round"/>'
            f'<path d="{path}" fill="{fill}" stroke="{INK}" stroke-width="{ink}" stroke-linejoin="round"/>{extra}')


def outline(path, w=9):
    return f'<path d="{path}" fill="none" stroke="{INK}" stroke-width="{w}" stroke-linejoin="round"/>'


def grad(id_, light, mid, dark, x1=0.15, y1=0.1, x2=0.95, y2=0.9):
    return (f'<linearGradient id="{id_}" x1="{x1}" y1="{y1}" x2="{x2}" y2="{y2}">'
            f'<stop offset="0" stop-color="{light}"/><stop offset="0.45" stop-color="{mid}"/><stop offset="1" stop-color="{dark}"/></linearGradient>')


def svg(w, h, body, defs=""):
    return f'<svg xmlns="http://www.w3.org/2000/svg" width="{w}" height="{h}" viewBox="0 0 {w} {h}"><defs>{defs}</defs>{body}</svg>'


def scale_x(path, k, cx):
    """Scale a path's x coordinates toward cx (stroke widths stay even)."""
    toks = re.findall(r"[A-Za-z]|-?\d+\.?\d*", path)
    out, n = [], 0
    for t in toks:
        if t.isalpha():
            out.append(t); n = 0
        else:
            out.append(f"{cx + (float(t) - cx) * k:.1f}" if n % 2 == 0 else t); n += 1
    return " ".join(out)


# ---- shared silhouettes (same skeleton for every hero; builds differ by width) ----
TORSO = ("M70 46 C110 22 290 22 330 46 C362 62 372 96 364 140 C352 200 316 262 290 310 C282 330 282 352 288 380 "
         "L292 440 C292 452 280 460 266 460 L134 460 C120 460 108 452 108 440 L112 380 C118 352 118 330 110 310 "
         "C84 262 48 200 36 140 C28 96 38 62 70 46 Z")  # 400 x 480
ARM = ("M44 60 C42 22 120 18 124 58 C130 110 128 160 120 210 C118 230 116 246 118 262 C126 320 120 400 110 462 "
       "C126 470 132 500 128 530 C126 556 104 570 80 570 C54 570 34 558 32 532 C30 504 38 474 52 462 "
       "C44 400 38 330 42 262 C44 246 42 230 40 210 C36 160 38 110 44 60 Z")  # 160 x 600, outer side = left
LEG = ("M26 30 C24 8 158 8 156 30 C160 120 150 210 140 290 C138 304 138 316 142 330 C156 390 148 450 132 520 "
       "C140 540 154 560 156 584 C158 600 150 608 138 608 L42 608 C30 608 22 600 24 584 C26 560 40 540 48 520 "
       "C32 450 26 390 40 330 C44 316 44 304 40 290 C30 210 22 120 26 30 Z")  # 180 x 630
HEAD = ("M200 30 C298 30 358 100 356 196 C354 280 326 350 288 408 C262 446 232 470 200 470 "
        "C168 470 138 446 112 408 C74 350 46 280 44 196 C42 100 102 30 200 30 Z")  # 400 x 504


def render(outdir, files):
    """files: {name: svg string} -> writes name.svg + name.png (2x, transparent)."""
    os.makedirs(outdir, exist_ok=True)
    paths = []
    for k, v in files.items():
        p = os.path.abspath(os.path.join(outdir, k + ".svg")); open(p, "w").write(v); paths.append(p)
    js = """
const { chromium } = require('playwright'); const fs = require('fs');
(async () => { const b = await chromium.launch(); const p = await b.newPage({ deviceScaleFactor: 2 });
for (const f of JSON.parse(process.argv[2])) {
  const svg = fs.readFileSync(f, 'utf8'); const m = svg.match(/width="(\\d+)" height="(\\d+)"/);
  await p.setViewportSize({ width: +m[1], height: +m[2] });
  await p.setContent(`<html><body style="margin:0;background:transparent">${svg}</body></html>`);
  await p.screenshot({ path: f.replace(/\\.svg$/, '.png'), omitBackground: true, clip: { x: 0, y: 0, width: +m[1], height: +m[2] } });
} await b.close(); })();
"""
    jp = os.path.join(outdir, "_r.js"); open(jp, "w").write(js)
    subprocess.run(["node", jp, json.dumps(paths)], check=True)
    os.remove(jp)


def assemble(outdir, out_png, title=""):
    """Front + back preview of the six pieces (+ Cape if present) laid out like the in-game puppet."""
    from PIL import Image
    def ld(k):
        p = os.path.join(outdir, k + ".png")
        return Image.open(p).convert("RGBA") if os.path.exists(p) else None
    def sc(img, w): return img.resize((w, int(img.height * w / img.width)), Image.LANCZOS)
    arm, leg, cape = ld("Arm"), ld("Leg"), ld("Cape")
    def puppet(head, torso, back):
        c = Image.new("RGBA", (900, 1400), (234, 231, 222, 255))
        if cape and not back: c.alpha_composite(sc(cape, 520), (190, 250))
        L = sc(leg, 150)
        for x in (305, 445): c.alpha_composite(L, (x, 760))
        c.alpha_composite(sc(torso, 440), (230, 290))
        A = sc(arm, 138)
        for x, flip in ((150, False), (612, True)):
            c.alpha_composite(A.transpose(Image.FLIP_LEFT_RIGHT) if flip else A, (x, 300))
        if cape and back: c.alpha_composite(sc(cape, 520), (190, 250))
        c.alpha_composite(sc(head, 200), (350, 92))
        return c
    o = Image.new("RGBA", (1800, 1400))
    o.paste(puppet(ld("Head_Front"), ld("Torso_Front"), False), (0, 0))
    o.paste(puppet(ld("Head_Back"), ld("Torso_Back"), True), (900, 0))
    o.convert("RGB").resize((1200, 933)).save(out_png)
