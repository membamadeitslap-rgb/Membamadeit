-- CaptainAmerica rarity variants: v(name, primary, secondary, opts). opts: Colors = { group = color } overrides, Extra = { costume pieces }, Pieces = replace defaults, plus any flags the costume module reads.
return function(v, C)
	return {
		Common = v("Classic Cap", C(30, 60, 150), C(200, 30, 40)),
		Rare = v("WWII Cap", C(110, 85, 60), C(40, 60, 120)),
		Epic = v("Stealth Suit", C(25, 35, 70), C(170, 175, 185)),
		Legendary = v("Sam Wilson Cap", C(240, 240, 245), C(30, 60, 150)),
		Mythic = v("Captain Carter", C(30, 50, 120), C(200, 30, 40)),
		Secret = v("Hydra Supreme", C(20, 20, 25), C(190, 20, 20)),
	}
end
