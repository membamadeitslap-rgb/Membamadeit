-- Ben 10 (Ben Tennyson, cartoon style): kid proportions, rounded head with big green eyes and a smirk, fluffy brown hair with a
-- fringe swept across the forehead; Classic = white tee with one black stripe down the middle, green cargo pants, black/white sneakers.
-- Later looks: Alien Force green jacket (black yoke, white stripe, "10"), Ultimate Alien black jacket with green trim,
-- Omniverse black tee with green stripe, Ben 10,000 black/white suit with the Omnitrix symbol, Alien X starfield body.
-- The Omnitrix itself is a weapon (Weapons.Omnitrix) on the left wrist.
-- Costume module: return function(s, H, rarity) -> { colors = { group = Color3 }, pieces = { { "Piece", args... } | function(m) end } }
-- s = skin variant (Name, Primary, Secondary = pants, Trim, Stripe, Tee, Suit, AlienX, Logo...), H = shared helpers, rarity = tier name
return function(s, H, rarity)
	local C, SKIN, WHITE = H.C, H.SKIN, H.WHITE
	local piece, round, band, find, chestOf, waistOf, glyph = H.piece, H.round, H.band, H.find, H.chestOf, H.waistOf, H.glyph
	local function each(m, names, fn) for _, n in names do local a = m:FindFirstChild(n); if a then fn(a, n:find("Left") and -1 or 1) end end end
	local V, CF = Vector3.new, CFrame.new
	local BLACK, GREEN = C(25, 25, 28), C(70, 210, 70)
	local trim, stripe = s.Trim or BLACK, s.Stripe or WHITE
	local HAIR = s.Hair or C(110, 70, 38)
	local skin = SKIN

	-- rounded head shell replacing the box head; returns shell + surface placer at(x, y, out) facing outward
	local function shellHead(m, color, sx, sy, sz_)
		local hd = find(m, "Head"); if not hd then return end
		hd.Transparency = 1
		local s0 = hd.Size
		local X, Y, Z = s0.X * sx, s0.Y * sy, s0.Z * sz_
		local shell = round(m, hd, "Skull", V(X, Y, Z), CF(0, s0.Y * 0.02, 0), color)
		local function at(x, y, out)
			local a, b, c = X / 2, Y / 2, Z / 2
			local z = -c * math.sqrt(math.max(0.02, 1 - (x / a) ^ 2 - (y / b) ^ 2))
			local pos = V(x, y, z)
			local n = V(x / (a * a), y / (b * b), z / (c * c)).Unit
			return CFrame.lookAt(pos, pos + n) * CF(0, 0, -(out or 0))
		end
		return shell, at, X, Y, Z
	end
	-- elliptical band (SpecialMesh cylinder scaled per axis) around a torso/waist: dx wide, dz deep, h tall
	local function eband(m, a, name, dx, dz, h, cf, color, mat)
		local p = piece(m, a, name, V(h, dx, dz), cf * CFrame.Angles(0, 0, math.rad(90)), color, mat)
		local sm = Instance.new("SpecialMesh"); sm.MeshType = Enum.MeshType.Cylinder; sm.Parent = p
		return p
	end
	-- torso stripe: a narrow slice of the sculpted chest + abs ellipsoids, slightly proud, so it hugs the rounded torso front and back
	local function torsoStripe(m, t, width, color)
		local sz = t.Size
		round(m, t, "Stripe", V(sz.X * width, sz.Y * 0.97, sz.Z * 1.04), CF(0, sz.Y * 0.1, 0), color)
		round(m, t, "Stripe", V(sz.X * width, sz.Y * 0.77, sz.Z * 0.97), CF(0, -sz.Y * 0.2, 0), color)
	end

	if s.AlienX then -- Alien X: starfield-black body, white face plate and horns, green eyes (non-Neon)
		local VOID = C(12, 12, 20)
		return { colors = { Head = VOID, Chest = VOID, Waist = VOID, Arms = VOID, Hands = VOID, Legs = VOID, Feet = VOID },
			pieces = {
				function(m)
					local shell, at, X, Y = shellHead(m, VOID, 1.0, 1.15, 1.0); if not shell then return end
					round(m, shell, "Mask", V(X * 0.8, Y * 0.62, 0.12), at(0, Y * 0.02, -0.02), WHITE)
					for _, x in { -1, 1 } do
						round(m, shell, "Eye", V(X * 0.24, Y * 0.09, 0.08), at(x * X * 0.17, Y * 0.06, 0.08) * CFrame.Angles(0, 0, math.rad(x * -14)), C(110, 255, 120), Enum.Material.SmoothPlastic)
						for k = 0, 3 do -- horns curling up and out from the temples
							round(m, shell, "Horn", V(0.22 - k * 0.04, 0.5, 0.22 - k * 0.04), CF(x * X * (0.45 + k * 0.12), Y * (0.35 + k * 0.22), 0) * CFrame.Angles(0, 0, math.rad(-x * (20 + k * 18))), WHITE)
						end
					end
				end,
				function(m) -- stars sprinkled over the body + chest Omnitrix symbol
					local rng = Random.new(10)
					for _, n in { "UpperTorso", "LowerTorso", "LeftUpperArm", "RightUpperArm", "LeftUpperLeg", "RightUpperLeg", "LeftLowerLeg", "RightLowerLeg" } do
						local p = find(m, n)
						if p then for _ = 1, 3 do
							local sz = p.Size
							round(m, p, "Star", V(0.08, 0.08, 0.03), CF(rng:NextNumber(-0.3, 0.3) * sz.X, rng:NextNumber(-0.3, 0.3) * sz.Y, -sz.Z / 2 - 0.02), WHITE, Enum.Material.SmoothPlastic)
						end end
					end
					local t = chestOf(m)
					if t then
						local e = piece(m, t, "Omni", V(0.06, t.Size.X * 0.3, t.Size.X * 0.3), CF(0, t.Size.Y * 0.15, -t.Size.Z / 2 - 0.03) * CFrame.Angles(0, math.rad(90), 0), WHITE, nil, Enum.PartType.Cylinder)
						piece(m, e, "OmniCore", V(0.08, t.Size.X * 0.2, t.Size.X * 0.2), CF(), C(110, 255, 120), Enum.Material.SmoothPlastic, Enum.PartType.Cylinder)
					end
				end,
			} }
	end

	local pieces = {
		function(m) -- head: rounded skull, big green eyes, brows, small nose, smirk, ears; fluffy hair with a swept fringe
			local shell, at, X, Y, Z = shellHead(m, skin, 1.0, 1.08, 1.02); if not shell then return end
			local dark = skin:Lerp(C(0, 0, 0), 0.5)
			for _, x in { -1, 1 } do
				local ex, ey = x * X * 0.19, -Y * 0.02
				round(m, shell, "Sclera", V(X * 0.22, Y * 0.19, 0.08), at(ex, ey, -0.01), C(252, 252, 252))
				round(m, shell, "Iris", V(X * 0.13, Y * 0.16, 0.08), at(ex - x * X * 0.02, ey - Y * 0.01, 0.0), C(70, 170, 80))
				round(m, shell, "Pupil", V(X * 0.06, Y * 0.08, 0.08), at(ex - x * X * 0.02, ey - Y * 0.01, 0.012), BLACK)
				piece(m, shell, "Lid", V(X * 0.21, 0.04, 0.04), at(ex, ey + Y * 0.08, 0.01), BLACK)
				piece(m, shell, "Brow", V(X * 0.2, 0.06, 0.05), at(ex, ey + Y * 0.16, 0.01) * CFrame.Angles(0, 0, math.rad(x > 0 and 12 or -4)), HAIR:Lerp(C(0, 0, 0), 0.3))
				round(m, shell, "Ear", V(X * 0.1, Y * 0.24, Z * 0.2), CF(x * X * 0.49, -Y * 0.04, Z * 0.02), skin)
			end
			round(m, shell, "Nose", V(X * 0.1, Y * 0.1, 0.14), at(0, -Y * 0.14, 0.0), skin:Lerp(C(0, 0, 0), 0.05))
			piece(m, shell, "Mouth", V(X * 0.22, 0.04, 0.04), at(X * 0.03, -Y * 0.29, 0.0) * CFrame.Angles(0, 0, math.rad(10)), dark)
			piece(m, shell, "MouthCorner", V(X * 0.06, 0.04, 0.04), at(X * 0.15, -Y * 0.26, 0.0) * CFrame.Angles(0, 0, math.rad(40)), dark)
			-- hair
			round(m, shell, "Hair", V(X * 1.1, Y * 0.72, Z * 1.12), CF(0, Y * 0.24, Z * 0.04), HAIR)
			round(m, shell, "HairBack", V(X * 1.04, Y * 0.8, Z * 0.6), CF(0, Y * 0.02, Z * 0.26), HAIR)
			for i, o in { { -0.28, 0.25, 30 }, { -0.04, 0.22, 34 }, { 0.22, 0.2, 40 } } do -- fringe locks swept toward his left
				round(m, shell, "Fringe", V(X * 0.36, Y * 0.18, Z * 0.2), at(o[1] * X, o[2] * Y, -0.02) * CFrame.Angles(0, 0, math.rad(-o[3] + i * 4)), HAIR)
			end
			for _, x in { -1, 1 } do round(m, shell, "Tuft", V(X * 0.16, Y * 0.4, Z * 0.5), CF(x * X * 0.47, Y * 0.12, Z * 0.08), HAIR) end
		end,
		function(m) -- sneakers: white soles + toe caps
			each(m, { "LeftFoot", "RightFoot" }, function(f)
				local sz = f.Size
				piece(m, f, "Sole", V(sz.X * 0.95, 0.1, sz.Z * 1.15), CF(0, -sz.Y / 2 + 0.03, -sz.Z * 0.02), WHITE)
				round(m, f, "Toe", V(sz.X * 0.85, sz.Y * 0.8, sz.Z * 0.4), CF(0, -sz.Y * 0.1, -sz.Z * 0.42), WHITE)
			end)
		end,
		function(m) -- cargo pants: side pockets + cuffs
			each(m, { "LeftUpperLeg", "RightUpperLeg" }, function(a, side)
				round(m, a, "Cargo", V(0.12, a.Size.Y * 0.45, a.Size.Z * 0.6), CF(side * (a.Size.X * 0.48), -a.Size.Y * 0.1, 0), s.Secondary:Lerp(C(0, 0, 0), 0.15))
			end)
			each(m, { "LeftLowerLeg", "RightLowerLeg" }, function(a)
				band(m, a, "Cuff", a.Size.X * 1.12, 0.14, CF(0, -a.Size.Y * 0.42, 0), s.Secondary:Lerp(C(0, 0, 0), 0.15))
			end)
		end,
	}
	if s.Tee then -- Classic: white tee with one black stripe down the middle (front and back); Omniverse: black tee, green stripe
		table.insert(pieces, function(m)
			local t = chestOf(m); if not t then return end
			torsoStripe(m, t, 0.2, stripe)
			band(m, t, "Collar", t.Size.Z * 0.62, 0.08, CF(0, t.Size.Y * 0.5, 0), stripe)
			if s.Logo then
				local l = piece(m, t, "Logo", V(t.Size.X * 0.22, t.Size.Y * 0.22, 0.05), CF(-t.Size.X * 0.25, t.Size.Y * 0.2, -t.Size.Z / 2 - 0.06), WHITE); l.Transparency = 1
				glyph(l, Enum.NormalId.Front, "10", stripe)
			end
			each(m, { "LeftUpperArm", "RightUpperArm" }, function(a)
				round(m, a, "SleeveCap", V(a.Size.X * 1.22, a.Size.Y * 0.9, a.Size.Z * 1.22), CF(0, a.Size.Y * 0.3, 0), s.Primary)
				band(m, a, "Sleeve", a.Size.X * 1.2, a.Size.Y * 0.4, CF(0, a.Size.Y * 0.12, 0), s.Primary)
				band(m, a, "SleeveHem", a.Size.X * 1.22, 0.06, CF(0, -a.Size.Y * 0.08, 0), stripe)
			end)
		end)
	elseif s.Suit then -- Ben 10,000: black bodysuit, white yoke, big Omnitrix symbol on the chest, white gloves + boots, belt
		table.insert(pieces, function(m)
			local t = chestOf(m); if not t then return end
			local sz = t.Size
			round(m, t, "Yoke", V(sz.X * 1.04, sz.Y * 0.5, sz.Z * 1.06), CF(0, sz.Y * 0.36, 0), WHITE)
			local e = piece(m, t, "Omni", V(0.06, sz.X * 0.4, sz.X * 0.4), CF(0, sz.Y * 0.05, -sz.Z / 2 - 0.05) * CFrame.Angles(0, math.rad(90), 0), BLACK, nil, Enum.PartType.Cylinder)
			piece(m, e, "OmniRing", V(0.07, e.Size.Y * 0.84, e.Size.Z * 0.84), CF(), GREEN, Enum.Material.SmoothPlastic, Enum.PartType.Cylinder)
			piece(m, e, "OmniCore", V(0.08, e.Size.Y * 0.62, e.Size.Z * 0.62), CF(), BLACK, nil, Enum.PartType.Cylinder)
			for _, a in { 35, -35 } do piece(m, e, "Hourglass", V(0.09, 0.07, e.Size.Z * 0.55), CFrame.Angles(math.rad(90 + a), 0, 0), GREEN, Enum.Material.SmoothPlastic) end
			local w = waistOf(m)
			if w then eband(m, w, "Belt", w.Size.X * 1.0, w.Size.Z * 1.05, w.Size.Y * 0.6, CF(0, w.Size.Y * 0.25, 0), WHITE) end
		end)
	else -- Alien Force / Ultimate Alien jacket: body color, contrasting yoke, white stripe under it, open front over a black shirt, "10"
		table.insert(pieces, function(m)
			local t = chestOf(m); if not t then return end
			local sz = t.Size
			round(m, t, "Yoke", V(sz.X * 1.04, sz.Y * 0.48, sz.Z * 1.07), CF(0, sz.Y * 0.38, 0), trim)
			torsoStripe(m, t, 0.2, BLACK)
			for _, x in { -1, 1 } do
				round(m, t, "Collar", V(sz.X * 0.3, sz.Y * 0.28, sz.Z * 0.3), CF(x * sz.X * 0.17, sz.Y * 0.5, -sz.Z * 0.22) * CFrame.Angles(math.rad(-10), 0, math.rad(x * 20)), trim)
			end
			eband(m, t, "Hem", sz.X * 0.84, sz.Z * 0.98, 0.14, CF(0, -sz.Y * 0.47, 0), trim)
			local l = piece(m, t, "Logo", V(sz.X * 0.2, sz.Y * 0.2, 0.05), CF(-sz.X * 0.25, sz.Y * 0.0, -sz.Z / 2 - 0.08), WHITE); l.Transparency = 1
			glyph(l, Enum.NormalId.Front, "10", stripe)
			each(m, { "LeftUpperArm", "RightUpperArm" }, function(a)
				band(m, a, "SleeveStripe", a.Size.X * 1.12, 0.1, CF(0, a.Size.Y * 0.05, 0), stripe)
			end)
			each(m, { "LeftLowerArm", "RightLowerArm" }, function(a)
				band(m, a, "SleeveCuff", a.Size.X * 1.1, 0.16, CF(0, -a.Size.Y * 0.42, 0), trim)
			end)
		end)
	end
	local tee = s.Tee
	return { colors = { Head = skin, Chest = s.Primary, Waist = s.Secondary, UpperArms = tee and skin or s.Primary, LowerArms = tee and skin or (s.Suit and BLACK or s.Primary),
		Hands = s.Suit and WHITE or skin, Legs = s.Secondary, Feet = s.Suit and WHITE or (s.Shoes or C(30, 30, 34)) },
		pieces = pieces }
end
