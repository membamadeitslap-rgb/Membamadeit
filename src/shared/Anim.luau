-- Procedural keyframe animator (client-side, visual only). Drives R15 Motor6D.C0 offsets so it
-- needs no uploaded animation assets and layers on top of the default walk/idle animations.
-- Pose = { Joint = { pitch, yaw, roll, x, y, z } } in degrees/studs, relative to the rest pose.
-- Signs: arms/legs +pitch swing forward/up, knees -pitch bend back, elbows +pitch bend forward,
-- Waist/Root -pitch lean forward, +yaw turn left, shoulder +roll = right arm out (left arm: -roll = out).
local RunService = game:GetService("RunService")
local Anim = {}

local JOINTS = {
	Root = { "LowerTorso", "Root" }, Waist = { "UpperTorso", "Waist" }, Neck = { "Head", "Neck" },
	RS = { "RightUpperArm", "RightShoulder" }, RE = { "RightLowerArm", "RightElbow" },
	LS = { "LeftUpperArm", "LeftShoulder" }, LE = { "LeftLowerArm", "LeftElbow" },
	RH = { "RightUpperLeg", "RightHip" }, RK = { "RightLowerLeg", "RightKnee" },
	LH = { "LeftUpperLeg", "LeftHip" }, LK = { "LeftLowerLeg", "LeftKnee" },
}
local IDENT = CFrame.identity
local states = setmetatable({}, { __mode = "k" })

local function toCF(t)
	if not t then return IDENT end
	local r = math.rad
	return CFrame.new(t[4] or 0, t[5] or 0, t[6] or 0) * CFrame.Angles(r(t[1] or 0), r(t[2] or 0), r(t[3] or 0))
end

local function stateOf(char)
	local st = states[char]
	if st then return st end
	st = { motors = {}, base = {}, cur = {}, idle = {}, token = 0, freezeUntil = 0 }
	for k, j in JOINTS do
		local part = char:FindFirstChild(j[1])
		local m = part and part:FindFirstChild(j[2])
		if m and m:IsA("Motor6D") then st.motors[k] = m; st.base[k] = m.C0; st.cur[k] = IDENT end
	end
	if not next(st.motors) then return nil end -- R6 or broken rig: no-op
	states[char] = st
	return st
end

local function apply(st)
	for k, m in st.motors do if m.Parent then m.C0 = st.base[k] * (st.idle[k] or IDENT) * st.cur[k] end end
end

local function ease(a, style)
	if style == "In" then return a * a end
	if style == "Linear" then return a end
	return 1 - (1 - a) * (1 - a) -- Out (snappy strike)
end

-- frames = { { t = seconds, pose = Pose, ease = "Out"|"In"|"Linear" }, ... }; ends by easing back to rest.
-- opts.hold = true keeps the last pose until Anim.Release; opts.speed scales time.
function Anim.Play(char, frames, opts)
	local st = char and stateOf(char); if not st then return end
	opts = opts or {}
	st.token += 1
	local token = st.token
	task.spawn(function()
		local list = table.clone(frames)
		if not opts.hold then table.insert(list, { t = opts.recover or 0.18, pose = {}, ease = "Out" }) end
		for _, f in list do
			local from = table.clone(st.cur)
			local to = {}
			for k in st.motors do to[k] = toCF(f.pose[k]) end
			local dur, t = math.max(f.t / (opts.speed or 1), 1 / 60), 0
			while t < dur do
				local dt = RunService.RenderStepped:Wait()
				if st.token ~= token or not char.Parent then return end
				if os.clock() >= st.freezeUntil then t += dt end
				local a = ease(math.min(t / dur, 1), f.ease)
				for k in st.motors do st.cur[k] = from[k]:Lerp(to[k], a) end
				apply(st)
			end
		end
	end)
	return token
end

function Anim.Release(char, t)
	local st = char and states[char]; if not st then return end
	Anim.Play(char, {}, { recover = t or 0.15 })
end

