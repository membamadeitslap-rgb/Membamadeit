-- Thor: sculpted head (oval skull + strong jaw) with a built face, long blond hair (cap + back fall + side locks),
-- Kirby winged helmet (dome + three feathers per side), sleeveless tunic with six silver discs on the chest/abs surface,
-- red cape hanging from the shoulders to mid-calf (three panels + mantle, front disc clasps), gold belt,
-- silver wristbands, gold boots with criss-cross straps.
-- Variants: Ragnarok (short hair, eyepatch, gray), Infinity War (dark armor sleeves, beard, heterochromia),
-- Mighty Thor (silver masked winged helm), King Thor (white hair/beard, eyepatch, gold), Unleashed (white-blue, lightning).
-- Costume module: return function(s, H, rarity) -> { colors = { group = Color3 }, pieces = { { "Piece", args... } | function(m) end } }
return function(s, H, rarity)
	local C, SKIN, WHITE, piece, round, band, find = H.C, H.SKIN, H.WHITE, H.piece, H.round, H.band, H.find
	local V, CF = Vector3.new, CFrame.new
	local METAL, FABRIC = Enum.Material.Metal, Enum.Material.Fabric
	local BLOND, SILVER, GOLDY = C(225, 185, 95), C(200, 202, 212), C(230, 190, 60)
	local cfg = ({
		Common = { hair = "long", hairColor = BLOND, helmet = "wings", legs = C(40, 40, 55), boots = GOLDY, straps = C(90, 60, 30), iris = C(60, 120, 200) },
		Rare = { hair = "short", hairColor = C(200, 160, 80), beard = "short", patch = true, legs = C(45, 45, 50), boots = C(30, 30, 34), iris = C(60, 120, 200) },
		Epic = { hair = "medium", hairColor = C(170, 130, 70), beard = "full", sleeves = C(35, 35, 40), legs = C(30, 30, 35), boots = C(25, 25, 30), iris = C(60, 120, 200), iris2 = C(120, 80, 40) },
		Legendary = { hair = "long", hairColor = C(235, 205, 120), helmet = "mask", legs = C(40, 45, 70), boots = s.Primary, iris = C(80, 120, 170) },
		Mythic = { hair = "long", hairColor = C(235, 235, 235), beard = "long", patch = true, helmet = "wings", helmColor = s.Primary, legs = C(60, 40, 30), boots = s.Primary, straps = C(90, 20, 20), iris = C(60, 120, 200) },
		Secret = { hair = "long", hairColor = C(240, 220, 150), helmet = "wings", legs = C(40, 60, 90), boots = SILVER, straps = C(80, 200, 255), glowEyes = true, bolts = true },
	})[rarity] or {}
	local tunic, cape = s.Primary, s.Secondary

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
	-- frontmost of several ellipsoids (only those that actually cover the point)
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

	local pieces = {}
	local function add(f) table.insert(pieces, f) end

	-- ===== head, face, hair, beard, helmet =====
	add(function(m)
		local hd = find(m, "Head"); if not hd then return end
		local s0 = hd.Size.X
		hd.Transparency = 1
		local cy = s0 * 0.05
		local R = V(s0 * 0.43, s0 * 0.52, s0 * 0.48)
		round(m, hd, "Skull", R * 2, CF(0, cy, 0), SKIN)
		local jc, jr = V(0, -s0 * 0.22, -s0 * 0.07), V(s0 * 0.36, s0 * 0.26, s0 * 0.39)
		round(m, hd, "Jaw", jr * 2, CF(jc), SKIN)
		band(m, hd, "Neck", s0 * 0.56, s0 * 0.5, CF(0, -s0 * 0.5, 0.03), SKIN)
		local surf = multi({ ell(V(0, cy, 0), R), ell(jc, jr) })
		for _, x in { -1, 1 } do round(m, hd, "Ear", V(0.1, s0 * 0.24, s0 * 0.16), CF(x * s0 * 0.43, s0 * 0.02, s0 * 0.04), SKIN) end
		-- eyes / brows
		local brow = cfg.hairColor:Lerp(C(0, 0, 0), 0.25)
		for _, x in { -1, 1 } do
			local p, n = surf(x * s0 * 0.16, s0 * 0.06, 0)
			if cfg.patch and x < 0 then
				round(m, hd, "Eyepatch", V(s0 * 0.22, s0 * 0.17, 0.06), faceOn(p, n), C(20, 18, 18))
				piece(m, hd, "PatchStrap", V(s0 * 0.92, 0.035, s0 * 0.98), CF(0, s0 * 0.12, 0) * CFrame.Angles(0, 0, math.rad(-14)), C(20, 18, 18))
			elseif cfg.glowEyes then
				round(m, hd, "EyeGlow", V(s0 * 0.17, s0 * 0.08, 0.06), faceOn(p, n), C(235, 250, 255), Enum.Material.SmoothPlastic)
			else
				round(m, hd, "Sclera", V(s0 * 0.17, s0 * 0.08, 0.05), faceOn(p, n), C(250, 250, 250), Enum.Material.SmoothPlastic)
				round(m, hd, "Iris", V(s0 * 0.07, s0 * 0.075, 0.04), faceOn(p + n * 0.012, n), (x < 0 and cfg.iris2) or cfg.iris, Enum.Material.SmoothPlastic)
				round(m, hd, "Pupil", V(s0 * 0.03, s0 * 0.035, 0.03), faceOn(p + n * 0.02, n), C(10, 10, 12))
			end
			local bp, bn = surf(x * s0 * 0.16, s0 * 0.15, 0.01)
			piece(m, hd, "Brow", V(s0 * 0.21, s0 * 0.045, 0.05), faceOn(bp, bn, x * math.rad(14)), brow)
		end
		local np, nn = surf(0, -s0 * 0.04, 0)
		local nose = piece(m, hd, "Nose", V(s0 * 0.11, s0 * 0.17, 0.11), faceOn(np, nn) * CF(0, 0, -0.04), SKIN)
		Instance.new("SpecialMesh", nose).MeshType = Enum.MeshType.Wedge
		local mp, mn = surf(0, -s0 * 0.25, 0)
		piece(m, hd, "Mouth", V(s0 * 0.22, s0 * 0.03, 0.04), faceOn(mp, mn), C(140, 80, 70))
		-- hair
		local hc = cfg.hairColor
		round(m, hd, "HairCap", V(s0 * 0.93, s0 * 0.58, s0 * 1.02), CF(0, s0 * 0.31, s0 * 0.04), hc)
		if cfg.hair ~= "short" then
			local long = cfg.hair == "long"
			round(m, hd, "HairBack", V(s0 * 0.9, s0 * (long and 1.35 or 0.95), s0 * 0.5), CF(0, -s0 * (long and 0.22 or 0.05), s0 * 0.27), hc)
			for _, x in { -1, 1 } do
				round(m, hd, "HairLock", V(s0 * 0.24, s0 * (long and 0.95 or 0.6), s0 * 0.44), CF(x * s0 * 0.4, -s0 * (long and 0.12 or 0.0), s0 * 0.08) * CFrame.Angles(0, 0, math.rad(x * 6)), hc)
				if long then round(m, hd, "HairFall", V(s0 * 0.36, s0 * 0.9, s0 * 0.3), CF(x * s0 * 0.26, -s0 * 0.68, s0 * 0.3) * CFrame.Angles(math.rad(10), 0, math.rad(x * 10)), hc) end
			end
		end
		-- beard
		if cfg.beard then
			local bc = hc:Lerp(C(0, 0, 0), 0.08)
			if cfg.beard == "long" then
				round(m, hd, "Beard", V(s0 * 0.74, s0 * 0.6, s0 * 0.66), CF(0, -s0 * 0.3, -s0 * 0.1), bc)
				round(m, hd, "BeardLong", V(s0 * 0.5, s0 * 1.0, s0 * 0.36), CF(0, -s0 * 0.75, -s0 * 0.25) * CFrame.Angles(math.rad(-8), 0, 0), bc)
			else
				round(m, hd, "Beard", V(s0 * 0.76, s0 * (cfg.beard == "full" and 0.5 or 0.42), s0 * 0.8), CF(0, -s0 * 0.28, -s0 * 0.06), bc)
			end
			local p, n = surf(0, -s0 * 0.17, 0.01)
			round(m, hd, "Mustache", V(s0 * 0.36, s0 * 0.09, 0.08), faceOn(p, n), bc)
			piece(m, hd, "Mouth", V(s0 * 0.18, s0 * 0.035, 0.04), faceOn(p + n * 0.02, n) * CF(0, -s0 * 0.08, 0), C(120, 70, 60))
		end
		-- helmet
		if cfg.helmet then
			local hcol = cfg.helmColor or SILVER
			if cfg.helmet == "mask" then -- Mighty Thor: helm that masks the upper face, eye slits
				round(m, hd, "Helm", V(s0 * 0.96, s0 * 0.86, s0 * 1.04), CF(0, s0 * 0.16, -s0 * 0.02), hcol, METAL)
				for _, x in { -1, 1 } do
					local p, n = ell(V(0, s0 * 0.16, -s0 * 0.02), V(s0 * 0.48, s0 * 0.43, s0 * 0.52))(x * s0 * 0.16, s0 * 0.06, 0)
					piece(m, hd, "EyeSlit", V(s0 * 0.19, s0 * 0.05, 0.05), faceOn(p, n, x * math.rad(10)), C(240, 248, 255), Enum.Material.SmoothPlastic)
				end
				local p, n = ell(V(0, s0 * 0.16, -s0 * 0.02), V(s0 * 0.48, s0 * 0.43, s0 * 0.52))(0, s0 * 0.0, 0)
				piece(m, hd, "Nasal", V(s0 * 0.08, s0 * 0.26, 0.06), faceOn(p, n) * CF(0, -s0 * 0.06, 0), hcol, METAL)
			else
				round(m, hd, "Helm", V(s0 * 0.98, s0 * 0.52, s0 * 1.06), CF(0, s0 * 0.36, 0.01), hcol, METAL)
				round(m, hd, "HelmRim", V(s0 * 1.0, s0 * 0.07, s0 * 1.08), CF(0, s0 * 0.24, 0.01), hcol:Lerp(C(0, 0, 0), 0.2), METAL)
			end
			for _, x in { -1, 1 } do -- three feathers per side sweeping up and back
				for k = 0, 2 do
					local len = s0 * (0.78 - k * 0.14)
					round(m, hd, "Wing", V(0.05, len, s0 * 0.2), CF(x * s0 * 0.48, s0 * 0.3, s0 * (0.0 + k * 0.08))
						* CFrame.Angles(math.rad(-28 - k * 16), 0, math.rad(-x * (10 + k * 6))) * CF(0, len * 0.45, 0), hcol, METAL)
				end
			end
		end
	end)

	-- ===== torso: discs, cape, belt =====
	add(function(m)
		local t = find(m, "UpperTorso"); if not t then return end
		local sz = t.Size
		local pd = sz.Z * 0.25
		local list = { ell(V(0, sz.Y * 0.1, 0), V(sz.X * 0.49, sz.Y * 0.475, sz.Z * 0.5)), ell(V(0, -sz.Y * 0.2, 0), V(sz.X * 0.33, sz.Y * 0.375, sz.Z * 0.46)) }
		for _, x in { -1, 1 } do table.insert(list, ell(V(x * sz.X * 0.21, sz.Y * 0.24, -sz.Z * 0.5 + pd / 2 - 0.015), V(sz.X * 0.25, sz.Y * 0.13, pd / 2))) end
		local surf = multi(list)
		local dc = (rarity == "Mythic") and C(255, 225, 120) or SILVER
		for _, x in { -1, 1 } do
			for j = 0, 2 do
				local p, n = surf(x * sz.X * 0.2, sz.Y * (0.27 - j * 0.24), 0.02)
				local d = sz.X * 0.15
				band(m, t, "Disc", d, 0.08, faceOn(p, n) * CFrame.Angles(math.rad(90), 0, 0), dc, METAL)
				band(m, t, "DiscBoss", d * 0.55, 0.12, faceOn(p, n) * CFrame.Angles(math.rad(90), 0, 0), dc:Lerp(C(0, 0, 0), 0.2), METAL)
			end
		end
		-- cape: mantle over the shoulder blades + three panels flaring to mid-calf
		local ll = m:FindFirstChild("LeftLowerLeg")
		local bottom = ll and t.CFrame:PointToObjectSpace(ll.Position).Y or -sz.Y * 2.6
		local top = sz.Y * 0.44
		local L = top - bottom
		round(m, t, "CapeMantle", V(sz.X * 1.08, sz.Y * 0.36, sz.Z * 0.8), CF(0, sz.Y * 0.42, sz.Z * 0.2), cape, FABRIC)
		local z0 = sz.Z * 0.5 + 0.08
		piece(m, t, "Cape", V(sz.X * 0.62, L, 0.08), CF(0, top, z0) * CFrame.Angles(math.rad(-11), 0, 0) * CF(0, -L / 2, 0), cape, FABRIC)
		for _, x in { -1, 1 } do
			piece(m, t, "CapeSide", V(sz.X * 0.36, L, 0.08), CF(x * sz.X * 0.3, top, z0) * CFrame.Angles(math.rad(-11), x * math.rad(16), 0) * CF(x * sz.X * 0.16, -L / 2, 0) * CFrame.Angles(0, 0, math.rad(x * 3)), cape, FABRIC)
			-- clasp discs where the cape meets the tunic
			local p, n = surf(x * sz.X * 0.36, sz.Y * 0.42, 0.03)
			band(m, t, "Clasp", sz.X * 0.13, 0.08, faceOn(p, n) * CFrame.Angles(math.rad(90), 0, 0), dc, METAL)
		end
		local w = find(m, "LowerTorso")
		if w then
			local ws = w.Size
			local belt = rarity == "Rare" and C(60, 60, 64) or GOLDY
			round(m, w, "Belt", V(ws.X * 1.0, ws.Y * 0.75, ws.Z * 1.06), CF(0, ws.Y * 0.32, 0), belt, METAL)
			round(m, w, "Buckle", V(ws.X * 0.22, ws.Y * 0.7, 0.14), CF(0, ws.Y * 0.32, -ws.Z * 0.52), belt:Lerp(WHITE, 0.25), METAL)
		end
	end)

	-- ===== arms / boots =====
	add(function(m)
		for _, side in { "Left", "Right" } do
			local la = m:FindFirstChild(side .. "LowerArm")
			if la and not cfg.sleeves then
				band(m, la, "Wristband", la.Size.X * 1.08, la.Size.Y * 0.42, CF(0, -la.Size.Y * 0.26, 0), SILVER, METAL)
				band(m, la, "WristbandRim", la.Size.X * 1.12, la.Size.Y * 0.07, CF(0, -la.Size.Y * 0.06, 0), SILVER:Lerp(C(0, 0, 0), 0.3), METAL)
			end
			local ll = m:FindFirstChild(side .. "LowerLeg")
			if ll then
				local sz = ll.Size
				round(m, ll, "BootCuff", V(sz.X * 1.12, sz.Y * 0.16, sz.Z * 1.2), CF(0, sz.Y * 0.36, sz.Z * 0.04), cfg.boots, Enum.Material.Leather)
				if cfg.straps then
					for k = 0, 2 do
						for _, d in { -1, 1 } do
							round(m, ll, "Strap", V(sz.X * 1.07, 0.05, sz.Z * 1.15), CF(0, sz.Y * (0.18 - k * 0.24), sz.Z * 0.05) * CFrame.Angles(math.rad(d * 22), 0, 0), cfg.straps)
						end
					end
				end
			end
		end
	end)

	if cfg.bolts then -- Unleashed: lightning crackling along the arms (neon is fine off the face)
		add(function(m)
			for _, n in { "LeftUpperArm", "RightUpperArm", "LeftLowerArm", "RightLowerArm" } do
				local a = m:FindFirstChild(n)
				if a then
					local sz = a.Size; local x = n:find("Left") and -1 or 1
					for k = 0, 2 do
						piece(m, a, "Bolt", V(0.06, sz.Y * 0.4, 0.06), CF(x * sz.X * 0.52, sz.Y * (0.3 - k * 0.3), -sz.Z * 0.1) * CFrame.Angles(0, 0, math.rad((k % 2 == 0 and 1 or -1) * 30)), C(170, 230, 255), Enum.Material.Neon)
					end
				end
			end
			local t = find(m, "UpperTorso")
			if t then local l = Instance.new("PointLight"); l.Color = C(150, 220, 255); l.Range = 12; l.Brightness = 1.5; l.Parent = t end
		end)
	end

	local arm = cfg.sleeves or SKIN
	return {
		colors = { Head = SKIN, Chest = tunic, Waist = tunic, UpperArms = arm, LowerArms = arm, Hands = cfg.sleeves or SKIN,
			UpperLegs = cfg.legs, LowerLegs = cfg.boots, Feet = cfg.boots },
		pieces = pieces,
	}
end
