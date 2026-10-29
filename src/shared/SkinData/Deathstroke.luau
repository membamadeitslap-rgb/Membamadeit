-- Deathstroke rarity variants: v(name, primary, secondary, opts). opts: Colors = { group = color } overrides, Extra = { costume pieces }, Pieces = replace defaults, plus any flags the costume module reads.
return function(v, C)
	return {
		Common = v("Classic Deathstroke", C(220, 120, 30), C(30, 40, 90)),
		Rare = v("Arkham Origins Deathstroke", C(40, 40, 45), C(220, 120, 30)),
		Epic = v("Rebirth Deathstroke", C(25, 25, 30), C(170, 175, 185)),
		Legendary = v("Ravager Armor", C(150, 30, 30), C(30, 30, 35)),
		Mythic = v("Titans Hunter", C(30, 50, 110), C(255, 140, 30)),
		Secret = v("Golden Contract", C(215, 170, 50), C(20, 20, 25)),
	}
end
