-- Hit sparks, camera shake, hitstop feel, red ultimate flash (as seen in footage).
local RS = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local Lighting = game:GetService("Lighting")
local Players = game:GetService("Players")
local Net = require(RS.Shared.Net)
local Heroes = require(RS.Shared.Heroes)
local Weapons = require(RS.Shared.Weapons)
local cam = workspace.CurrentCamera

local shake = 0
RunService.RenderStepped:Connect(function(dt)
	if shake > 0 then
		cam.CFrame *= CFrame.new((math.random() - 0.5) * shake, (math.random() - 0.5) * shake, 0)
		shake = math.max(0, shake - dt * 4)
	end
end)

local function spark(pos, color, size)
	local p = Instance.new("Part"); p.Anchored = true; p.CanCollide = false; p.CanQuery = false
	p.Shape = Enum.PartType.Ball; p.Material = Enum.Material.Neon; p.Color = color
	p.Size = Vector3.one * size; p.Position = pos; p.Parent = workspace
	TweenService:Create(p, TweenInfo.new(0.2), { Size = Vector3.one * size * 2.5, Transparency = 1 }):Play()
	game:GetService("Debris"):AddItem(p, 0.25)
end

local function ultFlash()
	local cc = Instance.new("ColorCorrectionEffect"); cc.TintColor = Color3.fromRGB(255, 60, 60); cc.Saturation = -0.6; cc.Contrast = 0.4; cc.Parent = Lighting
	TweenService:Create(cc, TweenInfo.new(1.2, Enum.EasingStyle.Quad, Enum.EasingDirection.In), { TintColor = Color3.new(1, 1, 1), Saturation = 0, Contrast = 0 }):Play()
	game:GetService("Debris"):AddItem(cc, 1.3)
end

Net.Fx.OnClientEvent:Connect(function(kind, d)
	if kind == "Hit" then
		spark(d.pos, d.blocked and Color3.fromRGB(120, 180, 255) or Color3.fromRGB(255, 220, 120), d.heavy and 3 or 1.5)
		local me = Players.LocalPlayer
		if d.attacker == me or d.victim == me then shake = math.max(shake, d.heavy and 1.2 or 0.4) end
		if d.ult then ultFlash() end
	elseif kind == "GuardBreak" then spark(d.pos, Color3.fromRGB(255, 80, 80), 4); shake = 1
	elseif kind == "Counter" then spark(d.pos, Color3.new(1, 1, 1), 4)
	elseif kind == "Ability" and d.ult then ultFlash()
	elseif kind == "Projectile" then
		local hero = Heroes[d.hero]
		local obj, held
		if d.visual and Weapons.Ids[d.visual] then
			-- Throw the real weapon model; hide the one in hand until it returns.
			obj = Weapons.Build(d.visual)
			for _, w in d.char and d.char:GetChildren() or {} do
				if w:GetAttribute("WeaponId") == d.visual and not held then
					for _, x in w:GetDescendants() do if x:IsA("BasePart") then x.LocalTransparencyModifier = 1 end end
					held = w
				end
			end
			for _, x in obj:GetDescendants() do if x:IsA("BasePart") then x.Anchored = true end end
		else
			obj = Instance.new("Part"); obj.CanCollide = false; obj.Anchored = true
			obj.Size = Vector3.new(0.6, 0.6, 2); obj.Material = Enum.Material.Neon
			obj.Color = hero and hero.Color or Color3.new(1, 1, 1)
		end
		obj.Parent = workspace
		local life = 120 / d.speed
		local pos, t, spin = d.origin, 0, 0
		while t < life * (d.returns and 2 or 1) and obj.Parent do
			local dt = task.wait(); t += dt; spin += dt * 25
			if t < life then pos += d.dir * d.speed * dt
			else -- fly back to thrower's hand
				local hrp = d.char and d.char:FindFirstChild("HumanoidRootPart"); if not hrp then break end
				local to = hrp.Position - pos
				if to.Magnitude < 3 then break end
				pos += to.Unit * math.min(to.Magnitude, d.speed * 1.2 * dt)
			end
			obj:PivotTo(CFrame.lookAt(pos, pos + d.dir) * CFrame.Angles(0, spin, 0))
		end
		obj:Destroy()
		if held then for _, x in held:GetDescendants() do if x:IsA("BasePart") then x.LocalTransparencyModifier = 0 end end end
	end
end)
