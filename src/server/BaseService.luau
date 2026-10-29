-- Player bases: plot assignment, pedestal display, passive income, lock door, stealing.
local Players = game:GetService("Players")
local RS = game:GetService("ReplicatedStorage")
local Rarity = require(RS.Shared.Rarity)
local Skins = require(RS.Shared.Skins)
local Net = require(RS.Shared.Net)
local Data = require(script.Parent.DataService)
local HeroModel = require(script.Parent.HeroModel)
local Combat = require(script.Parent.CombatService)
local SLOTS = require(script.Parent.ArenaBuilder).SLOTS

local Base = {}
local LOCK_TIME, LOCK_COOLDOWN = 60, 15
local plots, owners = {}, {} -- owners[plot] = player
local plotOf = {} -- [player] = plot
local carrying = {} -- [thief] = { victim, index, entry, model }

local function label(plot, text, color)
	local g = plot.Sign:FindFirstChild("G") or Instance.new("SurfaceGui")
	g.Name = "G"; g.Face = Enum.NormalId.Front; g.Parent = plot.Sign
	local l = g:FindFirstChild("L") or Instance.new("TextLabel")
	l.Name = "L"; l.Size = UDim2.fromScale(1, 1); l.BackgroundTransparency = 1; l.TextScaled = true
	l.Font = Enum.Font.GothamBlack; l.TextColor3 = color or Color3.new(1, 1, 1); l.Text = text; l.Parent = g
end

function Base.PlotOf(p) return plotOf[p] end

