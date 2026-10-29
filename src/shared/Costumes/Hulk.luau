-- Hulk: small sculpted head on the Brute body: heavy brow ridge, wide jaw, gritted teeth, thick angry brows,
-- shaggy black flat-top hair with jagged bangs; torn purple pants ending in ragged points at mid-calf; bare green feet with toes.
-- Variants: Gray Hulk, Red Hulk (yellow eyes, black pants + belt), World War Hulk (gladiator armor),
-- Maestro (wild white hair + beard), Immortal Hulk (receding hair, glowing green eyes, dark pants).
-- Costume module: return function(s, H, rarity) -> { colors = { group = Color3 }, pieces = { { "Piece", args... } | function(m) end } }
return function(s, H, rarity)
	local C, WHITE, piece, round, band, find = H.C, H.WHITE, H.piece, H.round, H.band, H.find
	local V, CF = Vector3.new, CFrame.new
	local BLACK = C(22, 22, 24)
	local cfg = ({
		Common = { hair = BLACK, iris = C(60, 120, 40) },
		Rare = { hair = C(30, 30, 32), iris = C(60, 60, 60) },
		Epic = { hair = BLACK, eye = C(255, 225, 90), belt = C(60, 62, 70) },
		Legendary = { hair = BLACK, iris = C(60, 120, 40), armor = s.Secondary, belt = C(70, 50, 40) },
		Mythic = { hair = C(235, 235, 235), beard = true, wild = true, iris = C(60, 120, 40), belt = C(40, 30, 25) },
		Secret = { hair = C(30, 34, 30), receding = true, eye = s.Secondary, pants = C(90, 50, 120) },
	})[rarity] or {}
	local skin, pants = s.Primary, cfg.pants or s.Secondary

	local function faceOn(p, n, tilt)
		local z = -n.Unit
		local x = V(0, 1, 0):Cross(z).Unit
		return CFrame.fromMatrix(p, x, z:Cross(x), z) * CFrame.Angles(0, 0, tilt or 0)
	end
	local function ell(c, r)
		return function(x, y, out)
			local u, v = (x - c.X) / r.X, (y - c.Y) / r.Y
			local w = math.sqrt(math.max(0.03, 1 - u * u - v * v))
			local z = c.Z - r.Z * w
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
		local dark = skin:Lerp(C(0, 0, 0), 0.35)
		local sc, sr = V(0, s0 * 0.06, s0 * 0.02), V(s0 * 0.44, s0 * 0.5, s0 * 0.47)
		round(m, hd, "Skull", sr * 2, CF(sc), skin)
		local jc, jr = V(0, -s0 * 0.22, -s0 * 0.06), V(s0 * 0.46, s0 * 0.3, s0 * 0.42) -- wide square jaw
		round(m, hd, "Jaw", jr * 2, CF(jc), skin)
		local bc, br = V(0, s0 * 0.17, -s0 * 0.3), V(s0 * 0.4, s0 * 0.1, s0 * 0.16) -- heavy brow ridge
		round(m, hd, "BrowRidge", br * 2, CF(bc), skin)
		band(m, hd, "Neck", s0 * 0.85, s0 * 0.5, CF(0, -s0 * 0.48, 0.05), skin)
		for _, x in { -1, 1 } do round(m, hd, "Ear", V(0.12, s0 * 0.24, s0 * 0.16), CF(x * s0 * 0.45, s0 * 0.02, s0 * 0.06), skin) end
		local face = multi({ ell(sc, sr), ell(jc, jr) })
		local brow = ell(bc, br)
		for _, x in { -1, 1 } do
			local p, n = face(x * s0 * 0.16, s0 * 0.07, 0)
			round(m, hd, "Socket", V(s0 * 0.2, s0 * 0.1, 0.05), faceOn(p, n), dark)
			if cfg.eye then
				round(m, hd, "Eye", V(s0 * 0.15, s0 * 0.06, 0.05), faceOn(p + n * 0.012, n, x * math.rad(-10)), cfg.eye, Enum.Material.SmoothPlastic)
			else
				round(m, hd, "Sclera", V(s0 * 0.15, s0 * 0.06, 0.05), faceOn(p + n * 0.012, n, x * math.rad(-10)), C(245, 245, 235), Enum.Material.SmoothPlastic)
				round(m, hd, "Iris", V(s0 * 0.055, s0 * 0.055, 0.04), faceOn(p + n * 0.024, n), cfg.iris, Enum.Material.SmoothPlastic)
			end
			local bp, bn = brow(x * s0 * 0.17, s0 * 0.16, 0.01)
			piece(m, hd, "Brow", V(s0 * 0.26, s0 * 0.07, 0.06), faceOn(bp, bn, x * math.rad(22)), cfg.receding and dark or cfg.hair) -- angry: inner ends down
		end
		local np, nn = face(0, -s0 * 0.06, 0)
		round(m, hd, "Nose", V(s0 * 0.2, s0 * 0.12, s0 * 0.16), faceOn(np, nn), skin)
		local mp, mn = face(0, -s0 * 0.27, 0)
		round(m, hd, "Mouth", V(s0 * 0.42, s0 * 0.12, 0.05), faceOn(mp, mn), C(70, 20, 20))
		piece(m, hd, "Teeth", V(s0 * 0.36, s0 * 0.035, 0.05), faceOn(mp + mn * 0.012, mn) * CF(0, s0 * 0.022, 0), C(240, 236, 220))
		piece(m, hd, "TeethLow", V(s0 * 0.32, s0 * 0.03, 0.05), faceOn(mp + mn * 0.012, mn) * CF(0, -s0 * 0.025, 0), C(240, 236, 220))
		-- hair
		local hc = cfg.hair
		if cfg.receding then
			round(m, hd, "Hair", V(s0 * 0.86, s0 * 0.4, s0 * 0.86), CF(0, s0 * 0.38, s0 * 0.1), hc)
		else
			round(m, hd, "Hair", V(s0 * 0.94, s0 * 0.5, s0 * 1.02), CF(0, s0 * 0.36, s0 * 0.04), hc)
			round(m, hd, "HairBack", V(s0 * 0.9, s0 * 0.8, s0 * 0.5), CF(0, s0 * 0.02, s0 * 0.26), hc)
			for i = -2, 2 do -- jagged bangs over the forehead
				wedgeP(m, hd, "Bang", V(s0 * 0.16, s0 * 0.24, s0 * 0.12), CF(i * s0 * 0.15, s0 * 0.3, -s0 * 0.38 + math.abs(i) * s0 * 0.06)
					* CFrame.Angles(math.rad(180), math.rad(i * 14), math.rad(i * 6)), hc)
			end
			if cfg.wild then -- Maestro: wild mane
				for _, x in { -1, 1 } do round(m, hd, "Mane", V(s0 * 0.4, s0 * 1.1, s0 * 0.7), CF(x * s0 * 0.42, -s0 * 0.15, s0 * 0.2) * CFrame.Angles(0, 0, math.rad(x * 15)), hc) end
				round(m, hd, "ManeBack", V(s0 * 1.1, s0 * 1.4, s0 * 0.5), CF(0, -s0 * 0.35, s0 * 0.35), hc)
			end
		end
		if cfg.beard then
			round(m, hd, "Beard", V(s0 * 0.9, s0 * 0.6, s0 * 0.75), CF(0, -s0 * 0.38, -s0 * 0.1), hc)
			round(m, hd, "BeardTip", V(s0 * 0.5, s0 * 0.6, s0 * 0.4), CF(0, -s0 * 0.75, -s0 * 0.2), hc)
			local p, n = face(0, -s0 * 0.18, 0.01)
			round(m, hd, "Mustache", V(s0 * 0.5, s0 * 0.1, 0.1), faceOn(p, n), hc)
		end
	end)

	-- ===== torn pants, toes, belt, armor =====
	add(function(m)
		for _, side in { "Left", "Right" } do
			local ll = m:FindFirstChild(side .. "LowerLeg")
			if ll then
				local sz = ll.Size
				round(m, ll, "PantLeg", V(sz.X * 1.16, sz.Y * 0.9, sz.Z * 1.24), CF(0, sz.Y * 0.24, sz.Z * 0.05), pants, Enum.Material.Fabric)
				for i = 0, 6 do -- ragged hem: points hanging down around the calf
					local a = i / 7 * math.pi * 2
					local len = sz.Y * (0.16 + (i % 3) * 0.06)
					wedgeP(m, ll, "Tatter", V(0.06, len, sz.X * 0.34), CF(math.sin(a) * sz.X * 0.56, sz.Y * 0.02 - len / 2, -math.cos(a) * sz.Z * 0.6 + sz.Z * 0.05)
						* CFrame.Angles(0, math.pi / 2 - a, 0) * CFrame.Angles(math.rad(180), 0, 0), pants, Enum.Material.Fabric)
				end
			end
			local f = m:FindFirstChild(side .. "Foot")
			if f then
				for i = -1, 2 do
					round(m, f, "Toe", V(f.Size.X * 0.2, f.Size.Y * 0.6, f.Size.X * 0.24), CF((i - 0.5) * f.Size.X * 0.21, -f.Size.Y * 0.15, -f.Size.Z * 0.62), skin)
				end
			end
		end
		local w = find(m, "LowerTorso")
		if w then
			local ws = w.Size
			round(m, w, "Waistband", V(ws.X * 1.0, ws.Y * 0.6, ws.Z * 1.05), CF(0, ws.Y * 0.38, 0), cfg.belt or pants:Lerp(C(0, 0, 0), 0.25), Enum.Material.Fabric)
			if cfg.belt then piece(m, w, "Buckle", V(ws.X * 0.16, ws.Y * 0.5, 0.1), CF(0, ws.Y * 0.38, -ws.Z * 0.53), C(190, 190, 200), Enum.Material.Metal) end
		end
		if cfg.armor then -- World War Hulk: gladiator plates (left pauldron, chest strap plate, gauntlets)
			local t = find(m, "UpperTorso")
			local ua = m:FindFirstChild("LeftUpperArm")
			if ua then
				round(m, ua, "Pauldron", V(ua.Size.X * 1.42, ua.Size.Y * 0.95, ua.Size.Z * 1.42), CF(-ua.Size.X * 0.12, ua.Size.Y * 0.26, 0), cfg.armor, Enum.Material.Metal)
			end
			if t then
				local sz = t.Size
				piece(m, t, "ChestStrap", V(sz.X * 0.16, sz.Y * 1.25, 0.1), CF(-sz.X * 0.08, sz.Y * 0.02, -sz.Z * 0.5) * CFrame.Angles(0, 0, math.rad(-36)), C(70, 50, 40), Enum.Material.Leather)
				round(m, t, "ChestPlate", V(sz.X * 0.36, sz.Y * 0.36, sz.Z * 0.3), CF(-sz.X * 0.25, sz.Y * 0.26, -sz.Z * 0.42), cfg.armor, Enum.Material.Metal)
			end
			for _, n in { "LeftLowerArm", "RightLowerArm" } do
				local la = m:FindFirstChild(n)
				if la then band(m, la, "Gauntlet", la.Size.X * 1.12, la.Size.Y * 0.55, CF(0, -la.Size.Y * 0.2, 0), cfg.armor, Enum.Material.Metal) end
			end
		end
	end)

	return {
		colors = { Head = skin, Chest = skin, Arms = skin, Hands = skin, Waist = pants, UpperLegs = pants, LowerLegs = skin, Feet = skin },
		pieces = pieces,
	}
end
