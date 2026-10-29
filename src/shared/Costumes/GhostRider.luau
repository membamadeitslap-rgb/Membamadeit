-- Ghost Rider (Johnny Blaze): flaming bone skull, black leather biker jacket (raised collar, lapels, off-center zip, flared hem
-- over the hips), rounded leather shoulder pads with steel spikes, one heavy chain slung from shoulder to hip, studded belt,
-- leather pants, spiked gloves and boots.
-- Variants: Robbie Reyes (racing jacket with red/white stripes, no spikes), Danny Ketch (forearm spikes, gray pants, mystic chain),
-- Cosmic (purple/blue fire, cape, Hell Cycle), Spirit of Vengeance / King of Hell (full-body hellfire, Hell Cycle).
-- Costume module: return function(s, H, rarity) -> { colors = { group = Color3 }, pieces = { { "Piece", args... } | function(m) end } }
return function(s, H, rarity)
	local C = H.C
	local piece, round, find = H.piece, H.round, H.find
	local V, CF, A, rad = Vector3.new, CFrame.new, CFrame.Angles, math.rad
	local LEATHER, METAL = Enum.Material.Leather, Enum.Material.Metal
	local function mesh(p, kind) local sm = Instance.new("SpecialMesh"); sm.MeshType = kind; sm.Parent = p; return p end
	local function ecyl(m, a, name, w, h, d, cf, color, mat)
		return mesh(piece(m, a, name, V(h, w, d), cf * A(0, 0, rad(90)), color, mat), Enum.MeshType.Cylinder)
	end
	local JACKET, METALC = s.Primary, s.Secondary
	local robbie = rarity == "Rare"
	local ketch = rarity == "Epic"
	local STEEL = robbie and C(190, 190, 198) or METALC

	local function chainRun(m, a, from, to, n, color)
		for i = 0, n do
			local pos = from:Lerp(to, i / n)
			local dir = (to - from).Unit
			round(m, a, "Link", V(0.1, 0.3, 0.2), CFrame.lookAt(pos, pos + dir) * A(-math.pi / 2, 0, 0) * A(0, (i % 2) * math.pi / 2, 0), color, METAL)
		end
	end

	local function skullBack(m) -- rounds off the back and sides of the head behind the skull face
		local hd = find(m, "Head"); if not hd then return end
		local s3 = hd.Size
		round(m, hd, "SkullBack", V(s3.X * 1.12, s3.Y * 1.08, s3.Z * 1.0), CF(0, s3.Y * 0.04, s3.Z * 0.1), C(232, 224, 204), Enum.Material.Slate)
	end
	local function jacket(m)
		local t, w = find(m, "UpperTorso"), find(m, "LowerTorso")
		if not t then return end
		local s3 = t.Size
		local fz = -s3.Z / 2
		-- raised collar + wide lapels
		round(m, t, "Collar", V(s3.X * 0.56, s3.Y * 0.26, s3.Z * 1.05), CF(0, s3.Y * 0.5, s3.Z * 0.03), JACKET, LEATHER)
		for _, x in { -1, 1 } do
			piece(m, t, "Lapel", V(s3.X * 0.22, s3.Y * 0.36, 0.06), CF(x * s3.X * 0.16, s3.Y * 0.3, fz - 0.03) * A(0, 0, rad(x * 28)), JACKET:Lerp(C(255, 255, 255), 0.06), LEATHER)
			piece(m, t, "PocketZip", V(s3.X * 0.2, 0.04, 0.05), CF(x * s3.X * 0.26, -s3.Y * 0.12, fz - 0.02) * A(0, 0, rad(x * -15)), STEEL, METAL)
		end
		piece(m, t, "Zip", V(0.05, s3.Y * 0.9, 0.05), CF(s3.X * 0.07, -s3.Y * 0.04, fz - 0.04) * A(0, 0, rad(-10)), STEEL, METAL)
		if robbie then -- Robbie Reyes racing stripes: chest band + sleeve stripes
			piece(m, t, "Stripe", V(s3.X * 0.92, s3.Y * 0.09, 0.05), CF(0, s3.Y * 0.08, fz - 0.01), C(200, 35, 35))
			piece(m, t, "Stripe2", V(s3.X * 0.92, s3.Y * 0.04, 0.05), CF(0, s3.Y * 0.0, fz - 0.01), C(240, 240, 240))
			for _, n in { "LeftUpperArm", "RightUpperArm", "LeftLowerArm", "RightLowerArm" } do
				local a = m:FindFirstChild(n)
				if a then local x = n:find("Left") and -1 or 1
					piece(m, a, "SleeveStripe", V(0.05, a.Size.Y * 1.0, a.Size.Z * 0.22), CF(x * a.Size.X * 0.47, 0, 0), C(200, 35, 35))
					piece(m, a, "SleeveStripe2", V(0.05, a.Size.Y * 1.0, a.Size.Z * 0.08), CF(x * a.Size.X * 0.46, 0, a.Size.Z * 0.16), C(240, 240, 240)) end
			end
		end
		-- jacket hem flares over the hips, studded belt underneath
		if w then
			local ws = w.Size
			ecyl(m, w, "JacketHem", ws.X * 1.06, ws.Y * 1.2, ws.Z * 1.14, CF(0, ws.Y * 0.2, 0), JACKET, LEATHER)
			ecyl(m, w, "Belt", ws.X * 1.0, ws.Y * 0.4, ws.Z * 1.06, CF(0, -ws.Y * 0.55, 0), C(30, 26, 22), LEATHER)
			piece(m, w, "Buckle", V(ws.X * 0.2, ws.Y * 0.5, 0.06), CF(0, -ws.Y * 0.55, -ws.Z * 0.54), STEEL, METAL)
		end
		-- shoulder pads with spikes (Robbie has plain shoulders)
		if not robbie then
			for _, n in { "LeftUpperArm", "RightUpperArm" } do
				local a = m:FindFirstChild(n)
				if a then
					local as = a.Size; local x = n:find("Left") and -1 or 1
					round(m, a, "ShoulderPad", V(as.X * 1.4, as.Y * 0.55, as.Z * 1.32), CF(x * as.X * 0.08, as.Y * 0.38, 0) * A(0, 0, rad(-x * 12)), JACKET, LEATHER)
					for k = -1, 1 do
						round(m, a, "Spike", V(0.14, 0.42, 0.14), CF(x * as.X * 0.18 + k * as.X * 0.0, as.Y * 0.62, k * as.Z * 0.3) * A(0, 0, rad(-x * 25)), STEEL, METAL)
					end
				end
			end
			-- heavy chain slung from the left shoulder across to the right hip
			chainRun(m, t, V(-s3.X * 0.36, s3.Y * 0.5, fz + 0.05), V(s3.X * 0.4, -s3.Y * 0.48, fz - 0.12), ketch and 9 or 8, STEEL)
		end
		-- spikes on the glove knuckles and boot sides
		for _, n in { "LeftHand", "RightHand" } do
			local h = m:FindFirstChild(n)
			if h and not robbie then for k = -1, 1, 2 do round(m, h, "KnuckleSpike", V(0.12, 0.12, 0.3), CF(k * h.Size.X * 0.2, -h.Size.Y * 0.8, -h.Size.Z * 0.42), STEEL, METAL) end end
		end
		if ketch then -- Danny Ketch's spiked forearms
			for _, n in { "LeftLowerArm", "RightLowerArm" } do
				local a = m:FindFirstChild(n)
				if a then local x = n:find("Left") and -1 or 1
					for k = 0, 2 do round(m, a, "ArmSpike", V(0.36, 0.13, 0.13), CF(x * a.Size.X * 0.58, a.Size.Y * (0.25 - k * 0.25), 0), STEEL, METAL) end
				end
			end
		end
		for _, n in { "LeftLowerLeg", "RightLowerLeg" } do
			local a = m:FindFirstChild(n)
			if a then ecyl(m, a, "BootTop", a.Size.X * 1.1, a.Size.Y * 0.14, a.Size.Z * 1.1, CF(0, -a.Size.Y * 0.05, 0), C(18, 18, 20), LEATHER) end
		end
	end

	local colors = { Head = C(235, 228, 210), Chest = JACKET, Waist = JACKET, Arms = JACKET, Hands = C(22, 20, 20), Legs = C(28, 28, 32),
		Feet = C(18, 18, 20), LowerLegs = C(28, 28, 32) }
	if robbie then colors.Legs, colors.LowerLegs, colors.Feet = C(40, 44, 60), C(40, 44, 60), C(220, 220, 225) end
	return { colors = colors,
		pieces = { { "Material", LEATHER }, { "FlamingSkull", s.Flame, s.Flame2 }, skullBack, jacket } }
end
