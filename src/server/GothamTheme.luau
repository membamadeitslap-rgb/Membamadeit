-- Halloween night in 90s animated Batman art deco Gotham, centered on the convoy spawn (road start).
-- Palette from the references: deep blue/violet night, black deco towers with gold window stripes,
-- red sky glow on the horizon, sweeping searchlights, yellow headlights, red tail-light streaks.
local Lighting = game:GetService("Lighting")
local RunService = game:GetService("RunService")
local C = Color3.fromRGB
local G = {}

local NIGHT_BLUE, VIOLET, GOLD, DECO_BLACK = C(30, 30, 90), C(70, 40, 120), C(255, 200, 70), C(18, 16, 32)
local PUMPKIN = C(255, 120, 20)

local function part(parent, props)
	local p = Instance.new("Part"); p.Anchored = true; p.CanCollide = false; p.TopSurface = Enum.SurfaceType.Smooth
	p.Material = Enum.Material.SmoothPlastic
	for k, v in props do p[k] = v end
	p.Parent = parent; return p
end
local function solid(parent, props) local p = part(parent, props); p.CanCollide = true; return p end

local function lighting()
	Lighting.ClockTime = 0; Lighting.Brightness = 2; Lighting.GlobalShadows = true; Lighting.ExposureCompensation = 0.25
	Lighting.Ambient = C(105, 100, 140); Lighting.OutdoorAmbient = C(125, 120, 170) -- bright enough to read characters at night
	Lighting.FogColor = C(40, 30, 90); Lighting.FogStart = 120; Lighting.FogEnd = 900
	for _, x in Lighting:GetChildren() do if x:IsA("PostEffect") or x:IsA("Atmosphere") or x:IsA("Sky") then x:Destroy() end end
	local atm = Instance.new("Atmosphere"); atm.Density = 0.3; atm.Offset = 0.1
	atm.Color = C(90, 70, 170); atm.Decay = C(200, 40, 60); atm.Glare = 0; atm.Haze = 1.6; atm.Parent = Lighting -- red horizon glow
	local cc = Instance.new("ColorCorrectionEffect"); cc.TintColor = C(200, 190, 255); cc.Saturation = 0.25; cc.Contrast = 0.15; cc.Parent = Lighting
	local bloom = Instance.new("BloomEffect"); bloom.Intensity = 0.4; bloom.Size = 18; bloom.Threshold = 2.2; -- only true light sources glow, never faces/skin bloom.Parent = Lighting
	local sky = Instance.new("Sky"); sky.StarCount = 1500; sky.MoonAngularSize = 14; sky.CelestialBodiesShown = true; sky.Parent = Lighting
end

-- Stepped art deco skyscraper: setbacks, vertical gold window stripes, optional spire with beacon.
local function tower(parent, base, w, h, faceDir, spire)
	local m = Instance.new("Model"); m.Name = "DecoTower"; m.Parent = parent
	local y, cw = 0, w
	local tiers = 3 + (h > 200 and 1 or 0)
	for t = 1, tiers do
		local th = h * (t == 1 and 0.55 or 0.45 / (tiers - 1))
		local body = solid(m, { Size = Vector3.new(cw, th, cw), CFrame = CFrame.new(base + Vector3.new(0, y + th / 2, 0)), Color = DECO_BLACK, Material = Enum.Material.Slate })
		-- gold window stripes on the face looking at the road
		local stripes = math.max(2, math.floor(cw / 7))
		for s = 1, stripes do
			local off = -cw / 2 + (s - 0.5) * cw / stripes
			local lit = (s + t) % 3 ~= 0
			part(m, { Size = Vector3.new(1.2, th * 0.8, 0.3),
				CFrame = body.CFrame * CFrame.lookAt(Vector3.zero, faceDir) * CFrame.new(off, 0, -cw / 2 - 0.2),
				Color = lit and GOLD or C(60, 50, 40), Material = lit and Enum.Material.Neon or Enum.Material.SmoothPlastic, Transparency = lit and 0.15 or 0 })
		end
		-- gold uplight band on each setback (like the glowing crowns in the art)
		part(m, { Size = Vector3.new(cw + 0.4, 1, cw + 0.4), CFrame = CFrame.new(base + Vector3.new(0, y + th - 0.5, 0)), Color = GOLD, Material = Enum.Material.Neon, Transparency = 0.35 })
		y += th; cw *= 0.72
	end
	if spire then
		part(m, { Size = Vector3.new(2, 40, 2), CFrame = CFrame.new(base + Vector3.new(0, y + 20, 0)), Color = C(170, 170, 200), Material = Enum.Material.Metal })
		local b = part(m, { Shape = Enum.PartType.Ball, Size = Vector3.one * 3, CFrame = CFrame.new(base + Vector3.new(0, y + 41, 0)), Color = C(255, 40, 40), Material = Enum.Material.Neon })
		local l = Instance.new("PointLight"); l.Color = C(255, 40, 40); l.Range = 40; l.Brightness = 3; l.Parent = b
	end
	return m
