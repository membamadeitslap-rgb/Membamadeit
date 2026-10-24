-- Saves Wins, Losses, Coins per player. Retries on DataStore failure; works in Studio without API access (just won't save).
local Players = game:GetService("Players")
local DataStoreService = game:GetService("DataStoreService")
local ok, store = pcall(DataStoreService.GetDataStore, DataStoreService, "MvD_v1")
local Data = {}
local DEFAULT = { Wins = 0, Losses = 0, Coins = 0 }
local WIN_COINS, LOSS_COINS = 25, 5

local function retry(fn)
	for i = 1, 3 do
		local s, r = pcall(fn); if s then return true, r end
		task.wait(i)
	end
	return false
end

local function load(p)
	local ls = Instance.new("Folder"); ls.Name = "leaderstats"
	local saved = ok and select(2, retry(function() return store:GetAsync("u" .. p.UserId) end)) or nil
	for k, v in DEFAULT do
		local iv = Instance.new("IntValue"); iv.Name = k; iv.Value = saved and saved[k] or v; iv.Parent = ls
	end
	ls.Parent = p
end

local function save(p)
	local ls = p:FindFirstChild("leaderstats"); if not (ok and ls) then return end
	local t = {}; for k in DEFAULT do t[k] = ls[k].Value end
	retry(function() store:SetAsync("u" .. p.UserId, t) end)
end

function Data.Reward(winner, loser)
	for p, won in { [winner] = true, [loser] = false } do
		local ls = p.Parent and p:FindFirstChild("leaderstats")
		if ls then
			if won then ls.Wins.Value += 1 else ls.Losses.Value += 1 end
			ls.Coins.Value += won and WIN_COINS or LOSS_COINS
			task.spawn(save, p)
		end
	end
end

function Data.Start()
	Players.PlayerAdded:Connect(load)
	for _, p in Players:GetPlayers() do task.spawn(load, p) end
	Players.PlayerRemoving:Connect(save)
	game:BindToClose(function() for _, p in Players:GetPlayers() do task.spawn(save, p) end; task.wait(3) end)
end
return Data
