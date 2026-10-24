-- Superman: blue suit, red cape/trunks/boots, yellow belt, diamond S-shield, black hair
-- Costume module: return function(s, H, rarity) -> { colors = { group = Color3 }, pieces = { { "Piece", args... } | function(m) end } }
-- s = skin variant (Name, Primary, Secondary, Flame...), H = shared helpers (see Costume.luau "Helpers"), rarity = "Common" | "Rare" | "Epic" | "Legendary" | "Mythic" | "Secret"
return function(s, H, rarity)
	local C, SKIN, GOLD, WHITE = H.C, H.SKIN, H.GOLD, H.WHITE
	return { colors = { Head = SKIN, Chest = s.Primary, Waist = s.Secondary, Arms = s.Primary, Hands = s.Primary, Legs = s.Primary, Boots = s.Secondary },
		pieces = { { "Cape", s.Secondary }, { "CapeEmblem", "S", C(255, 215, 40) }, { "Hair", C(15, 15, 20) }, { "Face", C(60, 120, 210), C(20, 20, 25), "neutral" }, { "Shield", s.Secondary, C(255, 215, 40), s.Secondary },
			{ "Belt", C(255, 215, 40), { color = C(255, 215, 40) } } } }
end
