-- Spider-Man: red mask/chest/gloves/boots with black webbing, blue sides/legs, big white lenses, black spider
-- Costume module: return function(s, H, rarity) -> { colors = { group = Color3 }, pieces = { { "Piece", args... } | function(m) end } }
-- s = skin variant (Name, Primary, Secondary, Flame...), H = shared helpers (see Costume.luau "Helpers"), rarity = "Common" | "Rare" | "Epic" | "Legendary" | "Mythic" | "Secret"
return function(s, H, rarity)
	local C, SKIN, GOLD, WHITE = H.C, H.SKIN, H.GOLD, H.WHITE
	return { colors = { Head = s.Primary, Chest = s.Primary, Waist = s.Secondary, UpperArms = s.Secondary, Gloves = s.Primary, Legs = s.Secondary, Boots = s.Primary },
		pieces = { { "SidePanels", s.Secondary, 0.2 }, { "WebLines", C(15, 15, 20), { "Head", "UpperTorso", "LeftLowerArm", "RightLowerArm", "LeftLowerLeg", "RightLowerLeg" } },
			{ "Lenses", C(15, 15, 20), WHITE }, { "Emblem", "✱", s.Secondary == WHITE and WHITE or C(15, 15, 15) } } }
end
