-- Server-authoritative combat: M1 combos, block, dash, abilities, ultimate.
-- Player state is stored as attributes on the Character so the client HUD can read it.
local Players = game:GetService("Players")
local RS = game:GetService("ReplicatedStorage")
local Debris = game:GetService("Debris")
local Config = require(RS.Shared.Config)
local Heroes = require(RS.Shared.Heroes)
local Net = require(RS.Shared.Net)
local Weapons = require(RS.Shared.Weapons)
local Skins = require(RS.Shared.Skins)
local HellCycle = require(RS.Shared.HellCycle)

local Combat = {}
local state = {} -- [player] = { combo, lastM1, cds = {}, counterUntil }
Combat.OnDamage = Instance.new("BindableEvent") -- (attacker, victim, dmg)

local function hrpOf(char) return char and char:FindFirstChild("HumanoidRootPart") end
local function now() return os.clock() end

local function ready(p, key, cd)
	local s = state[p]
	if (s.cds[key] or 0) > now() then return false end
	s.cds[key] = now() + cd
	return true
end

-- heroId nil = lobby mode (no skin/weapons; M1 only knocks back, used to stop thieves)
function Combat.SetupCharacter(player, heroId, rarity)
	local char = player.Character
	char:SetAttribute("Hero", heroId)
	char:SetAttribute("Rarity", rarity)
	if heroId then Skins.Apply(char, heroId, rarity or "Common") end
	char:SetAttribute("Stamina", Config.MaxStamina)
	char:SetAttribute("Ult", 0)
	char:SetAttribute("Blocking", false)
	char:SetAttribute("StunUntil", 0)
	char:SetAttribute("IFrameUntil", 0)
	local hum = char:FindFirstChildOfClass("Humanoid")
	hum.MaxHealth = Config.MaxHealth; hum.Health = Config.MaxHealth
	hum.BreakJointsOnDeath = false
	for hand, id in (Heroes[heroId] and Heroes[heroId].Weapons or {}) do Weapons.Attach(char, id, hand) end
	state[player] = { combo = 0, lastM1 = 0, cds = {}, counterUntil = 0 }
end

local function stunned(char) return char:GetAttribute("StunUntil") and char:GetAttribute("StunUntil") > now() end

-- Knockback via a short-lived LinearVelocity; ragdoll-ish via PlatformStand on heavy hits.
local function knockback(victimChar, fromPos, power, up, ragdoll)
	local hrp = hrpOf(victimChar); if not hrp then return end
	local dir = (hrp.Position - fromPos) * Vector3.new(1, 0, 1)
	dir = dir.Magnitude > 0.01 and dir.Unit or hrp.CFrame.LookVector * -1
	local att = Instance.new("Attachment", hrp)
	local lv = Instance.new("LinearVelocity")
	lv.Attachment0 = att; lv.MaxForce = math.huge
	lv.VectorVelocity = dir * power + Vector3.new(0, up or 0, 0)
	lv.Parent = hrp
	Debris:AddItem(lv, 0.15); Debris:AddItem(att, 0.15)
	if ragdoll then
		local hum = victimChar:FindFirstChildOfClass("Humanoid")
		hum.PlatformStand = true
		task.delay(0.8, function() if hum.Parent then hum.PlatformStand = false end end)
	end
end

function Combat.Hit(attacker, victimChar, info, fromPos)
	local hum = victimChar:FindFirstChildOfClass("Humanoid")
	if not hum or hum.Health <= 0 then return end
	if not Players:GetPlayerFromCharacter(victimChar) then return end -- ignore display heroes on pedestals/convoy
	if (victimChar:GetAttribute("IFrameUntil") or 0) > now() then return end
	local victim = Players:GetPlayerFromCharacter(victimChar)
	-- Counter stance: reflect the hit
	if victim and state[victim] and state[victim].counterUntil > now() then
		state[victim].counterUntil = 0
		local c = state[victim].counterInfo
		Combat.Hit(victim, attacker.Character, c, hrpOf(victimChar).Position)
		Net.Fx:FireAllClients("Counter", { pos = hrpOf(victimChar).Position })
		return
	end
	local dmg = victimChar:GetAttribute("InDuel") and info.Damage or 0 -- lobby slaps: knockback only
	local blocked = victimChar:GetAttribute("Blocking") and not info.Unblockable
	if blocked then
		local st = victimChar:GetAttribute("Stamina") - Config.Block.StaminaPerHit
		if st <= 0 or info.GuardBreak then -- guard break
			victimChar:SetAttribute("Blocking", false)
			victimChar:SetAttribute("Stamina", 0)
			victimChar:SetAttribute("StunUntil", now() + 1.2)
			Net.Fx:FireAllClients("GuardBreak", { pos = hrpOf(victimChar).Position })
			return
		end
		victimChar:SetAttribute("Stamina", st)
		dmg *= Config.Block.DamageMult
	end
	if dmg > 0 then hum:TakeDamage(dmg) end
	local ac = attacker.Character
	if ac then ac:SetAttribute("Ult", math.min(100, (ac:GetAttribute("Ult") or 0) + dmg * Config.UltPerDamage)) end
	if not blocked then
		victimChar:SetAttribute("StunUntil", now() + (info.Stun or Config.Hitstun))
		knockback(victimChar, fromPos, info.Knockback or Config.Knockback.Light, info.Up or 0, (info.Knockback or 0) >= 50)
	end
	Combat.OnDamage:Fire(attacker, victimChar, dmg)
	Net.Fx:FireAllClients("Hit", { pos = hrpOf(victimChar).Position, heavy = (info.Knockback or 0) >= 50, blocked = blocked, attacker = attacker, victim = victim, ult = info.IsUlt })
