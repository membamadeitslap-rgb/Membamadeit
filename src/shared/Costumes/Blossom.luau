-- Blossom (Powerpuff Girls): oversized round head shell with huge pink eyes, long orange hair to the waist, big red bow,
-- pink dress with a black waist stripe and A-line skirt, white tights, black Mary Janes.
-- Costume module: return function(s, H, rarity) -> { colors = { group = Color3 }, pieces = { { "Piece", args... } | function(m) end } }
-- s = skin variant (Name, Primary = dress, Secondary = stripe, Bow, Hair, Iris, Ponytail, Armor...), H = shared helpers, rarity = tier name
return function(s, H, rarity)
	local C, SKIN, GOLD, WHITE = H.C, H.SKIN, H.GOLD, H.WHITE
	local piece, find, chestOf, waistOf, front = H.piece, H.find, H.chestOf, H.waistOf, H.front
	local function each(m, names, fn) for _, n in names do local a = m:FindFirstChild(n); if a then fn(a, n:find("Left") and -1 or 1) end end end
	local function oval(p) Instance.new("SpecialMesh", p).MeshType = Enum.MeshType.Sphere; return p end
	local skin = C(255, 222, 200)
	local hairC, bowC, iris = s.Hair or C(235, 110, 40), s.Bow or C(220, 25, 40), s.Iris or C(230, 80, 150)
	local BLACK = C(20, 20, 22)
	local pieces = {
		function(m) -- big head shell + giant eyes
			local hd = find(m, "Head"); if not hd then return end
			local sz = hd.Size
			local X, Y, Z = sz.X * 1.5, sz.Y * 1.32, sz.Z * 1.36
			local shell = oval(piece(m, hd, "BigHead", Vector3.new(X, Y, Z), CFrame.new(0, sz.Y * 0.14, -sz.Z * 0.05), skin))
			local function surf(x, y) return -(Z / 2) * math.sqrt(math.max(0.05, 1 - (2 * x / X) ^ 2 - (2 * y / Y) ^ 2)) end
			for _, x in { -1, 1 } do
				local ex, ey = x * X * 0.2, -Y * 0.02
				local cf = CFrame.new(ex, ey, surf(ex, ey) + 0.06) * CFrame.Angles(0, math.rad(x * 22), 0)
				oval(piece(m, shell, "Sclera", Vector3.new(X * 0.3, Y * 0.42, 0.2), cf, C(252, 252, 252)))
				oval(piece(m, shell, "Iris", Vector3.new(X * 0.21, Y * 0.3, 0.2), cf * CFrame.new(-x * X * 0.02, -Y * 0.02, -0.03), iris))
				oval(piece(m, shell, "Pupil", Vector3.new(X * 0.11, Y * 0.16, 0.2), cf * CFrame.new(-x * X * 0.025, -Y * 0.03, -0.05), BLACK))
				oval(piece(m, shell, "Shine", Vector3.new(X * 0.05, Y * 0.07, 0.2), cf * CFrame.new(-x * X * 0.05, Y * 0.04, -0.07), WHITE))
				piece(m, shell, "Lid", Vector3.new(X * 0.28, 0.07, 0.08), cf * CFrame.new(0, Y * 0.2, -0.04) * CFrame.Angles(0, 0, math.rad(x * -6)), BLACK)
				piece(m, shell, "Lash", Vector3.new(X * 0.09, 0.07, 0.07), cf * CFrame.new(x * X * 0.15, Y * 0.2, -0.04) * CFrame.Angles(0, 0, math.rad(x * 35)), BLACK)
			end
			local my = -Y * 0.3
			piece(m, shell, "Mouth", Vector3.new(X * 0.12, 0.05, 0.06), CFrame.new(0, my, surf(0, my) + 0.01), C(120, 40, 40))
			for _, x in { -1, 1 } do piece(m, shell, "MouthCurl", Vector3.new(X * 0.04, 0.05, 0.06), CFrame.new(x * X * 0.07, my + 0.02, surf(0, my) + 0.01) * CFrame.Angles(0, 0, math.rad(x * 35)), C(120, 40, 40)) end
			-- hair: cap over the back/top of the shell, bangs, side curtains, long fall down to the waist
			oval(piece(m, shell, "HairCap", Vector3.new(X * 1.05, Y * 1.06, Z * 1.02), CFrame.new(0, Y * 0.12, Z * 0.08), hairC))
			for i = -2, 2 do
				local bx = i * X * 0.13
				local bang = piece(m, shell, "Bang", Vector3.new(X * 0.2, Y * 0.2, 0.2), CFrame.new(bx, Y * 0.32 - math.abs(i) * Y * 0.02, surf(bx, Y * 0.32) + 0.08) * CFrame.Angles(math.rad(-25), 0, math.rad(i * 8)), hairC)
				Instance.new("SpecialMesh", bang).MeshType = Enum.MeshType.Wedge
			end
			local fall = piece(m, shell, "HairFall", Vector3.new(X * 0.95, Y * 1.9, Z * 0.32), CFrame.new(0, -Y * 0.75, Z * 0.36) * CFrame.Angles(math.rad(-8), 0, 0), hairC)
			piece(m, fall, "HairTip", Vector3.new(X * 0.75, Y * 0.2, Z * 0.28), CFrame.new(0, -fall.Size.Y / 2 - Y * 0.08, 0), hairC)
			if s.Ponytail then
				piece(m, shell, "Ponytail", Vector3.new(X * 0.35, Y * 1.4, Z * 0.3), CFrame.new(0, -Y * 0.1, Z * 0.65) * CFrame.Angles(math.rad(-25), 0, 0), hairC)
			end
			-- the bow: knot + two big loops + two tails
			local bowCF = CFrame.new(0, Y * 0.45, Z * 0.32) * CFrame.Angles(math.rad(-20), 0, 0)
			oval(piece(m, shell, "BowKnot", Vector3.new(X * 0.18, Y * 0.2, Z * 0.2), bowCF, bowC:Lerp(C(0, 0, 0), 0.15)))
			for _, x in { -1, 1 } do
				oval(piece(m, shell, "BowLoop", Vector3.new(X * 0.55, Y * 0.42, Z * 0.18), bowCF * CFrame.new(x * X * 0.3, Y * 0.06, 0) * CFrame.Angles(0, 0, math.rad(x * -18)), bowC))
				piece(m, shell, "BowTail", Vector3.new(X * 0.1, Y * 0.35, 0.06), bowCF * CFrame.new(x * X * 0.08, -Y * 0.2, 0.05) * CFrame.Angles(0, 0, math.rad(x * 20)), bowC)
			end
			for _, x in { -1, 1 } do -- tiny round ears hidden by hair; keeps the PPG silhouette clean
				piece(m, shell, "Cheek", Vector3.new(X * 0.1, Y * 0.06, 0.04), CFrame.new(x * X * 0.28, -Y * 0.2, surf(x * X * 0.28, -Y * 0.2) + 0.01), C(255, 190, 190))
			end
		end,
		function(m) -- dress: black waist stripe, A-line skirt panels, collar
			local t = chestOf(m)
			if t then
				local sz = t.Size
				piece(m, t, "Stripe", Vector3.new(sz.X * 1.03, sz.Y * 0.14, sz.Z * 1.05), CFrame.new(0, -sz.Y * 0.43, 0), s.Secondary)
				piece(m, t, "Neckline", Vector3.new(sz.X * 0.32, 0.08, 0.04), CFrame.new(0, sz.Y * 0.46, front(t, 0.02)), skin)
			end
			local w = waistOf(m); if not w then return end
			local sz = w.Size
			local y = w.Name == "Torso" and -sz.Y * 0.5 or -sz.Y * 0.3
			for i = 0, 9 do
				local a = i / 10 * math.pi * 2
				local r = Vector3.new(math.sin(a) * sz.X * 0.55, 0, math.cos(a) * sz.Z * 0.62)
				piece(m, w, "Skirt", Vector3.new(sz.X * 0.36, 1.0, 0.08), CFrame.new(r.X, y - 0.45, r.Z) * CFrame.Angles(0, a, 0) * CFrame.Angles(math.rad(-14), 0, 0), s.Primary, Enum.Material.Fabric)
			end
		end,
		function(m) -- Mary Janes: black shoe, strap, sole
			each(m, { "LeftFoot", "RightFoot" }, function(f)
				piece(m, f, "Strap", Vector3.new(f.Size.X * 1.06, 0.08, 0.12), CFrame.new(0, f.Size.Y * 0.3, -f.Size.Z * 0.1), BLACK)
				piece(m, f, "Toe", Vector3.new(f.Size.X * 0.9, f.Size.Y * 0.7, 0.1), CFrame.new(0, -f.Size.Y * 0.1, -f.Size.Z / 2 - 0.04), BLACK)
			end)
		end,
	}
	if s.Armor then -- Dynamo pilot: chrome shoulder pads, chest plate, gauntlets
		table.insert(pieces, { "Shoulders", s.Armor })
		table.insert(pieces, { "Cuffs", s.Armor })
		table.insert(pieces, function(m)
			local t = chestOf(m); if not t then return end
			piece(m, t, "ChestPlate", Vector3.new(t.Size.X * 0.8, t.Size.Y * 0.5, 0.1), CFrame.new(0, t.Size.Y * 0.15, front(t, 0.05)), s.Armor, Enum.Material.Metal)
		end)
	end
	if s.Belt then table.insert(pieces, { "Belt", s.Belt, { color = C(255, 230, 120), text = "♥", textColor = C(230, 40, 120) } }) end
	return { colors = { Head = skin, Chest = s.Primary, Waist = s.Primary, Arms = skin, Hands = skin, UpperLegs = WHITE, LowerLegs = s.Tights or WHITE, Feet = BLACK },
		pieces = pieces }
end
