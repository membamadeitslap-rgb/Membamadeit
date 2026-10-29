-- SpongeBob: boxy porous yellow head + body, huge round eyes with lashes, long nose, wide grin with buck teeth and freckled cheeks,
-- white shirt band with collar points and red tie, square brown pants with black belt, striped socks, shiny black shoes.
-- Costume module: return function(s, H, rarity) -> { colors = { group = Color3 }, pieces = { { "Piece", args... } | function(m) end } }
-- s = skin variant (Name, Primary = sponge, Secondary = pants, Tie, Shirt, Hat, Karate, Gar, Cape...), H = shared helpers, rarity = tier name
return function(s, H, rarity)
	local C, SKIN, GOLD, WHITE = H.C, H.SKIN, H.GOLD, H.WHITE
	local piece, find, chestOf, waistOf, front, glyph = H.piece, H.find, H.chestOf, H.waistOf, H.front, H.glyph
	local function each(m, names, fn) for _, n in names do local a = m:FindFirstChild(n); if a then fn(a, n:find("Left") and -1 or 1) end end end
	local function oval(p) Instance.new("SpecialMesh", p).MeshType = Enum.MeshType.Sphere; return p end
	local cyl = Enum.PartType.Cylinder
	local face = CFrame.Angles(0, math.rad(90), 0) -- turns an X-axis cylinder to face forward
	local sponge = s.Primary
	local pore = sponge:Lerp(C(120, 140, 20), 0.45)
	local shirt, tie = s.Shirt or WHITE, s.Tie or C(210, 30, 30)
	local BLACK = C(20, 20, 22)
	local function pores(m, box, n, seed)
		local rng = Random.new(seed)
		local sz = box.Size
		for i = 1, n do -- front, sides and back
			local f = i % 4
			local u, v = rng:NextNumber(-0.38, 0.38), rng:NextNumber(-0.38, 0.38)
			local r = rng:NextNumber(0.1, 0.2)
			local cf = f == 0 and CFrame.new(u * sz.X, v * sz.Y, -sz.Z / 2 - 0.01)
				or f == 1 and CFrame.new(u * sz.X, v * sz.Y, sz.Z / 2 + 0.01)
				or f == 2 and CFrame.new(-sz.X / 2 - 0.01, v * sz.Y, u * sz.Z) * CFrame.Angles(0, math.rad(90), 0)
				or CFrame.new(sz.X / 2 + 0.01, v * sz.Y, u * sz.Z) * CFrame.Angles(0, math.rad(90), 0)
			oval(piece(m, box, "Pore", Vector3.new(r, r * rng:NextNumber(0.8, 1.3), 0.04), cf, pore))
		end
	end
	local pieces = {}
	if not s.Gar then
		table.insert(pieces, function(m) -- square body + shirt band, collar points, tie
			local t = chestOf(m); if not t then return end
			local sz = t.Size
			local box = piece(m, t, "Sponge", Vector3.new(sz.X * 1.22, sz.Y * 0.95, sz.Z * 1.5), CFrame.new(0, sz.Y * 0.06, 0), sponge, Enum.Material.Slate)
			pores(m, box, 18, 7)
			local band = piece(m, t, "ShirtBand", Vector3.new(sz.X * 1.24, sz.Y * 0.22, sz.Z * 1.52), CFrame.new(0, -sz.Y * 0.47, 0), shirt)
			local fz = -band.Size.Z / 2
			for _, x in { -1, 1 } do
				piece(m, t, "CollarPoint", Vector3.new(sz.X * 0.2, sz.Y * 0.1, 0.05), CFrame.new(x * sz.X * 0.13, -sz.Y * 0.4, fz - 0.03) * CFrame.Angles(0, 0, math.rad(x * 30)), shirt)
			end
			piece(m, t, "TieKnot", Vector3.new(sz.X * 0.12, sz.Y * 0.12, 0.1), CFrame.new(0, -sz.Y * 0.44, fz - 0.06), tie)
			local w = waistOf(m)
			if w and w ~= t then
				local tl = piece(m, w, "Tie", Vector3.new(sz.X * 0.14, w.Size.Y * 1.6, 0.06), CFrame.new(0, -w.Size.Y * 0.4, -sz.Z * 0.76 - 0.05), tie)
				piece(m, tl, "TieTip", Vector3.new(tl.Size.X * 0.72, tl.Size.X * 0.72, 0.06), CFrame.new(0, -tl.Size.Y / 2, 0) * CFrame.Angles(0, 0, math.rad(45)), tie)
			end
		end)
		table.insert(pieces, function(m) -- square pants + black belt with notches
			local w = waistOf(m); if not w then return end
			local sz = w.Size
			local pants = piece(m, w, "Pants", Vector3.new(sz.X * 1.22, sz.Y * 1.4, sz.Z * 1.5), CFrame.new(0, -sz.Y * 0.1, 0), s.Secondary, Enum.Material.Fabric)
			local belt = piece(m, pants, "Belt", Vector3.new(pants.Size.X * 1.01, 0.16, pants.Size.Z * 1.01), CFrame.new(0, pants.Size.Y / 2 - 0.12, 0), BLACK)
			for i = -3, 3 do piece(m, belt, "Notch", Vector3.new(0.1, 0.08, 0.02), CFrame.new(i * pants.Size.X * 0.13, 0, -belt.Size.Z / 2 - 0.01), WHITE) end
			each(m, { "LeftUpperLeg", "RightUpperLeg" }, function(a)
				piece(m, a, "PantLeg", Vector3.new(a.Size.X * 1.25, a.Size.Y * 0.45, a.Size.Z * 1.4), CFrame.new(0, a.Size.Y * 0.25, 0), s.Secondary, Enum.Material.Fabric)
			end)
		end)
		table.insert(pieces, function(m) -- shirt sleeves
			each(m, { "LeftUpperArm", "RightUpperArm" }, function(a)
				piece(m, a, "Sleeve", Vector3.new(a.Size.X * 1.3, a.Size.Y * 0.4, a.Size.Z * 1.3), CFrame.new(0, a.Size.Y * 0.28, 0), shirt)
			end)
		end)
	else -- SpongeGar: caveman, bare sponge body with a fur loincloth
		table.insert(pieces, function(m)
			local t = chestOf(m); if not t then return end
			local sz = t.Size
			local box = piece(m, t, "Sponge", Vector3.new(sz.X * 1.22, sz.Y * 1.0, sz.Z * 1.5), CFrame.new(0, 0, 0), sponge, Enum.Material.Slate)
			pores(m, box, 18, 9)
			local w = waistOf(m)
			if w then
				for i = 0, 7 do
					local a = i / 8 * math.pi * 2
					piece(m, w, "Fur", Vector3.new(w.Size.X * 0.4, 0.8, 0.1), CFrame.new(math.sin(a) * w.Size.X * 0.6, -0.25, math.cos(a) * w.Size.Z * 0.7) * CFrame.Angles(0, a, 0) * CFrame.Angles(math.rad(-10), 0, math.rad(i % 2 == 0 and 8 or -8)), C(150, 105, 60), Enum.Material.Fabric)
				end
			end
		end)
	end
	table.insert(pieces, function(m) -- the face: boxy porous head, huge eyes, lashes, nose, grin, buck teeth, freckles
		local hd = find(m, "Head"); if not hd then return end
		local sz = hd.Size
		local box = piece(m, hd, "SpongeHead", Vector3.new(sz.X * 1.25, sz.Y * 1.2, sz.Z * 1.15), CFrame.new(0, sz.Y * 0.05, 0), sponge, Enum.Material.Slate)
		local b = box.Size
		local fz = -b.Z / 2
		pores(m, box, 8, 3)
		for _, x in { -1, 1 } do
			local ex = x * b.X * 0.22
			piece(m, box, "Sclera", Vector3.new(0.08, b.X * 0.42, b.X * 0.42), CFrame.new(ex, b.Y * 0.12, fz - 0.03) * face, C(252, 252, 252), Enum.Material.SmoothPlastic, cyl)
			piece(m, box, "Iris", Vector3.new(0.1, b.X * 0.2, b.X * 0.2), CFrame.new(ex - x * b.X * 0.02, b.Y * 0.1, fz - 0.04) * face, s.Iris or C(70, 150, 230), Enum.Material.SmoothPlastic, cyl)
			piece(m, box, "Pupil", Vector3.new(0.12, b.X * 0.09, b.X * 0.09), CFrame.new(ex - x * b.X * 0.02, b.Y * 0.1, fz - 0.05) * face, BLACK, Enum.Material.SmoothPlastic, cyl)
			for k = -1, 1 do
				piece(m, box, "Lash", Vector3.new(0.04, b.Y * 0.14, 0.04), CFrame.new(ex + k * b.X * 0.09, b.Y * 0.38, fz - 0.03) * CFrame.Angles(0, 0, math.rad(-k * 25)), BLACK)
			end
			local cheek = piece(m, box, "Cheek", Vector3.new(0.06, b.X * 0.2, b.X * 0.2), CFrame.new(x * b.X * 0.33, -b.Y * 0.14, fz - 0.02) * face, sponge:Lerp(C(255, 120, 90), 0.35), Enum.Material.SmoothPlastic, cyl)
			for k = 0, 2 do piece(m, box, "Freckle", Vector3.new(0.04, 0.04, 0.03), CFrame.new(x * b.X * (0.3 + (k - 1) * 0.04), -b.Y * (0.12 + (k % 2) * 0.04), fz - 0.06), C(200, 110, 70)) end
		end
		local nose = piece(m, box, "Nose", Vector3.new(b.Z * 0.45, b.X * 0.12, b.X * 0.12), CFrame.new(0, -b.Y * 0.04, fz - b.Z * 0.2) * face, sponge, Enum.Material.SmoothPlastic, cyl)
		piece(m, nose, "NoseTip", Vector3.one * b.X * 0.14, CFrame.new(nose.Size.X / 2, 0, 0), sponge, Enum.Material.SmoothPlastic, Enum.PartType.Ball)
		piece(m, box, "Grin", Vector3.new(b.X * 0.62, b.Y * 0.05, 0.04), CFrame.new(0, -b.Y * 0.26, fz - 0.02), C(120, 30, 30))
		for _, x in { -1, 1 } do
			piece(m, box, "GrinEnd", Vector3.new(b.X * 0.12, b.Y * 0.05, 0.04), CFrame.new(x * b.X * 0.34, -b.Y * 0.2, fz - 0.02) * CFrame.Angles(0, 0, math.rad(x * 40)), C(120, 30, 30))
			piece(m, box, "BuckTooth", Vector3.new(b.X * 0.11, b.Y * 0.13, 0.05), CFrame.new(x * b.X * 0.065, -b.Y * 0.33, fz - 0.03), WHITE)
		end
		piece(m, box, "Chin", Vector3.new(b.X * 0.3, 0.04, 0.03), CFrame.new(0, -b.Y * 0.42, fz - 0.015), pore)
		if s.Hat then -- Krusty Krab sailor cap: white boat hat with blue band + anchor
			local cap = piece(m, box, "Hat", Vector3.new(b.X * 0.7, b.Y * 0.35, b.Z * 0.5), CFrame.new(0, b.Y * 0.62, 0), WHITE, Enum.Material.Fabric)
			piece(m, cap, "HatBand", Vector3.new(cap.Size.X * 1.02, cap.Size.Y * 0.25, cap.Size.Z * 1.02), CFrame.new(0, -cap.Size.Y * 0.3, 0), C(40, 80, 200), Enum.Material.Fabric)
			local tag = piece(m, cap, "Anchor", Vector3.new(cap.Size.X * 0.4, cap.Size.Y * 0.6, 0.04), CFrame.new(0, cap.Size.Y * 0.1, -cap.Size.Z / 2 - 0.03), WHITE); tag.Transparency = 1
			glyph(tag, Enum.NormalId.Front, "⚓", C(40, 80, 200))
		end
		if s.Karate then -- karate helmet: padded dome with a clear face cage
			local dome = oval(piece(m, box, "KarateHelm", Vector3.new(b.X * 1.12, b.Y * 0.7, b.Z * 1.2), CFrame.new(0, b.Y * 0.42, 0), s.Karate, Enum.Material.Fabric))
			piece(m, dome, "Rim", Vector3.new(b.X * 1.14, 0.12, b.Z * 1.22), CFrame.new(0, -dome.Size.Y * 0.32, 0), WHITE, Enum.Material.Fabric)
		end
	end)
	table.insert(pieces, function(m) -- striped socks + shiny shoes
		each(m, { "LeftLowerLeg", "RightLowerLeg" }, function(a)
			for k, c in { C(210, 30, 30), C(40, 90, 210) } do piece(m, a, "SockStripe", Vector3.new(a.Size.X * 1.06, 0.07, a.Size.Z * 1.06), CFrame.new(0, a.Size.Y * (0.32 - k * 0.1), 0), c) end
		end)
		each(m, { "LeftFoot", "RightFoot" }, function(f)
			oval(piece(m, f, "Shoe", Vector3.new(f.Size.X * 1.15, f.Size.Y * 1.1, f.Size.Z * 1.4), CFrame.new(0, 0, -f.Size.Z * 0.15), BLACK, Enum.Material.Glass))
		end)
	end)
	if s.Cape or s.Emblem then -- superhero looks: cape off the back of the sponge box, chest emblem on its front
		table.insert(pieces, function(m)
			local box = m:FindFirstChild("Costume_Sponge"); if not box then return end
			local b = box.Size
			if s.Cape then
				local cape = piece(m, box, "Cape", Vector3.new(b.X * 1.05, b.Y * 2.4, 0.12), CFrame.new(0, -b.Y * 0.65, b.Z / 2 + 0.08) * CFrame.Angles(math.rad(-6), 0, 0), s.Cape, Enum.Material.Fabric)
				piece(m, box, "CapeCollar", Vector3.new(b.X * 1.08, 0.2, b.Z * 1.04), CFrame.new(0, b.Y / 2 + 0.05, 0), s.Cape, Enum.Material.Fabric)
			end
			if s.Emblem then
				local e = piece(m, box, "Emblem", Vector3.new(b.X * 0.4, b.Y * 0.4, 0.05), CFrame.new(0, b.Y * 0.1, -b.Z / 2 - 0.04), s.Cape or s.Tie or WHITE); e.Transparency = 1
				glyph(e, Enum.NormalId.Front, s.Emblem, s.Tie or WHITE)
			end
		end)
	end
	if s.Mask then -- domino mask across the eyes
		table.insert(pieces, function(m)
			local box = m:FindFirstChild("Costume_SpongeHead"); if not box then return end
			local b = box.Size
			piece(m, box, "Mask", Vector3.new(b.X * 0.9, b.Y * 0.2, 0.03), CFrame.new(0, b.Y * 0.1, -b.Z / 2 - 0.015), s.Mask)
		end)
	end
	if s.Karate then
		table.insert(pieces, function(m) -- karate mitts
			each(m, { "LeftHand", "RightHand" }, function(h)
				oval(piece(m, h, "Mitt", h.Size * Vector3.new(1.4, 1.6, 1.4), CFrame.new(0, -h.Size.Y * 0.1, 0), s.Karate, Enum.Material.Fabric))
			end)
		end)
	end
	return { colors = { Head = sponge, Chest = sponge, Waist = s.Gar and sponge or s.Secondary, UpperArms = s.Gar and sponge or shirt, LowerArms = sponge, Hands = sponge,
		UpperLegs = s.Gar and sponge or s.Secondary, LowerLegs = WHITE, Feet = BLACK }, pieces = pieces }
end
