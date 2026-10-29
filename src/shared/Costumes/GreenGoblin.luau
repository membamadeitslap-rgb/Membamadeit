-- Green Goblin (Ditko/Romita classic): green scaled suit, goblin mask (long hooked nose, slanted yellow eyes, heavy brows,
-- huge toothy grin, tall pointed ears), purple floppy stocking hat, short-sleeved purple tunic with a jagged hem,
-- long purple gloves, curled purple elf boots, purple satchel of pumpkin bombs on the hip.
-- Variants: Armored (Raimi-style green armor + helmet mask), Hobgoblin (orange hood + cape over blue), Red Goblin (red skin,
-- black symbiote tunic, spiked crest), Demogoblin (horned demon, flaming head), Goblin King (gold crown + cape).
-- Costume module: return function(s, H, rarity) -> { colors = { group = Color3 }, pieces = { { "Piece", args... } | function(m) end } }
return function(s, H, rarity)
	local C = H.C
	local piece, round, find = H.piece, H.round, H.find
	local V, CF, A, rad = Vector3.new, CFrame.new, CFrame.Angles, math.rad
	local FABRIC, METAL = Enum.Material.Fabric, Enum.Material.Metal
	local function mesh(p, kind) local sm = Instance.new("SpecialMesh"); sm.MeshType = kind; sm.Parent = p; return p end
	local function wedge(p) return mesh(p, Enum.MeshType.Wedge) end
	local function ecyl(m, a, name, w, h, d, cf, color, mat)
		return mesh(piece(m, a, name, V(h, w, d), cf * A(0, 0, rad(90)), color, mat), Enum.MeshType.Cylinder)
	end
	local function tube(m, a, name, pts, r0, r1, color, mat)
		for i = 1, #pts - 1 do
			local p0, p1 = pts[i], pts[i + 1]
			local r = r0 + (r1 - r0) * (i - 1) / math.max(1, #pts - 2)
			round(m, a, name, V(r * 2, (p1 - p0).Magnitude + r * 1.4, r * 2), CFrame.lookAt((p0 + p1) / 2, p1) * A(-math.pi / 2, 0, 0), color, mat)
		end
	end
	local look = ({
		Common = { mask = "Goblin", hat = true },
		Rare = { mask = "Armor" },
		Epic = { mask = "Goblin", hood = true },
		Legendary = { mask = "Goblin", crest = true },
		Mythic = { mask = "Goblin", horns = true, flame = true },
		Secret = { mask = "Goblin", hat = true, crown = true },
	})[rarity] or { mask = "Goblin", hat = true }
	local SKINC, CLOTH = s.Primary, s.Secondary
	if rarity == "Epic" then SKINC, CLOTH = C(235, 170, 50), C(232, 118, 28) end -- Hobgoblin's yellow-orange goblin mask
	local EYE = C(255, 225, 40)

	local function head(m)
		local hd = find(m, "Head"); if not hd then return end
		local s3 = hd.Size
		local hx, hy, hz = s3.X, s3.Y, s3.Z
		local fz = -hz * 0.5
		local DARK = SKINC:Lerp(C(0, 0, 0), 0.6)
		if look.mask == "Armor" then
			-- Raimi-style armored helmet mask: angular brow, insect lenses, grim mouth, swept ear fins
			round(m, hd, "Helmet", V(hx * 1.12, hy * 1.08, hz * 1.12), CF(0, hy * 0.02, 0.02), SKINC, METAL)
			piece(m, hd, "BrowPlate", V(hx * 0.8, hy * 0.14, hz * 0.2), CF(0, hy * 0.2, -hz * 0.5) * A(rad(-15), 0, 0), SKINC:Lerp(C(0, 0, 0), 0.25), METAL)
			for _, x in { -1, 1 } do
				piece(m, hd, "Lens", V(hx * 0.3, hy * 0.14, 0.06), CF(x * hx * 0.2, hy * 0.06, -hz * 0.56) * A(0, rad(x * 18), rad(x * 18)), EYE)
				wedge(piece(m, hd, "EarFin", V(0.08, hy * 0.6, hz * 0.45), CF(x * hx * 0.56, hy * 0.25, hz * 0.1) * A(rad(-25), 0, rad(-x * 15)), SKINC, METAL))
			end
			piece(m, hd, "Mouth", V(hx * 0.42, hy * 0.06, 0.06), CF(0, -hy * 0.28, -hz * 0.55), C(20, 25, 20))
			round(m, hd, "Nose", V(hx * 0.12, hy * 0.26, hz * 0.2), CF(0, -hy * 0.06, -hz * 0.55), SKINC, METAL)
			return
		end
		-- goblin face: brow ridge, slanted yellow eyes, long hooked nose, enormous grin, cheek wrinkles
		for _, x in { -1, 1 } do
			piece(m, hd, "Brow", V(hx * 0.3, hy * 0.1, hz * 0.14), CF(x * hx * 0.17, hy * 0.2, fz - 0.02) * A(0, 0, rad(x * 22)), DARK)
			piece(m, hd, "EyeSocket", V(hx * 0.24, hy * 0.13, 0.04), CF(x * hx * 0.19, hy * 0.07, fz - 0.005) * A(0, 0, rad(x * 18)), C(25, 20, 15))
			piece(m, hd, "Eye", V(hx * 0.18, hy * 0.08, 0.05), CF(x * hx * 0.19, hy * 0.07, fz - 0.015) * A(0, 0, rad(x * 18)), EYE)
			piece(m, hd, "Pupil", V(hx * 0.04, hy * 0.06, 0.06), CF(x * hx * 0.16, hy * 0.07, fz - 0.025), C(20, 10, 5))
			piece(m, hd, "Wrinkle", V(hx * 0.03, hy * 0.2, 0.04), CF(x * hx * 0.33, -hy * 0.2, fz + 0.01) * A(0, 0, rad(x * 25)), DARK)
			-- tall pointed ears
			local ear = wedge(piece(m, hd, "Ear", V(0.08, hy * 0.6, hz * 0.32), CF(x * hx * 0.56, hy * 0.18, hz * 0.04) * A(0, 0, rad(-x * 28)), SKINC))
			ear.CFrame = ear.CFrame * A(0, math.pi, 0)
		end
		round(m, hd, "Nose", V(hx * 0.16, hy * 0.3, hz * 0.32), CF(0, -hy * 0.04, fz - 0.08) * A(rad(-30), 0, 0), SKINC:Lerp(C(0, 0, 0), 0.08))
		round(m, hd, "NoseTip", V(hx * 0.12, hy * 0.14, hz * 0.18), CF(0, -hy * 0.15, fz - 0.16), SKINC:Lerp(C(0, 0, 0), 0.1))
		piece(m, hd, "Mouth", V(hx * 0.62, hy * 0.15, 0.04), CF(0, -hy * 0.31, fz), C(40, 10, 15))
		for _, x in { -1, 1 } do piece(m, hd, "MouthCorner", V(hx * 0.1, hy * 0.04, 0.04), CF(x * hx * 0.33, -hy * 0.26, fz) * A(0, 0, rad(x * 30)), C(40, 10, 15)) end
		piece(m, hd, "TeethTop", V(hx * 0.54, hy * 0.05, 0.05), CF(0, -hy * 0.26, fz - 0.01), C(245, 240, 215))
		piece(m, hd, "TeethLow", V(hx * 0.44, hy * 0.04, 0.05), CF(0, -hy * 0.36, fz - 0.01), C(245, 240, 215))
		round(m, hd, "Chin", V(hx * 0.4, hy * 0.2, hz * 0.3), CF(0, -hy * 0.46, -hz * 0.32), SKINC)
		if look.hat then
			-- floppy stocking cap: rolled brim, then a tapering tube that rises and flops back and to the side
			round(m, hd, "Hat", V(hx * 1.14, hy * 0.62, hz * 1.16), CF(0, hy * 0.34, 0.02), CLOTH, FABRIC)
			ecyl(m, hd, "HatBrim", hx * 1.16, hy * 0.12, hz * 1.18, CF(0, hy * 0.17, 0.02), CLOTH:Lerp(C(0, 0, 0), 0.15), FABRIC)
			tube(m, hd, "HatTip", { V(0, hy * 0.5, hz * 0.05), V(hx * 0.05, hy * 0.85, hz * 0.15), V(hx * 0.14, hy * 1.08, hz * 0.38), V(hx * 0.24, hy * 1.08, hz * 0.62), V(hx * 0.32, hy * 0.9, hz * 0.8) },
				hx * 0.36, hx * 0.1, CLOTH, FABRIC)
			if look.crown then
				ecyl(m, hd, "Crown", hx * 1.2, hy * 0.18, hz * 1.22, CF(0, hy * 0.3, 0.02), C(255, 210, 70), METAL)
				for i = -2, 2 do round(m, hd, "CrownPoint", V(hx * 0.1, hy * 0.28, hx * 0.1), CF(i * hx * 0.22, hy * 0.44, -hz * 0.5 + math.abs(i) * 0.12), C(255, 210, 70), METAL) end
			end
		elseif look.hood then -- Hobgoblin cowl: hood with a forward-pointing peak, open around the face
			round(m, hd, "Hood", V(hx * 1.2, hy * 1.12, hz * 1.2), CF(0, hy * 0.08, hz * 0.1), CLOTH, FABRIC)
			tube(m, hd, "HoodPeak", { V(0, hy * 0.5, 0), V(0, hy * 0.72, hz * 0.2), V(0, hy * 0.8, hz * 0.5) }, hx * 0.3, hx * 0.08, CLOTH, FABRIC)
		elseif look.crest then -- Red Goblin: symbiote spikes sweeping back off the skull
			round(m, hd, "Scalp", V(hx * 1.06, hy * 0.6, hz * 1.08), CF(0, hy * 0.32, 0.04), SKINC)
			for i = -2, 2 do
				tube(m, hd, "Spike", { V(i * hx * 0.18, hy * 0.5, -hz * 0.1), V(i * hx * 0.24, hy * 0.85, hz * 0.25), V(i * hx * 0.3, hy * 1.0, hz * 0.6) }, hx * 0.1, hx * 0.03, SKINC)
			end
		end
		if look.horns then -- Demogoblin: curled demon horns + burning head
			for _, x in { -1, 1 } do
				tube(m, hd, "Horn", { V(x * hx * 0.3, hy * 0.4, -hz * 0.1), V(x * hx * 0.55, hy * 0.7, 0), V(x * hx * 0.62, hy * 1.05, hz * 0.15), V(x * hx * 0.5, hy * 1.25, hz * 0.2) }, hx * 0.12, hx * 0.04, C(40, 25, 20))
			end
			H.hellfire(hd, C(255, 120, 20), C(255, 220, 90), 0.8, 0.8, -1)
		end
	end

	local function body(m)
		local t, w = find(m, "UpperTorso"), find(m, "LowerTorso")
		if not t then return end
		local s3 = t.Size
		local TUNIC = (rarity == "Legendary") and C(20, 20, 24) or CLOTH
		if look.mask == "Armor" then -- armor plates over the chest + abs
			round(m, t, "Chestplate", V(s3.X * 0.85, s3.Y * 0.5, s3.Z * 1.06), CF(0, s3.Y * 0.2, 0), SKINC, METAL)
			for i = 0, 2 do piece(m, t, "Plate", V(s3.X * 0.36, s3.Y * 0.1, 0.06), CF(0, -s3.Y * (0.12 + i * 0.13), -s3.Z / 2 - 0.02), CLOTH, METAL) end
			for _, x in { -1, 1 } do piece(m, t, "Rib", V(s3.X * 0.06, s3.Y * 0.5, 0.06), CF(x * s3.X * 0.28, -s3.Y * 0.12, -s3.Z / 2 + 0.02) * A(0, 0, rad(x * 15)), CLOTH, METAL) end
		else
			-- tunic: V-neck, short puffed sleeves, jagged hem around the hips
			piece(m, t, "VNeck", V(s3.X * 0.16, s3.X * 0.16, 0.05), CF(0, s3.Y * 0.44, -s3.Z / 2 - 0.01) * A(0, 0, rad(45)), SKINC)
			for _, n in { "LeftUpperArm", "RightUpperArm" } do
				local a = m:FindFirstChild(n)
				if a then local x = n:find("Left") and -1 or 1
					round(m, a, "Sleeve", V(a.Size.X * 1.3, a.Size.Y * 0.75, a.Size.Z * 1.3), CF(x * a.Size.X * 0.04, a.Size.Y * 0.2, 0), TUNIC, FABRIC) end
			end
			if w then
				local ws = w.Size
				ecyl(m, w, "TunicSkirt", ws.X * 1.04, ws.Y * 1.3, ws.Z * 1.1, CF(0, -ws.Y * 0.1, 0), TUNIC, FABRIC)
				for i = 0, 9 do -- hanging points
					local a = i / 10 * math.pi * 2
					local px, pz = math.sin(a) * ws.X * 0.5, -math.cos(a) * ws.Z * 0.54
					piece(m, w, "HemPoint", V(ws.X * 0.2, ws.X * 0.2, 0.06), CF(px, -ws.Y * 0.75, pz) * A(0, -a, 0) * A(0, 0, rad(45)), TUNIC, FABRIC)
				end
			end
		end
		if w then -- belt + satchel strap + bag
			local ws = w.Size
			ecyl(m, w, "Belt", ws.X * 1.06, ws.Y * 0.35, ws.Z * 1.12, CF(0, ws.Y * 0.3, 0), CLOTH:Lerp(C(0, 0, 0), 0.35), Enum.Material.Leather)
			local bag = round(m, w, "Satchel", V(ws.X * 0.32, ws.X * 0.32, ws.Z * 0.4), CF(-ws.X * 0.56, -ws.Y * 0.6, -ws.Z * 0.05), C(100, 60, 120):Lerp(CLOTH, 0.5), Enum.Material.Leather)
			piece(m, w, "SatchelFlap", V(ws.X * 0.26, ws.X * 0.12, ws.Z * 0.42), CF(-ws.X * 0.57, -ws.Y * 0.2, -ws.Z * 0.05), CLOTH:Lerp(C(0, 0, 0), 0.3), Enum.Material.Leather)
		end
		piece(m, t, "SatchelStrap", V(s3.X * 0.08, s3.Y * 1.3, 0.05), CF(-s3.X * 0.05, -s3.Y * 0.05, -s3.Z / 2 - 0.05) * A(0, 0, rad(-38)), CLOTH:Lerp(C(0, 0, 0), 0.35), Enum.Material.Leather)
		-- long gloves flare at the elbow; elf boots with curled toes
		for _, n in { "LeftLowerArm", "RightLowerArm" } do
			local a = m:FindFirstChild(n)
			if a then ecyl(m, a, "GloveFlare", a.Size.X * 1.22, a.Size.Y * 0.2, a.Size.Z * 1.22, CF(0, a.Size.Y * 0.36, 0), CLOTH, FABRIC) end
		end
		for _, n in { "LeftFoot", "RightFoot" } do
			local f = m:FindFirstChild(n)
			if f then
				tube(m, f, "CurlToe", { V(0, 0, -f.Size.Z * 0.3), V(0, f.Size.Y * 0.1, -f.Size.Z * 0.72), V(0, f.Size.Y * 0.9, -f.Size.Z * 0.85) }, f.Size.X * 0.3, f.Size.X * 0.1, look.mask == "Armor" and CLOTH or CLOTH, look.mask == "Armor" and METAL or FABRIC)
			end
		end
		if look.hood or look.crown then -- Hobgoblin / Goblin King cape
			local L = s3.Y * 2.3
			local capeC = look.crown and C(255, 200, 60) or CLOTH
			piece(m, t, "Cape", V(s3.X * 0.85, L, 0.1), CF(0, s3.Y * 0.42 - L / 2, s3.Z / 2 + 0.12) * A(rad(-6), 0, 0), capeC, FABRIC)
			for _, x in { -1, 1 } do
				piece(m, t, "CapeSide", V(s3.X * 0.25, L * 0.97, 0.1), CF(x * s3.X * 0.5, s3.Y * 0.42 - L * 0.49, s3.Z / 2 + 0.02) * A(rad(-6), rad(x * 35), 0), capeC, FABRIC)
			end
		end
	end

	local colors = { Head = SKINC, Chest = CLOTH, Waist = CLOTH, Arms = SKINC, Gloves = CLOTH, Legs = SKINC, Boots = CLOTH }
	if rarity == "Epic" then colors.Arms, colors.Legs, colors.Chest, colors.Waist = C(40, 70, 160), C(40, 70, 160), C(230, 120, 30), C(230, 120, 30) end
	if rarity == "Legendary" then colors.Chest, colors.Waist, colors.Gloves, colors.Boots = C(20, 20, 24), C(20, 20, 24), SKINC, SKINC end
	if look.mask == "Armor" then colors.Arms, colors.Legs = SKINC, SKINC end
	return { colors = colors, pieces = { head, body } }
end