end

-- Box hitbox in front of the attacker
local function boxHit(attacker, info)
	local char = attacker.Character; local hrp = hrpOf(char); if not hrp then return end
	local cf = hrp.CFrame * CFrame.new(0, 0, -(info.Offset or 3))
	local params = OverlapParams.new()
	params.FilterDescendantsInstances = { char }; params.FilterType = Enum.RaycastFilterType.Exclude
	local hit = {}
	for _, part in workspace:GetPartBoundsInBox(cf, info.Range or Config.M1.Range, params) do
		local m = part:FindFirstAncestorOfClass("Model")
		if m and m:FindFirstChildOfClass("Humanoid") and not hit[m] then
			hit[m] = true
			Combat.Hit(attacker, m, info, hrp.Position)
		end
	end
end

local function projectile(attacker, info)
	local hrp = hrpOf(attacker.Character)
	local origin, dir = hrp.Position, hrp.CFrame.LookVector
	Net.Fx:FireAllClients("Projectile", { origin = origin, dir = dir, speed = info.Speed, hero = attacker.Character:GetAttribute("Hero"), visual = info.Visual, returns = info.Returns, char = attacker.Character })
	local params = RaycastParams.new(); params.FilterDescendantsInstances = { attacker.Character }
	local traveled, pos = 0, origin
	while traveled < 120 do
		local step = info.Speed * task.wait()
		local r = workspace:Raycast(pos, dir * step, params)
		if r then
			local m = r.Instance:FindFirstAncestorOfClass("Model")
			if m and m:FindFirstChildOfClass("Humanoid") then Combat.Hit(attacker, m, info, pos) end
			return
		end
		pos += dir * step; traveled += step
	end
end

-- Legendary+ Ghost Rider mounts the Hell Cycle for the charge (visual; physics stays on the rider)
local function mountBike(char, duration)
	local skin = Skins.Get(char:GetAttribute("Hero") or "", char:GetAttribute("Rarity") or "Common")
	local hrp = hrpOf(char)
	if not (skin and skin.HellCycle and hrp) then return end
	local bike = HellCycle.Build(skin.Flame, skin.Flame2)
	bike:PivotTo(hrp.CFrame * CFrame.new(0, -0.9, 0.4)) -- seat at hip height, wheels on the ground
	local w = Instance.new("WeldConstraint"); w.Part0 = hrp; w.Part1 = bike.PrimaryPart; w.Parent = bike.PrimaryPart
	bike.Parent = char
	Debris:AddItem(bike, duration)
end

local function leap(attacker, info)
	local hrp = hrpOf(attacker.Character)
	if info.Name == "Hellcycle Charge" then mountBike(attacker.Character, 1.2) end
	knockback(attacker.Character, hrp.Position - hrp.CFrame.LookVector, info.Distance * 2.2, 15)
	task.wait(0.25)
	boxHit(attacker, { Damage = info.Damage, Knockback = info.Knockback, Range = Vector3.new(7, 6, 7), Offset = 2 })
end

local function grab(attacker, info)
	local hrp = hrpOf(attacker.Character)
	local params = RaycastParams.new(); params.FilterDescendantsInstances = { attacker.Character }
	local r = workspace:Spherecast(hrp.Position, 2, hrp.CFrame.LookVector * info.Distance, params)
	local m = r and r.Instance:FindFirstAncestorOfClass("Model")
	if m and m:FindFirstChildOfClass("Humanoid") then
		local v = hrpOf(m)
		v.AssemblyLinearVelocity = (hrp.Position - v.Position).Unit * 90 + Vector3.new(0, 10, 0)
		Combat.Hit(attacker, m, { Damage = info.Damage, Stun = info.Stun, Knockback = 0 }, v.Position)
	end
