-- Fighter select, styled after Mortal Kombat vs DC:
-- big P1 portrait left, big P2 portrait right, "VS" between, roster grid of YOUR base heroes at the bottom,
-- rarity-colored frames, countdown, lock-in reveal of the opponent's pick.
local Players = game:GetService("Players")
local RS = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local Net = require(RS.Shared.Net)
local Heroes = require(RS.Shared.Heroes)
local Skins = require(RS.Shared.Skins)
local Rarity = require(RS.Shared.Rarity)
local Mannequin = require(RS.Shared.Mannequin)
local me = Players.LocalPlayer
local queueRemote = RS:WaitForChild("MvD_Queue")

local FONT = Enum.Font.GothamBlack
local function new(c, props, parent) local o = Instance.new(c); for k, v in props do o[k] = v end; o.Parent = parent; return o end
local function stroke(o, t, col) return new("UIStroke", { Thickness = t or 2, Color = col or Color3.new(0, 0, 0), ApplyStrokeMode = Enum.ApplyStrokeMode.Contextual }, o) end

local gui = new("ScreenGui", { Name = "MvD_Select", ResetOnSpawn = false, IgnoreGuiInset = true, DisplayOrder = 10, Enabled = false }, me:WaitForChild("PlayerGui"))
local bg = new("Frame", { Size = UDim2.fromScale(1, 1), BackgroundColor3 = Color3.fromRGB(8, 8, 14), BorderSizePixel = 0 }, gui)
-- Split background: Marvel red left, DC blue right
local left = new("Frame", { Size = UDim2.fromScale(0.5, 1), BackgroundColor3 = Color3.fromRGB(120, 10, 20), BorderSizePixel = 0 }, bg)
new("UIGradient", { Transparency = NumberSequence.new(0.2, 1), Rotation = 0 }, left)
local right = new("Frame", { Size = UDim2.fromScale(0.5, 1), Position = UDim2.fromScale(0.5, 0), BackgroundColor3 = Color3.fromRGB(10, 40, 130), BorderSizePixel = 0 }, bg)
new("UIGradient", { Transparency = NumberSequence.new(1, 0.2), Rotation = 0 }, right)

local title = new("TextLabel", { BackgroundTransparency = 1, Font = FONT, TextSize = 40, Text = "SELECT YOUR FIGHTER", TextColor3 = Color3.fromRGB(255, 215, 80),
	Size = UDim2.new(1, 0, 0, 50), Position = UDim2.fromOffset(0, 16) }, bg)
stroke(title, 3)
local timer = new("TextLabel", { BackgroundTransparency = 1, Font = FONT, TextSize = 48, Text = "20", TextColor3 = Color3.new(1, 1, 1),
	AnchorPoint = Vector2.new(0.5, 0), Size = UDim2.fromOffset(120, 56), Position = UDim2.new(0.5, 0, 0, 64) }, bg)
stroke(timer, 3)
local vs = new("TextLabel", { BackgroundTransparency = 1, Font = FONT, TextSize = 110, Text = "VS", TextColor3 = Color3.fromRGB(255, 200, 60),
	AnchorPoint = Vector2.new(0.5, 0.5), Size = UDim2.fromOffset(240, 120), Position = UDim2.fromScale(0.5, 0.38) }, bg)
stroke(vs, 5, Color3.fromRGB(120, 20, 0))

