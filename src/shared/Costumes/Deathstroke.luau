-- Deathstroke: orange/black split mask (one eye), dark blue armor, orange gloves/boots, katana + staff
-- Costume module: return function(s, H, rarity) -> { colors = { group = Color3 }, pieces = { { "Piece", args... } | function(m) end } }
-- s = skin variant (Name, Primary, Secondary, Flame...), H = shared helpers (see Costume.luau "Helpers"), rarity = "Common" | "Rare" | "Epic" | "Legendary" | "Mythic" | "Secret"
return function(s, H, rarity)
	local C, SKIN, GOLD, WHITE = H.C, H.SKIN, H.GOLD, H.WHITE
	return { colors = { Chest = s.Secondary, Waist = s.Secondary, Arms = s.Secondary, Gloves = s.Primary, Legs = s.Secondary, Boots = s.Primary },
		pieces = { { "HalfMask", s.Primary, C(20, 20, 25), C(10, 10, 10) }, { "Belt", C(60, 50, 40) }, { "Pouches", C(50, 45, 40), 4 }, { "Shoulders", s.Primary }, { "Harness", C(40, 40, 45), "X" },
			{ "Scabbards", C(30, 30, 35) }, { "Cuffs", s.Primary } } }
end
