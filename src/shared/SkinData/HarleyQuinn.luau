-- HarleyQuinn rarity variants: v(name, primary, secondary, opts). opts: Colors = { group = color } overrides, Extra = { costume pieces }, Pieces = replace defaults, plus any flags the costume module reads.
return function(v, C)
	return {
		Common = v("Classic Harley", C(200, 30, 40), C(25, 25, 30)),
		Rare = v("Suicide Squad Harley", C(220, 60, 120), C(60, 100, 220)),
		Epic = v("Birds of Prey Harley", C(240, 200, 60), C(220, 60, 150)),
		Legendary = v("Rebirth Harley", C(25, 25, 30), C(200, 30, 40)),
		Mythic = v("Dr. Harleen Quinzel", C(240, 240, 245), C(30, 30, 35)),
		Secret = v("Queen of Gotham", C(170, 20, 60), C(255, 215, 80)),
	}
end
