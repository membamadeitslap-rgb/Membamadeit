-- Lightweight blocky figure in a hero skin's colors, for ViewportFrames (select screen portraits).
local RS = game:GetService("ReplicatedStorage")
local Skins = require(script.Parent.Skins)
local Heroes = require(script.Parent.Heroes)
local Weapons = require(script.Parent.Weapons)
return function(heroId, rarity)
	local skin = Skins.Get(heroId, rarity)
	local m = Instance.new("Model")
	local function p(name, size, pos, color)
		local x = Instance.new("Part"); x.Name = name; x.Size = size; x.Position = pos; x.Color = color
		x.Anchored = true; x.Material = Enum.Material.SmoothPlastic; x.Parent = m; return x
	end
	local head = p("Head", Vector3.new(1.2, 1.2, 1.2), Vector3.new(0, 4.6, 0), skin.Primary)
	local eyes = p("Eyes", Vector3.new(0.8, 0.25, 0.05), Vector3.new(0, 4.7, -0.62), Color3.new(1, 1, 1)); eyes.Material = Enum.Material.Neon
	p("Torso", Vector3.new(2, 2, 1), Vector3.new(0, 3, 0), skin.Primary)
	p("Belt", Vector3.new(2.05, 0.3, 1.05), Vector3.new(0, 2.1, 0), skin.Secondary)
	p("LeftArm", Vector3.new(1, 2, 1), Vector3.new(-1.5, 3, 0), skin.Primary)
	p("RightArm", Vector3.new(1, 2, 1), Vector3.new(1.5, 3, 0), skin.Primary)
	p("LeftHand", Vector3.new(1, 0.4, 1), Vector3.new(-1.5, 1.8, 0), skin.Secondary)
	p("RightHand", Vector3.new(1, 0.4, 1), Vector3.new(1.5, 1.8, 0), skin.Secondary)
	p("LeftLeg", Vector3.new(1, 2, 1), Vector3.new(-0.5, 1, 0), skin.Secondary)
	p("RightLeg", Vector3.new(1, 2, 1), Vector3.new(0.5, 1, 0), skin.Secondary)
	for hand, id in (Heroes[heroId].Weapons or {}) do
		local w = Weapons.Attach(m, id, hand)
		if w then for _, x in w:GetDescendants() do if x:IsA("BasePart") then x.Anchored = true end end end
	end
	m.PrimaryPart = head
	return m
end
