-- Leonardo (TMNT): green turtle skin, blue mask with eye holes and long knot tails, domed brown shell with scutes,
-- yellow segmented plastron, brown belt, elbow/knee pads, tan wrist + ankle wraps, twin scabbards over the shell.
-- Costume module: return function(s, H, rarity) -> { colors = { group = Color3 }, pieces = { { "Piece", args... } | function(m) end } }
-- s = skin variant (Name, Primary = mask, Secondary = gear, Skin, Shell, Plastron, Letter, Iris, Robe...), H = shared helpers, rarity = tier name
return function(s, H, rarity)
	local C, SKIN, GOLD, WHITE = H.C, H.SKIN, H.GOLD, H.WHITE
	local piece, find, chestOf, waistOf, front, glyph = H.piece, H.find, H.chestOf, H.waistOf, H.front, H.glyph
	local function each(m, names, fn) for _, n in names do local a = m:FindFirstChild(n); if a then fn(a, n:find("Left") and -1 or 1) end end end
	local function oval(p) Instance.new("SpecialMesh", p).MeshType = Enum.MeshType.Sphere; return p end
	local skin = s.Skin or C(80, 150, 60)
	local shellC, plas, gear, wrap = s.Shell or C(110, 78, 45), s.Plastron or C(225, 200, 115), s.Secondary, s.Wrap or C(200, 175, 125)
	local dark = skin:Lerp(C(0, 0, 0), 0.5)
	local pieces = {
		function(m) -- head: mask band with eye holes, brow, wide mouth, knot + tails
			local hd = find(m, "Head"); if not hd then return end
			local sz = hd.Size
			local fz = -sz.Z * 0.53
			H.band(m, hd, "Mask", sz.X * 1.07, sz.Y * 0.3, CFrame.new(0, sz.Y * 0.08, 0), s.Primary, Enum.Material.Fabric)
			for _, x in { -1, 1 } do
				local ex = x * sz.X * 0.2
				oval(piece(m, hd, "Sclera", Vector3.new(sz.X * 0.22, sz.Y * 0.14, 0.05), CFrame.new(ex, sz.Y * 0.07, fz - 0.01), C(250, 250, 250)))
				oval(piece(m, hd, "Iris", Vector3.new(sz.X * 0.09, sz.Y * 0.11, 0.05), CFrame.new(ex - x * sz.X * 0.02, sz.Y * 0.065, fz - 0.025), s.Iris or C(60, 110, 200)))
				oval(piece(m, hd, "Pupil", Vector3.new(sz.X * 0.045, sz.Y * 0.06, 0.05), CFrame.new(ex - x * sz.X * 0.02, sz.Y * 0.065, fz - 0.035), C(10, 10, 12)))
				piece(m, hd, "Brow", Vector3.new(sz.X * 0.3, sz.Y * 0.06, 0.06), CFrame.new(ex, sz.Y * 0.17, fz - 0.02) * CFrame.Angles(0, 0, math.rad(x * -14)), s.Primary:Lerp(C(0, 0, 0), 0.2), Enum.Material.Fabric)
				oval(piece(m, hd, "Tail", Vector3.new(sz.X * 0.16, sz.Y * 1.2, 0.06), CFrame.new(x * sz.X * 0.13, -sz.Y * 0.4, sz.Z * 0.6) * CFrame.Angles(math.rad(12), 0, math.rad(x * 16)), s.Primary, Enum.Material.Fabric))
			end
			oval(piece(m, hd, "Knot", Vector3.new(sz.X * 0.24, sz.Y * 0.22, 0.2), CFrame.new(0, sz.Y * 0.08, sz.Z * 0.55), s.Primary:Lerp(C(0, 0, 0), 0.15), Enum.Material.Fabric))
			piece(m, hd, "Mouth", Vector3.new(sz.X * 0.56, sz.Y * 0.035, 0.04), CFrame.new(0, -sz.Y * 0.25, -sz.Z * 0.555), dark)
			oval(piece(m, hd, "Beak", Vector3.new(sz.X * 0.62, sz.Y * 0.36, sz.Z * 0.3), CFrame.new(0, -sz.Y * 0.16, -sz.Z * 0.4), skin:Lerp(C(255, 255, 255), 0.06)))
		end,
		function(m) -- shell: dome, darker rim, scutes; plastron on the front with segment lines
			local t = chestOf(m); if not t then return end
			local sz = t.Size
			local dome = oval(piece(m, t, "Shell", Vector3.new(sz.X * 1.05, sz.Y * 1.35, 1.0), CFrame.new(0, -sz.Y * 0.1, sz.Z / 2 + 0.12), shellC))
			oval(piece(m, t, "ShellRim", Vector3.new(sz.X * 1.12, sz.Y * 1.42, 0.5), CFrame.new(0, -sz.Y * 0.1, sz.Z / 2 + 0.02), shellC:Lerp(plas, 0.45)))
			for _, o in { { 0, 0.22 }, { 0, -0.2 }, { -0.28, 0.02 }, { 0.28, 0.02 } } do
				local sx, sy = o[1] * dome.Size.X, o[2] * dome.Size.Y
				local dz = 0.5 * math.sqrt(math.max(0.05, 1 - (2 * sx / dome.Size.X) ^ 2 - (2 * sy / dome.Size.Y) ^ 2))
				oval(piece(m, dome, "Scute", Vector3.new(dome.Size.X * 0.26, dome.Size.Y * 0.24, 0.12), CFrame.new(sx, sy, dz - 0.03), shellC:Lerp(C(0, 0, 0), 0.18)))
			end
			local fz = front(t, 0.05)
			oval(piece(m, t, "Plastron", Vector3.new(sz.X * 0.84, sz.Y * 1.12, sz.Z * 1.0), CFrame.new(0, -sz.Y * 0.04, -sz.Z * 0.09), plas))
			fz = -sz.Z * 0.59
			for j = 0, 3 do piece(m, t, "PlastronLine", Vector3.new(sz.X * (0.62 - math.abs(j - 1.5) * 0.08), 0.04, 0.04), CFrame.new(0, sz.Y * (0.32 - j * 0.24), fz + 0.02 + math.abs(j - 1.5) * 0.02), plas:Lerp(C(0, 0, 0), 0.3)) end
			for _, x in { -1, 1 } do oval(piece(m, t, "Bridge", Vector3.new(0.3, sz.Y * 0.95, sz.Z * 0.95), CFrame.new(x * (sz.X / 2 - 0.08), -sz.Y * 0.08, 0.05), plas:Lerp(shellC, 0.4))) end
			local w = waistOf(m)
			if w and w ~= t then oval(piece(m, w, "PlastronLow", Vector3.new(w.Size.X * 0.62, w.Size.Y * 2.0, w.Size.Z * 0.5), CFrame.new(0, -w.Size.Y * 0.2, -w.Size.Z * 0.3), plas)) end
		end,
		function(m) -- twin scabbards crossed over the shell
			local t = chestOf(m); if not t then return end
			local sz = t.Size
			for _, x in { -1, 1 } do
				local sc = piece(m, t, "Scabbard", Vector3.new(0.2, sz.Y * 1.6, 0.22), CFrame.new(x * sz.X * 0.18, 0.1, sz.Z / 2 + 0.7) * CFrame.Angles(0, 0, math.rad(x * 28)), gear:Lerp(C(0, 0, 0), 0.3))
				piece(m, sc, "Throat", Vector3.new(0.24, 0.12, 0.26), CFrame.new(0, sc.Size.Y / 2, 0), gear)
				piece(m, sc, "Chape", Vector3.new(0.24, 0.12, 0.26), CFrame.new(0, -sc.Size.Y / 2, 0), gear)
			end
			for _, x in { -1, 1 } do -- harness straps over the shoulders onto the plastron
				piece(m, t, "Harness", Vector3.new(sz.X * 0.1, 0.06, sz.Z * 1.3), CFrame.new(x * sz.X * 0.25, sz.Y / 2 + 0.03, 0.1), gear)
				piece(m, t, "HarnessFront", Vector3.new(sz.X * 0.1, sz.Y * 0.5, 0.05), CFrame.new(x * sz.X * 0.25, sz.Y * 0.24, front(t, 0.12)), gear)
			end
		end,
		{ "Belt", gear, { color = gear:Lerp(C(255, 220, 120), 0.4), text = s.Letter, textColor = s.Primary } },
		function(m) each(m, { "LeftLowerLeg", "RightLowerLeg" }, function(a) oval(piece(m, a, "KneePad", Vector3.new(a.Size.X * 0.75, a.Size.Y * 0.38, a.Size.Z * 0.45), CFrame.new(0, a.Size.Y * 0.38, -a.Size.Z * 0.36), gear, Enum.Material.Leather)) end) end,
		function(m) -- elbow pads, wrist + ankle wraps
			each(m, { "LeftLowerArm", "RightLowerArm", "LeftArm", "RightArm" }, function(a)
				local sz = a.Size
				oval(piece(m, a, "ElbowPad", Vector3.new(sz.X * 0.75, sz.Y * 0.36, sz.Z * 0.45), CFrame.new(0, sz.Y * 0.36, sz.Z * 0.36), gear, Enum.Material.Leather))
				for k = 0, 1 do H.band(m, a, "WristWrap", sz.X * (1.02 - k * 0.04), 0.12, CFrame.new(0, -sz.Y * (0.28 + k * 0.13), 0) * CFrame.Angles(0, 0, math.rad(k % 2 == 0 and 7 or -7)), wrap, Enum.Material.Fabric) end
			end)
			each(m, { "LeftLowerLeg", "RightLowerLeg", "LeftLeg", "RightLeg" }, function(a)
				for k = 0, 1 do H.band(m, a, "AnkleWrap", a.Size.X * (0.98 - k * 0.04), 0.12, CFrame.new(0, -a.Size.Y * (0.3 + k * 0.13), 0) * CFrame.Angles(0, 0, math.rad(k % 2 == 0 and -7 or 7)), wrap, Enum.Material.Fabric) end
			end)
		end,
	}
	if s.Tech then -- Fast Forward (2105): tech armor plates on the shoulders and shins
		table.insert(pieces, { "Shoulders", s.Tech })
		table.insert(pieces, function(m)
			each(m, { "LeftLowerLeg", "RightLowerLeg" }, function(a)
				piece(m, a, "ShinPlate", Vector3.new(a.Size.X * 0.8, a.Size.Y * 0.6, 0.1), CFrame.new(0, -a.Size.Y * 0.05, -a.Size.Z / 2 - 0.05), s.Tech, Enum.Material.Metal)
			end)
		end)
	end
	if s.Robe then -- Foot Clan leader: dark sash robe over one shoulder + red Foot crest
		table.insert(pieces, function(m)
			local t = chestOf(m); if not t then return end
			local sz = t.Size
			local diag = math.sqrt(sz.X ^ 2 + sz.Y ^ 2)
			piece(m, t, "Sash", Vector3.new(sz.X * 0.3, diag, 0.06), CFrame.new(0, 0, front(t, 0.14)) * CFrame.Angles(0, 0, math.rad(-35)), s.Robe, Enum.Material.Fabric)
			local c = piece(m, t, "Crest", Vector3.new(sz.X * 0.3, sz.X * 0.3, 0.05), CFrame.new(-sz.X * 0.22, sz.Y * 0.22, front(t, 0.18)), s.Primary); c.Transparency = 1
			glyph(c, Enum.NormalId.Front, "✿", s.Primary)
		end)
	end
	return { colors = { Head = skin, Chest = skin, Waist = skin, Arms = skin, Hands = skin, Legs = skin, Feet = skin }, pieces = pieces }
end
