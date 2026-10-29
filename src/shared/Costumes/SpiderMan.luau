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
	-- Head: the round Roblox head is the mask. Web = rings around the head + lines running up from the
	-- nose and over the top; big angled white lenses with thick black frames sit on the curved front.
	table.insert(pieces, function(m)
		local hd = m:FindFirstChild("Head"); if not hd then return end
		local s = hd.Size
		local r = s.X / 2
		local thin = math.max(0.02, s.X * 0.018)
		for i, y in { -0.3, -0.12, 0.06, 0.24 } do -- rings around the mask
			H.band(m, hd, "WebRing", s.X * (1.012 - math.abs(y) * 0.06), thin, CFrame.new(0, s.Y * y, 0), web)
		end
		for i = -5, 5 do -- strands fanning from the nose around the head
			local a = math.rad(i * 30)
			piece(m, hd, "WebLine", Vector3.new(thin, s.Y * 0.72, thin), CFrame.Angles(0, a, 0) * CFrame.new(0, -s.Y * 0.02, -r * 1.005), web)
		end
		for i = 0, 5 do -- over the crown
			piece(m, hd, "WebTop", Vector3.new(thin, thin, s.Z * 0.9), CFrame.new(0, s.Y * 0.5, 0) * CFrame.Angles(0, math.rad(i * 30), 0), web)
		end
		for _, x in { -1, 1 } do -- lenses: frame + white eye, angled up and out, wrapped onto the curve
			local at = CFrame.Angles(0, math.rad(x * 26), 0) * CFrame.new(0, s.Y * 0.06, -r * 1.0) * CFrame.Angles(0, 0, math.rad(x * -24))
			H.round(m, hd, "LensFrame", Vector3.new(s.X * 0.5, s.Y * 0.36, 0.08), at, cfg.frame)
			H.round(m, hd, "Lens", Vector3.new(s.X * 0.38, s.Y * 0.23, 0.08), at * CFrame.new(x * s.X * 0.01, -s.Y * 0.005, -0.025), cfg.lens, Enum.Material.SmoothPlastic)
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
				if face == "Front" then -- soft pec and ab shading under the webbing
					for _, x in { -1, 1 } do f:Box(0.5 + x * 0.17, 0.3, 0.3, 0.2, red:Lerp(BLACK, 0.12), { round = 0.5, z = 3 }) end
					f:Line(0.5, 0.45, 0.5, 0.95, 0.012, red:Lerp(BLACK, 0.2), { z = 3 })
				end
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
