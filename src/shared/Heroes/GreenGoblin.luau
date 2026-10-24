return {
	Name = "Green Goblin", Faction = "Marvel", Role = "Villain", Color = Color3.fromRGB(60, 140, 50),
	Weapons = { Right = "PumpkinBomb" },
	Abilities = {
		{ Name = "Pumpkin Bomb", Kind = "Projectile", Cooldown = 4, Damage = 10, Speed = 90, Stun = 0.8, Visual = "PumpkinBomb" },
		{ Name = "Glider Ram", Kind = "Leap", Cooldown = 6, Damage = 10, Distance = 45, Knockback = 50 },
		{ Name = "Razor Bats", Kind = "Melee", Cooldown = 8, Damage = 11, Range = Vector3.new(10, 6, 14), Offset = 7, Knockback = 25, Stun = 0.9 },
		{ Name = "Goblin Cackle", Kind = "Counter", Cooldown = 9, Damage = 11, Window = 0.6, Knockback = 45 },
	},
	Ultimate = { Name = "Goblin Formula", Kind = "Melee", Damage = 31, Range = Vector3.new(16, 8, 16), Offset = 6, Knockback = 85, Stun = 1.5 },
}
