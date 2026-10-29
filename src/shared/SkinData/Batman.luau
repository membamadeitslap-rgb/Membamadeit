-- Batman rarity variants: v(name, primary, secondary, opts). opts: Colors = { group = color } overrides, Extra = { costume pieces }, Pieces = replace defaults, plus any flags the costume module reads.
return function(v, C)
	return {
		Common = v("Animated Series Batman", C(120, 120, 130), C(25, 25, 35)),
		Rare = v("Filmation Batman", C(160, 160, 170), C(60, 110, 210)),
		Epic = v("Long Halloween Batman", C(95, 80, 70), C(30, 25, 25), { Pieces = {
			{ "Cowl", C(30, 25, 25), 1.1, C(234, 184, 146) }, { "Eyes", C(245, 245, 245) }, { "Cape", C(30, 25, 25) },
			{ "Emblem", "🦇", C(0, 0, 0), C(95, 80, 70) }, { "Belt", C(200, 160, 70) }, { "Cuffs", C(30, 25, 25), true } } }),
		Legendary = v("Hellbat", C(50, 50, 55), C(255, 120, 30), { Extra = { { "Shoulders", C(60, 60, 70), true } } }),
		Mythic = v("Red Death", C(170, 20, 25), C(30, 10, 10), { Extra = { { "Hair", C(170, 20, 25), "Spiky" } } }),
		Secret = v("Batman Who Laughs", C(15, 15, 18), C(200, 200, 210), { Extra = { { "Spikes", C(200, 200, 210) } } }),
	}
end
