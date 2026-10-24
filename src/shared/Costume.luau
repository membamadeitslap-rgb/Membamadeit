-- Costume pieces built from parts and welded onto a rig (R15 player/NPC or the select-screen Mannequin).
-- Each piece is a function(model, ...) ; Costume.Apply runs a list of { "Piece", args... }.
local C = Color3.fromRGB
local Costume = {}

local function find(m, ...) for _, n in { ... } do local p = m:FindFirstChild(n); if p then return p end end end
local function chestOf(m) return find(m, "UpperTorso", "Torso") end
local function waistOf(m) return find(m, "LowerTorso", "Belt", "Torso") end

local function piece(m, anchor, name, size, offset, color, mat, shape)
	local p = Instance.new("Part"); p.Name = "Costume_" .. name; p.Size = size; p.Color = color
	p.Material = mat or Enum.Material.SmoothPlastic; p.CanCollide = false; p.CanQuery = false; p.Massless = true
	p.CastShadow = false
	if shape then p.Shape = shape end
	p.CFrame = anchor.CFrame * offset
	p.Anchored = anchor.Anchored
	local w = Instance.new("WeldConstraint"); w.Part0 = anchor; w.Part1 = p; w.Parent = p
	p.Parent = m
	return p
end
local function glyph(part, face, text, color, font)
	local g = Instance.new("SurfaceGui"); g.Face = face; g.LightInfluence = 0; g.Parent = part
	local t = Instance.new("TextLabel"); t.Size = UDim2.fromScale(1, 1); t.BackgroundTransparency = 1; t.TextScaled = true
	t.Font = font or Enum.Font.GothamBlack; t.Text = text; t.TextColor3 = color; t.Parent = g
	return t
end

local P = {}
local spike -- defined with the Ghost Rider pieces below
-- Long cape hanging from the shoulders (Batman, Superman, Thor, Loki, Red Hood jacket tails...)
function P.Cape(m, color, inner)
	local t = chestOf(m); if not t then return end
	local h = t.Size.Y
	local cape = piece(m, t, "Cape", Vector3.new(t.Size.X * 1.25, h * 2.6, 0.15), CFrame.new(0, -h * 0.75, t.Size.Z / 2 + 0.12) * CFrame.Angles(math.rad(-6), 0, 0), color, Enum.Material.Fabric)
	if inner then piece(m, cape, "CapeInner", cape.Size - Vector3.new(0.05, 0.05, 0.1), CFrame.new(0, 0, -0.06), inner, Enum.Material.Fabric) end
	piece(m, t, "CapeCollar", Vector3.new(t.Size.X * 1.1, 0.3, t.Size.Z * 1.1), CFrame.new(0, h / 2, 0), color, Enum.Material.Fabric)
end
-- Bat cowl: mask shell + two ears; earLen 0.6 = TAS/classic, 1.1 = Longest Halloween / BTAS long ears
function P.Cowl(m, color, earLen, jaw)
	local hd = find(m, "Head"); if not hd then return end
	local s = hd.Size
	piece(m, hd, "Cowl", Vector3.new(s.X * 1.04, s.Y * 0.7, s.Z * 1.04), CFrame.new(0, s.Y * 0.17, 0), color)
	for _, x in { -0.28, 0.28 } do
		piece(m, hd, "Ear", Vector3.new(s.X * 0.16, s.Y * (earLen or 0.6), s.Z * 0.16), CFrame.new(x * s.X, s.Y * (0.5 + (earLen or 0.6) / 2), 0), color)
	end
	if jaw then piece(m, hd, "Jaw", Vector3.new(s.X * 0.7, s.Y * 0.32, s.Z * 0.2), CFrame.new(0, -s.Y * 0.3, -s.Z * 0.45), jaw) end -- skin-tone jaw
end
-- Full helmet (Iron Man, Red Hood, Nova); faceplate color + optional crest
function P.Helmet(m, color, plate, crest)
	local hd = find(m, "Head"); if not hd then return end
	local s = hd.Size
	piece(m, hd, "Helmet", s * 1.08, CFrame.new(), color)
	if plate then piece(m, hd, "Faceplate", Vector3.new(s.X * 0.8, s.Y * 0.85, 0.1), CFrame.new(0, -s.Y * 0.04, -s.Z * 0.56), plate) end
	if crest == "Fin" then piece(m, hd, "Fin", Vector3.new(0.15, s.Y * 0.5, s.Z * 0.9), CFrame.new(0, s.Y * 0.58, 0), color)
	elseif crest then -- Nova star crest
		local c = piece(m, hd, "Crest", Vector3.new(s.X * 0.6, s.Y * 0.5, 0.1), CFrame.new(0, s.Y * 0.35, -s.Z * 0.58), crest, Enum.Material.Neon)
		c.Transparency = 1; glyph(c, Enum.NormalId.Front, "✦", crest)
	end
end
-- Glowing eye slits (Iron Man white, Batman white, Superman red heat vision...)
function P.Eyes(m, color)
	local hd = find(m, "Head"); if not hd then return end
	local s = hd.Size
	for _, x in { -0.2, 0.2 } do
		piece(m, hd, "Eye", Vector3.new(s.X * 0.22, s.Y * 0.08, 0.06), CFrame.new(x * s.X, s.Y * 0.08, -s.Z * 0.6), color or C(255, 255, 255), Enum.Material.Neon)
	end
