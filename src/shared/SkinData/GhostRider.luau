-- GhostRider rarity variants: v(name, primary, secondary, opts). opts: Colors = { group = color } overrides, Extra = { costume pieces }, Pieces = replace defaults, plus any flags the costume module reads.
return function(v, C)
	return {
		Common = v("Johnny Blaze", C(22, 22, 24), C(170, 170, 178)),
		Rare = v("Robbie Reyes", C(25, 25, 30), C(200, 40, 40), { Flame = C(255, 110, 20), Flame2 = C(255, 210, 90) }), -- streaming orange flames, black jacket, red trim
		Epic = v("Danny Ketch", C(24, 24, 28), C(150, 150, 160), { Flame = C(255, 90, 20), Flame2 = C(255, 180, 60), Colors = { Legs = C(110, 110, 118) } }), -- gray leather pants, mystic chest chain
		Legendary = v("Cosmic Ghost Rider", C(30, 30, 40), C(215, 170, 50), { Flame = C(170, 80, 255), Flame2 = C(120, 220, 255), HellCycle = true,
			Extra = { { "HellfireBody", C(170, 80, 255), C(120, 220, 255) }, { "Cape", C(45, 30, 70), C(20, 15, 30) } } }),
		Mythic = v("Spirit of Vengeance", C(15, 12, 12), C(255, 120, 30), { Flame = C(255, 40, 20), Flame2 = C(255, 140, 40), HellCycle = true,
			Extra = { { "HellfireBody", C(255, 40, 20), C(255, 140, 40) } } }),
		Secret = v("King of Hell", C(10, 10, 12), C(255, 215, 80), { Flame = C(255, 255, 255), Flame2 = C(120, 255, 160), HellCycle = true,
			Extra = { { "HellfireBody", C(255, 255, 255), C(120, 255, 160) } } }),
	}
end
