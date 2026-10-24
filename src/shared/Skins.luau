-- Cosmetic variant per hero per rarity: { Name, Primary (torso/arms), Secondary (legs/head accents) }.
-- Higher tiers also get aura effects (see Skins.Apply).
local C = Color3.fromRGB
local function v(name, a, b) return { Name = name, Primary = a, Secondary = b } end
local S = {}
S.Data = {
	SpiderMan = {
		Common = v("Classic Spider-Man", C(200, 30, 40), C(30, 60, 160)),
		Rare = v("Miles Morales", C(25, 25, 30), C(200, 30, 40)),
		Epic = v("Iron Spider", C(190, 30, 30), C(215, 170, 50)),
		Legendary = v("Symbiote Spider-Man", C(15, 15, 18), C(240, 240, 240)),
		Mythic = v("Spider-Man 2099", C(25, 35, 90), C(220, 30, 40)),
		Secret = v("Cosmic Spider-Man", C(240, 240, 250), C(40, 60, 200)),
	},
	IronMan = {
		Common = v("Mark III", C(180, 25, 30), C(215, 170, 50)),
		Rare = v("Mark I", C(110, 110, 115), C(80, 80, 85)),
		Epic = v("Hulkbuster", C(170, 30, 30), C(200, 160, 50)),
		Legendary = v("Iron Patriot", C(30, 50, 140), C(200, 30, 40)),
		Mythic = v("Mark 85", C(200, 20, 30), C(255, 200, 60)),
		Secret = v("Superior Iron Man", C(240, 240, 245), C(215, 170, 50)),
	},
	Thor = {
		Common = v("Classic Thor", C(60, 70, 110), C(170, 30, 30)),
		Rare = v("Ragnarok Thor", C(70, 70, 75), C(150, 25, 25)),
		Epic = v("Infinity War Thor", C(30, 30, 35), C(130, 20, 20)),
		Legendary = v("Mighty Thor (Jane Foster)", C(180, 185, 195), C(190, 25, 30)),
		Mythic = v("King Thor", C(215, 170, 50), C(90, 20, 20)),
		Secret = v("God of Thunder Unleashed", C(220, 240, 255), C(80, 200, 255)),
	},
	CaptainAmerica = {
		Common = v("Classic Cap", C(30, 60, 150), C(200, 30, 40)),
		Rare = v("WWII Cap", C(110, 85, 60), C(40, 60, 120)),
		Epic = v("Stealth Suit", C(25, 35, 70), C(170, 175, 185)),
		Legendary = v("Sam Wilson Cap", C(240, 240, 245), C(30, 60, 150)),
		Mythic = v("Captain Carter", C(30, 50, 120), C(200, 30, 40)),
		Secret = v("Hydra Supreme", C(20, 20, 25), C(190, 20, 20)),
	},
	Loki = {
		Common = v("Classic Loki", C(30, 120, 60), C(215, 170, 50)),
		Rare = v("Agent of Asgard", C(25, 25, 30), C(30, 120, 60)),
		Epic = v("Kid Loki", C(40, 140, 70), C(25, 25, 30)),
		Legendary = v("Sylvie", C(40, 100, 60), C(215, 170, 50)),
		Mythic = v("President Loki", C(25, 30, 40), C(30, 150, 70)),
		Secret = v("God of Stories", C(60, 220, 120), C(255, 215, 80)),
	},
	Thanos = {
		Common = v("Classic Thanos", C(110, 70, 140), C(215, 170, 50)),
		Rare = v("Armored Thanos", C(40, 70, 140), C(215, 170, 50)),
		Epic = v("Infinity War Thanos", C(100, 80, 120), C(60, 70, 110)),
		Legendary = v("Endgame Thanos", C(70, 60, 90), C(160, 140, 90)),
		Mythic = v("Infinity Thanos", C(220, 180, 60), C(130, 60, 200)),
		Secret = v("Cosmic Ghost Thanos", C(30, 30, 40), C(170, 80, 255)),
	},
	Hulk = {
		Common = v("Classic Hulk", C(70, 150, 50), C(110, 60, 140)),
		Rare = v("Gray Hulk", C(120, 125, 130), C(70, 70, 75)),
		Epic = v("Red Hulk", C(190, 30, 30), C(30, 30, 35)),
		Legendary = v("World War Hulk", C(60, 140, 40), C(140, 140, 150)),
		Mythic = v("Maestro", C(80, 130, 60), C(190, 190, 195)),
		Secret = v("Immortal Hulk", C(50, 110, 40), C(80, 255, 120)),
	},
	Venom = {
		Common = v("Classic Venom", C(20, 20, 25), C(240, 240, 240)),
		Rare = v("Agent Venom", C(25, 25, 30), C(90, 90, 100)),
		Epic = v("Anti-Venom", C(240, 240, 240), C(20, 20, 25)),
		Legendary = v("Carnage", C(190, 20, 25), C(30, 10, 10)),
		Mythic = v("Toxin", C(30, 60, 150), C(190, 20, 25)),
		Secret = v("King in Black", C(10, 10, 12), C(255, 240, 120)),
	},
	GreenGoblin = {
		Common = v("Classic Goblin", C(60, 140, 50), C(110, 50, 140)),
		Rare = v("Armored Goblin", C(70, 100, 60), C(60, 60, 65)),
		Epic = v("Hobgoblin", C(230, 120, 30), C(40, 70, 160)),
		Legendary = v("Red Goblin", C(200, 30, 30), C(20, 20, 25)),
		Mythic = v("Demogoblin", C(120, 20, 20), C(255, 130, 30)),
		Secret = v("Goblin King", C(40, 160, 60), C(255, 215, 80)),
	},
	Batman = {
		Common = v("Classic Batman", C(110, 110, 120), C(25, 25, 30)),
		Rare = v("Blue & Gray Batman", C(130, 130, 140), C(40, 60, 130)),
		Epic = v("Batman Beyond", C(20, 20, 25), C(200, 25, 30)),
		Legendary = v("Hellbat", C(50, 50, 55), C(255, 120, 30)),
		Mythic = v("Red Death", C(170, 20, 25), C(30, 10, 10)),
		Secret = v("Batman Who Laughs", C(15, 15, 18), C(200, 200, 210)),
	},
	Superman = {
		Common = v("Classic Superman", C(30, 70, 190), C(200, 30, 40)),
		Rare = v("Black Suit Superman", C(25, 25, 30), C(170, 175, 185)),
		Epic = v("Cyborg Superman", C(150, 155, 165), C(30, 70, 190)),
		Legendary = v("Kingdom Come Superman", C(35, 60, 140), C(20, 20, 25)),
		Mythic = v("Superman Prime", C(255, 215, 80), C(30, 70, 190)),
		Secret = v("Bizarro", C(70, 110, 80), C(140, 20, 30)),
	},
	Flash = {
		Common = v("Barry Allen", C(200, 30, 30), C(255, 210, 40)),
		Rare = v("Wally West", C(220, 40, 40), C(255, 220, 60)),
		Epic = v("Reverse-Flash", C(240, 200, 40), C(200, 30, 30)),
		Legendary = v("Zoom", C(20, 20, 25), C(60, 140, 255)),
		Mythic = v("Godspeed", C(240, 240, 245), C(255, 200, 60)),
		Secret = v("Speed Force Flash", C(255, 230, 120), C(255, 120, 30)),
	},
	WonderWoman = {
		Common = v("Classic Wonder Woman", C(180, 30, 40), C(30, 60, 150)),
		Rare = v("Amazon Warrior", C(140, 60, 50), C(80, 60, 50)),
		Epic = v("Golden Eagle Armor", C(215, 170, 50), C(180, 140, 40)),
		Legendary = v("Goddess of War", C(100, 20, 25), C(40, 40, 45)),
		Mythic = v("Queen of the Amazons", C(240, 240, 245), C(215, 170, 50)),
		Secret = v("Goddess of Truth", C(255, 230, 140), C(255, 255, 255)),
	},
	HarleyQuinn = {
		Common = v("Classic Harley", C(200, 30, 40), C(25, 25, 30)),
		Rare = v("Suicide Squad Harley", C(220, 60, 120), C(60, 100, 220)),
		Epic = v("Birds of Prey Harley", C(240, 200, 60), C(220, 60, 150)),
		Legendary = v("Rebirth Harley", C(25, 25, 30), C(200, 30, 40)),
		Mythic = v("Dr. Harleen Quinzel", C(240, 240, 245), C(30, 30, 35)),
		Secret = v("Queen of Gotham", C(170, 20, 60), C(255, 215, 80)),
	},
	Joker = {
		Common = v("Classic Joker", C(100, 40, 140), C(60, 160, 60)),
		Rare = v("Arkham Joker", C(110, 50, 130), C(200, 120, 40)),
		Epic = v("Dark Knight Joker", C(60, 40, 90), C(40, 100, 60)),
		Legendary = v("Red Suit Joker", C(170, 30, 30), C(200, 120, 40)),
		Mythic = v("Clown Prince", C(215, 170, 50), C(100, 40, 140)),
		Secret = v("Emperor Joker", C(240, 240, 245), C(140, 40, 200)),
	},
	Deathstroke = {
		Common = v("Classic Deathstroke", C(220, 120, 30), C(30, 40, 90)),
		Rare = v("Arkham Origins Deathstroke", C(40, 40, 45), C(220, 120, 30)),
		Epic = v("Rebirth Deathstroke", C(25, 25, 30), C(170, 175, 185)),
		Legendary = v("Ravager Armor", C(150, 30, 30), C(30, 30, 35)),
		Mythic = v("Titans Hunter", C(30, 50, 110), C(255, 140, 30)),
		Secret = v("Golden Contract", C(215, 170, 50), C(20, 20, 25)),
	},
	BlackAdam = {
		Common = v("Classic Black Adam", C(30, 30, 30), C(215, 170, 50)),
		Rare = v("Movie Black Adam", C(40, 40, 45), C(150, 120, 60)),
		Epic = v("Kahndaq Champion", C(25, 25, 30), C(60, 140, 255)),
		Legendary = v("Teth-Adam", C(160, 120, 70), C(215, 170, 50)),
		Mythic = v("Champion of Shazam", C(200, 30, 40), C(255, 215, 80)),
		Secret = v("God of Kahndaq", C(255, 230, 120), C(255, 255, 255)),
	},
	Darkseid = {
		Common = v("Classic Darkseid", C(90, 90, 100), C(40, 60, 130)),
		Rare = v("Armored Darkseid", C(60, 60, 70), C(30, 30, 40)),
		Epic = v("Injustice Darkseid", C(80, 70, 70), C(200, 60, 30)),
		Legendary = v("God of Apokolips", C(50, 50, 55), C(255, 80, 30)),
		Mythic = v("Omega Darkseid", C(30, 30, 35), C(255, 40, 40)),
		Secret = v("Absolute Darkseid", C(10, 10, 15), C(170, 80, 255)),
	},
}

local Rarity = require(script.Parent.Rarity)
function S.Get(heroId, rarity)
	return S.Data[heroId] and S.Data[heroId][rarity] or S.Data[heroId] and S.Data[heroId].Common
end

-- Recolor a rig and add aura by tier. Works on R15 and R6.
function S.Apply(model, heroId, rarity)
	local skin = S.Get(heroId, rarity); if not skin then return end
	local primary = { UpperTorso = 1, LowerTorso = 1, Torso = 1, LeftUpperArm = 1, RightUpperArm = 1, LeftLowerArm = 1, RightLowerArm = 1, ["Left Arm"] = 1, ["Right Arm"] = 1, Head = 1 }
	for _, p in model:GetChildren() do
		if p:IsA("BasePart") and p.Name ~= "HumanoidRootPart" then
			p.Color = primary[p.Name] and skin.Primary or skin.Secondary
		elseif p:IsA("Shirt") or p:IsA("Pants") or p:IsA("ShirtGraphic") or p:IsA("Accessory") then
			p:Destroy() -- skins replace the player's clothing
		end
	end
	local face = model:FindFirstChild("Head") and model.Head:FindFirstChild("face")
	if face then face:Destroy() end -- masked heroes
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
