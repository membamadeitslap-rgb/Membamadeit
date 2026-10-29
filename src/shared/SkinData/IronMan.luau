-- IronMan rarity variants: v(name, primary, secondary, opts). opts: Colors = { group = color } overrides, Extra = { costume pieces }, Pieces = replace defaults, plus any flags the costume module reads.
return function(v, C)
	return {
		Common = v("Mark VI", C(180, 25, 30), C(205, 160, 60)),
		Rare = v("Mark I", C(110, 110, 115), C(80, 80, 85), { Extra = {} }),
		Epic = v("Hulkbuster", C(170, 30, 30), C(200, 160, 50)),
		Legendary = v("Iron Patriot", C(30, 50, 140), C(200, 30, 40)),
		Mythic = v("Mark 85", C(200, 20, 30), C(255, 200, 60)),
		Secret = v("Superior Iron Man", C(240, 240, 245), C(215, 170, 50)),
	}
end
