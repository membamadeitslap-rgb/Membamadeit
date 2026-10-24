return {
	Name = "Black Adam", Faction = "DC", Role = "Villain", Color = Color3.fromRGB(30, 30, 30),
	Abilities = {
		{ Name = "Lightning Bolt", Kind = "Projectile", Cooldown = 3.5, Damage = 9, Speed = 180, Stun = 0.6 },
		{ Name = "Shazam Strike", Kind = "Melee", Cooldown = 8, Damage = 12, Range = Vector3.new(10, 20, 10), Offset = 8, Knockback = 25, Up = 35, Stun = 1.0 },
		{ Name = "Kahndaq Charge", Kind = "Leap", Cooldown = 6, Damage = 10, Distance = 42, Knockback = 55 },
		{ Name = "Ancient Guard", Kind = "Counter", Cooldown = 9, Damage = 12, Window = 0.7, Knockback = 50 },
	},
	Ultimate = { Name = "Wrath of the Gods", Kind = "Melee", Damage = 34, Range = Vector3.new(18, 12, 18), Offset = 4, Knockback = 95, Stun = 1.7 },
}
