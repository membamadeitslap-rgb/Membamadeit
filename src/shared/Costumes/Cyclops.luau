-- Cyclops (X-Men '97): blue suit, yellow X-harness, bands, gloves, boots, visor with pods, red X buckle, pouches
-- Costume module: return function(s, H, rarity) -> { colors = { group = Color3 }, pieces = { { "Piece", args... } | function(m) end } }
-- s = skin variant (Name, Primary, Secondary, Flame...), H = shared helpers (see Costume.luau "Helpers"), rarity = "Common" | "Rare" | "Epic" | "Legendary" | "Mythic" | "Secret"
return function(s, H, rarity)
	local C, SKIN, GOLD, WHITE = H.C, H.SKIN, H.GOLD, H.WHITE
	return { colors = { Head = SKIN, Chest = s.Primary, Waist = s.Primary, Arms = s.Primary, Legs = s.Primary, Hands = s.Secondary, Boots = s.Secondary },
		pieces = { { "Hair", C(130, 60, 30), "Spiky" }, { "LowerFace" }, { "Visor", s.Secondary, C(255, 30, 30) }, { "Harness", s.Secondary, "X" }, { "Bands", s.Secondary },
			{ "Belt", s.Secondary, { color = C(190, 20, 20), text = "X", textColor = C(110, 10, 10) } }, { "Pouches", s.Secondary, 6 }, { "Shoulders", s.Primary } } }
end
