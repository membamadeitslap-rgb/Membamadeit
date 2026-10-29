-- SpiderMan rarity variants: v(name, primary, secondary, opts). opts: Colors = { group = color } overrides, Extra = { costume pieces }, Pieces = replace defaults, plus any flags the costume module reads.
return function(v, C)
	return {
		Common = v("Classic Spider-Man", C(200, 30, 40), C(30, 60, 160)),
		Rare = v("Miles Morales", C(25, 25, 30), C(200, 30, 40)),
		Epic = v("Iron Spider", C(190, 30, 30), C(215, 170, 50)),
		Legendary = v("Symbiote Spider-Man", C(15, 15, 18), C(240, 240, 240), { Colors = { Legs = C(15, 15, 18), Hands = C(240, 240, 240) } }),
		Mythic = v("Spider-Man 2099", C(25, 35, 90), C(220, 30, 40)),
		Secret = v("Cosmic Spider-Man", C(240, 240, 250), C(40, 60, 200)),
	}
end
