local map = require(script.Parent.ArenaBuilder).Build()
local Data = require(script.Parent.DataService)
local Base = require(script.Parent.BaseService)
local Duel = require(script.Parent.DuelService)

Base.Start(map) -- must connect to Data.Loaded before Data.Start
Duel.Start(map)
Duel.OnMatchEnd.Event:Connect(Data.Reward)
require(script.Parent.ConvoyService).Start(map)
require(script.Parent.MatchmakingService).Start()
Data.Start()
