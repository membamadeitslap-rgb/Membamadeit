return {
	Name = "Joker", Faction = "DC", Role = "Villain", Style = "Heavy", Color = Color3.fromRGB(100, 40, 140),
	Weapons = { Right = "JokerCrowbar" },
	Abilities = {
		{ Name = "Joker Card", Kind = "Projectile", Cooldown = 3, Damage = 6, Speed = 150, Stun = 0.4 },
		{ Name = "Crowbar Beatdown", Kind = "Melee", Cooldown = 6, Damage = 12, Range = Vector3.new(6, 6, 6), Offset = 3, Knockback = 45, Stun = 1.0 },
		{ Name = "Joy Buzzer", Kind = "Grab", Cooldown = 8, Damage = 8, Distance = 12, Stun = 1.4 },
		{ Name = "Laughing Gas", Kind = "Melee", Cooldown = 10, Damage = 8, Range = Vector3.new(16, 8, 16), Offset = 0, Knockback = 10, Stun = 1.5 },
	},
	Ultimate = { Name = "One Bad Day", Kind = "Melee", Damage = 32, Range = Vector3.new(10, 8, 12), Offset = 5, Knockback = 85, Stun = 1.6 },
}
