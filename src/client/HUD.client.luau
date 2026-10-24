-- Fighting-game HUD matching the reference footage:
-- top-left / top-right diamond portraits + slanted HP bars, center ROUND text + win pips,
-- bottom-center stamina/ult meter, ability hotbar, countdown + result splash, hero select.
local Players = game:GetService("Players")
local RS = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local Config = require(RS.Shared.Config)
local Heroes = require(RS.Shared.Heroes)
local Net = require(RS.Shared.Net)
local me = Players.LocalPlayer

local gui = Instance.new("ScreenGui"); gui.Name = "MvD_HUD"; gui.ResetOnSpawn = false; gui.IgnoreGuiInset = true
gui.Parent = me:WaitForChild("PlayerGui")

local FONT = Enum.Font.GothamBlack
local function new(class, props, parent)
	local o = Instance.new(class); for k, v in props do o[k] = v end; o.Parent = parent; return o
end
local function label(text, size, parent, props)
	local l = new("TextLabel", { BackgroundTransparency = 1, Font = FONT, Text = text, TextColor3 = Color3.new(1, 1, 1), TextSize = size, Size = UDim2.new(1, 0, 0, size + 4) }, parent)
	new("UIStroke", { Thickness = 1.5 }, l)
	for k, v in props or {} do l[k] = v end
	return l
end

-- Player panel (side = 1 left, -1 right)
local function panel(side)
	local root = new("Frame", { BackgroundTransparency = 1, Size = UDim2.new(0.4, 0, 0, 90),
		Position = side == 1 and UDim2.new(0.02, 0, 0.03, 0) or UDim2.new(0.58, 0, 0.03, 0) }, gui)
	local diamond = new("Frame", { Size = UDim2.fromOffset(60, 60), Rotation = 45, BackgroundColor3 = Color3.fromRGB(30, 30, 40),
		AnchorPoint = Vector2.new(0.5, 0.5), Position = side == 1 and UDim2.new(0, 40, 0, 45) or UDim2.new(1, -40, 0, 45) }, root)
	new("UIStroke", { Color = Color3.new(1, 1, 1), Thickness = 2 }, diamond)
	local face = new("ImageLabel", { BackgroundTransparency = 1, Size = UDim2.fromScale(1.1, 1.1), Position = UDim2.fromScale(-0.05, -0.05), Rotation = -45 }, diamond)
	local name = label("", 14, root, { Position = side == 1 and UDim2.new(0, 85, 0, 4) or UDim2.new(0, 0, 0, 4), Size = UDim2.new(1, -85, 0, 18),
		TextXAlignment = side == 1 and Enum.TextXAlignment.Left or Enum.TextXAlignment.Right })
	local barBg = new("Frame", { BackgroundColor3 = Color3.fromRGB(20, 20, 25), BorderSizePixel = 0, Size = UDim2.new(1, -90, 0, 16),
		Position = side == 1 and UDim2.new(0, 85, 0, 26) or UDim2.new(0, 5, 0, 26) }, root)
	new("UIStroke", { Color = Color3.new(1, 1, 1), Thickness = 1.5 }, barBg)
	local anchorX = side == 1 and 0 or 1
	local lag = new("Frame", { BackgroundColor3 = Color3.fromRGB(255, 255, 255), BorderSizePixel = 0, Size = UDim2.fromScale(1, 1), AnchorPoint = Vector2.new(anchorX, 0), Position = UDim2.fromScale(anchorX, 0) }, barBg)
	local hp = new("Frame", { BackgroundColor3 = Color3.fromRGB(230, 40, 60), BorderSizePixel = 0, Size = UDim2.fromScale(1, 1), AnchorPoint = Vector2.new(anchorX, 0), Position = UDim2.fromScale(anchorX, 0) }, barBg)
	new("UIGradient", { Color = ColorSequence.new(Color3.fromRGB(255, 90, 110), Color3.fromRGB(180, 20, 40)), Rotation = 90 }, hp)
	local st = new("Frame", { BackgroundColor3 = Color3.fromRGB(80, 200, 255), BorderSizePixel = 0, Size = UDim2.new(0.6, 0, 0, 4), AnchorPoint = Vector2.new(anchorX, 0),
		Position = side == 1 and UDim2.new(0, 85, 0, 46) or UDim2.new(1, -5, 0, 46) }, root)
	local pips = new("Frame", { BackgroundTransparency = 1, Size = UDim2.fromOffset(60, 14),
		Position = side == 1 and UDim2.new(0, 85, 0, 56) or UDim2.new(1, -65, 0, 56) }, root)
	new("UIListLayout", { FillDirection = Enum.FillDirection.Horizontal, Padding = UDim.new(0, 6),
		HorizontalAlignment = side == 1 and Enum.HorizontalAlignment.Left or Enum.HorizontalAlignment.Right }, pips)
	local pipList = {}
	for i = 1, Config.RoundsToWin do
		pipList[i] = new("Frame", { Size = UDim2.fromOffset(10, 10), Rotation = 45, BackgroundColor3 = Color3.fromRGB(40, 40, 50) }, pips)
		new("UIStroke", { Color = Color3.new(1, 1, 1) }, pipList[i])
	end
	return { root = root, face = face, name = name, hp = hp, lag = lag, st = st, pips = pipList, stMax = 0.6 }