-- Hit-stop: freeze this character's current animation for a moment (sells heavy impacts).
function Anim.HitStop(char, dur)
	local st = char and states[char]; if st then st.freezeUntil = os.clock() + dur end
end

-- Idle layer (breathing / fighting stance sway) under whatever move is playing. pose = Pose table or nil.
function Anim.Idle(char, pose)
	local st = char and stateOf(char); if not st then return end
	for k in st.motors do st.idle[k] = pose and toCF(pose[k]) or nil end
	apply(st)
end

-- ===== Pose library =====
local function F(t, pose, e) return { t = t, pose = pose, ease = e } end
local P = {}
Anim.Moves = P

-- Blade / Dual / Staff / Heavy / Fists: H = horizontal, V = vertical, K = kick (Soul Calibur A/B/K)
P.Blade = {
	H = {
		{ F(0.1, { Waist = { 0, -55, 0 }, RS = { 60, 0, 85 }, RE = { 15 }, LS = { 20, 0, -20 }, Root = { 0, -10, 0 } }, "In"),
			F(0.12, { Waist = { -10, 55, 0 }, RS = { 85, 0, -45 }, RE = { 5 }, LS = { -10, 0, -35 }, Root = { 0, 15, 0, 0, -0.3 } }) },
		{ F(0.1, { Waist = { 0, 50, 0 }, RS = { 80, 0, -60 }, RE = { 30 }, Root = { 0, 10, 0 } }, "In"),
			F(0.12, { Waist = { -10, -60, 0 }, RS = { 75, 0, 95 }, RE = { 0 }, LS = { 30, 0, -40 }, Root = { 0, -15, 0, 0, -0.3 } }) },
	},
	V = {
		{ F(0.14, { Waist = { 15, 0, 0 }, RS = { 175, 0, 10 }, RE = { 30 }, LS = { 150, 0, -10 }, Neck = { 10 } }, "In"),
			F(0.12, { Waist = { -30, 0, 0 }, RS = { 35, 0, 0 }, RE = { 0 }, LS = { 30 }, Root = { -10, 0, 0, 0, -0.7, -0.8 }, RH = { 40 }, RK = { -40 }, LH = { -25 } }) },
		{ F(0.12, { Waist = { -20, -20, 0 }, RS = { -30, 0, 20 }, RE = { 10 }, Root = { 0, 0, 0, 0, -0.8 } }, "In"), -- rising slash
			F(0.12, { Waist = { 15, 10, 0 }, RS = { 180, 0, 0 }, RE = { 0 }, Root = { 10, 0, 0, 0, 0.3 }, RK = { -20 } }) },
	},
}
P.Dual = {
	H = { { F(0.1, { RS = { 80, 0, 80 }, LS = { 80, 0, -80 }, Waist = { 10 } }, "In"),
		F(0.12, { RS = { 80, 0, -50 }, LS = { 80, 0, 50 }, Waist = { -15 }, Root = { 0, 0, 0, 0, -0.4 } }) } },
	V = { { F(0.12, { RS = { 170, 0, 20 }, LS = { 170, 0, -20 }, Waist = { 15 } }, "In"),
		F(0.12, { RS = { 20, 0, 25 }, LS = { 20, 0, -25 }, Waist = { -30 }, Root = { -10, 0, 0, 0, -0.7, -0.8 }, RH = { 35 }, RK = { -35 } }) } },
}
P.Staff = {
	H = { { F(0.08, { RS = { 90, 0, 40 }, LS = { 90, 0, -40 }, Waist = { 0, -40 } }, "In"),
		F(0.1, { Root = { 0, 120 }, RS = { 90, 0, 60 }, LS = { 70, 0, -60 } }, "Linear"),
		F(0.1, { Root = { 0, 240 }, RS = { 90, 0, 60 }, LS = { 70, 0, -60 } }, "Linear"),
		F(0.08, { Root = { 0, 355 }, RS = { 90, 0, -30 }, LS = { 90, 0, 30 } }) } },
}
P.Staff.V = P.Blade.V
P.Heavy = {
	H = { { F(0.16, { Waist = { 0, -80 }, RS = { 90, 0, 100 }, LS = { 90, 0, 60 }, Root = { 0, -20, 0, 0, -0.5 } }, "In"),
		F(0.14, { Waist = { -15, 70 }, RS = { 90, 0, -40 }, LS = { 90, 0, 20 }, Root = { 0, 30, 0, 0, -0.6 }, RH = { 30 }, LK = { -30 } }) } },
	V = { { F(0.2, { Waist = { 25 }, RS = { 185, 0, 15 }, LS = { 185, 0, -15 }, RE = { 40 }, LE = { 40 }, Root = { 0, 0, 0, 0, 0.3 } }, "In"),
		F(0.12, { Waist = { -45 }, RS = { 40, 0, 10 }, LS = { 40, 0, -10 }, RE = { 0 }, LE = { 0 }, Root = { -15, 0, 0, 0, -1.1, -1 }, RH = { 50 }, RK = { -60 }, LH = { -30 } }) } },
}
P.Fists = {
	H = {
		{ F(0.07, { Waist = { 0, -35 }, RS = { 90, 0, 70 }, RE = { 90 } }, "In"), -- right hook
			F(0.1, { Waist = { -10, 45 }, RS = { 90, 0, -10 }, RE = { 70 }, Root = { 0, 15, 0, 0, -0.2 } }) },
		{ F(0.07, { Waist = { 0, 35 }, LS = { 90, 0, -70 }, LE = { 90 } }, "In"), -- left hook
			F(0.1, { Waist = { -10, -45 }, LS = { 90, 0, 10 }, LE = { 70 }, Root = { 0, -15, 0, 0, -0.2 } }) },
	},
	V = { { F(0.1, { Root = { 0, 0, 0, 0, -0.9 }, Waist = { -15, -20 }, RS = { -20, 0, 10 }, RE = { 110 }, RK = { -40 }, LK = { -40 } }, "In"), -- uppercut
		F(0.1, { Root = { 5, 0, 0, 0, 0.4 }, Waist = { 15, 15 }, RS = { 170, 0, 0 }, RE = { 30 }, Neck = { 15 } }) } },
}
local KICK = {
	{ F(0.09, { Root = { 0, 0, -15 }, RH = { 40, 0, 20 }, RK = { -90 }, Waist = { 0, 0, 10 } }, "In"), -- side kick
		F(0.1, { Root = { 0, 0, -35 }, RH = { 10, 0, 95 }, RK = { 0 }, Waist = { 0, 0, 30 }, LS = { 30, 0, -50 }, RS = { 30, 0, 60 } }) },
	{ F(0.08, { RH = { 70 }, RK = { -110 }, Waist = { 10 } }, "In"), -- front snap kick
		F(0.1, { RH = { 100 }, RK = { 0 }, Waist = { 20 }, LK = { -15 }, Root = { 10, 0, 0, 0, 0.2 } }) },
}
for _, s in P do s.K = KICK end
-- Finishers (4th hit): launcher (V), spinning wall-splat (H), flip kick (K)
P.Finish = {
	H = { F(0.1, { Waist = { 0, -60 }, RS = { 90, 0, 90 }, Root = { 0, -30, 0, 0, -0.4 } }, "In"),
		F(0.09, { Root = { 0, 120 }, RS = { 90, 0, 60 } }, "Linear"), F(0.09, { Root = { 0, 240 }, RS = { 90, 0, 60 } }, "Linear"),
		F(0.1, { Root = { 0, 355, 0, 0, -0.5 }, RS = { 90, 0, -40 }, LS = { 60, 0, 40 } }) },
	V = { F(0.12, { Root = { 0, 0, 0, 0, -1.2 }, Waist = { -25 }, RS = { -40, 0, 15 }, RK = { -70 }, LK = { -70 } }, "In"),
		F(0.12, { Root = { 15, 0, 0, 0, 1.2 }, Waist = { 20 }, RS = { 185, 0, 0 }, LS = { 120, 0, -30 }, RH = { 20 }, LH = { -30 }, LK = { -60 } }) },
	K = { F(0.08, { Root = { 0, 0, 0, 0, -0.6 }, RK = { -60 }, LK = { -60 } }, "In"),
		F(0.1, { Root = { 120, 0, 0, 0, 1.5 }, RH = { 120 }, LH = { 30 }, LK = { -90 } }, "Linear"),
		F(0.1, { Root = { 240, 0, 0, 0, 1.5 }, RH = { 60 }, LK = { -90 } }, "Linear"),
		F(0.1, { Root = { 355, 0, 0, 0, 0.3 }, RH = { 20 }, LK = { -30 } }) },
}

