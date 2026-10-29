return {
	Build = { "Hero", { shoulders = 1.18, chest = 1.15 } }, -- body preset + overrides (see Body.luau)
	Name = "Batman", Faction = "DC", Weapons = { Right = "Batarang" }, Role = "Hero",
	Color = Color3.fromRGB(40, 40, 55),
	Abilities = {
		{ Name = "Batarang", Kind = "Projectile", Cooldown = 3.5, Damage = 7, Speed = 140, Stun = 0.4, Visual = "Batarang", Returns = true },
		{ Name = "Grapple Pull", Kind = "Grab", Cooldown = 8, Damage = 5, Distance = 40, Stun = 0.8 },
		{ Name = "Cape Counter", Kind = "Counter", Cooldown = 10, Damage = 10, Window = 0.7, Knockback = 40 },
		{ Name = "Smoke Bomb Strike", Kind = "Melee", Cooldown = 8, Damage = 13, Range = Vector3.new(12, 6, 12), Offset = 0, Knockback = 35, Stun = 1.0 },
	},
	Ultimate = { Name = "Knightfall Combo", Kind = "Melee", Damage = 32, Range = Vector3.new(8, 7, 10), Offset = 4, Knockback = 85, Stun = 1.6 },
}
