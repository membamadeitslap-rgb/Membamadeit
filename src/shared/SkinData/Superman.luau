-- Superman rarity variants: v(name, primary, secondary). Primary = suit, Secondary = cape/trunks/boots (see Costumes/Superman.luau).
return function(v, C)
	return {
		Common = v("Classic Superman", C(30, 80, 200), C(205, 30, 40)),
		Rare = v("Black Suit Superman", C(25, 25, 30), C(25, 25, 30)),
		Epic = v("Cyborg Superman", C(30, 70, 180), C(190, 30, 40)),
		Legendary = v("Kingdom Come Superman", C(30, 55, 135), C(160, 25, 30)),
		Mythic = v("Superman Prime", C(240, 200, 70), C(30, 70, 190)),
		Secret = v("Bizarro", C(25, 50, 110), C(120, 20, 30)),
	}
end
