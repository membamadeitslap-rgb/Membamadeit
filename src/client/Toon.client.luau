-- Black ink outlines around characters. Roblox renders at most 31 Highlights at once, so only the
-- closest tagged models get one (leaving room for the impact-frame and rarity highlights).
local CollectionService = game:GetService("CollectionService")
local RS = game:GetService("ReplicatedStorage")
local Toon = require(RS.Shared.Toon)
local MAX = 24
local cam = workspace.CurrentCamera

local function outline(m)
	local h = m:FindFirstChild("InkOutline")
	if not h then
		h = Instance.new("Highlight"); h.Name = "InkOutline"
		h.FillTransparency = 1; h.OutlineTransparency = 0; h.OutlineColor = Color3.new(0, 0, 0)
		h.DepthMode = Enum.HighlightDepthMode.Occluded; h.Parent = m
	end
	return h
end

while true do
	local list = {}
	for _, m in CollectionService:GetTagged(Toon.Tag) do
		if m:IsDescendantOf(workspace) and not m:FindFirstChild("RarityGlow") then -- Mythic+ keep their colored outline
			local pivot = m:GetPivot().Position
			table.insert(list, { m = m, d = (pivot - cam.CFrame.Position).Magnitude })
		end
	end
	table.sort(list, function(a, b) return a.d < b.d end)
	for i, e in list do
		if i <= MAX then outline(e.m).Enabled = true
		else local h = e.m:FindFirstChild("InkOutline"); if h then h.Enabled = false end end
	end
	task.wait(0.3)
end
