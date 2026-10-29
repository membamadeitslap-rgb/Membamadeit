-- Superman rarity variants: v(name, primary, secondary, opts). opts: Colors = { group = color } overrides, Extra = { costume pieces }, Pieces = replace defaults, plus any flags the costume module reads.
return function(v, C)
	return {
		Common = v("Classic Superman", C(30, 70, 190), C(200, 30, 40)),
		Rare = v("Black Suit Superman", C(25, 25, 30), C(170, 175, 185)),
		Epic = v("Cyborg Superman", C(150, 155, 165), C(30, 70, 190)),
		Legendary = v("Kingdom Come Superman", C(35, 60, 140), C(20, 20, 25)),
		Mythic = v("Superman Prime", C(255, 215, 80), C(30, 70, 190)),
		Secret = v("Bizarro", C(70, 110, 80), C(140, 20, 30)),
	}
end
