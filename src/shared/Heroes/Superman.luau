return {
	Name = "Superman", Faction = "DC", Role = "Hero", Color = Color3.fromRGB(30, 70, 190),
	Abilities = {
		{ Name = "Heat Vision", Kind = "Projectile", Cooldown = 3.5, Damage = 9, Speed = 200, Stun = 0.5 },
		{ Name = "Flying Punch", Kind = "Leap", Cooldown = 6, Damage = 11, Distance = 45, Knockback = 60 },
		{ Name = "Freeze Breath", Kind = "Melee", Cooldown = 9, Damage = 7, Range = Vector3.new(8, 6, 16), Offset = 8, Knockback = 5, Stun = 1.8 },
		{ Name = "Man of Steel", Kind = "Counter", Cooldown = 9, Damage = 12, Window = 0.7, Knockback = 50 },
	},
	Ultimate = { Name = "Kryptonian Fury", Kind = "Melee", Damage = 34, Range = Vector3.new(10, 8, 12), Offset = 5, Knockback = 110, Up = 40, Stun = 1.6 },
}
