-- Captain America: sculpted head with the blue cowl covering the head down to the nose (eye holes, white A built from
-- bars, small white temple wings), exposed jaw/mouth; chest star built from wedge triangles on the chest surface;
-- red/white vertical stripes wrapping the midsection; brown belt with pouches; flared red gauntlets and boots.
-- Variants: WWII (leather helmet + chinstrap, navy + brown straps), Stealth (navy/silver, no stripes),
-- Sam Wilson (red goggles, falcon wings), Captain Carter (no cowl, hair, Union Jack), Hydra Supreme (black/red hydra).
-- Costume module: return function(s, H, rarity) -> { colors = { group = Color3 }, pieces = { { "Piece", args... } | function(m) end } }
return function(s, H, rarity)
	local C, SKIN, WHITE, piece, round, band, find = H.C, H.SKIN, H.WHITE, H.piece, H.round, H.band, H.find
	local V, CF = Vector3.new, CFrame.new
	local RED, BROWN, METAL, LEATHER = C(200, 30, 40), C(105, 70, 45), Enum.Material.Metal, Enum.Material.Leather
	local cfg = ({
		Common = { suit = s.Primary, cowl = s.Primary, star = WHITE, stripes = { s.Secondary, WHITE }, gloves = s.Secondary, boots = s.Secondary, belt = BROWN, A = WHITE, wings = WHITE },
		Rare = { suit = s.Secondary, cowl = s.Primary, star = WHITE, stripes = { RED, WHITE }, gloves = s.Primary, boots = s.Primary, belt = s.Primary, A = WHITE, helmet = true, straps = s.Primary },
		Epic = { suit = s.Primary, cowl = s.Primary, star = s.Secondary, gloves = C(30, 32, 40), boots = C(30, 32, 40), belt = C(40, 42, 50), straps = s.Secondary, accent = s.Secondary },
		Legendary = { suit = s.Primary, cowl = s.Secondary, star = s.Secondary, stripes = { RED, WHITE }, gloves = s.Secondary, boots = s.Secondary, belt = C(60, 60, 70), goggles = RED, falcon = true, skin = C(120, 80, 55), legs = s.Secondary },
		Mythic = { suit = s.Primary, star = WHITE, unionJack = true, gloves = s.Secondary, boots = s.Secondary, belt = C(140, 100, 60), hair = C(105, 55, 35), lips = C(180, 40, 50) },
		Secret = { suit = s.Primary, cowl = s.Primary, hydra = s.Secondary, gloves = s.Primary, boots = s.Primary, belt = C(40, 40, 45), A = s.Secondary, wings = s.Secondary, accent = s.Secondary },
	})[rarity] or {}
	local suit = cfg.suit or s.Primary
	local skin = cfg.skin or SKIN

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
		return function(x, y, out)
			local bp, bn
			for _, f in list do
				local p, n, q = f(x, y, 0)
				if q < 1 and (not bp or p.Z < bp.Z) then bp, bn = p, n end
			end
			if not bp then bp, bn = list[1](x, y, 0) end
			return bp + bn * (out or 0), bn
		end
	end
	-- flat isosceles triangle (apex toward local +Y) from two wedge halves, facing -Z of cf
	local function tri(m, a, name, cf, w, h, color, mat)
		local l = piece(m, a, name, V(0.05, h, w / 2), cf * CF(-w / 4, 0, 0) * CFrame.Angles(0, math.rad(90), 0), color, mat)
		Instance.new("SpecialMesh", l).MeshType = Enum.MeshType.Wedge
		local r = piece(m, a, name, V(0.05, w / 2, h), cf * CF(w / 4, 0, 0) * CFrame.Angles(0, 0, math.rad(-90)) * CFrame.Angles(0, math.rad(90), 0), color, mat)
		Instance.new("SpecialMesh", r).MeshType = Enum.MeshType.Wedge
	end
	local function star(m, a, cf, k, color)
		round(m, a, "StarCore", V(k * 1.3, k * 1.3, 0.06), cf, color)
		for i = 0, 4 do tri(m, a, "StarRay", cf * CFrame.Angles(0, 0, math.rad(i * 72)) * CF(0, k * 0.95, 0), k * 0.9, k * 1.15, color) end
	end
	local function bar(m, a, p0, p1, n, w, color) -- straight strip between two surface points
		local d = p1 - p0
		local y = d.Unit
		local x = y:Cross(-n).Unit
		return piece(m, a, "Bar", V(w, d.Magnitude + w * 0.5, 0.05), CFrame.fromMatrix((p0 + p1) / 2, x, y, x:Cross(y)), color)
	end

	-- strip that follows a surface: chain of bars through n+1 samples between (x0,y0) and (x1,y1)
	local function path(m, a, surf, x0, y0, x1, y1, n, w, color, out)
		local prev, pn = surf(x0, y0, out)
		for i = 1, n do
			local q, qn = surf(x0 + (x1 - x0) * i / n, y0 + (y1 - y0) * i / n, out)
			bar(m, a, prev, q, pn + qn, w, color)
			prev, pn = q, qn
		end
	end

	local pieces = {}
	local function add(f) table.insert(pieces, f) end

	-- ===== head =====
	add(function(m)
		local hd = find(m, "Head"); if not hd then return end
		local s0 = hd.Size.X
		hd.Transparency = 1
		local cy = s0 * 0.05
		local R = V(s0 * 0.43, s0 * 0.52, s0 * 0.48)
		round(m, hd, "Skull", R * 2, CF(0, cy, 0), skin)
		local jc, jr = V(0, -s0 * 0.22, -s0 * 0.08), V(s0 * 0.35, s0 * 0.26, s0 * 0.39)
		round(m, hd, "Jaw", jr * 2, CF(jc), skin)
		local mask = cfg.cowl
		band(m, hd, "Neck", s0 * 0.56, s0 * 0.5, CF(0, -s0 * 0.5, 0.03), mask or skin)
		local face = multi({ ell(V(0, cy, 0), R), ell(jc, jr) })
		local mc, mr = V(0, s0 * 0.13, 0.0), V(s0 * 0.46, s0 * 0.44, s0 * 0.51)
		local cowl = ell(mc, mr)
		if mask then
			round(m, hd, "Cowl", mr * 2, CF(mc), mask, cfg.helmet and LEATHER or nil)
			round(m, hd, "CowlBack", V(s0 * 0.9, s0 * 0.8, s0 * 0.74), CF(0, -s0 * 0.16, s0 * 0.13), mask, cfg.helmet and LEATHER or nil)
			if cfg.helmet then -- WWII: leather helmet rim + chinstrap
				round(m, hd, "HelmetRim", V(s0 * 0.98, s0 * 0.08, s0 * 1.06), CF(0, s0 * 0.12, 0), mask:Lerp(C(0, 0, 0), 0.25), LEATHER)
				round(m, hd, "Chinstrap", V(s0 * 0.86, s0 * 0.94, 0.06), CF(0, -s0 * 0.12, -s0 * 0.02), mask:Lerp(C(0, 0, 0), 0.25), LEATHER)
			end
		elseif cfg.hair then -- Captain Carter: wavy shoulder-length hair
			round(m, hd, "Hair", V(s0 * 0.94, s0 * 0.6, s0 * 1.02), CF(0, s0 * 0.3, s0 * 0.04), cfg.hair)
			round(m, hd, "HairBack", V(s0 * 0.96, s0 * 1.05, s0 * 0.56), CF(0, -s0 * 0.12, s0 * 0.24), cfg.hair)
			for _, x in { -1, 1 } do round(m, hd, "Curl", V(s0 * 0.3, s0 * 0.7, s0 * 0.5), CF(x * s0 * 0.4, -s0 * 0.2, s0 * 0.1), cfg.hair) end
		end
		-- eyes (in eye holes when masked)
		local srf = mask and cowl or face
		for _, x in { -1, 1 } do
			local p, n = srf(x * s0 * 0.16, s0 * 0.05, 0)
			if cfg.goggles then
				round(m, hd, "Goggle", V(s0 * 0.26, s0 * 0.18, 0.1), faceOn(p, n, x * math.rad(8)), cfg.goggles, Enum.Material.SmoothPlastic)
			else
				if mask then round(m, hd, "EyeHole", V(s0 * 0.24, s0 * 0.14, 0.05), faceOn(p, n), skin) end
				round(m, hd, "Sclera", V(s0 * 0.16, s0 * 0.075, 0.05), faceOn(p + n * 0.01, n), C(250, 250, 250), Enum.Material.SmoothPlastic)
				round(m, hd, "Iris", V(s0 * 0.065, s0 * 0.07, 0.04), faceOn(p + n * 0.022, n), C(70, 120, 190), Enum.Material.SmoothPlastic)
				if not mask then
					local bp, bn = face(x * s0 * 0.16, s0 * 0.15, 0.01)
					piece(m, hd, "Brow", V(s0 * 0.2, s0 * 0.035, 0.04), faceOn(bp, bn, -x * math.rad(6)), (cfg.hair or C(60, 40, 30)):Lerp(C(0, 0, 0), 0.3))
				end
			end
		end
		local np, nn = face(0, -s0 * 0.06, 0)
		local nose = piece(m, hd, "Nose", V(s0 * 0.1, s0 * 0.14, 0.1), faceOn(np, nn) * CF(0, 0, -0.035), skin)
		Instance.new("SpecialMesh", nose).MeshType = Enum.MeshType.Wedge
		local mp, mn = face(0, -s0 * 0.26, 0)
		piece(m, hd, "Mouth", V(s0 * 0.2, s0 * (cfg.lips and 0.05 or 0.03), 0.04), faceOn(mp, mn), cfg.lips or C(150, 90, 75))
		if not cfg.lips then piece(m, hd, "Cleft", V(0.025, s0 * 0.05, 0.03), faceOn(face(0, -s0 * 0.38, 0.005)), skin:Lerp(C(0, 0, 0), 0.4)) end
		-- forehead A built from bars, temple wings
		if cfg.A then
			local function at(x, y) return cowl(x * s0, y * s0, 0.012) end
			local t0, tn = at(0, 0.44)
			local l0, ln = at(-0.11, 0.21)
			local r0, rn = at(0.11, 0.21)
			bar(m, hd, l0, t0, ln + tn, s0 * 0.07, cfg.A)
			bar(m, hd, r0, t0, rn + tn, s0 * 0.07, cfg.A)
			local c0, cn = at(-0.06, 0.29)
			local c1 = at(0.06, 0.29)
			bar(m, hd, c0, c1, cn, s0 * 0.05, cfg.A)
		end
		if cfg.wings then
			for _, x in { -1, 1 } do
				for k = 0, 2 do
					local len = s0 * (0.36 - k * 0.07)
					round(m, hd, "Wing", V(0.05, s0 * 0.09, len), CF(x * s0 * 0.45, s0 * (0.24 - k * 0.07), s0 * 0.02)
						* CFrame.Angles(math.rad(-10 - k * 8), x * math.rad(8), 0) * CF(0, 0, len * 0.42), cfg.wings)
				end
			end
		end
	end)

	-- ===== torso: star / union jack / hydra, stripes, belt, straps, falcon wings =====
	add(function(m)
		local t = find(m, "UpperTorso"); if not t then return end
		local sz = t.Size
		local pd = sz.Z * 0.25
		local list = { ell(V(0, sz.Y * 0.1, 0), V(sz.X * 0.49, sz.Y * 0.475, sz.Z * 0.5)), ell(V(0, -sz.Y * 0.2, 0), V(sz.X * 0.36, sz.Y * 0.375, sz.Z * 0.46)) }
		for _, x in { -1, 1 } do table.insert(list, ell(V(x * sz.X * 0.21, sz.Y * 0.24, -sz.Z * 0.5 + pd / 2 - 0.015), V(sz.X * 0.25, sz.Y * 0.13, pd / 2))) end
		local surf = multi(list)
		if cfg.unionJack then
			local X, Y = sz.X, sz.Y
			for _, d in { { -0.36, 0.44, 0.36, -0.12 }, { 0.36, 0.44, -0.36, -0.12 } } do
				path(m, t, surf, d[1] * X, d[2] * Y, d[3] * X, d[4] * Y, 3, X * 0.09, WHITE, 0.03)
				path(m, t, surf, d[1] * X, d[2] * Y, d[3] * X, d[4] * Y, 3, X * 0.035, RED, 0.05)
			end
			path(m, t, surf, 0, 0.46 * Y, 0, -0.14 * Y, 2, X * 0.14, WHITE, 0.07)
			path(m, t, surf, 0, 0.46 * Y, 0, -0.14 * Y, 2, X * 0.08, RED, 0.09)
			path(m, t, surf, -0.42 * X, 0.16 * Y, 0.42 * X, 0.16 * Y, 3, Y * 0.13, WHITE, 0.07)
			path(m, t, surf, -0.42 * X, 0.16 * Y, 0.42 * X, 0.16 * Y, 3, Y * 0.075, RED, 0.09)
		elseif cfg.hydra then -- red hydra: skull disc with six curling tentacles
			local p, n = surf(0, sz.Y * 0.2, 0.04)
			local cf = faceOn(p, n)
			round(m, t, "HydraSkull", V(sz.X * 0.16, sz.X * 0.17, 0.08), cf, cfg.hydra)
			for i = 0, 5 do
				local a = math.rad(i * 60 + 30)
				local q0 = surf(math.cos(a) * sz.X * 0.07, sz.Y * 0.2 + math.sin(a) * sz.X * 0.07, 0.04)
				local q1, qn = surf(math.cos(a + 0.35) * sz.X * 0.17, sz.Y * 0.2 + math.sin(a + 0.35) * sz.X * 0.17, 0.04)
				local q2, q2n = surf(math.cos(a + 0.95) * sz.X * 0.22, sz.Y * 0.2 + math.sin(a + 0.95) * sz.X * 0.22, 0.04)
				bar(m, t, q0, q1, qn, sz.X * 0.05, cfg.hydra)
				bar(m, t, q1, q2, qn + q2n, sz.X * 0.035, cfg.hydra)
			end
		elseif cfg.star then
			local p, n = surf(0, sz.Y * 0.18, 0.04)
			star(m, t, faceOn(p, n), sz.X * 0.1, cfg.star)
		end
		if cfg.stripes then
			for i = -3, 3 do
				local x = i * sz.X * 0.1
				path(m, t, surf, x, -sz.Y * 0.02, x, -sz.Y * 0.52, 2, sz.X * 0.102, cfg.stripes[(i % 2) + 1], 0.02)
			end
		end
		if cfg.straps then -- shoulder straps down to the belt
			for _, x in { -1, 1 } do
				local a0, an = surf(x * sz.X * 0.24, sz.Y * 0.48, 0.03)
				local a1, bn = surf(x * sz.X * 0.2, -sz.Y * 0.48, 0.03)
				bar(m, t, a0, a1, an + bn, sz.X * 0.08, cfg.straps)
				piece(m, t, "StrapBack", V(sz.X * 0.08, sz.Y * 0.95, 0.06), CF(x * sz.X * 0.24, 0, sz.Z * 0.52), cfg.straps)
			end
		end
		if cfg.falcon then -- Sam Wilson: folded falcon wings on the back
			for _, x in { -1, 1 } do
				for k = 0, 2 do
					local len = sz.Y * (1.6 - k * 0.3)
					round(m, t, "FalconWing", V(sz.X * 0.22, len, 0.12), CF(x * sz.X * 0.12, sz.Y * 0.35, sz.Z * 0.62 + k * 0.05)
						* CFrame.Angles(0, 0, x * math.rad(28 + k * 12)) * CF(0, -len * 0.42, 0), k == 1 and RED or C(225, 228, 235), METAL)
				end
			end
			round(m, t, "WingPack", V(sz.X * 0.42, sz.Y * 0.5, sz.Z * 0.3), CF(0, sz.Y * 0.18, sz.Z * 0.55), C(80, 82, 90), METAL)
		end
		local w = find(m, "LowerTorso")
		if w then
			local ws = w.Size
			round(m, w, "Belt", V(ws.X * 1.0, ws.Y * 0.75, ws.Z * 1.07), CF(0, ws.Y * 0.32, 0), cfg.belt, LEATHER)
			piece(m, w, "Buckle", V(ws.X * 0.16, ws.Y * 0.6, 0.08), CF(0, ws.Y * 0.32, -ws.Z * 0.54), C(200, 200, 210), METAL)
			for _, x in { -0.28, 0.28 } do
				round(m, w, "Pouch", V(ws.X * 0.15, ws.Y * 0.9, ws.Z * 0.25), CF(x * ws.X, ws.Y * 0.22, -ws.Z * 0.45), cfg.belt:Lerp(C(0, 0, 0), 0.1), LEATHER)
			end
		end
	end)

	-- ===== flared gauntlet / boot cuffs =====
	add(function(m)
		for _, side in { "Left", "Right" } do
			local la = m:FindFirstChild(side .. "LowerArm")
			if la then
				band(m, la, "GloveCuff", la.Size.X * 1.22, la.Size.Y * 0.16, CF(0, la.Size.Y * 0.08, 0), cfg.gloves, LEATHER)
			end
			local ll = m:FindFirstChild(side .. "LowerLeg")
			if ll then
				local sz = ll.Size
				round(m, ll, "BootCuff", V(sz.X * 1.22, sz.Y * 0.24, sz.Z * 1.3), CF(0, sz.Y * 0.36, sz.Z * 0.05), cfg.boots, LEATHER)
			end
			if cfg.accent then
				local ua = m:FindFirstChild(side .. "UpperArm")
				if ua then band(m, ua, "ArmBand", ua.Size.X * 1.08, ua.Size.Y * 0.08, CF(0, ua.Size.Y * 0.05, 0), cfg.accent) end
			end
		end
	end)

	local legs = cfg.legs or suit
	return {
		colors = { Head = skin, Chest = suit, Waist = legs, UpperArms = suit, LowerArms = cfg.gloves, Hands = cfg.gloves, UpperLegs = legs, LowerLegs = cfg.boots, Feet = cfg.boots },
		pieces = pieces,
	}
end
