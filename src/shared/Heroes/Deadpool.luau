return {
	Build = { "Hero", { muscle = 0.8 } }, -- body preset + overrides (see Body.luau)
	Name = "Deadpool", Faction = "Marvel", Role = "Hero", Style = "Dual", Color = Color3.fromRGB(170, 20, 30),
	Weapons = { Right = "DeadpoolKatana", Left = "DeadpoolKatana" },
	Abilities = {
		{ Name = "Katana Flurry", Kind = "Melee", Anim = "Flurry", Element = "Slash", Cooldown = 5, Damage = 12, Range = Vector3.new(8, 6, 8), Offset = 4, Knockback = 30, Stun = 0.7 },
		{ Name = "Double Tap", Kind = "Projectile", From = "RightHand", Element = "Fire", Cooldown = 3, Damage = 8, Speed = 220, Stun = 0.3 },
		{ Name = "Teleport Slash", Kind = "Leap", Element = "Cosmic", Cooldown = 7, Damage = 10, Distance = 40, Knockback = 45 },
		{ Name = "Healing Factor", Kind = "Counter", Element = "Slash", Cooldown = 9, Damage = 10, Window = 0.8, Knockback = 45 },
	},
	Ultimate = { Name = "Maximum Effort", Kind = "Melee", Anim = "Spin", Element = "Slash", Damage = 33, Range = Vector3.new(14, 8, 14), Offset = 2, Knockback = 95, Stun = 1.6 },
}
