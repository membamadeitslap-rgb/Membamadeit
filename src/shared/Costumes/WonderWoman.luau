-- Wonder Woman (Perez classic): red bustier with the gold eagle across the bust, blue star-spangled briefs, gold belt,
-- silver bracers, gold tiara with red star, knee-high red boots with a white stripe, long black hair, lasso coiled on the hip.
-- Variants: Amazon Warrior (bronze leather + pteruges), Golden Eagle Armor (gold armor + wings), Goddess of War (dark armor,
-- crested helm), Queen of the Amazons (white/gold, crown + cape), Goddess of Truth (radiant gold/white, glowing lasso).
-- Costume module: return function(s, H, rarity) -> { colors = { group = Color3 }, pieces = { { "Piece", args... } | function(m) end } }
local V, CF, A, rad = Vector3.new, CFrame.new, CFrame.Angles, math.rad

-- ===== local kit (rounded shapes) =====
local function kit(H)
	local piece, round = H.piece, H.round
	local k = {}
	function k.wedge(m, a, name, size, cf, color, mat)
		local p = piece(m, a, name, size, cf, color, mat)
		local sm = Instance.new("SpecialMesh"); sm.MeshType = Enum.MeshType.Wedge; sm.Parent = p
		return p
	end
	-- isosceles triangle prism, apex toward +Y; base w along local Z, thickness t along X
	function k.tri(m, a, name, t, h, w, cf, color, mat)
		k.wedge(m, a, name, V(t, h, w / 2), cf * CF(0, 0, -w / 4), color, mat)
		k.wedge(m, a, name, V(t, h, w / 2), cf * CF(0, 0, w / 4) * A(0, math.pi, 0), color, mat)
	end
	-- flat triangle facing the camera (in the XY plane), apex toward +Y
	function k.flat(m, a, name, w, h, t, cf, color, mat) k.tri(m, a, name, t, h, w, cf * A(0, rad(90), 0), color, mat) end
	-- Draped cape: panels on an arc behind the back, hinged at the shoulders, fanning out to the hem
	function k.cape(m, color, o)
		local t = H.chestOf(m); if not t then return {} end
		local s = t.Size
		local n, len = o.n or 5, s.Y * (o.len or 2.6)
		local arc, R, fan, pitch = rad(o.arc or 80), s.X * (o.r or 0.5), rad(o.fan or 9), rad(o.pitch or 7)
		local top = s.Y * (o.top or 0.4)
		local zc = s.Z / 2 + (o.gap or 0.08) - R
		local dphi, droll = arc / (n - 1), 2 * fan / (n - 1)
		local w = (R * dphi + len * droll) * 1.1
		local panels = {}
		for i = 0, n - 1 do
			local u = i / (n - 1) * 2 - 1
			local cf = CF(0, top, zc) * A(0, u * arc / 2, 0) * CF(0, 0, R + (i % 2) * 0.012) * A(-pitch, 0, u * fan) * CF(0, -len / 2, 0)
			local p = piece(m, t, "Cape", V(w, len, 0.08), cf, color, o.mat or Enum.Material.Fabric)
			table.insert(panels, { p = p, cf = cf, w = w, len = len })
			if o.inner then piece(m, t, "CapeInner", V(w, len * 0.98, 0.04), cf * CF(0, 0, -0.06), o.inner, Enum.Material.Fabric) end
			if o.scallop then -- pointed hem (bat-wing scallops)
				k.flat(m, t, "CapeHem", w * 0.6, len * 0.09, 0.08, cf * CF(w * 0.2, -len / 2 - len * 0.045, 0) * A(0, 0, math.pi), color, o.mat or Enum.Material.Fabric)
			end
		end
		if o.drape ~= false then -- cloth over the shoulders
			local d = o.drape or 1
			for _, x in { -1, 1 } do
				round(m, t, "CapeDrape", V(s.X * 0.5 * d, s.Y * 0.32 * d, s.Z * 1.08), CF(x * s.X * 0.24, s.Y * 0.42, s.Z * 0.06) * A(0, 0, rad(-x * 14)), color, Enum.Material.Fabric)
			end
		end
		return panels
	end
	-- part-built bat symbol facing -Z (front), centered at cf, span w
	function k.bat(m, a, cf, w, color, mat)
		local h = w * 0.42
		round(m, a, "BatBody", V(w * 0.12, h * 0.8, 0.05), cf * CF(0, -h * 0.05, 0), color, mat)
		round(m, a, "BatHead", V(w * 0.1, h * 0.42, 0.05), cf * CF(0, h * 0.34, 0), color, mat) -- tall head reads as the ears at this size
		for _, x in { -1, 1 } do
			-- wing: triangle out to a raised tip, lower edge cut by two downward scallop points
			k.flat(m, a, "BatWing", h * 0.75, w * 0.46, 0.05, cf * CF(x * w * 0.27, h * 0.12, 0) * A(0, 0, rad(-x * 78)), color, mat)
			k.flat(m, a, "BatWing", w * 0.16, h * 0.42, 0.05, cf * CF(x * w * 0.3, -h * 0.18, 0) * A(0, 0, math.pi + rad(x * 10)), color, mat)
			k.flat(m, a, "BatWing", w * 0.16, h * 0.34, 0.05, cf * CF(x * w * 0.14, -h * 0.2, 0) * A(0, 0, math.pi), color, mat)
		end
	end
	-- z of the head's front surface (classic rounded head) at horizontal offset x
	function k.fz(h, x, out) return -math.sqrt(math.max(0.02, 0.25 - (x / h.X) ^ 2)) * h.Z - (out or 0.01) end
	-- Comic face on the bare head: rounded eyes (sclera/iris/pupil), lid line, brows, nose, lips, ears, heroic jaw
	-- o: iris, brow, lip, style ("neutral" | "angry" | "smirk" | "grin"), jaw (bool), lash (female)
	function k.face(m, o)
		local hd = H.find(m, "Head"); if not hd then return end
		local h = hd.Size
		local skin = o.skin or hd.Color
		local dark = skin:Lerp(H.C(0, 0, 0), 0.6)
		local style = o.style or "neutral"
		if o.jaw ~= false then round(m, hd, "Jaw", V(h.X * 0.78, h.Y * 0.46, h.Z * 0.6), CF(0, -h.Y * 0.27, -h.Z * 0.2), skin) end
		for _, x in { -1, 1 } do
			local ex = x * h.X * 0.19
			local z = k.fz(h, ex, 0)
			round(m, hd, "Sclera", V(h.X * 0.2, h.Y * 0.11, 0.08), CF(ex, h.Y * 0.06, z), H.C(250, 250, 250), Enum.Material.SmoothPlastic)
			round(m, hd, "Iris", V(h.X * 0.085, h.Y * 0.095, 0.08), CF(ex - x * 0.012, h.Y * 0.055, z - 0.012), o.iris or H.C(70, 110, 170), Enum.Material.SmoothPlastic)
			round(m, hd, "Pupil", V(h.X * 0.04, h.Y * 0.045, 0.06), CF(ex - x * 0.012, h.Y * 0.055, z - 0.035), H.C(10, 10, 12), Enum.Material.SmoothPlastic)
			piece(m, hd, "Lid", V(h.X * 0.22, h.Y * (o.lash and 0.035 or 0.025), 0.04), CF(ex, h.Y * 0.11, z - 0.01) * A(0, x * rad(20), rad(o.lash and -x * 8 or 0)), o.lash and H.C(20, 15, 15) or dark)
			local tilt = (style == "angry" and 20 or style == "smirk" and (x > 0 and -12 or 6) or 5) * x
			piece(m, hd, "Brow", V(h.X * 0.24, h.Y * (o.lash and 0.035 or 0.06), 0.05), CF(ex, h.Y * 0.19, z - 0.01) * A(0, x * rad(20), rad(-tilt)), o.brow or H.C(40, 30, 25))
			round(m, hd, "Ear", V(0.1, h.Y * 0.28, h.Z * 0.2), CF(x * h.X * 0.5, h.Y * 0.0, h.Z * 0.02), skin)
		end
		local nz = -h.Z * 0.5
		k.wedge(m, hd, "Nose", V(h.X * 0.11, h.Y * 0.2, 0.12), CF(0, -h.Y * 0.05, nz - 0.04), skin:Lerp(H.C(0, 0, 0), 0.06))
		local mz = -h.Z * 0.5 - (o.jaw ~= false and 0.025 or 0.01)
		local mw = style == "grin" and 0.4 or 0.26
		piece(m, hd, "Mouth", V(h.X * mw, h.Y * 0.03, 0.04), CF(0, -h.Y * 0.27, mz) * A(0, 0, rad(style == "smirk" and 7 or 0)), dark)
		if style == "grin" then piece(m, hd, "Teeth", V(h.X * 0.34, h.Y * 0.05, 0.04), CF(0, -h.Y * 0.3, mz + 0.005), H.C(250, 250, 245)) end
		if o.lip then round(m, hd, "Lip", V(h.X * 0.22, h.Y * 0.07, 0.06), CF(0, -h.Y * 0.31, mz + 0.01), o.lip) end
	end
	-- Hair cap that follows the skull (rounded), with optional back volume
	function k.hair(m, color, o)
		local hd = H.find(m, "Head"); if not hd then return end
		local h = hd.Size
		o = o or {}
		round(m, hd, "Hair", V(h.X * 1.1, h.Y * (o.top or 0.62), h.Z * 1.12), CF(0, h.Y * (o.y or 0.3), h.Z * 0.05), color)
		round(m, hd, "HairBack", V(h.X * 1.06, h.Y * (o.back or 0.75), h.Z * 0.6), CF(0, h.Y * 0.08, h.Z * 0.26), color)
		if o.sideburns ~= false then
			for _, x in { -1, 1 } do piece(m, hd, "Sideburn", V(0.06, h.Y * 0.22, h.Z * 0.14), CF(x * h.X * 0.5, h.Y * 0.08, -h.Z * 0.06), color) end
		end
	end
	-- Superman-style pentagon shield (flat-top, pointed bottom) facing -Z at cf; returns nothing
	function k.pentagon(m, a, name, w, ht, cf, color, mat, depth)
		depth = depth or 0.05
		local topH = ht * 0.32
		piece(m, a, name, V(w, topH, depth), cf * CF(0, ht / 2 - topH / 2, 0), color, mat)
		k.flat(m, a, name, w, ht - topH, depth, cf * CF(0, -topH / 2, 0) * A(0, 0, math.pi), color, mat)
	end
	-- text label on a nearly invisible plate (fully transparent plates are skipped by the preview dump)
	function k.label(m, a, name, size, cf, text, color, font)
		local g = piece(m, a, name, size, cf, color); g.Transparency = 0.97
		H.glyph(g, Enum.NormalId.Front, text, color, font or Enum.Font.GothamBlack)
		return g
	end
	return k
