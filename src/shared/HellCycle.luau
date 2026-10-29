-- Ghost Rider's Hell Cycle: long black chopper with a teardrop tank, tube frame, chrome V-twin, raked chrome forks,
-- ape-hanger bars, a bone skull headlight, twin exhausts and burning wheels.
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
	local function round(name, size, cf, color, mat)
		local x = p(name, size, cf, color, mat)
		local sm = Instance.new("SpecialMesh"); sm.MeshType = Enum.MeshType.Sphere; sm.Parent = x
		return x
	end
	local function rod(name, a, b, d, color, mat) -- round tube between two points
		local len = (b - a).Magnitude
		return p(name, Vector3.new(len, d, d), CFrame.lookAt((a + b) / 2, b) * CFrame.Angles(0, math.rad(90), 0), color, mat or Enum.Material.Metal, Enum.PartType.Cylinder)
	end
	local V = Vector3.new
	local BLACK, CHROME, LEATHER = C(20, 20, 24), C(190, 192, 200), C(35, 25, 20)
	local FRONT, REAR = V(0, 1.15, -3.15), V(0, 1.15, 2.0) -- axles
	local HEAD = V(0, 2.95, -2.05) -- steering head
	local seat = round("Seat", V(1.05, 0.38, 1.7), CFrame.new(0, 2.3, 0.4), LEATHER, Enum.Material.Leather)
	p("SeatBase", V(0.9, 0.12, 1.5), CFrame.new(0, 2.14, 0.45), BLACK, Enum.Material.Metal)
	round("Tank", V(1.0, 0.75, 1.75), CFrame.new(0, 2.62, -1.05) * CFrame.Angles(math.rad(10), 0, 0), BLACK, Enum.Material.SmoothPlastic)
	round("TankStripe", V(1.02, 0.2, 1.4), CFrame.new(0, 2.62, -1.05) * CFrame.Angles(math.rad(10), 0, 0), flame:Lerp(BLACK, 0.45), Enum.Material.SmoothPlastic)
	-- tube frame
	rod("Frame", HEAD, V(0, 2.25, 1.3), 0.2, BLACK)
	rod("Frame", HEAD, V(0, 0.95, -0.9), 0.2, BLACK)
	rod("Frame", V(0, 0.95, -0.9), REAR, 0.18, BLACK)
	rod("Frame", V(0, 2.2, 1.2), REAR, 0.16, BLACK)
	-- chrome V-twin: crankcase + two finned cylinders
	round("Crankcase", V(0.8, 0.75, 0.95), CFrame.new(0, 1.2, -0.35), CHROME, Enum.Material.Metal)
	for _, k in { -1, 1 } do
		local c = p("Cylinder", V(0.8, 0.5, 0.5), CFrame.new(0, 1.75, -0.35 + k * 0.28) * CFrame.Angles(math.rad(k * 28), 0, 0) * CFrame.Angles(0, 0, math.rad(90)), CHROME, Enum.Material.DiamondPlate, Enum.PartType.Cylinder)
		round("CylHead", V(0.55, 0.25, 0.55), c.CFrame * CFrame.Angles(0, 0, math.rad(-90)) * CFrame.new(0, 0.42, 0), CHROME, Enum.Material.Metal)
	end
	-- twin exhausts down the right side with flared tips
	for i, y in { 1.0, 1.32 } do
		rod("Exhaust", V(0.55, y + 0.3, -0.5), V(0.62, y, 0.4), 0.18, CHROME)
		rod("Exhaust", V(0.62, y, 0.4), V(0.62, y + 0.12, 2.5), 0.18, CHROME)
		p("ExhaustTip", V(0.2, 0.26, 0.26), CFrame.new(0.62, y + 0.12, 2.6) * CFrame.Angles(0, math.rad(90), 0), BLACK, Enum.Material.Metal, Enum.PartType.Cylinder)
	end
	-- raked chopper forks, triple tree, ape-hanger bars
	for _, x in { -0.3, 0.3 } do rod("Fork", V(x, HEAD.Y + 0.1, HEAD.Z + 0.05), V(x, FRONT.Y, FRONT.Z), 0.13, CHROME) end
	p("TripleTree", V(0.8, 0.12, 0.3), CFrame.new(HEAD + V(0, 0.15, -0.05)), CHROME, Enum.Material.Metal)
	for _, x in { -1, 1 } do
		rod("Riser", V(x * 0.25, HEAD.Y + 0.2, HEAD.Z), V(x * 0.4, HEAD.Y + 0.95, HEAD.Z + 0.2), 0.1, CHROME)
		rod("Bar", V(x * 0.4, HEAD.Y + 0.95, HEAD.Z + 0.2), V(x * 0.95, HEAD.Y + 0.9, HEAD.Z + 0.35), 0.1, CHROME)
		p("Grip", V(0.38, 0.17, 0.17), CFrame.new(x * 1.12, HEAD.Y + 0.9, HEAD.Z + 0.38), BLACK, Enum.Material.Leather, Enum.PartType.Cylinder)
	end
	-- skull headlight with burning eyes
	local skull = round("Headlight", V(0.6, 0.55, 0.62), CFrame.new(0, 2.75, -2.42), C(235, 228, 210), Enum.Material.Slate)
	round("SkullJaw", V(0.42, 0.22, 0.38), CFrame.new(0, 2.5, -2.5), C(225, 218, 200), Enum.Material.Slate)
	local sl = Instance.new("SpotLight"); sl.Face = Enum.NormalId.Front; sl.Color = flame; sl.Range = 40; sl.Brightness = 4; sl.Angle = 60; sl.Parent = skull
	for _, x in { -0.13, 0.13 } do round("Eye", V(0.15, 0.13, 0.08), CFrame.new(x, 2.78, -2.71), flame, Enum.Material.Neon) end
	-- rear fender over the back wheel
	round("Fender", V(0.62, 1.2, 2.2), CFrame.new(0, 1.95, 2.0), BLACK, Enum.Material.SmoothPlastic)
	-- burning wheels: fat tire, flaming rim, chrome hub
	for _, z in { FRONT.Z, REAR.Z } do
		local tire = p("Wheel", V(0.5, 2.3, 2.3), CFrame.new(0, 1.15, z), BLACK, Enum.Material.SmoothPlastic, Enum.PartType.Cylinder)
		local rim = p("Rim", V(0.56, 1.5, 1.5), tire.CFrame, flame, Enum.Material.Neon, Enum.PartType.Cylinder)
		p("Hub", V(0.66, 0.5, 0.5), tire.CFrame, CHROME, Enum.Material.Metal, Enum.PartType.Cylinder)
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