end
-- Cyclops visor / Deathstroke band: single wide glowing band
function P.Visor(m, frame, glow)
	local hd = find(m, "Head"); if not hd then return end
	local s = hd.Size
	piece(m, hd, "VisorFrame", Vector3.new(s.X * 1.1, s.Y * 0.24, s.Z * 1.06), CFrame.new(0, s.Y * 0.08, 0), frame)
	piece(m, hd, "VisorGlow", Vector3.new(s.X * 0.7, s.Y * 0.08, 0.06), CFrame.new(0, s.Y * 0.08, -s.Z * 0.56), glow, Enum.Material.Neon)
	for _, x in { -1, 1 } do -- ear pods
		piece(m, hd, "VisorPod", Vector3.new(0.12, s.Y * 0.34, s.Z * 0.34), CFrame.new(x * s.X * 0.56, 0, 0), frame)
	end
end
function P.Hair(m, color, style)
	local hd = find(m, "Head"); if not hd then return end
	local s = hd.Size
	piece(m, hd, "Hair", Vector3.new(s.X * 1.06, s.Y * 0.35, s.Z * 1.06), CFrame.new(0, s.Y * 0.4, s.Z * 0.04), color)
	if style == "Spiky" then
		for row, zf in { -0.3, 0.05, 0.38 } do -- three rows of spikes, swept up and back
			for i = -2, 2 do
				local sp = piece(m, hd, "Spike", Vector3.new(0.2, s.Y * (0.42 - math.abs(i) * 0.05), 0.2),
					CFrame.new(i * s.X * 0.2, s.Y * 0.62, zf * s.Z) * CFrame.Angles(math.rad(-20 - row * 8), 0, math.rad(-i * 18)), color)
				local sm = Instance.new("SpecialMesh"); sm.MeshType = Enum.MeshType.Wedge; sm.Parent = sp
			end
		end
	elseif style == "Pigtails" then
		for _, x in { -0.62, 0.62 } do piece(m, hd, "Pigtail", Vector3.new(s.X * 0.3, s.Y * 0.8, s.Z * 0.3), CFrame.new(x * s.X, s.Y * 0.1, s.Z * 0.2), color) end
	elseif style == "Long" then
		piece(m, hd, "HairBack", Vector3.new(s.X * 1.06, s.Y * 1.1, s.Z * 0.3), CFrame.new(0, -s.Y * 0.1, s.Z * 0.5), color)
	end
end
-- Chest emblem drawn as a glyph on a colored plate (bat oval, S shield, X, star, spider, triangle...)
function P.Emblem(m, text, color, plate)
	local t = chestOf(m); if not t then return end
	local s = t.Size
	local p = piece(m, t, "Emblem", Vector3.new(s.X * 0.62, s.Y * 0.42, 0.08), CFrame.new(0, s.Y * 0.12, -s.Z / 2 - 0.05), plate or color, plate and Enum.Material.SmoothPlastic or Enum.Material.Neon)
	if not plate then p.Transparency = 1 end
	glyph(p, Enum.NormalId.Front, text, color)
end
-- Iron Man arc reactor (triangle for Mark VI, circle otherwise)
function P.Reactor(m, tri)
	local t = chestOf(m); if not t then return end
	local s = t.Size
	local p = piece(m, t, "Reactor", Vector3.new(s.X * 0.32, s.X * 0.32, 0.08), CFrame.new(0, s.Y * 0.18, -s.Z / 2 - 0.05), C(200, 240, 255), Enum.Material.Neon)
	if tri then p.Transparency = 1; glyph(p, Enum.NormalId.Front, "▼", C(220, 245, 255)) end
	local l = Instance.new("PointLight"); l.Color = C(180, 230, 255); l.Range = 8; l.Parent = p
end
-- Nova Corps: three glowing chest orbs
function P.NovaOrbs(m, plate)
	local t = chestOf(m); if not t then return end
	local s = t.Size
	for _, o in { { -0.24, 0.25 }, { 0.24, 0.25 }, { 0, -0.05 } } do
		piece(m, t, "OrbPlate", Vector3.new(s.X * 0.3, s.X * 0.3, 0.06), CFrame.new(o[1] * s.X, o[2] * s.Y, -s.Z / 2 - 0.03), plate)
		piece(m, t, "Orb", Vector3.new(s.X * 0.18, s.X * 0.18, 0.08), CFrame.new(o[1] * s.X, o[2] * s.Y, -s.Z / 2 - 0.07), C(240, 250, 255), Enum.Material.Neon)
	end
end
function P.Belt(m, color, buckle)
	local w = waistOf(m); if not w then return end
	local s = w.Size
	local y = w.Name == "Torso" and -s.Y * 0.42 or s.Y * 0.3
	piece(m, w, "Belt", Vector3.new(s.X * 1.06, 0.3, s.Z * 1.08), CFrame.new(0, y, 0), color)
	if buckle then
		local b = piece(m, w, "Buckle", Vector3.new(s.X * 0.3, 0.36, 0.1), CFrame.new(0, y, -s.Z * 0.56), buckle.color or color)
		if buckle.text then glyph(b, Enum.NormalId.Front, buckle.text, buckle.textColor or C(200, 30, 30)) end
	end
