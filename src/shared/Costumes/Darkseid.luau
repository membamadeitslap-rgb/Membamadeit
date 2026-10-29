-- Darkseid (Kirby): huge Titan build, gray craggy stone face with a heavy brow, deep creases and red eyes, blue ridged
-- helmet-cap with cheek guards, blue tunic with a skirt, wide black belt with the Omega buckle, dark gauntlets/trousers/boots.
-- Variants: Armored (black plate + spiked pauldrons), Injustice (lava-cracked armor), God of Apokolips (fire cracks + cape),
-- Omega Darkseid (red Omega energy), Absolute Darkseid (void black with violet energy).
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
		round(m, a, "BatHead", V(w * 0.1, h * 0.28, 0.05), cf * CF(0, h * 0.32, 0), color, mat)
		for _, x in { -1, 1 } do
			k.flat(m, a, "BatEar", w * 0.05, h * 0.2, 0.05, cf * CF(x * w * 0.03, h * 0.5, 0), color, mat)
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
	local C = H.C
	local piece, round, band, ring, find, chestOf, waistOf = H.piece, H.round, H.band, H.ring, H.find, H.chestOf, H.waistOf
	local k = kit(H)
	local stone, tunic = s.Primary, s.Secondary
	local armored, inj, apok, omega, absolute = rarity == "Rare", rarity == "Epic", rarity == "Legendary", rarity == "Mythic", rarity == "Secret"
	local plated = armored or inj or apok or absolute
	local crease = stone:Lerp(C(0, 0, 0), 0.4)
	local glow = inj and C(255, 120, 40) or apok and C(255, 90, 30) or omega and C(255, 40, 40) or absolute and C(170, 80, 255) or nil
	local plateC = plated and C(40, 40, 46) or C(55, 58, 70)
	local helmC = plated and plateC or tunic
	local dark = C(28, 28, 34)

	local function head(m)
		local hd = find(m, "Head"); if not hd then return end
		local h = hd.Size
		-- heavy square jaw and cheekbones carved from stone
		round(m, hd, "Jaw", V(h.X * 0.92, h.Y * 0.55, h.Z * 0.75), CF(0, -h.Y * 0.24, -h.Z * 0.16), stone, Enum.Material.Slate)
		for _, x in { -1, 1 } do
			round(m, hd, "Cheek", V(h.X * 0.3, h.Y * 0.22, h.Z * 0.3), CF(x * h.X * 0.27, -h.Y * 0.04, -h.Z * 0.38), stone, Enum.Material.Slate)
			-- jutting brow block over each eye, eyes sunk beneath
			piece(m, hd, "Brow", V(h.X * 0.36, h.Y * 0.12, h.Z * 0.2), CF(x * h.X * 0.19, h.Y * 0.16, -h.Z * 0.46) * A(rad(-10), 0, rad(-x * 12)), stone, Enum.Material.Slate)
			round(m, hd, "Eye", V(h.X * 0.18, h.Y * 0.08, 0.06), CF(x * h.X * 0.19, h.Y * 0.06, -h.Z * 0.52), omega and C(255, 60, 60) or C(225, 30, 30), Enum.Material.SmoothPlastic)
			-- deep vertical creases down the cheeks and the forehead
			piece(m, hd, "Crease", V(0.04, h.Y * 0.36, 0.04), CF(x * h.X * 0.27, -h.Y * 0.2, -h.Z * 0.54) * A(0, 0, rad(x * 8)), crease)
			piece(m, hd, "Crease", V(0.04, h.Y * 0.18, 0.04), CF(x * h.X * 0.06, h.Y * 0.28, -h.Z * 0.52), crease)
		end
		k.wedge(m, hd, "Nose", V(h.X * 0.16, h.Y * 0.22, 0.14), CF(0, -h.Y * 0.06, -h.Z * 0.56), stone, Enum.Material.Slate)
		piece(m, hd, "Mouth", V(h.X * 0.34, h.Y * 0.035, 0.04), CF(0, -h.Y * 0.32, -h.Z * 0.56), crease)
		-- ridged helmet-cap with cheek guards
		round(m, hd, "Helm", V(h.X * 1.12, h.Y * 0.62, h.Z * 1.12), CF(0, h.Y * 0.32, 0.03), helmC, Enum.Material.Metal)
		round(m, hd, "HelmBack", V(h.X * 1.08, h.Y * 0.95, h.Z * 0.6), CF(0, -h.Y * 0.02, h.Z * 0.26), helmC, Enum.Material.Metal)
		for _, x in { -1, 1 } do
			piece(m, hd, "Guard", V(h.X * 0.14, h.Y * 0.62, h.Z * 0.72), CF(x * h.X * 0.52, -h.Y * 0.08, h.Z * 0.02), helmC, Enum.Material.Metal)
			for j = 0, 1 do piece(m, hd, "Ridge", V(h.X * 0.06, h.Y * 0.08, h.Z * 1.02), CF(x * h.X * (0.18 + j * 0.16), h.Y * 0.58 - j * h.Y * 0.06, 0.03), helmC:Lerp(C(0, 0, 0), 0.25), Enum.Material.Metal) end
		end
		if apok or absolute then -- horned crown of the god
			for _, x in { -1, 1 } do k.tri(m, hd, "Horn", h.X * 0.1, h.Y * 0.6, h.Z * 0.24, CF(x * h.X * 0.4, h.Y * 0.75, 0) * A(0, 0, rad(-x * 20)), plateC, Enum.Material.Metal) end
		end
	end

	local function body(m)
		local t, w = chestOf(m), waistOf(m)
		if t then
			local c = t.Size
			-- tunic collar line + chest plate trim
			round(m, t, "Collar", V(c.X * 0.48, c.Y * 0.2, c.Z * 0.98), CF(0, c.Y * 0.46, 0.02), stone:Lerp(tunic, 0.2), Enum.Material.Slate)
			if plated then
				round(m, t, "ChestPlate", V(c.X * 0.86, c.Y * 0.5, 0.25), CF(0, c.Y * 0.18, -c.Z * 0.45), plateC, Enum.Material.Metal)
			end
			if glow then -- energy cracks / Omega on the chest
				for i, o in { { -0.25, 0.25, 30 }, { 0.22, 0.1, -50 }, { -0.1, -0.2, 70 }, { 0.3, -0.25, 20 } } do
					piece(m, t, "Crack", V(c.X * 0.22, 0.05, 0.05), CF(o[1] * c.X, o[2] * c.Y, -c.Z * 0.5 - 0.1) * A(0, 0, rad(o[3])), glow, Enum.Material.Neon)
				end
				k.label(m, t, "Omega", V(c.X * 0.32, c.Y * 0.32, 0.02), CF(0, c.Y * 0.18, -c.Z * 0.5 - 0.14), "Ω", glow)
				local l = Instance.new("PointLight"); l.Color = glow; l.Range = 10; l.Brightness = 1.2; l.Parent = t
			end
		end
		if w then
			local l = w.Size
			ring(m, w, "Belt", l.X * 0.54, l.Z * 0.57, 0.42, 0.1, CF(0, l.Y * 0.25, 0), dark, nil, 10)
			local b = round(m, w, "Buckle", V(l.X * 0.32, 0.5, 0.12), CF(0, l.Y * 0.25, -l.Z * 0.6), C(150, 25, 25), Enum.Material.Metal)
			k.label(m, w, "OmegaBuckle", V(l.X * 0.26, 0.42, 0.02), CF(0, l.Y * 0.25, -l.Z * 0.6 - 0.07), "Ω", C(255, 215, 120))
			-- tunic skirt panels to mid-thigh
			for i = 0, 7 do
				local a = (i + 0.5) / 8 * math.pi * 2
				piece(m, w, "Skirt", V(l.X * 0.36, l.Y * 1.5, 0.08), CF(math.sin(a) * l.X * 0.52, -l.Y * 0.45, -math.cos(a) * l.Z * 0.58) * A(0, -a, 0) * A(rad(7), 0, 0), plated and plateC or tunic, plated and Enum.Material.Metal or Enum.Material.Fabric)
			end
		end
	end

	local function limbs(m)
		for _, n in { "LeftLowerArm", "RightLowerArm" } do -- flared gauntlet cuffs
			local a = m:FindFirstChild(n)
			if a then band(m, a, "Cuff", a.Size.X * 1.22, 0.14, CF(0, a.Size.Y * 0.38, 0), plateC, Enum.Material.Metal) end
		end
		for _, n in { "LeftLowerLeg", "RightLowerLeg" } do
			local a = m:FindFirstChild(n)
			if a then band(m, a, "BootTop", a.Size.X * 1.18, 0.14, CF(0, a.Size.Y * 0.3, 0), plateC, Enum.Material.Metal) end
		end
		for _, n in { "LeftUpperArm", "RightUpperArm" } do -- rounded shoulder plates
			local a = m:FindFirstChild(n)
			if a then
				round(m, a, "Pauldron", V(a.Size.X * 1.38, a.Size.Y * 0.62, a.Size.Z * 1.34), CF(0, a.Size.Y * 0.36, 0), plated and plateC or tunic:Lerp(C(0, 0, 0), 0.2), Enum.Material.Metal)
				if armored or absolute then
					for j = -1, 1 do H.spike(m, a, CF(j * a.Size.X * 0.32, a.Size.Y * 0.62, 0), C(120, 120, 130)) end
				end
			end
		end
		if apok then k.cape(m, C(25, 22, 22), { n = 5, len = 2.2, arc = 100, fan = 9, r = 0.5, pitch = 7, top = 0.42, drape = 0.7, inner = C(120, 25, 15) }) end
	end

	local colors = { Head = stone, Chest = tunic, Waist = tunic, Arms = tunic, Gloves = plateC, Legs = dark, Boots = plateC }
	if plated then colors.Chest = plateC; colors.Arms = plateC; colors.Waist = plateC end
	return { colors = colors, pieces = { head, body, limbs } }
end
