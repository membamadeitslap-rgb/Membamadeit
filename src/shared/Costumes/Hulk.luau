-- Hulk: green skin, torn purple shorts, bare feet, black hair
-- Costume module: return function(s, H, rarity) -> { colors = { group = Color3 }, pieces = { { "Piece", args... } | function(m) end } }
-- s = skin variant (Name, Primary, Secondary, Flame...), H = shared helpers (see Costume.luau "Helpers"), rarity = "Common" | "Rare" | "Epic" | "Legendary" | "Mythic" | "Secret"
return function(s, H, rarity)
	local C, SKIN, GOLD, WHITE = H.C, H.SKIN, H.GOLD, H.WHITE
	return { colors = { Head = s.Primary, Chest = s.Primary, Arms = s.Primary, Hands = s.Primary, Waist = s.Secondary, UpperLegs = s.Secondary, LowerLegs = s.Secondary, Feet = s.Primary },
		pieces = { { "Hair", C(20, 20, 20), "Spiky" }, { "Face", C(60, 110, 40), C(20, 20, 20), "angry" }, { "TornHem", s.Secondary }, { "Belt", C(120, 70, 40) } } }
end
