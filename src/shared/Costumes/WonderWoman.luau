-- Wonder Woman: red top w/ gold eagle, blue star briefs, silver bracers, tiara, red boots, lasso
-- Costume module: return function(s, H, rarity) -> { colors = { group = Color3 }, pieces = { { "Piece", args... } | function(m) end } }
-- s = skin variant (Name, Primary, Secondary, Flame...), H = shared helpers (see Costume.luau "Helpers"), rarity = "Common" | "Rare" | "Epic" | "Legendary" | "Mythic" | "Secret"
return function(s, H, rarity)
	local C, SKIN, GOLD, WHITE = H.C, H.SKIN, H.GOLD, H.WHITE
	return { colors = { Head = SKIN, Chest = s.Primary, Waist = s.Secondary, Arms = SKIN, LowerArms = C(200, 200, 210), Hands = SKIN, UpperLegs = SKIN, Boots = s.Primary },
		pieces = { { "Hair", C(20, 15, 15), "Long" }, { "Face", C(60, 110, 190), C(30, 20, 20), "neutral", C(190, 40, 50) }, { "Tiara", GOLD, C(220, 30, 40) }, { "Emblem", "W", GOLD }, { "Belt", GOLD },
			{ "Lasso", C(255, 210, 80) }, { "WWDetails" } } }
end
