-- Per-hero body proportions + smooth anatomy (no more identical blocky R15 bodies).
-- 1) Body.Shape(model, heroId): resizes R15 parts and their rig attachments to the hero's build
--    (Hulk huge, Blossom chibi, Flash lean, Wonder Woman's figure, SpongeBob's stick limbs...) and
--    re-seats the joints. Runs BEFORE costumes so every costume piece sizes itself to the new body.
-- 2) Body.Sculpt(model, heroId): AFTER costumes have colored the parts, covers each box limb with
--    rounded forms (ellipsoid muscles, ball joints, tapered limbs, shaped hands and boots) in the
--    same color/material, then hides the box. Costume pieces stay where they were (box faces), and the
--    rounded forms are sized so the box face centers are still on the surface.
local Body = {}

-- Build presets (each hero picks one with `Build = { "Preset", { overrides } }` in Heroes/<Id>.luau). Multipliers on the default blocky R15 sizes.
-- tall: overall height; shoulders/chest(depth)/waist/hips: torso; arm/leg: { thickness, length }
-- head: head scale; hand/foot: size; muscle: bulge amount (0 = smooth, 1 = athletic, 1.6 = brute); female: figure
local B = {}
B.Hero = { tall = 1.05, shoulders = 1.12, chest = 1.06, waist = 0.84, hips = 0.92, arm = { 0.74, 1.05 }, leg = { 0.82, 1.08 }, head = 0.9, hand = 0.85, foot = 0.85, muscle = 1 }
B.Lean = { tall = 1.02, shoulders = 1.0, chest = 0.92, waist = 0.78, hips = 0.86, arm = { 0.62, 1.06 }, leg = { 0.74, 1.1 }, head = 0.88, hand = 0.8, foot = 0.8, muscle = 0.6 }
B.Brute = { tall = 1.32, shoulders = 1.6, chest = 1.5, waist = 1.18, hips = 1.12, arm = { 1.2, 1.12 }, leg = { 1.15, 0.98 }, head = 0.82, hand = 1.35, foot = 1.25, muscle = 1.7 }
B.Titan = { tall = 1.22, shoulders = 1.42, chest = 1.35, waist = 1.1, hips = 1.08, arm = { 1.05, 1.08 }, leg = { 1.05, 1.0 }, head = 0.85, hand = 1.15, foot = 1.1, muscle = 1.35 }
B.Female = { tall = 1.0, shoulders = 0.92, chest = 0.92, waist = 0.68, hips = 0.98, arm = { 0.55, 1.02 }, leg = { 0.72, 1.12 }, head = 0.86, hand = 0.7, foot = 0.72, muscle = 0.45, female = true }
B.Teen = { tall = 0.92, shoulders = 0.95, chest = 0.9, waist = 0.78, hips = 0.84, arm = { 0.62, 1.0 }, leg = { 0.7, 1.05 }, head = 0.95, hand = 0.75, foot = 0.8, muscle = 0.35 }
B.Kid = { tall = 0.78, shoulders = 0.86, chest = 0.85, waist = 0.8, hips = 0.84, arm = { 0.58, 0.88 }, leg = { 0.64, 0.86 }, head = 1.12, hand = 0.72, foot = 0.85, muscle = 0.15 }
B.Chibi = { tall = 0.62, shoulders = 0.7, chest = 0.85, waist = 0.7, hips = 0.78, arm = { 0.42, 0.72 }, leg = { 0.48, 0.62 }, head = 1.75, hand = 0.6, foot = 0.85, muscle = 0, chibi = true }
B.Sponge = { tall = 0.82, shoulders = 1.35, chest = 0.7, waist = 1.3, hips = 1.3, arm = { 0.32, 1.0 }, leg = { 0.34, 0.85 }, head = 1.0, hand = 0.62, foot = 1.0, muscle = 0, boxy = true }
B.Turtle = { tall = 0.92, shoulders = 1.22, chest = 1.45, waist = 1.08, hips = 1.0, arm = { 0.92, 0.95 }, leg = { 0.95, 0.88 }, head = 1.0, hand = 1.0, foot = 1.0, muscle = 1.1 }
B.Armored = { tall = 1.06, shoulders = 1.18, chest = 1.15, waist = 0.92, hips = 0.98, arm = { 0.88, 1.04 }, leg = { 0.9, 1.06 }, head = 0.92, hand = 0.95, foot = 0.95, muscle = 0.8 }

local Heroes = require(script.Parent.Heroes)

