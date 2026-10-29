-- Blossom (Powerpuff Girls, Craig McCracken style): giant wide oval head (about half her height) with huge pink oval eyes,
-- no nose, tiny mouth; long orange hair with swept bangs flowing down past her waist; big red bow on top;
-- tiny body: pink dress with a black stripe under the chest and an A-line skirt, stubby nub arms, white tights, black Mary Janes.
-- Costume module: return function(s, H, rarity) -> { colors = { group = Color3 }, pieces = { { "Piece", args... } | function(m) end } }
-- s = skin variant (Name, Primary = dress, Secondary = stripe, Bow, Hair, Iris, Ponytail, Armor, Belt, Tights...), H = shared helpers, rarity = tier name
return function(s, H, rarity)
	local C, WHITE = H.C, H.WHITE
	local piece, round, band, find, chestOf, waistOf = H.piece, H.round, H.band, H.find, H.chestOf, H.waistOf
	local function each(m, names, fn) for _, n in names do local a = m:FindFirstChild(n); if a then fn(a, n:find("Left") and -1 or 1) end end end
	local V, CF = Vector3.new, CFrame.new
	local FAB = Enum.Material.Fabric
	local skin = C(255, 214, 186)
	local hairC, bowC, iris = s.Hair or C(235, 110, 40), s.Bow or C(220, 25, 40), s.Iris or C(230, 80, 150)
	local BLACK = C(20, 20, 22)
	local hairD = hairC:Lerp(C(0, 0, 0), 0.12)

	local pieces = {
		function(m) -- the big PPG head (replaces the box head)
			local hd = find(m, "Head"); if not hd then return end
			hd.Transparency = 1
			local sz = hd.Size
			local X, Y, Z = sz.X * 1.32, sz.Y * 1.08, sz.Z * 1.12
			local c0 = CF(0, sz.Y * 0.0, -sz.Z * 0.02)
			local shell = round(m, hd, "BigHead", V(X, Y, Z), c0, skin)
			-- point on the shell surface at (x, y) facing outward
			local function at(x, y, out)
				local a, b, c = X / 2, Y / 2, Z / 2
				local z = -c * math.sqrt(math.max(0.02, 1 - (x / a) ^ 2 - (y / b) ^ 2))
				local pos = V(x, y, z)
				local n = V(x / (a * a), y / (b * b), z / (c * c)).Unit
				return CFrame.lookAt(pos, pos + n) * CF(0, 0, -(out or 0))
			end
			-- eyes: huge vertical ovals, tilted outward at the top; black upper lid + a single outer lash
			for _, x in { -1, 1 } do
				local ex, ey = x * X * 0.2, -Y * 0.04
				local cf = at(ex, ey, 0.0) * CFrame.Angles(0, 0, math.rad(-x * 10))
				round(m, shell, "Sclera", V(X * 0.3, Y * 0.44, 0.16), cf, C(252, 252, 252))
				round(m, shell, "Iris", V(X * 0.21, Y * 0.31, 0.16), cf * CF(-x * X * 0.035, -Y * 0.035, -0.025), iris)
				round(m, shell, "Pupil", V(X * 0.12, Y * 0.18, 0.16), cf * CF(-x * X * 0.045, -Y * 0.05, -0.04), BLACK)
				round(m, shell, "Shine", V(X * 0.05, Y * 0.07, 0.14), cf * CF(-x * X * 0.02, Y * 0.0, -0.06), WHITE)
				piece(m, shell, "LidLine", V(X * 0.2, 0.05, 0.05), cf * CF(0, Y * 0.21, -0.07), BLACK)
				piece(m, shell, "Lash", V(X * 0.1, 0.05, 0.05), cf * CF(x * X * 0.14, Y * 0.18, -0.07) * CFrame.Angles(0, 0, math.rad(x * 38)), BLACK)
				round(m, shell, "Blush", V(X * 0.08, Y * 0.04, 0.06), at(x * X * 0.31, -Y * 0.26, -0.01), C(255, 185, 185))
			end
			-- small smile
			local mcf = at(0, -Y * 0.33, -0.01)
			round(m, shell, "Mouth", V(X * 0.1, Y * 0.045, 0.06), mcf, C(140, 40, 50))
			round(m, shell, "MouthMask", V(X * 0.12, Y * 0.04, 0.06), mcf * CF(0, Y * 0.02, -0.005), skin)
			-- hair: crown cap behind the face, two swept bangs parted off-center, side curtains
			round(m, shell, "HairCap", V(X * 1.06, Y * 1.0, Z * 1.02), CF(0, Y * 0.16, Z * 0.1), hairC)
			round(m, shell, "Bang", V(X * 0.6, Y * 0.3, Z * 0.25), at(-X * 0.15, Y * 0.28, -0.02) * CFrame.Angles(0, 0, math.rad(-14)), hairC)
			round(m, shell, "Bang", V(X * 0.46, Y * 0.26, Z * 0.25), at(X * 0.24, Y * 0.29, -0.02) * CFrame.Angles(0, 0, math.rad(20)), hairC)
			for _, x in { -1, 1 } do
				round(m, shell, "Curtain", V(X * 0.15, Y * 0.8, Z * 0.5), CF(x * X * 0.46, -Y * 0.06, Z * 0.1) * CFrame.Angles(0, 0, math.rad(x * 6)), hairC)
			end
			-- long fall: widens below the head, ends in a soft point past the waist
			round(m, shell, "HairFall", V(X * 0.86, Y * 0.95, Z * 0.42), CF(0, -Y * 0.36, Z * 0.3), hairC)
			round(m, shell, "HairFall", V(X * 0.7, Y * 0.8, Z * 0.3), CF(0, -Y * 0.78, Z * 0.38) * CFrame.Angles(math.rad(-6), 0, 0), hairD)
			round(m, shell, "HairTip", V(X * 0.42, Y * 0.42, Z * 0.24), CF(0, -Y * 1.08, Z * 0.42) * CFrame.Angles(math.rad(-8), 0, 0), hairC)
			if s.Ponytail then -- Hyper Blossom: high ponytail swinging back
				round(m, shell, "Ponytail", V(X * 0.36, Y * 1.3, Z * 0.36), CF(0, -Y * 0.05, Z * 0.7) * CFrame.Angles(math.rad(-30), 0, 0), hairC)
			end
			-- the bow: knot + two big loops angled up + two short tails, on top toward the back
			local bowCF = CF(0, Y * 0.5, Z * 0.18) * CFrame.Angles(math.rad(-12), 0, 0)
			round(m, shell, "BowKnot", V(X * 0.16, Y * 0.18, Z * 0.18), bowCF, bowC:Lerp(C(0, 0, 0), 0.15))
			for _, x in { -1, 1 } do
				round(m, shell, "BowLoop", V(X * 0.5, Y * 0.36, Z * 0.2), bowCF * CF(x * X * 0.26, Y * 0.07, 0) * CFrame.Angles(0, 0, math.rad(x * 22)), bowC)
				round(m, shell, "BowTail", V(X * 0.12, Y * 0.28, 0.08), bowCF * CF(x * X * 0.09, -Y * 0.14, Z * 0.1) * CFrame.Angles(0, 0, math.rad(x * 24)), bowC)
			end
		end,
		function(m) -- dress: rounded bodice, black stripe under the chest, A-line skirt
			local t = chestOf(m)
			if t then
				local sz = t.Size
				band(m, t, "Stripe", sz.X * 0.95, sz.Y * 0.14, CF(0, -sz.Y * 0.1, 0), s.Secondary)
			end
			local w = waistOf(m); if not w then return end
			local sz = w.Size
			local n = 12
			for i = 0, n - 1 do
				local a = i / n * math.pi * 2
				local r = V(math.sin(a) * sz.X * 0.56, 0, math.cos(a) * sz.Z * 0.62)
				piece(m, w, "Skirt", V(sz.X * 0.36, sz.Y * 2.3, 0.08), CF(r.X, -sz.Y * 0.9, r.Z) * CFrame.Angles(0, a, 0) * CFrame.Angles(math.rad(-20), 0, 0), s.Primary, FAB)
			end
		end,
		function(m) -- Mary Janes: strap + rounded toe
			each(m, { "LeftFoot", "RightFoot" }, function(f)
				piece(m, f, "Strap", V(f.Size.X * 1.02, 0.06, 0.1), CF(0, f.Size.Y * 0.45, -f.Size.Z * 0.05), BLACK)
			end)
		end,
	}
	if s.Armor then -- Dynamo pilot: chrome shoulder pods, chest plate, cuffs
		table.insert(pieces, function(m)
			local t = chestOf(m); if not t then return end
			local sz = t.Size
			round(m, t, "ChestPlate", V(sz.X * 0.8, sz.Y * 0.55, sz.Z * 0.5), CF(0, sz.Y * 0.18, -sz.Z * 0.32), s.Armor, Enum.Material.Metal)
			each(m, { "LeftUpperArm", "RightUpperArm" }, function(a, x)
				round(m, a, "ShoulderPod", V(a.Size.X * 1.8, a.Size.Y * 1.0, a.Size.Z * 1.8), CF(0, a.Size.Y * 0.3, 0), s.Armor, Enum.Material.Metal)
			end)
			each(m, { "LeftLowerArm", "RightLowerArm" }, function(a)
				band(m, a, "Cuff", a.Size.X * 1.4, a.Size.Y * 0.5, CF(0, -a.Size.Y * 0.2, 0), s.Armor, Enum.Material.Metal)
			end)
		end)
	end
	if s.Belt then -- Hyper Blossom compact belt with a heart buckle
		table.insert(pieces, function(m)
			local w = waistOf(m); if not w then return end
			band(m, w, "Belt", w.Size.X * 1.08, w.Size.Y * 0.6, CF(0, w.Size.Y * 0.1, 0), s.Belt)
			local b = round(m, w, "Buckle", V(w.Size.X * 0.3, w.Size.X * 0.26, 0.12), CF(0, w.Size.Y * 0.1, -w.Size.Z * 0.55), C(255, 230, 120), Enum.Material.Metal)
			H.glyph(b, Enum.NormalId.Front, "♥", C(230, 40, 120))
		end)
	end
	return { colors = { Head = skin, Chest = s.Primary, Waist = s.Primary, Arms = skin, Hands = skin, UpperLegs = s.Tights or WHITE, LowerLegs = s.Tights or WHITE, Feet = BLACK },
		pieces = pieces }
end
