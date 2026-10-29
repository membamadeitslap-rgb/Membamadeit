-- Joker rarity variants: v(name, primary, secondary, opts). opts: Colors = { group = color } overrides, Extra = { costume pieces }, Pieces = replace defaults, plus any flags the costume module reads.
return function(v, C)
	return {
		Common = v("Classic Joker", C(100, 40, 140), C(60, 160, 60)),
		Rare = v("Arkham Joker", C(110, 50, 130), C(200, 120, 40)),
		Epic = v("Dark Knight Joker", C(60, 40, 90), C(40, 100, 60)),
		Legendary = v("Red Suit Joker", C(170, 30, 30), C(200, 120, 40)),
		Mythic = v("Clown Prince", C(215, 170, 50), C(100, 40, 140)),
		Secret = v("Emperor Joker", C(240, 240, 245), C(140, 40, 200)),
	}
end
