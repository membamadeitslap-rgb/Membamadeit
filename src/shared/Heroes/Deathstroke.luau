return {
	Build = { "Hero", { tall = 1.07, head = 0.95, shoulders = 1.18, chest = 1.15, muscle = 1.15, arm = { 0.84, 1.05 }, leg = { 0.86, 1.06 } } }, -- body preset + overrides (see Body.luau)
	Name = "Deathstroke", Faction = "DC", Role = "Villain", Style = "Blade", Color = Color3.fromRGB(220, 120, 30),
	Weapons = { Right = "DeathstrokeKatana", Left = "DeathstrokeStaff" },
	Abilities = {
		{ Name = "Katana Dash", Kind = "Leap", Cooldown = 5, Damage = 10, Distance = 36, Knockback = 35 },
		{ Name = "Staff Sweep", Kind = "Melee", Cooldown = 6, Damage = 10, Range = Vector3.new(12, 4, 8), Offset = 3, Knockback = 30, Up = 25, Stun = 1.0 },
		{ Name = "Tactical Parry", Kind = "Counter", Cooldown = 8, Damage = 12, Window = 0.6, Knockback = 45 },
		{ Name = "Precision Strike", Kind = "Melee", Cooldown = 7, Damage = 14, Range = Vector3.new(4, 5, 9), Offset = 5, Knockback = 55, Stun = 0.9, GuardBreak = true },
	},
	Ultimate = { Name = "Contract Fulfilled", Kind = "Melee", Damage = 32, Range = Vector3.new(10, 8, 12), Offset = 5, Knockback = 90, Stun = 1.6 },
}