function Body.Profile(heroId)
	local h = Heroes[heroId]
	local entry = h and h.Build or { "Hero" }
	local prof = table.clone(B[entry[1]])
	for k, v in entry[2] or {} do prof[k] = v end
	if not prof.round and not prof.chibi and not prof.boxy then
		-- blocky Roblox look: limbs stay chunky and legs touch; builds differ by size, not by skinny limbs
		prof.arm = { 1 + (prof.arm[1] - 0.78) * 0.6, prof.arm[2] }
		prof.leg = { 1 + (prof.leg[1] - 0.82) * 0.6, prof.leg[2] }
	end
	return prof
end

-- ===== Shape: resize parts + attachments, re-seat joints =====
local GROUP = {
	Head = "head", UpperTorso = "chest", LowerTorso = "pelvis",
	LeftUpperArm = "arm", RightUpperArm = "arm", LeftLowerArm = "arm", RightLowerArm = "arm",
	LeftHand = "hand", RightHand = "hand",
	LeftUpperLeg = "leg", RightUpperLeg = "leg", LeftLowerLeg = "leg", RightLowerLeg = "leg",
	LeftFoot = "foot", RightFoot = "foot",
}
local function factor(prof, name)
	local g = GROUP[name]
	local t = prof.tall
	if g == "head" then return Vector3.one * prof.head end
	if g == "chest" then return Vector3.new(prof.shoulders, t, prof.chest) end
	if g == "pelvis" then return Vector3.new(math.max(prof.hips, prof.waist), t, prof.chest * 0.95) end
	if g == "arm" then return Vector3.new(prof.arm[1], prof.arm[2] * t, prof.arm[1]) end
	if g == "leg" then return Vector3.new(prof.leg[1], prof.leg[2] * t, prof.leg[1]) end
	if g == "hand" then return Vector3.new(prof.hand, prof.hand, prof.hand) end
	if g == "foot" then return Vector3.new(prof.foot * prof.leg[1] / 0.8, prof.foot, prof.foot * 1.1) end
	return nil
end

function Body.Shape(model, heroId)
	if model:GetAttribute("BodyShaped") or not model:FindFirstChild("UpperTorso") then return end -- R6 / already done
	model:SetAttribute("BodyShaped", true)
	local prof = Body.Profile(heroId)
	local hum = model:FindFirstChildOfClass("Humanoid")
	local root = model:FindFirstChild("HumanoidRootPart")
	for name in GROUP do
		local p = model:FindFirstChild(name)
		local f = p and factor(prof, name)
		if f then
			p.Size *= f
			for _, a in p:GetChildren() do
				if a:IsA("Attachment") then
					local fa = f
					-- shoulders sit at the chest edge; hips spread with the pelvis
					a.Position *= fa
				end
			end
		end
	end
	local up = model:FindFirstChild("UpperTorso")
	for _, n in { "LeftShoulderRigAttachment", "RightShoulderRigAttachment" } do
		local a = up and up:FindFirstChild(n)
		if a then a.Position = Vector3.new(a.Position.X * 0.9, a.Position.Y * 0.94, a.Position.Z) end
	end
	if root then
		local f = Vector3.new(prof.shoulders, prof.tall, prof.chest)
		root.Size *= f
		for _, a in root:GetChildren() do if a:IsA("Attachment") then a.Position *= f end end
	end
	if hum then
		hum:BuildRigFromAttachments()
		-- Hip height: root attachment down the leg chain to the sole
		local function att(part, n) local p = model:FindFirstChild(part); local a = p and p:FindFirstChild(n .. "RigAttachment"); return a and a.Position.Y or 0 end
		local y = att("HumanoidRootPart", "Root") - att("LowerTorso", "Root")
			+ att("LowerTorso", "RightHip") - att("RightUpperLeg", "RightHip")
			+ att("RightUpperLeg", "RightKnee") - att("RightLowerLeg", "RightKnee")
			+ att("RightLowerLeg", "RightAnkle") - att("RightFoot", "RightAnkle")
			- model.RightFoot.Size.Y / 2
		hum.HipHeight = -y - (root and root.Size.Y / 2 or 1)
	end
end

-- ===== Sculpt: rounded anatomy over the box parts =====
local function form(model, base, name, size, offset, shape)
	local p = Instance.new("Part"); p.Name = "Body_" .. name
	p.Color = base.Color; p.Material = base.Material; p.Transparency = base.Transparency
	p.CanCollide = false; p.CanQuery = false; p.CanTouch = false; p.Massless = true; p.CastShadow = true
	p.Anchored = base.Anchored
	if shape == "Ball" then -- ellipsoid via a scaled sphere mesh
		p.Size = size
		local m = Instance.new("SpecialMesh"); m.MeshType = Enum.MeshType.Sphere; m.Parent = p
	elseif shape == "Cyl" then -- round limb segment along the part's Y axis
		p.Shape = Enum.PartType.Cylinder
		p.Size = Vector3.new(size.Y, size.X, size.Z)
		offset *= CFrame.Angles(0, 0, math.rad(90))
	else
		p.Size = size
	end
	p.CFrame = base.CFrame * offset
	local w = Instance.new("WeldConstraint"); w.Part0 = base; w.Part1 = p; w.Parent = p
	p.Parent = model
	return p
