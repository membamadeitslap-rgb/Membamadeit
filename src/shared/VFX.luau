-- Client-side effect library (anime fighter look from the reference clips): 2D smear slash arcs,
-- black/white impact frames, shockwave rings, crater rocks, speed lines, afterimages, weapon trails,
-- Critical Edge banner, combo counter, damage numbers. Everything is local and cleans itself up.
local Players = game:GetService("Players")
local RS = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local Lighting = game:GetService("Lighting")
local Debris = game:GetService("Debris")
local Heroes = require(RS.Shared.Heroes)

local V = {}
local C = Color3.fromRGB
local cam = workspace.CurrentCamera
local function tween(o, t, props, style, dir)
	local tw = TweenService:Create(o, TweenInfo.new(t, style or Enum.EasingStyle.Quad, dir or Enum.EasingDirection.Out), props)
	tw:Play(); return tw
end

V.Elements = {
	Fire = C(255, 120, 30), Ice = C(140, 220, 255), Air = C(225, 245, 255), Ghost = C(90, 255, 140), Lightning = C(120, 200, 255),
	Water = C(60, 150, 255), Earth = C(160, 115, 70), Slash = C(255, 255, 255), Bubble = C(190, 240, 255), Impact = C(255, 220, 120),
}
function V.Color(element, heroId)
	if element and V.Elements[element] then return V.Elements[element] end
	local h = heroId and Heroes[heroId]
	return h and h.Color or C(255, 255, 255)
end
-- Brighten dark hero colors so trails/smears read on screen
function V.Bright(c)
	local h, s, v = c:ToHSV()
	return Color3.fromHSV(h, math.min(s, 0.85), math.max(v, 0.85))
end

local function fxPart(props)
	local p = Instance.new("Part"); p.Anchored = true; p.CanCollide = false; p.CanQuery = false; p.CanTouch = false
	p.CastShadow = false; p.Material = Enum.Material.Neon
	for k, v in props do p[k] = v end
	p.Parent = workspace
	return p
end

-- ===== Camera =====
local shake, baseFov = 0, 70
RunService.RenderStepped:Connect(function(dt)
	if shake > 0 then
		cam.CFrame *= CFrame.new((math.random() - 0.5) * shake, (math.random() - 0.5) * shake, 0) * CFrame.Angles(0, 0, (math.random() - 0.5) * shake * 0.02)
		shake = math.max(0, shake - dt * 5)
	end
end)
function V.Shake(n) shake = math.max(shake, n) end
function V.FovPunch(n)
	cam.FieldOfView = baseFov + (n or 8)
	tween(cam, 0.35, { FieldOfView = baseFov }, Enum.EasingStyle.Back)
end
function V.Near(pos, dist) return (cam.CFrame.Position - pos).Magnitude < (dist or 150) end

-- ===== World effects =====
function V.Spark(pos, color, size)
	local p = fxPart({ Shape = Enum.PartType.Ball, Color = color, Size = Vector3.one * size, Position = pos })
	tween(p, 0.2, { Size = Vector3.one * size * 2.6, Transparency = 1 })
	Debris:AddItem(p, 0.25)
	-- star streaks flying out of the spark
	for _ = 1, 6 do
		local d = Vector3.new(math.random() - 0.5, math.random() - 0.3, math.random() - 0.5).Unit
		local s = fxPart({ Color = color, Size = Vector3.new(0.12, 0.12, size * 1.2), CFrame = CFrame.lookAt(pos, pos + d) })
		tween(s, 0.22, { CFrame = CFrame.lookAt(pos + d * size * 2.2, pos + d * 3), Size = Vector3.new(0.02, 0.02, size * 0.3), Transparency = 1 })
		Debris:AddItem(s, 0.25)
	end
end

