-- Thanos rarity variants: v(name, primary, secondary, opts). opts: Colors = { group = color } overrides, Extra = { costume pieces }, Pieces = replace defaults, plus any flags the costume module reads.
return function(v, C)
	return {
		Common = v("Classic Thanos", C(110, 70, 140), C(215, 170, 50)),
		Rare = v("Armored Thanos", C(40, 70, 140), C(215, 170, 50)),
		Epic = v("Infinity War Thanos", C(100, 80, 120), C(60, 70, 110)),
		Legendary = v("Endgame Thanos", C(70, 60, 90), C(160, 140, 90)),
		Mythic = v("Infinity Thanos", C(220, 180, 60), C(130, 60, 200)),
		Secret = v("Cosmic Ghost Thanos", C(30, 30, 40), C(170, 80, 255)),
	}
end