-- Abilities
P.Thrust = { F(0.12, { Waist = { 0, -35 }, RS = { 70, 0, 20 }, RE = { 100 }, LS = { 60, 0, -30 }, Root = { 0, -15 } }, "In"),
	F(0.1, { Waist = { -15, 25 }, RS = { 95, 0, 0 }, RE = { 0 }, LS = { 20, 0, -40 }, Root = { -10, 15, 0, 0, -0.5, -1.5 }, RH = { 45 }, RK = { -30 }, LH = { -35 } }),
	F(0.12, { Waist = { -15, 25 }, RS = { 95, 0, 0 }, Root = { -10, 15, 0, 0, -0.5, -1.5 }, RH = { 45 }, LH = { -35 } }) }
P.Cast = { F(0.15, { Waist = { 0, -30 }, RS = { 40, 0, 30 }, RE = { 110 }, LS = { 70, 0, -10 }, LE = { 20 } }, "In"),
	F(0.08, { Waist = { -5, 20 }, RS = { 92, 0, 0 }, RE = { 0 }, LS = { 92, 0, 0 }, LE = { 0 }, Root = { 0, 0, 0, 0, -0.2, 0.3 } }),
	F(0.2, { Waist = { -5, 20 }, RS = { 92, 0, 0 }, LS = { 92, 0, 0 }, Root = { 0, 0, 0, 0, -0.2, 0.3 } }) }