-- Big fighter portrait panel (side 1 = left/P1, -1 = right/P2)
local function bigPanel(side)
	local f = new("Frame", { BackgroundTransparency = 1, AnchorPoint = Vector2.new(side == 1 and 0 or 1, 0),
		Position = side == 1 and UDim2.new(0, 30, 0, 110) or UDim2.new(1, -30, 0, 110), Size = UDim2.new(0.32, 0, 0.5, 0) }, bg)
	local vp = new("ViewportFrame", { BackgroundTransparency = 1, Size = UDim2.new(1, 0, 1, -70), Ambient = Color3.fromRGB(180, 180, 180), LightDirection = Vector3.new(-1, -1, -1) }, f)
	local cam = new("Camera", { FieldOfView = 40 }, vp); vp.CurrentCamera = cam
	local name = new("TextLabel", { BackgroundTransparency = 1, Font = FONT, TextSize = 30, TextColor3 = Color3.new(1, 1, 1),
		Size = UDim2.new(1, 0, 0, 34), Position = UDim2.new(0, 0, 1, -66), Text = "" }, f)
	stroke(name, 3)
	local sub = new("TextLabel", { BackgroundTransparency = 1, Font = FONT, TextSize = 20, TextColor3 = Color3.new(1, 1, 1),
		Size = UDim2.new(1, 0, 0, 24), Position = UDim2.new(0, 0, 1, -30), Text = "" }, f)
	stroke(sub, 2)
	local player = new("TextLabel", { BackgroundTransparency = 1, Font = FONT, TextSize = 18, TextColor3 = Color3.fromRGB(200, 200, 200),
		Size = UDim2.new(1, 0, 0, 20), Position = UDim2.new(0, 0, 0, -22), Text = "" }, f)
	stroke(player)
	return { frame = f, vp = vp, cam = cam, name = name, sub = sub, player = player, model = nil, side = side }
end
local P1, P2 = bigPanel(1), bigPanel(-1)

local function show(panel, heroId, rarity)
	if panel.model then panel.model:Destroy(); panel.model = nil end
	if not heroId then
		panel.name.Text = "?"; panel.sub.Text = "CHOOSING…"; panel.sub.TextColor3 = Color3.fromRGB(180, 180, 180); return
	end
	local m = Mannequin(heroId, rarity); m.Parent = panel.vp; panel.model = m
	panel.name.Text = Skins.Get(heroId, rarity).Name:upper()
	panel.sub.Text = rarity:upper() .. "  •  " .. Heroes[heroId].Faction:upper() .. " " .. (Heroes[heroId].Role or "Hero"):upper()
	panel.sub.TextColor3 = Rarity.Tiers[rarity].Color
	panel.frame.Position += UDim2.fromOffset(-40 * panel.side, 0)
	TweenService:Create(panel.frame, TweenInfo.new(0.25, Enum.EasingStyle.Back), { Position = panel.frame.Position + UDim2.fromOffset(40 * panel.side, 0) }):Play()
end

-- Roster grid (your owned heroes)
local grid = new("ScrollingFrame", { BackgroundColor3 = Color3.fromRGB(0, 0, 0), BackgroundTransparency = 0.4, BorderSizePixel = 0,
	AnchorPoint = Vector2.new(0.5, 1), Position = UDim2.new(0.5, 0, 1, -80), Size = UDim2.new(0.8, 0, 0, 230), ScrollBarThickness = 6,
	AutomaticCanvasSize = Enum.AutomaticSize.Y, CanvasSize = UDim2.new() }, bg)
stroke(grid, 2, Color3.fromRGB(255, 215, 80))
new("UIGridLayout", { CellSize = UDim2.fromOffset(110, 110), CellPadding = UDim2.fromOffset(8, 8), HorizontalAlignment = Enum.HorizontalAlignment.Center }, grid)
new("UIPadding", { PaddingTop = UDim.new(0, 8), PaddingLeft = UDim.new(0, 8), PaddingRight = UDim.new(0, 8) }, grid)

local lockBtn = new("TextButton", { Font = FONT, TextSize = 28, Text = "LOCK IN", TextColor3 = Color3.new(1, 1, 1), BackgroundColor3 = Color3.fromRGB(210, 30, 40),
	AnchorPoint = Vector2.new(0.5, 1), Position = UDim2.new(0.5, 0, 1, -20), Size = UDim2.fromOffset(240, 52) }, bg)
new("UICorner", {}, lockBtn); stroke(lockBtn, 3)

local selectedIndex, locked, deadline, owned = nil, false, 0, {}
local cells = {}

