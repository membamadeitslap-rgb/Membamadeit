-- WonderWoman rarity variants: v(name, primary, secondary). Primary = top, Secondary = briefs (see Costumes/WonderWoman.luau).
return function(v, C)
	return {
		Common = v("Classic Wonder Woman", C(190, 30, 40), C(30, 60, 160)),
		Rare = v("Amazon Warrior", C(150, 100, 55), C(110, 70, 45)),
		Epic = v("Golden Eagle Armor", C(225, 180, 55), C(30, 60, 160)),
		Legendary = v("Goddess of War", C(110, 20, 25), C(40, 35, 38)),
		Mythic = v("Queen of the Amazons", C(240, 240, 245), C(215, 170, 50)),
		Secret = v("Goddess of Truth", C(255, 225, 120), C(250, 250, 250)),
	}
end
