local Players = game:GetService("Players")
local RS = game:GetService("ReplicatedStorage")
local Heroes = require(RS.Shared.Heroes)
local map = require(script.Parent.ArenaBuilder).Build()
local Duel = require(script.Parent.DuelService)
local Data = require(script.Parent.DataService)
Data.Start()
Duel.Start(map)
Duel.OnMatchEnd.Event:Connect(Data.Reward)

-- Hero pick: client fires remote; default SpiderMan.
local pick = Instance.new("RemoteEvent"); pick.Name = "MvD_PickHero"; pick.Parent = RS
pick.OnServerEvent:Connect(function(p, id) if Heroes[id] then p:SetAttribute("Hero", id) end end)

Players.PlayerAdded:Connect(function(p)
	p:SetAttribute("Hero", "SpiderMan")
end)
