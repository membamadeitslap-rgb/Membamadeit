-- Hulk rarity variants: v(name, primary, secondary, opts). opts: Colors = { group = color } overrides, Extra = { costume pieces }, Pieces = replace defaults, plus any flags the costume module reads.
return function(v, C)
	return {
		Common = v("Classic Hulk", C(70, 150, 50), C(110, 60, 140)),
		Rare = v("Gray Hulk", C(120, 125, 130), C(70, 70, 75)),
		Epic = v("Red Hulk", C(190, 30, 30), C(30, 30, 35)),
		Legendary = v("World War Hulk", C(60, 140, 40), C(140, 140, 150)),
		Mythic = v("Maestro", C(80, 130, 60), C(190, 190, 195)),
		Secret = v("Immortal Hulk", C(50, 110, 40), C(80, 255, 120)),
	}
end