P.Throw = { F(0.14, { Waist = { 15, -40 }, RS = { 170, 0, 30 }, RE = { 70 }, LS = { 60, 0, -20 } }, "In"),
	F(0.1, { Waist = { -25, 30 }, RS = { 60, 0, -20 }, RE = { 0 }, LS = { -20, 0, -30 }, Root = { -10, 20, 0, 0, -0.3 }, RH = { 30 }, LH = { -30 } }) }
P.Grab = { F(0.1, { RS = { 95, 0, 10 }, RE = { 0 }, LS = { 60, 0, -20 }, Waist = { -15, 15 }, Root = { 0, 0, 0, 0, 0, -0.6 } }),
	F(0.12, { RS = { 95, 0, 10 }, Waist = { -15, 15 } }),
	F(0.14, { RS = { 40, 0, 10 }, RE = { 120 }, Waist = { 15, -20 }, Root = { 10, 0, 0, 0, 0, 0.5 } }, "In") }
P.Counter = { F(0.08, { RS = { 100, 0, -50 }, RE = { 90 }, LS = { 100, 0, 50 }, LE = { 90 }, Root = { 0, 0, 0, 0, -0.5 }, RK = { -25 }, LK = { -25 } }) }
P.Leap = { F(0.12, { Root = { 0, 0, 0, 0, -1 }, RK = { -70 }, LK = { -70 }, RS = { -40 }, LS = { -40 } }, "In"),
	F(0.12, { Root = { -120, 0, 0, 0, 1 }, RH = { 100 }, LH = { 100 }, RK = { -120 }, LK = { -120 }, RS = { 60 }, LS = { 60 } }, "Linear"),
	F(0.12, { Root = { -240, 0, 0, 0, 1 }, RH = { 100 }, LH = { 100 }, RK = { -120 }, LK = { -120 } }, "Linear"),
	F(0.1, { Root = { -360, 0, 0, 0, 0.5 }, RS = { 170, 0, 10 }, LS = { 170, 0, -10 } }, "Linear"),
	F(0.1, { Root = { -15, 0, 0, 0, -1.1, -0.5 }, Waist = { -35 }, RS = { 30, 0, 10 }, LS = { 30, 0, -10 }, RH = { 50 }, RK = { -60 }, LH = { -30 } }) }