local function buildGrid()
	for _, c in cells do c:Destroy() end
	table.clear(cells)
	for i, e in owned do
		local tier = Rarity.Tiers[e.R]
		local cell = new("ImageButton", { BackgroundColor3 = Color3.fromRGB(20, 20, 28), AutoButtonColor = true, LayoutOrder = -tier.Index * 100 + i }, grid)
		local st = stroke(cell, 3, tier.Color); st.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
		local vp = new("ViewportFrame", { BackgroundTransparency = 1, Size = UDim2.new(1, 0, 1, -22), Ambient = Color3.fromRGB(200, 200, 200) }, cell)
		local cam = new("Camera", { FieldOfView = 35, CFrame = CFrame.lookAt(Vector3.new(0, 4.2, -7), Vector3.new(0, 4, 0)) }, vp); vp.CurrentCamera = cam
		Mannequin(e.H, e.R).Parent = vp
		local n = new("TextLabel", { BackgroundColor3 = tier.Color, BackgroundTransparency = 0.25, Font = FONT, TextScaled = true, TextColor3 = Color3.new(1, 1, 1),
			Size = UDim2.new(1, 0, 0, 22), Position = UDim2.new(0, 0, 1, -22), Text = Heroes[e.H].Name:upper() }, cell)
		stroke(n, 1.5)
		cell.MouseEnter:Connect(function() if not locked then show(P1, e.H, e.R) end end)
		cell.Activated:Connect(function()
			if locked then return end
			selectedIndex = i; show(P1, e.H, e.R)
			for _, c in cells do c.BackgroundColor3 = Color3.fromRGB(20, 20, 28) end
			cell.BackgroundColor3 = Color3.fromRGB(90, 70, 20)
		end)
		cells[i] = cell
	end
end

local function lockIn()
	if locked or not selectedIndex then return end
	locked = true
	queueRemote:FireServer("Pick", selectedIndex)
	lockBtn.Text = "LOCKED ✓"; lockBtn.BackgroundColor3 = Color3.fromRGB(40, 160, 60)
end
lockBtn.Activated:Connect(lockIn)

Net.Match.OnClientEvent:Connect(function(d)
	if d.phase == "Select" then
		owned, selectedIndex, locked = d.owned, nil, false
		deadline = os.clock() + d.time
		lockBtn.Text = "LOCK IN"; lockBtn.BackgroundColor3 = Color3.fromRGB(210, 30, 40)
		P1.player.Text = me.DisplayName; P2.player.Text = d.opponent.name
		buildGrid(); show(P1, nil); show(P2, nil)
		if owned[1] then selectedIndex = 1; show(P1, owned[1].H, owned[1].R) end
		gui.Enabled = true
		vs.TextSize = 200; TweenService:Create(vs, TweenInfo.new(0.4, Enum.EasingStyle.Bounce), { TextSize = 110 }):Play()
	elseif d.phase == "OpponentPicked" then
		show(P2, d.hero, d.rarity)
	elseif d.phase == "SelectDone" then
		title.Text = "FIGHT!"; task.delay(1.4, function() gui.Enabled = false; title.Text = "SELECT YOUR FIGHTER" end)
	elseif d.phase == "SelectCancelled" then
		gui.Enabled = false
	end
end)

RunService.RenderStepped:Connect(function()
	if not gui.Enabled then return end
	timer.Text = tostring(math.max(0, math.ceil(deadline - os.clock())))
	for _, p in { P1, P2 } do -- slow turntable, mirrored per side
		p.cam.CFrame = CFrame.Angles(0, math.sin(os.clock() * 0.6) * 0.5 + (p.side == 1 and 0.35 or -0.35), 0) * CFrame.new(0, 3.2, -11) * CFrame.Angles(0, math.pi, 0)
		p.cam.CFrame = CFrame.lookAt(p.cam.CFrame.Position, Vector3.new(0, 3, 0))
	end
end)
