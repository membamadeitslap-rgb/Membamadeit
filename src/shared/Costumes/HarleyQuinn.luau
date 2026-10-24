-- Harley Quinn (classic): red/black harlequin split, jester cowl with white poms, white face, domino mask
-- Costume module: return function(s, H, rarity) -> { colors = { group = Color3 }, pieces = { { "Piece", args... } | function(m) end } }
-- s = skin variant (Name, Primary, Secondary, Flame...), H = shared helpers (see Costume.luau "Helpers"), rarity = "Common" | "Rare" | "Epic" | "Legendary" | "Mythic" | "Secret"
return function(s, H, rarity)
	local C, SKIN, GOLD, WHITE = H.C, H.SKIN, H.GOLD, H.WHITE
	return { colors = { Head = WHITE },
		pieces = { { "Harlequin", s.Primary, s.Secondary }, { "Face", C(70, 130, 220), C(20, 20, 20), "grin", C(200, 20, 30) }, { "JesterCowl", s.Primary, s.Secondary, WHITE } } }
end
