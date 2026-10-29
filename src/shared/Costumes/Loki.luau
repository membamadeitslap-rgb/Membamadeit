-- Loki (MCU Avengers look): black leather coat with green panels and long coat tails, layered gold gorget + shoulder plates,
-- gold horned helmet (cap, cheek guards, forehead point, long horns sweeping up and back), long green cape, slick black hair.
-- Variants: Agent of Asgard (no helmet, scarf), Kid Loki (small horns), Sylvie (blonde, broken-horn crown),
-- President Loki (black suit + green tie under the cape), God of Stories (green/gold robes, huge horns).
-- Costume module: return function(s, H, rarity) -> { colors = { group = Color3 }, pieces = { { "Piece", args... } | function(m) end } }
return function(s, H, rarity)
	local C, SKIN, GOLD = H.C, H.SKIN, H.GOLD
	local piece, round, find = H.piece, H.round, H.find
	local V, CF, A, rad = Vector3.new, CFrame.new, CFrame.Angles, math.rad
	local METAL, LEATHER, FABRIC = Enum.Material.Metal, Enum.Material.Leather, Enum.Material.Fabric
	local function mesh(p, kind) local sm = Instance.new("SpecialMesh"); sm.MeshType = kind; sm.Parent = p; return p end
	local function ecyl(m, a, name, w, h, d, cf, color, mat) -- elliptical band along the anchor's Y axis
		return mesh(piece(m, a, name, V(h, w, d), cf * A(0, 0, rad(90)), color, mat), Enum.MeshType.Cylinder)
	end
	local function tube(m, a, name, pts, r0, r1, color, mat) -- smooth tapered tube through points
		for i = 1, #pts - 1 do
			local p0, p1 = pts[i], pts[i + 1]
			local r = r0 + (r1 - r0) * (i - 1) / math.max(1, #pts - 2)
			round(m, a, name, V(r * 2, (p1 - p0).Magnitude + r * 1.4, r * 2), CFrame.lookAt((p0 + p1) / 2, p1) * A(-math.pi / 2, 0, 0), color, mat)
		end
	end

	local look = ({
		Common = { helmet = "Full", hair = C(18, 18, 20), horn = 1 },
		Rare = { helmet = nil, hair = C(18, 18, 20), scarf = true },
		Epic = { helmet = "Full", hair = C(18, 18, 20), horn = 0.62 },
		Legendary = { helmet = "Broken", hair = C(225, 190, 120), horn = 0.9, hood = false },
		Mythic = { helmet = "Full", hair = C(18, 18, 20), horn = 1, suit = true },
		Secret = { helmet = "Full", hair = C(18, 18, 20), horn = 1.35, robe = true },
	})[rarity] or {}
	local GREEN, ACC = s.Primary, s.Secondary -- coat/cape color, metal/accent color
	local LEATHERC = look.robe and C(20, 60, 35) or C(24, 24, 28)
	local metalMat = METAL

	local function head(m)
		local hd = find(m, "Head"); if not hd then return end
		local sz = hd.Size
		local hx, hy, hz = sz.X, sz.Y, sz.Z
		-- hair: slicked back, falling to the collar
		round(m, hd, "Hair", V(hx * 1.06, hy * 0.6, hz * 1.08), CF(0, hy * 0.3, hz * 0.06), look.hair)
		round(m, hd, "HairBack", V(hx * 0.98, hy * (look.helmet == nil and 1.25 or 1.0), hz * 0.42), CF(0, -hy * 0.22, hz * 0.36), look.hair)
		for _, x in { -1, 1 } do round(m, hd, "HairLock", V(hx * 0.2, hy * 0.75, hz * 0.32), CF(x * hx * 0.42, -hy * 0.12, hz * 0.18), look.hair) end
		if look.helmet == "Full" then
			round(m, hd, "HelmCap", V(hx * 1.12, hy * 0.7, hz * 1.12), CF(0, hy * 0.31, 0.02), ACC, metalMat)
			round(m, hd, "HelmBack", V(hx * 1.08, hy * 0.85, hz * 0.62), CF(0, hy * 0.08, hz * 0.24), ACC, metalMat)
			for _, x in { -1, 1 } do -- cheek guards sweeping forward along the cheekbones
				round(m, hd, "CheekGuard", V(hx * 0.16, hy * 0.62, hz * 0.62), CF(x * hx * 0.5, -hy * 0.04, -hz * 0.08) * A(rad(-8), 0, rad(x * 6)), ACC, metalMat)
			end
			piece(m, hd, "BrowPoint", V(hx * 0.2, hx * 0.2, 0.06), CF(0, hy * 0.26, -hz * 0.55) * A(0, 0, rad(45)), ACC, metalMat)
		elseif look.helmet == "Broken" then -- Sylvie's crown: thin gold band, one full horn, one snapped
			ecyl(m, hd, "Crown", hx * 1.08, hy * 0.12, hz * 1.1, CF(0, hy * 0.3, 0), ACC, metalMat)
			piece(m, hd, "BrowPoint", V(hx * 0.14, hx * 0.14, 0.05), CF(0, hy * 0.27, -hz * 0.56) * A(0, 0, rad(45)), ACC, metalMat)
		end
		if look.helmet then
			local k = look.horn or 1
			for _, x in { -1, 1 } do
				local pts = {}
				local n = (look.helmet == "Broken" and x < 0) and 3 or 7
				for i = 0, n - 1 do -- forward-up out of the temples, then a long sweep back
					local t = i / 6
					table.insert(pts, V(x * hx * (0.3 + 0.18 * t), hy * (0.36 + k * (1.25 * t - 0.05 * t * t)), hz * (-0.3 - 0.35 * math.sin(t * 2.2) * k + 0.95 * t * t * k)))
				end
				tube(m, hd, "Horn", pts, hx * 0.1 * math.min(1, k + 0.15), hx * 0.035, ACC, metalMat)
			end
		end
		if look.helmet == nil then -- Agent of Asgard: a small gold circlet
			piece(m, hd, "Circlet", V(hx * 0.12, hx * 0.12, 0.05), CF(0, hy * 0.3, -hz * 0.56) * A(0, 0, rad(45)), C(215, 170, 50), metalMat)
		end
	end

	local function body(m)
		local t, w = find(m, "UpperTorso"), find(m, "LowerTorso")
		if not t then return end
		local s = t.Size
		local fz = -s.Z / 2
		if look.suit then -- President Loki: black suit jacket over white shirt + green tie
			piece(m, t, "Shirt", V(s.X * 0.22, s.Y * 0.62, 0.05), CF(0, s.Y * 0.18, fz - 0.02), C(240, 240, 240))
			piece(m, t, "Tie", V(s.X * 0.07, s.Y * 0.55, 0.05), CF(0, s.Y * 0.16, fz - 0.05), C(30, 130, 60))
			for _, x in { -1, 1 } do
				piece(m, t, "Lapel", V(s.X * 0.12, s.Y * 0.5, 0.05), CF(x * s.X * 0.12, s.Y * 0.22, fz - 0.04) * A(0, 0, rad(x * 18)), C(14, 14, 16))
			end
			piece(m, t, "Pin", V(s.X * 0.07, s.X * 0.07, 0.04), CF(-s.X * 0.22, s.Y * 0.22, fz - 0.03), C(215, 170, 50), metalMat)
		else
			-- green tunic panel down the front, framed by gold trim
			piece(m, t, "Tunic", V(s.X * 0.36, s.Y * 0.92, 0.06), CF(0, -s.Y * 0.04, fz - 0.01), GREEN, LEATHER)
			for _, x in { -1, 1 } do
				piece(m, t, "Trim", V(s.X * 0.04, s.Y * 0.9, 0.06), CF(x * s.X * 0.19, -s.Y * 0.04, fz - 0.02), ACC, metalMat)
				piece(m, t, "Strap", V(s.X * 0.06, s.Y * 0.55, 0.05), CF(x * s.X * 0.3, -s.Y * 0.12, fz + 0.02), C(50, 50, 56), LEATHER)
			end
		end
		-- gorget: layered gold collar around the neck
		round(m, t, "Gorget", V(s.X * 0.62, s.Y * 0.22, s.Z * 1.06), CF(0, s.Y * 0.47, 0), ACC, metalMat)
		round(m, t, "GorgetLow", V(s.X * 0.72, s.Y * 0.16, s.Z * 1.08), CF(0, s.Y * 0.38, 0.01), LEATHERC, LEATHER)
		-- shoulder plates (gold over dark)
		for _, n in { "LeftUpperArm", "RightUpperArm" } do
			local a = m:FindFirstChild(n)
			if a then
				local as = a.Size; local x = n:find("Left") and -1 or 1
				round(m, a, "Pauldron", V(as.X * 1.55, as.Y * 0.55, as.Z * 1.45), CF(x * as.X * 0.06, as.Y * 0.4, 0) * A(0, 0, rad(-x * 14)), ACC, metalMat)
				round(m, a, "PauldronLow", V(as.X * 1.4, as.Y * 0.4, as.Z * 1.32), CF(x * as.X * 0.1, as.Y * 0.18, 0) * A(0, 0, rad(-x * 14)), look.suit and C(14, 14, 16) or GREEN, LEATHER)
			end
		end
		-- gold vambraces + boot tops
		for _, n in { "LeftLowerArm", "RightLowerArm" } do
			local a = m:FindFirstChild(n)
			if a and not look.suit then ecyl(m, a, "Vambrace", a.Size.X * 1.08, a.Size.Y * 0.5, a.Size.Z * 1.08, CF(0, -a.Size.Y * 0.18, 0), ACC, metalMat) end
		end
		for _, n in { "LeftLowerLeg", "RightLowerLeg" } do
			local a = m:FindFirstChild(n)
			if a then ecyl(m, a, "BootTop", a.Size.X * 1.12, a.Size.Y * 0.12, a.Size.Z * 1.12, CF(0, a.Size.Y * 0.4, 0), look.suit and C(14, 14, 16) or ACC, metalMat) end
		end
		if w then
			local ws = w.Size
			ecyl(m, w, "Belt", ws.X * 0.98, ws.Y * 0.6, ws.Z * 1.02, CF(0, ws.Y * 0.2, 0), look.suit and C(14, 14, 16) or C(40, 40, 46), LEATHER)
			if not look.suit then piece(m, w, "Buckle", V(ws.X * 0.16, ws.Y * 0.55, 0.06), CF(0, ws.Y * 0.2, -ws.Z * 0.52), ACC, metalMat) end
			-- long coat tails: open at the front, to below the knee
			local leg = m:FindFirstChild("LeftUpperLeg")
			local L = leg and leg.Size.Y * (look.robe and 2.2 or 1.75) or 1.7
			local coat = look.suit and C(14, 14, 16) or LEATHERC
			piece(m, w, "CoatBack", V(ws.X * 0.9, L, 0.08), CF(0, -L / 2, ws.Z * 0.52) * A(rad(-7), 0, 0), coat, LEATHER)
			for _, x in { -1, 1 } do
				piece(m, w, "CoatSide", V(0.08, L * 0.96, ws.Z * 0.9), CF(x * ws.X * 0.5, -L * 0.48, 0) * A(0, 0, rad(x * 6)), coat, LEATHER)
				local f = piece(m, w, "CoatFront", V(ws.X * 0.3, L * 0.92, 0.08), CF(x * ws.X * 0.34, -L * 0.46, -ws.Z * 0.52) * A(rad(6), 0, rad(x * 5)), coat, LEATHER)
				if not look.suit then piece(m, f, "CoatPanel", V(ws.X * 0.14, L * 0.86, 0.04), CF(-x * ws.X * 0.06, 0, -0.05), GREEN, LEATHER) end
			end
		end
		-- long cape hanging from under the gorget, curved by two angled side panels
		local L = s.Y * (look.robe and 2.75 or 2.55)
		local capeC = look.suit and C(20, 90, 45) or GREEN
		piece(m, t, "Cape", V(s.X * 0.82, L, 0.1), CF(0, s.Y * 0.42 - L / 2, s.Z / 2 + 0.12) * A(rad(-5), 0, 0), capeC, FABRIC)
		for _, x in { -1, 1 } do
			piece(m, t, "CapeSide", V(s.X * 0.26, L * 0.98, 0.1), CF(x * s.X * 0.5, s.Y * 0.42 - L * 0.49, s.Z / 2 + 0.02) * A(rad(-5), rad(x * 35), 0), capeC, FABRIC)
		end
		if look.scarf then -- Agent of Asgard's long green scarf
			round(m, t, "Scarf", V(s.X * 0.6, s.Y * 0.24, s.Z * 1.1), CF(0, s.Y * 0.5, 0), C(30, 120, 60), FABRIC)
			piece(m, t, "ScarfTail", V(s.X * 0.13, s.Y * 0.95, 0.06), CF(s.X * 0.14, -s.Y * 0.05, fz - 0.08) * A(0, 0, rad(4)), C(30, 120, 60), FABRIC)
			piece(m, t, "ScarfTail", V(s.X * 0.13, s.Y * 0.75, 0.06), CF(s.X * 0.02, s.Y * 0.03, fz - 0.06) * A(0, 0, rad(-6)), C(25, 105, 52), FABRIC)
		end
	end

	local colors = { Head = C(236, 206, 182), Chest = LEATHERC, Waist = LEATHERC, UpperArms = LEATHERC, LowerArms = LEATHERC, Hands = C(20, 20, 22),
		Legs = C(30, 34, 32), Feet = C(18, 18, 20), LowerLegs = C(18, 18, 20) }
	if look.suit then colors.Chest, colors.UpperArms, colors.LowerArms, colors.Legs = C(14, 14, 16), C(14, 14, 16), C(14, 14, 16), C(14, 14, 16) end
	if look.robe then colors.UpperArms, colors.LowerArms = GREEN, GREEN end
	if rarity == "Legendary" then colors.UpperArms = GREEN end
	return { colors = colors,
		pieces = { { "Material", LEATHER }, { "Face", C(60, 140, 90), look.hair, "smirk", C(150, 95, 90) }, head, body } }
end
