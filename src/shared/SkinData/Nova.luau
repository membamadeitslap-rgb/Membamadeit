-- Nova rarity variants: v(name, primary, secondary, opts). opts: Colors = { group = color } overrides, Extra = { costume pieces }, Pieces = replace defaults, plus any flags the costume module reads.
return function(v, C)
	return {
		Common = v("Nova Corps Rookie", C(40, 50, 120), C(205, 165, 60)),
		Rare = v("Sam Alexander Nova", C(20, 20, 25), C(205, 165, 60), { Colors = { Feet = C(205, 165, 60), Hands = C(205, 165, 60) } }),
		Epic = v("Richard Rider Nova", C(30, 40, 100), C(200, 160, 60)),
		Legendary = v("Nova Prime", C(25, 30, 70), C(230, 190, 80)),
		Mythic = v("Human Rocket", C(240, 120, 30), C(255, 220, 90)),
		Secret = v("Nova Force Unleashed", C(240, 245, 255), C(120, 200, 255)),
	}
end
