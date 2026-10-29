-- WonderWoman rarity variants: v(name, primary, secondary, opts). opts: Colors = { group = color } overrides, Extra = { costume pieces }, Pieces = replace defaults, plus any flags the costume module reads.
return function(v, C)
	return {
		Common = v("Classic Wonder Woman", C(180, 30, 40), C(30, 60, 150)),
		Rare = v("Amazon Warrior", C(140, 60, 50), C(80, 60, 50)),
		Epic = v("Golden Eagle Armor", C(215, 170, 50), C(180, 140, 40)),
		Legendary = v("Goddess of War", C(100, 20, 25), C(40, 40, 45)),
		Mythic = v("Queen of the Amazons", C(240, 240, 245), C(215, 170, 50)),
		Secret = v("Goddess of Truth", C(255, 230, 140), C(255, 255, 255)),
	}
end