end

return function(s, H, rarity)
	local C, SKIN, GOLD, WHITE = H.C, H.SKIN, H.GOLD, H.WHITE
	local piece, round, band, ring, find, chestOf, waistOf = H.piece, H.round, H.band, H.ring, H.find, H.chestOf, H.waistOf
	local k = kit(H)
	local top, low = s.Primary, s.Secondary
	local amazon, eagle, war, queen, truth = rarity == "Rare", rarity == "Epic", rarity == "Legendary", rarity == "Mythic", rarity == "Secret"
	local skin = C(222, 172, 134)
	local gold = C(225, 180, 55)
	local silver = C(200, 202, 212)
	local hairC = C(20, 15, 18)
	local armored = eagle or war
	local metal = eagle and gold or war and C(70, 60, 62) or nil
	local bootC = amazon and C(110, 70, 45) or truth and C(250, 240, 200) or queen and C(235, 235, 240) or armored and metal or top

	local function head(m)
		local hd = find(m, "Head"); if not hd then return end
		local h = hd.Size
		k.face(m, { iris = C(60, 110, 190), brow = hairC, style = war and "angry" or "neutral", lip = C(185, 40, 55), lash = true, skin = skin, jaw = false })
		k.hair(m, hairC, { top = 0.6, y = 0.3, back = 0.9, sideburns = false })
		-- long voluminous hair down the back, side locks framing the face
		round(m, hd, "HairLong", V(h.X * 1.3, h.Y * 2.1, h.Z * 0.62), CF(0, -h.Y * 0.75, h.Z * 0.4) * A(rad(-8), 0, 0), hairC)
		for _, x in { -1, 1 } do
			round(m, hd, "HairLock", V(h.X * 0.32, h.Y * 1.2, h.Z * 0.5), CF(x * h.X * 0.48, -h.Y * 0.35, h.Z * 0.12) * A(0, 0, rad(x * 6)), hairC)
		end
		if war then -- Greek crested war helm with cheek guards
			round(m, hd, "Helm", V(h.X * 1.16, h.Y * 0.85, h.Z * 1.16), CF(0, h.Y * 0.2, 0.02), metal, Enum.Material.Metal)
			for _, x in { -1, 1 } do piece(m, hd, "Cheek", V(h.X * 0.14, h.Y * 0.5, h.Z * 0.5), CF(x * h.X * 0.5, -h.Y * 0.12, -h.Z * 0.2), metal, Enum.Material.Metal) end
			for i = 0, 4 do round(m, hd, "Crest", V(h.X * 0.14, h.Y * 0.45, h.Z * 0.32), CF(0, h.Y * (0.66 - math.abs(i - 2) * 0.03), h.Z * (-0.36 + i * 0.2)) * A(rad(-10 + i * 18), 0, 0), C(150, 20, 25), Enum.Material.Fabric) end
			return
		end
		if eagle then -- winged eagle helm
			round(m, hd, "Helm", V(h.X * 1.14, h.Y * 0.7, h.Z * 1.14), CF(0, h.Y * 0.28, 0.02), gold, Enum.Material.Metal)
			for _, x in { -1, 1 } do k.tri(m, hd, "HelmWing", 0.06, h.Y * 0.6, h.Z * 0.35, CF(x * h.X * 0.57, h.Y * 0.4, h.Z * 0.15) * A(rad(-40), 0, rad(-x * 15)), gold, Enum.Material.Metal) end
			k.label(m, hd, "HelmStar", V(h.X * 0.24, h.Y * 0.22, 0.02), CF(0, h.Y * 0.3, k.fz(h, 0, 0.1)), "★", C(210, 25, 35))
			return
		end
		-- tiara: band round the brow rising to a point at the front, red star
		band(m, hd, "Tiara", h.X * 1.07, h.Y * 0.08, CF(0, h.Y * 0.25, 0.01), gold, Enum.Material.Metal)
		k.flat(m, hd, "TiaraPeak", h.X * 0.5, h.Y * 0.26, 0.05, CF(0, h.Y * 0.35, k.fz(h, 0, 0.04)), gold, Enum.Material.Metal)
		k.label(m, hd, "TiaraStar", V(h.X * 0.24, h.Y * 0.22, 0.02), CF(0, h.Y * 0.32, k.fz(h, 0, 0.08)), "★", queen and C(40, 80, 190) or C(210, 25, 35))
		if queen then -- crown points above the tiara
			for i = -2, 2 do k.flat(m, hd, "Crown", h.X * 0.14, h.Y * (0.32 - math.abs(i) * 0.06), 0.05, CF(i * h.X * 0.17, h.Y * 0.5, k.fz(h, i * h.X * 0.17, 0.0) + 0.05) * A(0, i * rad(-18), 0), gold, Enum.Material.Metal) end
		end
	end

	local function bustier(m)
		local t = chestOf(m); if not t then return end
		local c = t.Size
		if not armored then -- bare shoulders / upper chest above the strapless top
			round(m, t, "Shoulders", V(c.X * 0.8, c.Y * 0.36, c.Z * 1.0), CF(0, c.Y * 0.44, 0.02), skin)
		end
		-- gold eagle: two swept wings meeting in a W across the top of the bust, small head at center
		local fz = -c.Z * 0.5 - 0.02
		for _, x in { -1, 1 } do
			piece(m, t, "Eagle", V(c.X * 0.36, c.Y * 0.09, 0.08), CF(x * c.X * 0.18, c.Y * 0.2, fz - 0.06) * A(0, x * rad(18), rad(x * 26)), gold, Enum.Material.Metal)
			piece(m, t, "Eagle", V(c.X * 0.22, c.Y * 0.07, 0.08), CF(x * c.X * 0.24, c.Y * 0.11, fz - 0.06) * A(0, x * rad(18), rad(x * 20)), gold, Enum.Material.Metal)
			piece(m, t, "Eagle", V(c.X * 0.2, c.Y * 0.08, 0.08), CF(x * c.X * 0.36, c.Y * 0.32, fz + 0.02) * A(0, x * rad(30), rad(x * 40)), gold, Enum.Material.Metal)
		end
		round(m, t, "EagleHead", V(c.X * 0.1, c.Y * 0.12, 0.1), CF(0, c.Y * 0.1, fz - 0.07), gold, Enum.Material.Metal)
		if amazon then -- bronze breastplate edge + shoulder strap
			piece(m, t, "Strap", V(c.X * 0.1, c.Y * 1.05, 0.05), CF(-c.X * 0.12, 0, fz - 0.02) * A(0, 0, rad(-30)), C(90, 55, 35), Enum.Material.Leather)
		end
		if eagle or war then -- shoulder pauldrons
			for _, n in { "LeftUpperArm", "RightUpperArm" } do
				local a = m:FindFirstChild(n)
				if a then round(m, a, "Pauldron", V(a.Size.X * 1.7, a.Size.Y * 0.5, a.Size.Z * 1.6), CF(0, a.Size.Y * 0.38, 0), metal, Enum.Material.Metal) end
			end
		end
	end

	local function waist(m)
		local w = waistOf(m); if not w then return end
		local l = w.Size
		ring(m, w, "Belt", l.X * 0.53, l.Z * 0.56, 0.2, 0.08, CF(0, l.Y * 0.38, 0), gold, Enum.Material.Metal, 10)
		round(m, w, "Buckle", V(l.X * 0.18, 0.24, 0.08), CF(0, l.Y * 0.38, -l.Z * 0.58), gold, Enum.Material.Metal)
		if not (amazon or armored) then -- white stars on the blue briefs
			for _, o in { { -0.24, -0.15 }, { 0.24, -0.15 }, { 0, -0.4 } } do
				k.label(m, w, "Star", V(0.24, 0.24, 0.02), CF(o[1] * l.X, o[2] * l.Y, -l.Z * 0.62), "★", WHITE)
			end
		end
		if amazon or war or eagle then -- pteruges: leather / metal strips hanging from the belt
			for i = 0, 5 do
				local a = (i + 0.5) / 6 * math.pi * 2
				piece(m, w, "Pteruges", V(l.X * 0.4, l.Y * 1.5, 0.06), CF(math.sin(a) * l.X * 0.5, -l.Y * 0.5, -math.cos(a) * l.Z * 0.55) * A(0, -a, 0) * A(rad(8), 0, 0),
					amazon and C(120, 75, 45) or metal, amazon and Enum.Material.Leather or Enum.Material.Metal)
			end
		end
		-- golden lasso coiled on the right hip
		local lc = truth and C(255, 235, 140) or C(240, 195, 70)
		ring(m, w, "Lasso", 0.34, 0.34, 0.08, 0.08, CF(l.X * 0.58, -l.Y * 0.2, 0) * A(0, 0, rad(90)), lc, truth and Enum.Material.Neon or Enum.Material.Fabric, 8)
	end

	local function limbs(m)
		for _, n in { "LeftLowerArm", "RightLowerArm" } do -- bulletproof bracers with flared rims
			local a = m:FindFirstChild(n)
			if a then
				band(m, a, "BracerRim", a.Size.X * 1.18, 0.08, CF(0, a.Size.Y * 0.12, 0), silver, Enum.Material.Metal)
				band(m, a, "BracerRim", a.Size.X * 1.18, 0.08, CF(0, -a.Size.Y * 0.45, 0), silver, Enum.Material.Metal)
			end
		end
		for _, n in { "LeftLowerLeg", "RightLowerLeg" } do -- knee-high boots: white top + white front stripe
			local a = m:FindFirstChild(n)
			if a then
				local s2 = a.Size
				band(m, a, "BootTop", s2.X * 1.12, 0.12, CF(0, s2.Y * 0.46, 0), armored and metal or WHITE)
				if not armored then piece(m, a, "BootStripe", V(s2.X * 0.12, s2.Y * 0.92, 0.04), CF(0, -s2.Y * 0.02, -s2.Z * 0.5 - 0.02), amazon and C(200, 170, 90) or WHITE) end
			end
		end
	end

	local function extras(m)
		local t = chestOf(m); if not t then return end
		if queen or truth then -- flowing cape from the shoulders
			k.cape(m, queen and C(240, 240, 245) or C(255, 245, 210), { n = 5, len = 2.2, arc = 90, fan = 9, r = 0.5, pitch = 6, top = 0.4, drape = 0.6 })
		end
		if eagle then -- big golden eagle wings on the back
			local c = t.Size
			for _, x in { -1, 1 } do
				for i = 0, 3 do -- primaries sweep out and up, shorter coverts below
					local len = c.Y * (1.7 - i * 0.2)
					k.tri(m, t, "Feather", 0.06, len, c.Y * 0.36, CF(x * c.X * 0.2, c.Y * (0.3 - i * 0.08), c.Z * 0.6 + i * 0.02) * A(0, 0, rad(-x * (48 + i * 20))) * CF(0, len / 2, 0) * A(0, rad(90), 0), gold:Lerp(C(255, 245, 200), i * 0.08), Enum.Material.Metal)
				end
			end
		end
	end

	local colors = { Head = skin, Chest = top, Waist = low, Arms = skin, LowerArms = silver, Hands = skin, Legs = skin, Boots = bootC }
	if armored then colors.Arms = metal; colors.LowerArms = metal; colors.Hands = metal; colors.Legs = metal end
	if amazon then colors.LowerArms = C(110, 70, 45) end
	return { colors = colors, pieces = { head, bustier, waist, limbs, extras } }
end
