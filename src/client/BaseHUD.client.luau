-- Base-world HUD: cash + income, slots, FIGHT (queue) button, alerts, carry banner, rainbow Secret effects.
local Players = game:GetService("Players")
local RS = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local PPS = game:GetService("ProximityPromptService")
local CollectionService = game:GetService("CollectionService")
local Net = require(RS.Shared.Net)
local Rarity = require(RS.Shared.Rarity)
local me = Players.LocalPlayer
local queueRemote = RS:WaitForChild("MvD_Queue")

local gui = Instance.new("ScreenGui"); gui.Name = "MvD_Base"; gui.ResetOnSpawn = false; gui.Parent = me:WaitForChild("PlayerGui")
local FONT = Enum.Font.GothamBlack
local function new(c, props, parent) local o = Instance.new(c); for k, v in props do o[k] = v end; o.Parent = parent; return o end
local function stroke(o, t) return new("UIStroke", { Thickness = t or 2, ApplyStrokeMode = Enum.ApplyStrokeMode.Contextual }, o) end

-- Cash (top center, big green, Brainrot-style)
local cash = new("TextLabel", { BackgroundTransparency = 1, Font = FONT, TextSize = 42, TextColor3 = Color3.fromRGB(90, 255, 110),
	AnchorPoint = Vector2.new(0.5, 0), Position = UDim2.new(0.5, 0, 0, 8), Size = UDim2.fromOffset(400, 46), Text = "$0" }, gui)
stroke(cash, 3)
local income = new("TextLabel", { BackgroundTransparency = 1, Font = FONT, TextSize = 20, TextColor3 = Color3.fromRGB(200, 255, 200),
	AnchorPoint = Vector2.new(0.5, 0), Position = UDim2.new(0.5, 0, 0, 54), Size = UDim2.fromOffset(300, 24), Text = "+$0/s" }, gui)
stroke(income)
local slots = new("TextLabel", { BackgroundTransparency = 1, Font = FONT, TextSize = 18, TextColor3 = Color3.new(1, 1, 1),
	AnchorPoint = Vector2.new(0.5, 0), Position = UDim2.new(0.5, 0, 0, 78), Size = UDim2.fromOffset(300, 22), Text = "" }, gui)
stroke(slots)

-- FIGHT button (left middle)
local fight = new("TextButton", { Font = FONT, TextSize = 30, Text = "⚔ FIGHT", TextColor3 = Color3.new(1, 1, 1),
	BackgroundColor3 = Color3.fromRGB(210, 30, 40), AnchorPoint = Vector2.new(0, 0.5), Position = UDim2.new(0, 16, 0.5, 0), Size = UDim2.fromOffset(170, 64) }, gui)
new("UICorner", { CornerRadius = UDim.new(0, 12) }, fight); stroke(fight, 3)
new("UIGradient", { Color = ColorSequence.new(Color3.fromRGB(255, 120, 120), Color3.fromRGB(150, 20, 30)), Rotation = 90 }, fight)
local queued = false
fight.Activated:Connect(function() queueRemote:FireServer(queued and "Leave" or "Join") end)

-- Alerts (stacked toasts under the cash)
local alerts = new("Frame", { BackgroundTransparency = 1, AnchorPoint = Vector2.new(0.5, 0), Position = UDim2.new(0.5, 0, 0, 110), Size = UDim2.fromOffset(700, 200) }, gui)
new("UIListLayout", { HorizontalAlignment = Enum.HorizontalAlignment.Center, Padding = UDim.new(0, 4) }, alerts)
local function alert(text, color)
	local l = new("TextLabel", { BackgroundTransparency = 1, Font = FONT, TextSize = 24, Text = text, TextColor3 = color or Color3.new(1, 1, 1), Size = UDim2.new(1, 0, 0, 28) }, alerts)
	stroke(l)
	task.delay(3, function()
		TweenService:Create(l, TweenInfo.new(0.4), { TextTransparency = 1 }):Play()
		task.wait(0.4); l:Destroy()
	end)
end

-- Carry banner
local carry = new("TextLabel", { BackgroundColor3 = Color3.fromRGB(200, 30, 40), BackgroundTransparency = 0.2, Font = FONT, TextSize = 22, TextColor3 = Color3.new(1, 1, 1),
	AnchorPoint = Vector2.new(0.5, 1), Position = UDim2.new(0.5, 0, 1, -30), Size = UDim2.fromOffset(520, 44), Visible = false }, gui)
new("UICorner", {}, carry); stroke(carry)

Net.Fx.OnClientEvent:Connect(function(kind, d)
	if kind == "Alert" then alert(d.text, d.color or (d.good and Color3.fromRGB(90, 255, 110)) or nil) end
end)
Net.Match.OnClientEvent:Connect(function(d)
	if d.phase == "Queued" then queued = true; fight.Text = "SEARCHING…"; alert("Searching for an opponent…", Color3.fromRGB(255, 220, 100))
	elseif d.phase == "Unqueued" or d.phase == "Select" or d.phase == "SelectCancelled" then queued = false; fight.Text = "⚔ FIGHT" end
end)

-- Hide steal prompts on your own heroes
PPS.PromptShown:Connect(function(prompt)
	if prompt:GetAttribute("Owner") == me.UserId then prompt.Enabled = false end
end)

RunService.RenderStepped:Connect(function()
	local inDuel = me.Character and me.Character:GetAttribute("InDuel")
	local selecting = me:GetAttribute("Selecting")
	for _, o in { cash, income, slots, fight } do o.Visible = not inDuel and not selecting end
	cash.Text = "$" .. Rarity.Format(me:GetAttribute("Cash") or 0)
	income.Text = "+$" .. Rarity.Format(me:GetAttribute("Income") or 0) .. "/s"
	slots.Text = "Heroes " .. (me:GetAttribute("Slots") or "0/10")
	local c = me:GetAttribute("Carrying")
	carry.Visible = c ~= nil
	if c then carry.Text = "STEALING " .. c:upper() .. " — RUN HOME!" end
	-- Secret rarity rainbow
	local hue = Color3.fromHSV((os.clock() * 0.3) % 1, 0.8, 1)
	for _, h in CollectionService:GetTagged("Rainbow") do
		if h:IsA("Highlight") then h.OutlineColor = hue elseif h:IsA("TextLabel") then h.TextColor3 = hue end
	end
end)
