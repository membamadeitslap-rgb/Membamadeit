-- Captain America: blue suit, white star, red/white midsection stripes, A-helmet with wings, red gloves/boots, brown belt
-- Costume module: return function(s, H, rarity) -> { colors = { group = Color3 }, pieces = { { "Piece", args... } | function(m) end } }
-- s = skin variant (Name, Primary, Secondary, Flame...), H = shared helpers (see Costume.luau "Helpers"), rarity = "Common" | "Rare" | "Epic" | "Legendary" | "Mythic" | "Secret"
return function(s, H, rarity)
	local C, SKIN, GOLD, WHITE = H.C, H.SKIN, H.GOLD, H.WHITE
	return { colors = { Head = SKIN, Chest = s.Primary, Waist = s.Primary, Arms = s.Primary, Gloves = s.Secondary, Legs = s.Primary, Boots = s.Secondary },
		pieces = { { "CapHelmet", s.Primary, WHITE }, { "Eyes", WHITE }, { "LowerFace" }, { "Emblem", "★", WHITE }, { "Stripes", s.Secondary, WHITE }, { "Belt", C(110, 80, 50), { color = C(200, 200, 210) } },
			{ "Cuffs", s.Secondary }, { "Pouches", C(110, 80, 50), 4 } } }
end
