-- Finn (Adventure Time): white bear-ear hat framing the face, light-blue tee, dark-blue shorts, green backpack, skinny legs, white socks, black shoes
-- Costume module: return function(s, H, rarity) -> { colors = { group = Color3 }, pieces = { { "Piece", args... } | function(m) end } }
-- s = skin variant (Name, Primary = shirt, Secondary = shorts, Hat, Pack, Hatless, GrassArm, RobotArm, Fern...), H = shared helpers, rarity = tier name
return function(s, H, rarity)
	local C, SKIN, GOLD, WHITE = H.C, H.SKIN, H.GOLD, H.WHITE
	local piece, find, chestOf, waistOf, front = H.piece, H.find, H.chestOf, H.waistOf, H.front
	local function each(m, names, fn) for _, n in names do local a = m:FindFirstChild(n); if a then fn(a, n:find("Left") and -1 or 1) end end end
	local skin = s.Skin or C(250, 215, 180)
	local hat = s.Hat or WHITE
	local pack = s.Pack or C(90, 170, 70)
	local HAIR = C(250, 215, 100)
	local pieces = {
		{ "Face", C(20, 20, 22), C(60, 45, 30), "grin" },
	}
	if s.Hatless then -- hat off: Finn's long flowing golden hair
		table.insert(pieces, function(m)
			local hd = find(m, "Head"); if not hd then return end
			local sz = hd.Size
			piece(m, hd, "Hair", Vector3.new(sz.X * 1.08, sz.Y * 0.38, sz.Z * 1.08), CFrame.new(0, sz.Y * 0.38, 0.02), HAIR)
			piece(m, hd, "HairBack", Vector3.new(sz.X * 1.1, sz.Y * 2.2, sz.Z * 0.35), CFrame.new(0, -sz.Y * 0.55, sz.Z * 0.5) * CFrame.Angles(math.rad(-6), 0, 0), HAIR)
			for _, x in { -1, 1 } do
				piece(m, hd, "Lock", Vector3.new(sz.X * 0.16, sz.Y * 1.3, sz.Z * 0.5), CFrame.new(x * sz.X * 0.52, -sz.Y * 0.25, sz.Z * 0.15), HAIR)
				piece(m, hd, "Fringe", Vector3.new(sz.X * 0.36, sz.Y * 0.18, 0.08), CFrame.new(x * sz.X * 0.24, sz.Y * 0.26, -sz.Z * 0.52) * CFrame.Angles(0, 0, math.rad(x * 12)), HAIR)
			end
		end)
	else
		table.insert(pieces, function(m) -- the hat: shell wrapping top, sides, back and under the chin, two round bear ears
			local hd = find(m, "Head"); if not hd then return end
			local sz = hd.Size
			piece(m, hd, "HatTop", Vector3.new(sz.X * 1.1, sz.Y * 0.3, sz.Z * 1.1), CFrame.new(0, sz.Y * 0.42, 0), hat, Enum.Material.Fabric)
			piece(m, hd, "HatBack", Vector3.new(sz.X * 1.1, sz.Y * 1.14, sz.Z * 0.45), CFrame.new(0, -sz.Y * 0.03, sz.Z * 0.33), hat, Enum.Material.Fabric)
			for _, x in { -1, 1 } do
				piece(m, hd, "HatSide", Vector3.new(sz.X * 0.08, sz.Y * 1.14, sz.Z * 1.1), CFrame.new(x * sz.X * 0.52, -sz.Y * 0.03, 0), hat, Enum.Material.Fabric)
				if s.Bunny then -- Fionna: tall bunny ears
					local ear = piece(m, hd, "HatEar", Vector3.new(sz.X * 0.22, sz.Y * 0.75, sz.X * 0.14), CFrame.new(x * sz.X * 0.28, sz.Y * 0.88, 0.02) * CFrame.Angles(0, 0, math.rad(-x * 8)), hat, Enum.Material.Fabric)
					Instance.new("SpecialMesh", ear).MeshType = Enum.MeshType.Sphere
					piece(m, ear, "HatEarInner", Vector3.new(ear.Size.X * 0.45, ear.Size.Y * 0.7, 0.04), CFrame.new(0, 0, -ear.Size.Z * 0.4), C(255, 190, 210), Enum.Material.Fabric)
				else
					piece(m, hd, "HatEar", Vector3.new(sz.X * 0.3, sz.X * 0.3, sz.X * 0.3), CFrame.new(x * sz.X * 0.36, sz.Y * 0.62, 0.02), hat, Enum.Material.Fabric, Enum.PartType.Ball)
					piece(m, hd, "HatEarInner", Vector3.new(sz.X * 0.16, sz.X * 0.16, 0.05), CFrame.new(x * sz.X * 0.36, sz.Y * 0.62, -sz.X * 0.15), hat:Lerp(C(0, 0, 0), 0.08), Enum.Material.Fabric)
				end
			end
			piece(m, hd, "HatChin", Vector3.new(sz.X * 1.1, sz.Y * 0.14, sz.Z * 1.1), CFrame.new(0, -sz.Y * 0.53, 0), hat, Enum.Material.Fabric)
			piece(m, hd, "HatRim", Vector3.new(sz.X * 0.98, 0.05, 0.04), CFrame.new(0, sz.Y * 0.27, -sz.Z * 0.555), hat:Lerp(C(0, 0, 0), 0.12), Enum.Material.Fabric)
		end)
	end
	table.insert(pieces, function(m) -- tee: short sleeves, collar
		local t = chestOf(m); if not t then return end
		local sz = t.Size
		piece(m, t, "Collar", Vector3.new(sz.X * 0.4, 0.08, 0.05), CFrame.new(0, sz.Y * 0.46, front(t, 0.02)), s.Primary:Lerp(C(0, 0, 0), 0.25))
		piece(m, t, "Neck", Vector3.new(sz.X * 0.3, 0.12, 0.04), CFrame.new(0, sz.Y * 0.43, front(t, 0.01)), skin)
		each(m, { "LeftUpperArm", "RightUpperArm" }, function(a)
			piece(m, a, "SleeveHem", Vector3.new(a.Size.X * 1.06, 0.06, a.Size.Z * 1.06), CFrame.new(0, -a.Size.Y * 0.08, 0), s.Primary:Lerp(C(0, 0, 0), 0.2))
		end)
	end)
	table.insert(pieces, function(m) -- green backpack: body, flap, buckle, side pocket, shoulder straps
		local t = chestOf(m); if not t then return end
		local sz = t.Size
		local bz = sz.Z / 2 + 0.35
		local bag = piece(m, t, "Pack", Vector3.new(sz.X * 0.75, sz.Y * 0.85, 0.65), CFrame.new(0, -sz.Y * 0.05, bz), pack, Enum.Material.Fabric)
		piece(m, bag, "Flap", Vector3.new(bag.Size.X * 0.96, bag.Size.Y * 0.45, 0.06), CFrame.new(0, bag.Size.Y * 0.22, 0.34), pack:Lerp(C(0, 0, 0), 0.15), Enum.Material.Fabric)
		piece(m, bag, "Buckle", Vector3.new(0.2, 0.16, 0.05), CFrame.new(0, 0, 0.38), C(230, 200, 80), Enum.Material.Metal)
		piece(m, bag, "Pocket", Vector3.new(bag.Size.X * 0.6, bag.Size.Y * 0.28, 0.08), CFrame.new(0, -bag.Size.Y * 0.3, 0.36), pack:Lerp(C(0, 0, 0), 0.1), Enum.Material.Fabric)
		for _, x in { -1, 1 } do
			piece(m, t, "Strap", Vector3.new(sz.X * 0.1, 0.06, sz.Z * 1.12), CFrame.new(x * sz.X * 0.24, sz.Y / 2 + 0.02, 0), pack:Lerp(C(0, 0, 0), 0.2), Enum.Material.Fabric)
			piece(m, t, "StrapFront", Vector3.new(sz.X * 0.1, sz.Y * 0.8, 0.05), CFrame.new(x * sz.X * 0.24, sz.Y * 0.1, front(t, 0.03)), pack:Lerp(C(0, 0, 0), 0.2), Enum.Material.Fabric)
		end
	end)
	table.insert(pieces, function(m) -- shorts hem, white socks, black shoes
		each(m, { "LeftUpperLeg", "RightUpperLeg" }, function(a)
			piece(m, a, "Hem", Vector3.new(a.Size.X * 1.06, 0.08, a.Size.Z * 1.06), CFrame.new(0, -a.Size.Y * 0.3, 0), s.Secondary:Lerp(C(0, 0, 0), 0.25), Enum.Material.Fabric)
		end)
		each(m, { "LeftLowerLeg", "RightLowerLeg" }, function(a)
			piece(m, a, "Sock", Vector3.new(a.Size.X * 1.04, a.Size.Y * 0.35, a.Size.Z * 1.04), CFrame.new(0, -a.Size.Y * 0.33, 0), WHITE, Enum.Material.Fabric)
		end)
	end)
	if s.GrassArm then -- grass sword cursed arm: leafy green right forearm + hand
		table.insert(pieces, function(m)
			each(m, { "RightLowerArm", "RightHand", "RightArm" }, function(a)
				a.Color = C(80, 170, 60)
				for i = 0, 3 do piece(m, a, "GrassBlade", Vector3.new(a.Size.X * 0.2, a.Size.Y * 0.5, 0.05), CFrame.new((i - 1.5) * a.Size.X * 0.25, 0, -a.Size.Z / 2 - 0.03) * CFrame.Angles(0, 0, math.rad((i - 1.5) * 12)), C(60, 140, 45), Enum.Material.Grass) end
			end)
		end)
	end
	if s.RobotArm then -- Farmworld / later-season robotic right arm
		table.insert(pieces, function(m)
			each(m, { "RightLowerArm", "RightHand", "RightArm" }, function(a)
				a.Color = C(150, 155, 165); a.Material = Enum.Material.Metal
				piece(m, a, "Joint", Vector3.new(a.Size.X * 1.08, 0.12, a.Size.Z * 1.08), CFrame.new(0, a.Size.Y * 0.35, 0), C(90, 90, 100), Enum.Material.Metal)
			end)
		end)
	end
	if s.Fern then -- Fern: grass Finn, mossy body with leaf tufts
		table.insert(pieces, function(m)
			local hd = find(m, "Head")
			if hd then for i = -1, 1 do piece(m, hd, "Leaf", Vector3.new(0.12, hd.Size.Y * 0.4, 0.25), CFrame.new(i * hd.Size.X * 0.3, hd.Size.Y * 0.75, 0) * CFrame.Angles(0, 0, math.rad(-i * 25)), C(70, 150, 50), Enum.Material.Grass) end end
			local t = chestOf(m)
			if t then t.Material = Enum.Material.Grass end
		end)
	end
	return { colors = { Head = skin, Chest = s.Primary, Waist = s.Secondary, UpperArms = s.Primary, LowerArms = skin, Hands = skin, UpperLegs = s.Secondary, LowerLegs = skin, Feet = C(25, 25, 28) },
		pieces = pieces }
end
