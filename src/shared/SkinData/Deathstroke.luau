-- Deathstroke rarity variants: v(name, primary, secondary, opts).
-- Flags read by Costumes/Deathstroke.luau: Mask (eye half), MaskDark (blind half), Suit, Accent (gauntlets/boots), Armor (plates), Trim, Belt
return function(v, C)
	return {
		Common = v("Classic Deathstroke", C(225, 125, 30), C(30, 45, 105)),
		Rare = v("Arkham Origins Deathstroke", C(225, 125, 30), C(35, 35, 40), { Suit = C(35, 35, 40), Accent = C(55, 55, 62), Armor = C(70, 72, 80), Trim = C(225, 125, 30), Belt = C(45, 45, 50) }),
		Epic = v("Rebirth Deathstroke", C(225, 125, 30), C(25, 25, 30), { Suit = C(25, 25, 30), Accent = C(225, 125, 30), Armor = C(160, 165, 175), Trim = C(225, 125, 30), Belt = C(40, 40, 45) }),
		Legendary = v("Ravager Armor", C(170, 30, 35), C(30, 30, 35), { Suit = C(30, 30, 35), Accent = C(170, 30, 35), Armor = C(45, 45, 50), Trim = C(170, 30, 35), Belt = C(50, 50, 55) }),
		Mythic = v("Titans Hunter", C(255, 140, 30), C(30, 50, 110), { Suit = C(30, 50, 110), Accent = C(255, 140, 30), Armor = C(255, 140, 30), Trim = C(20, 25, 50), Belt = C(30, 30, 35) }),
		Secret = v("Golden Contract", C(225, 180, 60), C(20, 20, 25), { Suit = C(20, 20, 25), Accent = C(225, 180, 60), Armor = C(225, 180, 60), Trim = C(20, 20, 25), Belt = C(35, 30, 25) }),
	}
end
