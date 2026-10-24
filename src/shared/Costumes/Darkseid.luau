-- Darkseid: gray craggy stone face, blue hood + tunic, red Omega eyes, black legs
-- Costume module: return function(s, H, rarity) -> { colors = { group = Color3 }, pieces = { { "Piece", args... } | function(m) end } }
-- s = skin variant (Name, Primary, Secondary, Flame...), H = shared helpers (see Costume.luau "Helpers"), rarity = "Common" | "Rare" | "Epic" | "Legendary" | "Mythic" | "Secret"
return function(s, H, rarity)
	local C, SKIN, GOLD, WHITE = H.C, H.SKIN, H.GOLD, H.WHITE
	return { colors = { Head = s.Primary, Chest = s.Secondary, Waist = s.Secondary, Arms = s.Secondary, Gloves = s.Primary, Legs = C(30, 30, 40), Feet = s.Secondary },
		pieces = { { "Craggy", s.Primary:Lerp(C(0, 0, 0), 0.35) }, { "Eyes", C(255, 40, 40) }, { "DarkseidArmor", s.Secondary, C(90, 95, 110) }, { "Shoulders", C(90, 95, 110) } } }
end
