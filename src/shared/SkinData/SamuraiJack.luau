-- SamuraiJack rarity variants: v(name, primary, secondary, opts). opts: Colors = { group = color } overrides, Extra = { costume pieces }, Pieces = replace defaults, plus any flags the costume module reads.
-- ===== Cartoon Network =====
return function(v, C)
	return {
		Common = v("Classic Jack", C(242, 238, 228), C(222, 215, 198)),
		Rare = v("Bearded Jack (Season 5)", C(225, 218, 200), C(190, 180, 160), { Beard = true }),
		Epic = v("Armored Jack", C(70, 65, 70), C(150, 30, 30), { Beard = true, Armor = C(130, 132, 140) }),
		Legendary = v("Ronin Jack", C(55, 70, 110), C(200, 190, 160), { Kasa = true }),
		Mythic = v("Ghost Samurai", C(190, 225, 250), C(120, 200, 255), { Ghost = true }),
		Secret = v("Aku-Slayer Jack", C(250, 240, 210), C(230, 185, 60), { Armor = C(225, 180, 60) }),
	}
end