end

local P = { panel(1), panel(-1) }
local center = label("ROUND", 22, gui, { Position = UDim2.new(0.5, -60, 0.035, 0), Size = UDim2.fromOffset(120, 26) })
local timer = label("", 28, gui, { Position = UDim2.new(0.5, -40, 0.075, 0), Size = UDim2.fromOffset(80, 30) })
local splash = label("", 90, gui, { Position = UDim2.new(0, 0, 0.35, 0), Size = UDim2.new(1, 0, 0, 100), TextTransparency = 1 })

-- Bottom-center ult meter + hotbar
local bottom = new("Frame", { BackgroundTransparency = 1, Size = UDim2.fromOffset(420, 90), AnchorPoint = Vector2.new(0.5, 1), Position = UDim2.new(0.5, 0, 1, -18) }, gui)
local ultBg = new("Frame", { BackgroundColor3 = Color3.fromRGB(20, 20, 30), Size = UDim2.new(1, 0, 0, 10), Position = UDim2.new(0, 0, 1, -10), BorderSizePixel = 0 }, bottom)
new("UIStroke", { Color = Color3.new(1, 1, 1), Thickness = 1.5 }, ultBg)
local ult = new("Frame", { BackgroundColor3 = Color3.fromRGB(110, 170, 255), Size = UDim2.fromScale(0, 1), BorderSizePixel = 0 }, ultBg)
local ultLbl = label("G", 14, bottom, { Position = UDim2.new(0.5, -15, 1, -30), Size = UDim2.fromOffset(30, 18) })
local hot = new("Frame", { BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 56) }, bottom)
new("UIListLayout", { FillDirection = Enum.FillDirection.Horizontal, HorizontalAlignment = Enum.HorizontalAlignment.Center, Padding = UDim.new(0, 8) }, hot)
local slots = {}
for i = 1, 4 do
	local f = new("Frame", { Size = UDim2.fromOffset(90, 50), BackgroundColor3 = Color3.fromRGB(20, 20, 30), BackgroundTransparency = 0.2 }, hot)
	new("UIStroke", { Color = Color3.new(1, 1, 1) }, f)
	local cd = new("Frame", { BackgroundColor3 = Color3.new(0, 0, 0), BackgroundTransparency = 0.4, Size = UDim2.fromScale(1, 0), AnchorPoint = Vector2.new(0, 1), Position = UDim2.fromScale(0, 1), BorderSizePixel = 0 }, f)
	label(tostring(i), 12, f, { Position = UDim2.fromOffset(4, 2), Size = UDim2.fromOffset(12, 14) })
	local n = label("", 11, f, { TextWrapped = true, Size = UDim2.new(1, -6, 1, -6), Position = UDim2.fromOffset(3, 6) })
	slots[i] = { cd = cd, name = n, readyAt = 0, dur = 1 }
end

-- Hero select (lobby)
local select = new("Frame", { BackgroundTransparency = 1, Size = UDim2.fromOffset(830, 170), AnchorPoint = Vector2.new(0.5, 1), Position = UDim2.new(0.5, 0, 1, -100) }, gui)
new("UIGridLayout", { CellSize = UDim2.fromOffset(130, 48), CellPadding = UDim2.fromOffset(8, 8), HorizontalAlignment = Enum.HorizontalAlignment.Center, SortOrder = Enum.SortOrder.Name }, select)
local pick = RS:WaitForChild("MvD_PickHero")
for id, h in Heroes do
	local b = new("TextButton", { Size = UDim2.fromOffset(130, 44), BackgroundColor3 = h.Color, Font = FONT, TextSize = 16, TextColor3 = Color3.new(1, 1, 1),
		Text = h.Name .. "\n" .. h.Faction .. " " .. (h.Role or "Hero"), Name = h.Faction .. h.Name }, select)
	new("UIStroke", { Color = Color3.new(1, 1, 1), ApplyStrokeMode = Enum.ApplyStrokeMode.Border }, b)
	b.Activated:Connect(function() pick:FireServer(id) end)
end

