-- Joker: white face, green hair, red grin, purple suit, orange vest, green shirt, bow tie
-- Costume module: return function(s, H, rarity) -> { colors = { group = Color3 }, pieces = { { "Piece", args... } | function(m) end } }
-- s = skin variant (Name, Primary, Secondary, Flame...), H = shared helpers (see Costume.luau "Helpers"), rarity = "Common" | "Rare" | "Epic" | "Legendary" | "Mythic" | "Secret"
return function(s, H, rarity)
	local C, SKIN, GOLD, WHITE = H.C, H.SKIN, H.GOLD, H.WHITE
	return { colors = { Head = WHITE, Chest = s.Primary, Waist = s.Primary, Arms = s.Primary, Hands = C(240, 240, 240), Legs = s.Primary, Feet = C(25, 25, 30) },
		pieces = { { "Hair", s.Secondary, "Spiky" }, { "Face", C(60, 150, 60), C(40, 90, 40), "grin", C(200, 20, 30) }, { "Smile", C(200, 20, 30) }, { "SuitFront", C(230, 120, 30), s.Secondary, s.Secondary, s.Primary:Lerp(C(0, 0, 0), 0.3) },
			{ "Flower" } } }
end
