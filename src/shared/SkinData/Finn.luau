-- Finn rarity variants: v(name, primary, secondary, opts). opts: Colors = { group = color } overrides, Extra = { costume pieces }, Pieces = replace defaults, plus any flags the costume module reads.
return function(v, C)
	return {
		Common = v("Classic Finn", C(95, 175, 235), C(30, 60, 150)),
		Rare = v("Hatless Finn", C(95, 175, 235), C(30, 60, 150), { Hatless = true }),
		Epic = v("Grass Sword Finn", C(95, 175, 235), C(30, 60, 150), { GrassArm = true }),
		Legendary = v("Fionna", C(80, 150, 230), C(40, 80, 190), { Hat = C(245, 245, 250), Pack = C(240, 120, 170), Bunny = true }),
		Mythic = v("Farmworld Finn", C(130, 100, 70), C(80, 60, 45), { RobotArm = true, Hat = C(225, 215, 190), Pack = C(110, 120, 60) }),
		Secret = v("Fern", C(80, 160, 60), C(40, 100, 40), { Fern = true, Skin = C(120, 190, 90), Hat = C(170, 220, 140), Pack = C(60, 130, 50) }),
	}
end
