-- Controls: LMB = M1, F (hold) = block, Q = dash, 1-4 = abilities, G = ultimate.
local UIS = game:GetService("UserInputService")
local RS = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local Config = require(RS.Shared.Config)
local Net = require(RS.Shared.Net)
local player = Players.LocalPlayer

local keys = { [Enum.KeyCode.One] = 1, [Enum.KeyCode.Two] = 2, [Enum.KeyCode.Three] = 3, [Enum.KeyCode.Four] = 4 }

UIS.InputBegan:Connect(function(i, gp)
	if gp then return end
	if i.UserInputType == Enum.UserInputType.MouseButton1 then Net.Action:FireServer("M1")
	elseif i.KeyCode == Enum.KeyCode.F then Net.Action:FireServer("BlockStart")
	elseif i.KeyCode == Enum.KeyCode.Q then Net.Action:FireServer("Dash")
	elseif i.KeyCode == Enum.KeyCode.G then Net.Action:FireServer("Ability", "Ult")
	elseif keys[i.KeyCode] then Net.Action:FireServer("Ability", keys[i.KeyCode]) end
end)
UIS.InputEnded:Connect(function(i)
	if i.KeyCode == Enum.KeyCode.F then Net.Action:FireServer("BlockEnd") end
end)

-- Dash: server approves, client applies velocity (client owns its character physics).
Net.Fx.OnClientEvent:Connect(function(kind)
	if kind ~= "DashOk" then return end
	local char = player.Character; local hrp = char and char:FindFirstChild("HumanoidRootPart")
	local hum = char and char:FindFirstChildOfClass("Humanoid"); if not hrp then return end
	local dir = hum.MoveDirection.Magnitude > 0.1 and hum.MoveDirection or hrp.CFrame.LookVector
	local att = Instance.new("Attachment", hrp)
	local lv = Instance.new("LinearVelocity"); lv.Attachment0 = att; lv.MaxForce = 1e6
	lv.VelocityConstraintMode = Enum.VelocityConstraintMode.Plane
	lv.PrimaryTangentAxis = Vector3.xAxis; lv.SecondaryTangentAxis = Vector3.zAxis
	lv.PlaneVelocity = Vector2.new(dir.X, dir.Z) * Config.Dash.Speed
	lv.Parent = hrp
	task.delay(Config.Dash.Duration, function() lv:Destroy(); att:Destroy() end)
end)