end
-- Cyclops-style shoulder-to-hip harness straps
function P.Harness(m, color, style)
	local t = chestOf(m); if not t then return end
	local s = t.Size
	if style == "X" then
		local fz = -s.Z / 2 - 0.04
		local diag = math.sqrt((s.X * 0.8) ^ 2 + s.Y ^ 2)
		local ang = math.atan2(s.X * 0.8, s.Y)
		for _, k in { -1, 1 } do
			piece(m, t, "StrapX", Vector3.new(s.X * 0.13, diag, 0.08), CFrame.new(0, 0, fz) * CFrame.Angles(0, 0, k * ang), color)
			piece(m, t, "StrapShoulder", Vector3.new(s.X * 0.13, 0.08, s.Z * 1.1), CFrame.new(k * s.X * 0.36, s.Y / 2 + 0.03, 0), color)
			piece(m, t, "StrapBack", Vector3.new(s.X * 0.13, s.Y, 0.08), CFrame.new(k * s.X * 0.3, 0, s.Z / 2 + 0.04), color)
			piece(m, t, "StrapSide", Vector3.new(s.X * 0.12, s.Y * 0.5, 0.08), CFrame.new(k * s.X * 0.3, -s.Y * 0.26, fz), color)
		end
		return
	end
	piece(m, t, "Strap", Vector3.new(s.X * 0.14, s.Y * 1.1, 0.08), CFrame.new(-s.X * 0.1, 0, -s.Z / 2 - 0.04) * CFrame.Angles(0, 0, math.rad(-28)), color)
	piece(m, t, "Strap2", Vector3.new(s.X * 0.14, s.Y * 1.0, 0.08), CFrame.new(s.X * 0.25, -s.Y * 0.05, -s.Z / 2 - 0.04), color)
end
function P.Bands(m, color)
	local spots = { LeftUpperArm = 0.05, RightUpperArm = 0.05, LeftLowerArm = -0.36, RightLowerArm = -0.36, LeftUpperLeg = 0.05, RightUpperLeg = 0.05 }
	for name, y in spots do
		local a = m:FindFirstChild(name)
		if a then
			local s = a.Size
			piece(m, a, "Band", Vector3.new(s.X * 1.12, s.Y * (name:find("Lower") and 0.3 or 0.18), s.Z * 1.12), CFrame.new(0, y * s.Y, 0), color)
		end
	end
end
function P.Shoulders(m, color, spiky, spikeColor)
	for _, n in { "LeftUpperArm", "RightUpperArm", "LeftArm", "RightArm" } do
		local a = m:FindFirstChild(n)
		if a then
			local s = a.Size
			local h = a.Name:find("Upper") and s.Y * 0.4 or s.Y * 0.4
			piece(m, a, "Pad", Vector3.new(s.X * 1.35, s.Y * 0.35, s.Z * 1.35), CFrame.new(0, h, 0), color)
			if spiky then
				for k = -1, 1 do spike(m, a, CFrame.new(k * s.X * 0.35, h + s.Y * 0.3, 0), spikeColor or color) end
			end
		end
	end
end
-- Back spikes / crown spikes (Batman Who Laughs, Hellbat)
function P.Spikes(m, color)
	local hd = find(m, "Head")
	if hd then for i = -2, 2 do piece(m, hd, "Crown", Vector3.new(0.15, hd.Size.Y * 0.5, 0.15), CFrame.new(i * hd.Size.X * 0.2, hd.Size.Y * 0.7, 0) * CFrame.Angles(0, 0, math.rad(-i * 15)), color, Enum.Material.Metal) end end
	local t = chestOf(m)
	if t then for i = -1, 1 do piece(m, t, "BackSpike", Vector3.new(0.25, t.Size.Y * 0.6, 0.25), CFrame.new(i * t.Size.X * 0.3, t.Size.Y * 0.4, t.Size.Z / 2) * CFrame.Angles(math.rad(35), 0, 0), color, Enum.Material.Metal) end end
end
-- Wrist cuffs / gauntlet flares (Batman fins, Wonder Woman bracelets)
function P.Cuffs(m, color, fins)
	for _, n in { "LeftLowerArm", "RightLowerArm", "LeftArm", "RightArm" } do
		local a = m:FindFirstChild(n)
		if a then
			local s = a.Size
			piece(m, a, "Cuff", Vector3.new(s.X * 1.15, s.Y * 0.3, s.Z * 1.15), CFrame.new(0, -s.Y * 0.3, 0), color, Enum.Material.Metal)
			if fins then piece(m, a, "Fin", Vector3.new(0.1, s.Y * 0.35, s.Z * 0.5), CFrame.new(a.Name:find("Left") and -s.X * 0.6 or s.X * 0.6, -s.Y * 0.2, 0), color) end
		end
	end
