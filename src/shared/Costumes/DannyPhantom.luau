-- Danny Phantom: black hazmat jumpsuit, white gloves/boots/belt/collar, DP logo, white messy hair, glowing green eyes (bright SmoothPlastic, no Neon).
-- Variants: Danny Fenton (human tee + jeans), Fenton Peeler armor, Dan Phantom (blue skin, flaming hair, cape), Ghost King (crown + cape).
-- Costume module: return function(s, H, rarity) -> { colors = { group = Color3 }, pieces = { { "Piece", args... } | function(m) end } }
-- s = skin variant (Name, Primary = suit, Secondary = trim, Eye, Human, Armor, Dan, King...), H = shared helpers, rarity = tier name
return function(s, H, rarity)
	local C, SKIN, GOLD, WHITE = H.C, H.SKIN, H.GOLD, H.WHITE
	local piece, find, chestOf, waistOf, front, glyph = H.piece, H.find, H.chestOf, H.waistOf, H.front, H.glyph
	local function each(m, names, fn) for _, n in names do local a = m:FindFirstChild(n); if a then fn(a, n:find("Left") and -1 or 1) end end end
	local function oval(p) Instance.new("SpecialMesh", p).MeshType = Enum.MeshType.Sphere; return p end
	local skin = s.Skin or C(240, 200, 170)
	local trim = s.Secondary
	local eye = s.Eye or C(110, 255, 140)

	if s.Human then -- Danny Fenton: white tee with red oval + red trims, blue jeans, black hair, blue eyes, sneakers
		return { colors = { Head = skin, Chest = WHITE, Waist = s.Secondary, UpperArms = WHITE, LowerArms = skin, Hands = skin, Legs = s.Secondary, Feet = C(200, 30, 30) },
			pieces = {
				{ "Face", C(60, 120, 220), C(25, 25, 30), "smirk" },
				{ "Hair", C(25, 25, 30), "Spiky" },
				function(m)
					local t = chestOf(m); if not t then return end
					local sz = t.Size
					oval(piece(m, t, "Oval", Vector3.new(sz.X * 0.36, sz.Y * 0.36, 0.06), CFrame.new(0, sz.Y * 0.1, front(t, 0.02)), s.Primary))
					piece(m, t, "Collar", Vector3.new(sz.X * 0.42, 0.1, sz.Z * 1.04), CFrame.new(0, sz.Y * 0.46, 0), s.Primary)
					each(m, { "LeftUpperArm", "RightUpperArm" }, function(a)
						piece(m, a, "SleeveHem", Vector3.new(a.Size.X * 1.06, 0.1, a.Size.Z * 1.06), CFrame.new(0, -a.Size.Y * 0.1, 0), s.Primary)
					end)
					each(m, { "LeftFoot", "RightFoot" }, function(f)
						piece(m, f, "Sole", Vector3.new(f.Size.X * 1.06, 0.1, f.Size.Z * 1.08), CFrame.new(0, -f.Size.Y / 2 + 0.03, 0), WHITE)
					end)
				end,
			} }
	end

	local pieces = {
		{ "Face", eye, s.Dan and C(235, 245, 255) or WHITE, s.Dan and "angry" or "smirk" },
		function(m) -- ghost eyes: solid glowing green over the whole eye + soft light
			local hd = find(m, "Head"); if not hd then return end
			local sz = hd.Size
			for _, x in { -1, 1 } do
				piece(m, hd, "GhostEye", Vector3.new(sz.X * 0.18, sz.Y * 0.1, 0.03), CFrame.new(x * sz.X * 0.19, sz.Y * 0.06, -sz.Z * 0.505 - 0.02), eye, Enum.Material.SmoothPlastic)
				piece(m, hd, "EyeShine", Vector3.new(sz.X * 0.04, sz.Y * 0.035, 0.03), CFrame.new(x * sz.X * 0.19 - sz.X * 0.04, sz.Y * 0.08, -sz.Z * 0.505 - 0.03), C(240, 255, 245), Enum.Material.SmoothPlastic)
			end
			local l = Instance.new("PointLight"); l.Name = "GhostGlow"; l.Color = eye; l.Range = 8; l.Brightness = 0.8; l.Parent = hd
		end,
		function(m) -- messy white hair with bangs falling over the forehead
			local hd = find(m, "Head"); if not hd then return end
			local sz = hd.Size
			local hair = s.Hair or WHITE
			piece(m, hd, "Hair", Vector3.new(sz.X * 1.08, sz.Y * 0.38, sz.Z * 1.08), CFrame.new(0, sz.Y * 0.38, sz.Z * 0.03), hair)
			piece(m, hd, "HairBack", Vector3.new(sz.X * 1.08, sz.Y * 0.7, sz.Z * 0.3), CFrame.new(0, sz.Y * 0.08, sz.Z * 0.42), hair)
			for i, o in { { -0.32, 10 }, { -0.1, -6 }, { 0.12, 14 }, { 0.32, -10 } } do
				local b = piece(m, hd, "Bang", Vector3.new(sz.X * 0.26, sz.Y * 0.28, sz.Z * 0.16), CFrame.new(o[1] * sz.X, sz.Y * (0.24 - (i % 2) * 0.03), -sz.Z * 0.48) * CFrame.Angles(math.rad(-12), 0, math.rad(o[2])) * CFrame.Angles(0, 0, math.rad(180)), hair)
				Instance.new("SpecialMesh", b).MeshType = Enum.MeshType.Wedge
			end
			for i = -2, 2 do
				piece(m, hd, "Tuft", Vector3.new(0.18, sz.Y * 0.32, 0.18), CFrame.new(i * sz.X * 0.2, sz.Y * 0.58, sz.Z * 0.1) * CFrame.Angles(math.rad(-25), 0, math.rad(-i * 20)), hair)
			end
			if s.Dan then -- Dan Phantom: hair is white-blue ghost fire
				local crown = piece(m, hd, "FlameCrown", Vector3.new(sz.X * 0.7, 0.1, sz.Z * 0.6), CFrame.new(0, sz.Y * 0.55, sz.Z * 0.2), hair, Enum.Material.SmoothPlastic)
				crown.Transparency = 1
				H.hellfire(crown, C(120, 200, 255), C(240, 250, 255), sz.Y * 0.6, 0.9, -1.5)
				piece(m, hd, "Goatee", Vector3.new(sz.X * 0.18, sz.Y * 0.18, 0.06), CFrame.new(0, -sz.Y * 0.43, -sz.Z * 0.52), C(30, 30, 40))
			end
		end,
		function(m) -- hazmat details: white collar, DP logo, glove + boot tops, zipper seam
			local t = chestOf(m); if not t then return end
			local sz = t.Size
			piece(m, t, "Collar", Vector3.new(sz.X * 0.5, 0.22, sz.Z * 1.06), CFrame.new(0, sz.Y / 2 - 0.05, 0), trim)
			local fz = front(t, 0.03)
			piece(m, t, "LogoD", Vector3.new(sz.X * 0.3, sz.Y * 0.4, 0.05), CFrame.new(-sz.X * 0.04, sz.Y * 0.1, fz), trim)
			oval(piece(m, t, "LogoBow", Vector3.new(sz.X * 0.24, sz.Y * 0.4, 0.05), CFrame.new(sz.X * 0.09, sz.Y * 0.1, fz), trim))
			local p = piece(m, t, "LogoP", Vector3.new(sz.X * 0.24, sz.Y * 0.34, 0.03), CFrame.new(sz.X * 0.01, sz.Y * 0.1, fz - 0.04), s.Primary); p.Transparency = 1
			glyph(p, Enum.NormalId.Front, "P", s.Primary)
			piece(m, t, "Seam", Vector3.new(0.03, sz.Y * 0.4, 0.03), CFrame.new(0, -sz.Y * 0.28, fz), s.Primary:Lerp(C(128, 128, 128), 0.3))
			each(m, { "LeftLowerArm", "RightLowerArm", "LeftArm", "RightArm" }, function(a)
				piece(m, a, "GloveCuff", Vector3.new(a.Size.X * 1.12, a.Size.Y * 0.32, a.Size.Z * 1.12), CFrame.new(0, -a.Size.Y * 0.35, 0), trim)
			end)
			each(m, { "LeftLowerLeg", "RightLowerLeg", "LeftLeg", "RightLeg" }, function(a)
				piece(m, a, "Boot", Vector3.new(a.Size.X * 1.1, a.Size.Y * 0.55, a.Size.Z * 1.1), CFrame.new(0, -a.Size.Y * 0.24, 0), trim)
				piece(m, a, "BootTop", Vector3.new(a.Size.X * 1.14, 0.08, a.Size.Z * 1.14), CFrame.new(0, a.Size.Y * 0.04, 0), trim:Lerp(C(0, 0, 0), 0.12))
			end)
			-- faint ectoplasm drifting off the body
			local pe = Instance.new("ParticleEmitter"); pe.Name = "Ecto"; pe.Color = ColorSequence.new(eye); pe.LightEmission = 0.6
			pe.Size = NumberSequence.new(0.3, 0); pe.Transparency = NumberSequence.new(0.5, 1); pe.Rate = 6
			pe.Lifetime = NumberRange.new(0.6, 1); pe.Speed = NumberRange.new(0.5, 1.5); pe.SpreadAngle = Vector2.new(180, 180); pe.Parent = t
		end,
		{ "Belt", trim, { color = trim } },
	}
	if s.Armor then -- Fenton Ghost Peeler: bulky gray armor plates with green lights
		table.insert(pieces, { "Shoulders", s.Armor })
		table.insert(pieces, function(m)
			local t = chestOf(m); if not t then return end
			piece(m, t, "Peeler", Vector3.new(t.Size.X * 1.12, t.Size.Y * 0.6, t.Size.Z * 1.25), CFrame.new(0, -t.Size.Y * 0.12, 0), s.Armor, Enum.Material.Metal)
			for _, x in { -1, 1 } do piece(m, t, "Light", Vector3.new(0.16, 0.16, 0.05), CFrame.new(x * t.Size.X * 0.3, -t.Size.Y * 0.1, -t.Size.Z * 0.65), C(110, 255, 140), Enum.Material.Neon) end
			each(m, { "LeftLowerArm", "RightLowerArm", "LeftLowerLeg", "RightLowerLeg" }, function(a)
				piece(m, a, "Plate", Vector3.new(a.Size.X * 1.15, a.Size.Y * 0.5, a.Size.Z * 1.15), CFrame.new(0, a.Size.Y * 0.15, 0), s.Armor, Enum.Material.Metal)
			end)
		end)
	end
	if s.Dan or s.King then -- high-collared cape
		table.insert(pieces, { "Cape", s.Dan and C(20, 20, 25) or C(30, 70, 50), s.Dan and C(150, 25, 30) or C(200, 170, 70) })
		table.insert(pieces, function(m)
			local t = chestOf(m); if not t then return end
			for _, x in { -1, 1 } do
				piece(m, t, "HighCollar", Vector3.new(t.Size.X * 0.3, t.Size.Y * 0.55, 0.08), CFrame.new(x * t.Size.X * 0.38, t.Size.Y * 0.68, t.Size.Z * 0.2) * CFrame.Angles(math.rad(-10), math.rad(x * 30), 0), s.Dan and C(20, 20, 25) or C(30, 70, 50), Enum.Material.Fabric)
			end
		end)
	end
	if s.King then -- Ghost King: Crown of Fire + Ring of Rage
		table.insert(pieces, function(m)
			local hd = find(m, "Head")
			if hd then
				local sz = hd.Size
				piece(m, hd, "Crown", Vector3.new(sz.X * 1.1, sz.Y * 0.18, sz.Z * 1.1), CFrame.new(0, sz.Y * 0.58, 0), C(200, 200, 215), Enum.Material.Metal)
				for i = -2, 2 do piece(m, hd, "CrownSpike", Vector3.new(0.14, sz.Y * (0.38 - math.abs(i) * 0.06), 0.14), CFrame.new(i * sz.X * 0.22, sz.Y * 0.8, -sz.Z * 0.3), C(200, 200, 215), Enum.Material.Metal) end
				local fl = piece(m, hd, "CrownFire", Vector3.new(sz.X * 0.8, 0.1, sz.Z * 0.6), CFrame.new(0, sz.Y * 0.75, 0), WHITE); fl.Transparency = 1
				H.hellfire(fl, C(80, 255, 140), C(220, 255, 230), sz.Y * 0.45, 0.6, -1.5)
			end
			local h = m:FindFirstChild("LeftHand")
			if h then piece(m, h, "Ring", Vector3.new(h.Size.X * 1.1, 0.12, h.Size.Z * 1.1), CFrame.new(0, -h.Size.Y * 0.2, 0), C(110, 255, 140), Enum.Material.Neon) end
		end)
	end
	return { colors = { Head = skin, Chest = s.Primary, Waist = s.Primary, Arms = s.Primary, Hands = trim, Legs = s.Primary, Feet = trim }, pieces = pieces }
end
