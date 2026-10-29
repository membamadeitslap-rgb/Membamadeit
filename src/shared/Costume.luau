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
-- Rounded piece: ellipsoid filling `size` (helmets, cowls, hair, muscles...)
local function round(m, anchor, name, size, offset, color, mat)
	local p = piece(m, anchor, name, size, offset, color, mat)
	local sm = Instance.new("SpecialMesh"); sm.MeshType = Enum.MeshType.Sphere; sm.Parent = p
	return p
end
-- Round band around a limb (cuffs, armbands, boot tops): cylinder along the anchor's Y axis
local function band(m, anchor, name, diameter, height, offset, color, mat)
	local p = piece(m, anchor, name, Vector3.new(height, diameter, diameter), offset * CFrame.Angles(0, 0, math.rad(90)), color, mat, Enum.PartType.Cylinder)
	return p
end
-- Elliptical ring around the torso/waist (belts, collars): n flat segments tangent to the ellipse
local function ring(m, anchor, name, rx, rz, height, thick, offset, color, mat, n)
	n = n or 16
	local parts = {}
	for i = 0, n - 1 do
		local a0, a1 = i / n * math.pi * 2, (i + 1) / n * math.pi * 2
		local p0 = Vector3.new(math.sin(a0) * rx, 0, -math.cos(a0) * rz)
		local p1 = Vector3.new(math.sin(a1) * rx, 0, -math.cos(a1) * rz)
		local mid = (p0 + p1) / 2
		local len = (p1 - p0).Magnitude * 1.08
		local cf = CFrame.lookAt(mid, mid + (p1 - p0)) * CFrame.Angles(0, math.rad(90), 0)
		table.insert(parts, piece(m, anchor, name, Vector3.new(len, height, thick), offset * cf, color, mat))
	end
	return parts
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
	round(m, t, "CapeCollar", Vector3.new(t.Size.X * 0.78, 0.35, t.Size.Z * 1.05), CFrame.new(0, h / 2 - 0.02, 0.05), color, Enum.Material.Fabric)
end
-- Bat cowl: mask shell + two ears; earLen 0.6 = TAS/classic, 1.1 = Longest Halloween / BTAS long ears
function P.Cowl(m, color, earLen, jaw)
	local hd = find(m, "Head"); if not hd then return end
	local s = hd.Size
	round(m, hd, "Cowl", Vector3.new(s.X * 1.1, s.Y * 1.02, s.Z * 1.1), CFrame.new(0, s.Y * 0.2, 0.02), color)
	for _, x in { -1, 1 } do -- pointed ears: wedge pair forming a tapered spike
		local len = s.Y * (earLen or 0.6)
		for _, flip in { 0, 180 } do
			local e = piece(m, hd, "Ear", Vector3.new(s.X * 0.08, len, s.Z * 0.2), CFrame.new(x * s.X * 0.28, s.Y * 0.58 + len / 2, 0) * CFrame.Angles(0, math.rad(flip), math.rad(-x * 6)) * CFrame.new(-s.X * 0.04, 0, 0), color)
			local sm = Instance.new("SpecialMesh"); sm.MeshType = Enum.MeshType.Wedge; sm.Parent = e
		end
	end
	if jaw then piece(m, hd, "Jaw", Vector3.new(s.X * 0.7, s.Y * 0.32, s.Z * 0.2), CFrame.new(0, -s.Y * 0.3, -s.Z * 0.45), jaw) end -- skin-tone jaw
end
-- Full helmet (Iron Man, Red Hood, Nova); faceplate color + optional crest
function P.Helmet(m, color, plate, crest)
	local hd = find(m, "Head"); if not hd then return end
	local s = hd.Size
	round(m, hd, "Helmet", Vector3.new(s.X * 1.14, s.Y * 1.14, s.Z * 1.12), CFrame.new(0, s.Y * 0.04, 0), color)
	if plate then piece(m, hd, "Faceplate", Vector3.new(s.X * 0.8, s.Y * 0.85, 0.1), CFrame.new(0, -s.Y * 0.04, -s.Z * 0.56), plate) end
	if crest == "Fin" then piece(m, hd, "Fin", Vector3.new(0.15, s.Y * 0.5, s.Z * 0.9), CFrame.new(0, s.Y * 0.58, 0), color)
	elseif crest then -- Nova star crest
		local c = piece(m, hd, "Crest", Vector3.new(s.X * 0.6, s.Y * 0.5, 0.1), CFrame.new(0, s.Y * 0.35, -s.Z * 0.58), crest, Enum.Material.SmoothPlastic)
		c.Transparency = 1; glyph(c, Enum.NormalId.Front, "✦", crest)
	end
end
-- Glowing eye slits (Iron Man white, Batman white, Superman red heat vision...)
function P.Eyes(m, color)
	local hd = find(m, "Head"); if not hd then return end
	local s = hd.Size
	for _, x in { -0.2, 0.2 } do
		piece(m, hd, "Eye", Vector3.new(s.X * 0.22, s.Y * 0.08, 0.06), CFrame.new(x * s.X, s.Y * 0.08, -s.Z * 0.57) * CFrame.Angles(0, math.rad(x * 40), 0), color or C(255, 255, 255), Enum.Material.SmoothPlastic)
	end
end
-- Cyclops visor / Deathstroke band: single wide glowing band
function P.Visor(m, frame, glow)
	local hd = find(m, "Head"); if not hd then return end
	local s = hd.Size
	piece(m, hd, "VisorFrame", Vector3.new(s.X * 1.1, s.Y * 0.24, s.Z * 1.06), CFrame.new(0, s.Y * 0.08, 0), frame)
	piece(m, hd, "VisorGlow", Vector3.new(s.X * 0.7, s.Y * 0.08, 0.06), CFrame.new(0, s.Y * 0.08, -s.Z * 0.56), glow, Enum.Material.Glass)
	for _, x in { -1, 1 } do -- ear pods
		piece(m, hd, "VisorPod", Vector3.new(0.12, s.Y * 0.34, s.Z * 0.34), CFrame.new(x * s.X * 0.56, 0, 0), frame)
	end
