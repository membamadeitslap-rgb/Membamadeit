-- BlackAdam rarity variants: v(name, primary, secondary, opts). opts: Colors = { group = color } overrides, Extra = { costume pieces }, Pieces = replace defaults, plus any flags the costume module reads.
return function(v, C)
	return {
		Common = v("Classic Black Adam", C(30, 30, 30), C(215, 170, 50)),
		Rare = v("Movie Black Adam", C(40, 40, 45), C(150, 120, 60)),
		Epic = v("Kahndaq Champion", C(25, 25, 30), C(60, 140, 255)),
		Legendary = v("Teth-Adam", C(160, 120, 70), C(215, 170, 50)),
		Mythic = v("Champion of Shazam", C(200, 30, 40), C(255, 215, 80)),
		Secret = v("God of Kahndaq", C(255, 230, 120), C(255, 255, 255)),
	}
end