P.Slam = P.Heavy.V[1]
P.Overhead = P.Blade.V[1]
P.Uppercut = P.Finish.V
P.Spin = P.Finish.H
P.Kick = P.Finish.K
P.Flurry = {}
for i = 1, 6 do
	local s = i % 2 == 0 and 1 or -1
	table.insert(P.Flurry, F(0.05, { Waist = { -10, s * 30 }, RS = { 90, 0, s * 60 }, LS = { 90, 0, s * 60 }, RE = { 30 }, LE = { 30 }, Root = { 0, s * 10, 0, 0, -0.3 } }, "Linear"))
end
-- Critical Edge (ultimate) charge: crouched, arms drawn back, then the strike pose is picked by kind
P.Charge = { F(0.25, { Root = { 0, 0, 0, 0, -0.8 }, Waist = { 20, -30 }, RS = { -50, 0, 40 }, RE = { 60 }, LS = { -50, 0, -40 }, LE = { 60 }, RK = { -45 }, LK = { -45 }, Neck = { -10 } }, "Out"),
	F(0.35, { Root = { 0, 0, 0, 0, -0.9 }, Waist = { 25, -35 }, RS = { -60, 0, 45 }, RE = { 70 }, LS = { -60, 0, -45 }, LE = { 70 }, RK = { -50 }, LK = { -50 } }, "Linear") }

-- Beams: hand to the visor (eyes), chest thrust (unibeam), palm forward (repulsor / hand beams)
P.EyeBeam = { F(0.1, { Neck = { -5 }, RS = { 150, 0, -45 }, RE = { 120 }, Waist = { -5 }, Root = { 0, 0, 0, 0, -0.3 }, RK = { -20 }, LK = { -20 } }),
	F(0.4, { Neck = { -5 }, RS = { 150, 0, -45 }, RE = { 120 }, Waist = { -5 }, Root = { 0, 0, 0, 0, -0.3 }, RK = { -20 }, LK = { -20 } }, "Linear") }
P.ChestBeam = { F(0.12, { Waist = { 15 }, RS = { -40, 0, 50 }, LS = { -40, 0, -50 }, RE = { 30 }, LE = { 30 }, Neck = { 10 }, Root = { 0, 0, 0, 0, 0, 0.3 } }),
	F(0.6, { Waist = { 15 }, RS = { -40, 0, 50 }, LS = { -40, 0, -50 }, RE = { 30 }, LE = { 30 }, Neck = { 10 }, Root = { 0, 0, 0, 0, 0, 0.3 } }, "Linear") }
P.PalmBlast = { F(0.08, { RS = { 92, 0, 0 }, RE = { 0 }, Waist = { 0, 20 }, LS = { 40, 0, -20 }, LE = { 60 } }),
	F(0.3, { RS = { 92, 0, 0 }, RE = { 0 }, Waist = { 0, 20 }, LS = { 40, 0, -20 }, LE = { 60 } }, "Linear") }

