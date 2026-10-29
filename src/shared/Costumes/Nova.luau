-- Nova (Richard Rider): gold Nova Corps helmet (dome, three raised fins converging to the brow, nose guard, cheek guards,
-- dark visor with white lenses, open jaw), dark blue suit with three white stars across the chest, gold shoulder caps,
-- gold belt with a round buckle, gold flared gloves and boots.
-- Variants: Sam Alexander (black + gold), Richard Rider (Annihilation starburst), Nova Prime (cape), Human Rocket, Nova Force.
-- Costume module: return function(s, H, rarity) -> { colors = { group = Color3 }, pieces = { { "Piece", args... } | function(m) end } }
return function(s, H, rarity)
	local C, SKIN, WHITE = H.C, H.SKIN, H.WHITE
	local piece, round, find, glyph = H.piece, H.round, H.find, H.glyph
	local V, CF, A, rad = Vector3.new, CFrame.new, CFrame.Angles, math.rad
	local METAL = Enum.Material.Metal
	local function mesh(p, kind) local sm = Instance.new("SpecialMesh"); sm.MeshType = kind; sm.Parent = p; return p end
	local function ecyl(m, a, name, w, h, d, cf, color, mat)
		return mesh(piece(m, a, name, V(h, w, d), cf * A(0, 0, rad(90)), color, mat), Enum.MeshType.Cylinder)
	end
	local SUIT, GOLDC = s.Primary, s.Secondary
	local VISOR = C(22, 24, 34)
	local burst = rarity == "Epic" or rarity == "Mythic"
	local cape = rarity == "Legendary"
	local glow = rarity == "Secret"

	-- flat n-pointed star on a front face: each point is a wedge pair (isosceles triangle) radiating from the center
	local function star(m, a, cf, r, n, color, mat)
		for i = 0, n - 1 do
			local spoke = cf * A(0, 0, -i * 2 * math.pi / n) * CF(0, r * 0.5, 0) * A(0, rad(90), 0)
			for _, k in { 0, 180 } do
				mesh(piece(m, a, "StarPoint", V(0.04, r, r * 0.42), spoke * A(0, rad(k), 0) * CF(0, 0, -r * 0.105), color, mat), Enum.MeshType.Wedge)
			end
		end
	end
	local function helmet(m)
		local hd = find(m, "Head"); if not hd then return end
		local s3 = hd.Size
		local hx, hy, hz = s3.X, s3.Y, s3.Z
		round(m, hd, "Helmet", V(hx * 1.16, hy * 0.92, hz * 1.16), CF(0, hy * 0.16, 0.01), GOLDC, METAL)
		round(m, hd, "HelmetBack", V(hx * 1.12, hy * 1.0, hz * 0.72), CF(0, -hy * 0.04, hz * 0.2), GOLDC, METAL)
		for _, x in { -1, 1 } do
			round(m, hd, "CheekGuard", V(hx * 0.24, hy * 0.66, hz * 0.8), CF(x * hx * 0.44, -hy * 0.14, hz * 0.02), GOLDC, METAL)
			-- side fins: run front to back, angled outward
			round(m, hd, "SideFin", V(hx * 0.09, hy * 0.28, hz * 1.04), CF(x * hx * 0.3, hy * 0.52, hz * 0.04) * A(0, rad(-x * 6), rad(-x * 22)), GOLDC:Lerp(C(255, 255, 255), 0.12), METAL)
			piece(m, hd, "EarDisc", V(0.08, hy * 0.3, hy * 0.3), CF(x * hx * 0.59, hy * 0.0, 0), GOLDC:Lerp(C(0, 0, 0), 0.2), METAL, Enum.PartType.Cylinder)
		end
		round(m, hd, "CenterFin", V(hx * 0.1, hy * 0.42, hz * 1.12), CF(0, hy * 0.6, hz * 0.04), GOLDC:Lerp(C(255, 255, 255), 0.12), METAL)
		-- dark visor band with white lenses, gold nose guard splitting it
		round(m, hd, "Visor", V(hx * 0.92, hy * 0.26, hz * 0.3), CF(0, hy * 0.06, -hz * 0.42), VISOR, Enum.Material.Glass)
		for _, x in { -1, 1 } do
			piece(m, hd, "Lens", V(hx * 0.26, hy * 0.1, 0.05), CF(x * hx * 0.2, hy * 0.07, -hz * 0.565) * A(0, rad(x * 15), rad(x * 10)), glow and C(170, 230, 255) or WHITE)
		end
		piece(m, hd, "NoseGuard", V(hx * 0.11, hy * 0.42, 0.1), CF(0, hy * 0.08, -hz * 0.56), GOLDC, METAL)
	end

	local function suit(m)
		local t, w = find(m, "UpperTorso"), find(m, "LowerTorso")
		if not t then return end
		local s3 = t.Size
		local fz = -s3.Z / 2
		if burst then -- Annihilation-era chest emblem: gold starburst disc
			star(m, t, CF(0, s3.Y * 0.2, fz - 0.03), s3.X * 0.26, 4, GOLDC, METAL)
			star(m, t, CF(0, s3.Y * 0.2, fz - 0.02) * A(0, 0, rad(45)), s3.X * 0.15, 4, GOLDC:Lerp(C(255, 255, 255), 0.3), METAL)
			piece(m, t, "EmblemCore", V(0.06, s3.X * 0.1, s3.X * 0.1), CF(0, s3.Y * 0.2, fz - 0.06) * A(0, rad(90), 0), WHITE, Enum.Material.SmoothPlastic, Enum.PartType.Cylinder)
		else -- three white stars: two over the pecs, one centered below
			for _, o in { { -0.24, 0.24 }, { 0.24, 0.24 }, { 0, -0.04 } } do
				star(m, t, CF(o[1] * s3.X, o[2] * s3.Y, fz - 0.035), s3.X * 0.13, 5, glow and C(170, 230, 255) or WHITE)
			end
		end
		-- gold collar and shoulder caps
		round(m, t, "Collar", V(s3.X * 0.5, s3.Y * 0.16, s3.Z * 1.0), CF(0, s3.Y * 0.48, 0.02), GOLDC, METAL)
		for _, n in { "LeftUpperArm", "RightUpperArm" } do
			local a = m:FindFirstChild(n)
			if a then
				local as = a.Size; local x = n:find("Left") and -1 or 1
				round(m, a, "ShoulderCap", V(as.X * 1.3, as.Y * 0.5, as.Z * 1.24), CF(x * as.X * 0.06, as.Y * 0.38, 0) * A(0, 0, rad(-x * 10)), GOLDC, METAL)
			end
		end
		if w then
			local ws = w.Size
			ecyl(m, w, "Belt", ws.X * 1.02, ws.Y * 0.7, ws.Z * 1.08, CF(0, ws.Y * 0.2, 0), GOLDC, METAL)
			piece(m, w, "Buckle", V(0.08, ws.Y * 1.1, ws.Y * 1.1), CF(0, ws.Y * 0.2, -ws.Z * 0.55) * A(0, rad(90), 0), GOLDC:Lerp(C(255, 255, 255), 0.25), METAL, Enum.PartType.Cylinder)
		end
		for _, n in { "LeftLowerArm", "RightLowerArm", "LeftLowerLeg", "RightLowerLeg" } do
			local a = m:FindFirstChild(n)
			if a then ecyl(m, a, "Cuff", a.Size.X * 1.18, a.Size.Y * 0.14, a.Size.Z * 1.18, CF(0, a.Size.Y * 0.4, 0), GOLDC, METAL) end
		end
		if cape then
			local L = s3.Y * 2.4
			piece(m, t, "Cape", V(s3.X * 0.85, L, 0.1), CF(0, s3.Y * 0.42 - L / 2, s3.Z / 2 + 0.12) * A(rad(-6), 0, 0), SUIT, Enum.Material.Fabric)
			for _, x in { -1, 1 } do
				piece(m, t, "CapeSide", V(s3.X * 0.25, L * 0.97, 0.1), CF(x * s3.X * 0.5, s3.Y * 0.42 - L * 0.49, s3.Z / 2 + 0.02) * A(rad(-6), rad(x * 35), 0), GOLDC, Enum.Material.Fabric)
			end
		end
		if glow then -- Nova Force energy wreathing the hands
			for _, n in { "LeftHand", "RightHand" } do
				local h = m:FindFirstChild(n)
				if h then
					local pe = Instance.new("ParticleEmitter"); pe.Name = "NovaForce"; pe.LightEmission = 1; pe.Color = ColorSequence.new(C(200, 240, 255), C(80, 170, 255))
					pe.Size = NumberSequence.new(0.5, 0); pe.Lifetime = NumberRange.new(0.3, 0.6); pe.Rate = 30; pe.Speed = NumberRange.new(1, 3)
					pe.SpreadAngle = Vector2.new(180, 180); pe.Parent = h
				end
			end
		end
	end

	return { colors = { Head = SKIN, Chest = SUIT, Waist = SUIT, Arms = SUIT, Gloves = GOLDC, Legs = SUIT, Boots = GOLDC },
		pieces = { helmet, { "LowerFace" }, suit } }
end