end

local function jackOLantern(parent, pos, size)
	local m = Instance.new("Model"); m.Name = "JackOLantern"; m.Parent = parent
	local body = solid(m, { Shape = Enum.PartType.Ball, Size = Vector3.new(size, size * 0.85, size), CFrame = CFrame.new(pos + Vector3.new(0, size * 0.42, 0)), Color = PUMPKIN })
	part(m, { Size = Vector3.new(size * 0.12, size * 0.25, size * 0.12), CFrame = body.CFrame * CFrame.new(0, size * 0.48, 0), Color = C(60, 100, 30) })
	local face = Instance.new("SurfaceGui"); face.Face = Enum.NormalId.Front; face.LightInfluence = 0; face.Parent = body
	local t = Instance.new("TextLabel"); t.Size = UDim2.fromScale(1, 1); t.BackgroundTransparency = 1; t.Text = "▲ ▲\n▼▼▼"; t.TextScaled = true
	t.Font = Enum.Font.GothamBlack; t.TextColor3 = C(255, 230, 80); t.Parent = face
	local l = Instance.new("PointLight"); l.Color = PUMPKIN; l.Range = size * 4; l.Brightness = 2; l.Parent = body
	return body
end

local function streetLamp(parent, pos)
	solid(parent, { Size = Vector3.new(0.8, 18, 0.8), CFrame = CFrame.new(pos + Vector3.new(0, 9, 0)), Color = C(25, 25, 40), Material = Enum.Material.Metal })
	local head = part(parent, { Shape = Enum.PartType.Ball, Size = Vector3.one * 2.4, CFrame = CFrame.new(pos + Vector3.new(0, 18.5, 0)), Color = C(230, 220, 255), Material = Enum.Material.Neon })
	local l = Instance.new("PointLight"); l.Color = C(200, 190, 255); l.Range = 35; l.Brightness = 2.2; l.Parent = head
end

local function searchlight(parent, pos, color, speed, phase)
	local beam = part(parent, { Name = "Searchlight", Size = Vector3.new(3, 400, 3), Color = color, Material = Enum.Material.Neon, Transparency = 0.75, CastShadow = false })
	solid(parent, { Shape = Enum.PartType.Cylinder, Size = Vector3.new(3, 6, 6), CFrame = CFrame.new(pos) * CFrame.Angles(0, 0, math.rad(90)), Color = C(40, 40, 50), Material = Enum.Material.Metal })
	return { beam = beam, pos = pos, speed = speed, phase = phase }
end

local function bat(parent)
	local m = Instance.new("Model"); m.Name = "Bat"
	local body = part(m, { Size = Vector3.new(0.8, 0.6, 1.4), Color = C(10, 10, 15) })
	local l = part(m, { Size = Vector3.new(2.4, 0.15, 1), Color = C(10, 10, 15) })
	local r = part(m, { Size = Vector3.new(2.4, 0.15, 1), Color = C(10, 10, 15) })
	m.PrimaryPart = body; m.Parent = parent
	return { m = m, body = body, l = l, r = r }
end

