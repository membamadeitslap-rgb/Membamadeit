return {
	Build = { "Lean", { leg = { 0.78, 1.14 } } }, -- body preset + overrides (see Body.luau)
	Name = "Flash", Faction = "DC", Role = "Hero", Color = Color3.fromRGB(200, 30, 30), WalkSpeed = 22,
	Abilities = {
		{ Name = "Speed Blitz", Kind = "Leap", Cooldown = 3, Damage = 7, Distance = 50, Knockback = 30 },
		{ Name = "Lightning Throw", Kind = "Projectile", Cooldown = 4, Damage = 8, Speed = 220, Stun = 0.6 },
		{ Name = "Speed Force Tornado", Kind = "Melee", Cooldown = 8, Damage = 9, Range = Vector3.new(14, 10, 14), Offset = 0, Knockback = 15, Up = 45, Stun = 1.2 },
		{ Name = "Phase", Kind = "Counter", Cooldown = 8, Damage = 10, Window = 0.8, Knockback = 40 },
	},
	Ultimate = { Name = "Infinite Mass Punch", Kind = "Melee", Damage = 33, Range = Vector3.new(6, 6, 10), Offset = 5, Knockback = 120, Stun = 1.6 },
}
