return {
	Build = { "Hero", { shoulders = 1.25, chest = 1.2, tall = 1.1, arm = { 0.88, 1.06 } } }, -- body preset + overrides (see Body.luau)
	Name = "Thor", Faction = "Marvel", Role = "Hero", Style = "Heavy", Color = Color3.fromRGB(60, 110, 200),
	Weapons = { Right = "Mjolnir", Left = "Stormbreaker" },
	Abilities = {
		{ Name = "Mjolnir Throw", Kind = "Projectile", Cooldown = 4, Damage = 10, Speed = 110, Stun = 0.6, Visual = "Mjolnir", Returns = true },
		{ Name = "Stormbreaker Cleave", Kind = "Melee", Cooldown = 6, Damage = 13, Range = Vector3.new(9, 6, 7), Offset = 4, Knockback = 55, Stun = 0.8 },
		{ Name = "Lightning Strike", Kind = "Melee", Element = "Lightning", Cooldown = 9, Damage = 12, Range = Vector3.new(12, 20, 12), Offset = 10, Knockback = 20, Up = 40, Stun = 1.0 },
		{ Name = "Thunder Leap", Kind = "Leap", Cooldown = 7, Damage = 10, Distance = 38, Knockback = 50 },
	},
	Ultimate = { Name = "Bifrost Smash", Kind = "Melee", Damage = 32, Range = Vector3.new(18, 10, 18), Offset = 3, Knockback = 95, Up = 30, Stun = 1.6 },
}
