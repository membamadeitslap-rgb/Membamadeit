-- Controls (Soul Calibur layout on keyboard/mouse):
-- LMB = Horizontal (A), RMB = Vertical (B), R = Kick (K), F (hold) = Guard (tap right before a hit = Guard Impact),
-- Q = dash (hold A/D = sidestep, dodges verticals), 1-4 = abilities, G = Critical Edge, T = toggle lock-on.
-- In duels you auto-face your opponent (8-way run): WASD strafes and circles around them.
local UIS = game:GetService("UserInputService")
local RS = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local Config = require(RS.Shared.Config)
local Net = require(RS.Shared.Net)
local Anim = require(RS.Shared.Anim)
local player = Players.LocalPlayer

local keys = { [Enum.KeyCode.One] = 1, [Enum.KeyCode.Two] = 2, [Enum.KeyCode.Three] = 3, [Enum.KeyCode.Four] = 4 }
local lockOn = true

UIS.InputBegan:Connect(function(i, gp)
	if gp then return end
	if i.UserInputType == Enum.UserInputType.MouseButton1 then Net.Action:FireServer("M1", "H")
	elseif i.UserInputType == Enum.UserInputType.MouseButton2 then Net.Action:FireServer("M1", "V")
	elseif i.KeyCode == Enum.KeyCode.R then Net.Action:FireServer("M1", "K")
	elseif i.KeyCode == Enum.KeyCode.F then Net.Action:FireServer("BlockStart")
	elseif i.KeyCode == Enum.KeyCode.Q then
		local side = (UIS:IsKeyDown(Enum.KeyCode.A) or UIS:IsKeyDown(Enum.KeyCode.D)) and not UIS:IsKeyDown(Enum.KeyCode.W)
		Net.Action:FireServer("Dash", side and "Side" or nil)
	elseif i.KeyCode == Enum.KeyCode.G then Net.Action:FireServer("Ability", "Ult")
	elseif i.KeyCode == Enum.KeyCode.T then lockOn = not lockOn
	elseif keys[i.KeyCode] then Net.Action:FireServer("Ability", keys[i.KeyCode]) end
end)
UIS.InputEnded:Connect(function(i)
	if i.KeyCode == Enum.KeyCode.F then Net.Action:FireServer("BlockEnd") end
end)

-- Dash / sidestep: server approves, client applies velocity (client owns its character physics).
Net.Fx.OnClientEvent:Connect(function(kind, d)
	if kind ~= "DashOk" then return end
	local char = player.Character; local hrp = char and char:FindFirstChild("HumanoidRootPart")
	local hum = char and char:FindFirstChildOfClass("Humanoid"); if not hrp then return end
	local dir, speed = hum.MoveDirection.Magnitude > 0.1 and hum.MoveDirection or hrp.CFrame.LookVector, Config.Dash.Speed
	if d and d.side then
		dir = hrp.CFrame.RightVector * (UIS:IsKeyDown(Enum.KeyCode.A) and -1 or 1)
		speed = Config.Sidestep.Speed
	end
	local att = Instance.new("Attachment", hrp)
	local lv = Instance.new("LinearVelocity"); lv.Attachment0 = att; lv.MaxForce = 1e6
	lv.VelocityConstraintMode = Enum.VelocityConstraintMode.Plane
	lv.PrimaryTangentAxis = Vector3.xAxis; lv.SecondaryTangentAxis = Vector3.zAxis
	lv.PlaneVelocity = Vector2.new(dir.X, dir.Z) * speed
	lv.Parent = hrp
	task.delay(Config.Dash.Duration, function() lv:Destroy(); att:Destroy() end)
end)

-- Lock-on: face the nearest opponent while in a duel (disabled while parkour moves own the body)
local function opponent(char)
	local hrp = char:FindFirstChild("HumanoidRootPart")
	local best, bestD
	for _, p in Players:GetPlayers() do
		local c = p.Character
		if p ~= player and c and c:GetAttribute("InDuel") and c:FindFirstChild("HumanoidRootPart") then
			local dd = (c.HumanoidRootPart.Position - hrp.Position).Magnitude
			if dd < 90 and (not bestD or dd < bestD) then best, bestD = c, dd end
		end
	end
	return best
end
RunService.RenderStepped:Connect(function()
	local char = player.Character
	local hrp = char and char:FindFirstChild("HumanoidRootPart")
	local hum = char and char:FindFirstChildOfClass("Humanoid")
	if not (hrp and hum) then return end
	local target = lockOn and char:GetAttribute("InDuel") and not char:GetAttribute("Parkour") and hum.Health > 0 and opponent(char)
	hum.AutoRotate = not target
	if target then
		local p = target.HumanoidRootPart.Position
		hrp.CFrame = CFrame.lookAt(hrp.Position, Vector3.new(p.X, hrp.Position.Y, p.Z))
	end
end)

-- Victory pose for the round winner
Net.Match.OnClientEvent:Connect(function(data)
	if (data.phase == "RoundEnd" or data.phase == "MatchEnd") and data.winner == player.UserId and player.Character then
		Anim.Play(player.Character, Anim.Moves.Victory)
	end
end)
