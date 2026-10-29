-- Venom rarity variants: v(name, primary, secondary, opts). opts: Colors = { group = color } overrides, Extra = { costume pieces }, Pieces = replace defaults, plus any flags the costume module reads.
return function(v, C)
	return {
		Common = v("Classic Venom", C(20, 20, 25), C(240, 240, 240)),
		Rare = v("Agent Venom", C(25, 25, 30), C(90, 90, 100)),
		Epic = v("Anti-Venom", C(240, 240, 240), C(20, 20, 25)),
		Legendary = v("Carnage", C(190, 20, 25), C(30, 10, 10)),
		Mythic = v("Toxin", C(30, 60, 150), C(190, 20, 25)),
		Secret = v("King in Black", C(10, 10, 12), C(255, 240, 120)),
	}
end