end
-- Ghost Rider: bone-white skull with dark sockets/teeth, burning head (Fire + embers)
-- Realistic hellfire: layered particle flames (white-hot core -> flame color -> red -> smoke) + sparks.
-- Uses Roblox's built-in fire/smoke particle textures instead of the cartoony Fire object.
local FIRE_TEX, SMOKE_TEX, SPARK_TEX = "rbxasset://textures/particles/fire_main.dds", "rbxasset://textures/particles/smoke_main.dds", "rbxasset://textures/particles/sparkles_main.dds"
local function hellfire(parent, flame, flame2, scale, rate)
	scale, rate = scale or 1, rate or 1
	local function emitter(name, tex, props)
		local pe = Instance.new("ParticleEmitter"); pe.Name = name; pe.Texture = tex
		pe.EmissionDirection = Enum.NormalId.Top; pe.LockedToPart = false
		for k, v in props do pe[k] = v end
		pe.Parent = parent; return pe
	end
	emitter("FlameCore", FIRE_TEX, { LightEmission = 1, LightInfluence = 0, Rate = 60 * rate,
		Color = ColorSequence.new({ ColorSequenceKeypoint.new(0, Color3.new(1, 1, 0.9)), ColorSequenceKeypoint.new(0.3, flame2), ColorSequenceKeypoint.new(1, flame) }),
		Size = NumberSequence.new({ NumberSequenceKeypoint.new(0, 1.1 * scale), NumberSequenceKeypoint.new(0.6, 0.8 * scale), NumberSequenceKeypoint.new(1, 0) }),
		Transparency = NumberSequence.new({ NumberSequenceKeypoint.new(0, 0.2), NumberSequenceKeypoint.new(0.7, 0.4), NumberSequenceKeypoint.new(1, 1) }),
		Lifetime = NumberRange.new(0.35, 0.6), Speed = NumberRange.new(3 * scale, 5 * scale), SpreadAngle = Vector2.new(18, 18),
		Rotation = NumberRange.new(-30, 30), RotSpeed = NumberRange.new(-90, 90), Acceleration = Vector3.new(0, 4, 0) })
	emitter("FlameOuter", FIRE_TEX, { LightEmission = 0.8, LightInfluence = 0, Rate = 45 * rate,
		Color = ColorSequence.new({ ColorSequenceKeypoint.new(0, flame), ColorSequenceKeypoint.new(0.7, flame:Lerp(Color3.new(0.6, 0.05, 0), 0.6)), ColorSequenceKeypoint.new(1, Color3.new(0.2, 0.02, 0)) }),
		Size = NumberSequence.new({ NumberSequenceKeypoint.new(0, 1.4 * scale), NumberSequenceKeypoint.new(1, 0.3 * scale) }),
		Transparency = NumberSequence.new({ NumberSequenceKeypoint.new(0, 0.35), NumberSequenceKeypoint.new(1, 1) }),
		Lifetime = NumberRange.new(0.5, 0.9), Speed = NumberRange.new(2.5 * scale, 4.5 * scale), SpreadAngle = Vector2.new(30, 30),
		Rotation = NumberRange.new(0, 360), RotSpeed = NumberRange.new(-60, 60), Acceleration = Vector3.new(0, 3, 0) })
	emitter("Smoke", SMOKE_TEX, { LightInfluence = 0.3, Rate = 8 * rate, Color = ColorSequence.new(Color3.fromRGB(40, 30, 28)),
		Size = NumberSequence.new(1.2 * scale, 2.6 * scale), Transparency = NumberSequence.new(0.7, 1),
		Lifetime = NumberRange.new(1, 1.6), Speed = NumberRange.new(3, 5), SpreadAngle = Vector2.new(20, 20) })
	emitter("Sparks", SPARK_TEX, { LightEmission = 1, LightInfluence = 0, Rate = 14 * rate, Color = ColorSequence.new(flame2),
		Size = NumberSequence.new(0.18 * scale, 0), Lifetime = NumberRange.new(0.6, 1.2), Speed = NumberRange.new(5, 9),
		SpreadAngle = Vector2.new(35, 35), Acceleration = Vector3.new(0, -4, 0), Drag = 1 })
end
Costume.Hellfire = hellfire

