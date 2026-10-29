return {
	Build = { "Female", { tall = 0.96 } }, -- body preset + overrides (see Body.luau)
	Name = "Harley Quinn", Faction = "DC", Role = "Villain", Style = "Heavy", Color = Color3.fromRGB(200, 40, 70),
	Weapons = { Right = "HarleyMallet" },
	Abilities = {
		{ Name = "Mallet Toss", Kind = "Projectile", Cooldown = 4, Damage = 9, Speed = 100, Stun = 0.7, Visual = "HarleyMallet", Returns = true },
		{ Name = "Cartwheel Dodge", Kind = "Leap", Cooldown = 5, Damage = 6, Distance = 30, Knockback = 25 },
		{ Name = "Home Run Swing", Kind = "Melee", Cooldown = 7, Damage = 13, Range = Vector3.new(8, 6, 7), Offset = 4, Knockback = 80, Up = 25, Stun = 1.0 },
		{ Name = "Puddin' Counter", Kind = "Counter", Cooldown = 9, Damage = 11, Window = 0.6, Knockback = 45 },
	},
	Ultimate = { Name = "Mad Love", Kind = "Melee", Damage = 30, Range = Vector3.new(12, 8, 12), Offset = 4, Knockback = 90, Stun = 1.5 },
}