-- Flat expanding shockwave. up = ring normal (default world up)
function V.Ring(pos, color, size, up, dur)
	up = up or Vector3.yAxis
	local cf = math.abs(up.Unit.Y) > 0.98 and CFrame.new(pos) * CFrame.Angles(0, 0, math.rad(90)) -- cylinder axis (X) along `up`
		or CFrame.lookAt(pos, pos + up) * CFrame.Angles(0, math.rad(90), 0)
	local r = fxPart({ Shape = Enum.PartType.Cylinder, Color = color, Size = Vector3.new(0.2, size, size), CFrame = cf, Transparency = 0.1 })
	tween(r, dur or 0.35, { Size = Vector3.new(0.05, size * 4, size * 4), Transparency = 1 })
	Debris:AddItem(r, (dur or 0.35) + 0.05)
	local w = fxPart({ Shape = Enum.PartType.Cylinder, Color = C(255, 255, 255), Material = Enum.Material.ForceField, Size = Vector3.new(0.6, size * 0.6, size * 0.6), CFrame = cf })
	tween(w, (dur or 0.35) * 1.3, { Size = Vector3.new(0.2, size * 3, size * 3), Transparency = 1 })
	Debris:AddItem(w, (dur or 0.35) * 1.3 + 0.05)
end

-- 2D-style smear arc. cf = origin facing forward; sweeps from angle a0 to a1 (degrees, 0 = straight ahead).
-- vertical = arc in the vertical plane (overhead/rising slashes).
function V.Arc(cf, radius, a0, a1, color, vertical, width)
	if vertical then cf *= CFrame.Angles(0, 0, math.rad(90)) end
	width = width or 1.6
	local n = 14
	local seg = math.abs(math.rad(a1 - a0)) * radius / n * 1.25
	for i = 0, n - 1 do
		local a = math.rad(a0 + (a1 - a0) * i / (n - 1))
		local taper = math.sin((i + 0.5) / n * math.pi) -- thick in the middle, pointed ends
		local at = cf * CFrame.Angles(0, a, 0) * CFrame.new(0, 0, -radius)
		task.delay(i * 0.006, function()
			local outer = fxPart({ Color = color, Size = Vector3.new(seg, 0.06, width * taper + 0.1), CFrame = at, Transparency = 0.35 })
			local core = fxPart({ Color = C(255, 255, 255), Size = Vector3.new(seg, 0.08, width * taper * 0.4 + 0.05), CFrame = at * CFrame.new(0, 0, width * 0.15) })
			for _, p in { outer, core } do
				tween(p, 0.22, { Transparency = 1, Size = Vector3.new(seg, 0.02, p.Size.Z * 0.3), CFrame = p.CFrame * CFrame.new(0, 0, -0.8) }, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
				Debris:AddItem(p, 0.25)
			end
		end)
	end
end

-- Crossed slash scar on the victim (anime "X" cut)
function V.SlashMark(pos, color, big)
	local s = big and 9 or 5
	for _, ang in { 35, -35 } do
		local cf = CFrame.lookAt(pos, cam.CFrame.Position) * CFrame.Angles(0, 0, math.rad(ang))
		local p = fxPart({ Color = color, Size = Vector3.new(0.1, s, 0.05), CFrame = cf })
		local core = fxPart({ Color = C(255, 255, 255), Size = Vector3.new(0.06, s * 0.9, 0.06), CFrame = cf * CFrame.new(0, 0, -0.05) })
		for _, x in { p, core } do
			x.Size = Vector3.new(x.Size.X, 0.2, x.Size.Z)
			tween(x, 0.06, { Size = Vector3.new(x.Size.X * 6, x == p and s or s * 0.9, x.Size.Z) })
			task.delay(0.1, function() tween(x, 0.18, { Transparency = 1, Size = Vector3.new(0.01, s * 1.2, 0.01) }) end)
			Debris:AddItem(x, 0.32)
		end
	end
end

-- Ground crater: jagged rocks pushed up in a ring, plus chunks tossed in the air
function V.Crater(pos, radius, count)
	local params = RaycastParams.new(); params.FilterType = Enum.RaycastFilterType.Exclude
	local ignore = {}
	for _, p in Players:GetPlayers() do if p.Character then table.insert(ignore, p.Character) end end
	params.FilterDescendantsInstances = ignore
	local hit = workspace:Raycast(pos + Vector3.new(0, 3, 0), Vector3.new(0, -12, 0), params)
	if not hit then return end
	local color, mat, ground = hit.Instance.Color, hit.Instance.Material, hit.Position
	count = count or 10
	for i = 1, count do
		local a = i / count * math.pi * 2 + math.random() * 0.3
		local d = Vector3.new(math.cos(a), 0, math.sin(a))
		local size = Vector3.new(1 + math.random() * 1.5, 1 + math.random() * 1.6, 1 + math.random() * 1.5) * (radius / 6)
		local final = CFrame.lookAt(ground + d * radius, ground + d * radius * 2) * CFrame.Angles(math.rad(-30 - math.random() * 20), 0, math.rad(math.random(-20, 20)))
		local rock = fxPart({ Material = mat, Color = color, Size = size, CFrame = final - Vector3.new(0, size.Y, 0), CanCollide = false })
		tween(rock, 0.12, { CFrame = final }, Enum.EasingStyle.Back)
		task.delay(1.6, function() tween(rock, 0.5, { CFrame = final - Vector3.new(0, size.Y * 1.2, 0), Transparency = 1 }) end)
		Debris:AddItem(rock, 2.2)
	end
	for _ = 1, math.floor(count / 2) do -- flying chunks
		local s = 0.4 + math.random() * 0.8
		local rock = fxPart({ Material = mat, Color = color, Size = Vector3.one * s, Position = ground })
		local d = Vector3.new(math.random() - 0.5, 0, math.random() - 0.5).Unit * radius * (1 + math.random())
		local peak = ground + d * 0.5 + Vector3.new(0, 4 + math.random() * 5, 0)
		tween(rock, 0.25, { Position = peak, Orientation = Vector3.new(math.random(0, 360), math.random(0, 360), 0) }, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
		task.delay(0.25, function() tween(rock, 0.3, { Position = ground + d, Transparency = 1 }, Enum.EasingStyle.Quad, Enum.EasingDirection.In) end)
		Debris:AddItem(rock, 0.6)
	end
	V.Dust(ground, radius)
end

function V.Dust(pos, size)
	size = size or 3
	for _ = 1, 6 do
		local d = Vector3.new(math.random() - 0.5, 0, math.random() - 0.5).Unit
		local p = fxPart({ Shape = Enum.PartType.Ball, Material = Enum.Material.SmoothPlastic, Color = C(210, 205, 195), Transparency = 0.4, Size = Vector3.one * size * 0.5, Position = pos + d * 0.5 })
		tween(p, 0.6, { Position = pos + d * size * 1.4 + Vector3.new(0, 1, 0), Size = Vector3.one * size, Transparency = 1 })
		Debris:AddItem(p, 0.65)
	end
end

-- Neon ghost copies of a character (dash / sidestep / teleport)
function V.Afterimage(char, color, count)
	for k = 0, (count or 1) - 1 do
		task.delay(k * 0.05, function()
			local n = 0
			for _, part in char:GetDescendants() do
				if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" and part.Transparency < 1 and part.Size.Magnitude < 6 then
					n += 1; if n > 45 then break end
					local g = fxPart({ Color = color, Size = part.Size, CFrame = part.CFrame, Transparency = 0.45 })
					tween(g, 0.35, { Transparency = 1 })
					Debris:AddItem(g, 0.4)
				end
			end
		end)
	end
end

-- Charging orb at a part (Critical Edge wind-up, like the pink/red energy ball clip)
function V.ChargeOrb(part, color, dur)
	if not part then return end
	local orb = fxPart({ Shape = Enum.PartType.Ball, Color = color, Size = Vector3.one * 0.2, CFrame = part.CFrame })
	local core = fxPart({ Shape = Enum.PartType.Ball, Color = C(255, 255, 255), Size = Vector3.one * 0.1, CFrame = part.CFrame })
	local l = Instance.new("PointLight"); l.Color = color; l.Range = 14; l.Brightness = 4; l.Parent = orb
	local t0 = os.clock()
	local conn
	conn = RunService.RenderStepped:Connect(function()
		local a = math.min((os.clock() - t0) / dur, 1)
		if not part.Parent or a >= 1 then
			conn:Disconnect()
			V.Ring(orb.Position, color, 4, cam.CFrame.LookVector, 0.3)
			orb:Destroy(); core:Destroy()
			return
		end
		orb.CFrame = part.CFrame; core.CFrame = part.CFrame
		orb.Size = Vector3.one * (0.5 + a * 3.2) * (1 + math.sin(os.clock() * 40) * 0.08); core.Size = orb.Size * 0.55
		if math.random() < 0.7 then -- streaks converging into the orb
			local d = Vector3.new(math.random() - 0.5, math.random() - 0.5, math.random() - 0.5).Unit
			local from = part.Position + d * 9
			local s = fxPart({ Color = color, Size = Vector3.new(0.1, 0.1, 3), CFrame = CFrame.lookAt(from, part.Position) })
			tween(s, 0.18, { CFrame = CFrame.lookAt(part.Position + d, part.Position + d * 0.5), Transparency = 1 }, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
			Debris:AddItem(s, 0.2)
		end
	end)
end

-- Elemental burst (projectile impacts, ability flares)
function V.Burst(pos, color, size)
	size = size or 3
	V.Spark(pos, color, size * 0.6)
	local a = Instance.new("Attachment"); a.WorldPosition = pos; a.Parent = workspace.Terrain
	local pe = Instance.new("ParticleEmitter")
	pe.Texture = "rbxasset://textures/particles/sparkles_main.dds"; pe.Color = ColorSequence.new(color); pe.LightEmission = 1
	pe.Size = NumberSequence.new(size * 0.4, 0); pe.Speed = NumberRange.new(10, 25); pe.Lifetime = NumberRange.new(0.2, 0.45)
	pe.SpreadAngle = Vector2.new(180, 180); pe.Drag = 6; pe.Enabled = false; pe.Parent = a
	pe:Emit(24)
	Debris:AddItem(a, 0.6)
	V.Ring(pos, color, size, cam.CFrame.LookVector, 0.25)
end

-- ===== Weapon / limb trails =====
local function trailOn(part, name, y0, y1, color, width)
	local t = part:FindFirstChild(name)
	if not t then
		local a0 = Instance.new("Attachment"); a0.Name = name .. "_A0"; a0.Position = Vector3.new(0, y0, 0); a0.Parent = part
		local a1 = Instance.new("Attachment"); a1.Name = name .. "_A1"; a1.Position = Vector3.new(0, y1, 0); a1.Parent = part
		t = Instance.new("Trail"); t.Name = name; t.Attachment0 = a0; t.Attachment1 = a1
		t.Lifetime = 0.16; t.LightEmission = 1; t.FaceCamera = true; t.MinLength = 0.05
		t.Transparency = NumberSequence.new({ NumberSequenceKeypoint.new(0, 0.05), NumberSequenceKeypoint.new(1, 1) })
		t.WidthScale = NumberSequence.new({ NumberSequenceKeypoint.new(0, 1), NumberSequenceKeypoint.new(1, 0.2) })
		t.Enabled = false; t.Parent = part
	end
	t.Color = ColorSequence.new(C(255, 255, 255), color)
	return t
end
-- limb: "Weapon" (default) | "Kick". Lights trails for `dur` seconds.
function V.Trail(char, color, dur, limb)
	local trails = {}
	if limb ~= "Kick" then
		for _, w in char:GetChildren() do
			if w:IsA("Model") and w:GetAttribute("WeaponId") then
				local blade = w:FindFirstChild("Blade") or w:FindFirstChild("Grip")
				if blade then
					local half = math.max(blade.Size.X, blade.Size.Y, blade.Size.Z) / 2
					table.insert(trails, trailOn(blade, "FxTrail", -half * 0.6, half, color))
				end
			end
		end
	end
	if #trails == 0 then
		for _, n in limb == "Kick" and { "RightFoot", "RightLowerLeg" } or { "RightHand", "LeftHand" } do
			local p = char:FindFirstChild(n)
			if p then table.insert(trails, trailOn(p, "FxTrail", -0.5, 0.5, color)) end
		end
	end
	for _, t in trails do t.Enabled = true end
	task.delay(dur, function() for _, t in trails do t.Enabled = false end end)
end

-- ===== Screen effects =====
local gui
local function screen()
	if gui and gui.Parent then return gui end
	gui = Instance.new("ScreenGui"); gui.Name = "MvD_FX"; gui.ResetOnSpawn = false; gui.IgnoreGuiInset = true; gui.DisplayOrder = 50
	gui.Parent = Players.LocalPlayer:WaitForChild("PlayerGui")
	return gui
end
local function frame(props, parent)
	local f = Instance.new("Frame"); f.BorderSizePixel = 0
	for k, v in props do f[k] = v end
	f.Parent = parent or screen(); return f
end
local function text(str, size, color, parent, props)
	local l = Instance.new("TextLabel"); l.BackgroundTransparency = 1; l.Font = Enum.Font.GothamBlack; l.Text = str
	l.TextColor3 = color; l.TextSize = size; l.Size = UDim2.new(1, 0, 0, size + 6)
	local s = Instance.new("UIStroke"); s.Thickness = 3; s.Parent = l
	for k, v in props or {} do l[k] = v end
	l.Parent = parent or screen(); return l
end

-- Anime impact frame: the scene flashes to stark black/white with the fighters as inverted silhouettes
function V.ImpactFrame(chars, flashes)
	local cc = Instance.new("ColorCorrectionEffect"); cc.Saturation = -1; cc.Contrast = 3; cc.Parent = Lighting
	local hl = {}
	for _, ch in chars do
		if ch and ch.Parent then
			local h = Instance.new("Highlight"); h.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop; h.OutlineTransparency = 0
			h.FillTransparency = 0; h.Adornee = ch; h.Parent = ch
			table.insert(hl, h)
		end
	end
	for i = 1, flashes or 3 do
		local white = i % 2 == 1
		cc.Brightness = white and 0.9 or -0.85
		for _, h in hl do
			h.FillColor = white and C(0, 0, 0) or C(255, 255, 255)
			h.OutlineColor = white and C(255, 255, 255) or C(0, 0, 0)
		end
		task.wait(1 / 30)
	end
	cc:Destroy()
	for _, h in hl do h:Destroy() end
end

-- Radial anime speed lines
function V.SpeedLines(dur, color)
	local holder = frame({ BackgroundTransparency = 1, Size = UDim2.fromScale(1, 1) })
	for i = 1, 36 do
		local a = i / 36 * math.pi * 2 + math.random() * 0.15
		local k = 0.42 + math.random() * 0.12
		local f = frame({ AnchorPoint = Vector2.new(0.5, 0.5), BackgroundColor3 = color or C(255, 255, 255), BackgroundTransparency = 0.15,
			Position = UDim2.fromScale(0.5 + math.cos(a) * k, 0.5 + math.sin(a) * k), Size = UDim2.fromOffset(160 + math.random(0, 200), math.random(2, 5)),
			Rotation = math.deg(a) }, holder)
		tween(f, dur, { BackgroundTransparency = 1, Size = UDim2.fromOffset(f.Size.X.Offset * 1.4, 1) })
	end
	Debris:AddItem(holder, dur + 0.05)
end

function V.Flash(color, t)
	local f = frame({ BackgroundColor3 = color or C(255, 255, 255), BackgroundTransparency = 0.2, Size = UDim2.fromScale(1, 1) })
	tween(f, t or 0.25, { BackgroundTransparency = 1 })
	Debris:AddItem(f, (t or 0.25) + 0.05)
end

-- Big center callout: "GUARD IMPACT!", "RING OUT!", "COUNTER!"
function V.Popup(str, color, size)
	local l = text(str, size or 64, color, nil, { AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromScale(0.5, 0.36), Rotation = -6 })
	local sc = Instance.new("UIScale"); sc.Scale = 2.2; sc.Parent = l
	tween(sc, 0.18, { Scale = 1 }, Enum.EasingStyle.Back)
	task.delay(0.9, function() tween(l, 0.3, { TextTransparency = 1, Position = UDim2.fromScale(0.5, 0.3) }); tween(l.UIStroke, 0.3, { Transparency = 1 }) end)
	Debris:AddItem(l, 1.3)
end

-- Critical Edge cinematic banner: letterbox bars + slanted stripe with the move name
function V.Banner(title, sub, color)
	local root = frame({ BackgroundTransparency = 1, Size = UDim2.fromScale(1, 1) })
	local top = frame({ BackgroundColor3 = C(0, 0, 0), Size = UDim2.fromScale(1, 0), Position = UDim2.fromScale(0, 0) }, root)
	local bot = frame({ BackgroundColor3 = C(0, 0, 0), Size = UDim2.fromScale(1, 0), AnchorPoint = Vector2.new(0, 1), Position = UDim2.fromScale(0, 1) }, root)
	tween(top, 0.15, { Size = UDim2.fromScale(1, 0.12) }); tween(bot, 0.15, { Size = UDim2.fromScale(1, 0.12) })
	local stripe = frame({ BackgroundColor3 = color, BackgroundTransparency = 0.1, AnchorPoint = Vector2.new(0.5, 0.5), Size = UDim2.new(1.4, 0, 0, 120),
		Position = UDim2.fromScale(1.6, 0.5), Rotation = -8 }, root)
	local g = Instance.new("UIGradient"); g.Color = ColorSequence.new(C(0, 0, 0), C(255, 255, 255)); g.Transparency = NumberSequence.new(0.2, 0); g.Parent = stripe
	text(title, 58, C(255, 255, 255), stripe, { Position = UDim2.fromScale(0, 0.08), Font = Enum.Font.Bangers })
	text(sub, 30, color:Lerp(C(255, 255, 255), 0.6), stripe, { Position = UDim2.fromScale(0, 0.58), Font = Enum.Font.GothamBlack })
	tween(stripe, 0.18, { Position = UDim2.fromScale(0.5, 0.5) }, Enum.EasingStyle.Back)
	task.delay(0.85, function()
		tween(stripe, 0.18, { Position = UDim2.fromScale(-0.6, 0.5) }, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
		tween(top, 0.25, { Size = UDim2.fromScale(1, 0) }); tween(bot, 0.25, { Size = UDim2.fromScale(1, 0) })
	end)
	Debris:AddItem(root, 1.3)
end

-- Floating damage number over the victim
function V.Damage(pos, n, color, big)
	local a = Instance.new("Attachment"); a.WorldPosition = pos + Vector3.new(math.random(-10, 10) / 10, 2.5, 0); a.Parent = workspace.Terrain
	local bb = Instance.new("BillboardGui"); bb.Size = UDim2.fromOffset(120, 50); bb.AlwaysOnTop = true; bb.Adornee = a; bb.Parent = a
	local l = text(tostring(n), big and 40 or 28, color, bb, { Size = UDim2.fromScale(1, 1), Font = Enum.Font.Bangers })
	local sc = Instance.new("UIScale"); sc.Scale = 1.8; sc.Parent = l
	tween(sc, 0.15, { Scale = 1 }, Enum.EasingStyle.Back)
	tween(bb, 0.8, { StudsOffset = Vector3.new(0, 2.5, 0) })
	task.delay(0.5, function() tween(l, 0.3, { TextTransparency = 1 }); tween(l.UIStroke, 0.3, { Transparency = 1 }) end)
	Debris:AddItem(a, 0.9)
end

-- Combo counter (left side, like fighting-game hit counters)
local comboLabel, comboToken = nil, 0
function V.Combo(n)
	if n < 2 then return end
	if not (comboLabel and comboLabel.Parent) then
		comboLabel = text("", 54, C(255, 230, 90), nil, { AnchorPoint = Vector2.new(0, 0.5), Position = UDim2.fromScale(0.04, 0.45), Size = UDim2.fromOffset(300, 60), TextXAlignment = Enum.TextXAlignment.Left, Font = Enum.Font.Bangers, Rotation = -5 })
		Instance.new("UIScale", comboLabel)
	end
	comboLabel.Text = n .. " HITS!"; comboLabel.TextTransparency = 0; comboLabel.UIStroke.Transparency = 0
	comboLabel.TextColor3 = n >= 8 and C(255, 80, 80) or n >= 5 and C(255, 160, 40) or C(255, 230, 90)
	comboLabel.UIScale.Scale = 1.5; tween(comboLabel.UIScale, 0.12, { Scale = 1 }, Enum.EasingStyle.Back)
	comboToken += 1
	local tk = comboToken
	task.delay(1.4, function()
		if tk == comboToken and comboLabel then tween(comboLabel, 0.3, { TextTransparency = 1 }); tween(comboLabel.UIStroke, 0.3, { Transparency = 1 }) end
	end)
end

-- Red/colored ultimate tint (kept from the Dueling Grounds reference)
function V.Tint(color, t)
	local cc = Instance.new("ColorCorrectionEffect"); cc.TintColor = color; cc.Saturation = -0.5; cc.Contrast = 0.4; cc.Parent = Lighting
	tween(cc, t or 1.2, { TintColor = C(255, 255, 255), Saturation = 0, Contrast = 0 }, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
	Debris:AddItem(cc, (t or 1.2) + 0.1)
end
return V
