-- Parkour movement (from the "new movement system" reference): sprint, double jump with a flip,
-- wall-run + wall-jump, slide, vault over low obstacles. Client-simulated (the client owns its
-- character physics); the server only relays the move so other players see the animation.
-- Shift = sprint, Space in air = double jump / hold Space beside a wall = wall-run, C or Ctrl = slide.
local UIS = game:GetService("UserInputService")
local RS = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local Net = require(RS.Shared.Net)
local Anim = require(RS.Shared.Anim)
local V = require(RS.Shared.VFX)
local player = Players.LocalPlayer
local M = Anim.Moves

local airJumps, busy, wallCd, vaultCd = 0, nil, 0, 0

local function rig()
	local char = player.Character
	local hrp = char and char:FindFirstChild("HumanoidRootPart")
	local hum = char and char:FindFirstChildOfClass("Humanoid")
	if hrp and hum and hum.Health > 0 then return char, hrp, hum end
end
local function free(char)
	return not (char:GetAttribute("Frozen") or char:GetAttribute("Stunned") or char:GetAttribute("Carrying") or char:GetAttribute("Blocking"))
end
local function airborne(hum)
	local s = hum:GetState()
	return s == Enum.HumanoidStateType.Freefall or s == Enum.HumanoidStateType.Jumping
end
local function setBusy(char, name)
	busy = name
	char:SetAttribute("Parkour", name) -- local-only flag: pauses lock-on while the move owns the body
end
local function rayParams(char)
	local p = RaycastParams.new(); p.FilterType = Enum.RaycastFilterType.Exclude; p.FilterDescendantsInstances = { char }
	return p
end
local function send(move) Net.Action:FireServer("Move", move) end

-- Sprint
UIS.InputBegan:Connect(function(i, gp)
	if gp then return end
	if i.KeyCode == Enum.KeyCode.LeftShift then Net.Action:FireServer("Sprint", true) end
end)
UIS.InputEnded:Connect(function(i)
	if i.KeyCode == Enum.KeyCode.LeftShift then Net.Action:FireServer("Sprint", false) end
end)

-- Double jump
local function doubleJump(char, hrp)
	airJumps += 1
	local v = hrp.AssemblyLinearVelocity
	hrp.AssemblyLinearVelocity = Vector3.new(v.X, 55, v.Z)
	Anim.Play(char, M.DoubleJump)
	V.Ring(hrp.Position - Vector3.new(0, 3, 0), Color3.fromRGB(230, 240, 255), 2.5, nil, 0.3)
	send("DoubleJump")
end

-- Slide: burst of speed that decays, body low
local function slide(char, hrp, hum)
	setBusy(char, "Slide")
	local dir = hum.MoveDirection.Unit
	local att = Instance.new("Attachment", hrp)
	local lv = Instance.new("LinearVelocity"); lv.Attachment0 = att; lv.MaxForce = 4e4
	lv.VelocityConstraintMode = Enum.VelocityConstraintMode.Plane
	lv.PrimaryTangentAxis = Vector3.xAxis; lv.SecondaryTangentAxis = Vector3.zAxis
	lv.Parent = hrp
	Anim.Play(char, M.Slide, { hold = true })
	send("Slide")
	local t0 = os.clock()
	while os.clock() - t0 < 0.65 and lv.Parent and not UIS:IsKeyDown(Enum.KeyCode.Space) do
		local k = 1 - (os.clock() - t0) / 0.65
		lv.PlaneVelocity = Vector2.new(dir.X, dir.Z) * (22 + 45 * k)
		if math.random() < 0.4 then V.Dust(hrp.Position - Vector3.new(0, 3, 0), 1) end
		RunService.Heartbeat:Wait()
	end
	lv:Destroy(); att:Destroy()
	Anim.Release(char)
	setBusy(char, nil)
end

