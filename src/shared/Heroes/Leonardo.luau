return {
	Name = "Leonardo", Faction = "Nick", Role = "Hero", Color = Color3.fromRGB(40, 90, 200), Style = "Dual",
	Weapons = { Right = "LeoKatana", Left = "LeoKatana" },
	Abilities = {
		{ Name = "Twin Blade Rush", Kind = "Leap", Cooldown = 6, Damage = 11, Distance = 40, Knockback = 45, Element = "Slash", Anim = "Thrust" },
		{ Name = "Shell Spin", Kind = "Melee", Cooldown = 8, Damage = 12, Range = Vector3.new(14, 6, 14), Offset = 0, Knockback = 50, Stun = 0.9, Element = "Slash", Anim = "Spin" },
		{ Name = "Shuriken Toss", Kind = "Projectile", Cooldown = 3.5, Damage = 7, Speed = 170, Stun = 0.4, Element = "Slash", Anim = "Cast" },
		{ Name = "Ninjutsu Parry", Kind = "Counter", Cooldown = 8, Damage = 12, Window = 0.7, Knockback = 45, Element = "Slash", Anim = "Uppercut" },
	},
	Ultimate = { Name = "Cowabunga Blade Storm", Kind = "Melee", Damage = 33, Range = Vector3.new(12, 8, 14), Offset = 5, Knockback = 90, Stun = 1.7, Element = "Slash", Anim = "Flurry" },
}
