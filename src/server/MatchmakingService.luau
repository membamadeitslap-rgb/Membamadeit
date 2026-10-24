-- Queue -> pair two players -> fighter select (pick from your base roster) -> duel.
local Players = game:GetService("Players")
local RS = game:GetService("ReplicatedStorage")
local Net = require(RS.Shared.Net)
local Data = require(script.Parent.DataService)
local Duel = require(script.Parent.DuelService)

local MM = {}
local SELECT_TIME = 20
local queue = {} -- array of players
local picks = {} -- [player] = index into roster during select
local opp = {} -- [player] = opponent during select
local selecting = false

local remote = Instance.new("RemoteEvent"); remote.Name = "MvD_Queue"; remote.Parent = RS

local function inQueue(p) return table.find(queue, p) end
local function hasHeroes(p) local d = Data.Get(p); return d and #d.Owned > 0 end

local function startSelect(a, b)
	picks[a], picks[b] = nil, nil
	opp[a], opp[b] = b, a
	selecting = true
	for _, pair in { { a, b }, { b, a } } do
		local me, op = pair[1], pair[2]
		me:SetAttribute("Selecting", true)
		Net.Match:FireClient(me, { phase = "Select", time = SELECT_TIME, owned = Data.Get(me).Owned,
			opponent = { name = op.DisplayName, userId = op.UserId } })
	end
	local t0 = os.clock()
	while os.clock() - t0 < SELECT_TIME and not (picks[a] and picks[b]) and a.Parent and b.Parent do task.wait(0.2) end
	a:SetAttribute("Selecting", nil); b:SetAttribute("Selecting", nil)
	opp[a], opp[b] = nil, nil
	selecting = false
	if not (a.Parent and b.Parent) then
		for _, p in { a, b } do if p.Parent then Net.Match:FireClient(p, { phase = "SelectCancelled" }) end end
		return
	end
	local final = {}
	for _, p in { a, b } do
		local owned = Data.Get(p).Owned
		local i = picks[p] or math.random(#owned) -- timeout: random pick from roster
		final[p] = owned[i] and { H = owned[i].H, R = owned[i].R } or { H = "SpiderMan", R = "Common" }
	end
	for _, p in { a, b } do Net.Match:FireClient(p, { phase = "SelectDone" }) end
	task.wait(1.5)
	Duel.Run(a, b, final)
end

remote.OnServerEvent:Connect(function(p, action, arg)
	if action == "Join" then
		if inQueue(p) or p:GetAttribute("Selecting") then return end
		if not hasHeroes(p) then Net.Fx:FireClient(p, "Alert", { text = "Buy a hero from the convoy first!" }); return end
		if p:GetAttribute("Carrying") then return end
		table.insert(queue, p)
		Net.Match:FireClient(p, { phase = "Queued", count = #queue })
	elseif action == "Leave" then
		local i = inQueue(p); if i then table.remove(queue, i) end
		Net.Match:FireClient(p, { phase = "Unqueued" })
	elseif action == "Pick" and p:GetAttribute("Selecting") and type(arg) == "number" then
		local d = Data.Get(p)
		if d and d.Owned[arg] and not picks[p] then
			picks[p] = arg
			-- Reveal the pick to the opponent (MK-style lock-in)
			local other = opp[p]
			if other and other.Parent then
				Net.Match:FireClient(other, { phase = "OpponentPicked", hero = d.Owned[arg].H, rarity = d.Owned[arg].R })
			end
		end
	end
end)
Players.PlayerRemoving:Connect(function(p) local i = inQueue(p); if i then table.remove(queue, i) end end)

function MM.Start()
	task.spawn(function()
		while true do
			task.wait(1)
			if #queue >= 2 and not Duel.Busy() and not selecting then
				local a, b = table.remove(queue, 1), table.remove(queue, 1)
				if a.Parent and b.Parent and hasHeroes(a) and hasHeroes(b) then task.spawn(startSelect, a, b)
				else for _, p in { a, b } do if p.Parent then table.insert(queue, 1, p) end end end
			end
		end
	end)
end
return MM
