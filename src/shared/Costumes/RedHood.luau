-- Red Hood (Jason Todd, Rebirth / Under the Red Hood): glossy red full helmet with sharp white lenses, brown leather jacket
-- worn open over dark body armor with a wide red bat, gray cargo pants, belt + thigh holsters, black gloves and boots.
-- Variant flags (SkinData/RedHood): Look = "robin" | "hood" | "knight" | "redx" | "stroke" (nil = helmet + jacket), Jacket, Helmet, Bat, Armor.
-- Costume module: return function(s, H, rarity) -> { colors = { group = Color3 }, pieces = { ... } }
return function(s, H, rarity)
	local C, WHITE, SKIN = H.C, H.WHITE, H.SKIN
	local piece, round, band, ring, find, chestOf, waistOf, front, glyph = H.piece, H.round, H.band, H.ring, H.find, H.chestOf, H.waistOf, H.front, H.glyph
	local V, CF, rad = Vector3.new, CFrame.new, math.rad
	local function wedge(p) Instance.new("SpecialMesh", p).MeshType = Enum.MeshType.Wedge; return p end
	local function each(m, names, fn) for _, n in names do local a = m:FindFirstChild(n); if a then fn(a, n:find("Left") and -1 or 1) end end end
	local look = s.Look
	local body = s.Primary
	local dark = C(25, 25, 28)
	local metal = Enum.Material.Metal

	-- bat emblem from parts: two triangular wings (flat top edge sloping down into the body), body oval, ears
	local function bat(m, t, y, span, color)
		local fz = -t.Size.Z * 0.6 - 0.03
		local d, h = span * 0.44, span * 0.3
		for _, x in { -1, 1 } do
			wedge(piece(m, t, "BatWing", V(0.05, h, d), CF(x * (span * 0.05 + d / 2), y + h * 0.1, fz) * CFrame.Angles(0, 0, rad(x * 8)) * CFrame.Angles(0, rad(x * 90), 0) * CFrame.Angles(rad(180), 0, 0), color))
			wedge(piece(m, t, "BatEar", V(0.05, span * 0.12, span * 0.05), CF(x * span * 0.035, y + h * 0.42, fz) * CFrame.Angles(0, rad(-x * 90), 0), color))
		end
		round(m, t, "BatBody", V(span * 0.14, h * 1.1, 0.07), CF(0, y, fz), color)
	end
	local function helmet(m, color, lens, opts)
		local hd = find(m, "Head"); if not hd then return end
		local sz = hd.Size
		round(m, hd, "Helmet", V(sz.X * 1.14, sz.Y * 1.16, sz.Z * 1.16), CF(0, sz.Y * 0.04, 0), color, Enum.Material.SmoothPlastic)
		round(m, hd, "HelmetJaw", V(sz.X * 0.8, sz.Y * 0.55, sz.Z * 0.6), CF(0, -sz.Y * 0.28, -sz.Z * 0.24), color)
		round(m, hd, "Brow", V(sz.X * 0.95, sz.Y * 0.22, sz.Z * 0.5), CF(0, sz.Y * 0.2, -sz.Z * 0.32), color:Lerp(C(0, 0, 0), 0.08))
		local fz = -sz.Z * 0.58
		for _, x in { -1, 1 } do -- sharp angled lenses
			round(m, hd, "Lens", V(sz.X * 0.3, sz.Y * 0.09, 0.06), CF(x * sz.X * 0.2, sz.Y * 0.07, fz) * CFrame.Angles(0, rad(x * 20), rad(x * 14)), lens)
		end
		if opts and opts.ears then -- Arkham Knight: swept-back ear fins + jaw plate + glowing visor band
			for _, x in { -1, 1 } do
				wedge(piece(m, hd, "Fin", V(0.07, sz.Y * 0.55, sz.Z * 0.6), CF(x * sz.X * 0.36, sz.Y * 0.62, sz.Z * 0.12) * CFrame.Angles(rad(-10), 0, rad(-x * 8)), color))
			end
			piece(m, hd, "Jawplate", V(sz.X * 0.6, sz.Y * 0.22, 0.1), CF(0, -sz.Y * 0.32, fz + 0.02), color:Lerp(C(255, 255, 255), 0.1), metal)
		end
	end
	local function face(m, opts) -- domino-masked lower face
		local hd = find(m, "Head"); if not hd then return end
		local sz = hd.Size
		local fz = -sz.Z * 0.5
		for _, x in { -1, 1 } do
			round(m, hd, "Domino", V(sz.X * 0.32, sz.Y * 0.18, 0.06), CF(x * sz.X * 0.19, sz.Y * 0.08, fz) * CFrame.Angles(0, 0, rad(x * -10)), dark)
			round(m, hd, "DominoLens", V(sz.X * 0.17, sz.Y * 0.07, 0.04), CF(x * sz.X * 0.19, sz.Y * 0.08, fz - 0.03) * CFrame.Angles(0, 0, rad(x * -10)), WHITE)
			round(m, hd, "Ear", V(0.1, sz.Y * 0.28, sz.Z * 0.22), CF(x * sz.X * 0.5, sz.Y * 0.03, 0.02), SKIN)
		end
		round(m, hd, "Nose", V(sz.X * 0.1, sz.Y * 0.13, 0.08), CF(0, -sz.Y * 0.08, fz - 0.03), SKIN:Lerp(C(0, 0, 0), 0.06))
		piece(m, hd, "Mouth", V(sz.X * 0.24, sz.Y * 0.03, 0.04), CF(0, -sz.Y * 0.27, fz - 0.005) * CFrame.Angles(0, 0, rad(-5)), C(120, 60, 50))
		piece(m, hd, "Jaw", V(sz.X * 0.5, 0.025, 0.03), CF(0, -sz.Y * 0.42, fz + 0.03), SKIN:Lerp(C(0, 0, 0), 0.25))
		if opts.hair then
			round(m, hd, "Hair", V(sz.X * 1.1, sz.Y * 0.6, sz.Z * 1.12), CF(0, sz.Y * 0.32, sz.Z * 0.05), opts.hair)
			round(m, hd, "Fringe", V(sz.X * 0.8, sz.Y * 0.25, sz.Z * 0.35), CF(-sz.X * 0.1, sz.Y * 0.38, -sz.Z * 0.38) * CFrame.Angles(0, 0, rad(10)), opts.hair)
			for _, x in { -1, 1 } do round(m, hd, "Sideburn", V(sz.X * 0.16, sz.Y * 0.4, sz.Z * 0.5), CF(x * sz.X * 0.48, sz.Y * 0.15, sz.Z * 0.1), opts.hair) end
		end
		if opts.streak then round(m, hd, "Streak", V(sz.X * 0.22, sz.Y * 0.12, sz.Z * 0.3), CF(-sz.X * 0.2, sz.Y * 0.5, -sz.Z * 0.35), WHITE) end
	end
	local function jacket(m, color, under)
		local t = chestOf(m); if not t then return end
		local sz = t.Size
		round(m, t, "Armor", V(sz.X * 0.64, sz.Y * 0.95, sz.Z * 1.0), CF(0, sz.Y * 0.05, -sz.Z * 0.07), under)
		for _, x in { -1, 1 } do
			piece(m, t, "Lapel", V(sz.X * 0.09, sz.Y * 0.95, 0.07), CF(x * sz.X * 0.27, -sz.Y * 0.02, front(t, -0.01)) * CFrame.Angles(0, rad(x * -15), rad(x * 4)), color, Enum.Material.Leather)
			round(m, t, "Collar", V(sz.X * 0.3, sz.Y * 0.32, sz.Z * 0.75), CF(x * sz.X * 0.2, sz.Y * 0.5, sz.Z * 0.06) * CFrame.Angles(0, 0, rad(x * -12)), color, Enum.Material.Leather)
		end
		local w = waistOf(m)
		if w and w ~= t then -- hip-length hem
			local l = w.Size
			for _, x in { -1, 1 } do
				piece(m, w, "HemBack", V(l.X * 0.52, 0.75, 0.08), CF(x * l.X * 0.25, -0.15, l.Z * 0.56) * CFrame.Angles(rad(8), 0, 0), color, Enum.Material.Leather)
				piece(m, w, "HemSide", V(0.08, 0.7, l.Z * 0.95), CF(x * l.X * 0.54, -0.13, 0.04) * CFrame.Angles(0, 0, rad(x * 7)), color, Enum.Material.Leather)
				piece(m, w, "HemFront", V(l.X * 0.2, 0.6, 0.08), CF(x * l.X * 0.42, -0.1, -l.Z * 0.56) * CFrame.Angles(rad(-6), 0, rad(x * 5)), color, Enum.Material.Leather)
			end
		end
		each(m, { "LeftLowerArm", "RightLowerArm" }, function(a) band(m, a, "SleeveCuff", a.Size.X * 1.1, a.Size.Y * 0.16, CF(0, -a.Size.Y * 0.4, 0), color:Lerp(C(0, 0, 0), 0.2), Enum.Material.Leather) end)
	end
	local function gear(m, beltC, holsters)
		local w = waistOf(m)
		if w then
			local l = w.Size
			ring(m, w, "Belt", l.X * 0.52, l.Z * 0.56, 0.24, 0.1, CF(0, l.Y * 0.2, 0), beltC, Enum.Material.Leather, 12)
			piece(m, w, "Buckle", V(l.X * 0.18, 0.26, 0.08), CF(0, l.Y * 0.2, -l.Z * 0.6), C(150, 150, 155), metal)
			for _, a in { 60, 300, 120, 240 } do
				local r = rad(a)
				piece(m, w, "Pouch", V(0.24, 0.28, 0.14), CF(math.sin(r) * l.X * 0.56, l.Y * 0.1, -math.cos(r) * l.Z * 0.6) * CFrame.Angles(0, -r, 0), beltC:Lerp(C(0, 0, 0), 0.2), Enum.Material.Leather)
			end
		end
		if holsters then
			each(m, { "LeftUpperLeg", "RightUpperLeg" }, function(a, x)
				local hs = piece(m, a, "Holster", V(0.18, a.Size.Y * 0.55, a.Size.Z * 0.55), CF(x * a.Size.X * 0.55, -a.Size.Y * 0.05, 0), C(35, 30, 28), Enum.Material.Leather)
				piece(m, hs, "Pistol", V(0.14, 0.32, 0.18), CF(0, hs.Size.Y * 0.62, 0.05) * CFrame.Angles(rad(-15), 0, 0), C(20, 20, 22), metal)
				band(m, a, "HolsterStrap", a.Size.X * 1.06, 0.08, CF(0, -a.Size.Y * 0.18, 0), C(35, 30, 28))
			end)
		end
	end
	local function kneepads(m, color)
		each(m, { "LeftLowerLeg", "RightLowerLeg" }, function(a)
			round(m, a, "KneePad", V(a.Size.X * 0.6, a.Size.Y * 0.32, a.Size.Z * 0.35), CF(0, a.Size.Y * 0.4, -a.Size.Z * 0.38), color)
		end)
	end
	local function cape(m, color, inner, len, jagged) -- curved drape: strips around the back that flare at the hem
		local t = chestOf(m); if not t then return end
		local sz = t.Size
		local L = sz.Y * len
		for i = -2, 2 do
			local a = rad(i * 22)
			local cf = CF(math.sin(a) * sz.X * 0.6, sz.Y * 0.45 - L / 2, math.cos(a) * sz.Z * 0.62) * CFrame.Angles(0, a, 0) * CFrame.Angles(rad(7), 0, 0)
			local c = piece(m, t, "Cape", V(sz.X * 0.26, L, 0.07), cf, color, Enum.Material.Fabric)
			if inner then piece(m, c, "CapeInner", V(sz.X * 0.26, L * 0.98, 0.03), CF(0, 0, -0.05), inner, Enum.Material.Fabric) end
			if jagged then wedge(piece(m, c, "Jag", V(0.07, 0.4, sz.X * 0.2), CF(0, -L / 2 - 0.2, 0) * CFrame.Angles(0, rad(90), rad(180)), color)) end
		end
	end
	local function xmark(m, anchor, y, z, size, color, w)
		for _, a in { 45, -45 } do piece(m, anchor, "X", V(size, w or size * 0.22, 0.05), CF(0, y, z) * CFrame.Angles(0, 0, rad(a)), color) end
	end

	local pieces
	local colors
	if look == "robin" then -- Jason Todd's Robin: red tunic with R badge, green sleeves/gloves/trunks, yellow cape, black domino + hair
		local green = C(40, 120, 50)
		pieces = {
			function(m) face(m, { hair = C(22, 20, 22) }) end,
			function(m)
				local t = chestOf(m); if not t then return end
				local sz = t.Size
				round(m, t, "RBadge", V(0.5, 0.5, 0.06), CF(-sz.X * 0.24, sz.Y * 0.22, front(t, 0.02)), dark)
				round(m, t, "RBadgeFill", V(0.42, 0.42, 0.06), CF(-sz.X * 0.24, sz.Y * 0.22, front(t, 0.04)), C(255, 210, 60))
				local g = piece(m, t, "RLetter", V(0.32, 0.32, 0.03), CF(-sz.X * 0.24, sz.Y * 0.22, front(t, 0.09)), dark); g.Transparency = 1
				glyph(g, Enum.NormalId.Front, "R", dark)
				for k = 0, 2 do round(m, t, "Clasp", V(0.08, 0.08, 0.04), CF(sz.X * 0.04, sz.Y * (0.25 - k * 0.2), front(t, 0.03)), C(255, 210, 60)) end
				each(m, { "LeftUpperArm", "RightUpperArm" }, function(a) band(m, a, "Sleeve", a.Size.X * 1.08, a.Size.Y * 0.45, CF(0, a.Size.Y * 0.25, 0), green, Enum.Material.Fabric) end)
			end,
			function(m) cape(m, C(255, 210, 60), nil, 1.75) end,
			function(m) gear(m, C(255, 210, 60), false) end,
		}
		colors = { Head = SKIN, Chest = s.Primary, Waist = green, Arms = SKIN, Gloves = green, Legs = green, Boots = C(25, 60, 30) }
		return { colors = colors, pieces = pieces }
	end
	if look == "redx" then -- Red X: black suit, white skull mask with a red X, red X on the chest, ragged black cape, white belt
		local red = s.Secondary
		pieces = {
			function(m)
				local hd = find(m, "Head"); if not hd then return end
				local sz = hd.Size
				round(m, hd, "Hood", V(sz.X * 1.14, sz.Y * 1.14, sz.Z * 1.14), CF(0, sz.Y * 0.04, sz.Z * 0.03), dark, Enum.Material.Fabric)
				round(m, hd, "Skull", V(sz.X * 0.9, sz.Y * 1.0, sz.Z * 0.5), CF(0, -sz.Y * 0.02, -sz.Z * 0.36), C(240, 240, 235))
				for _, x in { -1, 1 } do round(m, hd, "Socket", V(sz.X * 0.24, sz.Y * 0.16, 0.06), CF(x * sz.X * 0.19, sz.Y * 0.06, -sz.Z * 0.6) * CFrame.Angles(0, rad(x * 15), rad(x * 15)), C(15, 15, 18)) end
				xmark(m, hd, sz.Y * 0.08, -sz.Z * 0.63, sz.X * 0.75, red, sz.Y * 0.1)
			end,
			function(m)
				local t = chestOf(m); if not t then return end
				xmark(m, t, t.Size.Y * 0.12, front(t, 0.03), t.Size.X * 0.5, red, 0.16)
				for _, x in { -1, 1 } do round(m, t, "Collar", V(t.Size.X * 0.3, t.Size.Y * 0.3, t.Size.Z * 0.7), CF(x * t.Size.X * 0.2, t.Size.Y * 0.5, t.Size.Z * 0.1), dark, Enum.Material.Fabric) end
			end,
			function(m) cape(m, dark, nil, 2.4, true) end,
			function(m)
				gear(m, C(220, 220, 225), false)
				local w = waistOf(m)
				if w then xmark(m, w, w.Size.Y * 0.2, -w.Size.Z * 0.66, 0.3, red, 0.07) end
				each(m, { "LeftLowerArm", "RightLowerArm" }, function(a) band(m, a, "Cuff", a.Size.X * 1.14, a.Size.Y * 0.14, CF(0, a.Size.Y * 0.1, 0), red) end)
			end,
		}
		return { colors = { Head = dark, Chest = body, Waist = body, Arms = body, Hands = dark, Legs = body, Feet = dark }, pieces = pieces }
	end

	local jacketC = s.Jacket or s.Secondary
	local under = s.Armor or C(45, 45, 50)
	local batC = s.Bat or C(200, 30, 40)
	pieces = {}
	if look == "hood" then -- Outlaws: red cloth hood over a domino mask, open leather jacket
		table.insert(pieces, function(m)
			face(m, { hair = C(22, 20, 22), streak = true })
			local hd = find(m, "Head"); if not hd then return end
			local sz = hd.Size
			round(m, hd, "Hood", V(sz.X * 1.22, sz.Y * 1.08, sz.Z * 1.1), CF(0, sz.Y * 0.14, sz.Z * 0.12), s.Helmet, Enum.Material.Fabric)
			round(m, hd, "HoodDrape", V(sz.X * 1.4, sz.Y * 0.55, sz.Z * 1.0), CF(0, -sz.Y * 0.55, sz.Z * 0.15), s.Helmet, Enum.Material.Fabric)
		end)
	elseif look == "knight" then
		table.insert(pieces, function(m) helmet(m, s.Helmet, C(140, 210, 255), { ears = true }) end)
	elseif look == "stroke" then -- Jasonstroke: Deathstroke-style split helmet in red/black
		table.insert(pieces, function(m)
			local hd = find(m, "Head"); if not hd then return end
			local sz = hd.Size
			round(m, hd, "HelmetR", V(sz.X * 1.14, sz.Y * 1.16, sz.Z * 1.16), CF(-0.03, sz.Y * 0.04, 0), s.Helmet)
			round(m, hd, "HelmetL", V(sz.X * 1.14, sz.Y * 1.16, sz.Z * 1.16), CF(0.03, sz.Y * 0.04, 0), dark)
			round(m, hd, "HelmetJaw", V(sz.X * 0.8, sz.Y * 0.5, sz.Z * 0.6), CF(0, -sz.Y * 0.28, -sz.Z * 0.24), dark)
			round(m, hd, "Lens", V(sz.X * 0.3, sz.Y * 0.09, 0.06), CF(-sz.X * 0.2, sz.Y * 0.07, -sz.Z * 0.58) * CFrame.Angles(0, rad(-20), rad(-14)), WHITE)
		end)
	else
		table.insert(pieces, function(m) helmet(m, s.Helmet or C(200, 25, 35), WHITE) end)
	end
	if look == "knight" or look == "stroke" then -- armored: chest plates, pauldrons, emblem, harness
		table.insert(pieces, function(m)
			local t = chestOf(m); if not t then return end
			local sz = t.Size
			for _, x in { -1, 1 } do
				round(m, t, "ChestPlate", V(sz.X * 0.5, sz.Y * 0.42, sz.Z * 0.26), CF(x * sz.X * 0.21, sz.Y * 0.22, -sz.Z * 0.42) * CFrame.Angles(0, rad(x * 12), 0), under, metal)
			end
			each(m, { "LeftUpperArm", "RightUpperArm" }, function(a, x)
				round(m, a, "Pauldron", V(a.Size.X * 1.45, a.Size.Y * 0.7, a.Size.Z * 1.35), CF(x * a.Size.X * 0.08, a.Size.Y * 0.4, 0), under, metal)
			end)
			each(m, { "LeftLowerArm", "RightLowerArm" }, function(a) round(m, a, "Vambrace", V(a.Size.X * 1.12, a.Size.Y * 0.6, a.Size.Z * 1.12), CF(0, -a.Size.Y * 0.05, 0), under, metal) end)
			bat(m, t, sz.Y * 0.18, sz.X * 0.6, batC)
			if look == "stroke" then
				for _, k in { -1, 1 } do
					local diag = math.sqrt((sz.X * 0.75) ^ 2 + sz.Y ^ 2)
					piece(m, t, "Strap", V(sz.X * 0.06, diag, 0.06), CF(0, -sz.Y * 0.02, front(t, 0.04)) * CFrame.Angles(0, 0, k * math.atan2(sz.X * 0.75, sz.Y)), C(60, 20, 25), Enum.Material.Leather)
				end
			end
		end)
		table.insert(pieces, function(m) gear(m, C(40, 40, 45), true); kneepads(m, under) end)
	else
		table.insert(pieces, function(m)
			jacket(m, jacketC, under)
			local t = chestOf(m)
			if t then bat(m, t, t.Size.Y * 0.14, t.Size.X * 0.66, batC) end
		end)
		table.insert(pieces, function(m) gear(m, C(60, 45, 35), true); kneepads(m, C(35, 35, 40)) end)
	end
	local armored = look == "knight" or look == "stroke"
	colors = { Head = look == "hood" and SKIN or (s.Helmet or C(200, 25, 35)), Chest = armored and body or jacketC, Waist = s.Pants or C(55, 55, 60), Arms = armored and body or jacketC,
		Hands = dark, Legs = s.Pants or C(55, 55, 60), Boots = C(30, 28, 28) }
	return { colors = colors, pieces = pieces }
end
