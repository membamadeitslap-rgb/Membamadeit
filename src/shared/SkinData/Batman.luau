-- Batman rarity variants: v(name, primary, secondary, opts). Primary = suit, Secondary = cowl/cape/gloves/boots/trunks.
-- The costume module (Costumes/Batman.luau) builds each variant's details from the rarity.
return function(v, C)
	return {
		Common = v("Animated Series Batman", C(128, 130, 142), C(32, 34, 48)),
		Rare = v("Filmation Batman", C(165, 165, 175), C(70, 110, 200)),
		Epic = v("Long Halloween Batman", C(122, 120, 120), C(24, 24, 28)),
		Legendary = v("Hellbat", C(55, 55, 62), C(32, 32, 38)),
		Mythic = v("Red Death", C(175, 25, 30), C(70, 12, 14)),
		Secret = v("Batman Who Laughs", C(48, 48, 54), C(18, 18, 22)),
	}
end
