-- Global tuning. All combat numbers live here so both server and client agree.
return {
	MaxHealth = 100,
	MaxStamina = 100,
	RoundsToWin = 2, -- best of 3
	RoundTime = 99,
	M1 = { Damage = 4, FinisherDamage = 7, ComboLength = 4, Cooldown = 0.32, ComboReset = 1.0, Range = Vector3.new(5, 5, 6) },
	Knockback = { Light = 8, Finisher = 55, Up = 20 },
	Hitstun = 0.35, FinisherStun = 0.9,
	Block = { DamageMult = 0.15, StaminaPerHit = 20 },
	Dash = { Speed = 70, Duration = 0.18, Cooldown = 1.2, StaminaCost = 25, IFrames = 0.15 },
	WalkSpeed = 16, StunWalkSpeed = 3, BlockWalkSpeed = 7, CarryWalkSpeed = 12, JumpPower = 50,
	StaminaRegen = 18, -- per second
	UltPerDamage = 1.5, -- ult meter gained per damage dealt (meter max 100)
	-- Soul Calibur style attacks: H = horizontal (wide, tracks sidesteps), V = vertical (strong, linear), K = kick (fast, guard-crushing finisher)
	Attacks = {
		H = { Damage = 4, Finisher = 7, Startup = 0.12, Recovery = 0.3, Range = Vector3.new(10, 5, 6), Offset = 3 },
		V = { Damage = 6, Finisher = 9, Startup = 0.18, Recovery = 0.42, Range = Vector3.new(4, 7, 8), Offset = 4 },
		K = { Damage = 5, Finisher = 8, Startup = 0.1, Recovery = 0.36, Range = Vector3.new(5, 5, 6), Offset = 3 },
	},
	GuardImpact = { Window = 0.2, Stun = 0.9 }, -- tap guard right before a hit to parry it
	Sidestep = { Window = 0.3, Speed = 45 }, -- evades verticals, horizontals still connect
	SprintSpeed = 26,
	CritEdgeCharge = 0.55, -- ultimate wind-up before the hit (attacker is invulnerable meanwhile)
	ComboWindow = 1.3, -- hits within this gap count toward the on-screen combo counter
	RingOutDepth = 25, -- studs below the arena floor = ring out
}
