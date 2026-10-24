-- Thanos: purple skin with chin ridges, gold helmet, blue armor, gold shoulders/belt/boots
-- Costume module: return function(s, H, rarity) -> { colors = { group = Color3 }, pieces = { { "Piece", args... } | function(m) end } }
-- s = skin variant (Name, Primary, Secondary, Flame...), H = shared helpers (see Costume.luau "Helpers"), rarity = "Common" | "Rare" | "Epic" | "Legendary" | "Mythic" | "Secret"
return function(s, H, rarity)
	local C, SKIN, GOLD, WHITE = H.C, H.SKIN, H.GOLD, H.WHITE
	return { colors = { Head = C(130, 90, 160), Chest = s.Primary, Waist = s.Primary, Arms = C(130, 90, 160), Gloves = s.Secondary, Legs = s.Primary, Boots = s.Secondary },
		pieces = { { "Face", C(90, 60, 120), C(90, 60, 120), "grin", C(80, 40, 90) }, { "Helmet", s.Secondary }, { "JawOpening", C(130, 90, 160) }, { "ChinRidges", C(100, 65, 130) }, { "Shoulders", s.Secondary }, { "Belt", s.Secondary }, { "Harness", s.Secondary, "X" } } }
end
