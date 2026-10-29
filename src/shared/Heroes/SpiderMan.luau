return {
	Build = { "Lean", { tall = 1.1, shoulders = 0.82, chest = 0.8, waist = 0.72, hips = 0.78, arm = { 0.7, 1.12 }, leg = { 0.74, 1.2 }, head = 1.1, hand = 0.72, foot = 0.78, muscle = 0.5 } }, -- body preset + overrides (see Body.luau)
	Name = "Spider-Man", Faction = "Marvel", Weapons = {}, -- web shooters sit under the gloves on the classic suit Role = "Hero",
	Color = Color3.fromRGB(200, 30, 40),
	Abilities = {
		{ Name = "Web Shot", Kind = "Projectile", Cooldown = 4, Damage = 6, Speed = 120, Stun = 1.2 },
		{ Name = "Web Zip", Kind = "Leap", Cooldown = 6, Damage = 8, Distance = 35, Knockback = 30 },
		{ Name = "Spider Sense Counter", Kind = "Counter", Cooldown = 10, Damage = 12, Window = 0.6, Knockback = 45 },
		{ Name = "Swing Kick", Kind = "Melee", Cooldown = 7, Damage = 11, Range = Vector3.new(7, 6, 8), Offset = 4, Knockback = 60, Stun = 0.8 },
	},
	Ultimate = { Name = "Maximum Spider", Kind = "Melee", Damage = 30, Range = Vector3.new(10, 8, 12), Offset = 5, Knockback = 90, Stun = 1.5 },
}
