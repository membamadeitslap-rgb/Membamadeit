-- Iron Man Mark VI: red helmet + gold faceplate, red torso/forearms/boots, gold upper arms/thighs, triangle reactor, repulsors
-- Costume module: return function(s, H, rarity) -> { colors = { group = Color3 }, pieces = { { "Piece", args... } | function(m) end } }
-- s = skin variant (Name, Primary, Secondary, Flame...), H = shared helpers (see Costume.luau "Helpers"), rarity = "Common" | "Rare" | "Epic" | "Legendary" | "Mythic" | "Secret"
return function(s, H, rarity)
	local C, SKIN, GOLD, WHITE = H.C, H.SKIN, H.GOLD, H.WHITE
	return { colors = { Chest = s.Primary, Waist = s.Primary, UpperArms = s.Secondary, LowerArms = s.Primary, Hands = s.Primary, UpperLegs = s.Secondary, LowerLegs = s.Primary, Feet = s.Primary },
		pieces = { { "Material", Enum.Material.Metal }, { "Helmet", s.Primary, s.Secondary }, { "Eyes", WHITE }, { "IronFace", s.Secondary }, { "Reactor", true },
			{ "Shoulders", s.Primary }, { "PalmGlow", C(190, 240, 255) } } }
end
