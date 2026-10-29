-- Harley Quinn. Classic (BTAS): red/black harlequin bodysuit split down the middle with arms/legs in the opposite color,
-- jester cowl with two floppy horns ending in white pom-poms, chalk-white face, black domino mask, white neck ruff + wrist ruffles.
-- Variant flags (SkinData/HarleyQuinn): Style = "squad" | "bop" | "rebirth" | "doctor" (nil = jester bodysuit), Top, Tips = { right, left },
-- Legs, Boots, Crown.
-- Costume module: return function(s, H, rarity) -> { colors = { group = Color3 }, pieces = { ... } }
return function(s, H, rarity)
	local C, WHITE, SKIN = H.C, H.WHITE, H.SKIN
	local piece, round, band, find, chestOf, waistOf, front, glyph = H.piece, H.round, H.band, H.find, H.chestOf, H.waistOf, H.front, H.glyph
	local V, CF, rad = Vector3.new, CFrame.new, math.rad
	local function each(m, names, fn) for _, n in names do local a = m:FindFirstChild(n); if a then fn(a, n:find("Left") and -1 or 1) end end end
	-- two congruent ellipsoids offset along X meet exactly on a vertical plane: a clean two-tone split on a rounded shape
	local function split(m, anchor, name, size, cf, cR, cL, mat)
		local d = 0.025
		round(m, anchor, name .. "L", size, cf * CF(-d, 0, 0), cL, mat)
		round(m, anchor, name .. "R", size, cf * CF(d, 0, 0), cR, mat)
	end
	local cR, cL = s.Primary, s.Secondary -- her right / her left
	local style = s.Style
	local blonde = C(250, 225, 140)
	local faceSkin = style and SKIN or C(248, 246, 242)
	local dark = C(20, 20, 25)

	local function face(m, opts) -- eyes, brows, nose, red lips; optional domino mask / eye makeup / glasses
		local hd = find(m, "Head"); if not hd then return end
		local sz = hd.Size
		local fz = -sz.Z * 0.5
		for _, x in { -1, 1 } do
			local ex = x * sz.X * 0.19
			if opts.domino then
				round(m, hd, "Domino", V(sz.X * 0.32, sz.Y * 0.2, 0.07), CF(ex, sz.Y * 0.07, fz + 0.005) * CFrame.Angles(0, 0, rad(x * -14)), dark)
			elseif opts.shadow then
				round(m, hd, "EyeShadow", V(sz.X * 0.26, sz.Y * 0.15, 0.06), CF(ex, sz.Y * 0.1, fz + 0.01), x > 0 and opts.shadow[1] or opts.shadow[2])
			end
			round(m, hd, "Sclera", V(sz.X * 0.16, sz.Y * 0.1, 0.05), CF(ex, sz.Y * 0.07, fz - 0.02), C(252, 252, 250))
			round(m, hd, "Iris", V(sz.X * 0.08, sz.Y * 0.09, 0.04), CF(ex - x * sz.X * 0.01, sz.Y * 0.065, fz - 0.04), C(60, 120, 220))
			piece(m, hd, "Lash", V(sz.X * 0.19, sz.Y * 0.03, 0.04), CF(ex + x * sz.X * 0.01, sz.Y * 0.12, fz - 0.04) * CFrame.Angles(0, 0, rad(x * -12)), dark)
			if not opts.domino then piece(m, hd, "Brow", V(sz.X * 0.17, sz.Y * 0.03, 0.04), CF(ex, sz.Y * 0.21, fz - 0.01) * CFrame.Angles(0, 0, rad(x * -8)), opts.brow or C(150, 120, 70)) end
			if opts.glasses then
				round(m, hd, "Lens", V(sz.X * 0.27, sz.Y * 0.18, 0.04), CF(ex, sz.Y * 0.07, fz - 0.06), C(30, 30, 35))
				local l = round(m, hd, "LensGlass", V(sz.X * 0.22, sz.Y * 0.13, 0.04), CF(ex, sz.Y * 0.07, fz - 0.075), C(200, 220, 235)); l.Transparency = 0.55
			end
		end
		if opts.domino then piece(m, hd, "DominoBridge", V(sz.X * 0.14, sz.Y * 0.06, 0.05), CF(0, sz.Y * 0.1, fz - 0.01), dark) end
		if opts.glasses then piece(m, hd, "GlassBridge", V(sz.X * 0.12, 0.04, 0.03), CF(0, sz.Y * 0.09, fz - 0.07), C(30, 30, 35)) end
		round(m, hd, "Nose", V(sz.X * 0.09, sz.Y * 0.1, 0.08), CF(0, -sz.Y * 0.08, fz - 0.03), faceSkin:Lerp(C(0, 0, 0), 0.06))
		round(m, hd, "Lips", V(sz.X * 0.26, sz.Y * 0.08, 0.06), CF(0, -sz.Y * 0.27, fz - 0.005), C(200, 25, 40))
		for _, x in { -1, 1 } do round(m, hd, "Smile", V(sz.X * 0.08, sz.Y * 0.04, 0.05), CF(x * sz.X * 0.15, -sz.Y * 0.24, fz) * CFrame.Angles(0, 0, rad(x * 35)), C(200, 25, 40)) end
	end

	local function pigtails(m, tips, bun)
		local hd = find(m, "Head"); if not hd then return end
		local sz = hd.Size
		round(m, hd, "Hair", V(sz.X * 1.1, sz.Y * 0.64, sz.Z * 1.12), CF(0, sz.Y * 0.3, sz.Z * 0.06), blonde)
		round(m, hd, "Bangs", V(sz.X * 0.75, sz.Y * 0.28, sz.Z * 0.4), CF(sz.X * 0.12, sz.Y * 0.36, -sz.Z * 0.36) * CFrame.Angles(0, 0, rad(-12)), blonde)
		round(m, hd, "HairBack", V(sz.X * 1.0, sz.Y * 0.75, sz.Z * 0.45), CF(0, sz.Y * 0.05, sz.Z * 0.33), blonde)
		if bun then
			round(m, hd, "Bun", V(sz.X * 0.42, sz.Y * 0.38, sz.Z * 0.38), CF(0, sz.Y * 0.35, sz.Z * 0.55), blonde)
			return
		end
		for _, x in { -1, 1 } do
			local tip = x > 0 and tips[1] or tips[2]
			round(m, hd, "Tie", V(sz.X * 0.16, sz.Y * 0.16, sz.Z * 0.16), CF(x * sz.X * 0.5, sz.Y * 0.32, sz.Z * 0.18), tip)
			local base = CF(x * sz.X * 0.62, sz.Y * 0.32, sz.Z * 0.2) * CFrame.Angles(0, 0, rad(x * 20))
			round(m, hd, "Pigtail", V(sz.X * 0.3, sz.Y * 0.75, sz.Z * 0.3), base * CF(0, -sz.Y * 0.32, 0), blonde)
			round(m, hd, "PigtailTip", V(sz.X * 0.26, sz.Y * 0.45, sz.Z * 0.26), base * CF(0, -sz.Y * 0.72, 0), tip)
		end
	end

	-- open top: torso is the jacket color, the shirt shows as a front panel between the lapels
	local function jacket(m, top, trim)
		local t = chestOf(m); if not t then return end
		local sz = t.Size
		round(m, t, "Top", V(sz.X * 0.62, sz.Y * 0.9, sz.Z * 1.0), CF(0, sz.Y * 0.04, -sz.Z * 0.07), top, Enum.Material.Fabric)
		for _, x in { -1, 1 } do
			piece(m, t, "JacketEdge", V(sz.X * 0.07, sz.Y * 0.9, 0.06), CF(x * sz.X * 0.25, 0, front(t, 0.0)) * CFrame.Angles(0, 0, rad(x * 6)), trim or t.Color, Enum.Material.Fabric)
			round(m, t, "JacketCollar", V(sz.X * 0.3, sz.Y * 0.2, sz.Z * 0.6), CF(x * sz.X * 0.2, sz.Y * 0.48, sz.Z * 0.1) * CFrame.Angles(0, 0, rad(x * -20)), trim or t.Color, Enum.Material.Fabric)
		end
	end
	local function fishnet(m, color)
		each(m, { "LeftUpperLeg", "RightUpperLeg", "LeftLowerLeg", "RightLowerLeg" }, function(a)
			for k = -1, 1 do
				piece(m, a, "Net", V(a.Size.X * 1.0, 0.03, 0.03), CF(0, k * a.Size.Y * 0.28, -a.Size.Z * 0.47) * CFrame.Angles(0, 0, rad(30)), color)
			end
		end)
	end
	local function boots(m, color, top)
		each(m, { "LeftLowerLeg", "RightLowerLeg" }, function(a)
			band(m, a, "BootTop", a.Size.X * 1.08, 0.14, CF(0, a.Size.Y * (top or 0.15), 0), color)
		end)
	end

	local pieces
	if not style then -- ===== jester bodysuit =====
		pieces = {
			function(m) -- quartered harlequin colors (torso split, limbs opposite), drawn with congruent split ellipsoids
				for _, n in { "UpperTorso", "LowerTorso" } do local p = m:FindFirstChild(n); if p then p.Color = cL end end
				for _, n in { "RightUpperArm", "RightLowerArm", "RightUpperLeg", "RightLowerLeg", "RightFoot", "LeftHand" } do local p = m:FindFirstChild(n); if p then p.Color = cL end end
				for _, n in { "LeftUpperArm", "LeftLowerArm", "LeftUpperLeg", "LeftLowerLeg", "LeftFoot", "RightHand" } do local p = m:FindFirstChild(n); if p then p.Color = cR end end
				local t = chestOf(m)
				if t then -- right half of the sculpted chest (same forms Body.Sculpt makes for the Female build)
					local sz = t.Size
					round(m, t, "HalfChest", V(sz.X * 0.98, sz.Y * 0.95, sz.Z * 1.0), CF(0.05, sz.Y * 0.1, 0), cR)
					round(m, t, "HalfAbs", V(sz.X * 0.68 / 0.92 * 0.98, sz.Y * 0.75, sz.Z * 0.92), CF(0.05, -sz.Y * 0.2, 0), cR)
					round(m, t, "HalfBust", V(sz.X * 0.33, sz.Y * 0.27, sz.Z * 0.52), CF(sz.X * 0.16, sz.Y * 0.12, -sz.Z * 0.24), cR)
					round(m, t, "HalfTrap", V(sz.X * 0.33, sz.Y * 0.27, sz.Z * 0.62), CF(sz.X * 0.17, sz.Y * 0.45, sz.Z * 0.04), cR)
					-- white neck ruff
					for i = 0, 6 do
						local a = i / 7 * math.pi * 2
						round(m, t, "Ruff", V(0.32, 0.2, 0.32), CF(math.sin(a) * sz.X * 0.17, sz.Y * 0.5, -math.cos(a) * sz.Z * 0.3) * CFrame.Angles(0, -a, rad(15)), WHITE, Enum.Material.Fabric)
					end
				end
				local w = waistOf(m)
				if w and w ~= t then
					local l = w.Size
					round(m, w, "HalfPelvis", V(l.X * 1.04, l.Y * 2.2, l.Z * 0.98), CF(0.05, -l.Y * 0.05, 0), cR)
					round(m, w, "HalfGlute", V(l.X * 0.44, l.Y * 1.65, l.Z * 0.52), CF(l.X * 0.2, -l.Y * 0.35, l.Z * 0.22), cR)
					for _, x in { -1, 1 } do -- diamonds on the hips in the opposite color
						piece(m, w, "Diamond", V(0.24, 0.24, 0.04), CF(x * l.X * 0.26, -l.Y * 0.1, -l.Z * 0.5 - 0.02) * CFrame.Angles(0, rad(x * 20), rad(45)), x > 0 and cL or cR)
					end
				end
				each(m, { "LeftLowerArm", "RightLowerArm" }, function(a) -- wrist ruffles
					round(m, a, "Ruffle", V(a.Size.X * 1.4, a.Size.Y * 0.28, a.Size.Z * 1.4), CF(0, -a.Size.Y * 0.44, 0), WHITE, Enum.Material.Fabric)
				end)
			end,
			function(m) -- jester cowl: two-tone hood framing the face, floppy horns with pom-poms
				local hd = find(m, "Head"); if not hd then return end
				local sz = hd.Size
				split(m, hd, "Cap", V(sz.X * 1.14, sz.Y * 0.74, sz.Z * 1.14), CF(0, sz.Y * 0.3, sz.Z * 0.03), cR, cL, Enum.Material.Fabric)
				split(m, hd, "HoodBack", V(sz.X * 1.06, sz.Y * 1.05, sz.Z * 0.6), CF(0, -sz.Y * 0.02, sz.Z * 0.3), cR, cL, Enum.Material.Fabric)
				split(m, hd, "ChinWrap", V(sz.X * 0.92, sz.Y * 0.32, sz.Z * 0.8), CF(0, -sz.Y * 0.52, sz.Z * 0.05), cR, cL, Enum.Material.Fabric)
				for _, x in { -1, 1 } do
					local c = x > 0 and cR or cL
					round(m, hd, "HoodSide", V(sz.X * 0.26, sz.Y * 1.0, sz.Z * 0.9), CF(x * sz.X * 0.46, -sz.Y * 0.04, sz.Z * 0.06), c, Enum.Material.Fabric)
					-- horn: tapering segments arching out and drooping, pom-pom at the tip
					local pts = { { 0.32, 0.62, 0.36 }, { 0.62, 0.86, 0.3 }, { 0.92, 0.86, 0.25 }, { 1.12, 0.62, 0.2 } }
					for i, q in pts do
						round(m, hd, "Horn", V(sz.X * q[3], sz.Y * 0.42, sz.X * q[3]), CF(x * sz.X * q[1], sz.Y * q[2], sz.Z * 0.05) * CFrame.Angles(0, 0, rad(x * (-55 + i * 30))), c, Enum.Material.Fabric)
					end
					round(m, hd, "Pom", V(0.3, 0.3, 0.3), CF(x * sz.X * 1.2, sz.Y * 0.36, sz.Z * 0.05), WHITE, Enum.Material.Fabric)
				end
			end,
			function(m) face(m, { domino = true }) end,
		}
		if s.Crown then
			table.insert(pieces, function(m)
				local hd = find(m, "Head"); if not hd then return end
				local sz = hd.Size
				band(m, hd, "Crown", sz.X * 0.62, sz.Y * 0.16, CF(0, sz.Y * 0.68, sz.Z * 0.02), s.Crown, Enum.Material.Metal)
				for i = -2, 2 do
					round(m, hd, "CrownPoint", V(0.1, sz.Y * 0.26, 0.1), CF(i * sz.X * 0.12, sz.Y * 0.8, -sz.Z * 0.26 + math.abs(i) * sz.Z * 0.05), s.Crown, Enum.Material.Metal)
				end
				round(m, hd, "CrownGem", V(0.14, 0.14, 0.08), CF(0, sz.Y * 0.68, -sz.Z * 0.32), C(200, 20, 50))
				local t = chestOf(m)
				if t then -- short regal cape
					local tz = t.Size
					local L = tz.Y * 2.0
					for i = -2, 2 do -- curved drape with a gold hem, alternating colors like the suit
						local a = rad(i * 22)
						local c = piece(m, t, "Cape", V(tz.X * 0.27, L, 0.07), CF(math.sin(a) * tz.X * 0.6, tz.Y * 0.45 - L / 2, math.cos(a) * tz.Z * 0.64) * CFrame.Angles(0, a, 0) * CFrame.Angles(rad(7), 0, 0), i % 2 == 0 and cR or cL:Lerp(cR, 0.4), Enum.Material.Fabric)
						piece(m, c, "CapeTrim", V(tz.X * 0.27, 0.12, 0.09), CF(0, -L / 2 + 0.06, 0), s.Crown, Enum.Material.Metal)
					end
				end
			end)
		end
		return { colors = { Head = faceSkin }, pieces = pieces }
	end

	-- ===== street / civilian looks =====
	local top = s.Top or WHITE
	local legs = s.Legs or C(200, 160, 140)
	local bootsC = s.Boots or dark
	if style == "doctor" then -- Dr. Harleen Quinzel: lab coat, black blouse + pencil skirt, bun, glasses
		pieces = {
			function(m) face(m, { glasses = true }) end,
			function(m) pigtails(m, nil, true) end,
			function(m) jacket(m, s.Secondary, WHITE) end,
			function(m) -- lab coat skirt to the knees, pocket, ID badge
				local w = waistOf(m); if not w then return end
				local l = w.Size
				for _, x in { -1, 1 } do
					piece(m, w, "CoatBack", V(l.X * 0.52, 1.5, 0.07), CF(x * l.X * 0.25, -0.6, l.Z * 0.56) * CFrame.Angles(rad(6), 0, 0), WHITE, Enum.Material.Fabric)
					piece(m, w, "CoatSide", V(0.07, 1.45, l.Z * 0.95), CF(x * l.X * 0.54, -0.58, 0.04) * CFrame.Angles(0, 0, rad(x * 6)), WHITE, Enum.Material.Fabric)
					piece(m, w, "CoatFront", V(l.X * 0.24, 1.45, 0.07), CF(x * l.X * 0.4, -0.58, -l.Z * 0.56) * CFrame.Angles(rad(-5), 0, rad(x * 4)), WHITE, Enum.Material.Fabric)
				end
				local t = chestOf(m)
				if t then
					local b = piece(m, t, "Badge", V(0.24, 0.32, 0.04), CF(-t.Size.X * 0.3, t.Size.Y * 0.12, front(t, 0.06)), C(235, 240, 250))
					glyph(b, Enum.NormalId.Front, "Dr.", C(40, 60, 120))
				end
			end,
		}
		return { colors = { Head = SKIN, Chest = WHITE, Waist = s.Secondary, Arms = WHITE, Hands = SKIN, UpperLegs = s.Secondary, LowerLegs = C(215, 180, 150), Feet = dark }, pieces = pieces }
	end
	local tips = s.Tips or { C(230, 60, 140), C(60, 110, 220) }
	pieces = {
		function(m) face(m, { shadow = tips }) end,
		function(m) pigtails(m, tips) end,
		function(m)
			jacket(m, top, s.Trim)
			if style == "squad" then -- two-tone satin bomber: right half red, left half blue; striped cuffs + waistband
				local t = chestOf(m)
				if t then local sz = t.Size; round(m, t, "HalfChest", V(sz.X * 0.98, sz.Y * 0.95, sz.Z * 1.0), CF(0.05, sz.Y * 0.1, 0), cR) end
				each(m, { "LeftLowerArm", "RightLowerArm" }, function(a) band(m, a, "Cuff", a.Size.X * 1.1, a.Size.Y * 0.18, CF(0, -a.Size.Y * 0.4, 0), WHITE, Enum.Material.Fabric) end)
				if t then local g = piece(m, t, "TeeText", V(t.Size.X * 0.3, t.Size.Y * 0.2, 0.03), CF(0, t.Size.Y * 0.05, front(t, 0.03)), top); g.Transparency = 1; glyph(g, Enum.NormalId.Front, "Daddy's Lil Monster", C(200, 30, 50), Enum.Font.Arcade) end
			elseif style == "bop" then -- caution-tape jacket: black stripes + fringe on the sleeves
				each(m, { "LeftUpperArm", "RightUpperArm" }, function(a)
					for k = -1, 1, 2 do band(m, a, "Stripe", a.Size.X * 1.1, 0.08, CF(0, k * a.Size.Y * 0.2, 0), dark, Enum.Material.Fabric) end
				end)
				each(m, { "LeftLowerArm", "RightLowerArm" }, function(a, x)
					for k = 0, 2 do piece(m, a, "Fringe", V(0.05, a.Size.Y * 0.5, 0.05), CF(x * a.Size.X * 0.52, -a.Size.Y * (0.15 + k * 0.1), (k - 1) * 0.12), s.Primary:Lerp(C(255, 255, 255), 0.3)) end
				end)
			elseif style == "rebirth" then -- red corset lacing + red trims on the black jacket
				local t = chestOf(m)
				if t then for k = 0, 3 do piece(m, t, "Lace", V(t.Size.X * 0.14, 0.03, 0.03), CF(0, -t.Size.Y * (0.25 - k * 0.12), front(t, 0.04)) * CFrame.Angles(0, 0, rad(k % 2 == 0 and 25 or -25)), dark) end end
				each(m, { "LeftLowerArm", "RightLowerArm" }, function(a) band(m, a, "Cuff", a.Size.X * 1.1, a.Size.Y * 0.16, CF(0, -a.Size.Y * 0.4, 0), s.Secondary, Enum.Material.Fabric) end)
			end
		end,
		function(m)
			fishnet(m, C(30, 30, 35))
			boots(m, bootsC, style == "bop" and -0.1 or 0.25)
			local w = waistOf(m)
			if w then band(m, w, "Waistband", w.Size.X * 0.98, 0.12, CF(0, w.Size.Y * 0.3, 0), s.Belt or dark) end
		end,
	}
	local shorts = s.Shorts or cL
	local arms = s.Sleeves or s.Primary
	local colors = { Head = SKIN, Chest = s.Jacket or (style == "squad" and cL or s.Primary), Waist = shorts, Arms = arms, Hands = SKIN, UpperLegs = legs, LowerLegs = bootsC, Feet = bootsC }
	if style == "squad" then colors.LowerArms = nil end
	local out = { colors = colors, pieces = pieces }
	if style == "squad" then
		table.insert(pieces, 1, function(m) -- sleeves split by side
			for _, n in { "RightUpperArm", "RightLowerArm" } do local p = m:FindFirstChild(n); if p then p.Color = cR end end
			for _, n in { "LeftUpperArm", "LeftLowerArm" } do local p = m:FindFirstChild(n); if p then p.Color = cL end end
		end)
	end
	return out
end
