-- RedHood rarity variants: v(name, primary, secondary, opts). Primary = body/armor suit, Secondary = jacket (or accent).
-- Flags read by Costumes/RedHood.luau: Look ("robin" | "hood" | "knight" | "redx" | "stroke"), Helmet, Jacket, Armor (under-suit), Bat, Pants
return function(v, C)
	return {
		Common = v("Red Hood", C(40, 40, 45), C(105, 65, 40), { Helmet = C(200, 25, 35), Armor = C(45, 45, 50), Bat = C(200, 30, 40) }),
		Rare = v("Robin (Jason Todd)", C(190, 30, 40), C(255, 210, 60), { Look = "robin" }),
		Epic = v("Red Hood 2.0", C(30, 30, 35), C(30, 30, 35), { Look = "hood", Helmet = C(185, 25, 35), Jacket = C(30, 30, 34), Armor = C(55, 55, 60), Bat = C(200, 30, 40), Pants = C(40, 40, 45) }),
		Legendary = v("Arkham Knight", C(30, 38, 58), C(80, 140, 220), { Look = "knight", Helmet = C(35, 45, 70), Armor = C(55, 65, 90), Bat = C(140, 200, 255), Pants = C(30, 38, 58) }),
		Mythic = v("Red X", C(25, 25, 30), C(210, 30, 30), { Look = "redx" }),
		Secret = v("Jasonstroke", C(30, 30, 35), C(210, 30, 30), { Look = "stroke", Helmet = C(200, 25, 35), Armor = C(45, 45, 50), Bat = C(210, 30, 30), Pants = C(30, 30, 35) }),
	}
end
