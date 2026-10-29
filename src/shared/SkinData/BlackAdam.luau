-- BlackAdam rarity variants: v(name, primary, secondary). Primary = suit, Secondary = gold trim/bolt (see Costumes/BlackAdam.luau).
return function(v, C)
	return {
		Common = v("Classic Black Adam", C(28, 28, 30), C(225, 180, 50)),
		Rare = v("Movie Black Adam", C(36, 36, 40), C(255, 190, 80)),
		Epic = v("Kahndaq Champion", C(24, 24, 30), C(70, 150, 255)),
		Legendary = v("Teth-Adam", C(170, 120, 85), C(225, 180, 50)),
		Mythic = v("Champion of Shazam", C(190, 25, 35), C(255, 210, 70)),
		Secret = v("God of Kahndaq", C(20, 20, 24), C(255, 225, 120)),
	}
end
