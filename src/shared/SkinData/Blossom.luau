-- Blossom rarity variants: v(name, primary, secondary, opts). opts: Colors = { group = color } overrides, Extra = { costume pieces }, Pieces = replace defaults, plus any flags the costume module reads.
return function(v, C)
	return {
		Common = v("Classic Blossom", C(245, 135, 190), C(20, 20, 22)),
		Rare = v("2016 Reboot Blossom", C(250, 150, 200), C(20, 20, 22), { Hair = C(240, 95, 50), Bow = C(235, 30, 60) }),
		Epic = v("Hyper Blossom (Powerpuff Z)", C(240, 90, 150), C(250, 250, 250), { Ponytail = true, Belt = C(250, 250, 250), Tights = C(240, 90, 150) }),
		Legendary = v("Dynamo Pilot Blossom", C(245, 135, 190), C(20, 20, 22), { Armor = C(170, 175, 190) }),
		Mythic = v("Dark Blossom", C(30, 25, 35), C(220, 30, 60), { Bow = C(20, 20, 22), Iris = C(220, 30, 60), Tights = C(30, 25, 35) }),
		Secret = v("Chemical X Overload", C(250, 220, 240), C(255, 80, 160), { Bow = C(255, 80, 160), Hair = C(255, 170, 90), Iris = C(255, 60, 140), Armor = C(255, 215, 120) }),
	}
end
