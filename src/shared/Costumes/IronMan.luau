-- Iron Man: sculpted metal armor. Rounded helmet with a raised shield-shaped faceplate (angled eye slits, mouth line,
-- cheek seams, ear discs), arc reactor in a housing, rounded pauldrons, gauntlet cuffs, kneecaps, back thruster pods.
-- Mark VI (red/gold, triangle reactor), Mark I (gray bucket helmet + rivets), Hulkbuster (bulky shells over every limb),
-- Iron Patriot (navy/red/silver + star), Mark 85 (red/gold, round reactor), Superior (white/gold).
-- Costume module: return function(s, H, rarity) -> { colors = { group = Color3 }, pieces = { { "Piece", args... } | function(m) end } }
return function(s, H, rarity)
	local C, WHITE, piece, round, band, find, glyph = H.C, H.WHITE, H.piece, H.round, H.band, H.find, H.glyph
	local V, CF = Vector3.new, CFrame.new
	local METAL = Enum.Material.Metal
	local SEAM = C(35, 30, 32)
	local cfg = ({
		Common = { main = s.Primary, accent = s.Secondary, plate = s.Secondary, reactor = "tri" },
		Rare = { main = s.Primary, accent = s.Secondary, plate = s.Primary, reactor = "round", mk1 = true },
		Epic = { main = s.Primary, accent = s.Secondary, plate = s.Secondary, reactor = "round", bulk = true },
		Legendary = { main = s.Primary, accent = s.Secondary, plate = C(200, 205, 215), reactor = "round", star = true, arms = s.Secondary, legs = s.Secondary },
		Mythic = { main = s.Primary, accent = s.Secondary, plate = s.Secondary, reactor = "round", goldPads = true },
		Secret = { main = s.Primary, accent = s.Secondary, plate = s.Secondary, reactor = "round", eye = C(170, 220, 255) },
	})[rarity] or { main = s.Primary, accent = s.Secondary, plate = s.Secondary, reactor = "tri" }
	local main, accent = cfg.main, cfg.accent
	local EYE = cfg.eye or C(235, 245, 255)

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
			return V(x, y, z) + n * (out or 0), n
		end
	end
	local function seg(m, a, name, p0, p1, n, w, t, color, mat)
		local d = p1 - p0
		local y = d.Unit
		local x = y:Cross(-n).Unit
		return piece(m, a, name, V(w, d.Magnitude, t), CFrame.fromMatrix((p0 + p1) / 2, x, y, x:Cross(y)), color, mat)
	end

	-- flat isosceles triangle (apex toward local +Y) from two wedge halves, facing -Z of cf
	local function tri(m, a, name, cf, w, h, color, mat)
		local t = 0.05
		local l = piece(m, a, name, V(t, h, w / 2), cf * CF(-w / 4, 0, 0) * CFrame.Angles(0, math.rad(90), 0), color, mat)
		Instance.new("SpecialMesh", l).MeshType = Enum.MeshType.Wedge
		local r = piece(m, a, name, V(t, w / 2, h), cf * CF(w / 4, 0, 0) * CFrame.Angles(0, 0, math.rad(-90)) * CFrame.Angles(0, math.rad(90), 0), color, mat)
		Instance.new("SpecialMesh", r).MeshType = Enum.MeshType.Wedge
	end

	local pieces = { { "Material", METAL } }
	local function add(f) table.insert(pieces, f) end

	-- ===== helmet =====
	add(function(m)
		local hd = find(m, "Head"); if not hd then return end
		local s0 = hd.Size.X
		hd.Transparency = 1
		band(m, hd, "Neck", s0 * 0.46, s0 * 0.5, CF(0, -s0 * 0.5, 0.02), SEAM, METAL)
		if cfg.mk1 then -- Mark I: riveted bucket with a flat slotted faceplate
			band(m, hd, "Bucket", s0 * 0.98, s0 * 0.9, CF(0, -s0 * 0.02, 0.02), main, METAL)
			round(m, hd, "Dome", V(s0 * 0.98, s0 * 0.4, s0 * 0.98), CF(0, s0 * 0.42, 0.02), main, METAL)
			piece(m, hd, "Faceplate", V(s0 * 0.66, s0 * 0.78, 0.14), CF(0, -s0 * 0.04, -s0 * 0.45), accent, METAL)
			for _, x in { -1, 1 } do
				piece(m, hd, "EyeSlit", V(s0 * 0.2, s0 * 0.06, 0.04), CF(x * s0 * 0.15, s0 * 0.12, -s0 * 0.53), SEAM)
				piece(m, hd, "Rivet", V(0.09, 0.09, 0.09), CF(x * s0 * 0.27, s0 * 0.3, -s0 * 0.53), C(150, 150, 155), METAL, Enum.PartType.Ball)
				piece(m, hd, "Rivet", V(0.09, 0.09, 0.09), CF(x * s0 * 0.27, -s0 * 0.36, -s0 * 0.53), C(150, 150, 155), METAL, Enum.PartType.Ball)
			end
			for i = -2, 2 do piece(m, hd, "Grille", V(0.04, s0 * 0.16, 0.04), CF(i * s0 * 0.06, -s0 * 0.24, -s0 * 0.53), SEAM) end
			return
		end
		local cy = s0 * 0.04
		local dome = V(s0 * 0.47, s0 * 0.55, s0 * 0.52)
		round(m, hd, "Helmet", dome * 2, CF(0, cy, 0.02), main, METAL)
		local pc, pr = V(0, -s0 * 0.04, -s0 * 0.28), V(s0 * 0.36, s0 * 0.42, s0 * 0.27)
		round(m, hd, "Faceplate", pr * 2, CF(pc), cfg.plate, METAL)
		round(m, hd, "Jaw", V(s0 * 0.46, s0 * 0.34, s0 * 0.42), CF(0, -s0 * 0.34, -s0 * 0.25), cfg.plate, METAL)
		local plate = ell(pc, pr)
		for _, x in { -1, 1 } do
			local p, n = plate(x * s0 * 0.15, s0 * 0.07, 0.005)
			piece(m, hd, "Eye", V(s0 * 0.21, s0 * 0.06, 0.05), faceOn(p, n, x * math.rad(12)), EYE, Enum.Material.SmoothPlastic)
			piece(m, hd, "EyeLid", V(s0 * 0.23, s0 * 0.025, 0.05), faceOn(p, n, x * math.rad(12)) * CF(0, s0 * 0.04, -0.005), main, METAL)
			-- cheek seams framing the faceplate
			local a0, n0 = plate(x * s0 * 0.3, -s0 * 0.02, 0.01)
			local a1, n1 = plate(x * s0 * 0.17, -s0 * 0.36, 0.01)
			seg(m, hd, "CheekSeam", a0, a1, n0 + n1, 0.03, 0.03, SEAM)
			band(m, hd, "EarDisc", s0 * 0.34, 0.08, CF(x * s0 * 0.46, -s0 * 0.02, s0 * 0.04) * CFrame.Angles(0, 0, math.rad(90)), main:Lerp(WHITE, 0.15), METAL)
		end
		local mp, mn = plate(0, -s0 * 0.25, 0.01)
		piece(m, hd, "Mouth", V(s0 * 0.22, 0.03, 0.03), faceOn(mp, mn), SEAM)
	end)

	-- ===== chest: reactor, pec seam, star, back thrusters =====
	add(function(m)
		local t = find(m, "UpperTorso"); if not t then return end
		local sz = t.Size
		local chest = ell(V(0, sz.Y * 0.1, 0), V(sz.X * 0.49, sz.Y * 0.475, sz.Z * 0.5))
		local p, n = chest(0, sz.Y * 0.12, 0)
		local d = sz.X * 0.2
		round(m, t, "ReactorHousing", V(d * 1.25, d * 1.25, 0.12), faceOn(p, n), C(70, 72, 80), METAL)
		if cfg.reactor == "tri" then
			local cf = faceOn(p + n * 0.1, n) * CFrame.Angles(0, 0, math.pi)
			tri(m, t, "ReactorFrame", cf * CF(0, 0, 0.005), d * 1.25, d * 1.05, C(140, 145, 155), METAL)
			tri(m, t, "Reactor", cf * CF(0, -d * 0.06, -0.02), d * 0.95, d * 0.8, C(200, 240, 255), Enum.Material.Neon)
			local l = Instance.new("PointLight"); l.Color = C(180, 230, 255); l.Range = 8; l.Parent = t
		else
			local g = round(m, t, "Reactor", V(d * 0.75, d * 0.75, 0.16), faceOn(p + n * 0.04, n), C(200, 240, 255), Enum.Material.Neon)
			local l = Instance.new("PointLight"); l.Color = C(180, 230, 255); l.Range = 8; l.Parent = g
		end
		if cfg.star then
			local sp, sn = chest(0, sz.Y * 0.36, 0.2)
			local k = sz.X * 0.1
			local cf = faceOn(sp, sn)
			round(m, t, "StarCore", V(k * 1.3, k * 1.3, 0.06), cf, WHITE)
			for i = 0, 4 do
				tri(m, t, "StarRay", cf * CFrame.Angles(0, 0, math.rad(i * 72)) * CF(0, k * 0.9, 0), k * 0.85, k * 1.1, WHITE)
			end
			for i = 0, 2 do -- red / white abdomen stripes
				round(m, t, "AbStripe", V(sz.X * 0.11, sz.Y * 0.5, sz.Z * 0.99), CF((i - 1) * sz.X * 0.12, -sz.Y * 0.22, 0), i == 1 and WHITE or accent, METAL)
			end
		end
		-- seam under the pecs and down the sternum (thin discs whose rims show)
		round(m, t, "PecSeam", V(sz.X * 0.98 * 1.03, 0.05, sz.Z * 1.03), CF(0, -sz.Y * 0.06, 0), SEAM)
		-- gold abdomen plate (Mark VI / 85 / Superior)
		for _, x in { -1, 1 } do
			-- shoulder-blade flaps + small exhaust nozzles at the small of the back
			round(m, t, "BackFlap", V(sz.X * 0.34, sz.Y * 0.42, sz.Z * 0.22), CF(x * sz.X * 0.2, sz.Y * 0.22, sz.Z * 0.43) * CFrame.Angles(0, 0, math.rad(x * 12)), main:Lerp(C(0, 0, 0), 0.18), METAL)
			band(m, t, "Nozzle", sz.X * 0.1, sz.Y * 0.12, CF(x * sz.X * 0.12, -sz.Y * 0.42, sz.Z * 0.42), C(70, 72, 80), METAL)
		end
		local w = find(m, "LowerTorso")
		if w then
			local ws = w.Size
			round(m, w, "BeltSeam", V(ws.X * 1.0, 0.07, ws.Z * 1.04), CF(0, ws.Y * 0.35, 0), SEAM)
			round(m, w, "Codpiece", V(ws.X * 0.34, ws.Y * 1.6, ws.Z * 0.5), CF(0, -ws.Y * 0.2, -ws.Z * 0.28), accent, METAL)
		end
		if cfg.mk1 then
			for _, x in { -1, 1 } do
				for _, y in { 0.35, -0.1 } do
					local rp, rn = chest(x * sz.X * 0.32, sz.Y * y, 0.02)
					piece(m, t, "Rivet", V(0.11, 0.11, 0.11), CF(rp), C(150, 150, 155), METAL, Enum.PartType.Ball)
				end
			end
			piece(m, t, "ChestPlate", V(sz.X * 0.7, sz.Y * 0.45, 0.1), CF(0, sz.Y * 0.18, -sz.Z * 0.52), cfg.accent, METAL)
		end
	end)

	-- ===== limbs: pauldrons, cuffs, kneecaps; Hulkbuster shells =====
	add(function(m)
		local B = cfg.bulk and 1.55 or 1
		for _, side in { "Left", "Right" } do
			local x = side == "Left" and -1 or 1
			local ua = m:FindFirstChild(side .. "UpperArm")
			if ua then
				local sz = ua.Size
				round(m, ua, "Pauldron", V(sz.X * 1.24 * B, sz.Y * 0.78 * B, sz.Z * 1.2 * B), CF(x * sz.X * 0.06 * B, sz.Y * 0.3 * B, 0), cfg.goldPads and accent or main, METAL)
				if cfg.bulk then band(m, ua, "ArmShell", sz.X * 1.55, sz.Y * 0.8, CF(0, -sz.Y * 0.1, 0), accent, METAL) end
			end
			local la = m:FindFirstChild(side .. "LowerArm")
			if la then
				local sz = la.Size
				band(m, la, "Cuff", sz.X * 1.05, sz.Y * 0.2, CF(0, -sz.Y * 0.38, 0), main, METAL)
				band(m, la, "CuffSeam", sz.X * 1.0, 0.04, CF(0, -sz.Y * 0.26, 0), SEAM)
				if cfg.bulk then
					band(m, la, "Gauntlet", sz.X * 1.95, sz.Y * 0.9, CF(0, -sz.Y * 0.05, 0), main, METAL)
					round(m, la, "GauntletTop", V(sz.X * 1.95, sz.Y * 0.4, sz.Z * 1.95), CF(0, sz.Y * 0.38, 0), main, METAL)
					band(m, la, "GauntletRim", sz.X * 2.0, sz.Y * 0.12, CF(0, -sz.Y * 0.48, 0), accent, METAL)
				end
			end
			local h = m:FindFirstChild(side .. "Hand")
			if h and cfg.bulk then round(m, h, "Fist", h.Size * V(1.75, 4.2, 1.9), CF(0, -h.Size.Y * 1.0, 0), accent, METAL) end
			local ul = m:FindFirstChild(side .. "UpperLeg")
			if ul and cfg.bulk then band(m, ul, "ThighShell", ul.Size.X * 1.4, ul.Size.Y * 0.8, CF(), accent, METAL) end
			local ll = m:FindFirstChild(side .. "LowerLeg")
			if ll then
				local sz = ll.Size
				round(m, ll, "Kneecap", V(sz.X * 0.62, sz.Y * 0.36, sz.Z * 0.4), CF(0, sz.Y * 0.44, -sz.Z * 0.4), main, METAL)
				band(m, ll, "AnkleSeam", sz.X * 0.98, 0.04, CF(0, -sz.Y * 0.3, 0), SEAM)
				if cfg.bulk then band(m, ll, "ShinShell", sz.X * 1.45, sz.Y * 0.85, CF(0, -sz.Y * 0.05, 0), main, METAL) end
			end
		end
		if cfg.bulk then
			local t = find(m, "UpperTorso")
			if t then
				local sz = t.Size
				round(m, t, "Hull", V(sz.X * 1.15, sz.Y * 1.1, sz.Z * 1.45), CF(0, sz.Y * 0.05, -sz.Z * 0.05), main, METAL)
			end
		end
	end)

	if cfg.bulk then -- reactor + face must sit on the hull: redo the reactor further forward
		add(function(m)
			local t = find(m, "UpperTorso"); if not t then return end
			local sz = t.Size
			local d = sz.X * 0.24
			round(m, t, "HullReactorRing", V(d * 1.3, d * 1.3, 0.2), CF(0, sz.Y * 0.15, -sz.Z * 0.78), C(70, 72, 80), METAL)
			local g = round(m, t, "HullReactor", V(d, d, 0.16), CF(0, sz.Y * 0.15, -sz.Z * 0.85), C(200, 240, 255), Enum.Material.Neon)
			local l = Instance.new("PointLight"); l.Color = C(180, 230, 255); l.Range = 8; l.Parent = g
		end)
	end

	local arms, legs = cfg.arms or accent, cfg.legs or accent
	return {
		colors = { Head = main, Chest = main, Waist = main, UpperArms = arms, LowerArms = main, Hands = main, UpperLegs = legs, LowerLegs = main, Feet = main },
		pieces = pieces,
	}
end
