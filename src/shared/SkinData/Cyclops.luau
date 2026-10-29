-- Cyclops rarity variants: v(name, primary, secondary, opts). opts: Colors = { group = color } overrides, Extra = { costume pieces }, Pieces = replace defaults, plus any flags the costume module reads.
return function(v, C)
	return {
		Common = v("X-Men '97 Cyclops", C(35, 70, 200), C(250, 215, 40)),
		Rare = v("Jim Lee Cyclops", C(35, 55, 150), C(240, 200, 40)),
		Epic = v("X-Factor Cyclops", C(25, 70, 160), C(230, 230, 240)),
		Legendary = v("Astonishing Cyclops", C(20, 20, 25), C(255, 220, 60)),
		Mythic = v("Phoenix Five Cyclops", C(255, 140, 30), C(255, 230, 120)),
		Secret = v("Dark Phoenix Cyclops", C(150, 20, 30), C(255, 90, 40)),
	}
end
