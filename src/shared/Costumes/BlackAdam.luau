-- Black Adam: black suit, big gold lightning bolt down the chest, wide gold belt, gold gauntlets and boots,
-- short cream cape with gold shoulder clasps, black hair in a sharp widow's peak, pointed ears, permanent scowl.
-- Variants: Movie (bald, glowing bolt seams, no cape), Kahndaq Champion (blue lightning), Teth-Adam (Egyptian nemes,
-- broad collar, linen kilt), Champion of Shazam (red/gold, white cape), God of Kahndaq (radiant, crowned).
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
	local C, WHITE = H.C, H.WHITE
	local piece, round, band, ring, find, chestOf, waistOf = H.piece, H.round, H.band, H.ring, H.find, H.chestOf, H.waistOf
	local k = kit(H)
	local suit, gold = s.Primary, s.Secondary
	local boltC = gold
	if rarity == "Epic" then gold = C(225, 180, 50) end -- Kahndaq Champion: blue lightning, gold trim
	local movie, champ, teth, shazam, god = rarity == "Rare", rarity == "Epic", rarity == "Legendary", rarity == "Mythic", rarity == "Secret"
	local skin = C(170, 120, 85)
	local hairC = C(14, 12, 12)
	local boltMat = (champ or god or movie) and Enum.Material.Neon or Enum.Material.Metal
	local capeC = shazam and C(245, 245, 240) or god and C(255, 250, 230) or C(225, 210, 175)

	local function bolt(m, a, cf, ht, color, mt)
		local w = ht * 0.17
		piece(m, a, "Bolt", V(w, ht * 0.5, 0.05), cf * CF(ht * 0.08, ht * 0.24, 0) * A(0, 0, rad(-28)), color, mt)
		piece(m, a, "Bolt", V(w * 1.1, ht * 0.32, 0.05), cf * A(0, 0, rad(62)), color, mt)
		k.flat(m, a, "Bolt", w * 1.6, ht * 0.5, 0.05, cf * CF(-ht * 0.08, -ht * 0.26, 0) * A(0, 0, math.pi + rad(-28)), color, mt)
	end

	local function head(m)
		local hd = find(m, "Head"); if not hd then return end
		local h = hd.Size
		k.face(m, { iris = C(40, 30, 25), brow = hairC, style = "angry", skin = skin })
		for _, x in { -1, 1 } do -- pointed ears
			k.tri(m, hd, "EarTip", 0.07, h.Y * 0.22, h.Z * 0.16, CF(x * h.X * 0.52, h.Y * 0.16, h.Z * 0.04) * A(rad(-20), 0, rad(-x * 10)), skin)
		end
		if movie then return end -- bald
		if teth then -- striped nemes headdress
			round(m, hd, "Nemes", V(h.X * 1.14, h.Y * 0.7, h.Z * 1.14), CF(0, h.Y * 0.26, 0.02), gold, Enum.Material.Metal)
			band(m, hd, "Brow", h.X * 1.12, h.Y * 0.08, CF(0, h.Y * 0.2, 0.02), C(40, 70, 160))
			for _, x in { -1, 1 } do
				piece(m, hd, "Lappet", V(h.X * 0.3, h.Y * 1.0, h.Z * 0.16), CF(x * h.X * 0.45, -h.Y * 0.45, -h.Z * 0.05) * A(0, 0, rad(-x * 8)), gold, Enum.Material.Metal)
				for j = 0, 2 do piece(m, hd, "Stripe", V(h.X * 0.31, 0.05, h.Z * 0.17), CF(x * h.X * 0.45, -h.Y * (0.2 + j * 0.25), -h.Z * 0.05) * A(0, 0, rad(-x * 8)), C(40, 70, 160)) end
			end
			round(m, hd, "NemesBack", V(h.X * 1.1, h.Y * 1.2, h.Z * 0.5), CF(0, -h.Y * 0.2, h.Z * 0.32), gold, Enum.Material.Metal)
			return
		end
		k.hair(m, hairC, { top = 0.52, y = 0.34, back = 0.65 })
		k.flat(m, hd, "WidowsPeak", h.X * 0.32, h.Y * 0.2, 0.06, CF(0, h.Y * 0.28, k.fz(h, 0, 0.0)) * A(0, 0, math.pi), hairC)
		if god then -- gold crown of lightning
			band(m, hd, "Crown", h.X * 1.12, h.Y * 0.1, CF(0, h.Y * 0.4, 0.02), gold, Enum.Material.Metal)
			for i = -2, 2 do k.flat(m, hd, "CrownPoint", h.X * 0.14, h.Y * (0.32 - math.abs(i) * 0.05), 0.06, CF(i * h.X * 0.18, h.Y * 0.58, k.fz(h, i * h.X * 0.18, -0.02)), gold, Enum.Material.Metal) end
		end
	end

	local function chest(m)
		local t = chestOf(m); if not t then return end
		local c = t.Size
		bolt(m, t, CF(0, c.Y * 0.02, -c.Z / 2 - 0.05), c.Y * 0.95, boltC, boltMat)
		if movie then -- glowing seams of the film suit
			for _, x in { -1, 1 } do piece(m, t, "Seam", V(0.05, c.Y * 0.8, 0.04), CF(x * c.X * 0.36, -c.Y * 0.05, -c.Z * 0.47) * A(0, 0, rad(x * 8)), gold, Enum.Material.Neon) end
		end
		if teth then -- broad Egyptian collar (usekh) in gold and lapis rows
			for j, col in { gold, C(40, 70, 160), gold } do
				round(m, t, "Collar", V(c.X * (0.72 + j * 0.06), c.Y * 0.3, c.Z * (1.06 + j * 0.02)), CF(0, c.Y * (0.48 - j * 0.04), 0.02), col, j % 2 == 1 and Enum.Material.Metal or nil)
			end
		end
	end

	local function waist(m)
		local w = waistOf(m); if not w then return end
		local l = w.Size
		ring(m, w, "Belt", l.X * 0.53, l.Z * 0.56, 0.36, 0.1, CF(0, l.Y * 0.28, 0), gold, Enum.Material.Metal, 10)
		round(m, w, "Buckle", V(l.X * 0.24, 0.38, 0.1), CF(0, l.Y * 0.28, -l.Z * 0.58), gold:Lerp(WHITE, 0.2), Enum.Material.Metal)
		if teth then -- pleated linen kilt (shendyt)
			for i = 0, 7 do
				local a = (i + 0.5) / 8 * math.pi * 2
				piece(m, w, "Kilt", V(l.X * 0.32, l.Y * 1.7, 0.06), CF(math.sin(a) * l.X * 0.5, -l.Y * 0.62, -math.cos(a) * l.Z * 0.56) * A(0, -a, 0) * A(rad(6), 0, 0), C(235, 225, 195), Enum.Material.Fabric)
			end
		end
	end

	local function limbs(m)
		for _, n in { "LeftLowerArm", "RightLowerArm" } do -- flared gold gauntlet cuffs
			local a = m:FindFirstChild(n)
			if a then band(m, a, "GauntletTop", a.Size.X * 1.2, 0.1, CF(0, a.Size.Y * 0.1, 0), gold, Enum.Material.Metal) end
		end
		for _, n in { "LeftLowerLeg", "RightLowerLeg" } do
			local a = m:FindFirstChild(n)
			if a then band(m, a, "BootTop", a.Size.X * 1.16, 0.1, CF(0, a.Size.Y * 0.2, 0), gold, Enum.Material.Metal) end
		end
	end

	local function cape(m)
		if movie or teth then return end
		local t = chestOf(m); if not t then return end
		k.cape(m, capeC, { n = 5, len = 1.5, arc = 110, fan = 8, r = 0.5, pitch = 8, top = 0.44, drape = 0.55 })
		for _, x in { -1, 1 } do -- round gold clasps where the cape meets the shoulders
			round(m, t, "Clasp", V(t.Size.X * 0.13, t.Size.X * 0.13, 0.1), CF(x * t.Size.X * 0.3, t.Size.Y * 0.36, -t.Size.Z * 0.48), gold, Enum.Material.Metal)
		end
	end

	local colors = { Head = skin, Chest = suit, Waist = suit, Arms = suit, Gloves = gold, Legs = suit, Boots = gold }
	if teth then colors.Chest = skin; colors.Arms = skin; colors.Legs = skin; colors.Waist = C(235, 225, 195) end
	if movie then colors.Gloves = suit; colors.Boots = suit end
	return { colors = colors, pieces = { head, chest, waist, limbs, cape } }
end