-- Re-render every pedestal from the player's saved roster.
function Base.Render(p)
	local plot = plotOf[p]; local d = Data.Get(p)
	if not plot or not d then return end
	for _, ped in plot.Pedestals do
		local old = ped:FindFirstChild("Hero"); if old then old:Destroy() end
	end
	for i, entry in d.Owned do
		local ped = plot.Pedestals[i]; if not ped then break end
		local stolen = false
		for _, c in carrying do if c.victim == p and c.index == i then stolen = true end end
		local m = HeroModel.Build(entry.H, entry.R)
		m.Name = "Hero"
		m:PivotTo(CFrame.new(ped.Position + Vector3.new(0, 3.6, 0)) * (plot.CFrame - plot.CFrame.Position)) -- face the entrance
		if stolen then for _, x in m:GetDescendants() do if x:IsA("BasePart") and x.Transparency < 1 then x.Transparency = 0.8 end end end -- keep hidden body boxes hidden
		local prompt = Instance.new("ProximityPrompt")
		prompt.ActionText = "Steal"; prompt.ObjectText = Skins.Get(entry.H, entry.R).Name
		prompt.HoldDuration = 1.5; prompt.MaxActivationDistance = 9; prompt.RequiresLineOfSight = false
		prompt.Enabled = not stolen
		prompt:SetAttribute("Owner", p.UserId) -- client hides it for the owner
		prompt.Triggered:Connect(function(thief) Base.Steal(thief, p, i) end)
		prompt.Parent = m.HumanoidRootPart
		m.Parent = ped
	end
	p:SetAttribute("Slots", #d.Owned .. "/" .. SLOTS)
	Net.Match:FireClient(p, { phase = "Roster", owned = d.Owned })
end

local function isLocked(plot) return (plot.Model:GetAttribute("LockedUntil") or 0) > os.clock() end

local function setDoor(plot)
	local locked = isLocked(plot)
	plot.Door.Transparency = locked and 0.3 or 1
	plot.Door.CanCollide = locked
	plot.LockPad.Color = locked and Color3.fromRGB(80, 255, 120) or Color3.fromRGB(255, 60, 60)
end

local function clearCarry(thief, delivered)
	local c = carrying[thief]; if not c then return end
	carrying[thief] = nil
	if c.model then c.model:Destroy() end
	if thief.Character then thief.Character:SetAttribute("Carrying", nil) end
	thief:SetAttribute("Carrying", nil)
	if not delivered and c.victim.Parent then Base.Render(c.victim) end
end

function Base.Steal(thief, victim, index)
	local plot = plotOf[victim]
	if thief == victim or carrying[thief] or not plot or isLocked(plot) then return end
	for _, c in carrying do if c.victim == victim and c.index == index then return end end
	local d = Data.Get(victim); local entry = d and d.Owned[index]
	local char = thief.Character; local head = char and char:FindFirstChild("Head")
	if not entry or not head then return end
	-- Mini model floats above the thief's head while carrying
	local m = HeroModel.Build(entry.H, entry.R, "STOLEN!")
	m:ScaleTo(0.5)
	m.HumanoidRootPart.Anchored = false
	m:PivotTo(head.CFrame * CFrame.new(0, 3, 0))
	local w = Instance.new("WeldConstraint"); w.Part0 = head; w.Part1 = m.HumanoidRootPart; w.Parent = m
	for _, x in m:GetDescendants() do if x:IsA("BasePart") then x.Massless = true end end
	m.Parent = char
	carrying[thief] = { victim = victim, index = index, entry = entry, model = m }
	char:SetAttribute("Carrying", true)
	thief:SetAttribute("Carrying", Skins.Get(entry.H, entry.R).Name)
	Net.Fx:FireClient(victim, "Alert", { text = thief.DisplayName .. " is stealing your " .. Skins.Get(entry.H, entry.R).Name .. "!" })
	Base.Render(victim)
end

local function deliver(thief)
	local c = carrying[thief]; if not c then return end
	local d = Data.Get(thief)
	if not d or #d.Owned >= SLOTS then
		Net.Fx:FireClient(thief, "Alert", { text = "Your base is full!" }); return
	end
	-- Find the entry again (victim's roster may have shifted)
	local vd = Data.Get(c.victim); local idx
	if vd then for i, e in vd.Owned do if e == c.entry then idx = i end end end
	if not idx then clearCarry(thief); return end
	Data.RemoveHero(c.victim, idx)
	Data.AddHero(thief, c.entry.H, c.entry.R, SLOTS)
	clearCarry(thief, true)
	Base.Render(c.victim); Base.Render(thief)
	Net.Fx:FireClient(thief, "Alert", { text = "Stole " .. Skins.Get(c.entry.H, c.entry.R).Name .. "!", good = true })
end

function Base.Start(map)
	plots = map.Plots
	for _, plot in plots do
		label(plot, "EMPTY BASE", Color3.fromRGB(150, 150, 150)); setDoor(plot)
		local bb = Instance.new("BillboardGui"); bb.Name = "LockTag"; bb.Size = UDim2.fromOffset(160, 30); bb.StudsOffset = Vector3.new(0, 3, 0); bb.MaxDistance = 60
		local l = Instance.new("TextLabel"); l.Name = "L"; l.Size = UDim2.fromScale(1, 1); l.BackgroundTransparency = 1; l.Font = Enum.Font.GothamBlack
		l.TextScaled = true; l.TextColor3 = Color3.new(1, 1, 1); l.Text = "STEP TO LOCK"; l.Parent = bb
		Instance.new("UIStroke", l).Thickness = 2
		bb.Parent = plot.LockPad
		plot.LockPad.Touched:Connect(function(hit)
			local p = Players:GetPlayerFromCharacter(hit.Parent)
			if not p or owners[plot] ~= p or isLocked(plot) then return end
			if (plot.Model:GetAttribute("LockReadyAt") or 0) > os.clock() then return end
			plot.Model:SetAttribute("LockedUntil", os.clock() + LOCK_TIME)
			plot.Model:SetAttribute("LockReadyAt", os.clock() + LOCK_TIME + LOCK_COOLDOWN)
			setDoor(plot)
		end)
	end
	Data.Loaded.Event:Connect(function(p)
		for _, plot in plots do
			if not owners[plot] then
				owners[plot] = p; plotOf[p] = plot
				label(plot, p.DisplayName:upper() .. "'S BASE", Color3.fromRGB(255, 220, 80))
				p.RespawnLocation = nil
				Base.Render(p)
				local hrp = p.Character and p.Character:FindFirstChild("HumanoidRootPart")
				if hrp then hrp.CFrame = CFrame.new(plot.Spawn) end
				return
			end
		end
	end)
	Players.PlayerRemoving:Connect(function(p)
		clearCarry(p)
		for thief, c in carrying do if c.victim == p then clearCarry(thief) end end
		local plot = plotOf[p]
		if plot then
			owners[plot] = nil; plotOf[p] = nil
			for _, ped in plot.Pedestals do local h = ped:FindFirstChild("Hero"); if h then h:Destroy() end end
			label(plot, "EMPTY BASE", Color3.fromRGB(150, 150, 150))
		end
	end)
	-- Spawn players inside their own base
	Players.PlayerAdded:Connect(function(p)
		p.CharacterAdded:Connect(function(char)
			clearCarry(p)
			task.wait()
			local plot = plotOf[p]
			if plot and not char:GetAttribute("InDuel") then char:PivotTo(CFrame.new(plot.Spawn)) end
			char:FindFirstChildOfClass("Humanoid").Died:Connect(function() clearCarry(p) end)
		end)
	end)
	-- Getting hit while carrying drops the stolen hero (it returns home)
	Combat.OnDamage.Event:Connect(function(_, victimChar)
		local p = Players:GetPlayerFromCharacter(victimChar)
		if p and carrying[p] then
			Net.Fx:FireClient(p, "Alert", { text = "You dropped it!" })
			clearCarry(p)
		end
	end)
	-- Income + delivery + lock timers
	task.spawn(function()
		local acc = 0
		while true do
			local dt = task.wait(0.25); acc += dt
			for thief in carrying do
				local plot = plotOf[thief]; local hrp = thief.Character and thief.Character:FindFirstChild("HumanoidRootPart")
				if plot and hrp then
					local rel = plot.Zone.CFrame:PointToObjectSpace(hrp.Position)
					if math.abs(rel.X) < 29 and math.abs(rel.Z) < 29 and math.abs(rel.Y) < 10 then deliver(thief) end
				end
			end
			for _, plot in plots do
				if plot.Door.CanCollide ~= isLocked(plot) then setDoor(plot) end
				local p = owners[plot]
				if p then
					local left = (plot.Model:GetAttribute("LockedUntil") or 0) - os.clock()
					plot.LockPad.LockTag.L.Text = left > 0 and ("LOCKED " .. math.ceil(left) .. "s") or "STEP TO LOCK"
				end
			end
			if acc >= 1 then
				acc -= 1
				for p, plot in plotOf do
					local d = Data.Get(p)
					if d then
						local inc = 0
						for i, e in d.Owned do
							local away = false
							for _, c in carrying do if c.victim == p and c.index == i then away = true end end
							if not away then inc += Rarity.Tiers[e.R].Income end
						end
						if inc > 0 then Data.AddCash(p, inc) end
						p:SetAttribute("Income", inc)
					end
				end
			end
		end
	end)
end
return Base
