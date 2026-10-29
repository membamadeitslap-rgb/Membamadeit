-- DannyPhantom rarity variants: v(name, primary, secondary, opts). opts: Colors = { group = color } overrides, Extra = { costume pieces }, Pieces = replace defaults, plus any flags the costume module reads.
return function(v, C)
	return {
		Common = v("Danny Phantom", C(22, 22, 26), C(245, 245, 245)),
		Rare = v("Danny Fenton", C(200, 30, 30), C(50, 80, 150), { Human = true }),
		Epic = v("Fenton Ghost Peeler", C(22, 22, 26), C(245, 245, 245), { Armor = C(150, 155, 165) }),
		Legendary = v("Phantom Planet Danny", C(15, 15, 22), C(225, 240, 255), { Eye = C(140, 255, 200) }),
		Mythic = v("Dan Phantom", C(20, 20, 25), C(235, 240, 250), { Dan = true, Skin = C(120, 175, 215), Eye = C(255, 70, 70), Hair = C(225, 240, 255) }),
		Secret = v("Ghost King Danny", C(25, 30, 35), C(200, 170, 70), { King = true, Eye = C(140, 255, 170) }),
	}
end
