-- Joker: chalk-white face with a long pointed chin, huge red grin, slicked-back green hair, purple frock coat with
-- tails and peaked lapels, vest + shirt + bow tie, white lapel flower, white hands, pointed black shoes.
-- Variant flags (SkinData/Joker): Vest, Shirt, Tie ("bow" | "long" | false), Coat ("tail" | "long"), Makeup ("ledger" | "arthur"),
-- Hat (top hat color), Crown (gold), Cape (color), Gloves (color), Hair.
-- Costume module: return function(s, H, rarity) -> { colors = { group = Color3 }, pieces = { ... } }
return function(s, H, rarity)
	local C, WHITE = H.C, H.WHITE
	local piece, round, band, find, chestOf, waistOf, front, glyph = H.piece, H.round, H.band, H.find, H.chestOf, H.waistOf, H.front, H.glyph
	local V, CF, rad = Vector3.new, CFrame.new, math.rad
	local function wedge(p) Instance.new("SpecialMesh", p).MeshType = Enum.MeshType.Wedge; return p end
	local function each(m, names, fn) for _, n in names do local a = m:FindFirstChild(n); if a then fn(a, n:find("Left") and -1 or 1) end end end

	local suit = s.Primary
	local lapel = suit:Lerp(C(0, 0, 0), 0.25)
	local vest, shirt, tie = s.Vest or s.Secondary, s.Shirt or C(240, 150, 40), s.Tie
	local hair = s.Hair or C(60, 160, 60)
	local faceC = s.Face or C(245, 245, 240)
	local red = C(200, 20, 35)
	local makeup = s.Makeup

	local pieces = {
		function(m) -- head: long chin, narrow eyes, high arched brows, long nose, huge grin with teeth, ears
			local hd = find(m, "Head"); if not hd then return end
			local sz = hd.Size
			local fz = -sz.Z * 0.5
			round(m, hd, "Chin", V(sz.X * 0.5, sz.Y * 0.42, sz.Z * 0.55), CF(0, -sz.Y * 0.4, -sz.Z * 0.18), faceC)
			for _, x in { -1, 1 } do
				local ex = x * sz.X * 0.19
				if makeup == "ledger" then -- smeared black eye sockets
					round(m, hd, "Smudge", V(sz.X * 0.3, sz.Y * 0.26, 0.08), CF(ex, sz.Y * 0.08, fz + 0.01) * CFrame.Angles(0, 0, rad(x * 15)), C(25, 25, 30))
				elseif makeup == "arthur" then -- blue diamonds above and below each eye
					for _, dy in { 0.2, -0.06 } do piece(m, hd, "Diamond", V(sz.X * 0.07, sz.X * 0.07, 0.03), CF(ex, sz.Y * dy, fz - 0.005) * CFrame.Angles(0, 0, rad(45)), C(40, 110, 210)) end
				end
				round(m, hd, "Sclera", V(sz.X * 0.2, sz.Y * 0.09, 0.05), CF(ex, sz.Y * 0.07, fz - 0.005) * CFrame.Angles(0, 0, rad(x * -6)), C(250, 250, 240))
				round(m, hd, "Iris", V(sz.X * 0.075, sz.Y * 0.085, 0.04), CF(ex - x * sz.X * 0.01, sz.Y * 0.07, fz - 0.025), makeup == "arthur" and C(90, 70, 50) or C(60, 170, 70))
				piece(m, hd, "Lid", V(sz.X * 0.22, sz.Y * 0.03, 0.04), CF(ex, sz.Y * 0.115, fz - 0.02) * CFrame.Angles(0, 0, rad(x * -10)), C(70, 40, 80))
				piece(m, hd, "Brow", V(sz.X * 0.25, sz.Y * 0.04, 0.05), CF(ex, sz.Y * 0.21, fz - 0.015) * CFrame.Angles(0, 0, rad(x * 24)), hair:Lerp(C(0, 0, 0), 0.45))
				round(m, hd, "Ear", V(0.1, sz.Y * 0.32, sz.Z * 0.24), CF(x * sz.X * 0.5, sz.Y * 0.04, 0.02) * CFrame.Angles(0, 0, rad(x * -10)), faceC)
				-- grin corners curl up into the cheeks + cheek creases
				round(m, hd, "GrinEnd", V(sz.X * 0.16, sz.Y * 0.06, 0.07), CF(x * sz.X * 0.36, -sz.Y * 0.2, fz + 0.04) * CFrame.Angles(0, 0, rad(x * 38)), red)
				piece(m, hd, "Crease", V(0.025, sz.Y * 0.2, 0.03), CF(x * sz.X * 0.44, -sz.Y * 0.12, fz + 0.09) * CFrame.Angles(0, rad(x * 30), rad(x * -20)), faceC:Lerp(C(80, 40, 90), 0.5))
				if makeup == "ledger" then -- Glasgow-smile scars
					piece(m, hd, "Scar", V(sz.X * 0.2, 0.035, 0.03), CF(x * sz.X * 0.36, -sz.Y * 0.14, fz + 0.06) * CFrame.Angles(0, rad(x * 25), rad(x * 35)), C(150, 30, 40))
				end
			end
			wedge(piece(m, hd, "Nose", V(sz.X * 0.1, sz.Y * 0.24, 0.13), CF(0, -sz.Y * 0.04, fz - 0.06), faceC:Lerp(C(0, 0, 0), 0.05)))
			round(m, hd, "Lips", V(sz.X * 0.68, sz.Y * 0.2, 0.12), CF(0, -sz.Y * 0.27, fz + 0.02), red)
			round(m, hd, "Teeth", V(sz.X * 0.56, sz.Y * 0.11, 0.1), CF(0, -sz.Y * 0.265, fz - 0.005), C(250, 248, 230))
			piece(m, hd, "ToothLine", V(sz.X * 0.5, 0.015, 0.02), CF(0, -sz.Y * 0.265, fz - 0.06), C(120, 40, 50))
		end,
		function(m) -- hair: slicked back with a wave on top and curls at the nape
			local hd = find(m, "Head"); if not hd then return end
			local sz = hd.Size
			round(m, hd, "Hair", V(sz.X * 1.08, sz.Y * 0.6, sz.Z * 1.08), CF(0, sz.Y * 0.32, sz.Z * 0.08), hair)
			round(m, hd, "HairWave", V(sz.X * 0.78, sz.Y * 0.36, sz.Z * 0.62), CF(0, sz.Y * 0.56, -sz.Z * 0.08) * CFrame.Angles(rad(-20), 0, 0), hair)
			round(m, hd, "HairBack", V(sz.X * 1.0, sz.Y * (makeup == "ledger" and 0.95 or 0.7), sz.Z * 0.42), CF(0, makeup == "ledger" and -sz.Y * 0.05 or sz.Y * 0.08, sz.Z * 0.36), hair)
			for _, x in { -1, 1 } do
				round(m, hd, "Temple", V(sz.X * 0.18, sz.Y * 0.42, sz.Z * 0.6), CF(x * sz.X * 0.48, sz.Y * 0.2, sz.Z * 0.12), hair)
				local c = wedge(piece(m, hd, "Curl", V(sz.X * 0.2, sz.Y * 0.35, sz.Z * 0.18), CF(x * sz.X * 0.28, -sz.Y * (makeup == "ledger" and 0.55 or 0.3), sz.Z * 0.48) * CFrame.Angles(rad(180), 0, rad(x * 25)), hair))
				if makeup == "ledger" then -- messy shoulder-length strands
					round(m, hd, "Strand", V(sz.X * 0.2, sz.Y * 0.7, sz.Z * 0.3), CF(x * sz.X * 0.46, -sz.Y * 0.25, sz.Z * 0.1) * CFrame.Angles(0, 0, rad(x * 10)), hair)
				end
			end
		end,
		function(m) -- suit front: vest, shirt, tie, peaked lapels, buttons, flower
			local t = chestOf(m); if not t then return end
			local sz = t.Size
			local fz = front(t, 0.02)
			piece(m, t, "Vest", V(sz.X * 0.4, sz.Y * 0.62, 0.05), CF(0, -sz.Y * 0.16, fz), vest, Enum.Material.Fabric)
			for _, x in { -1, 1 } do -- vest V-neck halves
				piece(m, t, "VestV", V(sz.X * 0.08, sz.Y * 0.3, 0.05), CF(x * sz.X * 0.12, sz.Y * 0.26, fz) * CFrame.Angles(0, 0, rad(x * 22)), vest, Enum.Material.Fabric)
			end
			piece(m, t, "Shirt", V(sz.X * 0.14, sz.Y * 0.3, 0.05), CF(0, sz.Y * 0.32, fz - 0.005), shirt, Enum.Material.Fabric)
			for k = 0, 2 do round(m, t, "Button", V(0.08, 0.08, 0.05), CF(0, -sz.Y * (0.0 + k * 0.17), fz - 0.04), vest:Lerp(C(0, 0, 0), 0.4)) end
			if tie == "long" then
				piece(m, t, "Tie", V(sz.X * 0.07, sz.Y * 0.45, 0.04), CF(0, sz.Y * 0.18, fz - 0.03), s.TieColor or C(30, 100, 60), Enum.Material.Fabric)
			elseif tie ~= false then -- bow tie: two triangles + knot
				for _, x in { -1, 1 } do
					round(m, t, "Bow", V(sz.X * 0.13, sz.Y * 0.11, 0.07), CF(x * sz.X * 0.07, sz.Y * 0.43, fz - 0.05) * CFrame.Angles(0, 0, rad(x * 12)), s.TieColor or C(40, 160, 170))
				end
				round(m, t, "Knot", V(0.12, 0.11, 0.08), CF(0, sz.Y * 0.43, fz - 0.06), s.TieColor or C(40, 160, 170))
			end
			for _, x in { -1, 1 } do -- wide peaked lapels running down to the waist
				piece(m, t, "Lapel", V(sz.X * 0.13, sz.Y * 0.62, 0.05), CF(x * sz.X * 0.2, sz.Y * 0.06, fz - 0.03) * CFrame.Angles(0, 0, rad(x * 14)), lapel, Enum.Material.Fabric)
				wedge(piece(m, t, "LapelPeak", V(0.05, sz.Y * 0.16, sz.X * 0.13), CF(x * sz.X * 0.31, sz.Y * 0.3, fz - 0.03) * CFrame.Angles(0, rad(x * 90), rad(x * 30)), lapel))
				round(m, t, "Collar", V(sz.X * 0.22, sz.Y * 0.2, sz.Z * 0.5), CF(x * sz.X * 0.16, sz.Y * 0.5, sz.Z * 0.12), shirt) -- shirt collar points around the neck
			end
			piece(m, t, "CoatCollar", V(sz.X * 0.42, sz.Y * 0.14, 0.12), CF(0, sz.Y * 0.5, sz.Z * 0.38) * CFrame.Angles(rad(-15), 0, 0), lapel, Enum.Material.Fabric)
			-- lapel flower (squirting): white petals + yellow eye
			round(m, t, "Flower", V(0.26, 0.26, 0.1), CF(-sz.X * 0.3, sz.Y * 0.24, fz - 0.08), WHITE)
			round(m, t, "FlowerEye", V(0.1, 0.1, 0.06), CF(-sz.X * 0.3, sz.Y * 0.24, fz - 0.13), C(240, 200, 40))
		end,
		function(m) -- coat tails from the waist: split back vent, sides, cutaway fronts
			local w = waistOf(m); if not w then return end
			local l = w.Size
			local long = s.Coat == "long"
			local len = long and 2.6 or 1.7
			local y = -len / 2 + l.Y * 0.3
			for _, x in { -1, 1 } do
				piece(m, w, "TailBack", V(l.X * 0.48, len, 0.07), CF(x * l.X * 0.24, y, l.Z * 0.56) * CFrame.Angles(rad(9), 0, rad(x * -3)), suit, Enum.Material.Fabric)
				piece(m, w, "TailSide", V(0.07, len * 0.95, l.Z * 0.95), CF(x * l.X * 0.53, y + len * 0.025, 0.05) * CFrame.Angles(0, 0, rad(x * 7)), suit, Enum.Material.Fabric)
				piece(m, w, "TailFront", V(l.X * 0.24, len * (long and 0.95 or 0.7), 0.07), CF(x * l.X * 0.4, y + len * (long and 0.025 or 0.15), -l.Z * 0.56) * CFrame.Angles(rad(-8), 0, rad(x * 6)), suit, Enum.Material.Fabric)
			end
		end,
		function(m) -- sleeve cuffs, trouser hems, pointed shoes
			each(m, { "LeftLowerArm", "RightLowerArm" }, function(a)
				band(m, a, "Cuff", a.Size.X * 1.12, a.Size.Y * 0.16, CF(0, -a.Size.Y * 0.42, 0), lapel, Enum.Material.Fabric)
				band(m, a, "ShirtCuff", a.Size.X * 1.0, a.Size.Y * 0.1, CF(0, -a.Size.Y * 0.53, 0), shirt, Enum.Material.Fabric)
			end)
			each(m, { "LeftFoot", "RightFoot" }, function(f)
				local p = wedge(piece(m, f, "ShoeTip", V(f.Size.X * 0.6, f.Size.Y * 0.9, f.Size.Z * 0.5), CF(0, -f.Size.Y * 0.05, -f.Size.Z * 0.65), f.Color))
				p.CFrame = p.CFrame * CFrame.Angles(0, rad(180), 0)
			end)
		end,
	}
	if s.Hat then -- Clown Prince: tall top hat with a playing card in the band
		table.insert(pieces, function(m)
			local hd = find(m, "Head"); if not hd then return end
			local sz = hd.Size
			local top = CF(0, sz.Y * 0.6, sz.Z * 0.02) * CFrame.Angles(rad(-8), 0, rad(6))
			band(m, hd, "Brim", sz.X * 1.5, 0.07, top, s.Hat)
			band(m, hd, "Crown", sz.X * 0.92, sz.Y * 0.75, top * CF(0, sz.Y * 0.38, 0), s.Hat)
			band(m, hd, "HatBand", sz.X * 0.95, sz.Y * 0.14, top * CF(0, sz.Y * 0.1, 0), s.Secondary)
			local card = piece(m, hd, "Card", V(sz.X * 0.22, sz.Y * 0.3, 0.03), top * CF(sz.X * 0.25, sz.Y * 0.25, -sz.Z * 0.45) * CFrame.Angles(0, rad(20), rad(-12)), WHITE)
			glyph(card, Enum.NormalId.Front, "J", red)
		end)
	end
	if s.Crown then -- Emperor Joker: gold crown + regal cape
		table.insert(pieces, function(m)
			local hd = find(m, "Head"); if not hd then return end
			local sz = hd.Size
			band(m, hd, "Crown", sz.X * 1.04, sz.Y * 0.2, CF(0, sz.Y * 0.52, sz.Z * 0.04), s.Crown, Enum.Material.Metal)
			for i = -2, 2 do
				local a = rad(i * 32)
				local sp = wedge(piece(m, hd, "CrownSpike", V(0.08, sz.Y * (0.42 - math.abs(i) * 0.06), sz.X * 0.22), CF(math.sin(a) * sz.X * 0.5, sz.Y * 0.78, -math.cos(a) * sz.X * 0.5 + sz.Z * 0.04) * CFrame.Angles(0, -a + rad(90), 0), s.Crown, Enum.Material.Metal))
				sp.CFrame = sp.CFrame * CFrame.Angles(0, rad(90), 0)
			end
			round(m, hd, "Jewel", V(0.16, 0.16, 0.08), CF(0, sz.Y * 0.52, -sz.Z * 0.54), s.Secondary)
		end)
	end
	if s.Cape then
		table.insert(pieces, function(m)
			local t = chestOf(m); if not t then return end
			local sz = t.Size
			local len = sz.Y * 2.4
			for i = -2, 2 do -- curved drape: strips around the back, flaring at the hem
				local a = rad(i * 22)
				piece(m, t, "Cape", V(sz.X * 0.27, len, 0.07), CF(math.sin(a) * sz.X * 0.6, sz.Y * 0.45 - len / 2, math.cos(a) * sz.Z * 0.64) * CFrame.Angles(0, a, 0) * CFrame.Angles(rad(7), 0, 0), s.Cape, Enum.Material.Fabric)
			end
			for _, x in { -1, 1 } do
				round(m, t, "CapeCollar", V(sz.X * 0.35, sz.Y * 0.5, 0.12), CF(x * sz.X * 0.3, sz.Y * 0.62, sz.Z * 0.3) * CFrame.Angles(rad(-15), rad(x * 25), 0), s.Cape:Lerp(C(255, 255, 255), 0.2), Enum.Material.Fabric)
			end
		end)
	end
	local gloves = s.Gloves or C(245, 245, 245)
	return { colors = { Head = faceC, Chest = suit, Waist = suit, Arms = suit, Hands = gloves, Legs = s.Pants or suit, Feet = s.Shoes or C(30, 25, 30) }, pieces = pieces }
end
