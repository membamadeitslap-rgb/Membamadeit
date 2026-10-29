-- Joker rarity variants: v(name, primary, secondary, opts). Flags read by Costumes/Joker.luau:
-- Vest, Shirt, Tie ("long" | false | nil = bow), TieColor, Coat ("long"), Makeup ("ledger" | "arthur"), Hat, Crown, Cape, Gloves, Hair, Pants, Shoes
return function(v, C)
	return {
		Common = v("Classic Joker", C(110, 45, 150), C(60, 160, 60), { Shirt = C(245, 150, 40), TieColor = C(40, 160, 170) }),
		Rare = v("Arkham Joker", C(105, 50, 135), C(215, 130, 45), { Shirt = C(70, 150, 70), TieColor = C(60, 30, 80), Coat = "long", Gloves = C(240, 240, 235) }),
		Epic = v("Dark Knight Joker", C(70, 45, 100), C(40, 105, 65), { Shirt = C(70, 140, 120), Tie = "long", TieColor = C(30, 70, 45), Coat = "long", Makeup = "ledger",
			Hair = C(95, 125, 60), Gloves = C(110, 70, 120), Face = C(235, 232, 225), Pants = C(80, 50, 110) }),
		Legendary = v("Red Suit Joker", C(160, 35, 30), C(220, 140, 40), { Shirt = C(60, 150, 130), Tie = false, Makeup = "arthur", Face = C(245, 240, 235), Gloves = C(245, 240, 235), Shoes = C(70, 40, 30) }),
		Mythic = v("Clown Prince", C(215, 170, 50), C(110, 40, 150), { Shirt = C(110, 40, 150), TieColor = C(60, 160, 60), Hat = C(110, 40, 150) }),
		Secret = v("Emperor Joker", C(240, 240, 245), C(140, 40, 200), { Shirt = C(60, 170, 70), TieColor = C(140, 40, 200), Crown = C(225, 180, 60), Cape = C(120, 30, 170), Gloves = C(140, 40, 200), Shoes = C(140, 40, 200) }),
	}
end
