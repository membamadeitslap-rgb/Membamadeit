return {
	Name = "Darkseid", Faction = "DC", Role = "Villain", Color = Color3.fromRGB(90, 90, 100), WalkSpeed = 14,
	Abilities = {
		{ Name = "Omega Beams", Kind = "Projectile", Cooldown = 4, Damage = 12, Speed = 160, Stun = 0.7 },
		{ Name = "Boom Tube", Kind = "Leap", Cooldown = 8, Damage = 9, Distance = 50, Knockback = 40 },
		{ Name = "Apokolips Grip", Kind = "Grab", Cooldown = 8, Damage = 10, Distance = 18, Stun = 1.2 },
		{ Name = "Tyrant Slam", Kind = "Melee", Cooldown = 8, Damage = 14, Range = Vector3.new(9, 6, 9), Offset = 4, Knockback = 70, Stun = 1.0, GuardBreak = true },
	},
	Ultimate = { Name = "Omega Sanction", Kind = "Melee", Damage = 36, Range = Vector3.new(8, 8, 30), Offset = 15, Knockback = 90, Stun = 2.0 },
}
