-- SpongeBob SquarePants: ONE tall porous yellow sponge block (no separate head) with wavy edges, huge round blue eyes close together
-- with three lashes each, long tube nose, freckled rosy cheeks, wide smile with two buck teeth; white shirt band with collar points
-- and a red tie, square brown pants with a notched black belt, stick-thin yellow arms and legs, short white sleeves,
-- white socks with red/blue stripes and big shiny black shoes.
-- Costume module: return function(s, H, rarity) -> { colors = { group = Color3 }, pieces = { { "Piece", args... } | function(m) end } }
-- s = skin variant (Name, Primary = sponge, Secondary = pants, Tie, Shirt, Hat, Karate, Gar, Cape, Emblem, Mask...), H = shared helpers, rarity = tier name
return function(s, H, rarity)
	local C, WHITE = H.C, H.WHITE
	local piece, round, band, find, chestOf, waistOf, glyph = H.piece, H.round, H.band, H.find, H.chestOf, H.waistOf, H.glyph
	local function each(m, names, fn) for _, n in names do local a = m:FindFirstChild(n); if a then fn(a, n:find("Left") and -1 or 1) end end end
	local V, CF = Vector3.new, CFrame.new
	local cyl = Enum.PartType.Cylinder
	local face = CFrame.Angles(0, math.rad(90), 0) -- turns an X-axis cylinder to face forward
	local sponge = s.Primary
	local pore = sponge:Lerp(C(150, 160, 30), 0.4)
	local shirt, tie = s.Shirt or WHITE, s.Tie or C(210, 30, 30)
	local BLACK = C(20, 20, 22)
	local SLATE = Enum.Material.Slate

	local pieces = {}
	-- the sponge: built on the chest, spanning from the shirt up to where the head would be (the box head is hidden)
	table.insert(pieces, function(m)
		local t = chestOf(m); if not t then return end
		local hd = find(m, "Head")
		local sz = t.Size
		local headH = hd and hd.Size.Y or 1.2
		if hd then hd.Transparency = 1 end
		local bot, top = -sz.Y * 0.5, sz.Y * 0.5 + headH * 1.3
		local W, Hh, D = sz.X * 0.86, top - bot, sz.Z * 1.45
		local cy = (top + bot) / 2
		local box = piece(m, t, "Sponge", V(W, Hh, D), CF(0, cy, 0), sponge, SLATE)
		-- wavy edges: soft bumps along the top and down the sides
		for i = -2, 2 do round(m, box, "Wave", V(W * 0.24, Hh * 0.08, D * 0.98), CF(i * W * 0.2, Hh / 2, 0), sponge, SLATE) end
		for _, x in { -1, 1 } do for j = 0, 2 do
			round(m, box, "Wave", V(W * 0.07, Hh * 0.22, D * 0.98), CF(x * W / 2, Hh * (0.28 - j * 0.28), 0), sponge, SLATE)
		end end
		-- pores: darker ovals on the front, back and sides
		local rng = Random.new(7)
		local spots = { { -0.36, 0.38 }, { 0.38, 0.34 }, { -0.4, -0.05 }, { 0.4, -0.1 }, { -0.12, -0.32 }, { 0.3, -0.36 }, { 0.0, 0.42 } }
		for i, uv in spots do
			local r = rng:NextNumber(0.1, 0.2)
			round(m, box, "Pore", V(r, r * 1.2, 0.04), CF(uv[1] * W, uv[2] * Hh, -D / 2 - 0.01), pore)
			round(m, box, "Pore", V(r, r * 1.2, 0.04), CF(-uv[1] * W, uv[2] * Hh * 0.9, D / 2 + 0.01), pore)
			if i <= 3 then
				for _, x in { -1, 1 } do round(m, box, "Pore", V(0.04, r, r), CF(x * (W / 2 + 0.01), uv[2] * Hh, uv[1] * D), pore) end
			end
		end
		-- face (upper part of the block)
		local fz = -D / 2
		local ey = Hh * 0.2
		local eR = W * 0.34
		for _, x in { -1, 1 } do
			local ex = x * W * 0.17
			piece(m, box, "Sclera", V(0.08, eR, eR), CF(ex, ey, fz - 0.03) * face, C(252, 252, 252), nil, cyl)
			piece(m, box, "Iris", V(0.1, eR * 0.5, eR * 0.5), CF(ex - x * eR * 0.04, ey - eR * 0.02, fz - 0.04) * face, s.Iris or C(70, 150, 230), nil, cyl)
			piece(m, box, "Pupil", V(0.12, eR * 0.22, eR * 0.22), CF(ex - x * eR * 0.04, ey - eR * 0.02, fz - 0.05) * face, BLACK, nil, cyl)
			for k = -1, 1 do
				piece(m, box, "Lash", V(0.04, eR * 0.3, 0.04), CF(ex + k * eR * 0.24, ey + eR * 0.6, fz - 0.03) * CFrame.Angles(0, 0, math.rad(-k * 22)), BLACK)
			end
			local cx, cyc = x * W * 0.33, -Hh * 0.04
			piece(m, box, "Cheek", V(0.05, W * 0.2, W * 0.2), CF(cx, cyc, fz - 0.02) * face, sponge:Lerp(C(255, 110, 80), 0.35), nil, cyl)
			for k = 0, 2 do round(m, box, "Freckle", V(0.05, 0.05, 0.03), CF(cx + (k - 1) * W * 0.04, cyc + (k % 2) * W * 0.03, fz - 0.05), C(200, 100, 60)) end
		end
		local nose = piece(m, box, "Nose", V(D * 0.45, W * 0.1, W * 0.1), CF(0, ey - eR * 0.5, fz - D * 0.22) * face, sponge, nil, cyl)
		round(m, nose, "NoseTip", V(W * 0.13, W * 0.12, W * 0.12), CF(nose.Size.X / 2, 0, 0), sponge)
		-- smile: dark crescent (mouth oval masked by a sponge oval), dimples, buck teeth
		local my = -Hh * 0.1
		round(m, box, "Mouth", V(W * 0.62, Hh * 0.14, 0.04), CF(0, my, fz - 0.02), C(120, 30, 30))
		round(m, box, "MouthMask", V(W * 0.66, Hh * 0.12, 0.04), CF(0, my + Hh * 0.04, fz - 0.03), sponge, SLATE)
		for _, x in { -1, 1 } do
			piece(m, box, "BuckTooth", V(W * 0.09, Hh * 0.075, 0.05), CF(x * W * 0.05, my - Hh * 0.075, fz - 0.04), WHITE)
			piece(m, box, "Dimple", V(W * 0.05, 0.035, 0.03), CF(x * W * 0.32, my + Hh * 0.0, fz - 0.035) * CFrame.Angles(0, 0, math.rad(x * 50)), C(120, 30, 30))
		end
		if s.Mask then -- Invincibubble domino mask
			piece(m, box, "Mask", V(W * 0.86, eR * 0.5, 0.03), CF(0, ey, fz - 0.015), s.Mask)
		end
		if s.Hat then -- Krusty Krab paper sailor cap: folded crown, blue band, anchor
			local cap = piece(m, box, "Hat", V(W * 0.55, Hh * 0.13, D * 0.6), CF(0, Hh / 2 + Hh * 0.08, 0), WHITE, Enum.Material.Fabric)
			for _, z in { -1, 1 } do
				local w = piece(m, cap, "HatFold", V(cap.Size.X, cap.Size.Y * 0.9, cap.Size.Z * 0.5), CF(0, cap.Size.Y * 0.9, z * cap.Size.Z * 0.25) * CFrame.Angles(0, z > 0 and math.rad(180) or 0, 0), WHITE, Enum.Material.Fabric)
				Instance.new("SpecialMesh", w).MeshType = Enum.MeshType.Wedge
			end
			piece(m, cap, "HatBand", V(cap.Size.X * 1.02, cap.Size.Y * 0.35, cap.Size.Z * 1.04), CF(0, -cap.Size.Y * 0.2, 0), C(40, 80, 200), Enum.Material.Fabric)
			local tag = piece(m, cap, "Anchor", V(cap.Size.X * 0.3, cap.Size.Y * 0.9, 0.04), CF(0, cap.Size.Y * 0.5, -cap.Size.Z / 2 - 0.03), WHITE); tag.Transparency = 1
			glyph(tag, Enum.NormalId.Front, "⚓", C(40, 80, 200))
		end
		if s.Karate then -- karate helmet: padded dome over the top with a chin strap
			round(m, box, "KarateHelm", V(W * 1.0, Hh * 0.5, D * 1.3), CF(0, Hh * 0.46, 0), s.Karate, Enum.Material.Fabric)
			round(m, box, "Rim", V(W * 1.04, 0.12, D * 1.34), CF(0, Hh * 0.33, 0), s.Karate:Lerp(C(0, 0, 0), 0.1), Enum.Material.Fabric)
		end
		if not s.Gar then
			-- shirt band, collar points, tie knot
			local shY = bot + sz.Y * 0.1
			piece(m, t, "ShirtBand", V(W * 1.01, sz.Y * 0.2, D * 1.01), CF(0, shY, 0), shirt)
			for _, x in { -1, 1 } do
				piece(m, t, "CollarPoint", V(W * 0.14, sz.Y * 0.12, 0.05), CF(x * W * 0.09, shY + sz.Y * 0.02, fz - 0.03) * CFrame.Angles(0, 0, math.rad(x * 35)), shirt)
			end
			piece(m, t, "TieKnot", V(W * 0.09, sz.Y * 0.1, 0.1), CF(0, shY, fz - 0.06), tie)
			local tl = piece(m, t, "Tie", V(W * 0.1, sz.Y * 0.3, 0.06), CF(0, shY - sz.Y * 0.2, fz - 0.06), tie)
			piece(m, tl, "TieTip", V(tl.Size.X * 0.72, tl.Size.X * 0.72, 0.06), CF(0, -tl.Size.Y / 2, 0) * CFrame.Angles(0, 0, math.rad(45)), tie)
		end
	end)
	if not s.Gar then
		table.insert(pieces, function(m) -- square pants + black belt with white notches, short square pant legs
			local t, w = chestOf(m), waistOf(m); if not t or not w or w == t then return end
			local W, D = t.Size.X * 0.86, t.Size.Z * 1.45
			local sz = w.Size
			local pants = piece(m, w, "Pants", V(W, sz.Y * 1.5, D), CF(0, -sz.Y * 0.1, 0), s.Secondary, Enum.Material.Fabric)
			local belt = piece(m, pants, "Belt", V(W * 1.01, 0.14, D * 1.01), CF(0, pants.Size.Y / 2 - 0.1, 0), BLACK)
			for i = -3, 3 do piece(m, belt, "Notch", V(0.12, 0.06, 0.02), CF(i * W * 0.13, 0, -belt.Size.Z / 2 - 0.01), WHITE) end
			each(m, { "LeftUpperLeg", "RightUpperLeg" }, function(a)
				piece(m, a, "PantLeg", V(a.Size.X * 2.4, a.Size.Y * 0.5, a.Size.Z * 2.4), CF(0, a.Size.Y * 0.25, 0), s.Secondary, Enum.Material.Fabric)
			end)
			each(m, { "LeftUpperArm", "RightUpperArm" }, function(a) -- short white sleeves
				band(m, a, "Sleeve", a.Size.X * 2.3, a.Size.Y * 0.45, CF(0, a.Size.Y * 0.28, 0), s.Shirt or WHITE)
			end)
		end)
	else -- SpongeGar: caveman, bare sponge with a spotted fur loincloth
		table.insert(pieces, function(m)
			local t, w = chestOf(m), waistOf(m); if not t or not w then return end
			local W, D = t.Size.X * 0.86, t.Size.Z * 1.45
			for i = 0, 7 do
				local a = i / 8 * math.pi * 2
				local f = piece(m, w, "Fur", V(W * 0.32, 0.75, 0.1), CF(math.sin(a) * W * 0.47, -0.25, math.cos(a) * D * 0.5) * CFrame.Angles(0, a, 0) * CFrame.Angles(math.rad(-10), 0, math.rad(i % 2 == 0 and 8 or -8)), C(150, 105, 60), Enum.Material.Fabric)
				if i % 2 == 0 then round(m, f, "Spot", V(0.18, 0.18, 0.04), CF(0, 0.05, 0.06), C(90, 60, 35)) end
			end
		end)
	end
	table.insert(pieces, function(m) -- white socks with red + blue stripes, big shiny shoes
		each(m, { "LeftLowerLeg", "RightLowerLeg" }, function(a)
			for k, c in { C(210, 30, 30), C(40, 90, 210) } do band(m, a, "SockStripe", a.Size.X * 1.15, 0.07, CF(0, a.Size.Y * (0.36 - k * 0.12), 0), c) end
		end)
		each(m, { "LeftFoot", "RightFoot" }, function(f)
			round(m, f, "Shoe", V(f.Size.X * 1.25, f.Size.Y * 1.5, f.Size.Z * 1.4), CF(0, 0, -f.Size.Z * 0.12), BLACK, Enum.Material.Glass)
		end)
	end)
	if s.Cape or s.Emblem then -- superhero looks: cape off the back of the sponge, emblem on the shirt
		table.insert(pieces, function(m)
			local box = m:FindFirstChild("Costume_Sponge"); if not box then return end
			local b = box.Size
			if s.Cape then
				piece(m, box, "Cape", V(b.X * 1.0, b.Y * 1.25, 0.1), CF(0, -b.Y * 0.2, b.Z / 2 + 0.08) * CFrame.Angles(math.rad(-6), 0, 0), s.Cape, Enum.Material.Fabric)
			end
			if s.Emblem then
				local e = piece(m, box, "Emblem", V(b.X * 0.28, b.Y * 0.18, 0.05), CF(b.X * 0.3, -b.Y * 0.3, -b.Z / 2 - 0.04), WHITE); e.Transparency = 1
				glyph(e, Enum.NormalId.Front, s.Emblem, s.Tie or WHITE)
			end
		end)
	end
	if s.Karate then
		table.insert(pieces, function(m) -- karate mitts
			each(m, { "LeftHand", "RightHand" }, function(h)
				round(m, h, "Mitt", h.Size * V(1.5, 2.0, 1.5), CF(0, -h.Size.Y * 0.4, 0), s.Karate, Enum.Material.Fabric)
			end)
		end)
	end
	if s.Rock then -- Goofy Goober Rock: silver shoulder spikes
		table.insert(pieces, function(m)
			each(m, { "LeftUpperArm", "RightUpperArm" }, function(a, x)
				local pad = round(m, a, "RockPad", V(0.6, 0.3, 0.6), CF(0, a.Size.Y * 0.45, 0), C(200, 200, 215), Enum.Material.Metal)
				for k = -1, 1 do
					local sp = piece(m, pad, "RockSpike", V(0.1, 0.35, 0.1), CF(k * 0.17, 0.2, 0), C(220, 220, 230), Enum.Material.Metal)
					Instance.new("SpecialMesh", sp).MeshType = Enum.MeshType.Wedge
				end
			end)
		end)
	end
	return { colors = { Head = sponge, Chest = sponge, Waist = s.Gar and sponge or s.Secondary, Arms = sponge, Hands = sponge,
		UpperLegs = sponge, LowerLegs = WHITE, Feet = BLACK }, pieces = pieces }
end
