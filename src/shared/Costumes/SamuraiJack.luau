-- Samurai Jack: white gi with crossed collar, sash + empty saya on the hip, wide sleeves, tunic flaps, geta sandals, black topknot
-- Costume module: return function(s, H, rarity) -> { colors = { group = Color3 }, pieces = { { "Piece", args... } | function(m) end } }
-- s = skin variant (Name, Primary, Secondary, Beard, Armor, Kasa, Ghost...), H = shared helpers (see Costume.luau "Helpers"), rarity = "Common" | "Rare" | "Epic" | "Legendary" | "Mythic" | "Secret"
return function(s, H, rarity)
	local C, SKIN, GOLD, WHITE = H.C, H.SKIN, H.GOLD, H.WHITE
	local piece, find, chestOf, waistOf, front = H.piece, H.find, H.chestOf, H.waistOf, H.front
	local function each(m, names, fn) for _, n in names do local a = m:FindFirstChild(n); if a then fn(a, n:find("Left") and -1 or 1) end end end
	local HAIR, WOOD = C(22, 20, 22), C(120, 85, 50)
	local fold = s.Primary:Lerp(C(0, 0, 0), 0.18)
	local pieces = {
		{ "Face", C(45, 35, 30), HAIR, "neutral" },
		{ "Hair", HAIR },
		function(m) -- topknot: bun on the crown, white tie, short tail
			local hd = find(m, "Head"); if not hd then return end
			local sz = hd.Size
			piece(m, hd, "HairSides", Vector3.new(sz.X * 1.08, sz.Y * 0.5, sz.Z * 0.5), CFrame.new(0, sz.Y * 0.15, sz.Z * 0.3), HAIR)
			piece(m, hd, "Bun", Vector3.new(sz.X * 0.34, sz.Y * 0.3, sz.X * 0.34), CFrame.new(0, sz.Y * 0.68, sz.Z * 0.1), HAIR, nil, Enum.PartType.Ball)
			piece(m, hd, "BunTie", Vector3.new(sz.X * 0.22, sz.Y * 0.08, sz.X * 0.22), CFrame.new(0, sz.Y * 0.56, sz.Z * 0.1), C(240, 240, 235), Enum.Material.Fabric)
			piece(m, hd, "Tail", Vector3.new(sz.X * 0.12, sz.Y * 0.32, sz.X * 0.12), CFrame.new(0, sz.Y * 0.72, sz.Z * 0.3) * CFrame.Angles(math.rad(55), 0, 0), HAIR)
			if s.Beard then -- Season 5: long loose hair down the back + full beard and moustache
				piece(m, hd, "HairBack", Vector3.new(sz.X * 1.06, sz.Y * 1.2, sz.Z * 0.3), CFrame.new(0, -sz.Y * 0.15, sz.Z * 0.5), HAIR)
				piece(m, hd, "Beard", Vector3.new(sz.X * 0.86, sz.Y * 0.36, 0.12), CFrame.new(0, -sz.Y * 0.36, -sz.Z * 0.5), HAIR)
				for _, x in { -1, 1 } do
					piece(m, hd, "Sideburn", Vector3.new(sz.X * 0.12, sz.Y * 0.5, sz.Z * 0.5), CFrame.new(x * sz.X * 0.48, -sz.Y * 0.1, -sz.Z * 0.15), HAIR)
					piece(m, hd, "Moustache", Vector3.new(sz.X * 0.2, sz.Y * 0.06, 0.05), CFrame.new(x * sz.X * 0.1, -sz.Y * 0.21, -sz.Z * 0.56) * CFrame.Angles(0, 0, math.rad(x * -12)), HAIR)
				end
			end
		end,
		function(m) -- gi: crossed collar (left over right), inner V, back seam
			local t = chestOf(m); if not t then return end
			local sz = t.Size
			local fz = front(t, 0.03)
			piece(m, t, "InnerV", Vector3.new(sz.X * 0.22, sz.Y * 0.4, 0.03), CFrame.new(0, sz.Y * 0.3, fz + 0.01), fold)
			for _, x in { -1, 1 } do
				piece(m, t, "Collar", Vector3.new(sz.X * 0.16, sz.Y * 1.05, 0.05), CFrame.new(x * sz.X * 0.1, sz.Y * 0.02, fz - (x > 0 and 0.02 or 0)) * CFrame.Angles(0, 0, math.rad(x * 24)), s.Secondary, Enum.Material.Fabric)
				piece(m, t, "Shoulder", Vector3.new(sz.X * 0.16, 0.05, sz.Z * 1.04), CFrame.new(x * sz.X * 0.22, sz.Y / 2 + 0.01, 0), s.Secondary, Enum.Material.Fabric)
				piece(m, t, "Crease", Vector3.new(0.03, sz.Y * 0.6, 0.03), CFrame.new(x * sz.X * 0.33, -sz.Y * 0.12, fz) * CFrame.Angles(0, 0, math.rad(x * 6)), fold)
			end
			piece(m, t, "BackSeam", Vector3.new(0.04, sz.Y, 0.03), CFrame.new(0, 0, sz.Z / 2 + 0.02), fold)
		end,
		function(m) -- obi sash with a side knot + the empty saya pushed through it
			local w = waistOf(m); if not w then return end
			local sz = w.Size
			local y = w.Name == "LowerTorso" and sz.Y * 0.2 or (w.Name == "Torso" and -sz.Y * 0.42 or 0)
			piece(m, w, "Obi", Vector3.new(sz.X * 1.07, 0.42, sz.Z * 1.1), CFrame.new(0, y, 0), s.Secondary, Enum.Material.Fabric)
			piece(m, w, "Knot", Vector3.new(0.32, 0.3, 0.16), CFrame.new(sz.X * 0.3, y, -sz.Z * 0.58), s.Secondary, Enum.Material.Fabric)
			for _, a in { -15, 15 } do piece(m, w, "KnotTail", Vector3.new(0.12, 0.45, 0.06), CFrame.new(sz.X * 0.3 + a * 0.006, y - 0.3, -sz.Z * 0.6) * CFrame.Angles(0, 0, math.rad(a)), s.Secondary, Enum.Material.Fabric) end
			local saya = piece(m, w, "Saya", Vector3.new(0.2, 3.2, 0.26), CFrame.new(-sz.X * 0.6, y - 0.2, 0.2) * CFrame.Angles(math.rad(-62), 0, math.rad(8)), C(55, 38, 28), Enum.Material.SmoothPlastic)
			piece(m, saya, "Koiguchi", Vector3.new(0.24, 0.12, 0.3), CFrame.new(0, 1.55, 0), C(20, 20, 22))
			piece(m, saya, "Kojiri", Vector3.new(0.24, 0.14, 0.3), CFrame.new(0, -1.55, 0), C(205, 165, 60), Enum.Material.Metal)
			piece(m, saya, "Sageo", Vector3.new(0.06, 0.06, 0.6), CFrame.new(0.1, 1.2, -0.2), C(240, 240, 235), Enum.Material.Fabric)
			for _, z in { -1, 1 } do -- tunic flaps (front + back) split at the sides
				for _, x in { -1, 1 } do
					piece(m, w, "Flap", Vector3.new(sz.X * 0.5, 1.15, 0.08), CFrame.new(x * sz.X * 0.26, y - 0.75, z * (sz.Z / 2 + 0.06)), s.Primary, Enum.Material.Fabric)
				end
				piece(m, w, "FlapHem", Vector3.new(sz.X * 1.02, 0.08, 0.09), CFrame.new(0, y - 1.3, z * (sz.Z / 2 + 0.06)), fold, Enum.Material.Fabric)
			end
		end,
		function(m) -- wide gi sleeves flaring at the forearm
			each(m, { "LeftLowerArm", "RightLowerArm", "LeftArm", "RightArm" }, function(a)
				local sz = a.Size
				piece(m, a, "Sleeve", Vector3.new(sz.X * 1.3, sz.Y * 0.45, sz.Z * 1.3), CFrame.new(0, sz.Y * 0.05, 0), s.Primary, Enum.Material.Fabric)
				piece(m, a, "SleeveHem", Vector3.new(sz.X * 1.32, 0.06, sz.Z * 1.32), CFrame.new(0, -sz.Y * 0.17, 0), fold, Enum.Material.Fabric)
			end)
			each(m, { "LeftLowerLeg", "RightLowerLeg" }, function(a) -- hakama gathered at the shin
				piece(m, a, "Gather", Vector3.new(a.Size.X * 1.1, 0.12, a.Size.Z * 1.1), CFrame.new(0, -a.Size.Y * 0.3, 0), fold, Enum.Material.Fabric)
			end)
		end,
		function(m) -- geta: wooden platform + two teeth + thong strap
			each(m, { "LeftFoot", "RightFoot" }, function(f)
				local sz = f.Size
				piece(m, f, "Geta", Vector3.new(sz.X * 1.05, 0.14, sz.Z * 1.15), CFrame.new(0, -sz.Y / 2 - 0.07, 0), WOOD, Enum.Material.Wood)
				for _, z in { -0.3, 0.3 } do piece(m, f, "Tooth", Vector3.new(sz.X * 1.0, 0.18, 0.12), CFrame.new(0, -sz.Y / 2 - 0.22, z * sz.Z), WOOD:Lerp(C(0, 0, 0), 0.2), Enum.Material.Wood) end
				piece(m, f, "Thong", Vector3.new(sz.X * 1.04, 0.08, 0.1), CFrame.new(0, sz.Y * 0.2, -sz.Z * 0.15), C(30, 30, 30), Enum.Material.Fabric)
			end)
		end,
	}
	if s.Armor then -- Season 5 armor: lamellar chest, pauldrons, shin guards, gauntlets
		table.insert(pieces, { "Shoulders", s.Armor })
		table.insert(pieces, function(m)
			local t = chestOf(m); if not t then return end
			local sz = t.Size
			for i = 0, 4 do
				piece(m, t, "Lame", Vector3.new(sz.X * 1.02, sz.Y * 0.17, sz.Z * 1.12), CFrame.new(0, sz.Y * (0.32 - i * 0.18), 0), s.Armor:Lerp(C(0, 0, 0), i % 2 * 0.15), Enum.Material.Metal)
			end
			piece(m, t, "Cord", Vector3.new(0.06, sz.Y * 0.9, 0.04), CFrame.new(0, -sz.Y * 0.05, front(t, 0.1)), C(150, 30, 30), Enum.Material.Fabric)
			each(m, { "LeftLowerLeg", "RightLowerLeg", "LeftLowerArm", "RightLowerArm" }, function(a)
				piece(m, a, "Guard", Vector3.new(a.Size.X * 0.8, a.Size.Y * 0.7, 0.1), CFrame.new(0, 0, -a.Size.Z / 2 - 0.05), s.Armor, Enum.Material.Metal)
			end)
		end)
	end
	if s.Kasa then -- ronin straw hat
		table.insert(pieces, function(m)
			local hd = find(m, "Head"); if not hd then return end
			local sz = hd.Size
			for k = 0, 2 do
				piece(m, hd, "Kasa", Vector3.new(0.16, sz.X * (2.4 - k * 0.75), sz.X * (2.4 - k * 0.75)), CFrame.new(0, sz.Y * (0.62 + k * 0.12), 0) * CFrame.Angles(0, 0, math.rad(90)), C(200, 170, 100):Lerp(C(150, 120, 60), k * 0.3), Enum.Material.Fabric, Enum.PartType.Cylinder)
			end
			piece(m, hd, "ChinTie", Vector3.new(sz.X * 1.04, 0.05, 0.05), CFrame.new(0, -sz.Y * 0.42, -sz.Z * 0.2) * CFrame.Angles(math.rad(-30), 0, 0), C(80, 50, 30), Enum.Material.Fabric)
		end)
	end
	if s.Ghost then -- spectral samurai: pale, see-through body and gear
		table.insert(pieces, function(m)
			for _, p in m:GetDescendants() do
				if p:IsA("BasePart") and p.Name ~= "HumanoidRootPart" and not p.Name:find("Sclera") and not p.Name:find("Pupil") and not p.Name:find("Iris") then p.Transparency = math.max(p.Transparency, 0.35) end
			end
		end)
	end
	return { colors = { Head = s.Ghost and C(200, 225, 245) or SKIN, Chest = s.Primary, Waist = s.Primary, Arms = s.Primary, Hands = s.Ghost and C(200, 225, 245) or SKIN, Legs = s.Primary, Feet = C(238, 236, 228) },
		pieces = pieces }
end
