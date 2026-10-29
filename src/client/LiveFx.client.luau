-- Keeps characters alive between moves: breathing / fighting-stance idle on every nearby hero (duelists and
-- pedestal displays), plus tag-driven effects that costumes put on parts (see VFX.Tags):
-- FxPulse (arc reactor, repulsors, visors), FxFlicker (fire, unstable energy), FxCrackle (lightning arcs).
local CollectionService = game:GetService("CollectionService")
local RunService = game:GetService("RunService")
local RS = game:GetService("ReplicatedStorage")
local Anim = require(RS.Shared.Anim)
local V = require(RS.Shared.VFX)
local Toon = require(RS.Shared.Toon)
local cam = workspace.CurrentCamera
local RANGE = 110

-- glow parts remember their starting look so the pulse is relative to the costume's design
local base = setmetatable({}, { __mode = "k" })
local function baseOf(p)
	local b = base[p]
	if not b then
		local l = p:FindFirstChildWhichIsA("Light")
		b = { tr = p.Transparency, light = l, bright = l and l.Brightness or 0, phase = math.random() * 6 }
		base[p] = b
	end
	return b
end
local function near(p) return (p.Position - cam.CFrame.Position).Magnitude < RANGE end

RunService.RenderStepped:Connect(function()
	local t = os.clock()
	for _, p in CollectionService:GetTagged(V.Tags.Pulse) do
		if p:IsA("BasePart") and p:IsDescendantOf(workspace) and near(p) then
			local b = baseOf(p)
			local k = (math.sin((t + b.phase) * math.pi * 2 * (p:GetAttribute("Rate") or 1.2)) + 1) / 2 -- 0..1
			p.Transparency = math.clamp(b.tr + (1 - k) * 0.35, 0, 1)
			if b.light then b.light.Brightness = b.bright * (0.55 + 0.6 * k) end
		end
	end
	for _, p in CollectionService:GetTagged(V.Tags.Flicker) do
		if p:IsA("BasePart") and p:IsDescendantOf(workspace) and near(p) then
			local b = baseOf(p)
			local n = math.noise(t * 8, b.phase) -- -0.5..0.5 smooth noise
			p.Transparency = math.clamp(b.tr + (n + 0.5) * 0.3, 0, 1)
			if b.light then b.light.Brightness = b.bright * (0.7 + n) end
		end
	end
end)

-- Lightning crackle: a few arcs per second around tagged parts
task.spawn(function()
	while true do
		task.wait(0.18)
		for _, p in CollectionService:GetTagged(V.Tags.Crackle) do
			if p:IsA("BasePart") and p:IsDescendantOf(workspace) and near(p) and math.random() < 0.45 then
				local s = p.Size.Magnitude * 0.6 + 0.6
				local a = p.Position + Vector3.new(math.random() - 0.5, math.random() - 0.5, math.random() - 0.5) * s
				local b = p.Position + Vector3.new(math.random() - 0.5, math.random() - 0.5, math.random() - 0.5) * s
				V.Bolt(a, b, p:GetAttribute("BoltColor") or Color3.fromRGB(150, 210, 255), 0.06)
			end
		end
	end
end)

-- Idle: breathing for everyone, plus a guard stance while in a duel
local STANCE = { Waist = { 0, -12, 0 }, RS = { 25, 0, 12 }, LS = { 30, 0, -12 }, RE = { 35 }, LE = { 45 }, RK = { -10 }, LK = { -10 }, Root = { 0, 12, 0, 0, -0.15 } }
local idlePose = {}
RunService.RenderStepped:Connect(function()
	local t = os.clock()
	for _, m in CollectionService:GetTagged(Toon.Tag) do
		local root = m:FindFirstChild("HumanoidRootPart")
		if root and m:IsDescendantOf(workspace) and (root.Position - cam.CFrame.Position).Magnitude < RANGE then
			local ph = (m:GetAttribute("IdlePhase") or 0)
			if not m:GetAttribute("IdlePhase") then m:SetAttribute("IdlePhase", math.random() * 6) end
			local br = math.sin((t + ph) * 2.1) -- breathing
			local duel = m:GetAttribute("InDuel")
			local hum = m:FindFirstChildOfClass("Humanoid")
			local moving = hum and hum.MoveDirection.Magnitude > 0.1
			local p = idlePose[m] or {}; idlePose[m] = p
			if duel and not moving then
				for k, v in STANCE do p[k] = v end
				p.Waist = { br * 1.5, -12, 0 }; p.Neck = { br * -1.2, 8, 0 }
			else
				for k in p do p[k] = nil end
				p.Waist = { br * 1.8, 0, 0 }; p.Neck = { br * -1.2, 0, 0 }
				p.RS = { 0, 0, 2 + br * 1.5 }; p.LS = { 0, 0, -2 - br * 1.5 }
			end
			Anim.Idle(m, p)
		end
	end
end)
