-- Thor rarity variants: v(name, primary, secondary, opts). opts: Colors = { group = color } overrides, Extra = { costume pieces }, Pieces = replace defaults, plus any flags the costume module reads.
return function(v, C)
	return {
		Common = v("Classic Thor", C(60, 70, 110), C(170, 30, 30)),
		Rare = v("Ragnarok Thor", C(70, 70, 75), C(150, 25, 25)),
		Epic = v("Infinity War Thor", C(30, 30, 35), C(130, 20, 20)),
		Legendary = v("Mighty Thor (Jane Foster)", C(180, 185, 195), C(190, 25, 30)),
		Mythic = v("King Thor", C(215, 170, 50), C(90, 20, 20)),
		Secret = v("God of Thunder Unleashed", C(220, 240, 255), C(80, 200, 255)),
	}
end
