-- Single RemoteEvent bus. Server creates, client waits.
local RS = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local Net = {}
local function get(name)
	if RunService:IsServer() then
		local r = RS:FindFirstChild(name) or Instance.new("RemoteEvent")
		r.Name = name; r.Parent = RS
		return r
	end
	return RS:WaitForChild(name)
end
Net.Action = get("MvD_Action") -- client -> server: ("M1"|"Dash"|"BlockStart"|"BlockEnd"|"Ability", slot)
Net.Fx = get("MvD_Fx")         -- server -> clients: (kind, data)
Net.Match = get("MvD_Match")   -- server -> clients: match/HUD state
return Net
