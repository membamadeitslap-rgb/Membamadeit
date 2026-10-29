# Character preview

Runs the game's real character code (`src/shared`: Heroes, Body, Skins, Costume, Weapons) under the `luau` CLI against a small Roblox API mock (`rbxmock.luau`), dumps every part as JSON (`dump.py`), and renders front / 3-4 / back views with three.js in headless Chromium (`render.html`, `render.js`).

```
LUAU=/path/to/luau tools/preview/preview.sh out.png Batman Hulk          # Common skins
LUAU=/path/to/luau tools/preview/preview.sh out.png --rarity Common,Secret Thor
VIEWS=0,35 COLS=5 LUAU=... tools/preview/preview.sh roster.png           # every hero
```

Needs `luau` (github.com/luau-lang/luau releases), node + Playwright Chromium, and three.js (installed on first run).
The mock rig is the default blocky R15 rig; the head renders as the classic rounded Roblox head. SurfaceGui text renders as flat labels.
It is a preview, not Studio: lighting, Neon glow and particles are approximations.