end
local V, CF = Vector3.new, CFrame.new

local function limb(model, p, mus, lower, isLeg)
	local s = p.Size
	local d = math.min(s.X, s.Z)
	-- core: straight round segment so costume lines on the box faces still touch the surface
	form(model, p, "Core", V(d * 0.93, s.Y * 1.0, d * 0.93), CF(), "Cyl")
	if not lower then
		-- one long muscle belly that overlaps both joints, so the limb reads as a continuous taper
		form(model, p, "Muscle", V(s.X * (0.94 + 0.1 * mus), s.Y * 1.3, s.Z * (0.94 + 0.12 * mus)), CF(0, s.Y * 0.06, 0), "Ball")
		if mus > 0.3 and not isLeg then -- biceps peak on the front, triceps behind
			form(model, p, "Biceps", V(s.X * 0.6, s.Y * 0.7, s.Z * 0.5), CF(0, -s.Y * 0.05, -s.Z * (0.2 + 0.05 * mus)), "Ball")
			form(model, p, "Triceps", V(s.X * 0.62, s.Y * 0.8, s.Z * 0.5), CF(0, s.Y * 0.05, s.Z * (0.2 + 0.04 * mus)), "Ball")
		end
		if isLeg then -- quad sweep on the front, hamstring behind
			form(model, p, "Quad", V(s.X * 0.8, s.Y * 0.95, s.Z * 0.6), CF(0, s.Y * 0.0, -s.Z * 0.2), "Ball")
		else -- deltoid caps the top of the arm and hides the shoulder seam
			-- deltoid size follows the build: slim caps on lean heroes, big boulders on brutes
			form(model, p, "Deltoid", V(s.X * (0.94 + 0.16 * mus), s.Y * (0.5 + 0.14 * mus), s.Z * (0.94 + 0.14 * mus)), CF(0, s.Y * (0.36 - 0.04 * mus), 0), "Ball")
		end
		form(model, p, "Joint", V(d * 0.92, d * 0.92, d * 0.92), CF(0, -s.Y / 2, 0), "Ball")
	else
		-- forearm / calf: belly high up, slimming toward the wrist / ankle
		local bx = isLeg and V(s.X * (0.96 + 0.06 * mus), s.Y * 1.05, s.Z * (1.0 + 0.1 * mus)) or V(s.X * (0.94 + 0.08 * mus), s.Y * 1.1, s.Z * (0.92 + 0.06 * mus))
		form(model, p, "Belly", bx, CF(0, s.Y * 0.16, isLeg and s.Z * 0.06 or 0), "Ball")
		form(model, p, "Lower", V(d * 0.88, s.Y * 0.85, d * 0.88), CF(0, -s.Y * 0.2, 0), "Ball")
	end
end

