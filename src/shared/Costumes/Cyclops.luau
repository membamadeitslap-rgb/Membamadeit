-- Cyclops (X-Men '97 / Jim Lee): blue suit and cowl with brown hair spiking out the top, open lower face, wraparound yellow visor
-- with a ruby-quartz lens and round ear pods, yellow X-harness (crossing chest straps over the shoulders), yellow belt with a red
-- X-Men buckle, upper-arm and thigh bands with thigh pouches, yellow flared gloves and boots.
-- Variants: Jim Lee, X-Factor (white trim), Astonishing (black suit, solid yellow X), Phoenix Five / Dark Phoenix (phoenix emblem).
-- Costume module: return function(s, H, rarity) -> { colors = { group = Color3 }, pieces = { { "Piece", args... } | function(m) end } }
return function(s, H, rarity)
	local C, SKIN = H.C, H.SKIN
	local piece, round, find, glyph = H.piece, H.round, H.find, H.glyph
	local V, CF, A, rad = Vector3.new, CFrame.new, CFrame.Angles, math.rad
	local function mesh(p, kind) local sm = Instance.new("SpecialMesh"); sm.MeshType = kind; sm.Parent = p; return p end
	local function ecyl(m, a, name, w, h, d, cf, color, mat)
		return mesh(piece(m, a, name, V(h, w, d), cf * A(0, 0, rad(90)), color, mat), Enum.MeshType.Cylinder)
	end
	local SUIT, ACC = s.Primary, s.Secondary
	local phoenix = rarity == "Mythic" or rarity == "Secret"
	local astonishing = rarity == "Legendary"
	local LENS = C(225, 25, 30)
	local HAIR = C(120, 62, 32)

	local function head(m)
		local hd = find(m, "Head"); if not hd then return end
		local s3 = hd.Size
		local hx, hy, hz = s3.X, s3.Y, s3.Z
		-- cowl over the skull, open below the visor
		round(m, hd, "Cowl", V(hx * 1.1, hy * 0.86, hz * 1.1), CF(0, hy * 0.16, 0.01), SUIT)
		round(m, hd, "CowlBack", V(hx * 1.14, hy * 1.08, hz * 0.84), CF(0, -hy * 0.04, hz * 0.16), SUIT)
		round(m, hd, "CowlBrow", V(hx * 0.98, hy * 0.5, hz * 0.34), CF(0, hy * 0.32, -hz * 0.38), SUIT)
		for _, x in { -1, 1 } do -- cowl comes down the sides of the face to the jaw
			round(m, hd, "CowlCheek", V(hx * 0.24, hy * 0.7, hz * 0.8), CF(x * hx * 0.42, -hy * 0.14, hz * 0.04), SUIT)
		end
		-- hair spiking up out of the top of the cowl
		round(m, hd, "Hair", V(hx * 0.62, hy * 0.24, hz * 0.6), CF(0, hy * 0.55, hz * 0.05), HAIR)
		for i, sp in { { -0.16, 0.0, -20, 20 }, { 0.0, -0.06, -30, 0 }, { 0.16, 0.0, -20, -20 }, { -0.08, 0.16, 10, 12 }, { 0.1, 0.17, 12, -10 } } do
			round(m, hd, "HairSpike", V(hx * 0.2, hy * 0.46, hx * 0.2), CF(sp[1] * hx, hy * 0.7, sp[2] * hz) * A(rad(sp[3]), 0, rad(sp[4])), HAIR)
		end
		-- visor: wraparound frame, ruby lens, round ear pods
		ecyl(m, hd, "Visor", hx * 1.13, hy * 0.2, hz * 1.13, CF(0, hy * 0.08, 0), ACC, Enum.Material.Metal)
		round(m, hd, "Lens", V(hx * 0.86, hy * 0.15, hz * 0.24), CF(0, hy * 0.08, -hz * 0.5), LENS, Enum.Material.Glass)
		for _, x in { -1, 1 } do
			piece(m, hd, "EarPod", V(0.14, hy * 0.36, hy * 0.36), CF(x * hx * 0.56, hy * 0.04, 0), ACC, Enum.Material.Metal, Enum.PartType.Cylinder)
			piece(m, hd, "EarPodCap", V(0.06, hy * 0.2, hy * 0.2), CF(x * hx * 0.63, hy * 0.04, 0), SUIT, Enum.Material.Metal, Enum.PartType.Cylinder)
		end
	end

	local function body(m)
		local t, w = find(m, "UpperTorso"), find(m, "LowerTorso")
		if not t then return end
		local s3 = t.Size
		local fz = -s3.Z / 2
		if phoenix then -- Phoenix Force firebird across the chest
			local FIRE = ACC
			piece(m, t, "PhoenixBody", V(s3.X * 0.1, s3.Y * 0.5, 0.06), CF(0, s3.Y * 0.08, fz - 0.03), FIRE)
			round(m, t, "PhoenixHead", V(s3.X * 0.13, s3.X * 0.13, 0.08), CF(0, s3.Y * 0.36, fz - 0.03), FIRE)
			for _, x in { -1, 1 } do
				for k = 0, 2 do
					piece(m, t, "PhoenixWing", V(s3.X * (0.36 - k * 0.07), s3.Y * 0.06, 0.06), CF(x * s3.X * (0.2 + k * 0.03), s3.Y * (0.24 - k * 0.1), fz - 0.02) * A(0, 0, rad(x * (28 + k * 10))), FIRE)
				end
				piece(m, t, "PhoenixTail", V(s3.X * 0.06, s3.Y * 0.4, 0.06), CF(x * s3.X * 0.06, -s3.Y * 0.32, fz - 0.02) * A(0, 0, rad(-x * 18)), FIRE)
			end
		else
			-- X-harness: wide straps from each shoulder crossing at the sternum
			local diag = math.sqrt((s3.X * 0.66) ^ 2 + s3.Y ^ 2)
			local ang = math.atan2(s3.X * 0.66, s3.Y)
			for _, k in { -1, 1 } do
				piece(m, t, "StrapX", V(s3.X * (astonishing and 0.16 or 0.12), diag, 0.07), CF(0, 0, fz - 0.03) * A(0, 0, k * ang), ACC)
				if not astonishing then
					round(m, t, "StrapShoulder", V(s3.X * 0.14, s3.Y * 0.1, s3.Z * 1.06), CF(k * s3.X * 0.33, s3.Y * 0.47, 0), ACC)
					piece(m, t, "StrapBack", V(s3.X * 0.12, diag, 0.07), CF(0, 0, s3.Z / 2 + 0.03) * A(0, 0, k * ang), ACC)
				end
			end
			if not astonishing then
				local ring = piece(m, t, "StrapRing", V(0.08, s3.X * 0.14, s3.X * 0.14), CF(0, 0, fz - 0.06) * A(0, rad(90), 0), ACC:Lerp(C(0, 0, 0), 0.2), Enum.Material.Metal, Enum.PartType.Cylinder)
			end
		end
		if w then -- belt + red X-Men buckle
			local ws = w.Size
			ecyl(m, w, "Belt", ws.X * 1.02, ws.Y * 0.7, ws.Z * 1.08, CF(0, ws.Y * 0.2, 0), ACC)
			piece(m, w, "Buckle", V(0.08, ws.Y * 1.0, ws.Y * 1.0), CF(0, ws.Y * 0.2, -ws.Z * 0.55) * A(0, rad(90), 0), phoenix and C(255, 220, 80) or C(200, 25, 25), Enum.Material.Metal, Enum.PartType.Cylinder)
			local g = piece(m, w, "BuckleX", V(ws.Y * 0.8, ws.Y * 0.8, 0.02), CF(0, ws.Y * 0.2, -ws.Z * 0.6), C(0, 0, 0)); g.Transparency = 1
			glyph(g, Enum.NormalId.Front, "X", phoenix and C(200, 60, 20) or C(25, 25, 30))
		end
		-- bands on the upper arms, thigh straps with pouches
		if not astonishing then
			for _, n in { "LeftUpperArm", "RightUpperArm", "LeftUpperLeg", "RightUpperLeg" } do
				local a = m:FindFirstChild(n)
				if a then
					local as = a.Size; local x = n:find("Left") and -1 or 1
					local leg = n:find("Leg") ~= nil
					ecyl(m, a, "Band", as.X * 1.08, as.Y * 0.16, as.Z * 1.08, CF(0, leg and as.Y * 0.05 or -as.Y * 0.05, 0), ACC)
					if leg and not phoenix then piece(m, a, "Pouch", V(0.14, as.Y * 0.28, as.Z * 0.42), CF(x * as.X * 0.52, as.Y * 0.05, 0), ACC) end
				end
			end
		end
		-- flared glove cuffs + boot tops
		for _, n in { "LeftLowerArm", "RightLowerArm", "LeftLowerLeg", "RightLowerLeg" } do
			local a = m:FindFirstChild(n)
			if a then
				local leg = n:find("Leg") ~= nil
				ecyl(m, a, "Cuff", a.Size.X * 1.2, a.Size.Y * 0.14, a.Size.Z * 1.2, CF(0, a.Size.Y * 0.4, 0), ACC)
			end
		end
	end

	local colors = { Head = SKIN, Chest = SUIT, Waist = SUIT, Arms = SUIT, Legs = SUIT, Gloves = ACC, Boots = ACC }
	return { colors = colors, pieces = { head, { "LowerFace" }, body } }
end
