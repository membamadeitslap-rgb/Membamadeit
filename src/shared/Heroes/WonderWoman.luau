return {
	Build = { "Female", { tall = 1.06, shoulders = 0.98, arm = { 0.64, 1.04 } } }, -- body preset + overrides (see Body.luau)
	Name = "Wonder Woman", Faction = "DC", Role = "Hero", Style = "Blade", Color = Color3.fromRGB(180, 30, 40),
	Weapons = { Right = "GodKillerSword", Left = "AmazonShield" },
	Abilities = {
		{ Name = "Lasso of Truth", Kind = "Grab", Cooldown = 7, Damage = 6, Distance = 40, Stun = 1.2 },
		{ Name = "God Killer Slash", Kind = "Melee", Cooldown = 5, Damage = 12, Range = Vector3.new(9, 6, 8), Offset = 4, Knockback = 50, Stun = 0.8 },
		{ Name = "Bracelet Deflect", Kind = "Counter", Cooldown = 9, Damage = 12, Window = 0.7, Knockback = 50 },
		{ Name = "Amazon Charge", Kind = "Leap", Cooldown = 7, Damage = 10, Distance = 38, Knockback = 50 },
	},
	Ultimate = { Name = "Bracelets of Submission", Kind = "Melee", Damage = 32, Range = Vector3.new(20, 8, 20), Offset = 2, Knockback = 95, Stun = 1.5 },
}
