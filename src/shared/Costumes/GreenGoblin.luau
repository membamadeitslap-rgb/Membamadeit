-- Green Goblin: green skin, purple tunic/hat/gloves/boots, pointed ears, yellow eyes, satchel
-- Costume module: return function(s, H, rarity) -> { colors = { group = Color3 }, pieces = { { "Piece", args... } | function(m) end } }
-- s = skin variant (Name, Primary, Secondary, Flame...), H = shared helpers (see Costume.luau "Helpers"), rarity = "Common" | "Rare" | "Epic" | "Legendary" | "Mythic" | "Secret"
return function(s, H, rarity)
	local C, SKIN, GOLD, WHITE = H.C, H.SKIN, H.GOLD, H.WHITE
	return { colors = { Head = s.Primary, Chest = s.Secondary, Waist = s.Secondary, Arms = s.Primary, Gloves = s.Secondary, Legs = s.Primary, Boots = s.Secondary },
		pieces = { { "GoblinHat", s.Secondary }, { "Face", C(255, 220, 40), C(30, 50, 20), "grin", C(40, 20, 20) }, { "Satchel", C(120, 70, 40) }, { "Belt", s.Secondary } } }
end
