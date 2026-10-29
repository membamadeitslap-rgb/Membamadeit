-- Spider-Man in the blocky printed-suit style (user reference): classic Roblox block body, the suit is painted on
-- with Paint (web grid, blue side panels, black spider front + back, framed white lenses on a block head).
-- Variants recolor the same layout: Miles (black/red), Iron Spider (red/gold), Symbiote (black, big white spider),
-- 2099 (navy, red skull-spider), Cosmic (white/blue).
-- Costume module: return function(s, H, rarity) -> { colors = { group = Color3 }, pieces = { { "Piece", args... } | function(m) end } }
return function(s, H, rarity)
	local C, piece, paint = H.C, H.piece, H.paint
	local BLACK, WHITE = C(18, 18, 22), C(250, 250, 250)
	local cfg = ({
		Common = { red = s.Primary, blue = s.Secondary, web = BLACK, spider = BLACK, lens = WHITE, frame = BLACK },
		Rare = { red = s.Primary, blue = s.Primary, web = s.Secondary, spider = s.Secondary, lens = WHITE, frame = BLACK },
		Epic = { red = s.Primary, blue = s.Secondary, web = s.Secondary, spider = s.Secondary, lens = C(255, 225, 140), frame = s.Secondary },
		Legendary = { red = s.Primary, blue = s.Primary, web = C(60, 60, 66), spider = s.Secondary, lens = WHITE, frame = s.Primary, big = true },
		Mythic = { red = s.Primary, blue = s.Primary, web = s.Primary:Lerp(BLACK, 0.4), spider = s.Secondary, lens = C(255, 60, 60), frame = s.Primary, skull = true },
		Secret = { red = s.Primary, blue = s.Secondary, web = C(150, 170, 255), spider = s.Secondary, lens = C(200, 230, 255), frame = s.Secondary },
	})[rarity] or {}
	local red, blue, web = cfg.red, cfg.blue, cfg.web
	local function shade(c) return { c:Lerp(WHITE, 0.07), c:Lerp(BLACK, 0.14), 90 } end -- soft top-lit gradient

	-- Web grid: lines radiating from (cx, cy) plus sagging cross strands between them
	local function webs(f, cx, cy, spokes, rings, thick)
		thick = thick or 0.012
		local ends = {}
		for i = 0, spokes - 1 do
			local a = i / spokes * math.pi * 2
			local ex, ey = cx + math.cos(a) * 1.6, cy + math.sin(a) * 1.6
			f:Line(cx, cy, ex, ey, thick, web)
			ends[i] = a
		end
		for r = 1, rings do
			local rr = r / rings * 0.95
			for i = 0, spokes - 1 do
				local a0, a1 = ends[i], ends[(i + 1) % spokes] + (i == spokes - 1 and math.pi * 2 or 0)
				local am = (a0 + a1) / 2
				local p0 = { cx + math.cos(a0) * rr, cy + math.sin(a0) * rr }
				local pm = { cx + math.cos(am) * rr * 0.9, cy + math.sin(am) * rr * 0.9 }
				local p1 = { cx + math.cos(a1) * rr, cy + math.sin(a1) * rr }
				f:Poly({ p0, pm, p1 }, thick, web)
			end
		end
	end
	-- Square grid webbing for gloves / boots / limbs
	local function grid(f, cols, rows, thick)
		for i = 1, cols - 1 do f:Line(i / cols, 0, i / cols, 1, thick or 0.02, web) end
		for j = 1, rows - 1 do f:Poly({ { 0, j / rows }, { 0.5, j / rows + 0.04 }, { 1, j / rows } }, thick or 0.02, web) end
	end
	-- Spider emblem: thorax + abdomen + 8 bent legs, centered at (cx, cy), scale = height fraction
	local function spider(f, cx, cy, sc, color)
		f:Box(cx, cy - sc * 0.12, sc * 0.16, sc * 0.2, color, { round = 0.5 })
		f:Box(cx, cy + sc * 0.14, sc * 0.2, sc * 0.36, color, { round = 0.5 })
		for _, side in { -1, 1 } do
			for k, leg in { { -0.18, -0.45, -0.32 }, { -0.1, -0.5, -0.05 }, { 0.0, -0.5, 0.2 }, { 0.08, -0.42, 0.42 } } do
				local y0 = cy + leg[1] * sc
				local kx, ky = cx + side * sc * 0.28, cy + (leg[1] - 0.12 + k * 0.02) * sc
				local ex, ey = cx + side * sc * (0.36 + k * 0.03), cy + leg[3] * sc
				f:Poly({ { cx + side * sc * 0.05, y0 }, { kx, ky }, { ex, ey } }, sc * 0.028, color)
			end
		end
	end

	local pieces = {}
	-- Head: block head (like the reference), web mask, framed lenses
	table.insert(pieces, function(m)
		local hd = m:FindFirstChild("Head"); if not hd then return end
		hd.Transparency = 1
		local s = hd.Size
		local head = piece(m, hd, "BlockHead", Vector3.new(s.X * 1.12, s.Y * 1.0, s.Z * 1.08), CFrame.new(0, s.Y * 0.02, 0), red)
		for _, face in { "Front", "Back", "Left", "Right", "Top" } do
			local f = paint(head, face)
			f:Fill(red, { grad = shade(red) })
			if face == "Top" then webs(f, 0.5, 0.5, 8, 3)
			elseif face == "Front" then webs(f, 0.5, 0.42, 12, 5)
			else webs(f, face == "Back" and 0.5 or 0.5, 0.0, 9, 4) end
			if (face == "Left" or face == "Right") and blue ~= red then f:Rect(0, 0.72, 1, 0.28, blue, { z = 2 }) end
		end
		local f = paint(head, "Front")
		for _, x in { -1, 1 } do -- big angled lenses with thick black frames
			f:Box(0.5 + x * 0.21, 0.42, 0.36, 0.25, cfg.frame, { round = 0.5, rot = x * -20, z = 40 })
			f:Box(0.5 + x * 0.21, 0.43, 0.27, 0.16, cfg.lens, { round = 0.5, rot = x * -20, z = 41 })
		end
	end)
	-- Torso: red center with web, blue side panels, spider front + back, web belt
	table.insert(pieces, function(m)
		local t = m:FindFirstChild("UpperTorso"); if not t then return end
		for _, face in { "Front", "Back", "Left", "Right" } do
			local f = paint(t, face)
			f:Fill(blue, { grad = shade(blue) })
			if face == "Front" or face == "Back" then
				f:Rect(0.18, 0, 0.64, 1, red, { z = 2 })
				f:Box(0.5, 0.9, 1, 0.2, red, { z = 2 }) -- red band across the bottom of the ribs
				webs(f, 0.5, 0.35, 12, 5)
				f:Rect(0, 0, 0.1, 1, blue, { z = 30 }); f:Rect(0.9, 0, 0.1, 1, blue, { z = 30 }) -- keep the sides clean blue
				if cfg.skull then -- 2099 skull-spider
					f:Box(0.5, 0.42, 0.34, 0.3, cfg.spider, { round = 0.35, z = 50 })
					for _, x in { -1, 1 } do f:Box(0.5 + x * 0.08, 0.4, 0.08, 0.08, red, { round = 0.5, z = 51 }) end
					f:Poly({ { 0.33, 0.5 }, { 0.15, 0.85 } }, 0.04, cfg.spider, { z = 50 }); f:Poly({ { 0.67, 0.5 }, { 0.85, 0.85 } }, 0.04, cfg.spider, { z = 50 })
				else
					spider(f, 0.5, face == "Front" and 0.42 or 0.45, (cfg.big or face == "Back") and 0.95 or 0.72, cfg.spider)
				end
			end
		end
	end)
	table.insert(pieces, function(m)
		local w = m:FindFirstChild("LowerTorso"); if not w then return end
		for _, face in { "Front", "Back", "Left", "Right" } do
			local f = paint(w, face); f:Fill(red, { grad = shade(red) }); grid(f, 6, 2)
		end
	end)
	-- Limbs: blue upper arms/legs, red webbed forearms, gloves, shins and boots
	table.insert(pieces, function(m)
		local function limb(name, color, cols, rows)
			local p = m:FindFirstChild(name); if not p then return end
			for _, face in { "Front", "Back", "Left", "Right" } do
				local f = paint(p, face); f:Fill(color, { grad = shade(color) })
				if color == red or blue == red then grid(f, cols, rows) end
			end
		end
		for _, side in { "Left", "Right" } do
			limb(side .. "UpperArm", blue, 3, 3); limb(side .. "LowerArm", red, 3, 3); limb(side .. "Hand", red, 3, 1)
			limb(side .. "UpperLeg", blue, 3, 3); limb(side .. "LowerLeg", red, 3, 4); limb(side .. "Foot", red, 3, 1)
			local foot = m:FindFirstChild(side .. "Foot")
			if foot and blue ~= red then local f = paint(foot, "Bottom"); f:Fill(blue) end
		end
	end)
	return { colors = { Head = red, Chest = red, Waist = red, UpperArms = blue, LowerArms = red, Hands = red, UpperLegs = blue, LowerLegs = red, Feet = red }, pieces = pieces }
end