local function setHotbar(heroId)
	local h = Heroes[heroId]; if not h then return end
	for i, s in slots do s.name.Text = h.Abilities[i] and h.Abilities[i].Name or "" end
end
local UIS = game:GetService("UserInputService")
UIS.InputBegan:Connect(function(i, gp)
	if gp then return end
	local idx = ({ [Enum.KeyCode.One] = 1, [Enum.KeyCode.Two] = 2, [Enum.KeyCode.Three] = 3, [Enum.KeyCode.Four] = 4 })[i.KeyCode]
	local h = me.Character and Heroes[me.Character:GetAttribute("Hero")]
	if idx and h and slots[idx].readyAt < os.clock() then
		-- optimistic cooldown display (server is authoritative)
		slots[idx].dur = h.Abilities[idx].Cooldown; slots[idx].readyAt = os.clock() + slots[idx].dur
	end
end)

-- Match state
local match -- { p1, p2, wins }
local fightStart = 0
local function splashText(t, color)
	splash.Text = t; splash.TextColor3 = color or Color3.new(1, 1, 1); splash.TextTransparency = 0
	splash.TextSize = 130
	TweenService:Create(splash, TweenInfo.new(0.25, Enum.EasingStyle.Back), { TextSize = 90 }):Play()
	task.delay(1.1, function() TweenService:Create(splash, TweenInfo.new(0.3), { TextTransparency = 1 }):Play() end)
end
Net.Match.OnClientEvent:Connect(function(d)
	if d.phase == "Queued" then splashText("WAITING FOR OPPONENT", Color3.fromRGB(255, 220, 100)); return end
	if d.phase == "Unqueued" then return end
	match = d
	for i, info in { d.p1, d.p2 } do
		P[i].name.Text = info.name .. "  •  " .. (Heroes[info.hero] and Heroes[info.hero].Name or "")
		P[i].face.Image = ("rbxthumb://type=AvatarHeadShot&id=%d&w=150&h=150"):format(info.userId)
		for k, pip in P[i].pips do pip.BackgroundColor3 = d.wins[i] >= k and Color3.fromRGB(230, 40, 60) or Color3.fromRGB(40, 40, 50) end
	end
	if d.phase == "Countdown" then center.Text = "ROUND " .. d.round; splashText(d.n == 3 and d.round == 1 and d.arena and d.arena:upper() or tostring(d.n))
	elseif d.phase == "Fight" then splashText("FIGHT!", Color3.fromRGB(255, 70, 70)); fightStart = os.clock()
	elseif d.phase == "RoundEnd" then splashText(d.winner == me.UserId and "ROUND WON" or "ROUND LOST"); fightStart = 0
	elseif d.phase == "MatchEnd" then splashText(d.winner == me.UserId and "VICTORY" or "DEFEAT", d.winner == me.UserId and Color3.fromRGB(255, 215, 0) or Color3.fromRGB(200, 60, 60)); task.delay(4, function() match = nil end)
	end
end)

RunService.RenderStepped:Connect(function(dt)
	local inDuel = match ~= nil
	P[1].root.Visible = inDuel; P[2].root.Visible = inDuel; center.Visible = inDuel; timer.Visible = inDuel and fightStart > 0
	select.Visible = not inDuel
	if fightStart > 0 then timer.Text = tostring(math.max(0, math.ceil(Config.RoundTime - (os.clock() - fightStart)))) end
	if inDuel then
		for i, info in { match.p1, match.p2 } do
			local plr = Players:GetPlayerByUserId(info.userId)
			local c = plr and plr.Character; local hum = c and c:FindFirstChildOfClass("Humanoid")
			if hum then
				local f = math.clamp(hum.Health / hum.MaxHealth, 0, 1)
				P[i].hp.Size = UDim2.fromScale(f, 1)
				P[i].lag.Size = UDim2.fromScale(math.max(f, P[i].lag.Size.X.Scale - dt * 0.4), 1) -- white trailing damage
				P[i].st.Size = UDim2.new(P[i].stMax * (c:GetAttribute("Stamina") or 0) / Config.MaxStamina, 0, 0, 4)
			end
		end
	end
	local c = me.Character
	if c then
		setHotbar(c:GetAttribute("Hero"))
		local u = (c:GetAttribute("Ult") or 0) / 100
		ult.Size = UDim2.fromScale(u, 1)
		ult.BackgroundColor3 = u >= 1 and Color3.fromRGB(255, 70, 70) or Color3.fromRGB(110, 170, 255)
		ultLbl.TextColor3 = u >= 1 and Color3.fromRGB(255, 220, 100) or Color3.new(1, 1, 1)
	end
	for _, s in slots do s.cd.Size = UDim2.fromScale(1, math.clamp((s.readyAt - os.clock()) / s.dur, 0, 1)) end
end)
