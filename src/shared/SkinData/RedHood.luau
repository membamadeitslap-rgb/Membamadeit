-- RedHood rarity variants: v(name, primary, secondary, opts). opts: Colors = { group = color } overrides, Extra = { costume pieces }, Pieces = replace defaults, plus any flags the costume module reads.
return function(v, C)
	return {
		Common = v("Red Hood", C(35, 35, 40), C(110, 70, 45)),
		Rare = v("Robin (Jason Todd)", C(190, 30, 40), C(255, 210, 60), { Pieces = {
			{ "Hair", C(25, 20, 20) }, { "Visor", C(25, 25, 30), C(245, 245, 245) }, { "Cape", C(255, 210, 60) }, { "Emblem", "R", C(20, 20, 20), C(255, 210, 60), Enum.PartType.Cylinder }, { "Belt", C(255, 210, 60) } } }),
		Epic = v("Red Hood 2.0", C(30, 30, 35), C(240, 240, 245)),
		Legendary = v("Arkham Knight", C(30, 35, 50), C(80, 140, 220), { Pieces = {
			{ "Cowl", C(30, 35, 50), 0.7 }, { "Eyes", C(120, 200, 255) }, { "Emblem", "✦", C(220, 30, 40) }, { "Shoulders", C(40, 45, 60), true }, { "Belt", C(60, 60, 70) } } }),
		Mythic = v("Red X", C(30, 30, 35), C(200, 30, 30), { Pieces = {
			{ "Helmet", C(240, 240, 245) }, { "Emblem", "✕", C(220, 30, 30) }, { "Cape", C(25, 25, 30) }, { "Belt", C(60, 60, 70) } } }),
		Secret = v("Jasonstroke", C(30, 30, 35), C(220, 30, 30), { Pieces = {
			{ "Helmet", C(220, 30, 30) }, { "Eyes", C(245, 245, 245) }, { "Harness", C(220, 30, 30) }, { "Shoulders", C(220, 30, 30) }, { "Belt", C(220, 30, 30) } } }),
	}
end
