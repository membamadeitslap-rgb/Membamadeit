-- Flash rarity variants: v(name, primary, secondary, opts). opts: Colors = { group = color } overrides, Extra = { costume pieces }, Pieces = replace defaults, plus any flags the costume module reads.
return function(v, C)
	return {
		Common = v("Barry Allen", C(200, 30, 30), C(255, 210, 40)),
		Rare = v("Wally West", C(220, 40, 40), C(255, 220, 60)),
		Epic = v("Reverse-Flash", C(240, 200, 40), C(200, 30, 30)),
		Legendary = v("Zoom", C(20, 20, 25), C(60, 140, 255)),
		Mythic = v("Godspeed", C(240, 240, 245), C(255, 200, 60)),
		Secret = v("Speed Force Flash", C(255, 230, 120), C(255, 120, 30)),
	}
end
