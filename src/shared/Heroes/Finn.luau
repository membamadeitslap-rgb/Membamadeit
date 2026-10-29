return {
	Build = { "Kid", { tall = 0.82, head = 1.05 } }, -- body preset + overrides (see Body.luau)
	Name = "Finn", Faction = "CN", Role = "Hero", Color = Color3.fromRGB(70, 150, 230), Style = "Blade", WalkSpeed = 18,
	Weapons = { Right = "FinnSword" },
	Abilities = {
		{ Name = "Algebraic Slash", Kind = "Melee", Cooldown = 4, Damage = 11, Range = Vector3.new(8, 6, 9), Offset = 4, Knockback = 45, Stun = 0.7, Element = "Slash", Anim = "Overhead" },
		{ Name = "Hero Leap", Kind = "Leap", Cooldown = 6, Damage = 10, Distance = 40, Knockback = 45, Element = "Energy", Anim = "Slam" },
		{ Name = "Jake Stretch Grab", Kind = "Grab", Cooldown = 8, Damage = 7, Distance = 38, Stun = 1.0, Element = "Energy", Anim = "Cast" },
		{ Name = "Mathematical Kick", Kind = "Melee", Cooldown = 6, Damage = 10, Range = Vector3.new(6, 6, 8), Offset = 4, Knockback = 25, Up = 45, Stun = 0.9, Element = "Air", Anim = "Kick" },
	},
	Ultimate = { Name = "Grass Sword Fury", Kind = "Melee", Damage = 32, Range = Vector3.new(12, 8, 14), Offset = 5, Knockback = 90, Stun = 1.6, Element = "Earth", Anim = "Flurry" },
}
