-- Cosmetic variant per hero per rarity: { Name, Primary (torso/arms), Secondary (legs/head accents) }.
-- Higher tiers also get aura effects (see Skins.Apply).
local C = Color3.fromRGB
-- opts (optional): Colors = { group = color } overrides, Extra = { costume pieces } added, Pieces = replace defaults
local function v(name, a, b, opts)
	local t = { Name = name, Primary = a, Secondary = b }
	for k, x in opts or {} do t[k] = x end
	return t
end
local S = {}
-- One file per hero: src/shared/SkinData/<HeroId>.luau
S.Data = {}
for _, mod in script.Parent:WaitForChild("SkinData"):GetChildren() do
	if mod:IsA("ModuleScript") then S.Data[mod.Name] = require(mod)(v, C) end
end

local Rarity = require(script.Parent.Rarity)
local Costume = require(script.Parent.Costume)
local Body = require(script.Parent.Body)
local PaperDoll = require(script.Parent.PaperDoll)
function S.Get(heroId, rarity)
	return S.Data[heroId] and S.Data[heroId][rarity] or S.Data[heroId] and S.Data[heroId].Common
end

-- Recolor a rig and add aura by tier. Works on R15 and R6.
function S.Apply(model, heroId, rarity)
	local skin = S.Get(heroId, rarity); if not skin then return end
	Body.Shape(model, heroId) -- hero proportions first, so costume pieces size to the new body
	local primary = { UpperTorso = 1, LowerTorso = 1, Torso = 1, LeftUpperArm = 1, RightUpperArm = 1, LeftLowerArm = 1, RightLowerArm = 1, ["Left Arm"] = 1, ["Right Arm"] = 1, Head = 1 }
	for _, p in model:GetChildren() do
		if p:IsA("BasePart") and p.Name ~= "HumanoidRootPart" then
			p.Color = primary[p.Name] and skin.Primary or skin.Secondary
		elseif p:IsA("Shirt") or p:IsA("Pants") or p:IsA("ShirtGraphic") or p:IsA("Accessory") then
			p:Destroy() -- skins replace the player's clothing
		end
	end
	local paper = script.Parent:FindFirstChild("PaperDesigns") and script.Parent.PaperDesigns:FindFirstChild(heroId)
	if paper then
		PaperDoll.Build(model, require(paper), skin, rarity) -- Paper Mario style: drawn cards on the skeleton
	else
		Costume.Apply(model, heroId, skin, rarity) -- capes, cowls, helmets, emblems, per-part colors
	end
	local head = model:FindFirstChild("Head")
	local face = head and head:FindFirstChild("face")
	if face then face:Destroy() end -- every hero has a built face or mask now
	Body.Sculpt(model, heroId) -- rounded anatomy in the costume's colors over the box parts
	local tier = Rarity.Tiers[rarity]
	local root = model:FindFirstChild("HumanoidRootPart")
	if tier and tier.Index >= 4 and root then
		local pe = Instance.new("ParticleEmitter")
		pe.Name = "RarityAura"; pe.Color = ColorSequence.new(tier.Color)
		pe.LightEmission = 1; pe.Rate = tier.Index * 6; pe.Lifetime = NumberRange.new(0.6, 1.2)
		pe.Speed = NumberRange.new(1, 3); pe.Size = NumberSequence.new(0.4, 0)
		pe.SpreadAngle = Vector2.new(180, 180); pe.Parent = root
	end
	if tier and tier.Index >= 5 then
		local h = Instance.new("Highlight"); h.Name = "RarityGlow"
		h.FillTransparency = 1; h.OutlineColor = tier.Color; h.Parent = model
		if rarity == "Secret" then game:GetService("CollectionService"):AddTag(h, "Rainbow") end -- client cycles hue
	end
end
return S
