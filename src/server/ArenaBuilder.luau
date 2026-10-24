-- Builds placeholder lobby + circular arena in code (swap for real builds later).
local A = {}
local function part(props)
	local p = Instance.new("Part"); p.Anchored = true; p.TopSurface = Enum.SurfaceType.Smooth
	for k, v in props do p[k] = v end
	return p
end

function A.Build()
	local root = Instance.new("Folder"); root.Name = "Map"; root.Parent = workspace
	-- Lobby
	part({ Name = "LobbyFloor", Size = Vector3.new(120, 2, 120), Position = Vector3.new(0, 0, 0), Color = Color3.fromRGB(60, 60, 70), Material = Enum.Material.Concrete, Parent = root })
	local spawn = Instance.new("SpawnLocation"); spawn.Anchored = true; spawn.Size = Vector3.new(8, 1, 8); spawn.Position = Vector3.new(0, 1.5, 30); spawn.Neutral = true; spawn.Parent = root
	local pads = {}
	for i, x in { -12, 12 } do
		pads[i] = part({ Name = "DuelPad" .. i, Shape = Enum.PartType.Cylinder, Size = Vector3.new(1, 8, 8),
			CFrame = CFrame.new(x, 1.2, 0) * CFrame.Angles(0, 0, math.rad(90)),
			Color = i == 1 and Color3.fromRGB(200, 30, 40) or Color3.fromRGB(30, 80, 200), Material = Enum.Material.Neon, Parent = root })
	end
	-- Arena (offset far away)
	local c = Vector3.new(0, 0, 600)
	local floor = part({ Name = "ArenaFloor", Shape = Enum.PartType.Cylinder, Size = Vector3.new(2, 110, 110),
		CFrame = CFrame.new(c) * CFrame.Angles(0, 0, math.rad(90)), Color = Color3.fromRGB(45, 55, 95), Material = Enum.Material.Slate, Parent = root })
	for i = 0, 35 do -- railing ring + invisible wall
		local a = math.rad(i * 10)
		local pos = c + Vector3.new(math.cos(a) * 54, 3, math.sin(a) * 54)
		local cf = CFrame.lookAt(pos, c + Vector3.new(0, 3, 0))
		part({ Size = Vector3.new(10, 1, 0.6), CFrame = cf + Vector3.new(0, 1.5, 0), Color = Color3.fromRGB(190, 25, 25), Material = Enum.Material.Wood, Parent = root })
		part({ Size = Vector3.new(0.8, 4, 0.8), CFrame = cf, Color = Color3.fromRGB(190, 25, 25), Material = Enum.Material.Wood, Parent = root })
		part({ Size = Vector3.new(10, 30, 1), CFrame = cf + Vector3.new(0, 12, 0), Transparency = 1, Parent = root })
	end
	return { Pads = pads, ArenaCenter = c, SpawnA = c + Vector3.new(0, 4, -20), SpawnB = c + Vector3.new(0, 4, 20), Lobby = spawn.Position + Vector3.new(0, 4, 0) }
end
return A
