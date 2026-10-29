-- Samurai Jack (Genndy Tartakovsky design): tall, lean, long-legged; long face with heavy straight black brows, dark almond eyes,
-- long straight nose, small mouth; black hair with a flat hairline and a topknot bun tied in white.
-- White gi: crossed collar (left over right), loose sleeves flaring at the wrist, obi sash with a side knot, robe skirt to the knees,
-- white leggings, wooden geta; the empty black saya pushed through the obi on his left hip.
-- Costume module: return function(s, H, rarity) -> { colors = { group = Color3 }, pieces = { { "Piece", args... } | function(m) end } }
-- s = skin variant (Name, Primary = gi, Secondary = collar/obi, Beard, Armor, Kasa, Ghost...), H = shared helpers, rarity = tier name
return function(s, H, rarity)
	local C, SKIN, WHITE = H.C, H.SKIN, H.WHITE
	local piece, round, band, find, chestOf, waistOf = H.piece, H.round, H.band, H.find, H.chestOf, H.waistOf
	local function each(m, names, fn) for _, n in names do local a = m:FindFirstChild(n); if a then fn(a, n:find("Left") and -1 or 1) end end end
	local V, CF = Vector3.new, CFrame.new
	local FAB = Enum.Material.Fabric
	local HAIR, WOOD, INK = C(22, 20, 24), C(120, 85, 50), C(20, 18, 20)
	local skin = s.Ghost and C(200, 225, 245) or C(238, 200, 160)
	local gi, trim = s.Primary, s.Secondary
	local fold = gi:Lerp(C(0, 0, 0), 0.16)

	local function eband(m, a, name, dx, dz, h, cf, color, mat)
		local p = piece(m, a, name, V(h, dx, dz), cf * CFrame.Angles(0, 0, math.rad(90)), color, mat)
		local sm = Instance.new("SpecialMesh"); sm.MeshType = Enum.MeshType.Cylinder; sm.Parent = p
		return p
	end

	local pieces = {}
	table.insert(pieces, function(m) -- head: long face, jaw, brows, eyes, nose; hair + topknot
		local hd = find(m, "Head"); if not hd then return end
		hd.Transparency = 1
		local s0 = hd.Size
		local X, Y, Z = s0.X * 0.92, s0.Y * 1.12, s0.Z * 0.98
		local shell = round(m, hd, "Skull", V(X, Y, Z), CF(0, s0.Y * 0.06, 0), skin)
		round(m, shell, "Jaw", V(X * 0.74, Y * 0.5, Z * 0.8), CF(0, -Y * 0.28, -Z * 0.06), skin)
		local function at(x, y, out)
			local a, b, c = X / 2, Y / 2, Z / 2
			local z = -c * math.sqrt(math.max(0.02, 1 - (x / a) ^ 2 - (y / b) ^ 2))
			local pos = V(x, y, z)
			local n = V(x / (a * a), y / (b * b), z / (c * c)).Unit
			return CFrame.lookAt(pos, pos + n) * CF(0, 0, -(out or 0))
		end
		for _, x in { -1, 1 } do
			local ex, ey = x * X * 0.2, Y * 0.04
			round(m, shell, "Eye", V(X * 0.2, Y * 0.07, 0.06), at(ex, ey, 0.0) * CFrame.Angles(0, 0, math.rad(x * 8)), INK)
			round(m, shell, "Glint", V(X * 0.04, Y * 0.025, 0.04), at(ex - x * X * 0.03, ey + Y * 0.01, 0.025), C(240, 240, 240))
			piece(m, shell, "Brow", V(X * 0.3, Y * 0.06, 0.08), at(x * X * 0.2, Y * 0.13, 0.01) * CFrame.Angles(0, 0, math.rad(x * 10)), HAIR)
			round(m, shell, "Ear", V(X * 0.1, Y * 0.22, Z * 0.18), CF(x * X * 0.5, -Y * 0.02, Z * 0.04), skin)
		end
		local nose = piece(m, shell, "Nose", V(X * 0.12, Y * 0.24, 0.16), at(0, -Y * 0.05, 0.05), skin:Lerp(C(0, 0, 0), 0.06))
		Instance.new("SpecialMesh", nose).MeshType = Enum.MeshType.Wedge
		piece(m, shell, "Mouth", V(X * 0.18, 0.035, 0.04), at(0, -Y * 0.3, -0.02), skin:Lerp(C(0, 0, 0), 0.5))
		-- hair: cap with a flat, straight hairline, sides over the ears' tops
		round(m, shell, "Hair", V(X * 1.08, Y * 0.62, Z * 1.1), CF(0, Y * 0.3, Z * 0.04), HAIR)
		round(m, shell, "HairBack", V(X * 1.04, Y * 0.85, Z * 0.6), CF(0, Y * 0.06, Z * 0.25), HAIR)
		for _, x in { -1, 1 } do round(m, shell, "HairSide", V(X * 0.18, Y * 0.5, Z * 0.7), CF(x * X * 0.47, Y * 0.12, Z * 0.06), HAIR) end
		if not s.Kasa then -- topknot: bun on the crown, white tie
			round(m, shell, "Bun", V(X * 0.36, Y * 0.3, X * 0.36), CF(0, Y * 0.6, Z * 0.08), HAIR)
			band(m, shell, "BunTie", X * 0.26, Y * 0.07, CF(0, Y * 0.47, Z * 0.08), C(240, 240, 235), FAB)
		end
		if s.Beard then -- Season 5: long loose hair down the back + full beard and moustache
			round(m, shell, "HairFall", V(X * 1.0, Y * 1.3, Z * 0.4), CF(0, -Y * 0.35, Z * 0.36), HAIR)
			round(m, shell, "Beard", V(X * 0.82, Y * 0.48, Z * 0.7), CF(0, -Y * 0.33, -Z * 0.14), HAIR)
			round(m, shell, "Moustache", V(X * 0.42, Y * 0.08, 0.1), at(0, -Y * 0.22, 0.02), HAIR)
			round(m, shell, "Lip", V(X * 0.16, Y * 0.04, 0.06), at(0, -Y * 0.3, 0.06), skin:Lerp(C(0, 0, 0), 0.4))
			for _, x in { -1, 1 } do round(m, shell, "Sideburn", V(X * 0.14, Y * 0.5, Z * 0.5), CF(x * X * 0.43, -Y * 0.12, -Z * 0.02), HAIR) end
		end
		if s.Kasa then -- ronin straw hat: wide shallow cone + chin cord; hair tied low
			round(m, shell, "Kasa", V(X * 2.6, Y * 0.28, X * 2.6), CF(0, Y * 0.52, 0), C(205, 175, 105), FAB)
			round(m, shell, "KasaTop", V(X * 1.0, Y * 0.32, X * 1.0), CF(0, Y * 0.64, 0), C(185, 150, 85), FAB)
			for _, x in { -1, 1 } do piece(m, shell, "ChinCord", V(0.04, Y * 0.8, 0.04), CF(x * X * 0.4, Y * 0.0, -Z * 0.1) * CFrame.Angles(0, 0, math.rad(x * 18)), C(80, 50, 30), FAB) end
		end
	end)
	table.insert(pieces, function(m) -- gi top: crossed collar (two rolled slices of the chest), sleeves
		local t = chestOf(m); if not t then return end
		local sz = t.Size
		-- each lapel runs from the side of the neck down to the obi, where the two cross (left over right)
		local ang = math.atan2(sz.X * 0.25, sz.Y * 0.9)
		for _, x in { 1, -1 } do
			round(m, t, "Collar", V(sz.X * 0.15, sz.Y * 0.98, sz.Z * (x < 0 and 1.07 or 1.05)), CF(x * sz.X * 0.144, sz.Y * 0.1, 0) * CFrame.Angles(0, 0, -x * ang), trim, FAB)
		end
		each(m, { "LeftUpperArm", "RightUpperArm" }, function(a)
			round(m, a, "Sleeve", V(a.Size.X * 1.12, a.Size.Y * 1.25, a.Size.Z * 1.12), CF(0, 0, 0), gi, FAB)
		end)
		each(m, { "LeftLowerArm", "RightLowerArm" }, function(a)
			round(m, a, "SleeveLow", V(a.Size.X * 1.2, a.Size.Y * 1.05, a.Size.Z * 1.2), CF(0, -a.Size.Y * 0.02, 0), gi, FAB)
			band(m, a, "SleeveMouth", a.Size.X * 1.4, a.Size.Y * 0.18, CF(0, -a.Size.Y * 0.38, 0), gi, FAB)
			band(m, a, "SleeveHem", a.Size.X * 1.42, 0.05, CF(0, -a.Size.Y * 0.47, 0), fold, FAB)
		end)
	end)
	table.insert(pieces, function(m) -- obi + side knot, robe skirt to the knees, the empty saya through the obi
		local w = waistOf(m); if not w then return end
		local sz = w.Size
		eband(m, w, "Obi", sz.X * 1.02, sz.Z * 1.12, sz.Y * 1.2, CF(0, sz.Y * 0.2, 0), trim, FAB)
		round(m, w, "Knot", V(sz.X * 0.2, sz.Y * 0.9, 0.2), CF(sz.X * 0.28, sz.Y * 0.2, -sz.Z * 0.58), trim, FAB)
		for _, a in { -14, 14 } do round(m, w, "KnotTail", V(sz.X * 0.08, sz.Y * 1.6, 0.06), CF(sz.X * 0.28 + a * 0.005, -sz.Y * 0.7, -sz.Z * 0.6) * CFrame.Angles(0, 0, math.rad(a)), trim, FAB) end
		local leg = find(m, "LeftUpperLeg")
		local len = leg and leg.Size.Y * 1.05 or 1
		eband(m, w, "Skirt", sz.X * 1.12, sz.Z * 1.25, len, CF(0, -sz.Y * 0.4 - len / 2, 0), gi, FAB)
		eband(m, w, "SkirtHem", sz.X * 1.14, sz.Z * 1.27, 0.06, CF(0, -sz.Y * 0.4 - len + 0.03, 0), fold, FAB)
		piece(m, w, "SkirtSlit", V(0.03, len * 0.9, 0.04), CF(sz.X * 0.08, -sz.Y * 0.4 - len * 0.55, -sz.Z * 0.63), fold, FAB)
		-- saya: long black lacquered scabbard angled back off the left hip
		local saya = piece(m, w, "Saya", V(0.16, 3.3, 0.24), CF(-sz.X * 0.56, sz.Y * 0.2 - 0.3, 0.35) * CFrame.Angles(math.rad(-68), 0, math.rad(6)), C(30, 26, 26), Enum.Material.SmoothPlastic)
		piece(m, saya, "Koiguchi", V(0.2, 0.12, 0.28), CF(0, 1.6, 0), C(205, 165, 60), Enum.Material.Metal)
		piece(m, saya, "Kojiri", V(0.2, 0.14, 0.28), CF(0, -1.6, 0), C(205, 165, 60), Enum.Material.Metal)
	end)
	table.insert(pieces, function(m) -- leggings gathered at the ankle, geta
		each(m, { "LeftLowerLeg", "RightLowerLeg" }, function(a)
			band(m, a, "Legging", a.Size.X * 0.92, a.Size.Y * 0.5, CF(0, -a.Size.Y * 0.32, 0), gi, FAB)
			band(m, a, "Gather", a.Size.X * 0.96, 0.08, CF(0, -a.Size.Y * 0.5, 0), fold, FAB)
		end)
		each(m, { "LeftFoot", "RightFoot" }, function(f)
			local sz = f.Size
			piece(m, f, "Geta", V(sz.X * 1.0, 0.12, sz.Z * 1.2), CF(0, -sz.Y / 2 - 0.06, -sz.Z * 0.02), WOOD, Enum.Material.Wood)
			for _, z in { -0.3, 0.3 } do piece(m, f, "Tooth", V(sz.X * 0.95, 0.16, 0.1), CF(0, -sz.Y / 2 - 0.2, z * sz.Z), WOOD:Lerp(C(0, 0, 0), 0.2), Enum.Material.Wood) end
			piece(m, f, "Thong", V(sz.X * 0.95, 0.06, 0.08), CF(0, sz.Y * 0.3, -sz.Z * 0.18), C(30, 30, 30), FAB)
		end)
	end)
	if s.Armor then -- Season 5 / Aku-slayer armor: lamellar cuirass bands, rounded pauldrons, shin + forearm guards
		table.insert(pieces, function(m)
			local t = chestOf(m); if not t then return end
			local sz = t.Size
			for i = 0, 3 do
				eband(m, t, "Lame", sz.X * (0.98 - i * 0.04), sz.Z * 1.08, sz.Y * 0.18, CF(0, sz.Y * (0.18 - i * 0.18), 0), s.Armor:Lerp(C(0, 0, 0), i % 2 * 0.15), Enum.Material.Metal)
			end
			piece(m, t, "Cord", V(0.06, sz.Y * 0.75, 0.05), CF(0, -sz.Y * 0.08, -sz.Z * 0.58), C(150, 30, 30), FAB)
			each(m, { "LeftUpperArm", "RightUpperArm" }, function(a, x)
				for k = 0, 2 do
					round(m, a, "Sode", V(a.Size.X * (1.9 - k * 0.15), a.Size.Y * 0.35, a.Size.Z * 1.8), CF(x * a.Size.X * 0.1, a.Size.Y * (0.4 - k * 0.22), 0) * CFrame.Angles(0, 0, math.rad(x * -12)), s.Armor:Lerp(C(0, 0, 0), k * 0.08), Enum.Material.Metal)
				end
			end)
			each(m, { "LeftLowerLeg", "RightLowerLeg", "LeftLowerArm", "RightLowerArm" }, function(a)
				round(m, a, "Guard", V(a.Size.X * 0.9, a.Size.Y * 0.75, a.Size.Z * 0.5), CF(0, 0, -a.Size.Z * 0.45), s.Armor, Enum.Material.Metal)
			end)
		end)
	end
	if s.Ghost then -- spectral samurai: pale, see-through body and gear (runs last; the sculpted body copies transparency)
		table.insert(pieces, function(m)
			for _, p in m:GetDescendants() do
				if p:IsA("BasePart") and p.Name ~= "HumanoidRootPart" and not p.Name:find("Eye") and not p.Name:find("Brow") then p.Transparency = math.max(p.Transparency, 0.35) end
			end
		end)
	end
	return { colors = { Head = skin, Chest = gi, Waist = gi, Arms = gi, Hands = skin, Legs = gi, Feet = s.Ghost and gi or C(238, 236, 228) },
		pieces = pieces }
end
