"""Assemble a hero from kit meshes, export GLB, render front/side/back with three.js in headless Chromium.
Usage: python3 preview.py <out.png>   (hero spec built in build_batman for now)"""
import sys, json, subprocess, pathlib, numpy as np, trimesh
import kit

HERE = pathlib.Path(__file__).parent


def place(mesh, part):
    m = mesh.copy(); m.apply_translation(kit.LAYOUT[part]); return m


def colored(mesh, rgb):
    m = mesh.copy()
    m.visual = trimesh.visual.TextureVisuals(material=trimesh.visual.material.PBRMaterial(baseColorFactor=list(rgb) + [255], metallicFactor=0, roughnessFactor=1))
    return m


def build_batman(variant="tas"):
    pal = {"tas": dict(suit=(120, 120, 130), dark=(25, 25, 35), belt=(255, 205, 60), skin=(234, 184, 146), ear=0.6),
           "halloween": dict(suit=(95, 80, 70), dark=(30, 25, 25), belt=(200, 160, 70), skin=(234, 184, 146), ear=1.0, oval=False),
           "filmation": dict(suit=(160, 160, 170), dark=(60, 110, 210), belt=(255, 215, 60), skin=(234, 184, 146), ear=0.45)}[variant]
    b = kit.body("hero")
    dark_parts = {"LowerTorso", "LeftHand", "RightHand", "LeftFoot", "RightFoot", "LeftLowerLeg", "RightLowerLeg", "LeftLowerArm", "RightLowerArm"}
    scene = []
    for name, m in b.items():
        col = pal["skin"] if name == "Head" else pal["dark"] if name in dark_parts else pal["suit"]
        scene.append(colored(place(m, name), col))
    hx, hy, hz = kit.LAYOUT["Head"]
    cw = kit.cowl(pal["ear"]); cw.apply_scale(1.22); cw.apply_translation([hx, hy + 0.08, hz])
    scene.append(colored(cw, pal["dark"]))
    tx, ty, tz = kit.LAYOUT["UpperTorso"]
    cp = kit.cape(); cp.apply_translation([tx, ty, tz - 0.05]); scene.append(colored(cp, pal["dark"]))
    belt = trimesh.creation.cylinder(radius=1, height=0.2, sections=32)
    belt.apply_transform(trimesh.transformations.rotation_matrix(np.pi / 2, [1, 0, 0]))  # axis Z -> Y: ring around the waist
    belt.apply_scale([0.62, 1, 0.44]); belt.apply_translation(np.array(kit.LAYOUT["LowerTorso"]) + [0, 0.12, 0]); scene.append(colored(belt, pal["belt"]))
    buckle = trimesh.creation.box([0.34, 0.24, 0.06]); buckle.apply_translation(np.array(kit.LAYOUT["LowerTorso"]) + [0, 0.12, -0.45]); scene.append(colored(buckle, (255, 225, 110)))
    for x in (-0.17, 0.17):  # white slit eyes on the cowl
        eye = trimesh.creation.box([0.2, 0.06, 0.05]); eye.apply_transform(trimesh.transformations.rotation_matrix(np.sign(x) * -0.25, [0, 0, 1]))
        eye.apply_translation([hx + x, hy + 0.14, hz - 0.72]); scene.append(colored(eye, (250, 250, 255)))
    for side in (-1, 1):  # scalloped glove fins
        for k in range(3):
            fin = trimesh.creation.cone(radius=0.07, height=0.3, sections=6)
            fin.apply_transform(trimesh.transformations.rotation_matrix(side * np.pi / 2.4, [0, 0, 1]))
            lx, ly, lz = kit.LAYOUT["RightLowerArm" if side > 0 else "LeftLowerArm"]
            fin.apply_translation([lx + side * 0.3, ly - 0.05 - k * 0.16, lz]); scene.append(colored(fin, pal["dark"]))
    if pal.get("oval", True):  # TAS/Filmation yellow oval; Long Halloween is a plain black bat
        oval = trimesh.creation.cylinder(radius=1, height=0.05, sections=32); oval.apply_scale([0.55, 0.32, 1])
        oval.apply_translation([tx, ty + 0.35, tz - 0.6]); scene.append(colored(oval, (255, 215, 60)))
    bat = kit.emblem_bat(); bat.apply_translation([tx, ty + 0.35, tz - 0.66]); scene.append(colored(bat, (10, 10, 12)))
    return trimesh.Scene(scene)


HTML = """<!doctype html><html><body style="margin:0;background:#3a3a44">
<script type="importmap">{"imports":{"three":"./node_modules/three/build/three.module.js","three/addons/":"./node_modules/three/examples/jsm/"}}</script>
<script type="module">
import * as THREE from 'three'; import {GLTFLoader} from 'three/addons/loaders/GLTFLoader.js';
const W=1500,H=700; const r=new THREE.WebGLRenderer({antialias:true,preserveDrawingBuffer:true}); r.setSize(W,H); document.body.appendChild(r.domElement);
r.setClearColor(0x3a3a44); r.setScissorTest(true);
const scene=new THREE.Scene(); scene.add(new THREE.HemisphereLight(0xffffff,0x404050,1.6));
const d=new THREE.DirectionalLight(0xffffff,1.8); d.position.set(3,6,-6); scene.add(d);
new GLTFLoader().load('scene.glb',g=>{ g.scene.traverse(o=>{if(o.isMesh){o.geometry.computeVertexNormals(); o.material=new THREE.MeshToonMaterial({color:o.material.color}); o.material.side=THREE.DoubleSide;}}); scene.add(g.scene);
  const views=[[0,-1],[1,0],[0,1]]; views.forEach(([x,z],i)=>{ const cam=new THREE.PerspectiveCamera(32,(W/3)/H,0.1,100);
    cam.position.set(x*15,3.4,z*15); cam.lookAt(0,3.2,0); r.setViewport(i*W/3,0,W/3,H); r.setScissor(i*W/3,0,W/3,H); r.render(scene,cam); });
  document.title='done'; });
</script></body></html>"""


def render(mesh, out):
    view = HERE.parent.parent / ".." / ".."  # unused
    vd = pathlib.Path("/tmp/claude-0/-home-user/b1808802-6c8c-50d2-aac6-aa7219bd5180/scratchpad/viewer")
    mesh.export(vd / "scene.glb"); (vd / "index.html").write_text(HTML)
    js = f"""const {{chromium}}=require('playwright');(async()=>{{const b=await chromium.launch({{args:['--use-gl=swiftshader','--enable-webgl','--ignore-gpu-blocklist']}});
const p=await b.newPage({{viewport:{{width:1500,height:700}}}}); p.on('console',m=>console.log(m.text()));
await p.goto('http://127.0.0.1:8765/index.html'); await p.waitForFunction(()=>document.title==='done',null,{{timeout:60000}});
await p.screenshot({{path:'{out}'}}); await b.close();}})();"""
    srv = subprocess.Popen([sys.executable, "-m", "http.server", "8765", "--bind", "127.0.0.1"], cwd=vd, stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)
    try:
        import time; time.sleep(0.8)
        subprocess.run(["node", "-e", js], cwd=vd, check=True)
    finally:
        srv.terminate()


if __name__ == "__main__":
    variant = sys.argv[2] if len(sys.argv) > 2 else "tas"
    render(build_batman(variant), sys.argv[1])
