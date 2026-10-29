return {
	Build = { "Brute", { tall = 1.25, head = 1.08, waist = 0.98, leg = { 1.05, 1.1 } } }, -- body preset + overrides (see Body.luau)
	Name = "Venom", Faction = "Marvel", Role = "Villain", Color = Color3.fromRGB(20, 20, 25),
	Abilities = {
		{ Name = "Symbiote Tendril", Kind = "Grab", Cooldown = 6, Damage = 7, Distance = 35, Stun = 1.0 },
		{ Name = "Web Spit", Kind = "Projectile", Cooldown = 4, Damage = 7, Speed = 120, Stun = 1.0 },
		{ Name = "Pounce", Kind = "Leap", Cooldown = 6, Damage = 10, Distance = 38, Knockback = 45 },
		{ Name = "Tendril Lash", Kind = "Melee", Cooldown = 7, Damage = 12, Range = Vector3.new(12, 6, 10), Offset = 5, Knockback = 55, Stun = 0.8 },
	},
	Ultimate = { Name = "We Are Venom", Kind = "Melee", Damage = 33, Range = Vector3.new(10, 8, 12), Offset = 5, Knockback = 90, Stun = 1.7 },
}
