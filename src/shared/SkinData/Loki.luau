-- Loki rarity variants: v(name, primary, secondary, opts). opts: Colors = { group = color } overrides, Extra = { costume pieces }, Pieces = replace defaults, plus any flags the costume module reads.
return function(v, C)
	return {
		Common = v("Classic Loki", C(30, 120, 60), C(215, 170, 50)),
		Rare = v("Agent of Asgard", C(25, 25, 30), C(30, 120, 60)),
		Epic = v("Kid Loki", C(40, 140, 70), C(225, 180, 60)),
		Legendary = v("Sylvie", C(40, 100, 60), C(215, 170, 50)),
		Mythic = v("President Loki", C(30, 120, 60), C(215, 170, 50)),
		Secret = v("God of Stories", C(60, 220, 120), C(255, 215, 80)),
	}
end