end
function P.Hair(m, color, style)
	local hd = find(m, "Head"); if not hd then return end
	local s = hd.Size
	round(m, hd, "Hair", Vector3.new(s.X * 1.1, s.Y * 0.62, s.Z * 1.12), CFrame.new(0, s.Y * 0.33, s.Z * 0.05), color)
	if style == "Spiky" then
		for row, zf in { -0.3, 0.05, 0.38 } do -- three rows of spikes, swept up and back
			for i = -2, 2 do
				local sp = piece(m, hd, "Spike", Vector3.new(0.2, s.Y * (0.42 - math.abs(i) * 0.05), 0.2),
					CFrame.new(i * s.X * 0.2, s.Y * 0.62, zf * s.Z) * CFrame.Angles(math.rad(-20 - row * 8), 0, math.rad(-i * 18)), color)
				local sm = Instance.new("SpecialMesh"); sm.MeshType = Enum.MeshType.Wedge; sm.Parent = sp
			end
		end
	elseif style == "Pigtails" then
		for _, x in { -0.62, 0.62 } do round(m, hd, "Pigtail", Vector3.new(s.X * 0.32, s.Y * 0.95, s.Z * 0.32), CFrame.new(x * s.X, s.Y * 0.05, s.Z * 0.2) * CFrame.Angles(0, 0, math.rad(x * 25)), color) end
	elseif style == "Long" then
		round(m, hd, "HairBack", Vector3.new(s.X * 1.08, s.Y * 1.5, s.Z * 0.5), CFrame.new(0, -s.Y * 0.2, s.Z * 0.36), color)
	end
end
-- Chest emblem drawn as a glyph on a colored plate (bat oval, S shield, X, star, spider, triangle...)
function P.Emblem(m, text, color, plate, oval)
	local t = chestOf(m); if not t then return end
	local s = t.Size
	local p = piece(m, t, "Emblem", Vector3.new(s.X * 0.62, s.Y * 0.42, 0.08), CFrame.new(0, s.Y * 0.12, -s.Z / 2 - 0.05), plate or color, plate and Enum.Material.SmoothPlastic or Enum.Material.Neon)
	if not plate then p.Transparency = 1 end
	if plate and oval then local sm = Instance.new("SpecialMesh"); sm.MeshType = Enum.MeshType.Sphere; sm.Scale = Vector3.new(1, 1, 0.4); sm.Parent = p end
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
	ring(m, w, "Belt", s.X * 0.52, s.Z * 0.55, 0.3, 0.12, CFrame.new(0, y, 0), color)
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
	local spots = { LeftUpperArm = 0.05, RightUpperArm = 0.05, LeftLowerArm = -0.36, RightLowerArm = -0.36, LeftUpperLeg = 0.05, RightUpperLeg = 0.05, LeftLowerLeg = 0.42, RightLowerLeg = 0.42 }
	for name, y in spots do
		local a = m:FindFirstChild(name)
		if a then
			local s = a.Size
			band(m, a, "Band", s.X * 1.08, s.Y * (name:find("Lower") and 0.3 or 0.18), CFrame.new(0, y * s.Y, 0), color)
		end
	end
end
function P.Shoulders(m, color, spiky, spikeColor)
	for _, n in { "LeftUpperArm", "RightUpperArm", "LeftArm", "RightArm" } do
		local a = m:FindFirstChild(n)
		if a then
			local s = a.Size
			local h = a.Name:find("Upper") and s.Y * 0.4 or s.Y * 0.4
			round(m, a, "Pad", Vector3.new(s.X * 1.55, s.Y * 0.62, s.Z * 1.45), CFrame.new(a.Name:find("Left") and -s.X * 0.08 or s.X * 0.08, h, 0), color)
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
			band(m, a, "Cuff", s.X * 1.1, s.Y * 0.32, CFrame.new(0, -s.Y * 0.3, 0), color, Enum.Material.Metal)
			if fins then piece(m, a, "Fin", Vector3.new(0.1, s.Y * 0.35, s.Z * 0.5), CFrame.new(a.Name:find("Left") and -s.X * 0.6 or s.X * 0.6, -s.Y * 0.2, 0), color) end
		end
	end
