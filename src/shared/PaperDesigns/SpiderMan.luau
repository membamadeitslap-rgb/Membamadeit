-- Paper Mario style Spider-Man with an Ultimate Spider-Man (animated) build: lean V-shaped athlete, broad
-- shoulders, narrow waist, long legs, egg-shaped mask with big angular lenses, giant long-legged chest spider.
-- Every piece is a merged paper cutout (single ink outline + white paper border) drawn with PaperDoll's kit.
return function(skin, rarity, K)
	local red, blue = skin.Primary, skin.Secondary
	local white = Color3.fromRGB(250, 250, 250)
	local INK = K.INK
	local function grid(f, x0, x1, cols, y0, y1, rows, t)
		for i = 1, cols - 1 do local x = x0 + (x1 - x0) * i / cols; K.line(f, x, y0, x, y1, t or 0.012) end
		for j = 1, rows - 1 do
			local y = y0 + (y1 - y0) * j / rows
			f:Poly({ { x0, y }, { (x0 + x1) / 2, y + 0.03 }, { x1, y } }, t or 0.012, INK)
		end
	end
	-- the big Ultimate spider: tiny body, long legs reaching the shoulders and down the ribs
	local function spider(f, cx, cy, s)
		local ar = f.h / f.w
		f:Circle(cx, cy - 0.05 * s, 0.035 * s, INK)
		f:Box(cx, cy + 0.06 * s, 0.07 * s * ar * 1.6, 0.14 * s, INK, { round = 0.5 })
		for _, sx in { -1, 1 } do
			local legs = {
				{ { 0.02, -0.06 }, { 0.14, -0.2 }, { 0.3, -0.26 } }, -- to the shoulder
				{ { 0.02, -0.03 }, { 0.2, -0.08 }, { 0.36, -0.06 } },
				{ { 0.02, 0.03 }, { 0.2, 0.1 }, { 0.32, 0.26 } },
				{ { 0.02, 0.08 }, { 0.12, 0.24 }, { 0.2, 0.42 } }, -- down the ribs
			}
			for _, l in legs do
				local pts = {}
				for _, q in l do table.insert(pts, { cx + sx * q[1] * s * ar * 1.4, cy + q[2] * s }) end
				f:Poly(pts, 0.016 * s, INK, { cap = true })
			end
		end
	end
	local function draw(part, face, f)
		local back = face == "Back"
		if part == "Head" then
			K.union(f, { { 0.5, 0.44, 0.86, 0.8, 0.5 }, { 0.5, 0.66, 0.64, 0.5, 0.5 } }, red, { ink = 0.03 })
			K.web(f, 0.5, back and 0.4 or 0.55, 0.36, 10, 3, 0.012)
			if not back then
				for _, x in { -1, 1 } do -- big angular lenses, wide thick frames
					f:Box(0.5 + x * 0.21, 0.47, 0.42, 0.3, INK, { round = 0.35, rot = x * -26, z = 80 })
					f:Box(0.5 + x * 0.2, 0.475, 0.3, 0.18, white, { round = 0.35, rot = x * -26, z = 81 })
				end
			end
		elseif part == "UpperTorso" then
			K.union(f, { { 0.5, 0.2, 0.98, 0.36, 0.45 }, { 0.5, 0.42, 0.8, 0.34, 0.35 }, { 0.5, 0.62, 0.62, 0.34, 0.3 }, { 0.5, 0.82, 0.52, 0.32, 0.25 } }, blue)
			K.union(f, { { 0.5, 0.21, 0.9, 0.32, 0.45 }, { 0.5, 0.43, 0.6, 0.32, 0.3 }, { 0.5, 0.63, 0.42, 0.32, 0.25 }, { 0.5, 0.83, 0.38, 0.3, 0.2 } }, red, { border = false, ink = 0.012, z = 20 })
			K.web(f, 0.5, back and 0.38 or 0.34, 0.3, 10, 3, 0.008)
			spider(f, 0.5, back and 0.42 or 0.36, back and 1.35 or 1.0)
		elseif part == "LowerTorso" then
			K.union(f, { { 0.5, 0.5, 0.86, 0.86, 0.4 } }, red, { ink = 0.05 })
			grid(f, 0.2, 0.8, 6, 0.15, 0.85, 2, 0.03)
		elseif part:find("UpperArm") then
			K.union(f, { { 0.5, 0.5, 0.82, 0.92, 0.5 } }, blue)
			K.union(f, { { 0.5, 0.2, 0.82, 0.34, 0.5 } }, red, { border = false, ink = 0.02, z = 20 }) -- red shoulder cap
		elseif part:find("LowerArm") then
			K.union(f, { { 0.5, 0.36, 0.86, 0.62, 0.5 }, { 0.5, 0.7, 0.66, 0.56, 0.5 } }, red)
			grid(f, 0.22, 0.78, 3, 0.1, 0.92, 5)
		elseif part:find("Hand") then
			K.union(f, { { 0.5, 0.52, 0.86, 0.74, 0.45 }, { part:find("Left") and 0.84 or 0.16, 0.42, 0.3, 0.4, 0.5 } }, red)
			grid(f, 0.2, 0.8, 3, 0.25, 0.8, 2)
		elseif part:find("UpperLeg") then
			K.union(f, { { 0.5, 0.36, 0.92, 0.68, 0.45 }, { 0.5, 0.72, 0.74, 0.56, 0.45 } }, blue)
		elseif part:find("LowerLeg") then
			K.union(f, { { 0.5, 0.34, 0.82, 0.62, 0.45 }, { 0.5, 0.72, 0.64, 0.58, 0.4 } }, red)
			grid(f, 0.24, 0.76, 3, 0.1, 0.94, 5)
		elseif part:find("Foot") then
			K.union(f, { { 0.5, 0.42, 0.86, 0.7, 0.45 } }, red)
			f:Box(0.5, 0.8, 0.86, 0.16, blue, { round = 0.5, stroke = 3, strokeColor = INK, z = 60 })
		end
	end
	return {
		cards = { -- w/h in studs, or sw/sh = multiples of the body part's size (follows the skeleton's proportions)
			Head = { w = 1.6, h = 1.9, y = 0.3 },
			UpperTorso = { sw = 1.08, sh = 1.2, y = 0.02 },
			LowerTorso = { sw = 0.8, sh = 1.6, z = 0.012 }, -- belt tucks behind the torso
			LeftUpperArm = { sw = 1.4, sh = 1.35 }, RightUpperArm = { sw = 1.4, sh = 1.35 },
			LeftLowerArm = { sw = 1.35, sh = 1.35 }, RightLowerArm = { sw = 1.35, sh = 1.35 },
			LeftHand = { w = 0.85, h = 0.85, y = -0.15 }, RightHand = { w = 0.85, h = 0.85, y = -0.15 },
			LeftUpperLeg = { sw = 1.25, sh = 1.3 }, RightUpperLeg = { sw = 1.25, sh = 1.3 },
			LeftLowerLeg = { sw = 1.2, sh = 1.3 }, RightLowerLeg = { sw = 1.2, sh = 1.3 },
			LeftFoot = { w = 1.1, h = 0.6, y = 0.05 }, RightFoot = { w = 1.1, h = 0.6, y = 0.05 },
		},
		draw = draw,
	}
end
