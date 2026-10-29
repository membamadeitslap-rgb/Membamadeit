return {
	Build = { "Sponge" }, -- body preset + overrides (see Body.luau)
	Name = "SpongeBob", Faction = "Nick", Role = "Hero", Color = Color3.fromRGB(255, 230, 60), Style = "Blade",
	Weapons = { Right = "Spatula" },
	Abilities = {
		{ Name = "Karate Chop", Kind = "Melee", Cooldown = 4, Damage = 11, Range = Vector3.new(7, 6, 8), Offset = 4, Knockback = 45, Stun = 0.7, Element = "Slash", Anim = "Overhead" },
		{ Name = "Bubble Blast", Kind = "Projectile", Cooldown = 3.5, Damage = 8, Speed = 100, Stun = 0.8, Element = "Bubble", Anim = "Cast" },
		{ Name = "Jellyfish Net", Kind = "Grab", Cooldown = 8, Damage = 7, Distance = 34, Stun = 1.1, Element = "Lightning", Anim = "Overhead" },
		{ Name = "Spatula Flip", Kind = "Melee", Cooldown = 7, Damage = 10, Range = Vector3.new(7, 7, 8), Offset = 4, Knockback = 20, Up = 55, Stun = 1.0, Element = "Water", Anim = "Uppercut" },
	},
	Ultimate = { Name = "Krabby Patty Kombo", Kind = "Melee", Damage = 32, Range = Vector3.new(10, 8, 12), Offset = 5, Knockback = 90, Up = 20, Stun = 1.7, Element = "Bubble", Anim = "Flurry" },
}
