return {
	Build = { "Lean", { muscle = 0.8 } }, -- body preset + overrides (see Body.luau)
	Name = "Cyclops", Faction = "Marvel", Role = "Hero", Color = Color3.fromRGB(30, 60, 170),
	Abilities = {
		{ Name = "Optic Blast", Kind = "Projectile", Cooldown = 2.8, Damage = 9, Speed = 220, Stun = 0.5 },
		{ Name = "Ricochet Beam", Kind = "Melee", Cooldown = 7, Damage = 11, Range = Vector3.new(6, 6, 30), Offset = 15, Knockback = 50, Stun = 0.7 },
		{ Name = "Tactical Roll", Kind = "Leap", Cooldown = 5, Damage = 6, Distance = 30, Knockback = 20 },
		{ Name = "Visor Flash", Kind = "Counter", Cooldown = 9, Damage = 11, Window = 0.7, Knockback = 50 },
	},
	Ultimate = { Name = "Full Power Optic Blast", Kind = "Melee", Damage = 33, Range = Vector3.new(8, 8, 45), Offset = 22, Knockback = 110, Stun = 1.6 },
}
