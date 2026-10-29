-- Spider-Man: smooth egg-shaped mask with raised web lines (thin discs whose rims poke out of the head/chest), big angled
-- black-rimmed lenses, red chest with blue sides, blue arms with red shoulder caps, red gloves/boots with webbing, built spider emblems.
-- Variants: Miles (black + red webs, big red spider), Iron Spider (red/gold + waldo legs), Symbiote (black, giant white spider),
-- 2099 (navy + red skull-spider), Cosmic (white/blue classic layout).
-- Costume module: return function(s, H, rarity) -> { colors = { group = Color3 }, pieces = { { "Piece", args... } | function(m) end } }
return function(s, H, rarity)
	local C, WHITE, piece, round, band, find = H.C, H.WHITE, H.piece, H.round, H.band, H.find
	local V, CF = Vector3.new, CFrame.new
	local BLACK = C(15, 15, 20)
	local MUS = 0.6 -- Lean preset muscle (pec bulge)
	local cfg = ({
		Common = { body = s.Primary, side = s.Secondary, arm = s.Secondary, leg = s.Secondary, web = BLACK, spider = BLACK, back = BLACK, scale = 1, lens = WHITE, frame = BLACK },
		Rare = { body = s.Primary, arm = s.Primary, leg = s.Primary, web = s.Secondary, spider = s.Secondary, back = s.Secondary, scale = 1.9, lens = WHITE, frame = BLACK, soles = s.Secondary },
		Epic = { body = s.Primary, side = s.Secondary, arm = s.Secondary, leg = s.Secondary, legLow = s.Primary, spider = s.Secondary, back = s.Secondary, scale = 1.8, lens = C(255, 225, 140), frame = s.Secondary, metal = true, waldos = true },
		Legendary = { body = s.Primary, arm = s.Primary, leg = s.Primary, spider = s.Secondary, back = s.Secondary, scale = 2.6, lens = WHITE, frame = s.Primary, lensSize = 1.2 },
		Mythic = { body = s.Primary, arm = s.Primary, leg = s.Primary, spider = s.Secondary, back = s.Secondary, scale = 2.2, skull = true, lens = C(235, 40, 50), frame = BLACK, stripes = s.Secondary },
		Secret = { body = s.Primary, side = s.Secondary, arm = s.Secondary, leg = s.Secondary, web = C(20, 30, 90), spider = C(20, 30, 90), back = C(20, 30, 90), scale = 1, lens = C(200, 225, 255), frame = C(20, 30, 90) },
	})[rarity] or {}
	cfg.body = cfg.body or s.Primary
	local body = cfg.body

	-- flat piece on a surface point p with outward normal n: its -Z (front) face looks outward, +Y roughly up
	local function faceOn(p, n, tilt)
		local z = -n.Unit
		local x = V(0, 1, 0):Cross(z).Unit
		return CFrame.fromMatrix(p, x, z:Cross(x), z) * CFrame.Angles(0, 0, tilt or 0)
	end
	-- ellipsoid surface sampler: (x, y) -> point on the front (or back) surface + normal, in anchor space
	local function ell(c, r)
		return function(x, y, out, back)
			local u, v = (x - c.X) / r.X, (y - c.Y) / r.Y
			local w = math.sqrt(math.max(0.03, 1 - u * u - v * v))
			local z = c.Z + (back and 1 or -1) * r.Z * w
			local n = V((x - c.X) / r.X ^ 2, (y - c.Y) / r.Y ^ 2, (z - c.Z) / r.Z ^ 2).Unit
			return V(x, y, z) + n * (out or 0), n
		end
	end
	-- straight strip between two surface points
	local function seg(m, a, name, p0, p1, n, w, t, color, mat)
		local d = p1 - p0
		local y = d.Unit
		local x = y:Cross(-n).Unit
		local z = x:Cross(y)
		return piece(m, a, name, V(w, d.Magnitude + w * 0.6, t), CFrame.fromMatrix((p0 + p1) / 2, x, y, z), color, mat)
	end
	-- raised line ring: thin ellipsoid disc slightly larger than the surface cross-section, only its rim shows
	local function disc(m, a, name, size, cf, color)
		return round(m, a, name, size, cf, color)
	end

	-- spider emblem (front or back of the chest): body + thorax + 8 two-segment legs, laid on the chest surface
	local function spider(m, t, surf, cy, k, color, back, skull)
		local function at(x, y, o) return surf(x, y + cy, o or 0.03, back) end
		local pa, na = at(0, -0.1 * k)
		round(m, t, "SpiderAbdomen", V(0.13 * k, 0.24 * k, 0.07), faceOn(pa, na), color)
		local pt, nt = at(0, 0.09 * k)
		round(m, t, "SpiderHead", skull and V(0.2 * k, 0.2 * k, 0.07) or V(0.1 * k, 0.13 * k, 0.07), faceOn(pt, nt), color)
		local legs = skull and { { 0.04, 0.14, 0.18, 0.32, 0.2, 0.52 }, { 0.06, 0.1, 0.24, 0.2, 0.38, 0.36 }, { 0.06, 0.0, 0.24, -0.04, 0.38, -0.2 }, { 0.04, -0.04, 0.16, -0.16, 0.16, -0.42 } }
			or { { 0.03, 0.1, 0.13, 0.22, 0.11, 0.42 }, { 0.04, 0.07, 0.2, 0.13, 0.33, 0.3 }, { 0.04, 0.04, 0.2, -0.02, 0.33, -0.2 }, { 0.03, 0.02, 0.13, -0.13, 0.11, -0.4 } }
		local w = math.clamp(0.04 * k, 0.05, 0.1)
		for _, sx in { -1, 1 } do
			for _, l in legs do
				local p0, n0 = at(sx * l[1] * k, l[2] * k)
				local p1, n1 = at(sx * l[3] * k, l[4] * k)
				local p2, n2 = at(sx * l[5] * k, l[6] * k)
				seg(m, t, "SpiderLeg", p0, p1, (n0 + n1), w, 0.05, color)
				seg(m, t, "SpiderLeg", p1, p2, (n1 + n2), w * 0.85, 0.05, color)
			end
		end
	end

	local pieces = {}
	local function add(f) table.insert(pieces, f) end
	if cfg.metal then table.insert(pieces, { "Material", Enum.Material.Metal }) end

	-- ===== head: smooth egg mask, chin, neck, lenses, web lines =====
	add(function(m)
		local hd = find(m, "Head"); if not hd then return end
		local s0 = hd.Size.X
		hd.Transparency = 1 -- replaced by the sculpted mask below (classic head shape is too boxy)
		local cy = s0 * 0.04
		local R = V(s0 * 0.45, s0 * 0.55, s0 * 0.5)
		round(m, hd, "Mask", R * 2, CF(0, cy, 0), body)
		band(m, hd, "Neck", s0 * 0.44, s0 * 0.5, CF(0, -s0 * 0.5, 0.02), body)
		local surf = ell(V(0, cy, 0), R)
		local ls = cfg.lensSize or 1
		for _, x in { -1, 1 } do
			local p, n = surf(x * s0 * 0.2, s0 * 0.07, 0)
			round(m, hd, "LensFrame", V(s0 * 0.38 * ls, s0 * 0.27 * ls, 0.12), faceOn(p, n, x * math.rad(24)), cfg.frame)
			round(m, hd, "Lens", V(s0 * 0.3 * ls, s0 * 0.19 * ls, 0.1), faceOn(p + n * 0.03, n, x * math.rad(24)) * CF(x * s0 * 0.01, s0 * 0.01, 0), cfg.lens, Enum.Material.SmoothPlastic)
		end
		if cfg.web then
			local g = 1.035
			for i = 0, 5 do -- radial lines converging on the face center (and the back of the head)
				local a = math.rad(i * 30)
				local r = 1 / math.sqrt((math.sin(a) / R.X) ^ 2 + (math.cos(a) / R.Y) ^ 2)
				disc(m, hd, "WebR", V(0.07, r * 2 * g, R.Z * 2 * g), CF(0, cy, 0) * CFrame.Angles(0, 0, a), cfg.web)
			end
			for _, z0 in { -0.72, -0.3, 0.2, 0.65 } do -- concentric rings around the face
				local k = math.sqrt(1 - z0 * z0)
				disc(m, hd, "WebC", V(R.X * 2 * k * g, R.Y * 2 * k * g, 0.07), CF(0, cy, z0 * R.Z), cfg.web)
			end
		end
	end)

	-- ===== torso: blue sides, emblem, webbing =====
	add(function(m)
		local t = find(m, "UpperTorso"); if not t then return end
		local sz = t.Size
		local c = V(0, sz.Y * 0.1, 0)
		local R = V(sz.X * 0.49, sz.Y * 0.475, sz.Z * 0.5)
		local chest = ell(c, R)
		-- pec bulge (Body.Sculpt pecs) so emblems sit on top of them
		local pd = sz.Z * (0.2 + 0.05 * MUS)
		local function surf(x, y, o, back)
			local p, n = chest(x, y, 0, back)
			if not back then
				local pec = ell(V((x < 0 and -1 or 1) * sz.X * 0.21, sz.Y * 0.24, -sz.Z * 0.5 + pd / 2 - 0.015), V(sz.X * 0.25, sz.Y * 0.13, pd / 2))
				local pp, pn = pec(x, y, 0)
				local u, v = (x - (x < 0 and -1 or 1) * sz.X * 0.21) / (sz.X * 0.25), (y - sz.Y * 0.24) / (sz.Y * 0.13)
				if u * u + v * v < 1 and pp.Z < p.Z then p, n = pp, (pn + n).Unit end
			end
			return p + n * o, n
		end
		if cfg.side then
			for _, x in { -1, 1 } do
				round(m, t, "Side", V(sz.X * 0.3, sz.Y * 0.95, sz.Z * 0.62), CF(x * sz.X * 0.42, -sz.Y * 0.1, 0), cfg.side)
			end
		end
		if cfg.web then
			local g = 1.06
			for i = 0, 5 do
				local a = math.rad(i * 30)
				local r = 1 / math.sqrt((math.sin(a) / R.X) ^ 2 + (math.cos(a) / R.Y) ^ 2)
				disc(m, t, "WebR", V(0.07, r * 2 * g, R.Z * 2 * g), CF(c) * CFrame.Angles(0, 0, a), cfg.web)
			end
			for _, z0 in { 0.78 } do
				local k = math.sqrt(1 - z0 * z0)
				disc(m, t, "WebC", V(R.X * 2 * k * g, R.Y * 2 * k * g, 0.07), CF(c + V(0, 0, z0 * R.Z)), cfg.web)
			end
		end
		local k = sz.Y * 0.5 * (cfg.scale or 1)
		spider(m, t, surf, sz.Y * 0.13, k, cfg.spider, false, cfg.skull)
		if cfg.back then spider(m, t, surf, sz.Y * 0.08, k * (cfg.scale > 1.5 and 1 or 1.7), cfg.back, true, cfg.skull) end
		if cfg.waldos then -- Iron Spider: four golden waldo legs arching out of the back
			for _, x in { -1, 1 } do
				for j = 1, 2 do
					local base = V(x * sz.X * 0.18, sz.Y * (0.25 - j * 0.25), sz.Z * 0.5)
					local knee = base + V(x * sz.X * (0.3 + j * 0.1), sz.Y * (0.75 - j * 0.15), sz.Z * 0.7)
					local tip = knee + V(x * sz.X * (0.45 + j * 0.05), -sz.Y * (0.55 + j * 0.15), sz.Z * 0.1)
					seg(m, t, "Waldo", base, knee, V(0, 0, 1), 0.14, 0.14, cfg.spider, Enum.Material.Metal)
					seg(m, t, "Waldo", knee, tip, V(0, 0, 1), 0.11, 0.11, cfg.spider, Enum.Material.Metal)
					round(m, t, "WaldoJoint", V(0.2, 0.2, 0.2), CF(knee), cfg.body, Enum.Material.Metal)
				end
			end
		end
	end)

	-- ===== arms: red shoulder caps + outer stripe (classic layout) =====
	if cfg.arm ~= body then
		add(function(m)
			for _, n in { "LeftUpperArm", "RightUpperArm" } do
				local a = m:FindFirstChild(n)
				if a then
					local sz = a.Size; local x = n:find("Left") and -1 or 1
					round(m, a, "ShoulderCap", V(sz.X * 1.17, sz.Y * 0.66, sz.Z * 1.15), CF(0, sz.Y * 0.42, 0), body)
					round(m, a, "ArmStripe", V(sz.X * 0.4, sz.Y * 1.25, sz.Z * 0.5), CF(x * sz.X * 0.36, 0, 0), body)
				end
			end
		end)
	end

	-- ===== gloves / boots webbing (rings + vertical lines hugging the round limbs) =====
	if cfg.web then
		add(function(m)
			for _, n in { "LeftLowerArm", "RightLowerArm", "LeftLowerLeg", "RightLowerLeg" } do
				local a = m:FindFirstChild(n)
				if a then
					local sz = a.Size
					local leg = n:find("Leg") ~= nil
					local r = sz.X * (leg and 0.52 or 0.51)
					for _, y in (leg and { 0.3, -0.05, -0.38 } or { 0.15, -0.25 }) do
						round(m, a, "WebRing", V(r * 2.03, 0.06, r * 2.03 + (leg and sz.Z * 0.12 or 0)), CF(0, y * sz.Y, leg and sz.Z * 0.05 or 0), cfg.web)
					end
					for i = 0, 1 do
						round(m, a, "WebLine", V(0.05, sz.Y * (leg and 1.05 or 1.15), r * 2.06 + ((leg and i == 0) and sz.Z * 0.12 or 0)), CF(0, -sz.Y * 0.03, leg and sz.Z * 0.05 or 0) * CFrame.Angles(0, math.rad(i * 90), 0), cfg.web)
					end
				end
			end
		end)
	end
	if cfg.stripes then -- 2099: red bands at forearms and calves
		add(function(m)
			for _, n in { "LeftLowerArm", "RightLowerArm", "LeftLowerLeg", "RightLowerLeg" } do
				local a = m:FindFirstChild(n)
				if a then band(m, a, "Stripe", a.Size.X * 1.08, a.Size.Y * 0.12, CF(0, -a.Size.Y * 0.3, 0), cfg.stripes) end
			end
		end)
	end
	if cfg.soles then
		add(function(m)
			for _, n in { "LeftFoot", "RightFoot" } do
				local f = m:FindFirstChild(n)
				if f then piece(m, f, "Sole", V(f.Size.X * 0.9, f.Size.Y * 0.3, f.Size.Z * 1.12), CF(0, -f.Size.Y * 0.42, -f.Size.Z * 0.02), cfg.soles) end
			end
		end)
	end

	local legLow = cfg.legLow or body
	return {
		colors = { Head = body, Chest = body, Waist = cfg.leg or body, UpperArms = cfg.arm or body, LowerArms = body, Hands = body,
			UpperLegs = cfg.leg or body, LowerLegs = legLow, Feet = legLow },
		pieces = pieces,
	}
end
