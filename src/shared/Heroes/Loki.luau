return {
	Name = "Loki", Faction = "Marvel", Role = "Villain", Style = "Staff", Color = Color3.fromRGB(30, 120, 60),
	Weapons = { Right = "LokiScepter" },
	Abilities = {
		{ Name = "Scepter Bolt", Kind = "Projectile", Cooldown = 3, Damage = 8, Speed = 130, Stun = 0.5 },
		{ Name = "Illusion Step", Kind = "Leap", Cooldown = 6, Damage = 7, Distance = 35, Knockback = 25 },
		{ Name = "Trickster's Mirror", Kind = "Counter", Cooldown = 9, Damage = 12, Window = 0.7, Knockback = 45 },
		{ Name = "Scepter Impale", Kind = "Melee", Cooldown = 7, Damage = 12, Range = Vector3.new(4, 5, 10), Offset = 5, Knockback = 50, Stun = 0.9 },
	},
	Ultimate = { Name = "Glorious Purpose", Kind = "Melee", Damage = 30, Range = Vector3.new(14, 8, 14), Offset = 4, Knockback = 85, Stun = 1.6 },
}
