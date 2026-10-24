local Players = game:GetService("Players")
local RS = game:GetService("ReplicatedStorage")
local Heroes = require(RS.Shared.Heroes)
local map = require(script.Parent.ArenaBuilder).Build()
require(script.Parent.DuelService).Start(map)

-- Hero pick: client fires remote; default SpiderMan.
local pick = Instance.new("RemoteEvent"); pick.Name = "MvD_PickHero"; pick.Parent = RS
pick.OnServerEvent:Connect(function(p, id) if Heroes[id] then p:SetAttribute("Hero", id) end end)

Players.PlayerAdded:Connect(function(p)
	p:SetAttribute("Hero", "SpiderMan")
	local ls = Instance.new("Folder"); ls.Name = "leaderstats"; ls.Parent = p
	local w = Instance.new("IntValue"); w.Name = "Wins"; w.Parent = ls
end)
