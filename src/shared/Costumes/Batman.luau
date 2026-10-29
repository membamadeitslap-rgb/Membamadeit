-- Batman: per-variant suit built from rounded parts (cowl shell + skin jaw, tapered ears, angular white eyes,
-- part-built bat emblem, capsule utility belt, finned gauntlets, draped scalloped cape).
-- Costume module: return function(s, H, rarity) -> { colors = { group = Color3 }, pieces = { { "Piece", args... } | function(m) end } }
-- s = skin variant (Name, Primary, Secondary, Flame...), H = shared helpers (see Costume.luau "Helpers"), rarity = "Common" | "Rare" | "Epic" | "Legendary" | "Mythic" | "Secret"
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
			for _, x in { -1, 1 } do
				round(m, t, "CapeDrape", V(s.X * 0.5, s.Y * 0.32, s.Z * 1.08), CF(x * s.X * 0.24, s.Y * 0.42, s.Z * 0.06) * A(0, 0, rad(-x * 14)), color, Enum.Material.Fabric)
			end
		end
		return panels
	end
	-- part-built bat symbol facing -Z (front), centered at cf, span w
	function k.bat(m, a, cf, w, color, mat)
		local h = w * 0.42
		round(m, a, "BatBody", V(w * 0.12, h * 0.8, 0.05), cf * CF(0, -h * 0.05, 0), color, mat)
		round(m, a, "BatHead", V(w * 0.1, h * 0.28, 0.05), cf * CF(0, h * 0.32, 0), color, mat)
		for _, x in { -1, 1 } do
			k.flat(m, a, "BatEar", w * 0.05, h * 0.2, 0.05, cf * CF(x * w * 0.03, h * 0.5, 0), color, mat)
			-- wing: triangle out to a raised tip, lower edge cut by two downward scallop points
			k.flat(m, a, "BatWing", h * 0.75, w * 0.46, 0.05, cf * CF(x * w * 0.27, h * 0.12, 0) * A(0, 0, rad(-x * 78)), color, mat)
			k.flat(m, a, "BatWing", w * 0.16, h * 0.42, 0.05, cf * CF(x * w * 0.3, -h * 0.18, 0) * A(0, 0, math.pi + rad(x * 10)), color, mat)
			k.flat(m, a, "BatWing", w * 0.16, h * 0.34, 0.05, cf * CF(x * w * 0.14, -h * 0.2, 0) * A(0, 0, math.pi), color, mat)
		end
	end
	return k
end

