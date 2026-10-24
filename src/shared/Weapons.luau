-- Signature weapons built from parts (no external meshes needed).
-- Weapons.Build(id) -> Model with a "Grip" part; Weapons.Attach(char, id, hand) welds it.
local W = {}
local function p(model, name, size, cf, color, mat, shape)
	local x = Instance.new("Part"); x.Name = name; x.Size = size; x.CFrame = cf; x.Color = color
	x.Material = mat or Enum.Material.Metal; x.CanCollide = false; x.CanQuery = false; x.Massless = true
	if shape then x.Shape = shape end
	x.Parent = model; return x
end
local C = Color3.fromRGB
local cyl = Enum.PartType.Cylinder
local up = CFrame.Angles(0, 0, math.rad(90)) -- cylinders are X-aligned; rotate to Y

-- Each builder makes parts relative to origin; "Grip" is where the hand holds (Y = blade/handle axis).
local B = {}
B.Mjolnir = function(m) -- short leather-wrapped handle, rectangular uru head, wrist strap
	p(m, "Grip", Vector3.new(0.35, 1.6, 0.35), CFrame.new(), C(90, 60, 40), Enum.Material.Fabric)
	p(m, "Head", Vector3.new(1.0, 1.0, 1.7), CFrame.new(0, 1.2, 0), C(160, 165, 175), Enum.Material.Metal)
	p(m, "Pommel", Vector3.new(0.45, 0.25, 0.45), CFrame.new(0, -0.9, 0), C(140, 140, 150))
	p(m, "Strap", Vector3.new(0.08, 0.6, 0.3), CFrame.new(0, -1.25, 0), C(70, 45, 30), Enum.Material.Fabric)
end
B.Stormbreaker = function(m) -- axe blade + hammer back, Groot-wood handle
	p(m, "Grip", Vector3.new(0.3, 3.2, 0.3), CFrame.new(0, 0.6, 0), C(110, 80, 50), Enum.Material.Wood)
	p(m, "Blade", Vector3.new(0.15, 1.3, 1.4), CFrame.new(0, 2.0, 0.75), C(190, 195, 205))
	p(m, "Hammer", Vector3.new(0.6, 0.6, 0.7), CFrame.new(0, 2.0, -0.4), C(150, 150, 160))
end
B.CapShield = function(m) -- vibranium disc: red/white/red rings, blue center, white star
	local g = p(m, "Grip", Vector3.new(0.2, 0.2, 0.2), CFrame.new(), C(60, 60, 60)); g.Transparency = 1
	local rings = { { 3.2, C(190, 20, 30) }, { 2.6, C(235, 235, 235) }, { 2.0, C(190, 20, 30) }, { 1.4, C(20, 50, 140) } }
	for i, r in rings do p(m, "Ring" .. i, Vector3.new(0.12 + i * 0.02, r[1], r[1]), CFrame.new(-0.3 - i * 0.02, 0, 0), r[2], Enum.Material.Metal, cyl) end
	p(m, "Star", Vector3.new(0.05, 0.6, 0.6), CFrame.new(-0.42, 0, 0) * CFrame.Angles(math.rad(45), 0, 0), C(240, 240, 240), Enum.Material.SmoothPlastic)
end
B.LokiScepter = function(m) -- gold staff, curved blade, blue mind stone gem
	p(m, "Grip", Vector3.new(0.2, 3.4, 0.2), CFrame.new(0, 0.8, 0), C(210, 170, 60))
	p(m, "Gem", Vector3.new(0.45, 0.45, 0.45), CFrame.new(0, 2.6, 0), C(80, 180, 255), Enum.Material.Neon, Enum.PartType.Ball)
	p(m, "BladeA", Vector3.new(0.08, 1.1, 0.3), CFrame.new(0, 3.0, 0.25) * CFrame.Angles(math.rad(-20), 0, 0), C(200, 200, 210))
	p(m, "BladeB", Vector3.new(0.08, 0.7, 0.25), CFrame.new(0, 2.8, -0.3) * CFrame.Angles(math.rad(35), 0, 0), C(200, 200, 210))
end
B.InfinityGauntlet = function(m) -- gold glove with 6 stones on knuckles + back
	p(m, "Grip", Vector3.new(1.1, 1.3, 1.1), CFrame.new(), C(215, 170, 50))
	local stones = { C(255, 140, 0), C(170, 40, 255), C(40, 90, 255), C(230, 30, 30), C(255, 230, 40), C(40, 220, 80) }
	for i, c in stones do
		local cf = i == 6 and CFrame.new(0, 0, -0.58) or CFrame.new(-0.4 + (i - 1) * 0.2, -0.55, -0.45)
		p(m, "Stone" .. i, Vector3.one * 0.22, cf, c, Enum.Material.Neon, Enum.PartType.Ball)
	end