-- Art deco gateway the convoy drives out of
local function gateway(parent, at)
	for _, z in { -17, 17 } do
		local pillar = solid(parent, { Size = Vector3.new(8, 46, 8), CFrame = CFrame.new(at + Vector3.new(0, 23, z)), Color = DECO_BLACK, Material = Enum.Material.Slate })
		for k = 1, 3 do part(parent, { Size = Vector3.new(8.4, 1, 8.4), CFrame = CFrame.new(at + Vector3.new(0, 10 + k * 10, z)), Color = GOLD, Material = Enum.Material.Neon, Transparency = 0.2 }) end
		part(parent, { Size = Vector3.new(1, 40, 2), CFrame = pillar.CFrame * CFrame.new(4.2, 0, 0), Color = GOLD, Material = Enum.Material.Neon, Transparency = 0.2 })
		solid(parent, { Size = Vector3.new(5, 10, 5), CFrame = CFrame.new(at + Vector3.new(0, 51, z)), Color = DECO_BLACK, Material = Enum.Material.Slate })
		jackOLantern(parent, at + Vector3.new(0, 56, z), 5)
	end
	local beam = solid(parent, { Size = Vector3.new(8, 8, 42), CFrame = CFrame.new(at + Vector3.new(0, 42, 0)), Color = DECO_BLACK, Material = Enum.Material.Slate })
	local sg = Instance.new("SurfaceGui"); sg.Face = Enum.NormalId.Right; sg.LightInfluence = 0; sg.Parent = beam
	local t = Instance.new("TextLabel"); t.Size = UDim2.fromScale(1, 1); t.BackgroundTransparency = 1; t.TextScaled = true; t.Font = Enum.Font.Bodoni
	t.Text = "GOTHAM CONVOY"; t.TextColor3 = GOLD; t.Parent = sg
	Instance.new("UIStroke", t).Color = C(120, 40, 0)
	-- Sunburst fan above the arch (deco motif)
	for k = -4, 4 do
		part(parent, { Size = Vector3.new(0.6, 14, 1), CFrame = CFrame.new(at + Vector3.new(0, 46, 0)) * CFrame.Angles(math.rad(k * 16), 0, 0) * CFrame.new(0, 7, 0),
			Color = k % 2 == 0 and GOLD or PUMPKIN, Material = Enum.Material.Neon, Transparency = 0.25 })
	end
	-- Hanging orange/purple Halloween string lights across the road
	for i = 0, 12 do
		local z = -16 + i * (32 / 12)
		local sag = math.sin(i / 12 * math.pi) * 5
		local bulb = part(parent, { Shape = Enum.PartType.Ball, Size = Vector3.one * 1.2, CFrame = CFrame.new(at + Vector3.new(-6, 36 - sag, z)),
			Color = i % 2 == 0 and PUMPKIN or C(150, 60, 255), Material = Enum.Material.Neon })
		if i % 3 == 0 then local l = Instance.new("PointLight"); l.Color = bulb.Color; l.Range = 14; l.Parent = bulb end
	end
end

