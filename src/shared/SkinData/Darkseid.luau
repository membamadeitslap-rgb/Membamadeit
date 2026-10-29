-- Darkseid rarity variants: v(name, primary, secondary, opts). opts: Colors = { group = color } overrides, Extra = { costume pieces }, Pieces = replace defaults, plus any flags the costume module reads.
return function(v, C)
	return {
		Common = v("Classic Darkseid", C(90, 90, 100), C(40, 60, 130)),
		Rare = v("Armored Darkseid", C(60, 60, 70), C(30, 30, 40)),
		Epic = v("Injustice Darkseid", C(80, 70, 70), C(200, 60, 30)),
		Legendary = v("God of Apokolips", C(50, 50, 55), C(255, 80, 30)),
		Mythic = v("Omega Darkseid", C(30, 30, 35), C(255, 40, 40)),
		Secret = v("Absolute Darkseid", C(10, 10, 15), C(170, 80, 255)),
	}
end
