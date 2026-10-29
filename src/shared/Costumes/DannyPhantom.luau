-- Danny Phantom: slim teen in a black hazmat jumpsuit, white gloves to mid-forearm, white boots to mid-calf, white belt + collar,
-- DP logo (white D with a black P inside), messy white hair with bangs, glowing green eyes (bright SmoothPlastic, no Neon).
-- Variants: Danny Fenton (white tee with red oval, jeans, black hair), Fenton Ghost Peeler armor, Phantom Planet, Dan Phantom
-- (blue skin, white ghost-fire hair, goatee, fangs, black/red high-collared cape), Ghost King (fire crown, Ring of Rage, cape).
-- Costume module: return function(s, H, rarity) -> { colors = { group = Color3 }, pieces = { ... } }
-- s = skin variant (Primary = suit, Secondary = trim, Eye, Human, Armor, Dan, King, Skin, Hair)
return function(s, H, rarity)
	local C, WHITE = H.C, H.WHITE
	local piece, round, band, ring, find, chestOf, waistOf, front, glyph = H.piece, H.round, H.band, H.ring, H.find, H.chestOf, H.waistOf, H.front, H.glyph
	local V, CF, rad = Vector3.new, CFrame.new, math.rad
	local function each(m, names, fn) for _, n in names do local a = m:FindFirstChild(n); if a then fn(a, n:find("Left") and -1 or 1) end end end
	local skin = s.Skin or C(240, 200, 170)
	local trim = s.Secondary
	local eye = s.Eye or C(110, 255, 140)

	local function face(m, iris, glow, mouth)
		local hd = find(m, "Head"); if not hd then return end
		local sz = hd.Size
		local fz = -sz.Z * 0.5
		for _, x in { -1, 1 } do
			local ex = x * sz.X * 0.19
			if glow then -- solid glowing eyes
				round(m, hd, "GhostEye", V(sz.X * 0.19, sz.Y * 0.12, 0.05), CF(ex, sz.Y * 0.06, fz - 0.01) * CFrame.Angles(0, 0, rad(x * (mouth == "angry" and 12 or -5))), iris, Enum.Material.SmoothPlastic)
				round(m, hd, "EyeShine", V(sz.X * 0.05, sz.Y * 0.04, 0.03), CF(ex - sz.X * 0.04, sz.Y * 0.08, fz - 0.04), C(240, 255, 245), Enum.Material.SmoothPlastic)
			else
				round(m, hd, "Sclera", V(sz.X * 0.17, sz.Y * 0.11, 0.05), CF(ex, sz.Y * 0.06, fz - 0.01), C(252, 252, 250))
				round(m, hd, "Iris", V(sz.X * 0.08, sz.Y * 0.1, 0.04), CF(ex - x * sz.X * 0.01, sz.Y * 0.06, fz - 0.03), iris)
			end
			piece(m, hd, "Brow", V(sz.X * 0.2, sz.Y * 0.045, 0.04), CF(ex, sz.Y * 0.18, fz - 0.01) * CFrame.Angles(0, 0, rad(mouth == "angry" and x * 20 or x * -6)), s.Brow or C(60, 60, 70))
			round(m, hd, "Ear", V(0.1, sz.Y * 0.26, sz.Z * 0.2), CF(x * sz.X * 0.5, sz.Y * 0.02, 0.02), skin)
		end
		round(m, hd, "Nose", V(sz.X * 0.09, sz.Y * 0.1, 0.07), CF(0, -sz.Y * 0.08, fz - 0.025), skin:Lerp(C(0, 0, 0), 0.07))
		piece(m, hd, "Mouth", V(sz.X * 0.24, sz.Y * 0.035, 0.04), CF(sz.X * 0.03, -sz.Y * 0.26, fz - 0.005) * CFrame.Angles(0, 0, rad(mouth == "angry" and 0 or 8)), skin:Lerp(C(0, 0, 0), 0.5))
		if mouth == "angry" then -- Dan: fangs + goatee
			for _, x in { -1, 1 } do piece(m, hd, "Fang", V(0.05, 0.1, 0.03), CF(x * sz.X * 0.07, -sz.Y * 0.3, fz - 0.02), WHITE) end
			round(m, hd, "Goatee", V(sz.X * 0.2, sz.Y * 0.2, 0.08), CF(0, -sz.Y * 0.43, fz + 0.02), C(30, 30, 40))
		end
	end
	local function hair(m, color)
		local hd = find(m, "Head"); if not hd then return end
		local sz = hd.Size
		round(m, hd, "Hair", V(sz.X * 1.1, sz.Y * 0.66, sz.Z * 1.12), CF(0, sz.Y * 0.3, sz.Z * 0.06), color)
		round(m, hd, "HairBack", V(sz.X * 1.04, sz.Y * 0.8, sz.Z * 0.45), CF(0, sz.Y * 0.04, sz.Z * 0.36), color)
		-- messy bangs falling over the forehead, swept to his left
		for _, b in { { -0.3, 0.26, 18 }, { -0.08, 0.22, 8 }, { 0.14, 0.24, -6 }, { 0.34, 0.27, -20 } } do
			round(m, hd, "Bang", V(sz.X * 0.28, sz.Y * 0.4, sz.Z * 0.2), CF(b[1] * sz.X, sz.Y * b[2], -sz.Z * 0.42) * CFrame.Angles(rad(-15), 0, rad(b[3])), color)
		end
		for _, x in { -1, 1 } do round(m, hd, "SideTuft", V(sz.X * 0.2, sz.Y * 0.45, sz.Z * 0.5), CF(x * sz.X * 0.48, sz.Y * 0.12, sz.Z * 0.02) * CFrame.Angles(0, 0, rad(x * 12)), color) end
		for i = -1, 1 do -- spiky crown tufts
			round(m, hd, "Tuft", V(sz.X * 0.2, sz.Y * 0.38, sz.Z * 0.2), CF(i * sz.X * 0.22, sz.Y * 0.62, sz.Z * 0.12) * CFrame.Angles(rad(-30), 0, rad(-i * 25)), color)
		end
	end

	if s.Human then -- Danny Fenton: white tee with red oval + red trims, blue jeans, black hair, blue eyes, red sneakers
		return { colors = { Head = skin, Chest = WHITE, Waist = trim, UpperArms = WHITE, LowerArms = skin, Hands = skin, Legs = trim, Feet = C(200, 30, 30) },
			pieces = {
				function(m) face(m, C(60, 120, 220), false) end,
				function(m) hair(m, C(25, 25, 30)) end,
				function(m)
					local t = chestOf(m); if not t then return end
					local sz = t.Size
					round(m, t, "Oval", V(sz.X * 0.36, sz.Y * 0.38, 0.08), CF(0, sz.Y * 0.08, front(t, 0.02)), s.Primary)
					ring(m, t, "Collar", sz.X * 0.2, sz.Z * 0.32, 0.1, 0.06, CF(0, sz.Y * 0.47, 0), s.Primary, nil, 10)
					each(m, { "LeftUpperArm", "RightUpperArm" }, function(a) band(m, a, "SleeveHem", a.Size.X * 1.1, 0.12, CF(0, -a.Size.Y * 0.12, 0), s.Primary) end)
					each(m, { "LeftFoot", "RightFoot" }, function(f) piece(m, f, "Sole", V(f.Size.X * 0.92, 0.1, f.Size.Z * 1.12), CF(0, -f.Size.Y / 2 + 0.03, -0.02), WHITE) end)
					local w = waistOf(m)
					if w then band(m, w, "JeanBelt", w.Size.X * 0.98, 0.1, CF(0, w.Size.Y * 0.35, 0), C(60, 40, 30)) end
				end,
			} }
	end

	local pieces = {
		function(m) face(m, eye, true, s.Dan and "angry" or nil) end,
		function(m)
			hair(m, s.Hair or WHITE)
			if s.Dan then -- Dan Phantom: hair is white-blue ghost fire
				local hd = find(m, "Head"); if not hd then return end
				local sz = hd.Size
				local crown = piece(m, hd, "FlameCrown", V(sz.X * 0.7, 0.1, sz.Z * 0.6), CF(0, sz.Y * 0.6, sz.Z * 0.2), WHITE)
				crown.Transparency = 1
				H.hellfire(crown, C(120, 200, 255), C(240, 250, 255), sz.Y * 0.6, 0.9, -1.5)
			end
		end,
		function(m) -- hazmat details: rounded collar, DP logo, gloves and boots to mid-limb, zipper seam
			local t = chestOf(m); if not t then return end
			local sz = t.Size
			ring(m, t, "Collar", sz.X * 0.22, sz.Z * 0.36, 0.18, 0.08, CF(0, sz.Y * 0.47, 0), trim, nil, 10)
			local fz = front(t, 0.02)
			local y = sz.Y * 0.12
			local h = sz.Y * 0.44
			-- D: flat back on his right (viewer's left), round bowl to the other side
			piece(m, t, "LogoD", V(sz.X * 0.16, h, 0.05), CF(sz.X * 0.1, y, fz), trim)
			round(m, t, "LogoBowl", V(sz.X * 0.36, h, 0.06), CF(-sz.X * 0.02, y, fz), trim)
			-- P cut into it in the suit color: stem + bowl with a white hole
			piece(m, t, "LogoPStem", V(sz.X * 0.05, h * 0.74, 0.05), CF(sz.X * 0.07, y - h * 0.06, fz - 0.04), s.Primary)
			round(m, t, "LogoPBowl", V(sz.X * 0.15, h * 0.4, 0.05), CF(-sz.X * 0.02, y + h * 0.12, fz - 0.04), s.Primary)
			round(m, t, "LogoPHole", V(sz.X * 0.07, h * 0.18, 0.05), CF(-sz.X * 0.02, y + h * 0.12, fz - 0.06), trim)
			piece(m, t, "Seam", V(0.03, sz.Y * 0.36, 0.03), CF(0, -sz.Y * 0.3, fz), s.Primary:Lerp(C(128, 128, 128), 0.35))
			each(m, { "LeftLowerArm", "RightLowerArm" }, function(a)
				round(m, a, "Glove", V(a.Size.X * 1.1, a.Size.Y * 0.75, a.Size.Z * 1.1), CF(0, -a.Size.Y * 0.2, 0), trim)
			end)
			each(m, { "LeftLowerLeg", "RightLowerLeg" }, function(a)
				round(m, a, "Boot", V(a.Size.X * 1.1, a.Size.Y * 0.95, a.Size.Z * 1.12), CF(0, -a.Size.Y * 0.22, 0), trim)
			end)
			local w = waistOf(m)
			if w and w ~= t then ring(m, w, "Belt", w.Size.X * 0.52, w.Size.Z * 0.56, 0.24, 0.08, CF(0, w.Size.Y * 0.2, 0), trim, nil, 12) end
			-- faint ectoplasm drifting off the body
			local pe = Instance.new("ParticleEmitter"); pe.Name = "Ecto"; pe.Color = ColorSequence.new(eye); pe.LightEmission = 0.6
			pe.Size = NumberSequence.new(0.3, 0); pe.Transparency = NumberSequence.new(0.5, 1); pe.Rate = 6
			pe.Lifetime = NumberRange.new(0.6, 1); pe.Speed = NumberRange.new(0.5, 1.5); pe.SpreadAngle = Vector2.new(180, 180); pe.Parent = t
			local hd = find(m, "Head")
			if hd then local l = Instance.new("PointLight"); l.Name = "GhostGlow"; l.Color = eye; l.Range = 8; l.Brightness = 0.8; l.Parent = hd end
		end,
	}
	if s.Armor then -- Fenton Ghost Peeler: bulky gray armor shell with green power lights
		table.insert(pieces, function(m)
			local t = chestOf(m); if not t then return end
			local sz = t.Size
			round(m, t, "Peeler", V(sz.X * 1.15, sz.Y * 1.05, sz.Z * 1.35), CF(0, -sz.Y * 0.02, 0.02), s.Armor, Enum.Material.Metal)
			piece(m, t, "PeelerBand", V(sz.X * 0.9, 0.12, 0.08), CF(0, -sz.Y * 0.2, -sz.Z * 0.68), s.Armor:Lerp(C(0, 0, 0), 0.35), Enum.Material.Metal)
			for _, x in { -1, 1 } do round(m, t, "Light", V(0.2, 0.2, 0.08), CF(x * sz.X * 0.26, sz.Y * 0.12, -sz.Z * 0.66), C(110, 255, 140), Enum.Material.Neon) end
			each(m, { "LeftUpperArm", "RightUpperArm" }, function(a, x)
				round(m, a, "Pad", V(a.Size.X * 1.6, a.Size.Y * 0.7, a.Size.Z * 1.5), CF(x * a.Size.X * 0.1, a.Size.Y * 0.38, 0), s.Armor, Enum.Material.Metal)
			end)
			each(m, { "LeftLowerArm", "RightLowerArm", "LeftLowerLeg", "RightLowerLeg" }, function(a)
				round(m, a, "Plate", V(a.Size.X * 1.25, a.Size.Y * 0.6, a.Size.Z * 1.25), CF(0, a.Size.Y * 0.18, 0), s.Armor, Enum.Material.Metal)
			end)
		end)
	end
	if s.Dan or s.King then -- high-collared cape (curved drape)
		local outer = s.Dan and C(20, 20, 25) or C(30, 70, 50)
		local inner = s.Dan and C(150, 25, 30) or C(200, 170, 70)
		table.insert(pieces, function(m)
			local t = chestOf(m); if not t then return end
			local sz = t.Size
			local L = sz.Y * 2.5
			for i = -2, 2 do
				local a = rad(i * 22)
				local c = piece(m, t, "Cape", V(sz.X * 0.27, L, 0.07), CF(math.sin(a) * sz.X * 0.6, sz.Y * 0.45 - L / 2, math.cos(a) * sz.Z * 0.64) * CFrame.Angles(0, a, 0) * CFrame.Angles(rad(7), 0, 0), outer, Enum.Material.Fabric)
				piece(m, c, "CapeInner", V(sz.X * 0.27, L * 0.98, 0.03), CF(0, 0, -0.05), inner, Enum.Material.Fabric)
			end
			for _, x in { -1, 1 } do
				piece(m, t, "HighCollar", V(sz.X * 0.3, sz.Y * 0.55, 0.08), CF(x * sz.X * 0.36, sz.Y * 0.68, sz.Z * 0.2) * CFrame.Angles(rad(-10), rad(x * 30), 0), inner, Enum.Material.Fabric)
			end
		end)
	end
	if s.King then -- Ghost King: Crown of Fire + Ring of Rage
		table.insert(pieces, function(m)
			local hd = find(m, "Head")
			if hd then
				local sz = hd.Size
				band(m, hd, "Crown", sz.X * 1.08, sz.Y * 0.16, CF(0, sz.Y * 0.56, sz.Z * 0.04), C(200, 200, 215), Enum.Material.Metal)
				for i = -2, 2 do
					round(m, hd, "CrownSpike", V(0.14, sz.Y * (0.45 - math.abs(i) * 0.07), 0.14), CF(i * sz.X * 0.22, sz.Y * 0.74, -sz.Z * 0.36 + math.abs(i) * sz.Z * 0.08), C(200, 200, 215), Enum.Material.Metal)
				end
				local fl = piece(m, hd, "CrownFire", V(sz.X * 0.8, 0.1, sz.Z * 0.6), CF(0, sz.Y * 0.75, 0), WHITE); fl.Transparency = 1
				H.hellfire(fl, C(80, 255, 140), C(220, 255, 230), sz.Y * 0.45, 0.6, -1.5)
			end
			local h = m:FindFirstChild("LeftHand")
			if h then band(m, h, "Ring", h.Size.X * 0.9, 0.12, CF(0, -h.Size.Y * 0.6, 0), C(110, 255, 140), Enum.Material.Neon) end
		end)
	end
	return { colors = { Head = skin, Chest = s.Primary, Waist = s.Primary, Arms = s.Primary, Hands = trim, Legs = s.Primary, Feet = trim }, pieces = pieces }
end
