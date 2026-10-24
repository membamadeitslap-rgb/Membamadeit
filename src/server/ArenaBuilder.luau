-- Builds placeholder lobby + circular arena in code (swap for real builds later).
local A = {}
local function part(props)
	local p = Instance.new("Part"); p.Anchored = true; p.TopSurface = Enum.SurfaceType.Smooth
	for k, v in props do p[k] = v end
	return p
end

local C = Color3.fromRGB
-- Every arena: round floor, ring railing, invisible wall, themed props.
A.Themes = {
	{ Name = "Stark Tower Rooftop", Floor = C(70, 75, 85), FloorMat = Enum.Material.DiamondPlate, Rail = C(200, 200, 210), RailMat = Enum.Material.Metal,
		Props = function(root, c) -- glowing helipad ring + "A" tower spire
			part({ Shape = Enum.PartType.Cylinder, Size = Vector3.new(0.2, 30, 30), CFrame = CFrame.new(c + Vector3.new(0, 1.1, 0)) * CFrame.Angles(0, 0, math.rad(90)), Color = C(80, 200, 255), Material = Enum.Material.Neon, Transparency = 0.5, Parent = root })
			part({ Size = Vector3.new(8, 60, 8), Position = c + Vector3.new(0, 30, 75), Color = C(200, 200, 210), Material = Enum.Material.Glass, Parent = root })
		end },
	{ Name = "Gotham Streets", Floor = C(45, 45, 50), FloorMat = Enum.Material.Asphalt, Rail = C(30, 30, 30), RailMat = Enum.Material.Metal,
		Props = function(root, c) -- buildings + bat signal
			for i = 0, 7 do
				local a = math.rad(i * 45)
				part({ Size = Vector3.new(25, 50 + i % 3 * 20, 25), Position = c + Vector3.new(math.cos(a) * 85, 30, math.sin(a) * 85), Color = C(35, 35, 45), Material = Enum.Material.Brick, Parent = root })
			end
			local sig = part({ Shape = Enum.PartType.Cylinder, Size = Vector3.new(0.5, 30, 30), CFrame = CFrame.new(c + Vector3.new(0, 120, 100)) * CFrame.Angles(0, math.rad(90), 0), Color = C(255, 230, 120), Material = Enum.Material.Neon, Transparency = 0.4, Parent = root })
			Instance.new("PointLight", sig).Range = 60
		end },
	{ Name = "Wakanda Plains", Floor = C(150, 120, 70), FloorMat = Enum.Material.Sand, Rail = C(110, 60, 170), RailMat = Enum.Material.Neon,
		Props = function(root, c) -- vibranium crystals
			for i = 0, 5 do
				local a = math.rad(i * 60 + 20)
				part({ Size = Vector3.new(3, 10, 3), CFrame = CFrame.new(c + Vector3.new(math.cos(a) * 65, 5, math.sin(a) * 65)) * CFrame.Angles(0.3, a, 0.2), Color = C(150, 90, 255), Material = Enum.Material.Neon, Parent = root })
			end
		end },
	{ Name = "Metropolis Plaza", Floor = C(200, 200, 205), FloorMat = Enum.Material.Marble, Rail = C(215, 170, 50), RailMat = Enum.Material.Metal,
		Props = function(root, c) -- Daily Planet globe
			part({ Size = Vector3.new(6, 40, 6), Position = c + Vector3.new(0, 20, 80), Color = C(200, 200, 205), Material = Enum.Material.Marble, Parent = root })
			part({ Shape = Enum.PartType.Ball, Size = Vector3.one * 20, Position = c + Vector3.new(0, 48, 80), Color = C(215, 170, 50), Material = Enum.Material.Metal, Parent = root })
		end },
	{ Name = "Asgard Bifrost", Floor = C(60, 80, 160), FloorMat = Enum.Material.Glass, Rail = C(215, 170, 50), RailMat = Enum.Material.Metal,
		Props = function(root, c) -- rainbow bridge out of the arena
			local colors = { C(255, 60, 60), C(255, 160, 40), C(255, 240, 60), C(60, 220, 90), C(60, 140, 255), C(150, 70, 255) }
			for i, col in colors do
				part({ Size = Vector3.new(2, 0.4, 120), Position = c + Vector3.new(-6 + i * 2, 0.6, 115), Color = col, Material = Enum.Material.Neon, Parent = root })
			end
		end },
}

function A.BuildArena(root, c, t)
	part({ Name = "ArenaFloor", Shape = Enum.PartType.Cylinder, Size = Vector3.new(2, 110, 110),
		CFrame = CFrame.new(c) * CFrame.Angles(0, 0, math.rad(90)), Color = t.Floor, Material = t.FloorMat, Parent = root })
	for i = 0, 35 do
		local a = math.rad(i * 10)
		local pos = c + Vector3.new(math.cos(a) * 54, 3, math.sin(a) * 54)
		local cf = CFrame.lookAt(pos, c + Vector3.new(0, 3, 0))
		part({ Size = Vector3.new(10, 1, 0.6), CFrame = cf + Vector3.new(0, 1.5, 0), Color = t.Rail, Material = t.RailMat, Parent = root })
		part({ Size = Vector3.new(0.8, 4, 0.8), CFrame = cf, Color = t.Rail, Material = t.RailMat, Parent = root })
		part({ Size = Vector3.new(10, 30, 1), CFrame = cf + Vector3.new(0, 12, 0), Transparency = 1, Parent = root })
	end
	t.Props(root, c)
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
	local arenas = {}
	for i, theme in A.Themes do
		local c = Vector3.new((i - 3) * 300, 0, 600)
		A.BuildArena(root, c, theme)
		arenas[i] = { Name = theme.Name, Center = c, SpawnA = c + Vector3.new(0, 4, -20), SpawnB = c + Vector3.new(0, 4, 20) }
	end
	return { Pads = pads, Arenas = arenas, Lobby = spawn.Position + Vector3.new(0, 4, 0) }
end
return A
