-- Leonardo rarity variants: v(name, primary, secondary, opts). opts: Colors = { group = color } overrides, Extra = { costume pieces }, Pieces = replace defaults, plus any flags the costume module reads.
return function(v, C)
	return {
		Common = v("2012 Leonardo", C(30, 80, 200), C(120, 80, 45)),
		Rare = v("1987 Leonardo", C(40, 100, 230), C(150, 95, 50), { Skin = C(100, 170, 70), Letter = "L", Iris = C(250, 250, 250) }),
		Epic = v("Rise of the TMNT Leo", C(30, 120, 230), C(70, 60, 60), { Skin = C(70, 140, 100), Shell = C(80, 70, 50), Plastron = C(200, 190, 120) }),
		Legendary = v("Mutant Mayhem Leo", C(50, 110, 235), C(110, 80, 50), { Skin = C(95, 155, 60), Wrap = C(225, 225, 215) }),
		Mythic = v("Fast Forward Leo", C(30, 90, 220), C(70, 75, 90), { Tech = C(150, 160, 180) }),
		Secret = v("Foot Clan Leader Leo", C(170, 20, 25), C(25, 25, 30), { Skin = C(60, 120, 55), Robe = C(20, 20, 25), Iris = C(200, 30, 30) }),
	}
end