end
-- Ghost Rider: bone-white skull with dark sockets/teeth, burning head (Fire + embers)
-- Realistic hellfire: layered particle flames (white-hot core -> flame color -> red -> smoke) + sparks.
-- Uses Roblox's built-in fire/smoke particle textures instead of the cartoony Fire object.
local FIRE_TEX, SMOKE_TEX, SPARK_TEX = "rbxasset://textures/particles/fire_main.dds", "rbxasset://textures/particles/smoke_main.dds", "rbxasset://textures/particles/sparkles_main.dds"
local function hellfire(parent, flame, flame2, scale, rate, zoff)
	scale, rate = scale or 1, rate or 1
	local function emitter(name, tex, props)
		local pe = Instance.new("ParticleEmitter"); pe.Name = name; pe.Texture = tex
		pe.EmissionDirection = Enum.NormalId.Top; pe.LockedToPart = false
		for k, v in props do pe[k] = v end
		pe.ZOffset = zoff or 0
		pe.Parent = parent; return pe
	end
	emitter("FlameCore", FIRE_TEX, { LightEmission = 1, LightInfluence = 0, Rate = 60 * rate,
		Color = ColorSequence.new({ ColorSequenceKeypoint.new(0, Color3.new(1, 1, 0.9)), ColorSequenceKeypoint.new(0.3, flame2), ColorSequenceKeypoint.new(1, flame) }),
		Size = NumberSequence.new({ NumberSequenceKeypoint.new(0, 1.1 * scale), NumberSequenceKeypoint.new(0.6, 0.8 * scale), NumberSequenceKeypoint.new(1, 0) }),
		Transparency = NumberSequence.new({ NumberSequenceKeypoint.new(0, 0.2), NumberSequenceKeypoint.new(0.7, 0.4), NumberSequenceKeypoint.new(1, 1) }),
		Lifetime = NumberRange.new(0.35, 0.6), Speed = NumberRange.new(3 * scale, 5 * scale), SpreadAngle = Vector2.new(18, 18),
		Rotation = NumberRange.new(-30, 30), RotSpeed = NumberRange.new(-90, 90), Acceleration = Vector3.new(0, 4, 0) })
	emitter("FlameOuter", FIRE_TEX, { LightEmission = 0.5, LightInfluence = 0, Rate = 45 * rate,
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
		piece(m, hd, "Pupil", Vector3.new(0.07, 0.07, 0.04), CFrame.new(x * s.X * 0.2, s.Y * 0.02, -s.Z * 0.53), flame2, Enum.Material.SmoothPlastic)
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
	local crown = piece(m, hd, "FlameCrown", Vector3.new(s.X * 0.75, 0.1, s.Z * 0.6), CFrame.new(0, s.Y * 0.5, s.Z * 0.18), flame, Enum.Material.SmoothPlastic)
	crown.Transparency = 1
	hellfire(crown, flame, flame2, s.Y * 0.75, 1.2, -1.5) -- negative ZOffset: flames draw behind the skull, face stays readable
	local collar = chestOf(m)
	if collar then
		local ring = piece(m, collar, "CollarFire", Vector3.new(collar.Size.X * 0.4, 0.1, collar.Size.Z * 0.4), CFrame.new(0, collar.Size.Y / 2, collar.Size.Z * 0.25), flame, Enum.Material.SmoothPlastic)
		ring.Transparency = 1
		hellfire(ring, flame, flame2, 0.4, 0.5, -1.5)
	end
	local l = Instance.new("PointLight"); l.Color = flame; l.Range = 12; l.Brightness = 1.2; l.Parent = crown -- light from above the skull, not inside it
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
-- ===== Accuracy pass pieces =====
local function front(part, depth) return -part.Size.Z / 2 - (depth or 0.03) end

-- Spider-Man style web lines: thin dark grid lines on the front (and back) of the given parts
function P.WebLines(m, color, partNames)
	for _, n in partNames do
		local a = m:FindFirstChild(n)
		if a then
			local s = a.Size
			for _, z in { -1, 1 } do
				for i = -1, 1 do
					piece(m, a, "Web", Vector3.new(0.03, s.Y * 1.0, 0.02), CFrame.new(i * s.X * 0.3, 0, z * (s.Z / 2 + 0.012)), color)
				end
				for j = -1, 1 do
					piece(m, a, "Web", Vector3.new(s.X * 1.0, 0.03, 0.02), CFrame.new(0, j * s.Y * 0.3, z * (s.Z / 2 + 0.012)), color)
				end
			end
		end
	end
end
-- Big angled mask lenses (Spider-Man / Venom / Deadpool style): frame + white lens
function P.Lenses(m, frame, lens, size)
	local hd = find(m, "Head"); if not hd then return end
	local s = hd.Size; size = size or 1
	for _, x in { -1, 1 } do
		local cf = CFrame.new(x * s.X * 0.22, s.Y * 0.06, -s.Z * 0.51) * CFrame.Angles(0, 0, math.rad(x * 28))
		local fr = piece(m, hd, "LensFrame", Vector3.new(s.X * 0.34 * size, s.Y * 0.26 * size, 0.04), cf, frame)
		Instance.new("SpecialMesh", fr).MeshType = Enum.MeshType.Sphere
		local ln = piece(m, hd, "Lens", Vector3.new(s.X * 0.27 * size, s.Y * 0.19 * size, 0.05), cf * CFrame.new(0, 0, -0.01), lens, Enum.Material.SmoothPlastic)
		Instance.new("SpecialMesh", ln).MeshType = Enum.MeshType.Sphere
	end
end
-- Contrasting side panels on the torso (Spider-Man blue sides, Captain America stripes)
function P.SidePanels(m, color, width)
	local t = chestOf(m); if not t then return end
	local s = t.Size
	for _, x in { -1, 1 } do
		piece(m, t, "SidePanel", Vector3.new(s.X * (width or 0.18), s.Y * 1.0, s.Z * 1.04), CFrame.new(x * s.X * (0.5 - (width or 0.18) / 2), 0, 0), color)
	end
end
-- Vertical red/white stripes across the midsection (Captain America)
function P.Stripes(m, a, b)
	local t = chestOf(m); if not t then return end
	local s = t.Size
	for i = -3, 3 do
		piece(m, t, "Stripe", Vector3.new(s.X * 0.1, s.Y * 0.42, 0.04), CFrame.new(i * s.X * 0.1, -s.Y * 0.29, front(t)), i % 2 == 0 and a or b)
	end
end
-- Loki's golden horned helmet: crown band + two long sweeping horns
function P.Horns(m, color)
	local hd = find(m, "Head"); if not hd then return end
	local s = hd.Size
	piece(m, hd, "HornBand", Vector3.new(s.X * 1.08, s.Y * 0.25, s.Z * 1.08), CFrame.new(0, s.Y * 0.3, 0), color, Enum.Material.Metal)
	piece(m, hd, "HornPlate", Vector3.new(s.X * 0.4, s.Y * 0.35, 0.08), CFrame.new(0, s.Y * 0.18, -s.Z * 0.55), color, Enum.Material.Metal)
	for _, x in { -1, 1 } do
		for k = 0, 3 do -- segmented curve sweeping up and back
			piece(m, hd, "Horn", Vector3.new(0.16 - k * 0.025, 0.42, 0.16 - k * 0.025),
				CFrame.new(x * s.X * (0.32 + k * 0.05), s.Y * (0.55 + k * 0.28), -s.Z * 0.3 + k * 0.12) * CFrame.Angles(math.rad(25 + k * 12), 0, math.rad(-x * (8 + k * 6))), color, Enum.Material.Metal)
		end
	end
end
-- Thanos: vertical chin ridges
function P.ChinRidges(m, color)
	local hd = find(m, "Head"); if not hd then return end
	local s = hd.Size
	for i = -2, 2 do piece(m, hd, "Ridge", Vector3.new(0.05, s.Y * 0.32, 0.05), CFrame.new(i * s.X * 0.1, -s.Y * 0.3, -s.Z * 0.52), color) end
end
-- Thor's six silver chest discs (two columns of three)
function P.ChestDiscs(m, color)
	local t = chestOf(m); if not t then return end
	local s = t.Size
	for _, x in { -0.25, 0.25 } do
		for j = 0, 2 do
			local d = piece(m, t, "Disc", Vector3.new(0.06, s.X * 0.16, s.X * 0.16), CFrame.new(x * s.X, s.Y * (0.28 - j * 0.26), front(t, 0.04)) * CFrame.Angles(0, math.rad(90), 0), color, Enum.Material.Metal, Enum.PartType.Cylinder)
		end
	end
end
function P.Beard(m, color)
	local hd = find(m, "Head"); if not hd then return end
	local s = hd.Size
	piece(m, hd, "Beard", Vector3.new(s.X * 0.86, s.Y * 0.36, 0.12), CFrame.new(0, -s.Y * 0.33, -s.Z * 0.5), color)
end
-- Torn shorts hem (Hulk): jagged strips around the thighs
function P.TornHem(m, color)
	for _, n in { "LeftLowerLeg", "RightLowerLeg", "LeftLeg", "RightLeg" } do
		local a = m:FindFirstChild(n)
		if a then
			local s = a.Size
			for i = 0, 5 do
				local ang = i / 6 * math.pi * 2
				piece(m, a, "Tatter", Vector3.new(s.X * 0.3, s.Y * (0.15 + (i % 2) * 0.12), 0.06),
					CFrame.new(math.cos(ang) * s.X * 0.52, -s.Y * 0.38, math.sin(ang) * s.Z * 0.52) * CFrame.Angles(0, -ang + math.pi / 2, 0), color, Enum.Material.Fabric)
			end
		end
	end
end
-- Venom/Carnage mouth: wide jagged grin with teeth and a tongue
function P.Fangs(m, gum, tooth, tongue)
	local hd = find(m, "Head"); if not hd then return end
	local s = hd.Size
	piece(m, hd, "Mouth", Vector3.new(s.X * 0.8, s.Y * 0.26, 0.05), CFrame.new(0, -s.Y * 0.3, -s.Z * 0.51), gum)
	for i = -4, 4 do
		for _, y in { -0.2, -0.4 } do
			local t = piece(m, hd, "Fang", Vector3.new(0.06, s.Y * 0.11, 0.06), CFrame.new(i * s.X * 0.085, y * s.Y, -s.Z * 0.54) * CFrame.Angles(0, 0, y < -0.3 and math.pi or 0), tooth)
			Instance.new("SpecialMesh", t).MeshType = Enum.MeshType.Wedge
		end
	end
	if tongue then piece(m, hd, "Tongue", Vector3.new(s.X * 0.2, s.Y * 0.4, 0.06), CFrame.new(s.X * 0.08, -s.Y * 0.55, -s.Z * 0.55), tongue) end
end
-- Green Goblin: tall floppy pointed hat + pointed ears + shoulder satchel
function P.GoblinHat(m, color)
	local hd = find(m, "Head"); if not hd then return end
	local s = hd.Size
	piece(m, hd, "HatBase", Vector3.new(s.X * 1.08, s.Y * 0.3, s.Z * 1.08), CFrame.new(0, s.Y * 0.38, 0), color, Enum.Material.Fabric)
	for k = 0, 3 do
		piece(m, hd, "HatTip", Vector3.new(s.X * (0.8 - k * 0.18), s.Y * 0.3, s.Z * (0.8 - k * 0.18)), CFrame.new(0, s.Y * (0.62 + k * 0.22), s.Z * k * 0.12) * CFrame.Angles(math.rad(-k * 12), 0, 0), color, Enum.Material.Fabric)
	end
	for _, x in { -1, 1 } do
		local e = piece(m, hd, "Ear", Vector3.new(0.08, s.Y * 0.4, s.Z * 0.22), CFrame.new(x * s.X * 0.56, s.Y * 0.1, 0) * CFrame.Angles(0, 0, math.rad(-x * 25)), find(m, "Head").Color)
		Instance.new("SpecialMesh", e).MeshType = Enum.MeshType.Wedge
	end
end
function P.Satchel(m, color)
	local t = chestOf(m); if not t then return end
	local s = t.Size
	piece(m, t, "Strap", Vector3.new(s.X * 0.1, s.Y * 1.25, 0.06), CFrame.new(0, 0, front(t)) * CFrame.Angles(0, 0, math.rad(35)), color, Enum.Material.Fabric)
	local w = waistOf(m)
	if w then piece(m, w, "Bag", Vector3.new(0.5, 0.55, 0.3), CFrame.new(w.Size.X * 0.55, -0.1, -0.1), color, Enum.Material.Fabric) end
end
-- Superman's diamond shield: red-bordered yellow diamond with a red S
function P.Shield(m, border, fill, letter)
	local t = chestOf(m); if not t then return end
	local s = t.Size
	local cf = CFrame.new(0, s.Y * 0.15, front(t, 0.02))
	local outer = piece(m, t, "ShieldBorder", Vector3.new(s.Y * 0.5, s.Y * 0.5, 0.04), cf * CFrame.Angles(0, 0, math.rad(45)), border)
	local inner = piece(m, t, "ShieldFill", Vector3.new(s.Y * 0.4, s.Y * 0.4, 0.05), cf * CFrame.new(0, 0, -0.01) * CFrame.Angles(0, 0, math.rad(45)), fill)
	local g = piece(m, t, "ShieldS", Vector3.new(s.Y * 0.42, s.Y * 0.42, 0.02), cf * CFrame.new(0, 0, -0.04), fill); g.Transparency = 1
	glyph(g, Enum.NormalId.Front, "S", letter, Enum.Font.GothamBlack)
end
-- Flash: lightning-bolt ear wings on the cowl
function P.EarWings(m, color)
	local hd = find(m, "Head"); if not hd then return end
	local s = hd.Size
	for _, x in { -1, 1 } do
		for k = 0, 1 do
			local w = piece(m, hd, "Wing", Vector3.new(0.06, s.Y * 0.18, s.Z * 0.4), CFrame.new(x * s.X * 0.56, s.Y * (0.12 + k * 0.16), s.Z * (0.05 + k * 0.1)) * CFrame.Angles(math.rad(-30 - k * 10), 0, 0), color, Enum.Material.Metal)
			Instance.new("SpecialMesh", w).MeshType = Enum.MeshType.Wedge
		end
	end
end
-- Half-face skin opening (Flash, Batman-like cowls without a separate cowl piece)
function P.JawOpening(m, skin)
	local hd = find(m, "Head"); if not hd then return end
	local s = hd.Size
	piece(m, hd, "Jaw", Vector3.new(s.X * 0.82, s.Y * 0.36, s.Z * 0.5), CFrame.new(0, -s.Y * 0.3, -s.Z * 0.33), skin) -- protrudes past helmets
end
-- Wonder Woman: tiara with red star, and a gold lasso coil on the hip
function P.Tiara(m, gold, star)
	local hd = find(m, "Head"); if not hd then return end
	local s = hd.Size
	piece(m, hd, "Tiara", Vector3.new(s.X * 1.06, s.Y * 0.1, s.Z * 1.06), CFrame.new(0, s.Y * 0.28, 0), gold, Enum.Material.Metal)
	local st = piece(m, hd, "TiaraStar", Vector3.new(s.X * 0.3, s.Y * 0.3, 0.06), CFrame.new(0, s.Y * 0.3, -s.Z * 0.56), star); st.Transparency = 1
	glyph(st, Enum.NormalId.Front, "★", star)
end
function P.Lasso(m, color)
	local w = waistOf(m); if not w then return end
	local ring = piece(m, w, "Lasso", Vector3.new(0.18, 0.75, 0.75), CFrame.new(w.Size.X * 0.56, -0.1, 0) * CFrame.Angles(0, 0, 0), color, Enum.Material.Neon, Enum.PartType.Cylinder)
	ring.Transparency = 0.2
end
-- Harley: harlequin split (left side c1, right side c2) + jester cowl with two tassels + domino mask
function P.Harlequin(m, c1, c2)
	for _, p in m:GetChildren() do
		if p:IsA("BasePart") and p.Name ~= "Head" and p.Name ~= "HumanoidRootPart" and not p.Name:find("Costume_") then
			if p.Name:find("Left") then p.Color = c1 elseif p.Name:find("Right") then p.Color = c2 end
		end
	end
	for _, n in { "UpperTorso", "LowerTorso", "Torso" } do
		local t = m:FindFirstChild(n)
		if t then t.Color = c1; piece(m, t, "Half", Vector3.new(t.Size.X * 0.5, t.Size.Y, t.Size.Z * 1.02), CFrame.new(t.Size.X * 0.25, 0, 0), c2) end
	end
	local t = chestOf(m)
	if t then for _, x in { -1, 1 } do -- diamonds on the chest
		local d = piece(m, t, "Diamond", Vector3.new(0.3, 0.3, 0.04), CFrame.new(x * t.Size.X * 0.25, t.Size.Y * 0.1, front(t)) * CFrame.Angles(0, 0, math.rad(45)), x < 0 and c2 or c1)
	end end
end
function P.JesterCowl(m, c1, c2, pom)
	local hd = find(m, "Head"); if not hd then return end
	local s = hd.Size
	piece(m, hd, "CowlL", Vector3.new(s.X * 0.54, s.Y * 0.7, s.Z * 1.06), CFrame.new(-s.X * 0.26, s.Y * 0.2, 0.02), c1, Enum.Material.Fabric)
	piece(m, hd, "CowlR", Vector3.new(s.X * 0.54, s.Y * 0.7, s.Z * 1.06), CFrame.new(s.X * 0.26, s.Y * 0.2, 0.02), c2, Enum.Material.Fabric)
	for _, x in { -1, 1 } do
		piece(m, hd, "Tassel", Vector3.new(0.3, s.Y * 0.7, 0.3), CFrame.new(x * s.X * 0.7, s.Y * 0.5, 0) * CFrame.Angles(0, 0, math.rad(-x * 50)), x < 0 and c1 or c2, Enum.Material.Fabric)
		local b = piece(m, hd, "Pom", Vector3.one * 0.3, CFrame.new(x * s.X * 1.0, s.Y * 0.68, 0), pom, Enum.Material.Fabric, Enum.PartType.Ball)
	end
	piece(m, hd, "Domino", Vector3.new(s.X * 0.8, s.Y * 0.16, 0.05), CFrame.new(0, s.Y * 0.06, -s.Z * 0.52), C(15, 15, 15))
end
-- Joker: red smile, vest, lapels, bow tie
function P.Smile(m, color)
	local hd = find(m, "Head"); if not hd then return end
	local s = hd.Size
	piece(m, hd, "Smile", Vector3.new(s.X * 0.6, s.Y * 0.07, 0.04), CFrame.new(0, -s.Y * 0.28, -s.Z * 0.51), color)
	for _, x in { -1, 1 } do piece(m, hd, "SmileEnd", Vector3.new(s.X * 0.12, s.Y * 0.07, 0.04), CFrame.new(x * s.X * 0.33, -s.Y * 0.22, -s.Z * 0.51) * CFrame.Angles(0, 0, math.rad(x * 35)), color) end
end
function P.SuitFront(m, vest, shirt, tie, lapel)
	local t = chestOf(m); if not t then return end
	local s = t.Size
	piece(m, t, "Vest", Vector3.new(s.X * 0.42, s.Y * 0.9, 0.04), CFrame.new(0, -s.Y * 0.05, front(t)), vest)
	piece(m, t, "Shirt", Vector3.new(s.X * 0.14, s.Y * 0.4, 0.05), CFrame.new(0, s.Y * 0.28, front(t, 0.04)), shirt)
	piece(m, t, "Tie", Vector3.new(s.X * 0.26, s.Y * 0.1, 0.07), CFrame.new(0, s.Y * 0.4, front(t, 0.06)), tie)
	for _, x in { -1, 1 } do
		piece(m, t, "Lapel", Vector3.new(s.X * 0.12, s.Y * 0.8, 0.05), CFrame.new(x * s.X * 0.26, s.Y * 0.0, front(t, 0.05)) * CFrame.Angles(0, 0, math.rad(x * 12)), lapel)
	end
end
-- Deathstroke: half-and-half mask (one eye socket only)
function P.HalfMask(m, a, b, eye)
	local hd = find(m, "Head"); if not hd then return end
	local s = hd.Size
	piece(m, hd, "MaskL", Vector3.new(s.X * 0.54, s.Y * 1.06, s.Z * 1.06), CFrame.new(-s.X * 0.26, 0, 0), a)
	piece(m, hd, "MaskR", Vector3.new(s.X * 0.54, s.Y * 1.06, s.Z * 1.06), CFrame.new(s.X * 0.26, 0, 0), b)
	piece(m, hd, "EyeSlit", Vector3.new(s.X * 0.26, s.Y * 0.1, 0.05), CFrame.new(-s.X * 0.22, s.Y * 0.08, -s.Z * 0.55), eye) -- left eye only; right side is solid
	piece(m, hd, "MaskSeam", Vector3.new(0.04, s.Y * 1.08, s.Z * 1.08), CFrame.new(0, 0, 0), C(20, 20, 20))
end
-- Darkseid: craggy stone ridges on the face
function P.Craggy(m, color)
	local hd = find(m, "Head"); if not hd then return end
	local s = hd.Size
	for i, o in { { -0.25, 0.25 }, { 0.25, 0.25 }, { -0.2, -0.1 }, { 0.2, -0.1 }, { 0, -0.35 }, { -0.3, -0.3 }, { 0.3, -0.3 } } do
		piece(m, hd, "Crag", Vector3.new(s.X * 0.18, 0.06, 0.06), CFrame.new(o[1] * s.X, o[2] * s.Y, -s.Z * 0.52) * CFrame.Angles(0, 0, math.rad(i * 23)), color)
	end
	piece(m, hd, "Hood", Vector3.new(s.X * 1.1, s.Y * 0.5, s.Z * 1.1), CFrame.new(0, s.Y * 0.35, 0.03), C(40, 50, 90))
end
-- Knee pads (Ghost Rider reference), kneecaps on the lower legs
function P.KneePads(m, color)
	for _, n in { "LeftLowerLeg", "RightLowerLeg", "LeftLeg", "RightLeg" } do
		local a = m:FindFirstChild(n)
		if a then piece(m, a, "KneePad", Vector3.new(a.Size.X * 0.7, a.Size.Y * 0.32, 0.1), CFrame.new(0, a.Size.Y * (a.Name:find("Lower") and 0.32 or 0.05), -a.Size.Z / 2 - 0.05), color, Enum.Material.Leather) end
	end
end
-- Belt pouches (Cyclops, Batman, Red Hood)
function P.Pouches(m, color, n)
	local w = waistOf(m); if not w then return end
	local s = w.Size; local y = w.Name == "Torso" and -s.Y * 0.42 or s.Y * 0.3
	for i = 1, n or 4 do
		local x = (i - (n or 4) / 2 - 0.5) * s.X * 0.22
		if math.abs(x) > s.X * 0.12 then piece(m, w, "Pouch", Vector3.new(s.X * 0.15, 0.3, 0.12), CFrame.new(x, y, -s.Z * 0.56), color) end
	end
end
-- Repulsor glow on the palms (Iron Man)
function P.PalmGlow(m, color)
	for _, n in { "LeftHand", "RightHand" } do
		local h = m:FindFirstChild(n)
		if h then
			local g = piece(m, h, "Repulsor", Vector3.new(h.Size.X * 0.5, 0.05, h.Size.Z * 0.5), CFrame.new(0, -h.Size.Y / 2 - 0.02, 0), color, Enum.Material.Neon)
			local l = Instance.new("PointLight"); l.Color = color; l.Range = 6; l.Parent = g
		end
	end
end
-- Cap's A-helmet: white A on the forehead + white wings at the temples
function P.CapHelmet(m, blue, white)
	local hd = find(m, "Head"); if not hd then return end
	local s = hd.Size
	piece(m, hd, "Cowl", Vector3.new(s.X * 1.05, s.Y * 0.62, s.Z * 1.05), CFrame.new(0, s.Y * 0.2, 0), blue)
	local a = piece(m, hd, "A", Vector3.new(s.X * 0.32, s.Y * 0.3, 0.05), CFrame.new(0, s.Y * 0.3, -s.Z * 0.54), white); a.Transparency = 1
	glyph(a, Enum.NormalId.Front, "A", white)
	for _, x in { -1, 1 } do
		for k = 0, 2 do
			piece(m, hd, "Wing", Vector3.new(0.05, s.Y * 0.08, s.Z * (0.4 - k * 0.08)), CFrame.new(x * s.X * 0.54, s.Y * (0.12 + k * 0.1), s.Z * 0.05), white)
		end
	end
end
-- Iron Man faceplate details (mouth slit + gold plate shape)
function P.IronFace(m, plate)
	local hd = find(m, "Head"); if not hd then return end
	local s = hd.Size
	piece(m, hd, "MouthSlit", Vector3.new(s.X * 0.3, 0.03, 0.03), CFrame.new(0, -s.Y * 0.3, -s.Z * 0.58), C(20, 20, 20))
	piece(m, hd, "Chin", Vector3.new(s.X * 0.45, s.Y * 0.18, 0.06), CFrame.new(0, -s.Y * 0.42, -s.Z * 0.56), plate)
end
-- ===== Detailed faces =====
-- Unmasked comic face: brows, eyes (white + iris + pupil + lid line), nose, mouth, ears. style: "neutral"|"angry"|"smirk"|"grin"
function P.Face(m, iris, brow, style, lip)
	local hd = find(m, "Head"); if not hd then return end
	local s = hd.Size
	local skin = hd.Color
	local dark = skin:Lerp(C(0, 0, 0), 0.55)
	style = style or "neutral"
	local fz = -s.Z * 0.505
	for _, x in { -1, 1 } do
		local ex = x * s.X * 0.19
		piece(m, hd, "Sclera", Vector3.new(s.X * 0.17, s.Y * 0.09, 0.03), CFrame.new(ex, s.Y * 0.06, fz), C(250, 250, 250))
		piece(m, hd, "Iris", Vector3.new(s.X * 0.07, s.Y * 0.08, 0.035), CFrame.new(ex + x * -0.01, s.Y * 0.055, fz - 0.005), iris or C(70, 110, 170))
		piece(m, hd, "Pupil", Vector3.new(s.X * 0.03, s.Y * 0.04, 0.04), CFrame.new(ex + x * -0.01, s.Y * 0.055, fz - 0.01), C(10, 10, 12))
		piece(m, hd, "Lid", Vector3.new(s.X * 0.19, 0.03, 0.04), CFrame.new(ex, s.Y * 0.11, fz - 0.005), dark)
		local tilt = (style == "angry" and 18 or style == "smirk" and (x > 0 and -10 or 6) or 4) * x
		piece(m, hd, "Brow", Vector3.new(s.X * 0.22, s.Y * 0.05, 0.05), CFrame.new(ex, s.Y * 0.17, fz - 0.01) * CFrame.Angles(0, 0, math.rad(-tilt)), brow or C(40, 30, 25))
		piece(m, hd, "Ear", Vector3.new(0.08, s.Y * 0.26, s.Z * 0.2), CFrame.new(x * s.X * 0.52, s.Y * 0.02, 0.02), skin)
	end
	local nose = piece(m, hd, "Nose", Vector3.new(s.X * 0.11, s.Y * 0.16, 0.08), CFrame.new(0, -s.Y * 0.06, fz - 0.03), skin:Lerp(C(0, 0, 0), 0.08))
	Instance.new("SpecialMesh", nose).MeshType = Enum.MeshType.Wedge
	piece(m, hd, "NoseShadow", Vector3.new(s.X * 0.12, 0.025, 0.03), CFrame.new(0, -s.Y * 0.145, fz), dark)
	local mouthW = style == "grin" and 0.42 or 0.26
	piece(m, hd, "Mouth", Vector3.new(s.X * mouthW, s.Y * (style == "grin" and 0.07 or 0.035), 0.04), CFrame.new(0, -s.Y * 0.27, fz) * CFrame.Angles(0, 0, math.rad(style == "smirk" and 6 or 0)), lip or dark)
	if style == "grin" then
		piece(m, hd, "Teeth", Vector3.new(s.X * 0.36, s.Y * 0.035, 0.045), CFrame.new(0, -s.Y * 0.26, fz - 0.005), C(250, 250, 245))
	end
	piece(m, hd, "Chin", Vector3.new(s.X * 0.14, 0.025, 0.03), CFrame.new(0, -s.Y * 0.38, fz), dark)
end
-- Lower face under a cowl / helmet (Batman, Cap, Flash, Nova, Cyclops): nose, mouth, chin cleft
function P.LowerFace(m, style)
	local hd = find(m, "Head"); if not hd then return end
	local s = hd.Size
	local skin = Costume.SKIN
	local dark = skin:Lerp(C(0, 0, 0), 0.55)
	local fz = -s.Z * 0.56
	local nose = piece(m, hd, "Nose", Vector3.new(s.X * 0.1, s.Y * 0.12, 0.08), CFrame.new(0, -s.Y * 0.1, fz - 0.03), skin)
	Instance.new("SpecialMesh", nose).MeshType = Enum.MeshType.Wedge
	piece(m, hd, "Mouth", Vector3.new(s.X * 0.26, s.Y * 0.035, 0.04), CFrame.new(0, -s.Y * 0.28, fz) * CFrame.Angles(0, 0, math.rad(style == "smirk" and 6 or 0)), dark)
	piece(m, hd, "Cleft", Vector3.new(0.025, s.Y * 0.06, 0.03), CFrame.new(0, -s.Y * 0.4, fz), dark)
	piece(m, hd, "Jawline", Vector3.new(s.X * 0.6, 0.025, 0.03), CFrame.new(0, -s.Y * 0.45, fz + 0.02), dark)
end
-- Thor (Kirby): silver winged helmet
function P.WingedHelmet(m, metal)
	local hd = find(m, "Head"); if not hd then return end
	local s = hd.Size
	piece(m, hd, "Helm", Vector3.new(s.X * 1.06, s.Y * 0.42, s.Z * 1.06), CFrame.new(0, s.Y * 0.32, 0), metal, Enum.Material.Metal)
	piece(m, hd, "Nasal", Vector3.new(s.X * 0.1, s.Y * 0.28, 0.06), CFrame.new(0, s.Y * 0.14, -s.Z * 0.55), metal, Enum.Material.Metal)
	for _, x in { -1, 1 } do
		for k = 0, 2 do
			local w = piece(m, hd, "Wing", Vector3.new(0.06, s.Y * (0.5 - k * 0.1), s.Z * 0.3), CFrame.new(x * s.X * 0.56, s.Y * (0.45 + k * 0.08), s.Z * (0.05 + k * 0.14)) * CFrame.Angles(math.rad(-20 - k * 15), 0, math.rad(-x * 20)), metal, Enum.Material.Metal)
			Instance.new("SpecialMesh", w).MeshType = Enum.MeshType.Wedge
		end
	end
end
-- Thor's high strapped boots: cross straps up the lower legs
function P.StrappedBoots(m, strap)
	for _, n in { "LeftLowerLeg", "RightLowerLeg", "LeftLeg", "RightLeg" } do
		local a = m:FindFirstChild(n)
		if a then
			local s = a.Size
			for k = 0, 3 do
				for _, d in { -1, 1 } do
					piece(m, a, "Strap", Vector3.new(s.X * 1.05, 0.05, 0.04), CFrame.new(0, s.Y * (0.35 - k * 0.22), -s.Z / 2 - 0.03) * CFrame.Angles(0, 0, math.rad(d * 25)), strap)
				end
			end
		end
	end
end
-- Back-of-cape emblem (Superman's yellow S on the cape)
function P.CapeEmblem(m, text, color)
	local cape = m:FindFirstChild("Costume_Cape"); if not cape then return end
	local g = Instance.new("SurfaceGui"); g.Face = Enum.NormalId.Back; g.LightInfluence = 1; g.Parent = cape
	local t = Instance.new("TextLabel"); t.Size = UDim2.fromScale(1, 0.35); t.Position = UDim2.fromScale(0, 0.12); t.BackgroundTransparency = 1
	t.TextScaled = true; t.Font = Enum.Font.GothamBlack; t.Text = text; t.TextColor3 = color; t.Parent = g
end
-- Wonder Woman details: white boot stripes + white stars on the blue briefs
function P.WWDetails(m)
	for _, n in { "LeftLowerLeg", "RightLowerLeg" } do
		local a = m:FindFirstChild(n)
		if a then piece(m, a, "BootStripe", Vector3.new(a.Size.X * 0.12, a.Size.Y * 1.0, 0.04), CFrame.new(0, 0, -a.Size.Z / 2 - 0.02), C(245, 245, 245)) end
	end
	local w = waistOf(m)
	if w then for i = -1, 1 do
		local st = piece(m, w, "Star", Vector3.new(0.25, 0.25, 0.02), CFrame.new(i * w.Size.X * 0.28, 0, -w.Size.Z / 2 - 0.02), C(240, 240, 240)); st.Transparency = 1
		glyph(st, Enum.NormalId.Front, "★", C(245, 245, 245))
	end end
end
-- Darkseid: armored helmet ridge + chest plate + Omega buckle
function P.DarkseidArmor(m, blue, metal)
	local hd = find(m, "Head")
	if hd then piece(m, hd, "Helm", Vector3.new(hd.Size.X * 1.1, hd.Size.Y * 0.42, hd.Size.Z * 1.1), CFrame.new(0, hd.Size.Y * 0.35, 0.03), blue, Enum.Material.Metal) end
	local t = chestOf(m)
	if t then piece(m, t, "ChestPlate", Vector3.new(t.Size.X * 0.8, t.Size.Y * 0.55, 0.08), CFrame.new(0, t.Size.Y * 0.18, -t.Size.Z / 2 - 0.04), metal, Enum.Material.Metal) end
	P.Belt(m, metal, { color = C(150, 20, 20), text = "Ω", textColor = C(255, 220, 120) })
end
-- Deathstroke: twin sword hilts over the shoulders
function P.Scabbards(m, color)
	local t = chestOf(m); if not t then return end
	local s = t.Size
	for _, x in { -1, 1 } do
		piece(m, t, "Scabbard", Vector3.new(0.18, s.Y * 1.4, 0.18), CFrame.new(x * s.X * 0.2, 0, s.Z / 2 + 0.12) * CFrame.Angles(0, 0, math.rad(x * 20)), color)
		piece(m, t, "Hilt", Vector3.new(0.12, 0.6, 0.12), CFrame.new(x * s.X * 0.38, s.Y * 0.75, s.Z / 2 + 0.12) * CFrame.Angles(0, 0, math.rad(x * 20)), C(25, 25, 25))
	end
end
-- Joker's lapel flower
function P.Flower(m)
	local t = chestOf(m); if not t then return end
	piece(m, t, "Flower", Vector3.new(0.2, 0.2, 0.08), CFrame.new(-t.Size.X * 0.3, t.Size.Y * 0.25, -t.Size.Z / 2 - 0.08), C(240, 240, 240), Enum.Material.SmoothPlastic, Enum.PartType.Ball)
end
Costume.Pieces = P
Costume.SKIN = Color3.fromRGB(234, 184, 146)

-- Per-hero default look. Receives the skin (Primary/Secondary/Name) and returns { colors?, pieces }.
-- colors override body-part groups: Head, Chest, Waist, Arms, Hands, Legs, Feet.
local SKIN, GOLD, WHITE = C(234, 184, 146), C(215, 170, 50), C(245, 245, 245)
-- Shared helpers handed to every per-hero costume module (src/shared/Costumes/<HeroId>.luau)
Costume.Helpers = {
	C = C, SKIN = SKIN, GOLD = GOLD, WHITE = WHITE, P = P,
	find = find, chestOf = chestOf, waistOf = waistOf, piece = piece, round = round, band = band, ring = ring, glyph = glyph, front = front,
	spike = function(...) return spike(...) end, hellfire = hellfire,
}
Costume.Heroes = {}
for _, mod in script.Parent:WaitForChild("Costumes"):GetChildren() do
	if mod:IsA("ModuleScript") then Costume.Heroes[mod.Name] = require(mod) end
end

local GROUPS = {
	Head = { "Head" }, Chest = { "UpperTorso", "Torso" }, Waist = { "LowerTorso", "Belt" },
	Arms = { "LeftUpperArm", "RightUpperArm", "LeftLowerArm", "RightLowerArm", "LeftArm", "RightArm" },
	Hands = { "LeftHand", "RightHand" },
	Legs = { "LeftUpperLeg", "RightUpperLeg", "LeftLowerLeg", "RightLowerLeg", "LeftLeg", "RightLeg" },
	Feet = { "LeftFoot", "RightFoot" },
	Boots = { "LeftLowerLeg", "RightLowerLeg", "LeftFoot", "RightFoot" },
	UpperArms = { "LeftUpperArm", "RightUpperArm" }, LowerArms = { "LeftLowerArm", "RightLowerArm" },
	UpperLegs = { "LeftUpperLeg", "RightUpperLeg" }, LowerLegs = { "LeftLowerLeg", "RightLowerLeg" },
	Gloves = { "LeftLowerArm", "RightLowerArm", "LeftHand", "RightHand" },
}

function Costume.Apply(m, heroId, skin, rarity)
	local def = Costume.Heroes[heroId] and Costume.Heroes[heroId](skin, Costume.Helpers, rarity or "Common")
	if not def then return end
	local colors = table.clone(def.colors or {})
	for k, v in skin.Colors or {} do colors[k] = v end -- per-variant overrides
	for _, group in { "Head", "Chest", "Waist", "Arms", "UpperArms", "LowerArms", "Hands", "Gloves", "Legs", "UpperLegs", "LowerLegs", "Feet", "Boots" } do
		local color = colors[group]
		if color then for _, n in GROUPS[group] do local p = m:FindFirstChild(n); if p then p.Color = color end end end
	end
	local list = table.clone(skin.Pieces or def.pieces)
	for _, extra in skin.Extra or {} do table.insert(list, extra) end
	for _, entry in list do
		if type(entry) == "function" then
			entry(m) -- hero-specific custom piece
		else
			local fn = P[entry[1]]
			if fn then fn(m, table.unpack(entry, 2)) else warn("Costume: unknown piece " .. tostring(entry[1]) .. " for " .. heroId) end
		end
	end
end
return Costume
