-- Aang rarity variants: v(name, primary, secondary, opts). opts: Colors = { group = color } overrides, Extra = { costume pieces }, Pieces = replace defaults, plus any flags the costume module reads.
-- ===== Nickelodeon =====
return function(v, C)
	return {
		Common = v("Air Nomad Aang", C(245, 190, 60), C(230, 120, 30)),
		Rare = v("Fire Nation Disguise", C(150, 30, 30), C(60, 30, 30), { Headband = true, Pants = C(40, 30, 30) }),
		Epic = v("Book 3 Aang", C(240, 175, 60), C(200, 90, 30), { Hair = true }),
		Legendary = v("Avatar State Aang", C(245, 190, 60), C(230, 120, 30), { Glow = true }),
		Mythic = v("Avatar Aang (Legend of Korra)", C(235, 165, 55), C(200, 70, 30), { Goatee = true }),
		Secret = v("Spirit World Aang", C(200, 230, 255), C(120, 200, 255), { Glow = true, Ghost = true }),
	}
end
