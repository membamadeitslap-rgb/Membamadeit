return {
	Build = { "Teen", { tall = 0.98, shoulders = 0.94, waist = 0.74, muscle = 0.3, leg = { 0.68, 1.08 } } }, -- body preset + overrides (see Body.luau)
	Name = "Danny Phantom", Faction = "Nick", Role = "Hero", Color = Color3.fromRGB(80, 230, 120), Style = "Fists", WalkSpeed = 18,
	Abilities = {
		{ Name = "Ecto-Ray", Kind = "Projectile", Cooldown = 3, Damage = 8, Speed = 170, Stun = 0.5, Element = "Ghost", Anim = "Cast" },
		{ Name = "Intangibility", Kind = "Counter", Cooldown = 8, Damage = 11, Window = 0.9, Knockback = 40, Element = "Ghost", Anim = "Uppercut" },
		{ Name = "Ghost Dive", Kind = "Leap", Cooldown = 6, Damage = 10, Distance = 46, Knockback = 50, Element = "Ghost", Anim = "Kick" },
		{ Name = "Ecto Shield Slam", Kind = "Melee", Cooldown = 8, Damage = 13, Range = Vector3.new(12, 7, 10), Offset = 3, Knockback = 55, Stun = 1.0, Element = "Ghost", Anim = "Slam" },
	},
	Ultimate = { Name = "Ghostly Wail", Kind = "Melee", Damage = 34, Range = Vector3.new(10, 10, 22), Offset = 10, Knockback = 110, Stun = 2.0, Unblockable = true, Element = "Ghost", Anim = "Cast" },
}
