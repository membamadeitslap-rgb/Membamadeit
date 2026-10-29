return {
	Name = "Captain America", Faction = "Marvel", Role = "Hero", Style = "Fists", Color = Color3.fromRGB(30, 60, 150),
	Weapons = { Left = "CapShield" },
	Abilities = {
		{ Name = "Shield Throw", Kind = "Projectile", Cooldown = 3.5, Damage = 9, Speed = 120, Stun = 0.6, Visual = "CapShield", Returns = true },
		{ Name = "Shield Bash", Kind = "Melee", Cooldown = 6, Damage = 10, Range = Vector3.new(6, 6, 6), Offset = 3, Knockback = 60, Stun = 0.9, GuardBreak = true },
		{ Name = "Shield Parry", Kind = "Counter", Cooldown = 8, Damage = 11, Window = 0.8, Knockback = 45 },
		{ Name = "Charging Star", Kind = "Leap", Cooldown = 7, Damage = 9, Distance = 35, Knockback = 45 },
	},
	Ultimate = { Name = "Avengers Assemble", Kind = "Melee", Damage = 30, Range = Vector3.new(10, 8, 12), Offset = 5, Knockback = 85, Stun = 1.5 },
}
