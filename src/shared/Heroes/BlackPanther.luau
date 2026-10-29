return {
	Build = { "Hero", { muscle = 0.85 } }, -- body preset + overrides (see Body.luau)
	Name = "Black Panther", Faction = "Marvel", Role = "Hero", Style = "Fists", Color = Color3.fromRGB(150, 90, 255), WalkSpeed = 19,
	Weapons = { Right = "PantherClaws", Left = "PantherClaws" },
	Abilities = {
		{ Name = "Vibranium Claws", Kind = "Melee", Anim = "Flurry", Element = "Slash", Cooldown = 4, Damage = 11, Range = Vector3.new(7, 6, 7), Offset = 3, Knockback = 25, Stun = 0.6 },
		{ Name = "Kinetic Pulse", Kind = "Melee", Anim = "Slam", Element = "Cosmic", Cooldown = 8, Damage = 13, Range = Vector3.new(16, 6, 16), Offset = 0, Knockback = 55, Stun = 0.9 },
		{ Name = "Panther Pounce", Kind = "Leap", Element = "Cosmic", Cooldown = 6, Damage = 11, Distance = 42, Knockback = 50 },
		{ Name = "Kinetic Absorb", Kind = "Counter", Element = "Cosmic", Cooldown = 9, Damage = 14, Window = 0.8, Knockback = 60 },
	},
	Ultimate = { Name = "Bast's Fury", Kind = "Melee", Anim = "Flurry", Element = "Cosmic", Damage = 33, Range = Vector3.new(10, 8, 12), Offset = 4, Knockback = 90, Stun = 1.6 },
}
