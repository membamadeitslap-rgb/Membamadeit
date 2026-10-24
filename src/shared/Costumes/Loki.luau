-- Loki: green/black leather, gold horned helmet + shoulders, long green cape, black hair
-- Costume module: return function(s, H, rarity) -> { colors = { group = Color3 }, pieces = { { "Piece", args... } | function(m) end } }
-- s = skin variant (Name, Primary, Secondary, Flame...), H = shared helpers (see Costume.luau "Helpers"), rarity = "Common" | "Rare" | "Epic" | "Legendary" | "Mythic" | "Secret"
return function(s, H, rarity)
	local C, SKIN, GOLD, WHITE = H.C, H.SKIN, H.GOLD, H.WHITE
	return { colors = { Head = SKIN, Chest = C(25, 25, 30), Waist = C(25, 25, 30), Arms = s.Primary, Gloves = C(25, 25, 30), Legs = C(25, 25, 30), Feet = C(25, 25, 30) },
		pieces = { { "Material", Enum.Material.Leather }, { "Cape", s.Primary, C(20, 20, 25) }, { "Hair", C(15, 15, 15), "Long" }, { "Face", C(60, 140, 90), C(20, 20, 20), "smirk" }, { "Horns", s.Secondary }, { "Shoulders", s.Secondary },
			{ "Harness", s.Secondary, "X" } } }
end
