-- LEGO minifigure-style Spider-Man: cylinder head with stud and neck, tapered minifig torso (blue sloped sides),
-- hip block, straight legs with toe fronts, minifig arms and C-shaped hands. Detail is printed on with Paint
-- (webbing, spider, lenses) like a real minifig print; the R15 body parts are hidden and the pieces ride on them.
-- Costume module: return function(s, H, rarity) -> { colors = { group = Color3 }, pieces = { function(m) end } }
return function(s, H, rarity)
	local C, piece, band, paint = H.C, H.piece, H.band, H.paint
	local INK, WHITE = C(20, 20, 24), C(250, 250, 250)
	local red, blue = s.Primary, s.Secondary
	local web = (rarity == "Rare" or rarity == "Legendary") and s.Secondary or INK
	local V, CF = Vector3.new, CFrame.new
	local SP = Enum.Material.SmoothPlastic

	local function wedge(m, anchor, name, size, offset, color)
		local p = piece(m, anchor, name, size, offset, color, SP)
		local sm = Instance.new("SpecialMesh"); sm.MeshType = Enum.MeshType.Wedge; sm.Parent = p
		return p
	end
	-- printed web: spokes from (cx, cy) + sagging rings, on a Paint face
	local function webPrint(f, cx, cy, r, spokes, rings, t)
		local ar = f.h / f.w
		for i = 0, spokes - 1 do
			local a = i / spokes * math.pi * 2
			f:Line(cx, cy, cx + math.cos(a) * r * ar, cy + math.sin(a) * r, t, web)
		end
		for k = 1, rings do
			local rr = r * k / (rings + 0.3)
			local pts = {}
			for i = 0, spokes do
				local a = i / spokes * math.pi * 2
				table.insert(pts, { cx + math.cos(a) * rr * ar, cy + math.sin(a) * rr })
				if i < spokes then
					local am = (i + 0.5) / spokes * math.pi * 2
					table.insert(pts, { cx + math.cos(am) * rr * ar * 0.86, cy + math.sin(am) * rr * 0.86 })
				end
			end
			f:Poly(pts, t, web)
		end
	end
	local function grid(f, cols, rows, t)
		for i = 1, cols - 1 do f:Line(i / cols, 0, i / cols, 1, t, web) end
		for j = 1, rows - 1 do f:Poly({ { 0, j / rows }, { 0.5, j / rows + 0.03 }, { 1, j / rows } }, t, web) end
	end
	local function spider(f, cx, cy, sc)
		local ar = f.h / f.w
		f:Circle(cx, cy - 0.06 * sc, 0.035 * sc, INK, { z = 90 })
		f:Box(cx, cy + 0.05 * sc, 0.075 * sc * ar, 0.15 * sc, INK, { round = 0.5, z = 90 })
		for _, sx in { -1, 1 } do
			for _, l in { { { 0.02, -0.07 }, { 0.12, -0.2 }, { 0.24, -0.26 } }, { { 0.02, -0.03 }, { 0.16, -0.07 }, { 0.3, -0.05 } },
				{ { 0.02, 0.03 }, { 0.16, 0.09 }, { 0.26, 0.24 } }, { { 0.02, 0.08 }, { 0.1, 0.22 }, { 0.16, 0.36 } } } do
				local pts = {}
				for _, q in l do table.insert(pts, { cx + sx * q[1] * sc * ar * 1.3, cy + q[2] * sc }) end
				f:Poly(pts, 0.016 * sc, INK, { z = 90 })
			end
		end
	end

	local pieces = {}
	table.insert(pieces, function(m)
		for _, p in m:GetChildren() do
			if p:IsA("BasePart") and p.Name ~= "HumanoidRootPart" then p.Transparency = 1 end
		end
		local hd, ut, lt = m:FindFirstChild("Head"), m:FindFirstChild("UpperTorso"), m:FindFirstChild("LowerTorso")
		if not (hd and ut and lt) then return end

		-- HEAD: minifig cylinder + stud + neck, web wrapped around, printed lenses
		local d, hh = 1.3, 1.15
		local head = band(m, hd, "LegoHead", d, hh, CF(0, 0.05, 0), red, SP)
		band(m, hd, "LegoStud", d * 0.62, 0.22, CF(0, 0.05 + hh / 2 + 0.11, 0), red, SP)
		band(m, hd, "LegoNeck", d * 0.55, 0.2, CF(0, 0.05 - hh / 2 - 0.08, 0), red, SP)
		local r = d / 2
		for _, y in { -0.36, -0.16, 0.04, 0.24, 0.42 } do band(m, hd, "WebRing", d + 0.012, 0.022, CF(0, 0.05 + y, 0), web, SP) end
		for i = 0, 11 do
			piece(m, hd, "WebLine", V(0.022, hh * 0.98, 0.012), CF(0, 0.05, 0) * CFrame.Angles(0, math.rad(i * 30 + 15), 0) * CF(0, 0, -r - 0.004), web, SP)
		end
		for i = 0, 5 do piece(m, hd, "WebTop", V(0.022, 0.012, d * 0.98), CF(0, 0.05 + hh / 2 + 0.003, 0) * CFrame.Angles(0, math.rad(i * 30), 0), web, SP) end
		for _, x in { -1, 1 } do -- big minifig-print lenses on cards tangent to the cylinder
			local card = piece(m, hd, "Lens", V(0.64, 0.5, 0.01), CF(0, 0.12, 0) * CFrame.Angles(0, math.rad(-x * 27), 0) * CF(0, 0, -r - 0.012), red, SP)
			card.Transparency = 1
			local f = paint(card, "Front") -- outer corner sweeps up, like the comic lenses
			f:Box(0.5, 0.5, 0.92, 0.66, INK, { round = 0.5, rot = x * 26, z = 5 })
			f:Box(0.5 + x * 0.015, 0.5, 0.7, 0.42, WHITE, { round = 0.5, rot = x * 26, z = 6 })
			f:Box(0.5 + x * 0.1, 0.4, 0.22, 0.08, C(255, 255, 255), { round = 0.5, rot = x * 26, z = 7 })
		end

		-- TORSO: printed red chest panel on the front/back box, blue sloped minifig sides
		local tw, th, td = 1.55, 1.7, 0.95
		local torso = piece(m, ut, "LegoTorso", V(tw, th, td), CF(0, -0.05, 0), red, SP)
		for _, x in { -1, 1 } do
			wedge(m, ut, "LegoTorsoSide", V(td, th, 0.32), CF(x * (tw / 2 + 0.16), -0.05, 0) * CFrame.Angles(0, math.rad(x * 90), 0), blue)
		end
		for _, face in { "Front", "Back" } do
			local f = paint(torso, face)
			f:Fill(blue, { bevel = false })
			f:Box(0.5, 0.47, 0.8, 0.94, red, { round = 0.25, z = 2 })
			f:Rect(0, 0, 1, 0.16, red, { z = 2 })
			webPrint(f, 0.5, 0.36, 0.42, 12, 4, 0.008)
			spider(f, 0.5, face == "Front" and 0.36 or 0.4, face == "Front" and 1.0 or 1.5)
		end
		for _, face in { "Left", "Right" } do paint(torso, face):Fill(blue, { bevel = false }) end
		paint(torso, "Top"):Fill(red, { bevel = false })

		-- HIPS + LEGS (minifig legs don't bend at the knee: one piece from hip to toe)
		local hips = piece(m, lt, "LegoHips", V(tw + 0.64, 0.38, td * 0.92), CF(0, -0.02, 0), red, SP)
		for _, face in { "Front", "Back" } do local f = paint(hips, face); f:Fill(red, { bevel = false }); grid(f, 8, 1, 0.03) end
		for _, side in { "Left", "Right" } do
			local ul = m:FindFirstChild(side .. "UpperLeg"); local ll = m:FindFirstChild(side .. "LowerLeg"); local ft = m:FindFirstChild(side .. "Foot")
			if ul then
				local total = ul.Size.Y + (ll and ll.Size.Y or 0) + (ft and ft.Size.Y or 0)
				local lx = side == "Left" and 0.04 or -0.04 -- small split between the legs
				local leg = piece(m, ul, "LegoLeg", V(0.92, total, td * 0.88), CF(lx, ul.Size.Y / 2 - total / 2, 0), blue, SP)
				for _, face in { "Front", "Back", "Left", "Right" } do
					local f = paint(leg, face)
					f:Fill(blue, { bevel = false })
					f:Rect(0, 0.45, 1, 0.55, red, { z = 2 })
					local g = 0.45
					for i = 1, 3 do f:Line(i / 4, g, i / 4, 1, 0.012, web, { z = 3 }) end
					for j = 1, 5 do f:Poly({ { 0, g + j * 0.09 }, { 0.5, g + j * 0.09 + 0.015 }, { 1, g + j * 0.09 } }, 0.012, web, { z = 3 }) end
					f:Rect(0, 0.95, 1, 0.05, blue, { z = 4 })
				end
				local toe = piece(m, ul, "LegoToe", V(0.92, 0.34, 0.32), CF(lx, ul.Size.Y / 2 - total + 0.17, -td * 0.44 - 0.16), red, SP)
				local tf = paint(toe, "Front"); tf:Fill(red, { bevel = false }); tf:Rect(0, 0.75, 1, 0.25, blue, { z = 3 })
			end
		end

		-- ARMS: minifig arms hang from the shoulder, slightly out; C-shaped hands
		for _, side in { "Left", "Right" } do
			local ua = m:FindFirstChild(side .. "UpperArm"); local hand = m:FindFirstChild(side .. "Hand")
			local sx = side == "Left" and -1 or 1
			if ua then
				local len = 1.55
				local arm = piece(m, ua, "LegoArm", V(0.55, len, 0.6), CF(sx * 0.2, ua.Size.Y / 2 - len / 2 + 0.1, 0) * CFrame.Angles(0, 0, math.rad(sx * 6)), blue, SP)
				band(m, ua, "LegoShoulder", 0.62, 0.55, CF(sx * 0.17, ua.Size.Y / 2 - 0.05, 0) * CFrame.Angles(0, 0, math.rad(90)), blue, SP)
				for _, face in { "Front", "Back", "Left", "Right" } do
					local f = paint(arm, face)
					f:Fill(blue, { bevel = false })
					f:Rect(0, 0.5, 1, 0.5, red, { z = 2 })
					for i = 1, 2 do f:Line(i / 3, 0.5, i / 3, 1, 0.012, web, { z = 3 }) end
					for j = 1, 4 do f:Poly({ { 0, 0.5 + j * 0.1 }, { 0.5, 0.5 + j * 0.1 + 0.02 }, { 1, 0.5 + j * 0.1 } }, 0.012, web, { z = 3 }) end
				end
			end
			if hand then -- C-hand: ring with the gap facing forward
				band(m, hand, "LegoHand", 0.56, 0.36, CF(0, -0.18, -0.08) * CFrame.Angles(math.rad(90), 0, 0), red, SP)
				band(m, hand, "LegoHandHole", 0.3, 0.38, CF(0, -0.18, -0.08) * CFrame.Angles(math.rad(90), 0, 0), C(110, 10, 18), SP)
			end
		end
	end)
	return { colors = {}, pieces = pieces }
end
