-- 1v1 queue via two lobby pads -> best-of-3 rounds in the arena -> back to lobby.
local Players = game:GetService("Players")
local RS = game:GetService("ReplicatedStorage")
local Config = require(RS.Shared.Config)
local Net = require(RS.Shared.Net)
local Combat = require(script.Parent.CombatService)

local Duel = {}
local map, onPad, busy = nil, { nil, nil }, false

local function tp(p, pos, look)
	local hrp = p.Character and p.Character:FindFirstChild("HumanoidRootPart")
	if hrp then hrp.CFrame = CFrame.lookAt(pos, Vector3.new(look.X, pos.Y, look.Z)) end
end

local function broadcast(a, b, data)
	data.p1 = { name = a.DisplayName, userId = a.UserId, hero = a:GetAttribute("Hero") }
	data.p2 = { name = b.DisplayName, userId = b.UserId, hero = b:GetAttribute("Hero") }
	Net.Match:FireAllClients(data)
end

local function freeze(p, on)
	local hum = p.Character and p.Character:FindFirstChildOfClass("Humanoid")
	if hum then hum.WalkSpeed = on and 0 or 16; hum.JumpPower = on and 0 or 50 end
end

local function runDuel(a, b)
	busy = true
	local wins = { [a] = 0, [b] = 0 }
	local round = 0
	while wins[a] < Config.RoundsToWin and wins[b] < Config.RoundsToWin do
		round += 1
		for _, p in { a, b } do
			if not p.Parent then break end
			p:LoadCharacter(); task.wait(0.1)
			Combat.SetupCharacter(p, p:GetAttribute("Hero") or "SpiderMan")
			p.Character:SetAttribute("InDuel", true)
		end
		if not (a.Parent and b.Parent) then break end
		tp(a, map.SpawnA, map.ArenaCenter); tp(b, map.SpawnB, map.ArenaCenter)
		freeze(a, true); freeze(b, true)
		for i = 3, 1, -1 do broadcast(a, b, { phase = "Countdown", n = i, round = round, wins = { wins[a], wins[b] } }); task.wait(1) end
		freeze(a, false); freeze(b, false)
		broadcast(a, b, { phase = "Fight", round = round, wins = { wins[a], wins[b] } })
		local winner, t0 = nil, os.clock()
		while not winner do
			task.wait(0.1)
			local ha = a.Character and a.Character:FindFirstChildOfClass("Humanoid")
			local hb = b.Character and b.Character:FindFirstChildOfClass("Humanoid")
			if not a.Parent or not ha or ha.Health <= 0 then winner = b
			elseif not b.Parent or not hb or hb.Health <= 0 then winner = a
			elseif os.clock() - t0 > Config.RoundTime then winner = ha.Health >= hb.Health and a or b end
		end
		wins[winner] += 1
		broadcast(a, b, { phase = "RoundEnd", winner = winner.UserId, round = round, wins = { wins[a], wins[b] } })
		task.wait(3)
		if not (a.Parent and b.Parent) then break end
	end
	local champ = wins[a] > wins[b] and a or b
	if a.Parent and b.Parent then broadcast(a, b, { phase = "MatchEnd", winner = champ.UserId, wins = { wins[a], wins[b] } }) end
	local ls = champ:FindFirstChild("leaderstats"); if ls then ls.Wins.Value += 1 end
	task.wait(4)
	for _, p in { a, b } do if p.Parent then p:LoadCharacter() end end
	busy = false
end

function Duel.Start(m)
	map = m
	for i, pad in map.Pads do
		pad.Touched:Connect(function(hit)
			local p = Players:GetPlayerFromCharacter(hit.Parent)
			if not p or busy or onPad[1] == p or onPad[2] == p then return end
			if not onPad[i] then onPad[i] = p; Net.Match:FireClient(p, { phase = "Queued" }) end
			if onPad[1] and onPad[2] then
				local a, b = onPad[1], onPad[2]; onPad = { nil, nil }
				task.spawn(runDuel, a, b)
			end
		end)
		pad.TouchEnded:Connect(function(hit)
			local p = Players:GetPlayerFromCharacter(hit.Parent)
			if p and onPad[i] == p then task.delay(0.5, function()
				local hrp = p.Character and p.Character:FindFirstChild("HumanoidRootPart")
				if hrp and (hrp.Position - pad.Position).Magnitude > 6 then onPad[i] = nil; Net.Match:FireClient(p, { phase = "Unqueued" }) end
			end) end
		end)
	end
end
return Duel
