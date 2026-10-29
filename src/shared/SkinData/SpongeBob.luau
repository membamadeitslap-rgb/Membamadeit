-- SpongeBob rarity variants: v(name, primary, secondary, opts). opts: Colors = { group = color } overrides, Extra = { costume pieces }, Pieces = replace defaults, plus any flags the costume module reads.
return function(v, C)
	return {
		Common = v("Classic SpongeBob", C(255, 235, 70), C(150, 100, 50)),
		Rare = v("Krusty Krab Fry Cook", C(255, 235, 70), C(150, 100, 50), { Hat = true }),
		Epic = v("Karate SpongeBob", C(255, 235, 70), C(150, 100, 50), { Karate = C(245, 245, 245) }),
		Legendary = v("Invincibubble", C(255, 235, 70), C(30, 60, 160), { Shirt = C(30, 60, 160), Tie = C(255, 215, 60), Cape = C(200, 30, 40), Emblem = "◎", Mask = C(30, 60, 160) }),
		Mythic = v("SpongeGar", C(225, 200, 80), C(150, 105, 60), { Gar = true }),
		Secret = v("Goofy Goober Rock God", C(255, 240, 120), C(40, 30, 60), { Shirt = C(25, 25, 30), Tie = C(170, 60, 255), Cape = C(110, 40, 180), Emblem = "ϟ", Rock = true }),
	}
end