-- Wall-run along a wall beside you while Space is held; release to kick off (wall jump)
local function wallRun(char, hrp, hum, normal, side)
	setBusy(char, "WallRun")
	local move = side < 0 and "WallRunL" or "WallRunR"
	Anim.Play(char, M[move], { hold = true })
	send(move)
	local params = rayParams(char)
	local look = hrp.CFrame.LookVector
	local along = (look - normal * look:Dot(normal)) * Vector3.new(1, 0, 1)
	along = along.Magnitude > 0.1 and along.Unit or look
	local t0, jumped = os.clock(), false
	while os.clock() - t0 < 1.3 do
		local t = os.clock() - t0
		if not UIS:IsKeyDown(Enum.KeyCode.Space) then jumped = true; break end
		local r = workspace:Raycast(hrp.Position, -normal * 3.5, params)
		if not r then break end
		normal = r.Normal
		hrp.AssemblyLinearVelocity = along * 42 + Vector3.new(0, 7 - t * 14, 0) - normal * 2
		hrp.CFrame = CFrame.lookAt(hrp.Position, hrp.Position + along)
		if math.random() < 0.3 then V.Dust(r.Position, 0.8) end
		RunService.Heartbeat:Wait()
	end
	Anim.Release(char)
	if jumped then -- wall jump: away from the wall and up, with a flip
		hrp.AssemblyLinearVelocity = normal * 40 + along * 20 + Vector3.new(0, 48, 0)
		Anim.Play(char, M.DoubleJump)
		send("WallJump")
		airJumps = 0 -- wall jump refreshes the double jump
	end
	wallCd = os.clock() + 0.4
	setBusy(char, nil)
end

-- Vault over waist-high obstacles while running (not in duels: the arena rail is a ring-out edge)
local function vault(char, hrp, hum)
	vaultCd = os.clock() + 0.8
	setBusy(char, "Vault")
	local dir = hum.MoveDirection.Unit
	hrp.AssemblyLinearVelocity = dir * 32 + Vector3.new(0, 38, 0)
	Anim.Play(char, M.Vault)
	send("Vault")
	task.wait(0.3)
	setBusy(char, nil)
end

UIS.InputBegan:Connect(function(i, gp)
	if gp then return end
	local char, hrp, hum = rig(); if not char or not free(char) or busy then return end
	if i.KeyCode == Enum.KeyCode.Space and airborne(hum) and airJumps < 1 then
		doubleJump(char, hrp)
	elseif (i.KeyCode == Enum.KeyCode.C or i.KeyCode == Enum.KeyCode.LeftControl) and not airborne(hum) and hum.MoveDirection.Magnitude > 0.5 then
		task.spawn(slide, char, hrp, hum)
	end
end)

RunService.Heartbeat:Connect(function()
	local char, hrp, hum = rig(); if not char then return end
	if not airborne(hum) then airJumps = 0 end
	if busy or not free(char) then return end
	local params
	if airborne(hum) and UIS:IsKeyDown(Enum.KeyCode.Space) and os.clock() > wallCd and hum.MoveDirection.Magnitude > 0.5 then
		params = rayParams(char)
		for _, side in { -1, 1 } do
			local r = workspace:Raycast(hrp.Position, hrp.CFrame.RightVector * side * 3, params)
			if r and math.abs(r.Normal.Y) < 0.3 and r.Instance.CanCollide then
				task.spawn(wallRun, char, hrp, hum, r.Normal, side)
				return
			end
		end
	end
	if not airborne(hum) and not char:GetAttribute("InDuel") and os.clock() > vaultCd and hum.MoveDirection.Magnitude > 0.5 then
		params = params or rayParams(char)
		local fwd = hum.MoveDirection.Unit * 3
		local low = workspace:Raycast(hrp.Position - Vector3.new(0, 1.4, 0), fwd, params)
		local high = workspace:Raycast(hrp.Position + Vector3.new(0, 2.2, 0), fwd * 1.5, params)
		if low and not high and math.abs(low.Normal.Y) < 0.3 and low.Instance.CanCollide then
			task.spawn(vault, char, hrp, hum)
		end
	end
end)

player.CharacterAdded:Connect(function() busy = nil; airJumps = 0 end)
