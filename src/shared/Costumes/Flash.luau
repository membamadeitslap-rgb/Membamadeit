-- Flash: all red, open jaw, yellow ear wings, lightning emblem in a white circle, yellow belt + boots
-- Costume module: return function(s, H, rarity) -> { colors = { group = Color3 }, pieces = { { "Piece", args... } | function(m) end } }
-- s = skin variant (Name, Primary, Secondary, Flame...), H = shared helpers (see Costume.luau "Helpers"), rarity = "Common" | "Rare" | "Epic" | "Legendary" | "Mythic" | "Secret"
return function(s, H, rarity)
	local C, SKIN, GOLD, WHITE = H.C, H.SKIN, H.GOLD, H.WHITE
	return { colors = { Head = s.Primary, Chest = s.Primary, Waist = s.Primary, Arms = s.Primary, Hands = s.Primary, Legs = s.Primary, Boots = s.Secondary },
		pieces = { { "JawOpening", SKIN }, { "LowerFace", "smirk" }, { "EarWings", s.Secondary }, { "Emblem", "ϟ", s.Secondary, WHITE, true }, { "Belt", s.Secondary }, { "Eyes", WHITE } } }
end
