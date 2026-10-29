-- Ben 10: green/black jacket with white stripe and "10" (or the classic white tee with a black stripe), swept brown hair, cargo pants, sneakers.
-- The Omnitrix itself is a weapon (Weapons.Omnitrix) on the left wrist.
-- Costume module: return function(s, H, rarity) -> { colors = { group = Color3 }, pieces = { { "Piece", args... } | function(m) end } }
-- s = skin variant (Name, Primary, Secondary = pants, Trim, Stripe, Tee, Suit, AlienX...), H = shared helpers, rarity = tier name
return function(s, H, rarity)
	local C, SKIN, GOLD, WHITE = H.C, H.SKIN, H.GOLD, H.WHITE
	local piece, find, chestOf, waistOf, front, glyph = H.piece, H.find, H.chestOf, H.waistOf, H.front, H.glyph
	local function each(m, names, fn) for _, n in names do local a = m:FindFirstChild(n); if a then fn(a, n:find("Left") and -1 or 1) end end end
	local BLACK, GREEN = C(25, 25, 28), C(70, 210, 70)
	local trim, stripe = s.Trim or BLACK, s.Stripe or WHITE
	local HAIR = s.Hair or C(105, 65, 35)

	if s.AlienX then -- Alien X: starfield-black body, white horns, glowing green eyes (non-Neon)
		local VOID = C(12, 12, 20)
		return { colors = { Head = VOID, Chest = VOID, Waist = VOID, Arms = VOID, Hands = VOID, Legs = VOID, Feet = VOID },
			pieces = {
				function(m)
					local hd = find(m, "Head"); if not hd then return end
					local sz = hd.Size
					piece(m, hd, "Mask", Vector3.new(sz.X * 0.9, sz.Y * 0.62, 0.05), CFrame.new(0, sz.Y * 0.05, -sz.Z * 0.51), WHITE)
					for _, x in { -1, 1 } do
						piece(m, hd, "Eye", Vector3.new(sz.X * 0.26, sz.Y * 0.11, 0.05), CFrame.new(x * sz.X * 0.2, sz.Y * 0.06, -sz.Z * 0.54) * CFrame.Angles(0, 0, math.rad(x * -12)), C(110, 255, 120), Enum.Material.SmoothPlastic)
						for k = 0, 3 do -- horns curling up and out from the temples
							piece(m, hd, "Horn", Vector3.new(0.2 - k * 0.03, 0.4, 0.2 - k * 0.03), CFrame.new(x * sz.X * (0.48 + k * 0.1), sz.Y * (0.35 + k * 0.25), 0) * CFrame.Angles(0, 0, math.rad(-x * (20 + k * 18))), WHITE)
						end
					end
					piece(m, hd, "Mouthline", Vector3.new(sz.X * 0.22, 0.03, 0.04), CFrame.new(0, -sz.Y * 0.18, -sz.Z * 0.54), C(180, 180, 190))
				end,
				function(m) -- stars sprinkled over the body + chest Omnitrix symbol
					local rng = Random.new(10)
					for _, p in m:GetChildren() do
						if p:IsA("BasePart") and p.Name ~= "HumanoidRootPart" and p.Name ~= "Head" and not p.Name:find("Costume_") then
							for _ = 1, 4 do
								local sz = p.Size
								piece(m, p, "Star", Vector3.new(0.07, 0.07, 0.03), CFrame.new(rng:NextNumber(-0.4, 0.4) * sz.X, rng:NextNumber(-0.4, 0.4) * sz.Y, -sz.Z / 2 - 0.015), WHITE, Enum.Material.SmoothPlastic)
							end
						end
					end
					local t = chestOf(m)
					if t then
						local e = piece(m, t, "Omni", Vector3.new(0.06, t.Size.X * 0.3, t.Size.X * 0.3), CFrame.new(0, t.Size.Y * 0.15, front(t, 0.03)) * CFrame.Angles(0, math.rad(90), 0), WHITE, nil, Enum.PartType.Cylinder)
						piece(m, e, "OmniCore", Vector3.new(0.08, t.Size.X * 0.2, t.Size.X * 0.2), CFrame.new(), C(110, 255, 120), Enum.Material.SmoothPlastic, Enum.PartType.Cylinder)
					end
				end,
			} }
	end

	local pieces = {
		{ "Face", C(70, 160, 70), HAIR:Lerp(C(0, 0, 0), 0.3), "smirk" },
		{ "Hair", HAIR },
		function(m) -- Ben's swept fringe + side tufts
			local hd = find(m, "Head"); if not hd then return end
			local sz = hd.Size
			for i, o in { { -0.28, 8 }, { -0.05, -14 }, { 0.2, -22 } } do
				local f = piece(m, hd, "Fringe", Vector3.new(sz.X * 0.34, sz.Y * 0.2, sz.Z * 0.18), CFrame.new(o[1] * sz.X, sz.Y * (0.27 - i * 0.015), -sz.Z * 0.45) * CFrame.Angles(math.rad(-10), 0, math.rad(o[2])), HAIR)
				Instance.new("SpecialMesh", f).MeshType = Enum.MeshType.Wedge
			end
			piece(m, hd, "HairBack", Vector3.new(sz.X * 1.06, sz.Y * 0.55, sz.Z * 0.3), CFrame.new(0, sz.Y * 0.05, sz.Z * 0.42), HAIR)
			for _, x in { -1, 1 } do piece(m, hd, "Tuft", Vector3.new(sz.X * 0.1, sz.Y * 0.35, sz.Z * 0.45), CFrame.new(x * sz.X * 0.5, sz.Y * 0.15, sz.Z * 0.1), HAIR) end
		end,
		function(m) -- sneakers: white soles + toe caps + laces
			each(m, { "LeftFoot", "RightFoot" }, function(f)
				local sz = f.Size
				piece(m, f, "Sole", Vector3.new(sz.X * 1.06, 0.1, sz.Z * 1.08), CFrame.new(0, -sz.Y / 2 + 0.03, 0), WHITE)
				piece(m, f, "Toe", Vector3.new(sz.X * 0.9, sz.Y * 0.4, 0.06), CFrame.new(0, -sz.Y * 0.1, -sz.Z / 2 - 0.03), WHITE)
				piece(m, f, "Laces", Vector3.new(sz.X * 0.3, 0.04, sz.Z * 0.4), CFrame.new(0, sz.Y / 2 + 0.01, -sz.Z * 0.15), WHITE)
			end)
		end,
		function(m) -- cargo pants: thigh pockets + rolled cuffs
			each(m, { "LeftUpperLeg", "RightUpperLeg" }, function(a, side)
				piece(m, a, "Cargo", Vector3.new(0.08, a.Size.Y * 0.4, a.Size.Z * 0.6), CFrame.new(side * (a.Size.X / 2 + 0.04), -a.Size.Y * 0.1, 0), s.Secondary:Lerp(C(0, 0, 0), 0.15))
			end)
			each(m, { "LeftLowerLeg", "RightLowerLeg" }, function(a)
				piece(m, a, "Cuff", Vector3.new(a.Size.X * 1.08, 0.14, a.Size.Z * 1.08), CFrame.new(0, -a.Size.Y * 0.42, 0), s.Secondary:Lerp(C(0, 0, 0), 0.15))
			end)
		end,
	}
	if s.Tee then -- Classic: white tee with one black stripe down the middle, front and back
		table.insert(pieces, function(m)
			local t = chestOf(m); if not t then return end
			local sz = t.Size
			for _, z in { -1, 1 } do piece(m, t, "TeeStripe", Vector3.new(sz.X * 0.2, sz.Y * 1.0, 0.04), CFrame.new(0, 0, z * (sz.Z / 2 + 0.02)), stripe) end
			piece(m, t, "Collar", Vector3.new(sz.X * 0.36, 0.08, 0.05), CFrame.new(0, sz.Y * 0.46, front(t, 0.03)), stripe)
			if s.Logo then
				local l = piece(m, t, "Logo", Vector3.new(sz.X * 0.22, sz.Y * 0.22, 0.05), CFrame.new(0, sz.Y * 0.15, front(t, 0.05)), WHITE); l.Transparency = 1
				glyph(l, Enum.NormalId.Front, "10", WHITE)
			end
			each(m, { "LeftUpperArm", "RightUpperArm" }, function(a)
				piece(m, a, "SleeveHem", Vector3.new(a.Size.X * 1.06, 0.07, a.Size.Z * 1.06), CFrame.new(0, -a.Size.Y * 0.1, 0), stripe)
			end)
		end)
	elseif s.Suit then -- Ben 10,000: black/white bodysuit, big Omnitrix symbol on the chest, white gloves + boots
		table.insert(pieces, function(m)
			local t = chestOf(m); if not t then return end
			local sz = t.Size
			piece(m, t, "Yoke", Vector3.new(sz.X * 1.02, sz.Y * 0.35, sz.Z * 1.04), CFrame.new(0, sz.Y * 0.33, 0), WHITE)
			local e = piece(m, t, "Omni", Vector3.new(0.06, sz.X * 0.42, sz.X * 0.42), CFrame.new(0, sz.Y * 0.1, front(t, 0.03)) * CFrame.Angles(0, math.rad(90), 0), BLACK, nil, Enum.PartType.Cylinder)
			piece(m, e, "OmniRing", Vector3.new(0.07, e.Size.Y * 0.84, e.Size.Z * 0.84), CFrame.new(), GREEN, Enum.Material.SmoothPlastic, Enum.PartType.Cylinder)
			piece(m, e, "OmniCore", Vector3.new(0.08, e.Size.Y * 0.6, e.Size.Z * 0.6), CFrame.new(), BLACK, nil, Enum.PartType.Cylinder)
			for _, a in { 35, -35 } do piece(m, e, "Hourglass", Vector3.new(0.09, 0.07, e.Size.Z * 0.55), CFrame.Angles(math.rad(90 + a), 0, 0), GREEN, Enum.Material.SmoothPlastic) end
		end)
		table.insert(pieces, { "Belt", WHITE, { color = BLACK } })
	else -- Alien Force jacket: green body, black yoke + collar, white stripe, open front over a black shirt, "10" on the chest
		table.insert(pieces, function(m)
			local t = chestOf(m); if not t then return end
			local sz = t.Size
			local fz = front(t, 0.03)
			piece(m, t, "Yoke", Vector3.new(sz.X * 1.03, sz.Y * 0.3, sz.Z * 1.05), CFrame.new(0, sz.Y * 0.36, 0), trim)
			piece(m, t, "YokeStripe", Vector3.new(sz.X * 1.04, sz.Y * 0.07, sz.Z * 1.06), CFrame.new(0, sz.Y * 0.18, 0), stripe)
			piece(m, t, "Shirt", Vector3.new(sz.X * 0.2, sz.Y * 1.0, 0.03), CFrame.new(0, 0, fz - 0.02), BLACK)
			for _, x in { -1, 1 } do
				piece(m, t, "Zip", Vector3.new(0.04, sz.Y * 1.0, 0.04), CFrame.new(x * sz.X * 0.11, 0, fz - 0.03), C(170, 170, 175), Enum.Material.Metal)
				piece(m, t, "Collar", Vector3.new(sz.X * 0.3, 0.3, 0.1), CFrame.new(x * sz.X * 0.2, sz.Y / 2 + 0.1, -sz.Z * 0.3) * CFrame.Angles(math.rad(-10), 0, math.rad(x * 15)), trim)
				piece(m, t, "Hem", Vector3.new(sz.X * 0.4, 0.12, sz.Z * 1.06), CFrame.new(x * sz.X * 0.3, -sz.Y / 2 + 0.06, 0), trim)
			end
			local l = piece(m, t, "Logo", Vector3.new(sz.X * 0.2, sz.Y * 0.2, 0.05), CFrame.new(-sz.X * 0.28, -sz.Y * 0.05, fz - 0.02), WHITE); l.Transparency = 1
			glyph(l, Enum.NormalId.Front, "10", stripe)
			each(m, { "LeftUpperArm", "RightUpperArm", "LeftLowerArm", "RightLowerArm", "LeftArm", "RightArm" }, function(a, side) -- white stripe down the outer sleeve
				piece(m, a, "SleeveStripe", Vector3.new(0.04, a.Size.Y * 1.0, a.Size.Z * 0.22), CFrame.new(side * (a.Size.X / 2 + 0.02), 0, 0), stripe)
				if a.Name:find("Lower") or a.Name:find("Arm") and not a.Name:find("Upper") then
					piece(m, a, "SleeveCuff", Vector3.new(a.Size.X * 1.08, 0.16, a.Size.Z * 1.08), CFrame.new(0, -a.Size.Y * 0.42, 0), trim)
				end
			end)
		end)
	end
	local tee = s.Tee
	return { colors = { Head = SKIN, Chest = s.Primary, Waist = s.Secondary, UpperArms = s.Primary, LowerArms = tee and SKIN or (s.Suit and BLACK or s.Primary),
		Hands = s.Suit and WHITE or SKIN, Legs = s.Secondary, Feet = s.Suit and WHITE or (s.Shoes or C(30, 30, 34)) },
		pieces = pieces }
end
