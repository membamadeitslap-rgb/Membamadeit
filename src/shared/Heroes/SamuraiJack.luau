return {
	Name = "Samurai Jack", Faction = "CN", Role = "Hero", Color = Color3.fromRGB(235, 230, 215), Style = "Blade", WalkSpeed = 18,
	Weapons = { Right = "JackKatana" },
	Abilities = {
		{ Name = "Iaido Draw", Kind = "Melee", Cooldown = 4, Damage = 11, Range = Vector3.new(7, 6, 12), Offset = 6, Knockback = 40, Stun = 0.7, Element = "Slash", Anim = "Thrust" },
		{ Name = "Crane Leap", Kind = "Leap", Cooldown = 7, Damage = 11, Distance = 42, Knockback = 50, Element = "Air", Anim = "Overhead" },
		{ Name = "Whirlwind Cut", Kind = "Melee", Cooldown = 8, Damage = 12, Range = Vector3.new(14, 6, 14), Offset = 0, Knockback = 45, Stun = 0.9, Element = "Slash", Anim = "Spin" },
		{ Name = "Zen Parry", Kind = "Counter", Cooldown = 8, Damage = 12, Window = 0.7, Knockback = 45, Element = "Slash", Anim = "Thrust" },
	},
	Ultimate = { Name = "Back to the Past", Kind = "Melee", Damage = 33, Range = Vector3.new(10, 8, 16), Offset = 7, Knockback = 95, Stun = 1.8, Element = "Slash", Anim = "Flurry" },
}
