-- Batman (TAS): gray suit, dark cowl/cape/gloves/boots/trunks, yellow oval + belt, glove fins
-- Costume module: return function(s, H, rarity) -> { colors = { group = Color3 }, pieces = { { "Piece", args... } | function(m) end } }
-- s = skin variant (Name, Primary, Secondary, Flame...), H = shared helpers (see Costume.luau "Helpers"), rarity = "Common" | "Rare" | "Epic" | "Legendary" | "Mythic" | "Secret"
return function(s, H, rarity)
	local C, SKIN, GOLD, WHITE = H.C, H.SKIN, H.GOLD, H.WHITE
	return { colors = { Head = SKIN, Chest = s.Primary, Waist = s.Secondary, Arms = s.Primary, Gloves = s.Secondary, Legs = s.Primary, Boots = s.Secondary },
		pieces = { { "Cowl", s.Secondary, 0.6, SKIN }, { "Eyes", WHITE }, { "LowerFace" }, { "Cape", s.Secondary }, { "Emblem", "🦇", C(0, 0, 0), C(255, 215, 60), true },
			{ "Belt", C(255, 205, 60), { color = C(255, 215, 80) } }, { "Pouches", C(240, 195, 55), 6 }, { "Cuffs", s.Secondary, true } } }
end
