-- Nova: gold helmet with red crest, blue/black suit, gold orbs and armor
-- Costume module: return function(s, H, rarity) -> { colors = { group = Color3 }, pieces = { { "Piece", args... } | function(m) end } }
-- s = skin variant (Name, Primary, Secondary, Flame...), H = shared helpers (see Costume.luau "Helpers"), rarity = "Common" | "Rare" | "Epic" | "Legendary" | "Mythic" | "Secret"
return function(s, H, rarity)
	local C, SKIN, GOLD, WHITE = H.C, H.SKIN, H.GOLD, H.WHITE
	return { colors = { Head = s.Secondary, Chest = s.Primary, Arms = s.Primary, Gloves = s.Secondary, Legs = s.Primary, Boots = s.Secondary },
		pieces = { { "Helmet", s.Secondary, nil, C(220, 30, 40) }, { "JawOpening", SKIN }, { "LowerFace" }, { "Eyes", WHITE }, { "NovaOrbs", s.Secondary }, { "Belt", s.Secondary }, { "Shoulders", s.Secondary, true, s.Secondary } } }
end