-- Ghost Rider skull: rounded cranium, cheekbones, brow ridge, separate jaw, upper/lower teeth rows,
-- deep sockets with glowing pupils, inverted-heart nasal cavity. Flames pour off the top/back and creep up from the collar.
function P.FlamingSkull(m, flame, flame2)
	local hd = find(m, "Head"); if not hd then return end
	local s = hd.Size
	flame, flame2 = flame or C(255, 120, 20), flame2 or C(255, 220, 60)
	local BONE, DARK = C(232, 224, 204), C(22, 12, 8)
	local function mesh(p, kind, scale) local sm = Instance.new("SpecialMesh"); sm.MeshType = kind; sm.Scale = scale or Vector3.one; sm.Parent = p end
	local cranium = piece(m, hd, "Skull", Vector3.new(s.X * 1.0, s.Y * 0.82, s.Z * 1.05), CFrame.new(0, s.Y * 0.12, 0.02), BONE, Enum.Material.Slate)
	mesh(cranium, Enum.MeshType.Sphere)
	piece(m, hd, "Brow", Vector3.new(s.X * 0.86, s.Y * 0.12, s.Z * 0.2), CFrame.new(0, s.Y * 0.16, -s.Z * 0.42), BONE, Enum.Material.Slate)
	for _, x in { -1, 1 } do
		local cheek = piece(m, hd, "Cheekbone", Vector3.new(s.X * 0.3, s.Y * 0.22, s.Z * 0.42), CFrame.new(x * s.X * 0.33, -s.Y * 0.08, -s.Z * 0.22), BONE, Enum.Material.Slate)
		mesh(cheek, Enum.MeshType.Sphere)
		-- deep socket + ember pupil
		local sock = piece(m, hd, "Socket", Vector3.new(s.X * 0.27, s.Y * 0.24, 0.12), CFrame.new(x * s.X * 0.2, s.Y * 0.03, -s.Z * 0.47) * CFrame.Angles(0, 0, math.rad(-x * 10)), DARK)
		mesh(sock, Enum.MeshType.Sphere)
		piece(m, hd, "Pupil", Vector3.new(0.07, 0.07, 0.04), CFrame.new(x * s.X * 0.2, s.Y * 0.02, -s.Z * 0.53), flame2, Enum.Material.Neon)
	end
	for _, x in { -1, 1 } do -- inverted-heart nasal cavity (two angled slots)
		piece(m, hd, "Nasal", Vector3.new(s.X * 0.07, s.Y * 0.16, 0.08), CFrame.new(x * s.X * 0.035, -s.Y * 0.14, -s.Z * 0.5) * CFrame.Angles(0, 0, math.rad(x * 18)), DARK)
	end
	local maxilla = piece(m, hd, "Maxilla", Vector3.new(s.X * 0.56, s.Y * 0.14, s.Z * 0.3), CFrame.new(0, -s.Y * 0.27, -s.Z * 0.34), BONE, Enum.Material.Slate)
	local jaw = piece(m, hd, "Jaw", Vector3.new(s.X * 0.66, s.Y * 0.16, s.Z * 0.72), CFrame.new(0, -s.Y * 0.47, -s.Z * 0.06), BONE, Enum.Material.Slate)
	mesh(jaw, Enum.MeshType.Brick)
	for row, y in { -0.33, -0.41 } do -- upper / lower teeth
		for i = -3, 3 do
			piece(m, hd, "Tooth", Vector3.new(s.X * 0.068, s.Y * 0.075, 0.07), CFrame.new(i * s.X * 0.075, y * s.Y, -s.Z * 0.5 + math.abs(i) * 0.012), C(245, 240, 222), Enum.Material.Slate)
		end
	end
	piece(m, hd, "Bite", Vector3.new(s.X * 0.54, 0.02, 0.08), CFrame.new(0, -s.Y * 0.37, -s.Z * 0.5), DARK)
	-- flames: big crown off the cranium + collar flames creeping up around the neck
	local crown = piece(m, hd, "FlameCrown", Vector3.new(s.X * 0.8, 0.1, s.Z * 0.8), CFrame.new(0, s.Y * 0.45, 0.08), flame, Enum.Material.Neon)
	crown.Transparency = 1
	hellfire(crown, flame, flame2, s.Y * 1.1, 1.3)
	local collar = chestOf(m)
	if collar then
		local ring = piece(m, collar, "CollarFire", Vector3.new(collar.Size.X * 0.45, 0.1, collar.Size.Z * 0.7), CFrame.new(0, collar.Size.Y / 2, 0), flame, Enum.Material.Neon)
		ring.Transparency = 1
		hellfire(ring, flame, flame2, 0.55, 0.6)
	end
	local l = Instance.new("PointLight"); l.Color = flame; l.Range = 16; l.Brightness = 2.5; l.Shadows = true; l.Parent = cranium
	game:GetService("CollectionService"):AddTag(l, "HellfireFlicker")
end
-- Biker jacket: collar lapels, diagonal zipper, zip pockets
function P.BikerJacket(m, color, metal)
	local t = chestOf(m); if not t then return end
	local s = t.Size
	for _, x in { -1, 1 } do
		piece(m, t, "Lapel", Vector3.new(s.X * 0.28, s.Y * 0.4, 0.08), CFrame.new(x * s.X * 0.2, s.Y * 0.28, -s.Z / 2 - 0.04) * CFrame.Angles(0, 0, math.rad(x * 25)), color)
		piece(m, t, "Pocket", Vector3.new(s.X * 0.22, 0.04, 0.06), CFrame.new(x * s.X * 0.28, -s.Y * 0.15, -s.Z / 2 - 0.03), metal, Enum.Material.Metal)
	end
	piece(m, t, "Zip", Vector3.new(0.05, s.Y * 0.95, 0.06), CFrame.new(s.X * 0.08, -s.Y * 0.02, -s.Z / 2 - 0.03) * CFrame.Angles(0, 0, math.rad(-12)), metal, Enum.Material.Metal)
end
function spike(m, anchor, cf, metal) -- pointed metal stud
	local p = piece(m, anchor, "Stud", Vector3.new(0.2, 0.34, 0.2), cf, metal, Enum.Material.Metal)
	local sm = Instance.new("SpecialMesh"); sm.MeshType = Enum.MeshType.Sphere; sm.Scale = Vector3.new(0.7, 1.4, 0.7); sm.Parent = p
