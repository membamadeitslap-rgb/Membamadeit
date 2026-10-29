-- Flash rarity variants: v(name, primary, secondary). Primary = suit, Secondary = boots/bolts (see Costumes/Flash.luau).
return function(v, C)
	return {
		Common = v("Barry Allen", C(200, 25, 30), C(250, 200, 40)),
		Rare = v("Wally West", C(185, 20, 30), C(255, 215, 60)),
		Epic = v("Reverse-Flash", C(240, 200, 40), C(200, 30, 30)),
		Legendary = v("Zoom", C(22, 22, 28), C(60, 140, 255)),
		Mythic = v("Godspeed", C(235, 235, 240), C(250, 190, 40)),
		Secret = v("Speed Force Flash", C(255, 200, 70), C(255, 240, 170)),
	}
end