return function(s, H, rarity)
	local C, SKIN, WHITE = H.C, H.SKIN, H.WHITE
	local piece, round, band, ring, find, chestOf, waistOf = H.piece, H.round, H.band, H.ring, H.find, H.chestOf, H.waistOf
	local k = kit(H)
	local suit, dark = s.Primary, s.Secondary
	local name = s.Name or ""
	local epic, hell, red, laughs = rarity == "Epic", rarity == "Legendary", rarity == "Mythic", rarity == "Secret"
	local yellow = C(250, 205, 55)
	local belt = laughs and C(40, 40, 45) or hell and C(60, 60, 68) or red and C(30, 10, 10) or epic and C(205, 165, 60) or yellow
	local accent = hell and C(255, 120, 30) or red and C(255, 210, 60) or laughs and C(210, 210, 220) or nil
	local jawSkin = laughs and C(225, 225, 220) or SKIN
	local earLen = epic and 0.75 or hell and 0.6 or rarity == "Rare" and 0.22 or 0.32

	local function cowl(m)
		local hd = find(m, "Head"); if not hd then return end
		local h = hd.Size
		round(m, hd, "Cowl", V(h.X * 1.08, h.Y * 1.05, h.Z * 1.08), CF(0, h.Y * 0.05, 0.02), dark)
		-- skin jaw out of the cowl opening
		round(m, hd, "Jaw", V(h.X * 0.8, h.Y * 0.5, h.Z * 0.62), CF(0, -h.Y * 0.25, -h.Z * 0.24), jawSkin)
		round(m, hd, "Chin", V(h.X * 0.5, h.Y * 0.28, h.Z * 0.4), CF(0, -h.Y * 0.36, -h.Z * 0.36), jawSkin)
		-- cowl nose: bridge comes down over the nose to the upper lip
		k.flat(m, hd, "CowlNose", h.X * 0.34, h.Y * 0.3, h.Z * 0.2, CF(0, -h.Y * 0.06, -h.Z * 0.46) * A(rad(-12), 0, math.pi), dark)
		-- scowling brow + angular white eyes (no Neon on faces)
		for _, x in { -1, 1 } do
			piece(m, hd, "Brow", V(h.X * 0.3, h.Y * 0.08, h.Z * 0.12), CF(x * h.X * 0.17, h.Y * 0.16, -h.Z * 0.5) * A(0, 0, rad(-x * 14)), dark)
			k.wedge(m, hd, "Eye", V(h.X * 0.22, h.Y * 0.075, 0.04), CF(x * h.X * 0.18, h.Y * 0.08, -h.Z * 0.555) * A(0, rad(x * 16), rad(-x * 10)) * A(rad(-90), 0, 0),
				laughs and C(170, 20, 25) or hell and C(255, 170, 60) or WHITE, Enum.Material.SmoothPlastic)
			-- tapered bat ears
			local len = h.Y * earLen
			k.flat(m, hd, "Ear", h.X * 0.26, len, h.Z * 0.16, CF(x * h.X * 0.3, h.Y * 0.47 + len / 2, h.Z * 0.02) * A(0, 0, rad(-x * 5)), dark)
		end
		piece(m, hd, "Mouth", V(h.X * 0.24, h.Y * 0.025, 0.03), CF(0, -h.Y * 0.28, -h.Z * 0.555), laughs and C(20, 20, 20) or jawSkin:Lerp(C(0, 0, 0), 0.5))
		if laughs then -- Joker grin + spiked crown
			for _, x in { -1, 1 } do piece(m, hd, "Grin", V(h.X * 0.12, h.Y * 0.025, 0.03), CF(x * h.X * 0.15, -h.Y * 0.25, -h.Z * 0.54) * A(0, x * rad(25), rad(x * 30)), C(20, 20, 20)) end
			for i = 0, 6 do
				local a = rad(-90 + i * 30)
				local sp = piece(m, hd, "Crown", V(0.09, h.Y * 0.55, 0.09), CF(math.sin(a) * h.X * 0.48, h.Y * 0.55, -math.cos(a) * h.Z * 0.48) * A(0, -a, 0) * A(rad(-22), 0, 0), C(150, 150, 160), Enum.Material.Metal)
				local sm = Instance.new("SpecialMesh"); sm.MeshType = Enum.MeshType.Sphere; sm.Scale = V(1, 1, 1); sm.Parent = sp
			end
		end
		if red then -- Flash lightning wings on the cowl
			for _, x in { -1, 1 } do k.tri(m, hd, "Wing", 0.05, h.Y * 0.5, h.Z * 0.22, CF(x * h.X * 0.53, h.Y * 0.12, h.Z * 0.12) * A(rad(-55), 0, 0), accent, Enum.Material.Metal) end
		end
	end

	local function chest(m)
		local t = chestOf(m); if not t then return end
		local c = t.Size
		local cf = CF(0, c.Y * 0.16, -c.Z / 2 - 0.03)
		if epic or laughs or hell then -- no oval: big black bat straight on the chest
			k.bat(m, t, cf * CF(0, 0, -0.02), c.X * 0.82, hell and accent or laughs and C(120, 120, 130) or C(15, 12, 12), hell and Enum.Material.Neon or nil)
		else
			local o = round(m, t, "Oval", V(c.X * 0.56, c.Y * 0.32, 0.12), cf, red and C(25, 10, 10) or yellow)
			k.bat(m, t, cf * CF(0, 0, -0.06), c.X * 0.46, red and accent or C(10, 10, 12))
		end
		if hell then -- armored plates
			for _, x in { -1, 1 } do
				round(m, t, "Plate", V(c.X * 0.42, c.Y * 0.3, 0.18), CF(x * c.X * 0.22, c.Y * 0.2, -c.Z * 0.47), C(70, 70, 78), Enum.Material.Metal)
			end
			for i = 0, 2 do piece(m, t, "Ab", V(c.X * 0.36, c.Y * 0.1, 0.1), CF(0, -c.Y * (0.12 + i * 0.13), -c.Z * 0.47), C(65, 65, 72), Enum.Material.Metal) end
		end
	end

	local function utility(m)
		local w = waistOf(m); if not w then return end
		local l = w.Size
		local y = l.Y * 0.3
		ring(m, w, "Belt", l.X * 0.53, l.Z * 0.56, 0.26, 0.1, CF(0, y, 0), belt, nil, 10)
		piece(m, w, "Buckle", V(l.X * 0.24, 0.3, 0.08), CF(0, y, -l.Z * 0.58), belt:Lerp(WHITE, 0.15), Enum.Material.Metal)
		for _, x in { -0.42, -0.27, 0.27, 0.42 } do -- capsule pouches
			local pz = -math.sqrt(math.max(0, 1 - (x / 0.53) ^ 2)) * l.Z * 0.56 - 0.06
			band(m, w, "Pouch", 0.16, 0.34, CF(x * l.X, y - 0.02, pz), belt:Lerp(C(0, 0, 0), 0.08))
		end
	end

	local function gauntlets(m)
		for _, n in { "LeftLowerArm", "RightLowerArm" } do
			local a = m:FindFirstChild(n)
			if a then
				local s2 = a.Size
				local x = n:find("Left") and -1 or 1
				band(m, a, "Cuff", s2.X * 1.12, s2.Y * 0.16, CF(0, s2.Y * 0.38, 0), dark)
				for i = 0, 2 do -- three scalloped fins on the outer forearm
					k.tri(m, a, "Fin", 0.06, s2.Z * 0.6, s2.Y * 0.24, CF(x * s2.X * 0.5, s2.Y * (0.22 - i * 0.22), 0) * A(0, 0, rad(-x * 90)) * A(0, rad(90), 0), hell and accent or dark)
				end
			end
		end
		for _, n in { "LeftLowerLeg", "RightLowerLeg" } do -- boot tops
			local a = m:FindFirstChild(n)
			if a then band(m, a, "BootTop", a.Size.X * 1.14, a.Size.Y * 0.12, CF(0, a.Size.Y * 0.12, 0), dark) end
		end
	end

	local capeOpts = { n = 5, len = epic and 2.45 or 2.25, arc = epic and 120 or 90, fan = epic and 13 or 7, r = 0.5, scallop = not laughs, pitch = 6,
		inner = rarity == "Rare" and C(90, 140, 220) or nil }
	local function cape(m)
		local panels = k.cape(m, dark, capeOpts)
		if laughs then -- ragged hem
			for i, pnl in panels do k.flat(m, chestOf(m), "Rag", pnl.w * 0.5, pnl.len * (0.08 + (i % 2) * 0.08), 0.08, pnl.cf * CF(-pnl.w * 0.2, -pnl.len / 2 - pnl.len * 0.05, 0) * A(0, 0, math.pi), dark, Enum.Material.Fabric) end
		end
		if hell then -- glowing seams on the armor
			local t = chestOf(m)
			if t then local c = t.Size
				for _, x in { -1, 1 } do piece(m, t, "Seam", V(0.05, c.Y * 0.7, 0.05), CF(x * c.X * 0.43, -c.Y * 0.05, -c.Z * 0.42), accent, Enum.Material.Neon) end
			end
		end
	end

	local colors = { Head = dark, Chest = suit, Waist = dark, Arms = suit, Gloves = dark, Legs = suit, Boots = dark }
	if hell then colors.Arms = C(60, 60, 68); colors.Legs = C(55, 55, 62) end
	local pieces = { cowl, chest, utility, gauntlets, cape }
	if hell then table.insert(pieces, { "Shoulders", C(70, 70, 78) }) end
	return { colors = colors, pieces = pieces }
end