end
-- Spikes along the outer forearms and shins
function P.Studs(m, metal)
	for _, name in { "LeftLowerArm", "RightLowerArm", "LeftArm", "RightArm", "LeftLowerLeg", "RightLowerLeg", "LeftLeg", "RightLeg" } do
		local a = m:FindFirstChild(name)
		if a then
			local s = a.Size; local side = name:find("Left") and -1 or 1
			for k = 0, 1 do
				spike(m, a, CFrame.new(side * (s.X / 2 + 0.1), s.Y * 0.2 - k * s.Y * 0.35, 0) * CFrame.Angles(0, 0, math.rad(-side * 90)), metal)
			end
		end
	end
end
-- Heavy chain links: X across the chest, around the waist, one strand hanging off the hip
function P.Chains(m, metal)
	local t, w = chestOf(m), waistOf(m)
	local function link(anchor, p, dir, i)
		piece(m, anchor, "Link", Vector3.new(0.13, 0.22, 0.3), CFrame.lookAt(p, p + dir) * CFrame.Angles(0, 0, (i % 2) * math.rad(90)), metal, Enum.Material.Metal)
	end
	local function run(anchor, from, to, n)
		for i = 0, n do link(anchor, from:Lerp(to, i / n), (to - from).Unit, i) end
	end
	if t then
		local s = t.Size; local fz = -s.Z / 2 - 0.12
		run(t, Vector3.new(-s.X * 0.45, s.Y * 0.45, fz), Vector3.new(s.X * 0.42, -s.Y * 0.45, fz), 9)
		run(t, Vector3.new(s.X * 0.45, s.Y * 0.45, fz - 0.05), Vector3.new(-s.X * 0.42, -s.Y * 0.45, fz - 0.05), 9)
	end
	if w then
		local s = w.Size; local y = w.Name == "Torso" and -s.Y * 0.4 or 0
		for i = 0, 13 do
			local a = i / 14 * math.pi * 2
			link(w, Vector3.new(math.cos(a) * (s.X / 2 + 0.1), y, math.sin(a) * (s.Z / 2 + 0.12)), Vector3.new(-math.sin(a), 0, math.cos(a)), i)
		end
		run(w, Vector3.new(s.X * 0.58, y, -0.1), Vector3.new(s.X * 0.62, y - 1.6, 0), 6)
	end
end
-- Legendary+ Ghost Rider: hands, forearms and boots on fire, embers off the shoulders, flickering glow
function P.HellfireBody(m, flame, flame2)
	flame, flame2 = flame or C(255, 120, 20), flame2 or C(255, 220, 60)
	local CS = game:GetService("CollectionService")
	for _, n in { "LeftHand", "RightHand", "LeftLowerArm", "RightLowerArm", "LeftFoot", "RightFoot", "LeftArm", "RightArm", "LeftLeg", "RightLeg" } do
		local a = m:FindFirstChild(n)
		if a then
			hellfire(a, flame, flame2, n:find("Hand") and 0.7 or 0.5, n:find("Hand") and 0.8 or 0.5)
		end
	end
	for _, n in { "UpperTorso", "Torso" } do
		local t = m:FindFirstChild(n)
		if t then
			local pe = Instance.new("ParticleEmitter"); pe.Name = "HellEmbers"; pe.LightEmission = 1
			pe.Color = ColorSequence.new(flame, flame2); pe.Size = NumberSequence.new(0.35, 0)
			pe.Lifetime = NumberRange.new(0.6, 1.2); pe.Rate = 25; pe.Speed = NumberRange.new(1, 3)
			pe.Acceleration = Vector3.new(0, 6, 0); pe.SpreadAngle = Vector2.new(60, 60); pe.Parent = t
			local l = Instance.new("PointLight"); l.Name = "HellGlow"; l.Color = flame; l.Range = 16; l.Brightness = 2; l.Parent = t
			CS:AddTag(l, "HellfireFlicker")
		end
	end
end
-- Swap the body to a material (Ghost Rider: Leather)
function P.Material(m, mat)
	for _, p in m:GetChildren() do
		if p:IsA("BasePart") and p.Name ~= "HumanoidRootPart" and p.Name ~= "Head" then p.Material = mat end
	end
end
-- Spiked gloves (knuckles) and boots (outer ankle)
function P.GloveBootSpikes(m, metal)
	for _, n in { "LeftHand", "RightHand" } do
		local h = m:FindFirstChild(n)
		if h then for k = -1, 1 do spike(m, h, CFrame.new(k * h.Size.X * 0.3, 0, -h.Size.Z / 2 - 0.1) * CFrame.Angles(math.rad(-90), 0, 0), metal) end end
	end
	for _, n in { "LeftFoot", "RightFoot" } do
		local f = m:FindFirstChild(n)
		if f then local side = n:find("Left") and -1 or 1
			spike(m, f, CFrame.new(side * (f.Size.X / 2 + 0.1), f.Size.Y * 0.3, 0.1) * CFrame.Angles(0, 0, math.rad(-side * 90)), metal) end
	end
