-- 1v1 queue via two lobby pads -> best-of-3 rounds in the arena -> back to lobby.
local Players = game:GetService("Players")
local RS = game:GetService("ReplicatedStorage")
local Config = require(RS.Shared.Config)
local Net = require(RS.Shared.Net)
local Combat = require(script.Parent.CombatService)

local Duel = {}
Duel.OnMatchEnd = Instance.new("BindableEvent") -- (winner, loser)
local map, busy = nil, false
local Skins = require(RS.Shared.Skins)

local function tp(p, pos, look)
	local hrp = p.Character and p.Character:FindFirstChild("HumanoidRootPart")
	if hrp then hrp.CFrame = CFrame.lookAt(pos, Vector3.new(look.X, pos.Y, look.Z)) end
end

local function broadcast(a, b, data)
	for i, p in { a, b } do
		local pick = data.picks[p]
		data["p" .. i] = { name = p.DisplayName, userId = p.UserId, hero = pick.H, rarity = pick.R, skin = Skins.Get(pick.H, pick.R).Name }
	end
	data.picks = nil
	Net.Match:FireClient(a, data); Net.Match:FireClient(b, data)
end

local function freeze(p, on)
	if p.Character then p.Character:SetAttribute("Frozen", on or nil) end
end

local function runDuel(a, b, picks)
	busy = true
	local wins = { [a] = 0, [b] = 0 }
	local round = 0
	local arena = map.Arenas[math.random(#map.Arenas)]
	while wins[a] < Config.RoundsToWin and wins[b] < Config.RoundsToWin do
		round += 1
		for _, p in { a, b } do
			if not p.Parent then break end
			p:LoadCharacter(); task.wait(0.1)
			Combat.SetupCharacter(p, picks[p].H, picks[p].R)
			p.Character:SetAttribute("InDuel", true)
		end
		if not (a.Parent and b.Parent) then break end
		tp(a, arena.SpawnA, arena.Center); tp(b, arena.SpawnB, arena.Center)
		freeze(a, true); freeze(b, true)
		for i = 3, 1, -1 do broadcast(a, b, { picks = picks, phase = "Countdown", n = i, arena = arena.Name, round = round, wins = { wins[a], wins[b] } }); task.wait(1) end
		freeze(a, false); freeze(b, false)
		broadcast(a, b, { picks = picks, phase = "Fight", round = round, wins = { wins[a], wins[b] } })
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
		broadcast(a, b, { picks = picks, phase = "RoundEnd", winner = winner.UserId, round = round, wins = { wins[a], wins[b] } })
		task.wait(3)
		if not (a.Parent and b.Parent) then break end
	end
	local champ = (not b.Parent or wins[a] > wins[b]) and a or b
	if a.Parent and b.Parent then broadcast(a, b, { picks = picks, phase = "MatchEnd", winner = champ.UserId, wins = { wins[a], wins[b] } }) end
	Duel.OnMatchEnd:Fire(champ, champ == a and b or a)
	task.wait(4)
	for _, p in { a, b } do if p.Parent then p:LoadCharacter() end end
	busy = false
end

function Duel.Start(m) map = m end
function Duel.Busy() return busy end
function Duel.Run(a, b, picks)
	if busy then return false end
	task.spawn(runDuel, a, b, picks); return true
end
return Duel
