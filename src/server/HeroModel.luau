-- Builds a display rig for a hero variant: skin colors, weapons, aura, overhead tag.
local Players = game:GetService("Players")
local RS = game:GetService("ReplicatedStorage")
local Heroes = require(RS.Shared.Heroes)
local Skins = require(RS.Shared.Skins)
local Weapons = require(RS.Shared.Weapons)
local Rarity = require(RS.Shared.Rarity)
local HellCycle = require(RS.Shared.HellCycle)

local M = {}
local template
local function rig()
	if not template then
		template = Players:CreateHumanoidModelFromDescription(Instance.new("HumanoidDescription"), Enum.HumanoidRigType.R15)
	end
	return template:Clone()
end

-- extra: optional line under the name (e.g. "$750" price)
function M.Build(heroId, rarity, extra)
	local m = rig()
	m.Name = heroId
	local hum = m:FindFirstChildOfClass("Humanoid")
	hum.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.None
	Skins.Apply(m, heroId, rarity)
	for hand, id in (Heroes[heroId].Weapons or {}) do Weapons.Attach(m, id, hand) end
	for _, p in m:GetDescendants() do if p:IsA("BasePart") then p.CanCollide = false end end
	m.HumanoidRootPart.Anchored = true
	local skin = Skins.Get(heroId, rarity)
	if skin.HellCycle then -- parked beside the rider, angled toward the viewer
		local bike = HellCycle.Build(skin.Flame, skin.Flame2)
		local floor = m.HumanoidRootPart.CFrame * CFrame.new(0, -3, 0)
		bike:PivotTo(floor * CFrame.new(3.4, 2.3, 0.4) * CFrame.Angles(0, math.rad(-25), 0)) -- pivot is the seat (2.3 above ground)
		local w = Instance.new("WeldConstraint"); w.Part0 = m.HumanoidRootPart; w.Part1 = bike.PrimaryPart; w.Parent = bike.PrimaryPart
		bike.Parent = m
	end
	m:SetAttribute("Hero", heroId); m:SetAttribute("Rarity", rarity)

	local tier = Rarity.Tiers[rarity]
	local bb = Instance.new("BillboardGui"); bb.Name = "Tag"
	bb.Size = UDim2.fromOffset(220, 74); bb.StudsOffset = Vector3.new(0, 4.2, 0); bb.AlwaysOnTop = true; bb.MaxDistance = 90
	local function line(text, y, size, color)
		local l = Instance.new("TextLabel"); l.BackgroundTransparency = 1; l.Size = UDim2.new(1, 0, 0, size + 2); l.Position = UDim2.fromOffset(0, y)
		l.Font = Enum.Font.GothamBlack; l.TextSize = size; l.Text = text; l.TextColor3 = color
		local s = Instance.new("UIStroke"); s.Thickness = 2; s.Parent = l
		l.Parent = bb; return l
	end
	line(Skins.Get(heroId, rarity).Name, 0, 16, Color3.new(1, 1, 1))
	local r = line(rarity:upper(), 18, 14, tier.Color); r.Name = "Rarity"
	if rarity == "Secret" then game:GetService("CollectionService"):AddTag(r, "Rainbow") end
	line("$" .. Rarity.Format(tier.Income) .. "/s", 34, 14, Color3.fromRGB(90, 255, 110))
	if extra then line(extra, 52, 16, Color3.fromRGB(255, 220, 80)).Name = "Extra" end
	bb.Parent = m.Head
	return m
end
return M