end
-- Chain wrapped in a spiral around the right arm (upper + lower)
function P.ArmChain(m, metal)
	for _, n in { "RightUpperArm", "RightLowerArm", "Right Arm" } do
		local a = m:FindFirstChild(n)
		if a then
			local s = a.Size
			for i = 0, 9 do
				local t = i / 9
				local ang = t * math.pi * 3
				local pos = Vector3.new(math.cos(ang) * (s.X / 2 + 0.08), s.Y / 2 - t * s.Y, math.sin(ang) * (s.Z / 2 + 0.08))
				piece(m, a, "ArmLink", Vector3.new(0.12, 0.2, 0.26), CFrame.lookAt(pos, pos + Vector3.new(-math.sin(ang), -0.3, math.cos(ang))) * CFrame.Angles(0, 0, (i % 2) * math.rad(90)), metal, Enum.Material.Metal)
			end
		end
	end
end
Costume.Pieces = P
Costume.SKIN = Color3.fromRGB(234, 184, 146)

-- Per-hero default look. Receives the skin (Primary/Secondary/Name) and returns { colors?, pieces }.
-- colors override body-part groups: Head, Chest, Waist, Arms, Hands, Legs, Feet.
local SKIN, GOLD, WHITE = C(234, 184, 146), C(215, 170, 50), C(245, 245, 245)
Costume.Heroes = {
	SpiderMan = function(s) return { colors = { Head = s.Primary, Hands = s.Primary, Feet = s.Primary },
		pieces = { { "Eyes", WHITE }, { "Emblem", "✱", s.Secondary == WHITE and WHITE or C(15, 15, 15) } } } end,
	IronMan = function(s) return { colors = { Legs = s.Secondary, Arms = s.Primary, Hands = s.Primary, Feet = s.Primary },
		pieces = { { "Helmet", s.Primary, s.Secondary }, { "Eyes", WHITE }, { "Reactor", true }, { "Shoulders", s.Primary } } } end,
	Thor = function(s) return { colors = { Head = SKIN, Arms = SKIN, Hands = SKIN, Legs = C(40, 40, 50) },
		pieces = { { "Cape", s.Secondary }, { "Hair", C(220, 180, 90), "Long" }, { "Emblem", "◉ ◉", C(190, 190, 200) }, { "Cuffs", C(170, 170, 180) } } } end,
	CaptainAmerica = function(s) return { colors = { Hands = s.Secondary, Feet = s.Secondary },
		pieces = { { "Helmet", s.Primary, nil, "Fin" }, { "Emblem", "★", WHITE }, { "Belt", C(110, 80, 50) } } } end,
	Loki = function(s) return { colors = { Head = SKIN, Legs = C(25, 25, 30) },
		pieces = { { "Cape", s.Primary, C(20, 20, 25) }, { "Hair", C(15, 15, 15), "Long" }, { "Shoulders", s.Secondary } } } end,
	Thanos = function(s) return { colors = { Head = C(130, 90, 160), Arms = s.Secondary, Hands = s.Secondary },
		pieces = { { "Helmet", s.Secondary }, { "Shoulders", s.Secondary }, { "Belt", s.Secondary } } } end,
	Hulk = function(s) return { colors = { Head = s.Primary, Chest = s.Primary, Arms = s.Primary, Hands = s.Primary, Waist = s.Secondary, Legs = s.Secondary, Feet = s.Primary },
		pieces = { { "Hair", C(20, 20, 20), "Spiky" } } } end,
	Venom = function(s) return { colors = { Head = s.Primary, Hands = s.Primary, Feet = s.Primary, Legs = s.Primary },
		pieces = { { "Eyes", WHITE }, { "Emblem", "✱", s.Secondary } } } end,
	GreenGoblin = function(s) return { colors = { Head = s.Primary, Hands = s.Secondary, Feet = s.Secondary },
		pieces = { { "Eyes", C(255, 230, 60) }, { "Spikes", s.Primary }, { "Belt", s.Secondary } } } end,
	Batman = function(s) return { colors = { Head = SKIN, Hands = s.Secondary, Feet = s.Secondary, Waist = s.Secondary },
		pieces = { { "Cowl", s.Secondary, 0.6, SKIN }, { "Eyes", WHITE }, { "Cape", s.Secondary }, { "Emblem", "🦇", C(0, 0, 0), C(255, 215, 60), Enum.PartType.Cylinder },
			{ "Belt", C(255, 205, 60), { color = C(255, 215, 80) } }, { "Cuffs", s.Secondary, true } } } end,
	Superman = function(s) return { colors = { Head = SKIN, Hands = s.Primary, Feet = s.Secondary, Waist = s.Secondary },
		pieces = { { "Cape", s.Secondary }, { "Hair", C(15, 15, 20) }, { "Emblem", "S", s.Secondary, C(255, 215, 40) }, { "Belt", C(255, 215, 40) } } } end,
	Flash = function(s) return { colors = { Head = s.Primary, Hands = s.Primary, Feet = s.Secondary, Legs = s.Primary },
		pieces = { { "Emblem", "ϟ", s.Secondary, WHITE, Enum.PartType.Cylinder }, { "Belt", s.Secondary }, { "Eyes", WHITE } } } end,
	WonderWoman = function(s) return { colors = { Head = SKIN, Arms = SKIN, Legs = SKIN, Feet = s.Primary },
		pieces = { { "Hair", C(20, 15, 15), "Long" }, { "Emblem", "W", GOLD }, { "Belt", GOLD }, { "Cuffs", C(200, 200, 210) } } } end,
	HarleyQuinn = function(s) return { colors = { Head = WHITE },
		pieces = { { "Hair", C(250, 240, 200), "Pigtails" }, { "Emblem", "♦", s.Secondary } } } end,
	Joker = function(s) return { colors = { Head = WHITE, Hands = C(240, 240, 240), Legs = s.Primary },
		pieces = { { "Hair", C(60, 160, 60) }, { "Belt", s.Secondary } } } end,
	Deathstroke = function(s) return { colors = { Head = s.Primary, Arms = s.Secondary },
		pieces = { { "Helmet", s.Primary, s.Secondary }, { "Visor", s.Primary, C(20, 20, 20) }, { "Belt", C(60, 50, 40) }, { "Shoulders", s.Primary } } } end,
	BlackAdam = function(s) return { colors = { Head = SKIN, Hands = s.Secondary, Feet = s.Secondary },
		pieces = { { "Cape", C(240, 240, 245) }, { "Hair", C(15, 15, 15) }, { "Emblem", "ϟ", s.Secondary }, { "Belt", s.Secondary } } } end,
	Darkseid = function(s) return { colors = { Head = s.Primary, Arms = s.Secondary, Hands = s.Secondary },
		pieces = { { "Eyes", C(255, 40, 40) }, { "Shoulders", s.Secondary }, { "Belt", s.Secondary } } } end,
	Nova = function(s) return { colors = { Head = s.Secondary, Arms = s.Primary, Hands = s.Secondary, Feet = s.Secondary },
		pieces = { { "Helmet", s.Secondary, nil, C(220, 30, 40) }, { "Eyes", WHITE }, { "NovaOrbs", s.Secondary }, { "Belt", s.Secondary }, { "Shoulders", s.Secondary } } } end,
	Cyclops = function(s) return { colors = { Head = SKIN, Chest = s.Primary, Waist = s.Primary, Arms = s.Primary, Legs = s.Primary, Hands = s.Secondary, Boots = s.Secondary },
		pieces = { { "Hair", C(130, 60, 30), "Spiky" }, { "Visor", s.Secondary, C(255, 30, 30) }, { "Harness", s.Secondary, "X" }, { "Bands", s.Secondary },
			{ "Belt", s.Secondary, { color = C(190, 20, 20), text = "X", textColor = C(110, 10, 10) } } } } end,
	GhostRider = function(s) return { colors = { Head = C(235, 228, 210), Chest = s.Primary, Waist = s.Primary, Arms = s.Primary, Hands = s.Primary, Legs = s.Primary, Feet = C(20, 20, 22) },
		pieces = { { "Material", Enum.Material.Leather }, { "FlamingSkull", s.Flame, s.Flame2 }, { "BikerJacket", s.Primary, s.Secondary },
			{ "Shoulders", s.Primary, true, s.Secondary }, { "Studs", s.Secondary }, { "GloveBootSpikes", s.Secondary },
			{ "Chains", s.Secondary }, { "ArmChain", s.Secondary } } } end,
	RedHood = function(s) return { colors = { Head = s.Primary, Hands = C(25, 25, 30), Feet = C(25, 25, 30) },
		pieces = { { "Helmet", s.Primary }, { "Eyes", WHITE }, { "Emblem", "🦇", C(0, 0, 0), s.Primary }, { "Belt", C(60, 50, 40) }, { "Cape", s.Secondary } } } end,
}

