-- Turns server combat events into animation + VFX (see shared/Anim and shared/VFX).
-- Every client animates every fighter locally, so all players see the same moves.
local RS = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local Net = require(RS.Shared.Net)
local Heroes = require(RS.Shared.Heroes)
local Weapons = require(RS.Shared.Weapons)
local Config = require(RS.Shared.Config)
local Anim = require(RS.Shared.Anim)
local V = require(RS.Shared.VFX)
local me = Players.LocalPlayer
local M = Anim.Moves
local C = Color3.fromRGB

local function hrpOf(char) return char and char:FindFirstChild("HumanoidRootPart") end
local function involved(...) for _, c in { ... } do if c and c == me.Character then return true end end return false end
local function total(frames) local t = 0; for _, f in frames do t += f.t end return t end
local function abilityInfo(heroId, name)
	local h = Heroes[heroId or ""]; if not h then return end
	if h.Ultimate and h.Ultimate.Name == name then return h.Ultimate end
	for _, a in h.Abilities do if a.Name == name then return a end end
end

-- Smear arcs per attack: { a0, a1, vertical, radius }
local ARCS = {
	H = { { 75, -75, false, 4.5 }, { -75, 75, false, 4.5 } },
	V = { { -80, 60, true, 4.5 }, { 60, -90, true, 4.5 } },
	K = { { 60, -60, false, 3.5 }, { 50, -50, true, 3.5 } },
}
local FINISH_ARCS = { H = { 180, -180, false, 6 }, V = { 70, -110, true, 6 }, K = { 0, -360, true, 3.5 } }

