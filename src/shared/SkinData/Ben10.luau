-- Ben10 rarity variants: v(name, primary, secondary, opts). opts: Colors = { group = color } overrides, Extra = { costume pieces }, Pieces = replace defaults, plus any flags the costume module reads.
return function(v, C)
	return {
		Common = v("Classic Ben", C(245, 245, 245), C(80, 140, 70), { Tee = true, Stripe = C(25, 25, 28) }),
		Rare = v("Alien Force Ben", C(60, 160, 60), C(55, 80, 140)),
		Epic = v("Ultimate Alien Ben", C(30, 30, 34), C(50, 70, 120), { Trim = C(60, 170, 60), Stripe = C(245, 245, 245) }),
		Legendary = v("Omniverse Ben", C(30, 30, 34), C(150, 130, 95), { Tee = true, Stripe = C(80, 210, 80), Logo = true }),
		Mythic = v("Ben 10,000", C(25, 25, 28), C(25, 25, 28), { Suit = true }),
		Secret = v("Alien X", C(12, 12, 20), C(245, 245, 245), { AlienX = true }),
	}
end
