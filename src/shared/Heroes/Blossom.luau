return {
	Build = { "Chibi", { tall = 0.6, head = 1.7, shoulders = 0.62, chest = 0.8, waist = 0.6, hips = 0.7, arm = { 0.4, 0.62 }, leg = { 0.46, 0.6 }, hand = 0.55, foot = 0.8 } }, -- body preset + overrides (see Body.luau)
	Name = "Blossom", Faction = "CN", Role = "Hero", Color = Color3.fromRGB(240, 120, 180), Style = "Fists", WalkSpeed = 20,
	Abilities = {
		{ Name = "Flying Punch", Kind = "Leap", Cooldown = 5, Damage = 10, Distance = 48, Knockback = 55, Element = "Energy", Anim = "Thrust" },
		{ Name = "Ice Breath", Kind = "Projectile", Cooldown = 5, Damage = 8, Speed = 110, Stun = 1.1, Element = "Ice", Anim = "Cast" },
		{ Name = "Eye Beams", Kind = "Melee", Cooldown = 7, Damage = 11, Range = Vector3.new(5, 5, 18), Offset = 9, Knockback = 35, Stun = 0.8, Element = "Energy", Anim = "Cast" },
		{ Name = "Leader's Counter", Kind = "Counter", Cooldown = 8, Damage = 11, Window = 0.7, Knockback = 45, Element = "Energy", Anim = "Kick" },
	},
	Ultimate = { Name = "Powerpuff Barrage", Kind = "Melee", Damage = 32, Range = Vector3.new(10, 8, 12), Offset = 5, Knockback = 90, Up = 20, Stun = 1.7, Element = "Energy", Anim = "Flurry" },
}
