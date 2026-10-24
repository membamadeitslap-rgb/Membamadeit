return {
	Name = "Hulk", Faction = "Marvel", Role = "Hero", Color = Color3.fromRGB(70, 150, 50), WalkSpeed = 14,
	Abilities = {
		{ Name = "Thunderclap", Kind = "Melee", Cooldown = 6, Damage = 11, Range = Vector3.new(14, 6, 10), Offset = 5, Knockback = 70, Stun = 0.8 },
		{ Name = "Gamma Leap", Kind = "Leap", Cooldown = 7, Damage = 12, Distance = 45, Knockback = 60 },
		{ Name = "Hulk Grab", Kind = "Grab", Cooldown = 8, Damage = 10, Distance = 15, Stun = 1.2 },
		{ Name = "Ground Pound", Kind = "Melee", Cooldown = 9, Damage = 13, Range = Vector3.new(18, 6, 18), Offset = 0, Knockback = 40, Up = 35, Stun = 1.0, GuardBreak = true },
	},
	Ultimate = { Name = "Hulk Smash", Kind = "Melee", Damage = 36, Range = Vector3.new(12, 10, 12), Offset = 4, Knockback = 110, Up = 30, Stun = 1.8 },
}
