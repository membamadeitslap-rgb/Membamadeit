-- Finn (Adventure Time): rounded white bear hat (two little round ears) with a big face opening, black dot eyes and a wide open grin,
-- light-blue tee with short sleeves, noodle arms, dark-blue shorts, skinny bare legs, white knee socks, black shoes, green backpack.
-- Costume module: return function(s, H, rarity) -> { colors = { group = Color3 }, pieces = { { "Piece", args... } | function(m) end } }
-- s = skin variant (Name, Primary = shirt, Secondary = shorts, Hat, Pack, Hatless, GrassArm, RobotArm, Fern, Bunny...), H = shared helpers, rarity = tier name
return function(s, H, rarity)
	local C, WHITE = H.C, H.WHITE
	local piece, round, band, find, chestOf, waistOf = H.piece, H.round, H.band, H.find, H.chestOf, H.waistOf
	local function each(m, names, fn) for _, n in names do local a = m:FindFirstChild(n); if a then fn(a, n:find("Left") and -1 or 1) end end end
	local CYL, V, CF = Enum.PartType.Cylinder, Vector3.new, CFrame.new
	local FAB = Enum.Material.Fabric
	local skin = s.Skin or C(250, 215, 180)
	local hat = s.Hat or WHITE
	local pack = s.Pack or C(90, 170, 70)
	local HAIR = C(250, 215, 100)
	local INK = C(20, 20, 22)
	local fionna = s.Bunny

	-- rounded-rectangle slab: rounded corners seen from the front, depth d along Z
	local function rbox(m, a, name, w, h, d, r, cf, color, mat)
		local core = piece(m, a, name, V(w, h - 2 * r, d), cf, color, mat)
		piece(m, a, name, V(w - 2 * r, h, d), cf, color, mat)
		for _, x in { -1, 1 } do for _, y in { -1, 1 } do
			piece(m, a, name, V(d, 2 * r, 2 * r), cf * CF(x * (w / 2 - r), y * (h / 2 - r), 0) * CFrame.Angles(0, math.rad(90), 0), color, mat, CYL)
		end end
		return core
	end

	local pieces = {}
	-- head: the box head is replaced by Finn's rounded head shape (hat shell, or bare head with long hair)
	table.insert(pieces, function(m)
		local hd = find(m, "Head"); if not hd then return end
		hd.Transparency = 1
		local sz = hd.Size
		local W, Hh, D = sz.X * 1.12, sz.Y * 1.12, sz.Z * 1.0
		local c0 = CF(0, sz.Y * 0.04, 0)
		local fz = -D / 2
		if s.Hatless then
			rbox(m, hd, "Skull", W * 0.96, Hh * 0.98, D * 0.94, W * 0.3, c0, skin)
			-- long golden hair: crown cap, swept bangs, side curtains and a long fall down the back
			round(m, hd, "Hair", V(W * 1.08, Hh * 0.6, D * 1.1), c0 * CF(0, Hh * 0.3, D * 0.04), HAIR)
			for i = -1, 1 do
				round(m, hd, "Bang", V(W * 0.42, Hh * 0.26, 0.14), c0 * CF(i * W * 0.28, Hh * 0.3 - math.abs(i) * Hh * 0.03, fz - 0.02) * CFrame.Angles(0, 0, math.rad(-i * 14 - 6)), HAIR)
			end
			for _, x in { -1, 1 } do
				round(m, hd, "Lock", V(W * 0.22, Hh * 1.25, D * 0.7), c0 * CF(x * W * 0.5, -Hh * 0.2, D * 0.12) * CFrame.Angles(0, 0, math.rad(x * 4)), HAIR)
			end
			round(m, hd, "HairBack", V(W * 1.1, Hh * 2.3, D * 0.45), c0 * CF(0, -Hh * 0.75, D * 0.48) * CFrame.Angles(math.rad(-6), 0, 0), HAIR)
		else
			-- hat shell: rounded slab, slightly rounded back
			rbox(m, hd, "Hat", W, Hh, D * 0.7, W * 0.3, c0 * CF(0, 0, -D * 0.15), hat, FAB)
			round(m, hd, "HatBack", V(W * 1.0, Hh * 1.0, D * 0.94), c0 * CF(0, 0, D * 0.0), hat, FAB)
			-- face opening
			rbox(m, hd, "FaceSkin", W * 0.76, Hh * 0.58, 0.04, W * 0.2, c0 * CF(0, -Hh * 0.1, fz - 0.01), skin)
			if fionna then -- tall bunny ears with pink inner
				for _, x in { -1, 1 } do
					local ear = round(m, hd, "HatEar", V(W * 0.22, Hh * 0.8, D * 0.18), c0 * CF(x * W * 0.25, Hh * 0.85, 0) * CFrame.Angles(0, 0, math.rad(-x * 10)), hat, FAB)
					round(m, ear, "HatEarInner", V(ear.Size.X * 0.5, ear.Size.Y * 0.75, 0.05), CF(0, -ear.Size.Y * 0.04, -ear.Size.Z * 0.42), C(255, 185, 205), FAB)
				end
			else -- little round bear ears on the top corners
				for _, x in { -1, 1 } do
					round(m, hd, "HatEar", V(W * 0.26, W * 0.24, D * 0.3), c0 * CF(x * W * 0.33, Hh * 0.5, 0), hat, FAB)
				end
			end
			if s.Fern then -- Fern's grass hat: leaf blades sprouting off the top
				for i = -1, 1 do
					round(m, hd, "Leaf", V(0.14, Hh * 0.45, 0.3), c0 * CF(i * W * 0.2, Hh * 0.62, 0) * CFrame.Angles(0, 0, math.rad(-i * 28)), C(70, 150, 50), Enum.Material.Grass)
				end
			end
			if fionna then -- blonde locks peeking out from under the hat
				for _, x in { -1, 1 } do round(m, hd, "Lock", V(W * 0.16, Hh * 0.35, 0.1), c0 * CF(x * W * 0.3, Hh * 0.14, fz - 0.04), HAIR) end
			end
		end
		-- face: black dot eyes, wide open grin (dark crescent: mouth oval masked by a skin oval)
		local ey = s.Hatless and -Hh * 0.02 or -Hh * 0.0
		local fzz = fz - (s.Hatless and 0.0 or 0.05)
		for _, x in { -1, 1 } do
			round(m, hd, "Eye", V(W * 0.09, W * 0.11, 0.05), c0 * CF(x * W * 0.2, ey, fzz - 0.01), INK)
			if fionna then piece(m, hd, "Lash", V(W * 0.06, 0.03, 0.03), c0 * CF(x * W * 0.26, ey + W * 0.04, fzz - 0.02) * CFrame.Angles(0, 0, math.rad(x * 30)), INK) end
		end
		local my = -Hh * 0.2
		round(m, hd, "Mouth", V(W * 0.34, Hh * 0.17, 0.04), c0 * CF(0, my, fzz - 0.01), C(70, 25, 30))
		round(m, hd, "Tongue", V(W * 0.16, Hh * 0.06, 0.04), c0 * CF(0, my - Hh * 0.05, fzz - 0.015), C(230, 110, 120))
		round(m, hd, "MouthMask", V(W * 0.42, Hh * 0.12, 0.04), c0 * CF(0, my + Hh * 0.075, fzz - 0.02), skin)
		piece(m, hd, "Teeth", V(W * 0.2, Hh * 0.025, 0.04), c0 * CF(0, my + Hh * 0.005, fzz - 0.022), WHITE)
	end)
	-- tee: short sleeves over the noodle arms, collar
	table.insert(pieces, function(m)
		local t = chestOf(m); if not t then return end
		local sz = t.Size
		local col = s.Primary:Lerp(C(0, 0, 0), 0.2)
		piece(m, t, "Collar", V(sz.X * 0.34, 0.06, 0.06), CF(0, sz.Y * 0.47, -sz.Z * 0.42), col)
		each(m, { "LeftUpperArm", "RightUpperArm" }, function(a)
			band(m, a, "Sleeve", a.Size.X * 1.14, a.Size.Y * 0.55, CF(0, a.Size.Y * 0.2, 0), s.Primary, FAB)
			band(m, a, "SleeveHem", a.Size.X * 1.16, 0.05, CF(0, -a.Size.Y * 0.06, 0), col, FAB)
		end)
	end)
	-- green backpack: rounded pack, flap, buckle, straps over the shoulders
	table.insert(pieces, function(m)
		local t = chestOf(m); if not t then return end
		local sz = t.Size
		local bag = rbox(m, t, "Pack", sz.X * 0.8, sz.Y * 0.95, sz.Z * 0.75, sz.X * 0.18, CF(0, -sz.Y * 0.02, sz.Z * 0.5 + sz.Z * 0.36), pack, FAB)
		local dark = pack:Lerp(C(0, 0, 0), 0.22)
		round(m, t, "Flap", V(sz.X * 0.82, sz.Y * 0.5, sz.Z * 0.5), CF(0, sz.Y * 0.28, sz.Z * 0.5 + sz.Z * 0.52), pack:Lerp(C(0, 0, 0), 0.1), FAB)
		piece(m, t, "Buckle", V(sz.X * 0.12, sz.Y * 0.1, 0.06), CF(0, sz.Y * 0.08, sz.Z * 0.5 + sz.Z * 0.75), C(230, 200, 80), Enum.Material.Metal)
		round(m, bag, "Pocket", V(bag.Size.X * 0.6, bag.Size.Y * 0.3, sz.Z * 0.3), CF(0, -sz.Y * 0.28, sz.Z * 0.36), dark, FAB)
		for _, x in { -1, 1 } do
			piece(m, t, "Strap", V(sz.X * 0.11, 0.07, sz.Z * 1.1), CF(x * sz.X * 0.26, sz.Y * 0.5, 0), dark, FAB)
			piece(m, t, "StrapFront", V(sz.X * 0.11, sz.Y * 0.75, 0.05), CF(x * sz.X * 0.26, sz.Y * 0.12, -sz.Z * 0.5 + 0.0), dark, FAB)
		end
	end)
	-- shorts legs over the thighs, white socks up to the knee
	table.insert(pieces, function(m)
		each(m, { "LeftUpperLeg", "RightUpperLeg" }, function(a)
			band(m, a, "ShortLeg", a.Size.X * 1.3, a.Size.Y * 0.5, CF(0, a.Size.Y * 0.25, 0), s.Secondary, FAB)
		end)
		local w = waistOf(m)
		if w then round(m, w, "Seat", V(w.Size.X * 1.08, w.Size.Y * 2.4, w.Size.Z * 1.12), CF(0, -w.Size.Y * 0.3, 0), s.Secondary, FAB) end
		each(m, { "LeftLowerLeg", "RightLowerLeg" }, function(a)
			band(m, a, "Sock", a.Size.X * 1.08, a.Size.Y * 0.8, CF(0, -a.Size.Y * 0.1, 0), WHITE, FAB)
		end)
		if fionna then -- Fionna: dark skirt instead of shorts
			local wl = waistOf(m); if not wl then return end
			local z = wl.Size
			round(m, wl, "Skirt", V(z.X * 1.35, z.Y * 2.8, z.Z * 1.45), CF(0, -z.Y * 0.9, 0), s.Secondary, FAB)
		end
	end)
	if s.GrassArm then -- grass sword cursed arm: leafy green right forearm wrapped in grass blades
		table.insert(pieces, function(m)
			each(m, { "RightLowerArm", "RightHand" }, function(a)
				a.Color = C(80, 170, 60); a.Material = Enum.Material.Grass
			end)
			local a = find(m, "RightLowerArm"); if not a then return end
			for i = 0, 3 do
				round(m, a, "GrassBlade", V(a.Size.X * 0.35, a.Size.Y * 0.9, 0.1), CF(math.cos(i * 1.57) * a.Size.X * 0.4, a.Size.Y * 0.1, math.sin(i * 1.57) * a.Size.Z * 0.4) * CFrame.Angles(0, -i * 1.57, math.rad(15)), C(60, 140, 45), Enum.Material.Grass)
			end
		end)
	end
	if s.RobotArm then -- Farmworld / later-season mechanical arm
		table.insert(pieces, function(m)
			each(m, { "RightLowerArm", "RightHand" }, function(a)
				a.Color = C(150, 155, 165); a.Material = Enum.Material.Metal
			end)
			local a = find(m, "RightLowerArm"); if not a then return end
			band(m, a, "Joint", a.Size.X * 1.2, 0.14, CF(0, a.Size.Y * 0.4, 0), C(90, 90, 100), Enum.Material.Metal)
			band(m, a, "Joint", a.Size.X * 1.15, 0.1, CF(0, -a.Size.Y * 0.1, 0), C(90, 90, 100), Enum.Material.Metal)
		end)
	end
	if s.Fern then
		table.insert(pieces, function(m)
			for _, n in { "UpperTorso", "LeftLowerArm", "RightLowerArm" } do local p = find(m, n); if p then p.Material = Enum.Material.Grass end end
		end)
	end
	return { colors = { Head = skin, Chest = s.Primary, Waist = s.Secondary, UpperArms = skin, LowerArms = skin, Hands = skin, UpperLegs = skin, LowerLegs = skin, Feet = C(25, 25, 28) },
		pieces = pieces }
end
