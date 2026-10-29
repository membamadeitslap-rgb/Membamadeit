return {
	Name = "Aang", Faction = "Nick", Role = "Hero", Color = Color3.fromRGB(240, 150, 40), Style = "Staff", WalkSpeed = 20,
	Weapons = { Right = "AangStaff" },
	Abilities = {
		{ Name = "Air Scooter Blast", Kind = "Projectile", Cooldown = 3.5, Damage = 8, Speed = 150, Stun = 0.5, Element = "Air", Anim = "Cast" },
		{ Name = "Earth Pillar", Kind = "Melee", Cooldown = 8, Damage = 12, Range = Vector3.new(8, 14, 10), Offset = 6, Knockback = 20, Up = 50, Stun = 1.0, Element = "Earth", Anim = "Slam" },
		{ Name = "Fire Whip", Kind = "Melee", Cooldown = 6, Damage = 11, Range = Vector3.new(8, 6, 14), Offset = 7, Knockback = 40, Stun = 0.7, Element = "Fire", Anim = "Spin" },
		{ Name = "Water Deflect", Kind = "Counter", Cooldown = 9, Damage = 11, Window = 0.8, Knockback = 45, Element = "Water", Anim = "Cast" },
	},
	Ultimate = { Name = "Avatar State", Kind = "Melee", Damage = 34, Range = Vector3.new(20, 12, 20), Offset = 0, Knockback = 105, Up = 30, Stun = 1.8, Unblockable = true, Element = "Air", Anim = "Spin" },
}
