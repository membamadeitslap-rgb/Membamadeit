return {
	Build = { "Armored", { muscle = 0.38, waist = 0.82, chest = 1.05, shoulders = 1.15 } }, -- body preset + overrides (see Body.luau)
	Name = "Iron Man", Faction = "Marvel", Role = "Hero", Color = Color3.fromRGB(180, 25, 30),
	Weapons = { Right = "Repulsor", Left = "Repulsor" },
	Abilities = {
		{ Name = "Repulsor Blast", Kind = "Projectile", From = "RightHand", Element = "Repulsor", Cooldown = 3, Damage = 8, Speed = 160, Stun = 0.4 },
		{ Name = "Thruster Rush", Kind = "Leap", Cooldown = 6, Damage = 9, Distance = 40, Knockback = 40 },
		{ Name = "Micro Missiles", Kind = "Melee", Cooldown = 8, Damage = 12, Range = Vector3.new(14, 6, 14), Offset = 8, Knockback = 30, Stun = 0.7 },
		{ Name = "Nano Shield", Kind = "Counter", Cooldown = 10, Damage = 10, Window = 0.6, Knockback = 40 },
	},
	Ultimate = { Name = "Unibeam", Kind = "Beam", From = "Chest", Element = "Repulsor", Damage = 30, Distance = 70, Width = 3, Duration = 0.9, Knockback = 90, Stun = 1.5 },
}
