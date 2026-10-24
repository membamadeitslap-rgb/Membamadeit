# Mesh generator + preview

Builds stylized hero meshes in code (no ripped assets) and renders front/side/back previews so the model can be checked against reference art before it goes into Roblox.

- `kit.py`: lofted body parts sized for the Roblox R15 rig (`body("hero"|"brute"|"lean")`), plus costume shells (`cowl`, `cape`, `emblem_bat`).
- `preview.py out.png <variant>`: assembles a hero and renders it with three.js in headless Chromium. Needs `pip install trimesh numpy networkx scipy shapely mapbox-earcut` and `npm i three@0.160.0` in the viewer dir.

Status: Batman (TAS / Filmation / Long Halloween) previewed. Not yet uploaded to Roblox.
Next: export per-R15-part OBJ files, upload them via the Open Cloud Assets API (the key needs `asset:write`), then swap them onto rigs with `AssetService:CreateMeshPartAsync` + `MeshPart:ApplyMesh` in HeroModel/Skins.Apply.
