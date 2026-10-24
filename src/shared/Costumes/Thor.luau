-- Thor: dark armor with six silver discs, red cape, bare arms, silver bracers, long blond hair + beard
-- Costume module: return function(s, H, rarity) -> { colors = { group = Color3 }, pieces = { { "Piece", args... } | function(m) end } }
-- s = skin variant (Name, Primary, Secondary, Flame...), H = shared helpers (see Costume.luau "Helpers"), rarity = "Common" | "Rare" | "Epic" | "Legendary" | "Mythic" | "Secret"
return function(s, H, rarity)
	local C, SKIN, GOLD, WHITE = H.C, H.SKIN, H.GOLD, H.WHITE
	return { colors = { Head = SKIN, Chest = s.Primary, Waist = s.Primary, UpperArms = SKIN, LowerArms = C(190, 190, 200), Hands = SKIN, Legs = C(40, 40, 50), Boots = C(230, 190, 60) },
		pieces = { { "Cape", s.Secondary }, { "Hair", C(220, 180, 90), "Long" }, { "Face", C(60, 120, 200), C(190, 150, 70), "angry" }, { "WingedHelmet", C(200, 202, 212) },
			{ "ChestDiscs", C(205, 205, 215) }, { "Belt", C(230, 190, 60) }, { "StrappedBoots", C(150, 110, 40) } } }
end
