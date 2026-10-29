return {
	Build = { "Titan", { tall = 1.3 } }, -- body preset + overrides (see Body.luau)
	Name = "Thanos", Faction = "Marvel", Role = "Villain", Color = Color3.fromRGB(110, 70, 140),
	Weapons = { Left = "InfinityGauntlet" },
	Abilities = {
		{ Name = "Power Stone Blast", Kind = "Projectile", Cooldown = 4, Damage = 11, Speed = 100, Stun = 0.7 },
		{ Name = "Space Stone Warp", Kind = "Leap", Cooldown = 7, Damage = 9, Distance = 45, Knockback = 40 },
		{ Name = "Titan Grip", Kind = "Grab", Cooldown = 8, Damage = 8, Distance = 30, Stun = 1.0 },
		{ Name = "Gauntlet Smash", Kind = "Melee", Cooldown = 7, Damage = 14, Range = Vector3.new(8, 6, 8), Offset = 4, Knockback = 65, Stun = 1.0, GuardBreak = true },
	},
	Ultimate = { Name = "The Snap", Kind = "Melee", Damage = 35, Range = Vector3.new(40, 20, 40), Offset = 0, Knockback = 60, Stun = 2.0 },
}