local function torso(model, up, low, prof)
	local s = up.Size
	local mus = prof.muscle
	-- ribcage: wide ellipsoid touching the front/back faces at the center line
	form(model, up, "Chest", V(s.X * 0.98, s.Y * 0.95, s.Z * 1.0), CF(0, s.Y * 0.1, 0), "Ball")
	-- abdomen narrows into the waist (V-taper)
	form(model, up, "Abs", V(s.X * prof.waist / prof.shoulders * 0.98, s.Y * 0.75, s.Z * 0.92), CF(0, -s.Y * 0.2, 0), "Ball")
	-- shoulders: deltoid caps + trapezius slope into the neck
	for _, x in { -1, 1 } do
		form(model, up, "Trap", V(s.X * 0.32, s.Y * (0.22 + 0.08 * mus), s.Z * 0.6), CF(x * s.X * 0.17, s.Y * 0.45, s.Z * 0.04), "Ball")
		if prof.female then
			form(model, up, "Bust", V(s.X * 0.32, s.Y * 0.26, s.Z * 0.5), CF(x * s.X * 0.16, s.Y * 0.12, -s.Z * 0.24), "Ball")
		elseif mus > 0.4 then -- pecs stop just short of the front face so chest emblems stay visible
			local pd = s.Z * (0.16 + 0.05 * mus) -- shallow pec that blends into the chest instead of a ledge
			form(model, up, "Pec", V(s.X * 0.52, s.Y * 0.34, pd), CF(x * s.X * 0.2, s.Y * 0.22, -s.Z * 0.5 + pd / 2 - 0.02) * CFrame.Angles(0, 0, math.rad(x * 6)), "Ball")
		end
		if mus > 0.9 then -- lats flare under the arms
			form(model, up, "Lat", V(s.X * 0.28, s.Y * 0.55, s.Z * 0.75), CF(x * s.X * 0.34, s.Y * 0.0, s.Z * 0.05), "Ball")
		end
	end
	-- neck column
	local head = model:FindFirstChild("Head")
	if head then
		local nd = head.Size.X * (0.45 + 0.1 * mus)
		form(model, head, "Neck", V(nd, head.Size.Y * 0.45, nd * 0.95), CF(0, -head.Size.Y * 0.5, 0.02), "Cyl")
	end
	-- pelvis: hips + glutes
	if low then
		local l = low.Size
		form(model, low, "Pelvis", V(l.X * (prof.female and 1.04 or 0.96), l.Y * 2.2, l.Z * 0.98), CF(0, -l.Y * 0.05, 0), "Ball")
		for _, x in { -1, 1 } do
			form(model, low, "Glute", V(l.X * 0.42, l.Y * 1.6, l.Z * 0.5), CF(x * l.X * 0.2, -l.Y * 0.35, l.Z * 0.22), "Ball")
		end
	end
end

local function hand(model, h)
	local s = h.Size
	-- closed fist: knuckle block + rounded palm + thumb
	form(model, h, "Palm", V(s.X * 0.82, s.Y * 1.9, s.Z * 0.82), CF(0, -s.Y * 0.35, 0), "Ball")
	form(model, h, "Fist", V(s.X * 0.72, s.Y * 1.3, s.Z * 0.72), CF(0, -s.Y * 0.9, -s.Z * 0.05), "Ball")
	local x = h.Name:find("Left") and 1 or -1
	form(model, h, "Thumb", V(s.X * 0.3, s.Y * 1.0, s.Z * 0.32), CF(x * s.X * 0.3, -s.Y * 0.6, -s.Z * 0.28), "Ball")
end

local function foot(model, f)
	local s = f.Size
	-- boot: rounded toe cap forward, heel, flat sole
	form(model, f, "Toe", V(s.X * 0.9, s.Y * 1.5, s.Z * 1.0), CF(0, s.Y * 0.05, -s.Z * 0.18), "Ball")
	form(model, f, "Heel", V(s.X * 0.82, s.Y * 1.5, s.Z * 0.55), CF(0, s.Y * 0.1, s.Z * 0.24), "Ball")
	form(model, f, "Sole", V(s.X * 0.86, s.Y * 0.3, s.Z * 1.1), CF(0, -s.Y * 0.38, -s.Z * 0.02))
end

local LIMBS = {
	{ "LeftUpperArm", false, false }, { "RightUpperArm", false, false }, { "LeftLowerArm", true, false }, { "RightLowerArm", true, false },
	{ "LeftUpperLeg", false, true }, { "RightUpperLeg", false, true }, { "LeftLowerLeg", true, true }, { "RightLowerLeg", true, true },
}
-- Art direction (user references): classic blocky Roblox bodies with printed-suit detail, so rounded sculpting is off.
-- A hero can still opt in with Build overrides { round = true }.
function Body.Sculpt(model, heroId)
	if not Body.Profile(heroId).round then return end
	if model:GetAttribute("BodySculpted") or not model:FindFirstChild("UpperTorso") then return end
	model:SetAttribute("BodySculpted", true)
	local prof = Body.Profile(heroId)
	local hide = {}
	if not prof.boxy then
		torso(model, model.UpperTorso, model:FindFirstChild("LowerTorso"), prof)
		hide = { "UpperTorso", "LowerTorso" }
	end
	for _, l in LIMBS do
		local p = model:FindFirstChild(l[1])
		if p then
			limb(model, p, prof.muscle, l[2], l[3]); table.insert(hide, l[1])
		end
	end
	for _, n in { "LeftHand", "RightHand" } do local h = model:FindFirstChild(n); if h then hand(model, h); table.insert(hide, n) end end
	for _, n in { "LeftFoot", "RightFoot" } do local f = model:FindFirstChild(n); if f then foot(model, f); table.insert(hide, n) end end
	for _, n in hide do
		local p = model:FindFirstChild(n)
		if p then p.Transparency = 1 end
	end
end
return Body
