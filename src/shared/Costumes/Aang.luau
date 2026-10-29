-- Aang (Avatar: The Last Airbender, Book 1 design): 12-year-old proportions, round bald head with big gray eyes, big ears and a wide grin;
-- the light-blue airbender arrow (arrowhead on the forehead, stripe over the crown and down the back of the head) plus arrows down the
-- forearms onto the backs of the hands; yellow shirt + loose yellow pants, orange mantle with a standing collar, short orange back cape and
-- a diagonal orange drape across the chest, sash belt, off-white leg wraps, brown shoes.
-- Costume module: return function(s, H, rarity) -> { colors = { group = Color3 }, pieces = { { "Piece", args... } | function(m) end } }
-- s = skin variant (Name, Primary = shirt/pants, Secondary = shawl, Headband, Hair, Glow, Goatee, Ghost, Pants...), H = shared helpers, rarity = tier name
return function(s, H, rarity)
	local C = H.C
	local piece, round, band, find, chestOf, waistOf = H.piece, H.round, H.band, H.find, H.chestOf, H.waistOf
	local function each(m, names, fn) for _, n in names do local a = m:FindFirstChild(n); if a then fn(a, n:find("Left") and -1 or 1) end end end
	local V, CF = Vector3.new, CFrame.new
	local FAB = Enum.Material.Fabric
	local skin = s.Ghost and C(190, 225, 245) or C(245, 205, 165)
	local ink = s.Glow and C(225, 248, 255) or C(70, 150, 230)
	local pants = s.Pants or s.Primary
	local sh = s.Secondary
	local shDark = sh:Lerp(C(0, 0, 0), 0.22)
	local BLACK = C(25, 25, 30)

	local function eband(m, a, name, dx, dz, h, cf, color, mat)
		local p = piece(m, a, name, V(h, dx, dz), cf * CFrame.Angles(0, 0, math.rad(90)), color, mat)
		local sm = Instance.new("SpecialMesh"); sm.MeshType = Enum.MeshType.Cylinder; sm.Parent = p
		return p
	end
	-- flat isosceles triangle pointing down (-Y) in the given frame, built from two mirrored wedges
	local function arrowhead(m, a, name, frame, w, h, t, color)
		for _, x in { -1, 1 } do
			local p = piece(m, a, name, V(t, h, w / 2), frame * CF(x * w / 4, 0, 0) * CFrame.fromMatrix(Vector3.zero, V(0, 0, -x), V(0, -1, 0)), color, Enum.Material.SmoothPlastic)
			Instance.new("SpecialMesh", p).MeshType = Enum.MeshType.Wedge
		end
	end

	local pieces = {}
	table.insert(pieces, function(m) -- head: round bald skull, face, arrow
		local hd = find(m, "Head"); if not hd then return end
		hd.Transparency = 1
		local s0 = hd.Size
		local X, Y, Z = s0.X * 1.0, s0.Y * 1.06, s0.Z * 1.04
		local shell = round(m, hd, "Skull", V(X, Y, Z), CF(0, s0.Y * 0.02, 0), skin)
		local function at(x, y, out)
			local a, b, c = X / 2, Y / 2, Z / 2
			local z = -c * math.sqrt(math.max(0.02, 1 - (x / a) ^ 2 - (y / b) ^ 2))
			local pos = V(x, y, z)
			local n = V(x / (a * a), y / (b * b), z / (c * c)).Unit
			return CFrame.lookAt(pos, pos + n) * CF(0, 0, -(out or 0))
		end
		local dark = skin:Lerp(C(0, 0, 0), 0.5)
		-- face
		for _, x in { -1, 1 } do
			local ex, ey = x * X * 0.19, -Y * 0.04
			if s.Glow then
				round(m, shell, "GlowEye", V(X * 0.2, Y * 0.13, 0.08), at(ex, ey, -0.01), C(235, 250, 255), Enum.Material.SmoothPlastic)
			else
				round(m, shell, "Sclera", V(X * 0.2, Y * 0.17, 0.08), at(ex, ey, -0.01), C(252, 252, 252))
				round(m, shell, "Iris", V(X * 0.12, Y * 0.14, 0.08), at(ex - x * X * 0.015, ey - Y * 0.01, 0.0), C(120, 120, 135))
				round(m, shell, "Pupil", V(X * 0.06, Y * 0.08, 0.08), at(ex - x * X * 0.015, ey - Y * 0.01, 0.012), BLACK)
			end
			piece(m, shell, "Lid", V(X * 0.2, 0.04, 0.04), at(ex, ey + Y * 0.08, 0.01) * CFrame.Angles(0, 0, math.rad(x * (s.Glow and 14 or -4))), BLACK)
			piece(m, shell, "Brow", V(X * 0.16, 0.04, 0.04), at(ex, ey + Y * 0.16, 0.01) * CFrame.Angles(0, 0, math.rad(x * (s.Glow and 18 or -6))), dark)
			round(m, shell, "Ear", V(X * 0.12, Y * 0.3, Z * 0.22), CF(x * X * 0.5, -Y * 0.04, Z * 0.02) * CFrame.Angles(0, math.rad(-x * 15), 0), skin)
		end
		round(m, shell, "Nose", V(X * 0.09, Y * 0.09, 0.12), at(0, -Y * 0.15, 0.0), skin:Lerp(C(0, 0, 0), 0.05))
		local mcf = at(0, -Y * 0.29, 0.0)
		if s.Glow then
			piece(m, shell, "Mouth", V(X * 0.24, 0.05, 0.04), mcf, dark)
		else -- wide grin (dark crescent masked by a skin oval)
			round(m, shell, "Mouth", V(X * 0.34, Y * 0.13, 0.06), mcf, C(110, 40, 40))
			round(m, shell, "MouthMask", V(X * 0.38, Y * 0.1, 0.06), mcf * CF(0, Y * 0.05, -0.01), skin)
			piece(m, shell, "Teeth", V(X * 0.22, Y * 0.025, 0.04), mcf * CF(0, Y * 0.0, -0.015), C(250, 250, 245))
		end
		-- the arrow: a slice of the skull shifted up/back shows on the forehead, crown and back of the head
		if not s.Hair and not s.Headband then
			round(m, shell, "ArrowStripe", V(X * 0.15, Y * 1.0, Z * 1.0), CF(0, Y * 0.03, Z * 0.03), ink, Enum.Material.SmoothPlastic)
		end
		if not s.Headband and not s.Hair then
			arrowhead(m, shell, "ArrowHead", at(0, Y * 0.21, 0.03), X * 0.3, Y * 0.2, 0.06, ink)
		end
		if s.Hair then -- Book 3: short dark hair grown in, widow's peak over the arrowhead
			round(m, shell, "Hair", V(X * 1.04, Y * 1.0, Z * 1.04), CF(0, Y * 0.1, Z * 0.06), C(40, 30, 25))
		end
		if s.Headband then -- Fire Nation school disguise: red headband hides the arrow, knot tails behind
			eband(m, shell, "Headband", X * 0.99, Z * 1.02, Y * 0.14, CF(0, Y * 0.16, 0), C(170, 30, 30), FAB)
			for _, a in { -14, 14 } do round(m, shell, "BandTail", V(0.12, Y * 0.5, 0.06), CF(a * 0.006, -Y * 0.05, Z * 0.52) * CFrame.Angles(0, 0, math.rad(a)), C(170, 30, 30), FAB) end
		end
		if s.Goatee then -- Legend of Korra era: goatee + moustache
			round(m, shell, "Goatee", V(X * 0.18, Y * 0.22, 0.12), at(0, -Y * 0.42, 0.0), C(60, 45, 35))
			for _, x in { -1, 1 } do piece(m, shell, "Moustache", V(X * 0.2, 0.05, 0.05), at(x * X * 0.1, -Y * 0.22, 0.01) * CFrame.Angles(0, 0, math.rad(x * -18)), C(60, 45, 35)) end
		end
		if s.Glow then
			local l = Instance.new("PointLight"); l.Color = C(180, 230, 255); l.Range = 10; l.Brightness = 1.5; l.Parent = hd
		end
	end)
	table.insert(pieces, function(m) -- forearm stripes + arrowheads on the backs of the hands
		each(m, { "LeftLowerArm", "RightLowerArm" }, function(a, side)
			local sz = a.Size
			round(m, a, "ArmArrow", V(sz.X * 0.3, sz.Y * 1.1, sz.Z * 0.3), CF(side * sz.X * 0.36, -sz.Y * 0.05, 0), ink, Enum.Material.SmoothPlastic)
		end)
		each(m, { "LeftHand", "RightHand" }, function(h, side)
			local sz = h.Size
			local fr = CF(side * sz.X * 0.42, -sz.Y * 0.6, 0) * CFrame.Angles(0, math.rad(-side * 90), 0)
			arrowhead(m, h, "HandArrow", fr, sz.Z * 0.6, sz.Y * 1.0, 0.03, ink)
		end)
	end)
	table.insert(pieces, function(m) -- orange mantle with standing collar, short back cape, diagonal drape, sash belt
		local t = chestOf(m); if not t then return end
		local sz = t.Size
		round(m, t, "Mantle", V(sz.X * 1.12, sz.Y * 0.6, sz.Z * 1.14), CF(0, sz.Y * 0.36, sz.Z * 0.08), sh, FAB)
		eband(m, t, "Collar", sz.X * 0.42, sz.Z * 0.75, sz.Y * 0.22, CF(0, sz.Y * 0.62, 0.0), sh, FAB)
		eband(m, t, "CollarLip", sz.X * 0.44, sz.Z * 0.77, 0.05, CF(0, sz.Y * 0.73, 0.0), shDark, FAB)
		local capeLen = s.Goatee and 2.6 or 1.1
		-- back cape: the chest ellipsoid shifted back, so it only shows over the back and shoulders
		round(m, t, "BackCape", V(sz.X * 1.01, sz.Y * 0.98, sz.Z * 1.0), CF(0, sz.Y * 0.1, sz.Z * 0.07), sh, FAB)
		if s.Goatee then -- adult Aang: long cape to the calves
			round(m, t, "LongCape", V(sz.X * 1.05, sz.Y * capeLen, sz.Z * 0.2), CF(0, sz.Y * (0.45 - capeLen / 2), sz.Z * 0.5) * CFrame.Angles(math.rad(-5), 0, 0), sh, FAB)
		end
		-- drape: narrow slice of the chest ellipsoid, rolled from the right shoulder down to the left hip
		local ang = math.atan2(sz.X * 0.8, sz.Y * 0.9)
		round(m, t, "Drape", V(sz.X * 0.26, math.sqrt((sz.X * 0.9) ^ 2 + (sz.Y * 0.95) ^ 2), sz.Z * 1.08), CF(0, sz.Y * 0.02, 0) * CFrame.Angles(0, 0, -ang), sh, FAB)
		local w = waistOf(m)
		if w then
			eband(m, w, "Sash", w.Size.X * 1.0, w.Size.Z * 1.06, w.Size.Y * 0.8, CF(0, w.Size.Y * 0.25, 0), sh:Lerp(C(255, 220, 120), 0.3), FAB)
			round(m, w, "SashKnot", V(w.Size.X * 0.16, w.Size.Y * 0.8, 0.14), CF(w.Size.X * 0.2, w.Size.Y * 0.1, -w.Size.Z * 0.55), sh:Lerp(C(255, 220, 120), 0.2), FAB)
		end
	end)
	table.insert(pieces, function(m) -- loose sleeve cuffs, baggy pants, leg wraps
		each(m, { "LeftLowerArm", "RightLowerArm" }, function(a)
			band(m, a, "SleeveCuff", a.Size.X * 1.35, a.Size.Y * 0.35, CF(0, a.Size.Y * 0.36, 0), s.Primary, FAB)
		end)
		each(m, { "LeftUpperLeg", "RightUpperLeg" }, function(a)
			round(m, a, "Baggy", V(a.Size.X * 1.25, a.Size.Y * 1.25, a.Size.Z * 1.25), CF(0, -a.Size.Y * 0.05, 0), pants, FAB)
		end)
		each(m, { "LeftLowerLeg", "RightLowerLeg" }, function(a)
			round(m, a, "BaggyLow", V(a.Size.X * 1.2, a.Size.Y * 0.7, a.Size.Z * 1.2), CF(0, a.Size.Y * 0.2, 0), pants, FAB)
			band(m, a, "Wrap", a.Size.X * 1.05, a.Size.Y * 0.5, CF(0, -a.Size.Y * 0.25, 0), C(225, 210, 175), FAB)
			for k = 0, 2 do band(m, a, "WrapLine", a.Size.X * 1.07, 0.03, CF(0, -a.Size.Y * (0.08 + k * 0.13), 0) * CFrame.Angles(math.rad(k % 2 == 0 and 8 or -8), 0, 0), C(180, 160, 120), FAB) end
		end)
	end)
	if s.Ghost then -- must run last: everything (and the sculpted body, which copies transparency) turns see-through
		table.insert(pieces, function(m)
			for _, p in m:GetDescendants() do if p:IsA("BasePart") and p.Name ~= "HumanoidRootPart" then p.Transparency = math.max(p.Transparency, 0.3) end end
		end)
	end
	return { colors = { Head = skin, Chest = s.Primary, Waist = pants, UpperArms = s.Primary, LowerArms = skin, Hands = skin, Legs = pants, Feet = C(110, 70, 40) },
		pieces = pieces }
end
