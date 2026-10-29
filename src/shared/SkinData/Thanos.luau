-- Thanos rarity variants: v(name, primary, secondary, opts). opts: Colors = { group = color } overrides, Extra = { costume pieces }, Pieces = replace defaults, plus any flags the costume module reads.
return function(v, C)
	return {
		Common = v("Classic Thanos", C(40, 62, 160), C(222, 178, 52)),
		Rare = v("Armored Thanos", C(40, 70, 140), C(215, 170, 50)),
		Epic = v("Infinity War Thanos", C(92, 100, 122), C(175, 150, 95)),
		Legendary = v("Endgame Thanos", C(42, 48, 68), C(196, 160, 86)),
		Mythic = v("Infinity Thanos", C(70, 40, 125), C(245, 200, 70)),
		Secret = v("Cosmic Ghost Thanos", C(30, 30, 40), C(170, 80, 255)),
	}
end
