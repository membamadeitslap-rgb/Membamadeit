"""Stylized superhero body kit (animated-series proportions: broad chest, narrow waist, heavy arms).
Every mesh is authored in the local frame of its Roblox R15 part (centered on the part, +Y up, -Z forward)
and fits that part's Size, so MeshPart:ApplyMesh can swap it onto a standard rig without moving joints."""
import numpy as np
import trimesh

SEG = 28  # ring resolution


def superellipse_ring(rx, rz, n=2.2, seg=SEG, cx=0.0, cz=0.0, front_bulge=0.0):
    t = np.linspace(0, 2 * np.pi, seg, endpoint=False)
    c, s = np.cos(t), np.sin(t)
    x = rx * np.sign(c) * np.abs(c) ** (2 / n) + cx
    z = rz * np.sign(s) * np.abs(s) ** (2 / n) + cz
    z = z - front_bulge * np.clip(-s, 0, None) ** 2 * rz  # push the front (-Z) out for pecs / abs
    return x, z


def loft(sections, cap=True):
    """sections: list of dicts {y, rx, rz, n?, cx?, cz?, bulge?} bottom->top."""
    verts = []
    for sec in sections:
        x, z = superellipse_ring(sec["rx"], sec["rz"], sec.get("n", 2.2), cx=sec.get("cx", 0), cz=sec.get("cz", 0), front_bulge=sec.get("bulge", 0))
        verts.append(np.stack([x, np.full_like(x, sec["y"]), z], 1))
    v = np.concatenate(verts)
    faces = []
    for i in range(len(sections) - 1):
        for j in range(SEG):
            a, b = i * SEG + j, i * SEG + (j + 1) % SEG
            c, d = a + SEG, b + SEG
            faces += [[a, c, b], [b, c, d]]
    if cap:
        for idx, flip in ((0, True), (len(sections) - 1, False)):
            center = v[idx * SEG: idx * SEG + SEG].mean(0)
            ci = len(v); v = np.vstack([v, center])
            for j in range(SEG):
                a, b = idx * SEG + j, idx * SEG + (j + 1) % SEG
                faces.append([ci, b, a] if flip else [ci, a, b])
    m = trimesh.Trimesh(v, np.array(faces), process=True)
    trimesh.repair.fix_normals(m)
    return m


def fit(mesh, size):
    """Scale/center a mesh to exactly fill a part Size (x, y, z)."""
    lo, hi = mesh.bounds
    mesh = mesh.copy()
    mesh.apply_translation(-(lo + hi) / 2)
    mesh.apply_scale(np.array(size) / (hi - lo))
    return mesh


# ---- R15 part sizes (Roblox default block rig, studs) ----
R15 = {
    "Head": (1.2, 1.2, 1.2), "UpperTorso": (2, 1.6, 1), "LowerTorso": (2, 0.4, 1),
    "LeftUpperArm": (1, 1.17, 1), "RightUpperArm": (1, 1.17, 1), "LeftLowerArm": (1, 1.05, 1), "RightLowerArm": (1, 1.05, 1),
    "LeftHand": (1, 0.3, 1), "RightHand": (1, 0.3, 1),
    "LeftUpperLeg": (1, 1.217, 1), "RightUpperLeg": (1, 1.217, 1), "LeftLowerLeg": (1, 1.2, 1), "RightLowerLeg": (1, 1.2, 1),
    "LeftFoot": (1, 0.3, 1), "RightFoot": (1, 0.3, 1),
}
# Where each part's center sits for previews (feet on y=0)
LAYOUT = {
    "LeftFoot": (-0.45, 0.15, 0), "RightFoot": (0.45, 0.15, 0),
    "LeftLowerLeg": (-0.45, 0.9, 0), "RightLowerLeg": (0.45, 0.9, 0),
    "LeftUpperLeg": (-0.45, 2.1, 0), "RightUpperLeg": (0.45, 2.1, 0),
    "LowerTorso": (0, 2.9, 0), "UpperTorso": (0, 3.9, 0), "Head": (0, 5.3, 0),
    "LeftUpperArm": (-1.25, 4.05, 0), "RightUpperArm": (1.25, 4.05, 0),
    "LeftLowerArm": (-1.3, 2.95, 0), "RightLowerArm": (1.3, 2.95, 0),
    "LeftHand": (-1.3, 2.2, 0), "RightHand": (1.3, 2.2, 0),
}


