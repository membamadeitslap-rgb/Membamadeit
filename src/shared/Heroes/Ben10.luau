return {
	Build = { "Kid", { tall = 0.78, head = 1.24, shoulders = 0.82, chest = 0.8, waist = 0.76, hips = 0.8, arm = { 0.5, 0.92 }, leg = { 0.56, 0.9 }, hand = 0.68, foot = 0.85, muscle = 0.05 } }, -- body preset + overrides (see Body.luau)
	Name = "Ben 10", Faction = "CN", Role = "Hero", Color = Color3.fromRGB(60, 200, 60), Style = "Fists",
	Weapons = { Left = "Omnitrix" },
	Abilities = {
		{ Name = "Heatblast Fireball", Kind = "Projectile", Cooldown = 3.5, Damage = 9, Speed = 130, Stun = 0.5, Element = "Fire", Anim = "Cast" },
		{ Name = "Four Arms Smash", Kind = "Melee", Cooldown = 7, Damage = 14, Range = Vector3.new(12, 8, 10), Offset = 4, Knockback = 60, Up = 20, Stun = 1.0, Element = "Earth", Anim = "Slam" },
		{ Name = "XLR8 Dash", Kind = "Leap", Cooldown = 4, Damage = 8, Distance = 50, Knockback = 35, Element = "Energy", Anim = "Kick" },
		{ Name = "Diamondhead Counter", Kind = "Counter", Cooldown = 9, Damage = 12, Window = 0.7, Knockback = 50, Element = "Energy", Anim = "Uppercut" },
	},
	Ultimate = { Name = "Way Big Stomp", Kind = "Melee", Damage = 34, Range = Vector3.new(20, 12, 20), Offset = 4, Knockback = 100, Up = 35, Stun = 1.8, Element = "Energy", Anim = "Slam" },
}