function G.Build(map)
	local root = Instance.new("Folder"); root.Name = "GothamTheme"; root.Parent = workspace
	lighting()
	local start = map.RoadStart
	-- Dark city ground under the whole skyline (the base world sits on top)
	solid(root, { Name = "CityGround", Size = Vector3.new(1600, 1, 1000), CFrame = CFrame.new(0, -2.2, 0), Color = C(20, 18, 40), Material = Enum.Material.Pavement })
	-- Wet-look dark asphalt plaza around the spawn
	part(root, { Name = "Plaza", Size = Vector3.new(90, 0.3, 54), CFrame = CFrame.new(start + Vector3.new(0, 0.05, 0)), Color = C(25, 25, 55), Material = Enum.Material.Glass, Reflectance = 0.25, Transparency = 0 })
	gateway(root, start + Vector3.new(6, 0, 0))
	-- Skyline: canyon of deco towers framing the convoy's start (like the street-view references)
	local rng = Random.new(1939)
	for i = 0, 7 do
		for _, side in { -1, 1 } do
			local x = start.X - 40 - i * 34 + rng:NextNumber(-6, 6)
			local h = rng:NextNumber(110, 260) + (i == 3 and 120 or 0)
			tower(root, Vector3.new(x, 0, side * rng:NextNumber(30, 60)), rng:NextNumber(24, 34), h, Vector3.new(0, 0, -side), h > 220)
		end
	end
	-- The big Empire-State-style centerpiece at the end of the canyon
	tower(root, start + Vector3.new(-320, 0, 0), 60, 420, Vector3.new(1, 0, 0), true)
	-- Background ring of towers around the whole map (silhouettes in the fog)
	for i = 0, 23 do
		local a = math.rad(i * 15)
		local pos = Vector3.new(math.cos(a) * 420, 0, math.sin(a) * 260)
		if math.abs(pos.Z) > 140 or math.abs(pos.X) > 300 then
			tower(root, pos, rng:NextNumber(30, 50), rng:NextNumber(140, 320), (-pos * Vector3.new(1, 0, 1)).Unit, rng:NextNumber() > 0.6)
		end
	end
	-- Street lamps along the whole convoy road
	for x = start.X + 20, map.RoadEnd.X, 40 do
		streetLamp(root, Vector3.new(x, 0, 15)); streetLamp(root, Vector3.new(x, 0, -15))
	end
	-- Jack-o'-lanterns + spooky props at the spawn plaza
	for i = 0, 9 do
		local side = i % 2 == 0 and 1 or -1
		jackOLantern(root, start + Vector3.new(14 + (i // 2) * 9, 0, side * 18), rng:NextNumber(2.5, 4.5))
	end
	for _, z in { -32, 32 } do -- tombstones + dead trees
		for k = 0, 3 do
			solid(root, { Size = Vector3.new(3, 5, 1), CFrame = CFrame.new(start + Vector3.new(-14 + k * 7, 2.5, z * 1.3)) * CFrame.Angles(0, 0, math.rad(rng:NextNumber(-8, 8))), Color = C(90, 90, 110), Material = Enum.Material.Slate })
		end
		local trunk = solid(root, { Size = Vector3.new(1.6, 14, 1.6), CFrame = CFrame.new(start + Vector3.new(-22, 7, z * 1.6)), Color = C(25, 20, 30), Material = Enum.Material.Wood })
		for k = 1, 4 do
			part(root, { Size = Vector3.new(0.6, 6, 0.6), CFrame = trunk.CFrame * CFrame.new(0, 3 + k, 0) * CFrame.Angles(0, k * 1.6, math.rad(50)) * CFrame.new(0, 3, 0), Color = C(25, 20, 30), Material = Enum.Material.Wood })
		end
	end
	-- Ground fog over the plaza
	local fogPart = part(root, { Size = Vector3.new(110, 1, 110), CFrame = CFrame.new(start + Vector3.new(30, 1, 0)), Transparency = 1 })
	local fog = Instance.new("ParticleEmitter"); fog.Texture = "rbxasset://textures/particles/smoke_main.dds"
	fog.Color = ColorSequence.new(C(120, 100, 200)); fog.Transparency = NumberSequence.new({ NumberSequenceKeypoint.new(0, 1), NumberSequenceKeypoint.new(0.5, 0.75), NumberSequenceKeypoint.new(1, 1) })
	fog.Size = NumberSequence.new(14); fog.Lifetime = NumberRange.new(8, 12); fog.Rate = 12; fog.Speed = NumberRange.new(1, 2)
	fog.EmissionDirection = Enum.NormalId.Top; fog.Parent = fogPart
	-- Searchlights (one Bat-Signal-yellow, others pale violet)
	local lights = {
		searchlight(root, start + Vector3.new(-60, 3, 40), C(255, 220, 90), 0.35, 0),
		searchlight(root, start + Vector3.new(-110, 3, -45), C(190, 170, 255), 0.25, 2),
		searchlight(root, start + Vector3.new(40, 3, -50), C(190, 170, 255), 0.3, 4),
	}
	-- Bat-Signal projected on the clouds
	local signal = part(root, { Shape = Enum.PartType.Cylinder, Size = Vector3.new(0.5, 50, 50), CFrame = CFrame.new(start + Vector3.new(-150, 240, 120)) * CFrame.Angles(0, math.rad(90), 0),
		Color = C(255, 230, 120), Material = Enum.Material.Neon, Transparency = 0.45 })
	local logo = Instance.new("SurfaceGui"); logo.Face = Enum.NormalId.Right; logo.LightInfluence = 0; logo.Parent = signal
	local lt = Instance.new("TextLabel"); lt.Size = UDim2.fromScale(1, 1); lt.BackgroundTransparency = 1; lt.Text = "🦇"; lt.TextScaled = true
	lt.TextColor3 = C(0, 0, 0); lt.Parent = logo
	-- Bats circling the gateway
	local bats = {}
	for i = 1, 14 do bats[i] = bat(root) end
	RunService.Heartbeat:Connect(function()
		local t = os.clock()
		for _, s in lights do
			local a = math.sin(t * s.speed + s.phase) * 0.45
			s.beam.CFrame = CFrame.new(s.pos) * CFrame.Angles(a, 0, a * 0.6) * CFrame.new(0, 200, 0)
		end
		for i, b in bats do
			local r, h = 20 + (i % 4) * 8, 40 + (i % 5) * 6
			local ang = t * (0.6 + (i % 3) * 0.2) + i
			local pos = start + Vector3.new(math.cos(ang) * r, h + math.sin(t * 2 + i) * 3, math.sin(ang) * r)
			local cf = CFrame.lookAt(pos, pos + Vector3.new(-math.sin(ang), 0, math.cos(ang)))
			local flap = math.sin(t * 18 + i) * 0.7
			b.body.CFrame = cf
			b.l.CFrame = cf * CFrame.new(-0.4, 0, 0) * CFrame.Angles(0, 0, flap) * CFrame.new(-1.2, 0, 0)
			b.r.CFrame = cf * CFrame.new(0.4, 0, 0) * CFrame.Angles(0, 0, -flap) * CFrame.new(1.2, 0, 0)
		end
	end)
end
return G