def body(build="hero"):
    """Returns {partName: mesh}. build: 'hero' (TAS heroic V-taper), 'brute' (Hulk/Darkseid), 'lean' (Spider-Man/Flash)."""
    k = {"hero": 1.0, "brute": 1.18, "lean": 0.86}[build]
    parts = {}
    # Upper torso: V-taper, pecs pushed forward, traps sloping to the neck
    parts["UpperTorso"] = loft([
        dict(y=0.0, rx=0.46, rz=0.36, n=2.4),
        dict(y=0.3, rx=0.58 * k, rz=0.4, bulge=0.12),
        dict(y=0.75, rx=0.9 * k, rz=0.5 * k, bulge=0.3, n=2.5),
        dict(y=1.15, rx=1.04 * k, rz=0.5 * k, bulge=0.28, n=2.6),
        dict(y=1.42, rx=0.92 * k, rz=0.4, n=2.4),
        dict(y=1.6, rx=0.36, rz=0.28),
    ])
    parts["LowerTorso"] = loft([
        dict(y=0.0, rx=0.66, rz=0.42, n=2.6), dict(y=0.2, rx=0.56, rz=0.4, bulge=0.1, n=2.6), dict(y=0.4, rx=0.47, rz=0.36),
    ])
    for side in ("Left", "Right"):
        parts[side + "UpperArm"] = loft([  # shoulder ball -> bicep -> elbow
            dict(y=0.0, rx=0.22 * k, rz=0.22 * k), dict(y=0.4, rx=0.3 * k, rz=0.31 * k, bulge=0.15),
            dict(y=0.8, rx=0.36 * k, rz=0.34 * k), dict(y=1.05, rx=0.4 * k, rz=0.37 * k), dict(y=1.17, rx=0.3 * k, rz=0.3 * k),
        ])
        parts[side + "LowerArm"] = loft([  # forearm tapers to wrist; flared glove cuff
            dict(y=0.0, rx=0.2, rz=0.2), dict(y=0.12, rx=0.27, rz=0.25), dict(y=0.6, rx=0.32 * k, rz=0.29 * k), dict(y=0.95, rx=0.3 * k, rz=0.28 * k), dict(y=1.05, rx=0.24, rz=0.24),
        ])
        parts[side + "Hand"] = loft([  # closed fist
            dict(y=0.0, rx=0.17, rz=0.2, n=3), dict(y=0.1, rx=0.24, rz=0.27, n=3.5), dict(y=0.32, rx=0.23, rz=0.26, n=3.5), dict(y=0.42, rx=0.15, rz=0.2, n=3),
        ])
        parts[side + "UpperLeg"] = loft([  # thigh: wide quad tapering to knee
            dict(y=0.0, rx=0.26, rz=0.27), dict(y=0.4, rx=0.32, rz=0.34, bulge=0.12), dict(y=0.9, rx=0.4 * k, rz=0.4 * k, bulge=0.1), dict(y=1.217, rx=0.42 * k, rz=0.4),
        ])
        parts[side + "LowerLeg"] = loft([  # shin + calf, boot-top flare
            dict(y=0.0, rx=0.26, rz=0.28), dict(y=0.5, rx=0.29, rz=0.33), dict(y=0.85, rx=0.32, rz=0.36), dict(y=1.05, rx=0.34, rz=0.35), dict(y=1.2, rx=0.28, rz=0.28),
        ])
        foot = loft([  # boot: long toe toward -Z
            dict(y=0.0, rx=0.27, rz=0.52, n=3, cz=-0.14), dict(y=0.15, rx=0.27, rz=0.5, n=3, cz=-0.12), dict(y=0.3, rx=0.25, rz=0.3, n=2.6, cz=0.02),
        ])
        parts[side + "Foot"] = foot
    parts["Head"] = head()
    out = {}
    for name, m in parts.items():  # keep natural proportions; center on the part's joint-defined center
        lo, hi = m.bounds; m = m.copy(); m.apply_translation(-(lo + hi) / 2); out[name] = m
    return out


