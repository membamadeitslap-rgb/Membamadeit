-- Per-player save: Cash, Wins, Losses, Owned = { {H = heroId, R = rarity}, ... } (max ArenaBuilder.SLOTS).
-- Works in Studio without API access (just won't save).
local Players = game:GetService("Players")
local DataStoreService = game:GetService("DataStoreService")
local ok, store = pcall(DataStoreService.GetDataStore, DataStoreService, "MvD_v2")
local Data = {}
local profiles = {} -- [player] = table
Data.Loaded = Instance.new("BindableEvent") -- (player)
Data.Changed = Instance.new("BindableEvent") -- (player) roster changed
local WIN_CASH, LOSS_CASH = 500, 100
local START_CASH = 250

local function retry(fn)
	for i = 1, 3 do
		local s, r = pcall(fn); if s then return true, r end
		task.wait(i)
	end
	return false
end

local function stat(p, name, value)
	local ls = p:FindFirstChild("leaderstats"); if not ls then return end
	local v = ls:FindFirstChild(name)
	if not v then v = Instance.new("NumberValue"); v.Name = name; v.Parent = ls end
	v.Value = value
end

local function sync(p)
	local d = profiles[p]; if not d then return end
	stat(p, "Cash", math.floor(d.Cash)); stat(p, "Wins", d.Wins)
	p:SetAttribute("Cash", d.Cash)
	p:SetAttribute("Losses", d.Losses)
end

local function load(p)
	local ls = Instance.new("Folder"); ls.Name = "leaderstats"; ls.Parent = p
	local saved = nil
	if ok then
		local s, r = retry(function() return store:GetAsync("u" .. p.UserId) end)
		if s then saved = r end
	end
	saved = saved or {}
	profiles[p] = { Cash = saved.Cash or START_CASH, Wins = saved.Wins or 0, Losses = saved.Losses or 0, Owned = saved.Owned or {} }
	sync(p)
	Data.Loaded:Fire(p)
end

local function save(p)
	local d = profiles[p]; if not (ok and d) then return end
	retry(function() store:SetAsync("u" .. p.UserId, d) end)
end

function Data.Get(p) return profiles[p] end
function Data.AddCash(p, n)
	local d = profiles[p]; if not d then return false end
	if d.Cash + n < 0 then return false end
	d.Cash += n; sync(p); return true
end
function Data.AddHero(p, heroId, rarity, slots)
	local d = profiles[p]; if not d or #d.Owned >= slots then return false end
	table.insert(d.Owned, { H = heroId, R = rarity })
	Data.Changed:Fire(p); return true
end
function Data.RemoveHero(p, index)
	local d = profiles[p]; if not d or not d.Owned[index] then return nil end
	local h = table.remove(d.Owned, index)
	Data.Changed:Fire(p); return h
end

function Data.Reward(winner, loser)
	for p, won in { [winner] = true, [loser] = false } do
		local d = p.Parent and profiles[p]
		if d then
			if won then d.Wins += 1 else d.Losses += 1 end
			d.Cash += won and WIN_CASH or LOSS_CASH
			sync(p); task.spawn(save, p)
		end
	end
end

function Data.Start()
	Players.PlayerAdded:Connect(load)
	for _, p in Players:GetPlayers() do task.spawn(load, p) end
	Players.PlayerRemoving:Connect(function(p) save(p); profiles[p] = nil end)
	task.spawn(function() -- autosave
		while true do task.wait(120); for p in profiles do task.spawn(save, p) end end
	end)
	game:BindToClose(function() for p in profiles do task.spawn(save, p) end; task.wait(3) end)
end
return Data
