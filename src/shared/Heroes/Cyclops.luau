return {
	Build = { "Lean", { tall = 1.12, shoulders = 1.05, chest = 0.9, waist = 0.7, hips = 0.8, arm = { 0.6, 1.2 }, leg = { 0.66, 1.5 }, head = 1.0, muscle = 0.8 } }, -- body preset + overrides (see Body.luau)
	Name = "Cyclops", Faction = "Marvel", Role = "Hero", Color = Color3.fromRGB(30, 60, 170),
	Abilities = {
		{ Name = "Optic Blast", Kind = "Beam", From = "Eyes", Element = "Optic", Cooldown = 2.8, Damage = 9, Distance = 60, Width = 1.2, Duration = 0.35, Stun = 0.5, Knockback = 20 },
		{ Name = "Ricochet Beam", Kind = "Melee", Cooldown = 7, Damage = 11, Range = Vector3.new(6, 6, 30), Offset = 15, Knockback = 50, Stun = 0.7 },
		{ Name = "Tactical Roll", Kind = "Leap", Cooldown = 5, Damage = 6, Distance = 30, Knockback = 20 },
		{ Name = "Visor Flash", Kind = "Counter", Cooldown = 9, Damage = 11, Window = 0.7, Knockback = 50 },
	},
	Ultimate = { Name = "Full Power Optic Blast", Kind = "Beam", From = "Eyes", Element = "Optic", Damage = 33, Distance = 80, Width = 3.5, Duration = 1.0, Knockback = 110, Stun = 1.6 },
}
