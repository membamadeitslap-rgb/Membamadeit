-- Black Adam: black suit, gold lightning bolt, gold belt + bracers + boots, short white cape, widow's peak
-- Costume module: return function(s, H, rarity) -> { colors = { group = Color3 }, pieces = { { "Piece", args... } | function(m) end } }
-- s = skin variant (Name, Primary, Secondary, Flame...), H = shared helpers (see Costume.luau "Helpers"), rarity = "Common" | "Rare" | "Epic" | "Legendary" | "Mythic" | "Secret"
return function(s, H, rarity)
	local C, SKIN, GOLD, WHITE = H.C, H.SKIN, H.GOLD, H.WHITE
	return { colors = { Head = SKIN, Chest = s.Primary, Waist = s.Primary, Arms = s.Primary, Gloves = s.Secondary, Legs = s.Primary, Boots = s.Secondary },
		pieces = { { "Cape", C(190, 160, 120) }, { "Hair", C(15, 15, 15) }, { "Face", C(40, 30, 25), C(15, 15, 15), "angry" }, { "Emblem", "ϟ", s.Secondary }, { "Belt", s.Secondary, { color = s.Secondary, text = "▲", textColor = C(120, 90, 20) } },
			{ "Cuffs", s.Secondary } } }
end
