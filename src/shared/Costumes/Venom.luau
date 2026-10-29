-- Venom: sculpted symbiote head (skull + wide jaw) with huge angular white eyes that sweep up and back,
-- a mouth stretched across the jaw with two rows of fangs following its curve and a long hanging tongue,
-- the giant white spider whose legs reach over the shoulders (back spider too), white hand patches, back tendrils.
-- Variants: Agent Venom (masked, tactical straps/belt/holsters), Anti-Venom (white with black), Carnage (red + black
-- swirls, no spider), Toxin (blue + red streaks), King in Black (Knull: pale face, long black hair, spiked armor).
-- Costume module: return function(s, H, rarity) -> { colors = { group = Color3 }, pieces = { { "Piece", args... } | function(m) end } }
return function(s, H, rarity)
	local C, WHITE, piece, round, band, find = H.C, H.WHITE, H.piece, H.round, H.band, H.find
	local V, CF = Vector3.new, CFrame.new
	local GUM, TONGUE, TOOTH = C(70, 10, 22), C(205, 70, 100), C(245, 242, 232)
	local cfg = ({
		Common = { mouth = true, spider = s.Secondary, eye = WHITE, hands = s.Secondary, tendrils = true },
		Rare = { spider = WHITE, eye = WHITE, hands = WHITE, tactical = s.Secondary },
		Epic = { spider = s.Secondary, eye = s.Secondary, eyeRim = s.Secondary, hands = s.Secondary, mouth = false },
		Legendary = { mouth = true, eye = WHITE, swirls = s.Secondary, tendrils = true },
		Mythic = { mouth = true, eye = WHITE, swirls = s.Secondary, tendrils = true, spider = s.Secondary },
		Secret = { knull = true, eye = s.Secondary, spikes = true, tendrils = true },
	})[rarity] or {}
	local body = s.Primary

	local function faceOn(p, n, tilt)
		local z = -n.Unit
		local x = V(0, 1, 0):Cross(z).Unit
		return CFrame.fromMatrix(p, x, z:Cross(x), z) * CFrame.Angles(0, 0, tilt or 0)
	end
	local function ell(c, r)
		return function(x, y, out, back)
			local u, v = (x - c.X) / r.X, (y - c.Y) / r.Y
			local w = math.sqrt(math.max(0.03, 1 - u * u - v * v))
			local z = c.Z + (back and 1 or -1) * r.Z * w
			local n = V((x - c.X) / r.X ^ 2, (y - c.Y) / r.Y ^ 2, (z - c.Z) / r.Z ^ 2).Unit
			return V(x, y, z) + n * (out or 0), n, u * u + v * v
		end
	end
	local function multi(list)
		return function(x, y, out, back)
			local bp, bn
			for _, f in list do
				local p, n, q = f(x, y, 0, back)
				if q < 1 and (not bp or (back and p.Z > bp.Z) or (not back and p.Z < bp.Z)) then bp, bn = p, n end
			end
			if not bp then bp, bn = list[1](x, y, 0, back) end
			return bp + bn * (out or 0), bn
		end
	end
	local function bar(m, a, p0, p1, n, w, color, t)
		local d = p1 - p0
		local y = d.Unit
		local x = y:Cross(-n).Unit
		return piece(m, a, "Bar", V(w, d.Magnitude + w * 0.5, t or 0.05), CFrame.fromMatrix((p0 + p1) / 2, x, y, x:Cross(y)), color)
	end
	local function path(m, a, surf, pts, w, color, out, back)
		local prev, pn = surf(pts[1][1], pts[1][2], out, back)
		for i = 2, #pts do
			local q, qn = surf(pts[i][1], pts[i][2], out, back)
			bar(m, a, prev, q, pn + qn, w * (1 - (i - 2) / (#pts * 1.6)), color)
			prev, pn = q, qn
		end
	end
	local function wedgeP(m, a, name, size, cf, color, mat)
		local w = piece(m, a, name, size, cf, color, mat)
		Instance.new("SpecialMesh", w).MeshType = Enum.MeshType.Wedge
		return w
	end

	local pieces = {}
	local function add(f) table.insert(pieces, f) end

	-- ===== head =====
	add(function(m)
		local hd = find(m, "Head"); if not hd then return end
		local s0 = hd.Size.X
		hd.Transparency = 1
		local headCol = cfg.knull and C(225, 225, 220) or body
		local sc, sr = V(0, s0 * 0.1, s0 * 0.04), V(s0 * 0.44, s0 * 0.5, s0 * 0.5)
		local jc, jr = V(0, -s0 * 0.2, -s0 * 0.06), V(s0 * 0.5, s0 * 0.33, s0 * 0.47)
		round(m, hd, "Skull", sr * 2, CF(sc), headCol)
		round(m, hd, "Jaw", jr * 2, CF(jc), headCol)
		band(m, hd, "Neck", s0 * 0.85, s0 * 0.5, CF(0, -s0 * 0.48, 0.05), body)
		local skull, jaw = ell(sc, sr), ell(jc, jr)
		local face = multi({ skull, jaw })
		if cfg.knull then -- Knull: pale face, black-ringed eyes, black lips, long black hair, spiked crown
			for _, x in { -1, 1 } do
				local p, n = face(x * s0 * 0.17, s0 * 0.1, 0)
				round(m, hd, "EyeRing", V(s0 * 0.24, s0 * 0.16, 0.05), faceOn(p, n, x * math.rad(-15)), C(15, 15, 18))
				round(m, hd, "Eye", V(s0 * 0.12, s0 * 0.06, 0.05), faceOn(p + n * 0.015, n, x * math.rad(-15)), cfg.eye, Enum.Material.SmoothPlastic)
			end
			local mp, mn = face(0, -s0 * 0.28, 0)
			round(m, hd, "Lips", V(s0 * 0.3, s0 * 0.07, 0.05), faceOn(mp, mn), C(20, 18, 20))
			local np, nn = face(0, -s0 * 0.06, 0)
			round(m, hd, "Nose", V(s0 * 0.1, s0 * 0.16, s0 * 0.1), faceOn(np, nn), headCol:Lerp(C(0, 0, 0), 0.08))
			local hair = C(12, 12, 14)
			round(m, hd, "Hair", V(s0 * 0.96, s0 * 0.5, s0 * 1.06), CF(0, s0 * 0.4, s0 * 0.05), hair)
			round(m, hd, "HairBack", V(s0 * 1.0, s0 * 1.6, s0 * 0.55), CF(0, -s0 * 0.35, s0 * 0.32), hair)
			for _, x in { -1, 1 } do round(m, hd, "HairSide", V(s0 * 0.26, s0 * 1.2, s0 * 0.5), CF(x * s0 * 0.44, -s0 * 0.2, s0 * 0.12), hair) end
			for i = -2, 2 do
				wedgeP(m, hd, "CrownSpike", V(0.08, s0 * (0.5 - math.abs(i) * 0.08), s0 * 0.16), CF(i * s0 * 0.18, s0 * 0.68, s0 * 0.05) * CFrame.Angles(0, 0, math.rad(-i * 12)), C(20, 20, 24))
			end
			return
		end
		-- eyes: big white shapes with a pointed tail sweeping up/back
		for _, x in { -1, 1 } do
			local p, n = skull(x * s0 * 0.2, s0 * 0.14, 0)
			local tilt = x * math.rad(28)
			if cfg.eyeRim then round(m, hd, "EyeRim", V(s0 * 0.42, s0 * 0.3, 0.08), faceOn(p, n, tilt), C(20, 20, 25)) end
			round(m, hd, "Eye", V(s0 * 0.36, s0 * 0.24, 0.1), faceOn(p + n * 0.01, n, tilt), cfg.eyeRim and body or cfg.eye, Enum.Material.SmoothPlastic)
			local q, qn = skull(x * s0 * 0.36, s0 * 0.3, 0)
			wedgeP(m, hd, "EyeTail", V(0.06, s0 * 0.24, s0 * 0.12), faceOn(q, qn, x * math.rad(-50)) * CFrame.Angles(0, math.rad(90), 0), cfg.eyeRim and body or cfg.eye, Enum.Material.SmoothPlastic)
		end
		if cfg.mouth then -- grin stretched across the jaw, fangs following the curve, long tongue
			local mp, mn = jaw(0, -s0 * 0.2, 0)
			round(m, hd, "Mouth", V(s0 * 0.88, s0 * 0.3, 0.06), faceOn(mp, mn), GUM)
			for row, y in { -0.1, -0.31 } do
				for i = -4, 4 do
					local tx = i * s0 * 0.09
					local yy = y * s0 + (row == 1 and 1 or -1) * math.abs(i) * s0 * 0.012
					local p, n = jaw(tx, yy, 0.01)
					wedgeP(m, hd, "Fang", V(0.05, s0 * (0.15 - math.abs(i) * 0.01), s0 * 0.075), faceOn(p + n * 0.02, n) * CFrame.Angles(0, math.rad(90), 0) * CFrame.Angles(row == 1 and math.pi or 0, 0, 0), TOOTH)
				end
			end
			local tp, tn = jaw(s0 * 0.04, -s0 * 0.28, 0.02)
			round(m, hd, "Tongue", V(s0 * 0.17, s0 * 0.46, s0 * 0.12), faceOn(tp, tn) * CF(0, -s0 * 0.12, -0.02) * CFrame.Angles(math.rad(25), 0, 0), TONGUE)
			round(m, hd, "TongueTip", V(s0 * 0.13, s0 * 0.3, s0 * 0.1), faceOn(tp, tn) * CF(s0 * 0.04, -s0 * 0.38, -s0 * 0.1) * CFrame.Angles(math.rad(-20), 0, math.rad(-15)), TONGUE)
		end
	end)

	-- ===== torso: spider (wrapping over the shoulders), tactical gear, swirls, spikes, tendrils =====
	add(function(m)
		local t = find(m, "UpperTorso"); if not t then return end
		local sz = t.Size
		local X, Y = sz.X, sz.Y
		local pd = sz.Z * 0.285
		local list = { ell(V(0, Y * 0.1, 0), V(X * 0.49, Y * 0.475, sz.Z * 0.5)), ell(V(0, -Y * 0.2, 0), V(X * 0.36, Y * 0.375, sz.Z * 0.46)) }
		for _, x in { -1, 1 } do table.insert(list, ell(V(x * X * 0.21, Y * 0.24, -sz.Z * 0.5 + pd / 2 - 0.015), V(X * 0.25, Y * 0.13, pd / 2))) end
		local surf = multi(list)
		if cfg.spider then
			local col = cfg.spider
			local p, n = surf(0, Y * 0.12, 0.04)
			round(m, t, "SpiderBody", V(X * 0.13, Y * 0.36, 0.1), faceOn(p, n), col)
			local hp, hn = surf(0, Y * 0.36, 0.05)
			round(m, t, "SpiderHead", V(X * 0.1, Y * 0.14, 0.1), faceOn(hp, hn), col)
			for _, x in { -1, 1 } do
				-- upper legs climb over the shoulders, lower legs wrap round the ribs
				path(m, t, surf, { { x * X * 0.04, Y * 0.3 }, { x * X * 0.16, Y * 0.36 }, { x * X * 0.22, Y * 0.5 } }, X * 0.07, col, 0.04)
				path(m, t, surf, { { x * X * 0.05, Y * 0.22 }, { x * X * 0.26, Y * 0.3 }, { x * X * 0.4, Y * 0.42 } }, X * 0.07, col, 0.04)
				path(m, t, surf, { { x * X * 0.05, Y * 0.05 }, { x * X * 0.24, Y * -0.02 }, { x * X * 0.38, Y * -0.12 } }, X * 0.07, col, 0.04)
				path(m, t, surf, { { x * X * 0.04, -Y * 0.02 }, { x * X * 0.16, -Y * 0.16 }, { x * X * 0.24, -Y * 0.34 } }, X * 0.06, col, 0.04)
				-- legs continue down the back
				path(m, t, surf, { { x * X * 0.22, Y * 0.5 }, { x * X * 0.2, Y * 0.2 }, { x * X * 0.1, -Y * 0.1 } }, X * 0.06, col, 0.04, true)
			end
			local bp, bn = surf(0, Y * 0.0, 0.04, true)
			round(m, t, "BackSpider", V(X * 0.12, Y * 0.32, 0.1), faceOn(bp, bn), col)
		end
		if cfg.tactical then -- Agent Venom: chest straps, belt with pouches, thigh holsters
			for _, x in { -1, 1 } do
				path(m, t, surf, { { x * X * 0.32, Y * 0.48 }, { x * X * 0.1, Y * 0.0 }, { -x * X * 0.18, -Y * 0.45 } }, X * 0.06, cfg.tactical, 0.06)
			end
			local w = find(m, "LowerTorso")
			if w then
				local ws = w.Size
				round(m, w, "Belt", V(ws.X * 1.02, ws.Y * 0.7, ws.Z * 1.08), CF(0, ws.Y * 0.3, 0), cfg.tactical)
				for _, x in { -0.32, -0.12, 0.12, 0.32 } do piece(m, w, "Pouch", V(ws.X * 0.14, ws.Y * 0.8, 0.2), CF(x * ws.X, ws.Y * 0.2, -ws.Z * 0.5), cfg.tactical:Lerp(C(0, 0, 0), 0.3)) end
			end
			for _, n in { "LeftUpperLeg", "RightUpperLeg" } do
				local ul = m:FindFirstChild(n)
				if ul then
					local x = n:find("Left") and -1 or 1
					band(m, ul, "ThighStrap", ul.Size.X * 1.1, ul.Size.Y * 0.08, CF(0, -ul.Size.Y * 0.1, 0), cfg.tactical)
					piece(m, ul, "Holster", V(0.2, ul.Size.Y * 0.45, ul.Size.Z * 0.5), CF(x * ul.Size.X * 0.56, -ul.Size.Y * 0.08, 0), C(30, 30, 34))
				end
			end
		end
		if cfg.spikes then -- Knull: spiked shoulders
			for _, x in { -1, 1 } do
				for k = 0, 2 do
					wedgeP(m, t, "Spike", V(0.12, Y * 0.42, X * 0.08), CF(x * X * (0.36 + k * 0.06), Y * 0.5, (k - 1) * sz.Z * 0.25) * CFrame.Angles(0, 0, math.rad(-x * (20 + k * 12))), C(25, 25, 30))
				end
			end
		end
		if cfg.tendrils then -- symbiote tendrils reaching off the back
			for i, d in { { -1, 0.3, 40 }, { 1, 0.25, 35 }, { -1, -0.1, 60 }, { 1, -0.15, 65 } } do
				local base = V(d[1] * X * 0.22, Y * d[2], sz.Z * 0.42)
				local mid = base + V(d[1] * X * 0.12, Y * 0.18, sz.Z * 0.55)
				local tip = mid + V(d[1] * X * 0.14, -Y * 0.2, sz.Z * 0.35)
				for _, sgm in { { base, mid, 0.26 }, { mid, tip, 0.17 } } do -- rounded, tapering tendril segments
					local a0, a1 = sgm[1], sgm[2]
					round(m, t, "Tendril", V(sgm[3], sgm[3], (a1 - a0).Magnitude * 1.25), CFrame.lookAt((a0 + a1) / 2, a1), body)
				end
			end
		end
		if cfg.swirls then -- Carnage / Toxin: streaks wrapping chest and limbs
			for _, d in { { -0.4, 0.42, 0.1, 0.15, 0.3, -0.3 }, { 0.38, 0.35, -0.05, -0.05, -0.2, -0.45 }, { -0.1, 0.45, 0.25, 0.2, 0.42, 0.0 } } do
				path(m, t, surf, { { d[1] * X, d[2] * Y }, { d[3] * X, d[4] * Y }, { d[5] * X, d[6] * Y } }, X * 0.045, cfg.swirls, 0.03)
			end
			for _, n in { "LeftUpperArm", "RightUpperArm", "LeftLowerArm", "RightLowerArm", "LeftUpperLeg", "RightUpperLeg", "LeftLowerLeg", "RightLowerLeg" } do
				local a = m:FindFirstChild(n)
				if a then
					local s2 = a.Size
					round(m, a, "Swirl", V(s2.X * 1.12, 0.06, s2.Z * 1.14), CF(0, s2.Y * 0.1, 0) * CFrame.Angles(math.rad(28), 0, math.rad(12)), cfg.swirls)
				end
			end
		end
	end)

	-- ===== white hand patches =====
	if cfg.hands then
		add(function(m)
			for _, n in { "LeftHand", "RightHand" } do
				local h = m:FindFirstChild(n)
				if h then
					local x = n:find("Left") and -1 or 1
					round(m, h, "HandPatch", V(h.Size.X * 0.22, h.Size.Y * 1.5, h.Size.Z * 0.7), CF(x * h.Size.X * 0.36, -h.Size.Y * 0.5, 0), cfg.hands)
				end
			end
		end)
	end

	return {
		colors = { Head = body, Chest = body, Waist = body, Arms = body, Hands = body, Legs = body, Feet = body },
		pieces = pieces,
	}
end
