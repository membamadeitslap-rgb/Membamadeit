-- Red Hood: red helmet, brown leather jacket, dark armor, red bat on chest, gun-belt
-- Costume module: return function(s, H, rarity) -> { colors = { group = Color3 }, pieces = { { "Piece", args... } | function(m) end } }
-- s = skin variant (Name, Primary, Secondary, Flame...), H = shared helpers (see Costume.luau "Helpers"), rarity = "Common" | "Rare" | "Epic" | "Legendary" | "Mythic" | "Secret"
return function(s, H, rarity)
	local C, SKIN, GOLD, WHITE = H.C, H.SKIN, H.GOLD, H.WHITE
	return { colors = { Head = s.Primary, Chest = s.Primary, Waist = s.Primary, Arms = s.Secondary, Gloves = C(25, 25, 30), Legs = s.Primary, Boots = C(25, 25, 30) },
		pieces = { { "Helmet", C(200, 30, 40) }, { "Eyes", WHITE }, { "Emblem", "🦇", C(200, 30, 40) }, { "Belt", C(60, 50, 40) }, { "Pouches", C(60, 50, 40), 4 }, { "Cape", s.Secondary } } }
end
