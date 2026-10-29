"""Run the game's real character builders (src/shared) under the luau CLI with a mocked Roblox API
and dump every hero variant as a JSON scene for render.js.
Usage: python3 dump.py <luau-binary> <out.json> [HeroId ...] [--rarity Common,Rare]"""
import sys, json, pathlib, subprocess, tempfile

HERE = pathlib.Path(__file__).parent
SHARED = HERE.parent.parent / "src" / "shared"


def tree(path, parent_var, out, counter):
    """Emit Lua that mirrors the Rojo tree: dir+init.luau -> ModuleScript, dir -> Folder, X.luau -> ModuleScript."""
    for p in sorted(path.iterdir()):
        if p.name.startswith("."):
            continue
        counter[0] += 1
        v = f"i{counter[0]}"
        if p.is_dir():
            init = p / "init.luau"
            cls = "ModuleScript" if init.exists() else "Folder"
            out.append(f'local {v} = Instance.new("{cls}"); {v}.Name = "{p.name}"; {v}.Parent = {parent_var}')
            if init.exists():
                out.append(f"LOADERS[{v}] = function(script)\n{init.read_text()}\nend")
            tree(p, v, out, counter)
        elif p.suffix == ".luau" and p.name != "init.luau":
            name = p.stem
            out.append(f'local {v} = Instance.new("ModuleScript"); {v}.Name = "{name}"; {v}.Parent = {parent_var}')
            out.append(f"LOADERS[{v}] = function(script)\n{p.read_text()}\nend")


def lua_list(xs):
    return "{" + ", ".join(json.dumps(x) for x in xs) + "}"


def build(heroes, rarities):
    mock = (HERE / "rbxmock.luau").read_text()
    out = [f"local mock = (function()\n{mock}\nend)()"]
    for g in ["Vector3", "Vector2", "CFrame", "Color3", "ColorSequence", "ColorSequenceKeypoint", "NumberSequence", "NumberSequenceKeypoint",
              "NumberRange", "UDim", "UDim2", "TweenInfo", "Rect", "PhysicalProperties", "Enum", "Instance", "game", "workspace", "task",
              "warn", "typeof", "tick", "Random"]:
        out.append(f"{g} = mock.{g}")
    out.append("local LOADERS, CACHE = {}, {}")
    out.append("require = function(s) if CACHE[s] == nil then CACHE[s] = LOADERS[s](s) end return CACHE[s] end")
    out.append('local Shared = Instance.new("Folder"); Shared.Name = "Shared"; Shared.Parent = mock.services.ReplicatedStorage')
    tree(SHARED, "Shared", out, [0])
    out.append(f"""
local Heroes = require(Shared.Heroes)
local Skins = require(Shared.Skins)
local Weapons = require(Shared.Weapons)
local want = {lua_list(heroes)}
local rarities = {lua_list(rarities)}
local ids = {{}}
if #want > 0 then ids = want else for id in Heroes do table.insert(ids, id) end table.sort(ids) end
for _, id in ids do
	for _, r in rarities do
		local ok, err = pcall(function()
			local m = mock.services.Players.CreateHumanoidModelFromDescription()
			Skins.Apply(m, id, r)
			for hand, wid in (Heroes[id].Weapons or {{}}) do Weapons.Attach(m, wid, hand) end
			local skin = Skins.Get(id, r)
			print("@@" .. mock.json({{ hero = id, rarity = r, name = skin and skin.Name or id, parts = mock.Dump(m) }}))
		end)
		if not ok then print("ERR " .. id .. " " .. r .. ": " .. tostring(err)) end
	end
end
""")
    return "\n".join(out)


def main():
    luau, outp = sys.argv[1], sys.argv[2]
    args = sys.argv[3:]
    rarities = ["Common"]
    if "--rarity" in args:
        i = args.index("--rarity"); rarities = args[i + 1].split(","); args = args[:i] + args[i + 2:]
    src = build(args, rarities)
    with tempfile.NamedTemporaryFile("w", suffix=".luau", delete=False) as f:
        f.write(src); fn = f.name
    res = subprocess.run([luau, fn], capture_output=True, text=True)
    scenes = []
    for line in res.stdout.splitlines():
        if line.startswith("@@"):
            scenes.append(json.loads(line[2:]))
        elif line.strip():
            print(line[:300])
    if res.returncode:
        print(res.stderr[:3000])
    json.dump(scenes, open(outp, "w"))
    print(f"{len(scenes)} scenes -> {outp}")


if __name__ == "__main__":
    main()
