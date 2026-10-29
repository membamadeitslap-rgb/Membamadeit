-- HarleyQuinn rarity variants: v(name, primary, secondary, opts). Primary = her right side, Secondary = her left side.
-- Flags read by Costumes/HarleyQuinn.luau: Style ("squad" | "bop" | "rebirth" | "doctor"), Top, Tips = { right, left }, Jacket, Sleeves, Shorts, Legs, Boots, Trim, Belt, Crown
return function(v, C)
	return {
		Common = v("Classic Harley", C(200, 30, 40), C(25, 25, 30)),
		Rare = v("Suicide Squad Harley", C(200, 35, 55), C(45, 85, 200), { Style = "squad", Top = C(245, 245, 245), Shorts = C(200, 35, 55), Tips = { C(235, 80, 150), C(70, 130, 230) }, Boots = C(25, 25, 30), Legs = C(225, 185, 160) }),
		Epic = v("Birds of Prey Harley", C(240, 200, 50), C(230, 90, 160), { Style = "bop", Top = C(230, 90, 160), Shorts = C(110, 150, 210), Jacket = C(240, 200, 50), Tips = { C(235, 90, 160), C(80, 140, 230) }, Boots = C(240, 240, 240), Legs = C(225, 185, 160), Belt = C(240, 200, 50) }),
		Legendary = v("Rebirth Harley", C(25, 25, 30), C(200, 30, 40), { Style = "rebirth", Top = C(200, 30, 40), Shorts = C(25, 25, 30), Jacket = C(25, 25, 30), Sleeves = C(25, 25, 30), Trim = C(200, 30, 40),
			Tips = { C(200, 30, 40), C(50, 90, 210) }, Boots = C(200, 30, 40), Legs = C(215, 175, 150) }),
		Mythic = v("Dr. Harleen Quinzel", C(245, 245, 248), C(30, 30, 35), { Style = "doctor" }),
		Secret = v("Queen of Gotham", C(170, 20, 60), C(225, 180, 60), { Crown = C(240, 200, 80) }),
	}
end
