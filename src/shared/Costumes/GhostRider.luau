-- Ghost Rider: leather jacket, flaming skull, spikes, chains, knee pads
-- Costume module: return function(s, H, rarity) -> { colors = { group = Color3 }, pieces = { { "Piece", args... } | function(m) end } }
-- s = skin variant (Name, Primary, Secondary, Flame...), H = shared helpers (see Costume.luau "Helpers"), rarity = "Common" | "Rare" | "Epic" | "Legendary" | "Mythic" | "Secret"
return function(s, H, rarity)
	local C, SKIN, GOLD, WHITE = H.C, H.SKIN, H.GOLD, H.WHITE
	return { colors = { Head = C(235, 228, 210), Chest = s.Primary, Waist = s.Primary, Arms = s.Primary, Hands = s.Primary, Legs = s.Primary, Feet = C(20, 20, 22) },
		pieces = { { "Material", Enum.Material.Leather }, { "FlamingSkull", s.Flame, s.Flame2 }, { "BikerJacket", s.Primary, s.Secondary },
			{ "Shoulders", s.Primary, true, s.Secondary }, { "Studs", s.Secondary }, { "GloveBootSpikes", s.Secondary },
			{ "Chains", s.Secondary }, { "ArmChain", s.Secondary }, { "KneePads", s.Primary:Lerp(C(0, 0, 0), 0.3) } } }
end
