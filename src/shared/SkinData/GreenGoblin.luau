-- GreenGoblin rarity variants: v(name, primary, secondary, opts). opts: Colors = { group = color } overrides, Extra = { costume pieces }, Pieces = replace defaults, plus any flags the costume module reads.
return function(v, C)
	return {
		Common = v("Classic Goblin", C(60, 140, 50), C(110, 50, 140)),
		Rare = v("Armored Goblin", C(70, 100, 60), C(60, 60, 65)),
		Epic = v("Hobgoblin", C(230, 120, 30), C(40, 70, 160)),
		Legendary = v("Red Goblin", C(200, 30, 30), C(20, 20, 25)),
		Mythic = v("Demogoblin", C(120, 20, 20), C(255, 130, 30)),
		Secret = v("Goblin King", C(40, 150, 60), C(70, 25, 95)),
	}
end