def head(jaw=1.0):
    """Square-jawed animated-style head (cowls/helmets are built as separate shells over this)."""
    return loft([
        dict(y=0.0, rx=0.22, rz=0.24), dict(y=0.12, rx=0.4 * jaw, rz=0.4, n=3.2, bulge=0.1), dict(y=0.4, rx=0.48, rz=0.5, n=3),
        dict(y=0.75, rx=0.5, rz=0.54, n=2.6), dict(y=1.05, rx=0.44, rz=0.48, n=2.4), dict(y=1.2, rx=0.2, rz=0.22),
    ])


# ---------------- costume shells ----------------
def cowl(ear=0.6):
    """Bat cowl: a shell over the top/back of the head, open at the jaw, with two pointed ears.
    Returned in Head-local space (Head size 1.2^3, center at origin)."""
    shell = loft([
        dict(y=-0.2, rx=0.5, rz=0.56, n=3, cz=0.06), dict(y=0.1, rx=0.53, rz=0.58, n=2.8), dict(y=0.4, rx=0.5, rz=0.55, n=2.6), dict(y=0.62, rx=0.24, rz=0.28),
    ])
    shell.apply_translation([0, 0, 0])
    ears = []
    for x in (-0.3, 0.3):
        e = trimesh.creation.cone(radius=0.1, height=ear, sections=10)
        e.apply_transform(trimesh.transformations.rotation_matrix(-np.pi / 2, [1, 0, 0]))  # cone +Z -> +Y
        e.apply_translation([x, 0.45, 0.02])
        ears.append(e)
    return trimesh.util.concatenate([shell] + ears)


def cape(width=2.6, length=3.8, flare=1.5):
    """Scalloped bat cape hanging from the shoulders (UpperTorso-local, top at shoulder height)."""
    rows, cols = 10, 16
    v, f = [], []
    for r in range(rows + 1):
        t = r / rows
        w = width * (0.45 + 0.55 * t) * (1 + (flare - 1) * t ** 2)
        y = 0.75 - t * length
        for c in range(cols + 1):
            u = c / cols - 0.5
            scallop = 0.0
            if r == rows:  # bat-wing scallops along the hem
                scallop = 0.25 * abs(np.sin(u * np.pi * 4))
            z = 0.55 + 0.25 * t + 0.35 * (u * 2) ** 2 * t  # curves back around the body
            v.append([u * w, y + scallop, z])
    for r in range(rows):
        for c in range(cols):
            a = r * (cols + 1) + c; b = a + 1; d = a + cols + 1; e = d + 1
            f += [[a, b, d], [b, e, d]]
    return trimesh.Trimesh(np.array(v), np.array(f), process=True)


def emblem_bat(w=1.1, h=0.42):
    """Flat bat-symbol silhouette (extruded polygon), for chest emblems."""
    import shapely.geometry as sg
    pts = [(0, 0.5), (0.12, 0.42), (0.16, 0.6), (0.22, 0.38), (0.55, 0.62), (0.9, 0.55), (1.0, 0.25), (0.82, 0.32), (0.75, 0.05),
           (0.62, 0.2), (0.5, -0.05), (0.38, 0.14), (0.2, -0.1), (0.12, 0.18), (0, 0.05)]
    right = [(x * w / 2, y * h - h / 4) for x, y in pts]
    left = [(-x, y) for x, y in reversed(right)]
    poly = sg.Polygon(right + left[1:-1]).buffer(0)
    return trimesh.creation.extrude_polygon(poly, 0.06)