end
B.WebShooter = function(m) -- silver wrist cartridge band
	p(m, "Grip", Vector3.new(0.9, 0.25, 0.9), CFrame.new(0, 0.3, 0), C(170, 175, 185), Enum.Material.Metal, nil)
	p(m, "Nozzle", Vector3.new(0.15, 0.15, 0.15), CFrame.new(0, 0.3, -0.48), C(60, 60, 70))
end
B.Repulsor = function(m) -- gold palm plate with glowing repulsor
	p(m, "Grip", Vector3.new(1.05, 1.2, 1.05), CFrame.new(), C(200, 30, 30))
	p(m, "Glow", Vector3.new(0.1, 0.5, 0.5), CFrame.new(0, -0.45, 0) * up * CFrame.Angles(0, 0, 0), C(180, 240, 255), Enum.Material.Neon, cyl)
end
B.Batarang = function(m) -- black bat-wing blade
	p(m, "Grip", Vector3.new(0.3, 0.1, 0.3), CFrame.new(), C(25, 25, 30))
	p(m, "WingL", Vector3.new(0.7, 0.08, 0.25), CFrame.new(-0.45, 0, 0.05) * CFrame.Angles(0, math.rad(-20), 0), C(25, 25, 30))
	p(m, "WingR", Vector3.new(0.7, 0.08, 0.25), CFrame.new(0.45, 0, 0.05) * CFrame.Angles(0, math.rad(20), 0), C(25, 25, 30))
end
B.GodKillerSword = function(m) -- Wonder Woman: long silver blade, gold crossguard
	p(m, "Grip", Vector3.new(0.25, 0.9, 0.25), CFrame.new(), C(110, 70, 40), Enum.Material.Fabric)
	p(m, "Guard", Vector3.new(0.25, 0.2, 1.1), CFrame.new(0, 0.55, 0), C(215, 170, 50))
	p(m, "Blade", Vector3.new(0.08, 3.4, 0.35), CFrame.new(0, 2.35, 0), C(215, 220, 230))
end
B.AmazonShield = function(m) -- round bronze shield
	local g = p(m, "Grip", Vector3.one * 0.2, CFrame.new(), C(0, 0, 0)); g.Transparency = 1
	p(m, "Face", Vector3.new(0.2, 2.6, 2.6), CFrame.new(-0.3, 0, 0), C(170, 120, 60), Enum.Material.Metal, cyl)
	p(m, "Boss", Vector3.new(0.25, 0.8, 0.8), CFrame.new(-0.42, 0, 0), C(215, 170, 50), Enum.Material.Metal, cyl)
end
B.LassoOfTruth = function(m) -- glowing gold coil at the hip/hand
	local g = p(m, "Grip", Vector3.new(0.15, 1.1, 1.1), CFrame.new(), C(255, 210, 80), Enum.Material.Neon, cyl); g.Transparency = 0.2
end
B.HarleyMallet = function(m) -- oversized red/black mallet
	p(m, "Grip", Vector3.new(0.3, 3.4, 0.3), CFrame.new(0, 0.8, 0), C(30, 30, 30), Enum.Material.Wood)
	p(m, "HeadR", Vector3.new(1.5, 1.5, 1.2), CFrame.new(0, 2.8, 0.6) * CFrame.Angles(math.rad(90), 0, 0) * up, C(200, 30, 40), Enum.Material.SmoothPlastic, cyl)
	p(m, "HeadB", Vector3.new(1.5, 1.5, 1.2), CFrame.new(0, 2.8, -0.6) * CFrame.Angles(math.rad(90), 0, 0) * up, C(25, 25, 30), Enum.Material.SmoothPlastic, cyl)
end
B.JokerCrowbar = function(m) -- the infamous crowbar
	p(m, "Grip", Vector3.new(0.18, 3, 0.18), CFrame.new(0, 0.9, 0), C(120, 120, 125))
	p(m, "Hook", Vector3.new(0.18, 0.18, 0.7), CFrame.new(0, 2.4, 0.3), C(120, 120, 125))
	p(m, "Claw", Vector3.new(0.18, 0.18, 0.45), CFrame.new(0, -0.6, -0.15), C(120, 120, 125))
