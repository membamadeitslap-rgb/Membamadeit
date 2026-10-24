return {
	Name = "Red Hood", Faction = "DC", Role = "Villain", Color = Color3.fromRGB(190, 30, 40),
	Weapons = { Right = "DeathstrokeKatana" },
	Abilities = {
		{ Name = "Crowbar Toss", Kind = "Projectile", Cooldown = 3.5, Damage = 8, Speed = 120, Stun = 0.6, Visual = "JokerCrowbar", Returns = true },
		{ Name = "All-Caste Blade", Kind = "Melee", Cooldown = 6, Damage = 12, Range = Vector3.new(8, 6, 7), Offset = 4, Knockback = 45, Stun = 0.8 },
		{ Name = "Grapple Line", Kind = "Grab", Cooldown = 7, Damage = 6, Distance = 38, Stun = 1.0 },
		{ Name = "Street Counter", Kind = "Counter", Cooldown = 8, Damage = 12, Window = 0.6, Knockback = 45 },
	},
	Ultimate = { Name = "Under the Hood", Kind = "Melee", Damage = 32, Range = Vector3.new(10, 8, 12), Offset = 5, Knockback = 90, Stun = 1.6 },
}