end

local Kinds = {
	Melee = boxHit, Projectile = projectile, Leap = leap, Grab = grab,
	Counter = function(attacker, info)
		local s = state[attacker]
		s.counterUntil = now() + info.Window
		s.counterInfo = { Damage = info.Damage, Knockback = info.Knockback, Stun = 1 }
	end,
}

local Actions = {}
function Actions.M1(p, char)
	local s = state[p]
	if now() - s.lastM1 < Config.M1.Cooldown then return end
	if now() - s.lastM1 > Config.M1.ComboReset then s.combo = 0 end
	s.lastM1 = now(); s.combo += 1
	local finisher = s.combo >= Config.M1.ComboLength
	boxHit(p, finisher
		and { Damage = Config.M1.FinisherDamage, Knockback = Config.Knockback.Finisher, Up = Config.Knockback.Up, Stun = Config.FinisherStun, GuardBreak = true }
		or { Damage = Config.M1.Damage, Knockback = Config.Knockback.Light, Stun = Config.Hitstun })
	Net.Fx:FireAllClients("Swing", { char = char, combo = s.combo })
	if finisher then s.combo = 0; s.lastM1 = now() + 0.4 end -- endlag
end
function Actions.Dash(p, char)
	local st = char:GetAttribute("Stamina")
	if st < Config.Dash.StaminaCost or not ready(p, "Dash", Config.Dash.Cooldown) then return end
	char:SetAttribute("Stamina", st - Config.Dash.StaminaCost)
	char:SetAttribute("IFrameUntil", now() + Config.Dash.IFrames)
	Net.Fx:FireClient(p, "DashOk", {}) -- client applies its own velocity (owns its physics)
end
function Actions.BlockStart(_, char) char:SetAttribute("Blocking", true) end
function Actions.BlockEnd(_, char) char:SetAttribute("Blocking", false) end
function Actions.Ability(p, char, slot)
	local hero = Heroes[char:GetAttribute("Hero")]; if not hero then return end
	local info
	if slot == "Ult" then
		if (char:GetAttribute("Ult") or 0) < 100 then return end
		char:SetAttribute("Ult", 0)
		info = table.clone(hero.Ultimate); info.IsUlt = true; info.Unblockable = true
	else
		info = hero.Abilities[slot]
		if not info or not ready(p, slot, info.Cooldown) then return end
	end
	Net.Fx:FireAllClients("Ability", { char = char, name = info.Name, ult = info.IsUlt })
	task.spawn(Kinds[info.Kind], p, info)
end

Net.Action.OnServerEvent:Connect(function(p, action, arg)
	local char = p.Character
	if not char or not state[p] then return end
	if not char:GetAttribute("InDuel") and action == "Ability" then return end
	local hum = char:FindFirstChildOfClass("Humanoid")
	if hum.Health <= 0 or (stunned(char) and action ~= "BlockEnd") then return end
	if char:GetAttribute("Blocking") and action ~= "BlockEnd" then return end
	if Actions[action] then Actions[action](p, char, arg) end
end)

-- Stamina regen
task.spawn(function()
	while true do
		local dt = task.wait(0.1)
		for p in state do
			local c = p.Character
			if c and not c:GetAttribute("Blocking") then
				c:SetAttribute("Stamina", math.min(Config.MaxStamina, (c:GetAttribute("Stamina") or 0) + Config.StaminaRegen * dt))
			end
			-- Movement penalties: frozen (countdown) > stunned > blocking
			local hum = c and c:FindFirstChildOfClass("Humanoid")
			if hum then
				local hero = Heroes[c:GetAttribute("Hero")]
				local base = hero and hero.WalkSpeed or Config.WalkSpeed
				if c:GetAttribute("Carrying") then base = Config.CarryWalkSpeed end
				hum.WalkSpeed = c:GetAttribute("Frozen") and 0 or stunned(c) and Config.StunWalkSpeed
					or c:GetAttribute("Blocking") and Config.BlockWalkSpeed or base
				hum.JumpPower = (c:GetAttribute("Frozen") or stunned(c)) and 0 or Config.JumpPower
			end
		end
	end
end)
Players.PlayerRemoving:Connect(function(p) state[p] = nil end)
Players.PlayerAdded:Connect(function(p)
	p.CharacterAdded:Connect(function(char)
		task.wait()
		if not char:GetAttribute("InDuel") and p.Character == char then Combat.SetupCharacter(p, nil) end
	end)
end)

return Combat
