return {
	Name = "Ghost Rider", Faction = "Marvel", Role = "Hero", Color = Color3.fromRGB(255, 120, 20),
	Weapons = { Right = "HellfireChain" },
	Abilities = {
		{ Name = "Chain Lash", Kind = "Melee", Cooldown = 5, Damage = 11, Range = Vector3.new(6, 6, 16), Offset = 8, Knockback = 45, Stun = 0.7 },
		{ Name = "Hellfire Blast", Kind = "Projectile", Cooldown = 3.5, Damage = 9, Speed = 140, Stun = 0.5 },
		{ Name = "Chain Pull", Kind = "Grab", Cooldown = 7, Damage = 7, Distance = 35, Stun = 1.0 },
		{ Name = "Hellcycle Charge", Kind = "Leap", Cooldown = 7, Damage = 11, Distance = 45, Knockback = 55 },
	},
	Ultimate = { Name = "Penance Stare", Kind = "Melee", Damage = 34, Range = Vector3.new(8, 8, 14), Offset = 6, Knockback = 60, Stun = 2.2, Unblockable = true },
}
