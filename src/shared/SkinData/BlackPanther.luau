-- BlackPanther rarity variants: v(name, primary, secondary, opts). Costumes/BlackPanther.luau reads these.
return function(v, C)
	return {
		Common = v("Black Panther", C(22, 22, 26), C(190, 192, 200)),
		Rare = v("Comic Black Panther", C(20, 20, 30), C(60, 60, 80)),
		Epic = v("Shuri Panther", C(22, 22, 26), C(220, 180, 70)),
		Legendary = v("Golden Jaguar", C(120, 90, 30), C(240, 200, 90)),
		Mythic = v("Kinetic Charge", C(22, 22, 26), C(170, 100, 255)),
		Secret = v("King of the Dead", C(230, 230, 235), C(150, 90, 255)),
	}
end
