-- Venom: black symbiote, huge white lenses, giant white spider, fanged grin + tongue
-- Costume module: return function(s, H, rarity) -> { colors = { group = Color3 }, pieces = { { "Piece", args... } | function(m) end } }
-- s = skin variant (Name, Primary, Secondary, Flame...), H = shared helpers (see Costume.luau "Helpers"), rarity = "Common" | "Rare" | "Epic" | "Legendary" | "Mythic" | "Secret"
return function(s, H, rarity)
	local C, SKIN, GOLD, WHITE = H.C, H.SKIN, H.GOLD, H.WHITE
	return { colors = { Head = s.Primary, Chest = s.Primary, Waist = s.Primary, Arms = s.Primary, Hands = s.Primary, Legs = s.Primary, Feet = s.Primary },
		pieces = { { "Lenses", s.Primary, s.Secondary, 1.35 }, { "Fangs", C(120, 20, 30), WHITE, C(200, 60, 90) }, { "Emblem", "✱", s.Secondary } } }
end
