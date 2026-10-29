-- Thanos (Starlin classic): purple skin, huge ridged chin, gold helmet hood with face opening and ridged crest,
-- blue bodysuit, gold suspender straps into a wide gold belt, gold gloves and knee boots.
-- Variants: Armored (MCU battle armor: plated chest, pauldrons), Infinity War (bald, sleeveless gray-blue armor, bare arms),
-- Endgame (dark battle armor + horned crest helmet), Infinity Thanos (gold + violet), Cosmic Ghost (dark suit, violet hellfire trim).
-- Costume module: return function(s, H, rarity) -> { colors = { group = Color3 }, pieces = { { "Piece", args... } | function(m) end } }
return function(s, H, rarity)
	local C = H.C
	local piece, round, find = H.piece, H.round, H.find
	local V, CF, A, rad = Vector3.new, CFrame.new, CFrame.Angles, math.rad
	local METAL = Enum.Material.Metal
	local function mesh(p, kind) local sm = Instance.new("SpecialMesh"); sm.MeshType = kind; sm.Parent = p; return p end
	local function ecyl(m, a, name, w, h, d, cf, color, mat)
		return mesh(piece(m, a, name, V(h, w, d), cf * A(0, 0, rad(90)), color, mat), Enum.MeshType.Cylinder)
	end
	local SKINP = C(132, 98, 164)
	local SKIND = C(100, 70, 130)
	local SUIT, GOLDC = s.Primary, s.Secondary
	local look = ({
		Common = { helmet = "Classic" },
		Rare = { helmet = "Classic", armor = true },
		Epic = { helmet = nil, armor = true, bareArms = true },
		Legendary = { helmet = "Crest", armor = true },
		Mythic = { helmet = "Classic" },
		Secret = { helmet = "Classic", armor = true },
	})[rarity] or { helmet = "Classic" }

	local function head(m)
		local hd = find(m, "Head"); if not hd then return end
		local s3 = hd.Size
		local hx, hy, hz = s3.X, s3.Y, s3.Z
		-- massive square jaw + chin ridges
		round(m, hd, "Jaw", V(hx * 1.04, hy * 0.62, hz * 0.95), CF(0, -hy * 0.3, 0), SKINP)
		for i = -2, 2 do
			round(m, hd, "ChinRidge", V(hx * 0.05, hy * 0.24, hz * 0.07), CF(i * hx * 0.09, -hy * 0.44, -hz * 0.47 + math.abs(i) * 0.02), SKIND)
		end
		piece(m, hd, "Brow", V(hx * 0.7, hy * 0.08, hz * 0.12), CF(0, hy * 0.2, -hz * 0.47), SKIND)
		if look.helmet then
			round(m, hd, "HelmCap", V(hx * 1.16, hy * 0.74, hz * 1.16), CF(0, hy * 0.33, 0.02), GOLDC, METAL)
			round(m, hd, "HelmHood", V(hx * 1.14, hy * 1.12, hz * 0.8), CF(0, -hy * 0.04, hz * 0.18), GOLDC, METAL)
			for _, x in { -1, 1 } do
				round(m, hd, "HelmCheek", V(hx * 0.2, hy * 0.86, hz * 0.62), CF(x * hx * 0.5, -hy * 0.12, -hz * 0.1) * A(0, 0, rad(-x * 4)), GOLDC, METAL)
				round(m, hd, "HelmRidge", V(hx * 0.1, hy * 0.2, hz * 1.12), CF(x * hx * 0.2, hy * 0.62, 0.05), GOLDC:Lerp(C(0, 0, 0), 0.15), METAL)
			end
			round(m, hd, "HelmCrest", V(hx * 0.14, hy * 0.26, hz * 1.18), CF(0, hy * 0.66, 0.04), GOLDC:Lerp(C(0, 0, 0), 0.15), METAL)
			if look.helmet == "Crest" then -- Endgame helmet: swept horns off the temples
				for _, x in { -1, 1 } do
					round(m, hd, "HelmHorn", V(hx * 0.14, hy * 0.6, hx * 0.14), CF(x * hx * 0.56, hy * 0.42, 0.1) * A(rad(30), 0, rad(-x * 35)), GOLDC, METAL)
				end
			end
		end
	end

	local function body(m)
		local t, w = find(m, "UpperTorso"), find(m, "LowerTorso")
		if not t then return end
		local s3 = t.Size
		local fz = -s3.Z / 2
		local TRIM = GOLDC
		if look.armor then
			-- plated cuirass: rounded breastplate, ab plates, high collar, layered pauldrons
			round(m, t, "Breastplate", V(s3.X * 0.9, s3.Y * 0.55, s3.Z * 1.08), CF(0, s3.Y * 0.18, 0), SUIT, METAL)
			for i = 0, 2 do piece(m, t, "AbPlate", V(s3.X * (0.4 - i * 0.04), s3.Y * 0.11, 0.06), CF(0, -s3.Y * (0.12 + i * 0.13), fz - 0.02), SUIT:Lerp(C(0, 0, 0), 0.2), METAL) end
			piece(m, t, "ChestTrim", V(s3.X * 0.55, s3.Y * 0.05, 0.06), CF(0, s3.Y * 0.0, fz - 0.06), TRIM, METAL)
			round(m, t, "Collar", V(s3.X * 0.55, s3.Y * 0.24, s3.Z * 1.05), CF(0, s3.Y * 0.48, 0.02), TRIM, METAL)
			if not look.bareArms then
				for _, n in { "LeftUpperArm", "RightUpperArm" } do
					local a = m:FindFirstChild(n)
					if a then
						local as = a.Size; local x = n:find("Left") and -1 or 1
						round(m, a, "Pauldron", V(as.X * 1.5, as.Y * 0.6, as.Z * 1.4), CF(x * as.X * 0.06, as.Y * 0.4, 0) * A(0, 0, rad(-x * 15)), SUIT, METAL)
						round(m, a, "PauldronTrim", V(as.X * 1.4, as.Y * 0.4, as.Z * 1.3), CF(x * as.X * 0.12, as.Y * 0.18, 0) * A(0, 0, rad(-x * 15)), TRIM, METAL)
					end
				end
			else -- Infinity War: small armored shoulder caps over bare arms
				for _, n in { "LeftUpperArm", "RightUpperArm" } do
					local a = m:FindFirstChild(n)
					if a then local x = n:find("Left") and -1 or 1
						round(m, a, "ShoulderCap", V(a.Size.X * 1.25, a.Size.Y * 0.45, a.Size.Z * 1.2), CF(x * a.Size.X * 0.05, a.Size.Y * 0.38, 0), SUIT, METAL) end
				end
			end
		else
			-- classic gold suspender straps over the shoulders, down the chest and back into the belt
			for _, x in { -1, 1 } do
				piece(m, t, "Strap", V(s3.X * 0.13, s3.Y * 1.0, 0.07), CF(x * s3.X * 0.2, -s3.Y * 0.02, fz - 0.02) * A(0, 0, rad(-x * 4)), TRIM, METAL)
				piece(m, t, "StrapBack", V(s3.X * 0.13, s3.Y * 1.0, 0.07), CF(x * s3.X * 0.2, 0, s3.Z / 2 + 0.03), TRIM, METAL)
				round(m, t, "StrapTop", V(s3.X * 0.15, s3.Y * 0.12, s3.Z * 1.08), CF(x * s3.X * 0.21, s3.Y * 0.49, 0), TRIM, METAL)
			end
			piece(m, t, "ChestBar", V(s3.X * 0.5, s3.Y * 0.08, 0.07), CF(0, s3.Y * 0.2, fz - 0.03), TRIM, METAL)
		end
		if w then
			local ws = w.Size
			ecyl(m, w, "Belt", ws.X * 1.0, ws.Y * 1.0, ws.Z * 1.06, CF(0, ws.Y * 0.15, 0), TRIM, METAL)
			piece(m, w, "Buckle", V(ws.X * 0.26, ws.Y * 1.1, 0.08), CF(0, ws.Y * 0.15, -ws.Z * 0.55), TRIM:Lerp(C(255, 255, 255), 0.2), METAL)
			if look.armor then
				for _, x in { -1, 1 } do -- tasset plates over the hips
					piece(m, w, "Tasset", V(ws.X * 0.32, ws.Y * 1.6, 0.08), CF(x * ws.X * 0.26, -ws.Y * 0.8, -ws.Z * 0.5) * A(rad(8), 0, rad(x * 6)), SUIT, METAL)
				end
			end
		end
		-- gauntlet-style glove flare on the right (the left wears the Infinity Gauntlet) + boot tops
		local ra = m:FindFirstChild("RightLowerArm")
		if ra then ecyl(m, ra, "GloveFlare", ra.Size.X * 1.18, ra.Size.Y * 0.18, ra.Size.Z * 1.18, CF(0, -ra.Size.Y * 0.02, 0), TRIM, METAL) end
		for _, n in { "LeftLowerLeg", "RightLowerLeg" } do
			local a = m:FindFirstChild(n)
			if a then ecyl(m, a, "BootTop", a.Size.X * 1.18, a.Size.Y * 0.16, a.Size.Z * 1.18, CF(0, a.Size.Y * 0.42, 0), TRIM, METAL) end
		end
	end

	local colors = { Head = SKINP, Chest = SUIT, Waist = SUIT, Arms = SUIT, Legs = SUIT, Gloves = GOLDC, Boots = GOLDC }
	if look.bareArms then colors.Arms = SKINP; colors.Gloves = SKINP; colors.LowerArms = SKINP end
	if rarity == "Common" or rarity == "Mythic" then colors.LowerArms = GOLDC end
	return { colors = colors,
		pieces = { head, { "Face", C(70, 60, 110), SKIND, "angry", C(70, 40, 90) }, body } }
end
