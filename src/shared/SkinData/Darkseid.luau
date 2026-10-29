-- Darkseid rarity variants: v(name, primary, secondary). Primary = stone skin, Secondary = tunic/helmet (see Costumes/Darkseid.luau).
return function(v, C)
	return {
		Common = v("Classic Darkseid", C(118, 118, 112), C(45, 70, 150)),
		Rare = v("Armored Darkseid", C(105, 105, 102), C(40, 40, 46)),
		Epic = v("Injustice Darkseid", C(95, 88, 84), C(50, 40, 40)),
		Legendary = v("God of Apokolips", C(80, 78, 76), C(35, 30, 30)),
		Mythic = v("Omega Darkseid", C(100, 100, 98), C(40, 55, 120)),
		Secret = v("Absolute Darkseid", C(40, 38, 46), C(18, 16, 24)),
	}
end
