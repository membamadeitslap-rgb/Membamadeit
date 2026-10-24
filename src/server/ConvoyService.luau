-- Convoy: trucks drive down the road, each carrying a random hero variant.
-- Players buy with cash (ProximityPrompt); the hero then walks to their base and joins the roster.
local RS = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local Heroes = require(RS.Shared.Heroes)
local Rarity = require(RS.Shared.Rarity)
local Skins = require(RS.Shared.Skins)
local Net = require(RS.Shared.Net)
local Data = require(script.Parent.DataService)
local HeroModel = require(script.Parent.HeroModel)
local Base = require(script.Parent.BaseService)
local SLOTS = require(script.Parent.ArenaBuilder).SLOTS

local Convoy = {}
local SPAWN_EVERY, TRAVEL_TIME = 3.5, 45
local heroIds = {}
for id in Heroes do table.insert(heroIds, id) end
local rng = Random.new()

local function buildTruck(rarity)
	local tier = Rarity.Tiers[rarity]
	local m = Instance.new("Model"); m.Name = "Truck"
	local function p(name, size, offset, color, mat)
		local x = Instance.new("Part"); x.Name = name; x.Size = size; x.Anchored = true; x.CanCollide = false
		x.Color = color; x.Material = mat or Enum.Material.SmoothPlastic; x.CFrame = CFrame.new(offset); x.Parent = m
		return x
	end
	local bed = p("Bed", Vector3.new(14, 1, 8), Vector3.new(0, 2.5, 0), Color3.fromRGB(50, 50, 55), Enum.Material.DiamondPlate)
	p("Cab", Vector3.new(5, 5, 8), Vector3.new(9.5, 4.5, 0), Color3.fromRGB(30, 30, 35))
	p("Glass", Vector3.new(0.3, 2, 7), Vector3.new(12.1, 5.5, 0), Color3.fromRGB(120, 180, 220), Enum.Material.Glass)
	p("Stripe", Vector3.new(14.2, 0.4, 8.2), Vector3.new(0, 2.2, 0), tier.Color, Enum.Material.Neon)
	for _, x in { -5, 5, 9.5 } do
		for _, z in { -4.2, 4.2 } do
			local w = p("Wheel", Vector3.new(0.8, 3, 3), Vector3.new(x, 1.5, z), Color3.fromRGB(20, 20, 20))
			w.Shape = Enum.PartType.Cylinder; w.CFrame = CFrame.new(Vector3.new(x, 1.5, z)) * CFrame.Angles(0, math.rad(90), 0)
		end
	end
	-- Yellow headlights + red tail-light streaks (TAS-style motion lines)
	for _, z in { -2.8, 2.8 } do
		local hl = p("Headlight", Vector3.new(0.3, 0.9, 0.9), Vector3.new(12.2, 3.2, z), Color3.fromRGB(255, 230, 120), Enum.Material.Neon)
		local sl = Instance.new("SpotLight"); sl.Face = Enum.NormalId.Right; sl.Color = hl.Color; sl.Range = 40; sl.Angle = 50; sl.Brightness = 3; sl.Parent = hl
		local tl = p("TailLight", Vector3.new(0.3, 0.6, 0.9), Vector3.new(-7.1, 2.8, z), Color3.fromRGB(255, 30, 50), Enum.Material.Neon)
		local a0 = Instance.new("Attachment"); a0.Position = Vector3.new(0, 0.25, 0); a0.Parent = tl
		local a1 = Instance.new("Attachment"); a1.Position = Vector3.new(0, -0.25, 0); a1.Parent = tl
		local tr = Instance.new("Trail"); tr.Attachment0 = a0; tr.Attachment1 = a1; tr.Lifetime = 0.8; tr.LightEmission = 1
		tr.Color = ColorSequence.new(Color3.fromRGB(255, 30, 60)); tr.Transparency = NumberSequence.new(0.1, 1); tr.FaceCamera = true; tr.Parent = tl
	end
	m.PrimaryPart = bed
	return m
end

-- Hero hops off the truck and walks (tweened) to the buyer's base, then joins the roster.
local function walkHome(model, buyer)
	local plot = Base.PlotOf(buyer); if not plot then model:Destroy(); return end
	local path = { plot.Entrance, plot.Spawn }
	local pos = model:GetPivot().Position
	local start = Vector3.new(pos.X, 3, pos.Z + (plot.Entrance.Z > 0 and 6 or -6))
	model:PivotTo(CFrame.new(start))
	for _, target in path do
		local from = model:GetPivot().Position
		local to = Vector3.new(target.X, 3, target.Z)
		local dur = (to - from).Magnitude / 20
		local t = 0
		while t < dur and model.Parent do
			t += RunService.Heartbeat:Wait()
			model:PivotTo(CFrame.lookAt(from:Lerp(to, math.min(1, t / dur)), to + (to - from).Unit))
		end
	end
	model:Destroy()
	return true
end

local function spawnOne(map)
	local heroId = heroIds[rng:NextInteger(1, #heroIds)]
	local rarity = Rarity.Roll(rng)
	local price = Rarity.Tiers[rarity].Price
	local truck = buildTruck(rarity)
	local hero = HeroModel.Build(heroId, rarity, "$" .. Rarity.Format(price))
	hero.Parent = truck
	truck.Parent = workspace
	local prompt = Instance.new("ProximityPrompt")
	prompt.ActionText = "Buy $" .. Rarity.Format(price); prompt.ObjectText = Skins.Get(heroId, rarity).Name
	prompt.HoldDuration = 0.4; prompt.MaxActivationDistance = 14; prompt.RequiresLineOfSight = false
	prompt.Parent = hero.HumanoidRootPart

	local sold = false
	prompt.Triggered:Connect(function(p)
		if sold then return end
		local d = Data.Get(p)
		if not d or not Base.PlotOf(p) then return end
		if #d.Owned >= SLOTS then Net.Fx:FireClient(p, "Alert", { text = "Your base is full! (" .. SLOTS .. " slots)" }); return end
		if not Data.AddCash(p, -price) then Net.Fx:FireClient(p, "Alert", { text = "Not enough cash!" }); return end
		sold = true
		prompt:Destroy()
		hero.Head.Tag.Extra.Text = p.DisplayName
		hero.Parent = workspace
		if Rarity.Tiers[rarity].Index >= 4 then
			Net.Fx:FireAllClients("Alert", { text = p.DisplayName .. " bought a " .. rarity:upper() .. " " .. Skins.Get(heroId, rarity).Name .. "!", color = Rarity.Tiers[rarity].Color })
		end
		task.spawn(function()
			walkHome(hero, p)
			if p.Parent and Data.AddHero(p, heroId, rarity, SLOTS) then Base.Render(p)
			elseif p.Parent then Data.AddCash(p, price) end -- base filled up meanwhile: refund
		end)
	end)

	-- Drive from start to end of the road
	local from, to = map.RoadStart, map.RoadEnd
	local t = 0
	while t < TRAVEL_TIME and truck.Parent do
		t += RunService.Heartbeat:Wait()
		local pos = from:Lerp(to, t / TRAVEL_TIME)
		truck:PivotTo(CFrame.new(pos))
		if not sold then hero:PivotTo(CFrame.new(pos + Vector3.new(-2, 6.1, 0)) * CFrame.Angles(0, math.rad(180), 0)) end
	end
	truck:Destroy()
	if not sold then hero:Destroy() end
end

function Convoy.Start(map)
	task.spawn(function()
		while true do
			task.spawn(spawnOne, map)
			task.wait(SPAWN_EVERY)
		end
	end)
end
return Convoy