end
B.DeathstrokeKatana = function(m) -- black-handled katana, silver blade
	p(m, "Grip", Vector3.new(0.22, 1.0, 0.22), CFrame.new(), C(20, 20, 20), Enum.Material.Fabric)
	p(m, "Tsuba", Vector3.new(0.6, 0.08, 0.6), CFrame.new(0, 0.55, 0), C(30, 30, 30), Enum.Material.Metal, nil)
	p(m, "Blade", Vector3.new(0.06, 3.0, 0.22), CFrame.new(0, 2.1, 0) * CFrame.Angles(math.rad(4), 0, 0), C(215, 220, 230))
end
B.DeathstrokeStaff = function(m) -- folding bo staff on the back hand
	p(m, "Grip", Vector3.new(0.18, 4.5, 0.18), CFrame.new(0, 0, 0), C(40, 40, 45))
	p(m, "CapA", Vector3.new(0.24, 0.3, 0.24), CFrame.new(0, 2.2, 0), C(220, 130, 30))
	p(m, "CapB", Vector3.new(0.24, 0.3, 0.24), CFrame.new(0, -2.2, 0), C(220, 130, 30))
end
B.PumpkinBomb = function(m) -- orange jack-o'-lantern grenade with glowing face
	p(m, "Grip", Vector3.one * 0.9, CFrame.new(), C(230, 110, 20), Enum.Material.SmoothPlastic, Enum.PartType.Ball)
	p(m, "Stem", Vector3.new(0.15, 0.3, 0.15), CFrame.new(0, 0.5, 0), C(60, 120, 40))
	p(m, "Face", Vector3.new(0.5, 0.2, 0.05), CFrame.new(0, -0.05, -0.44), C(255, 230, 80), Enum.Material.Neon)
end

B.HellfireChain = function(m) -- Johnny Blaze's chain whip: links hanging from the fist, steel dart tip, burning
	p(m, "Grip", Vector3.new(0.4, 0.4, 0.4), CFrame.new(), C(150, 150, 160), Enum.Material.Metal)
	for i = 1, 11 do
		p(m, "Link" .. i, Vector3.new(0.12, 0.2, 0.28), CFrame.new(0, -i * 0.22, -0.04 * i) * CFrame.Angles(0, (i % 2) * math.rad(90), 0), C(175, 170, 165), Enum.Material.Metal)
	end
	local dart = p(m, "Dart", Vector3.new(0.22, 0.5, 0.22), CFrame.new(0, -2.75, -0.48), C(200, 205, 215), Enum.Material.Metal)
	local sm = Instance.new("SpecialMesh"); sm.MeshType = Enum.MeshType.Sphere; sm.Scale = Vector3.new(0.6, 1.4, 0.6); sm.Parent = dart
	local f = Instance.new("ParticleEmitter"); f.Texture = "rbxasset://textures/particles/fire_main.dds"; f.LightEmission = 1
	f.Color = ColorSequence.new(C(255, 220, 120), C(255, 90, 20)); f.Size = NumberSequence.new(0.6, 0); f.Rate = 30
	f.Lifetime = NumberRange.new(0.3, 0.5); f.Speed = NumberRange.new(1, 2); f.Parent = m.Link6
end

function W.Build(id)
	local m = Instance.new("Model"); m.Name = id
	B[id](m); m.PrimaryPart = m.Grip
	return m
end

-- Weld weapon to a hand. hand: "Right" | "Left". Supports R15 and R6.
function W.Attach(char, id, hand)
	local limb = char:FindFirstChild(hand .. "Hand") or char:FindFirstChild(hand .. " Arm")
	if not limb or not B[id] then return end
	local m = W.Build(id)
	local tipDown = limb.Name:find("Arm") and -1 or -0.2
	m:PivotTo(limb.CFrame * CFrame.new(0, tipDown, 0) * CFrame.Angles(math.rad(-90), 0, 0))
	for _, part in m:GetDescendants() do
		if part:IsA("BasePart") and part ~= m.Grip then
			local w = Instance.new("WeldConstraint"); w.Part0 = m.Grip; w.Part1 = part; w.Parent = part
		end
	end
	local w = Instance.new("WeldConstraint"); w.Part0 = limb; w.Part1 = m.Grip; w.Parent = m.Grip
	m.Name = "Weapon_" .. hand; m:SetAttribute("WeaponId", id); m.Parent = char
	return m
end

W.Ids = B
return W