local function swing(d)
	local char = d.char; local hrp = hrpOf(char); if not hrp then return end
	local frames = Anim.AttackFrames(d.style, d.kind, d.combo, d.finisher)
	Anim.Play(char, frames)
	local color = V.Bright(V.Color(nil, d.hero))
	V.Trail(char, color, total(frames), d.kind == "K" and "Kick")
	if not V.Near(hrp.Position) then return end
	task.delay(frames[1].t * 0.8, function()
		if not hrp.Parent then return end
		local arcs = ARCS[d.kind] or ARCS.H
		local a = d.finisher and FINISH_ARCS[d.kind] or arcs[(d.combo - 1) % #arcs + 1]
		local y = d.kind == "K" and -1 or 0.5
		V.Arc(hrp.CFrame * CFrame.new(0, y, 0), a[4], a[1], a[2], color, a[3], d.finisher and 2.4 or 1.6)
		if d.finisher then V.Dust(hrp.Position - Vector3.new(0, 3, 0), 2) end
	end)
end

local function hit(d)
	local color = d.blocked and C(120, 180, 255) or V.Bright(V.Color(d.element or ((d.kind == "H" or d.kind == "V" or d.kind == "K") and "Slash" or nil), d.hero))
	local mine = involved(d.achar, d.vchar)
	V.Spark(d.pos, color, d.heavy and 3 or 1.5)
	for _, c in { d.achar, d.vchar } do if c then Anim.HitStop(c, d.heavy and 0.12 or 0.05) end end
	if d.blocked then
		V.Ring(d.pos, color, 2, d.dir, 0.2)
		if mine then V.Shake(0.3) end
		return
	end
	V.SlashMark(d.pos, color, d.heavy)
	if d.dmg and d.dmg > 0 then V.Damage(d.pos, d.dmg, d.heavy and C(255, 90, 60) or C(255, 255, 255), d.heavy) end
	if d.vchar then Anim.Play(d.vchar, d.launch and M.Launched or d.heavy and M.Stagger or M.Hit, { recover = d.heavy and 0.3 or 0.15 }) end
	if d.heavy then
		V.Ring(d.pos, color, 4, d.dir)
		if d.launch then V.Ring(d.pos - Vector3.new(0, 2.5, 0), color, 3) end
	end
	if mine then
		V.Shake(d.heavy and 1.4 or 0.45)
		if d.heavy then
			task.spawn(V.ImpactFrame, { d.achar, d.vchar }, d.ult and 5 or 3)
			V.SpeedLines(0.3)
			V.FovPunch(d.ult and 14 or 8)
		end
	end
	if d.ult then V.Tint(C(255, 60, 60)) end
	if d.attacker == me then V.Combo(d.combo or 0) end
end

local function ability(d)
	local char = d.char; local hrp = hrpOf(char); if not hrp then return end
	local color = V.Bright(V.Color(d.element, d.hero))
	local info = abilityInfo(d.hero, d.name) or {}
	local style = d.style or "Fists"
	local frames
	if d.anim and M[d.anim] then frames = M[d.anim]
	elseif d.kind == "Projectile" then frames = info.Visual and M.Throw or M.Cast
	elseif d.kind == "Leap" then frames = M.Leap
	elseif d.kind == "Grab" then frames = M.Grab
	elseif d.kind == "Counter" then frames = M.Counter
	else frames = (style == "Blade" or style == "Dual") and M.Thrust or style == "Heavy" and M.Slam or style == "Staff" and M.Spin or M.Uppercut end
	local near = V.Near(hrp.Position)
	local function strike()
		if not char.Parent then return end
		if d.kind == "Counter" then
			Anim.Play(char, frames, { hold = true })
			task.delay(d.window or 0.7, function() Anim.Release(char) end)
			if near then V.Ring(hrp.Position, color, 3, nil, 0.4) end
			return
		end
		Anim.Play(char, frames)
		V.Trail(char, color, total(frames), d.anim == "Kick" and "Kick")
		if not near then return end
		local hand = char:FindFirstChild("RightHand") or hrp
		if d.kind == "Projectile" then
			task.delay(frames[1].t, function() V.Burst(hand.Position, color, 2) end)
		elseif d.kind == "Melee" then
			task.delay(frames[1].t * 0.8, function()
				if not hrp.Parent then return end
				local vertical = d.anim == "Overhead" or d.anim == "Slam" or d.anim == "Uppercut" or style == "Heavy"
				V.Arc(hrp.CFrame * CFrame.new(0, 0.5, 0), d.ult and 8 or 6, vertical and -80 or 85, vertical and 70 or -85, color, vertical, d.ult and 3.5 or 2.4)
				V.Burst(hrp.Position + hrp.CFrame.LookVector * 5, color, d.ult and 5 or 3)
			end)
		end
	end
	if d.ult then -- Critical Edge: charge, banner, then the strike
		Anim.Play(char, M.Charge, { hold = true })
		V.ChargeOrb(char:FindFirstChild("RightHand") or hrp, color, Config.CritEdgeCharge)
		if near then
			local h = Heroes[d.hero or ""]
			V.Banner("CRITICAL EDGE", (h and h.Name:upper() .. "  —  " or "") .. (d.name or ""):upper(), color)
			V.Tint(color, 1.4)
			if involved(char) then V.SpeedLines(Config.CritEdgeCharge, color) end
		end
		task.delay(Config.CritEdgeCharge, strike)
	else
		strike()
	end
end

local function projectile(d)
	local obj, held
	local color = V.Bright(V.Color(d.element, d.hero))
	if d.visual and Weapons.Ids[d.visual] then
		-- Throw the real weapon model; hide the one in hand until it returns.
		obj = Weapons.Build(d.visual)
		for _, w in d.char and d.char:GetChildren() or {} do
			if w:GetAttribute("WeaponId") == d.visual and not held then
				for _, x in w:GetDescendants() do if x:IsA("BasePart") then x.LocalTransparencyModifier = 1 end end
				held = w
			end
		end
		for _, x in obj:GetDescendants() do if x:IsA("BasePart") then x.Anchored = true end end
	else -- glowing energy orb with a white core
		obj = Instance.new("Model")
		local orb = Instance.new("Part"); orb.Name = "Grip"; orb.Shape = Enum.PartType.Ball; orb.Size = Vector3.one * 1.6
		orb.Material = Enum.Material.Neon; orb.Color = color; orb.Transparency = 0.25; orb.Anchored = true; orb.CanCollide = false; orb.Parent = obj
		local core = orb:Clone(); core.Name = "Core"; core.Size = Vector3.one * 0.8; core.Color = C(255, 255, 255); core.Transparency = 0; core.Parent = obj
		local l = Instance.new("PointLight"); l.Color = color; l.Range = 10; l.Brightness = 3; l.Parent = orb
		obj.PrimaryPart = orb
	end
	local grip = obj.PrimaryPart or obj:FindFirstChildWhichIsA("BasePart")
	local a0 = Instance.new("Attachment"); a0.Position = Vector3.new(0, 0.5, 0); a0.Parent = grip
	local a1 = Instance.new("Attachment"); a1.Position = Vector3.new(0, -0.5, 0); a1.Parent = grip
	local tr = Instance.new("Trail"); tr.Attachment0 = a0; tr.Attachment1 = a1; tr.Lifetime = 0.25; tr.LightEmission = 1; tr.FaceCamera = true
	tr.Color = ColorSequence.new(C(255, 255, 255), color); tr.Transparency = NumberSequence.new(0.1, 1)
	tr.WidthScale = NumberSequence.new(1.5, 0); tr.Parent = grip
	obj.Parent = workspace
	local life = 120 / d.speed
	local pos, t, spin = d.origin, 0, 0
	while t < life * (d.returns and 2 or 1) and obj.Parent do
		local dt = task.wait(); t += dt; spin += dt * 25
		if t < life then pos += d.dir * d.speed * dt
		else -- fly back to thrower's hand
			local hrp = hrpOf(d.char); if not hrp then break end
			local to = hrp.Position - pos
			if to.Magnitude < 3 then break end
			pos += to.Unit * math.min(to.Magnitude, d.speed * 1.2 * dt)
		end
		obj:PivotTo(CFrame.lookAt(pos, pos + d.dir) * CFrame.Angles(0, spin, 0))
	end
	obj:Destroy()
	if held then for _, x in held:GetDescendants() do if x:IsA("BasePart") then x.LocalTransparencyModifier = 0 end end end
end

local MOVE_HOLD = { Slide = 0.6, WallRunL = 0.9, WallRunR = 0.9 }
Net.Fx.OnClientEvent:Connect(function(kind, d)
	if kind == "Swing" then swing(d)
	elseif kind == "Hit" then hit(d)
	elseif kind == "Ability" then ability(d)
	elseif kind == "Projectile" then projectile(d)
	elseif kind == "ProjHit" then
		V.Burst(d.pos, V.Bright(V.Color(d.element, d.hero)), 3)
		if V.Near(d.pos, 40) then V.Shake(0.4) end
	elseif kind == "Slam" then
		local color = V.Bright(V.Color(d.element, d.hero))
		V.Crater(d.pos, 6, 12); V.Ring(d.pos + Vector3.new(0, 0.5, 0), color, 5)
		if V.Near(d.pos, 60) then V.Shake(1) end
	elseif kind == "GuardImpact" then
		V.Spark(d.pos, C(255, 240, 180), 4); V.Ring(d.pos, C(255, 220, 120), 5, workspace.CurrentCamera.CFrame.LookVector)
		if d.v then Anim.Play(d.v, M.GuardImpact) end
		if d.a then Anim.Play(d.a, M.Stagger, { recover = 0.3 }) end
		if involved(d.a, d.v) then
			task.spawn(V.ImpactFrame, { d.a, d.v }, 2)
			V.Popup("GUARD IMPACT!", C(255, 215, 80)); V.Shake(1); V.FovPunch(6)
		end
	elseif kind == "Evade" then
		V.Afterimage(d.char, C(140, 220, 255), 2)
		V.Damage(d.pos, "EVADE", C(140, 220, 255))
	elseif kind == "GuardBreak" then
		V.Spark(d.pos, C(255, 80, 80), 4); V.Ring(d.pos, C(255, 80, 80), 4)
		if V.Near(d.pos, 50) then V.Popup("GUARD BREAK!", C(255, 80, 80), 52); V.Shake(1) end
	elseif kind == "Counter" then
		V.Spark(d.pos, C(255, 255, 255), 4); V.Ring(d.pos, C(255, 255, 255), 4)
		if V.Near(d.pos, 50) then V.Popup("COUNTER!", C(255, 255, 255), 52) end
	elseif kind == "Dashed" then
		local hrp = hrpOf(d.char)
		local hero = Heroes[d.char and d.char:GetAttribute("Hero") or ""]
		V.Afterimage(d.char, V.Bright(hero and hero.Color or C(200, 220, 255)), 3)
		if hrp then V.Dust(hrp.Position - Vector3.new(0, 3, 0), 1.5) end
		if d.side then Anim.Play(d.char, M.Sidestep) end
	elseif kind == "Move" then
		local frames = M[d.move == "WallJump" and "DoubleJump" or d.move]
		if not frames then return end
		local hold = MOVE_HOLD[d.move]
		Anim.Play(d.char, frames, { hold = hold ~= nil })
		if hold then task.delay(hold, function() Anim.Release(d.char) end) end
	elseif kind == "RingOut" then
		V.Flash(C(255, 255, 255), 0.4)
		V.Popup("RING OUT!", C(255, 70, 70), 88)
	end
end)

-- Guard pose follows the replicated Blocking attribute for every fighter
local function watchChar(char)
	char:GetAttributeChangedSignal("Blocking"):Connect(function()
		if char:GetAttribute("Blocking") then Anim.Play(char, M.Block, { hold = true }) else Anim.Release(char) end
	end)
end
local function watchPlayer(p)
	p.CharacterAdded:Connect(watchChar)
	if p.Character then watchChar(p.Character) end
end
Players.PlayerAdded:Connect(watchPlayer)
for _, p in Players:GetPlayers() do watchPlayer(p) end
