return {
	Build = { "Hero", { muscle = 0.85 } }, -- body preset + overrides (see Body.luau)
	Name = "Nova", Faction = "Marvel", Role = "Hero", Color = Color3.fromRGB(205, 165, 60), WalkSpeed = 18,
	Abilities = {
		{ Name = "Nova Blast", Kind = "Projectile", Cooldown = 3, Damage = 9, Speed = 170, Stun = 0.5 },
		{ Name = "Human Rocket", Kind = "Leap", Cooldown = 5, Damage = 11, Distance = 50, Knockback = 55 },
		{ Name = "Gravimetric Pulse", Kind = "Melee", Cooldown = 8, Damage = 10, Range = Vector3.new(16, 8, 16), Offset = 0, Knockback = 45, Up = 20, Stun = 0.8 },
		{ Name = "Nova Force Shield", Kind = "Counter", Cooldown = 9, Damage = 11, Window = 0.7, Knockback = 45 },
	},
	Ultimate = { Name = "Supernova", Kind = "Melee", Damage = 33, Range = Vector3.new(20, 12, 20), Offset = 0, Knockback = 100, Up = 25, Stun = 1.6 },
}