local GROUPS = {
	Head = { "Head" }, Chest = { "UpperTorso", "Torso" }, Waist = { "LowerTorso", "Belt" },
	Arms = { "LeftUpperArm", "RightUpperArm", "LeftLowerArm", "RightLowerArm", "LeftArm", "RightArm" },
	Hands = { "LeftHand", "RightHand" },
	Legs = { "LeftUpperLeg", "RightUpperLeg", "LeftLowerLeg", "RightLowerLeg", "LeftLeg", "RightLeg" },
	Feet = { "LeftFoot", "RightFoot" },
	Boots = { "LeftLowerLeg", "RightLowerLeg", "LeftFoot", "RightFoot" },
}

function Costume.Apply(m, heroId, skin)
	local def = Costume.Heroes[heroId] and Costume.Heroes[heroId](skin)
	if not def then return end
	local colors = table.clone(def.colors or {})
	for k, v in skin.Colors or {} do colors[k] = v end -- per-variant overrides
	for _, group in { "Head", "Chest", "Waist", "Arms", "Hands", "Legs", "Feet", "Boots" } do
		local color = colors[group]
		if color then for _, n in GROUPS[group] do local p = m:FindFirstChild(n); if p then p.Color = color end end end
	end
	local list = table.clone(skin.Pieces or def.pieces)
	for _, extra in skin.Extra or {} do table.insert(list, extra) end
	for _, entry in list do
		local fn = P[entry[1]]
		if fn then fn(m, table.unpack(entry, 2)) end
	end
end
return Costume
