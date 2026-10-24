-- Ghost Rider's Hell Cycle: black chopper with chrome forks, skull headlight and burning wheels.
-- Front of the bike points -Z (Roblox forward); part positions are relative to the ground under the seat.
local C = Color3.fromRGB
local H = {}

function H.Build(flame, flame2)
	flame, flame2 = flame or C(255, 120, 20), flame2 or C(255, 220, 60)
	local m = Instance.new("Model"); m.Name = "HellCycle"
	local function p(name, size, cf, color, mat, shape)
		local x = Instance.new("Part"); x.Name = name; x.Size = size; x.CFrame = cf; x.Color = color
		x.Material = mat or Enum.Material.SmoothPlastic; x.CanCollide = false; x.CanQuery = false; x.Massless = true; x.CastShadow = false
		if shape then x.Shape = shape end
		x.Parent = m; return x
	end
	local BLACK, CHROME = C(20, 20, 24), C(190, 192, 200)
	local seat = p("Seat", Vector3.new(1.1, 0.35, 1.6), CFrame.new(0, 2.3, 0.4), C(35, 25, 20), Enum.Material.Fabric)
	p("Tank", Vector3.new(1.0, 0.7, 1.6), CFrame.new(0, 2.55, -1.0) * CFrame.Angles(math.rad(8), 0, 0), BLACK, Enum.Material.SmoothPlastic)
	p("Frame", Vector3.new(0.35, 0.35, 4.2), CFrame.new(0, 1.7, -0.2), BLACK, Enum.Material.Metal)
	p("Engine", Vector3.new(0.9, 0.9, 1.0), CFrame.new(0, 1.55, -0.4), CHROME, Enum.Material.DiamondPlate)
	for _, x in { -0.55, 0.55 } do -- exhaust pipes
		p("Exhaust", Vector3.new(0.22, 0.22, 2.6), CFrame.new(x, 1.15, 0.9), CHROME, Enum.Material.Metal)
	end
	for _, x in { -0.3, 0.3 } do -- raked chopper forks
		p("Fork", Vector3.new(0.14, 3.0, 0.14), CFrame.new(x, 2.0, -2.45) * CFrame.Angles(math.rad(-28), 0, 0), CHROME, Enum.Material.Metal)
	end
	p("Bars", Vector3.new(2.0, 0.12, 0.12), CFrame.new(0, 3.35, -1.85), CHROME, Enum.Material.Metal)
	for _, x in { -1, 1 } do p("Grip", Vector3.new(0.2, 0.5, 0.18), CFrame.new(x, 3.5, -1.8), BLACK) end
	-- skull headlight
	local skull = p("Headlight", Vector3.new(0.6, 0.6, 0.6), CFrame.new(0, 2.85, -2.35), C(235, 228, 210), Enum.Material.Slate, Enum.PartType.Ball)
	local sl = Instance.new("SpotLight"); sl.Face = Enum.NormalId.Front; sl.Color = flame; sl.Range = 40; sl.Brightness = 4; sl.Angle = 60; sl.Parent = skull
	for _, x in { -0.13, 0.13 } do p("Eye", Vector3.new(0.14, 0.12, 0.05), CFrame.new(x, 2.9, -2.64), flame, Enum.Material.Neon) end
	-- burning wheels
	for _, z in { -3.05, 2.0 } do
		local tire = p("Wheel", Vector3.new(0.5, 2.3, 2.3), CFrame.new(0, 1.15, z) * CFrame.Angles(0, math.rad(90), 0), BLACK, Enum.Material.SmoothPlastic, Enum.PartType.Cylinder)
		local rim = p("Rim", Vector3.new(0.56, 1.5, 1.5), tire.CFrame, flame, Enum.Material.Neon, Enum.PartType.Cylinder)
		local f = Instance.new("Fire"); f.Color = flame; f.SecondaryColor = flame2; f.Size = 4; f.Heat = 6; f.Parent = tire
		local pe = Instance.new("ParticleEmitter"); pe.Color = ColorSequence.new(flame, flame2); pe.LightEmission = 1
		pe.Size = NumberSequence.new(0.6, 0); pe.Lifetime = NumberRange.new(0.3, 0.7); pe.Rate = 40; pe.Speed = NumberRange.new(1, 4)
		pe.SpreadAngle = Vector2.new(180, 180); pe.Parent = rim
		game:GetService("CollectionService"):AddTag(rim, "HellfireFlicker")
	end
	-- weld everything to the seat
	for _, x in m:GetChildren() do
		if x ~= seat then local w = Instance.new("WeldConstraint"); w.Part0 = seat; w.Part1 = x; w.Parent = x end
	end
	m.PrimaryPart = seat
	return m
end
return H
