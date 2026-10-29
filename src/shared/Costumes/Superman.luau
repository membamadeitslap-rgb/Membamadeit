-- Superman: blue suit, red cape/trunks/boots (V-notch tops), yellow belt, red-bordered pentagon S-shield (also on the cape back),
-- black hair with the S-curl, square jaw. Variants: Black Suit (no cape, silver shield, long hair), Cyborg (half metal face/arm),
-- Kingdom Come (black-red shield, gray temples, no trunks), Superman Prime (gold), Bizarro (chalk skin, backwards S).
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
	local C, SKIN, WHITE = H.C, H.SKIN, H.WHITE
	local piece, round, band, ring, find, chestOf, waistOf, glyph = H.piece, H.round, H.band, H.ring, H.find, H.chestOf, H.waistOf, H.glyph
	local k = kit(H)
	local suit, red = s.Primary, s.Secondary
	local black, cyborg, kc, prime, bizarro = rarity == "Rare", rarity == "Epic", rarity == "Legendary", rarity == "Mythic", rarity == "Secret"
	local yellow = C(255, 210, 40)
	local skin = bizarro and C(195, 210, 205) or SKIN
	local hairC = C(18, 18, 26)
	-- shield colors: border, field, letter
	local border, field, letter = red, yellow, red
	if black then border, field, letter = C(170, 175, 185), C(25, 25, 30), C(170, 175, 185)
	elseif kc then border, field, letter = C(20, 20, 25), C(20, 20, 25), C(190, 25, 30)
	elseif prime then border, field, letter = C(30, 70, 190), C(255, 235, 150), C(30, 70, 190)
	elseif bizarro then border, field, letter = red, C(200, 190, 60), red end
	local S = bizarro and "Ƨ" or "S"
	local beltC = black and C(170, 175, 185) or kc and C(150, 25, 30) or prime and C(30, 70, 190) or yellow

	local function head(m)
		local hd = find(m, "Head"); if not hd then return end
		local h = hd.Size
		k.face(m, { iris = bizarro and C(20, 20, 20) or C(60, 120, 220), brow = hairC, style = bizarro and "grin" or cyborg and "angry" or "neutral", skin = skin })
		k.hair(m, hairC, { top = 0.58, y = 0.32, back = black and 1.25 or 0.72 })
		-- the S-curl on the forehead
		round(m, hd, "Curl", V(h.X * 0.12, h.Y * 0.16, 0.12), CF(h.X * 0.04, h.Y * 0.3, k.fz(h, 0, 0.02)) * A(0, 0, rad(-25)), hairC)
		round(m, hd, "Curl", V(h.X * 0.08, h.Y * 0.1, 0.1), CF(-h.X * 0.01, h.Y * 0.21, k.fz(h, 0, 0.03)), hairC)
		if kc then -- graying temples
			for _, x in { -1, 1 } do round(m, hd, "Temple", V(0.1, h.Y * 0.3, h.Z * 0.3), CF(x * h.X * 0.52, h.Y * 0.15, -h.Z * 0.05), C(170, 170, 175)) end
		end
		if cyborg then -- right half of the face is metal with a red eye
			round(m, hd, "Plate", V(h.X * 0.55, h.Y * 0.95, h.Z * 1.06), CF(h.X * 0.24, -h.Y * 0.02, 0), C(165, 170, 180), Enum.Material.Metal)
			round(m, hd, "RedEye", V(h.X * 0.14, h.Y * 0.1, 0.08), CF(h.X * 0.19, h.Y * 0.06, k.fz(h, h.X * 0.19, 0.06)), C(230, 30, 30), Enum.Material.SmoothPlastic)
		end
		if bizarro then -- cracked chalk face
			for i, o in { { -0.25, 0.3, 30 }, { 0.28, -0.1, -40 }, { -0.1, -0.12, 70 } } do
				piece(m, hd, "Crack", V(h.X * 0.16, 0.025, 0.03), CF(o[1] * h.X, o[2] * h.Y, k.fz(h, o[1] * h.X, 0.04)) * A(0, 0, rad(o[3])), C(90, 100, 100))
			end
		end
	end

	local function shield(m)
		local t = chestOf(m); if not t then return end
		local c = t.Size
		local w, ht = c.X * 0.5, c.Y * 0.44
		local cf = CF(0, c.Y * 0.17, -c.Z / 2 - 0.03)
		k.pentagon(m, t, "ShieldBorder", w, ht, cf, border)
		k.pentagon(m, t, "ShieldFill", w * 0.82, ht * 0.8, cf * CF(0, ht * 0.03, -0.03), field)
		local g = k.label(m, t, "ShieldS", V(w * 0.7, ht * 0.55, 0.02), cf * CF(0, ht * 0.06, -0.07), S, letter)
		if prime then
			local l = Instance.new("PointLight"); l.Color = C(255, 220, 120); l.Range = 10; l.Brightness = 1.5; l.Parent = g
		end
	end

	local function cape(m)
		if black then return end
		local panels = k.cape(m, red, { n = 5, len = 2.25, arc = 95, fan = 9, r = 0.5, pitch = 6, top = 0.42, drape = 0.75 })
		local mid = panels[3]
		if mid and not kc then -- yellow S-shield on the back of the cape
			local t = chestOf(m)
			local cf = mid.cf * CF(0, mid.len * 0.22, 0.05) * A(0, math.pi, 0)
			local w = mid.w * 1.5
			k.pentagon(m, t, "CapeShield", w, w * 0.88, cf, field)
			k.label(m, t, "CapeS", V(w * 0.7, w * 0.5, 0.02), cf * CF(0, w * 0.06, -0.05), S, red)
		end
		local t = chestOf(m)
		if t and not kc then -- gold cape clasps... classic: none; Prime: gold
			if prime then for _, x in { -1, 1 } do round(m, t, "Clasp", V(0.22, 0.22, 0.08), CF(x * t.Size.X * 0.32, t.Size.Y * 0.38, -t.Size.Z * 0.5), yellow, Enum.Material.Metal) end end
		end
	end

	local function belt(m)
		local w = waistOf(m); if not w then return end
		local l = w.Size
		ring(m, w, "Belt", l.X * 0.52, l.Z * 0.55, 0.2, 0.08, CF(0, l.Y * 0.36, 0), beltC, nil, 10)
		round(m, w, "Buckle", V(l.X * 0.2, 0.28, 0.1), CF(0, l.Y * 0.36, -l.Z * 0.57), beltC)
	end

	local function boots(m)
		for _, n in { "LeftLowerLeg", "RightLowerLeg" } do
			local a = m:FindFirstChild(n)
			if a then
				local s2 = a.Size
				-- V-notch at the top front of the boot (suit color showing through)
				k.flat(m, a, "BootNotch", s2.X * 0.42, s2.Y * 0.24, 0.05, CF(0, s2.Y * 0.4, -s2.Z * 0.5 - 0.02) * A(0, 0, math.pi), suit)
				band(m, a, "BootTop", s2.X * 1.1, 0.1, CF(0, s2.Y * 0.5, 0), red)
			end
		end
		if black then -- silver wrist cuffs on the black suit
			for _, n in { "LeftLowerArm", "RightLowerArm" } do
				local a = m:FindFirstChild(n)
				if a then band(m, a, "Cuff", a.Size.X * 1.1, a.Size.Y * 0.28, CF(0, -a.Size.Y * 0.32, 0), C(170, 175, 185), Enum.Material.Metal) end
			end
		end
	end

	local colors = { Head = skin, Chest = suit, Waist = red, Arms = suit, Hands = suit, Legs = suit, Boots = red }
	if black then colors.Waist = suit; colors.Boots = suit end
	if kc then colors.Waist = suit end
	local pieces = { head, shield, cape, belt, boots }
	if cyborg then
		table.insert(pieces, function(m) -- metal left arm
			for _, n in { "LeftUpperArm", "LeftLowerArm", "LeftHand" } do local p = m:FindFirstChild(n); if p then p.Color = C(165, 170, 180); p.Material = Enum.Material.Metal end end
		end)
	end
	return { colors = colors, pieces = pieces }
end
