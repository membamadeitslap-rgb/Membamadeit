-- Deadpool rarity variants: v(name, primary, secondary, opts). Costumes/Deadpool.luau reads these.
return function(v, C)
	return {
		Common = v("Classic Deadpool", C(170, 20, 30), C(20, 20, 24)),
		Rare = v("X-Force Deadpool", C(40, 40, 46), C(170, 20, 30)),
		Epic = v("Lady Deadpool", C(170, 20, 30), C(20, 20, 24)),
		Legendary = v("Dogpool", C(170, 20, 30), C(20, 20, 24)),
		Mythic = v("Deadpool Kills the Multiverse", C(110, 10, 15), C(10, 10, 12)),
		Secret = v("Venompool", C(15, 15, 18), C(240, 240, 240)),
	}
end