-- Defense / reactions
P.Block = { F(0.06, { RS = { 95, 0, -45 }, RE = { 100 }, LS = { 95, 0, 45 }, LE = { 100 }, Waist = { -10 }, Root = { 0, 0, 0, 0, -0.3 }, RK = { -20 }, LK = { -20 } }) }
P.GuardImpact = { F(0.06, { RS = { 100, 0, -60 }, RE = { 40 }, Waist = { 0, 30 } }), F(0.1, { RS = { 130, 0, 90 }, RE = { 10 }, Waist = { 5, -35 }, LS = { 40, 0, -60 } }) }
P.Hit = { F(0.05, { Waist = { 25, 0, 10 }, Neck = { 25 }, RS = { 30, 0, 40 }, LS = { 30, 0, -40 }, Root = { 10, 0, 0, 0, 0, 0.4 } }), F(0.15, { Waist = { 15 }, Neck = { 10 } }, "In") }
P.Launched = { F(0.08, { Root = { 40, 0, 0 }, Waist = { 30 }, Neck = { 30 }, RS = { 150, 0, 40 }, LS = { 150, 0, -40 }, RH = { -20 }, LH = { 20 } }), F(0.4, { Root = { 80, 0, 0 }, Waist = { 20 }, RS = { 120, 0, 60 }, LS = { 120, 0, -60 } }, "Linear") }
P.Stagger = { F(0.08, { Waist = { 35, 25 }, Neck = { 30 }, RS = { 60, 0, 70 }, LS = { 40, 0, -70 }, Root = { 10, 0, 15 } }), F(0.6, { Waist = { 30, 20 }, Neck = { 20 }, RS = { 40, 0, 50 }, LS = { 30, 0, -50 } }, "Linear") }

-- Movement
P.DoubleJump = { F(0.1, { Root = { -120, 0, 0 }, RH = { 110 }, LH = { 110 }, RK = { -130 }, LK = { -130 }, RS = { 40 }, LS = { 40 } }, "Linear"),
	F(0.1, { Root = { -240, 0, 0 }, RH = { 110 }, LH = { 110 }, RK = { -130 }, LK = { -130 } }, "Linear"),
	F(0.1, { Root = { -360, 0, 0 }, RS = { 150, 0, 30 }, LS = { 150, 0, -30 } }, "Linear") }
P.Slide = { F(0.08, { Root = { 55, 0, 0, 0, -1.7 }, RH = { 85 }, RK = { 0 }, LH = { 40 }, LK = { -80 }, Waist = { -20 }, RS = { -20, 0, 30 }, LS = { 40, 0, -20 }, Neck = { -25 } }) }
P.WallRunL = { F(0.1, { Root = { 0, 0, -25 }, LS = { 60, 0, -70 }, RS = { -40, 0, 20 }, RH = { 60 }, RK = { -70 }, LH = { -30 } }) }
P.WallRunR = { F(0.1, { Root = { 0, 0, 25 }, RS = { 60, 0, 70 }, LS = { -40, 0, -20 }, LH = { 60 }, LK = { -70 }, RH = { -30 } }) }
P.Vault = { F(0.1, { Root = { 0, 0, 70, 0, 0.6 }, RS = { 90, 0, 0 }, LS = { 120, 0, -60 }, RH = { 60 }, LH = { 30 }, RK = { -40 } }), F(0.15, { Root = { 0, 0, 0 } }, "In") }
P.Sidestep = { F(0.06, { Root = { 0, 0, 0, 0, -0.4 }, Waist = { -10 }, RK = { -30 }, LK = { -30 }, RS = { 60, 0, -30 }, RE = { 80 }, LS = { 60, 0, 30 }, LE = { 80 } }), F(0.14, { Root = { 0, 0, 0, 0, -0.3 } }) }
P.Victory = { F(0.3, { RS = { 175, 0, 20 }, RE = { 10 }, LS = { 0, 0, -10 }, Neck = { 15 }, Waist = { 5 } }), F(1.5, { RS = { 175, 0, 20 }, Neck = { 15 } }) }

-- Pick the attack frames for a hero style / attack kind / combo step
function Anim.AttackFrames(style, kind, combo, finisher)
	if finisher then return P.Finish[kind] or P.Finish.H end
	local set = (P[style] or P.Fists)[kind] or P.Fists.H
	return set[(combo - 1) % #set + 1]
end
return Anim
