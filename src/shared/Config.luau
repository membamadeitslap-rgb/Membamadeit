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
}
