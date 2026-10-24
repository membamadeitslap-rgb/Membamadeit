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

A.SLOTS = 10
-- One player base: walled plot facing the road, 10 pedestals, laser door, lock pad.
local function buildPlot(root, i, origin, facing)
	local m = Instance.new("Model"); m.Name = "Plot" .. i; m.Parent = root
	local cf = CFrame.lookAt(origin, origin + facing) -- -Z of cf points at the road
	local function at(x, y, z) return cf * CFrame.new(x, y, z) end
	part({ Name = "Floor", Size = Vector3.new(60, 1, 60), CFrame = at(0, 0.5, 0), Color = C(55, 55, 65), Material = Enum.Material.SmoothPlastic, Parent = m })
	for _, w in { { -30, 0, 1, 60 }, { 30, 0, 1, 60 }, { 0, 30, 60, 1 } } do
		part({ Size = Vector3.new(w[3], 14, w[4]), CFrame = at(w[1], 7, w[2]), Color = C(80, 80, 95), Material = Enum.Material.Brick, Parent = m })
	end
	for _, x in { -20, 20 } do -- front wall pieces, gap in the middle = entrance
		part({ Size = Vector3.new(20, 14, 1), CFrame = at(x, 7, -30), Color = C(80, 80, 95), Material = Enum.Material.Brick, Parent = m })
	end
	local door = part({ Name = "Door", Size = Vector3.new(20, 14, 0.4), CFrame = at(0, 7, -30), Color = C(255, 40, 40), Material = Enum.Material.ForceField, Transparency = 1, CanCollide = false, Parent = m })
	local lock = part({ Name = "LockPad", Size = Vector3.new(6, 0.4, 6), CFrame = at(22, 1.2, 22), Color = C(255, 60, 60), Material = Enum.Material.Neon, Parent = m })
	local sign = part({ Name = "Sign", Size = Vector3.new(20, 5, 1), CFrame = at(0, 17, -30), Color = C(25, 25, 30), Parent = m })
	local zone = part({ Name = "Zone", Size = Vector3.new(58, 16, 58), CFrame = at(0, 8, 0), Transparency = 1, CanCollide = false, CanQuery = false, Parent = m })
	local pedestals = {}
	for k = 1, A.SLOTS do
		local row, col = (k - 1) // 5, (k - 1) % 5
		pedestals[k] = part({ Name = "Pedestal" .. k, Shape = Enum.PartType.Cylinder, Size = Vector3.new(1, 6, 6),
			CFrame = at(-20 + col * 10, 1.5, 4 + row * 14) * CFrame.Angles(0, 0, math.rad(90)), Color = C(35, 35, 45), Material = Enum.Material.Metal, Parent = m })
	end
	return { Index = i, Model = m, CFrame = cf, Door = door, LockPad = lock, Sign = sign, Zone = zone, Pedestals = pedestals,
		Spawn = at(0, 4, 10).Position, Entrance = at(0, 3, -34).Position }
end

function A.Build()
	local root = Instance.new("Folder"); root.Name = "Map"; root.Parent = workspace
	-- Ground + convoy road running along X
	part({ Name = "Ground", Size = Vector3.new(560, 2, 260), Position = Vector3.new(0, -1, 0), Color = C(30, 35, 60), Material = Enum.Material.Pavement, Parent = root })
	part({ Name = "Road", Size = Vector3.new(560, 0.2, 26), Position = Vector3.new(0, 0.1, 0), Color = C(22, 22, 40), Material = Enum.Material.Glass, Reflectance = 0.2, Parent = root })
	for x = -270, 270, 20 do
		part({ Size = Vector3.new(8, 0.25, 0.8), Position = Vector3.new(x, 0.15, 0), Color = C(240, 200, 40), Material = Enum.Material.SmoothPlastic, Parent = root })
	end
	local spawn = Instance.new("SpawnLocation"); spawn.Anchored = true; spawn.Size = Vector3.new(10, 1, 10); spawn.Position = Vector3.new(0, 0.5, 20); spawn.Neutral = true; spawn.Transparency = 0.5; spawn.Parent = root
	local plots = {}
	for i = 1, 8 do
		local side = i <= 4 and 1 or -1
		local x = -195 + ((i - 1) % 4) * 130
		plots[i] = buildPlot(root, i, Vector3.new(x, 0, side * 60), Vector3.new(0, 0, -side))
	end
	local arenas = {}
	for i, theme in A.Themes do
		local c = Vector3.new((i - 3) * 300, 300, 900) -- floating arenas, far from the base world
		A.BuildArena(root, c, theme)
		arenas[i] = { Name = theme.Name, Center = c, SpawnA = c + Vector3.new(0, 4, -20), SpawnB = c + Vector3.new(0, 4, 20) }
	end
	return { Plots = plots, Arenas = arenas, Lobby = spawn.Position + Vector3.new(0, 4, 0),
		RoadStart = Vector3.new(-270, 0.2, 0), RoadEnd = Vector3.new(270, 0.2, 0) }
end
return A
