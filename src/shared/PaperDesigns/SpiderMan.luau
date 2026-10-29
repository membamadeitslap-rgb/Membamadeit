-- Paper Mario style Spider-Man: big round mask head, classic red/blue suit, black ink webs, white paper border.
return function(skin, rarity, K)
	local red, blue = skin.Primary, skin.Secondary
	local white = Color3.fromRGB(250, 250, 250)
	local INK = K.INK
	local function grid(f, cols, rows)
		for i = 1, cols - 1 do K.line(f, 0.12 + 0.76 * i / cols, 0.1, 0.12 + 0.76 * i / cols, 0.9, 0.018) end
		for j = 1, rows - 1 do
			local y = 0.1 + 0.8 * j / rows
			f:Poly({ { 0.12, y }, { 0.5, y + 0.04 }, { 0.88, y } }, 0.018, INK)
		end
	end
	local function spider(f, cx, cy, s)
		K.shape(f, cx, cy - 0.06 * s, 0.07 * s, 0.09 * s, INK, { round = 0.5, ink = 1 })
		K.shape(f, cx, cy + 0.07 * s, 0.1 * s, 0.18 * s, INK, { round = 0.5, ink = 1 })
		for _, sx in { -1, 1 } do
			for k, l in { { -0.07, -0.2, -0.3 }, { -0.03, -0.25, -0.1 }, { 0.03, -0.25, 0.12 }, { 0.08, -0.2, 0.32 } } do
				local kx, ky = cx + sx * 0.16 * s, cy + l[2] * 0.5 * s + k * 0.02 * s
				local ex, ey = cx + sx * (0.2 + k * 0.02) * s, cy + l[3] * s
				f:Poly({ { cx + sx * 0.03 * s, cy + l[1] * s }, { kx, ky }, { ex, ey } }, 0.016 * s, INK)
			end
		end
	end
	local function draw(part, face, f)
		if part == "Head" then
			K.cut(f, 0.5, 0.5, 0.9, 0.9, red, { round = 0.5, ink = 6 })
			K.web(f, 0.5, face == "Front" and 0.56 or 0.5, 0.4, 10, 3, 0.012, 1)
			if face == "Front" then
				for _, x in { -1, 1 } do
					K.shape(f, 0.5 + x * 0.19, 0.44, 0.3, 0.21, white, { round = 0.5, rot = x * -24, ink = 9, z = 80 })
				end
			end
		elseif part == "UpperTorso" then
			K.cut(f, 0.5, 0.5, 0.92, 0.92, blue, { round = 0.3, ink = 5 })
			local back = face == "Back"
			K.shape(f, 0.5, back and 0.47 or 0.44, back and 0.66 or 0.56, back and 0.84 or 0.8, red, { round = 0.35, ink = 2 })
			K.web(f, 0.5, back and 0.42 or 0.4, back and 0.36 or 0.32, 10, 3, 0.01)
			spider(f, 0.5, 0.42, back and 1.5 or 0.95)
		elseif part == "LowerTorso" then
			K.cut(f, 0.5, 0.5, 0.92, 0.84, red, { round = 0.45, ink = 4 })
			grid(f, 6, 2)
		elseif part:find("UpperArm") or part:find("UpperLeg") then
			K.cut(f, 0.5, 0.5, 0.86, 0.92, blue, { round = 0.45, ink = 4 })
		elseif part:find("LowerArm") or part:find("LowerLeg") then
			K.cut(f, 0.5, 0.5, 0.86, 0.94, red, { round = 0.45, ink = 4 })
			grid(f, 3, 4)
		elseif part:find("Hand") then
			K.cut(f, 0.5, 0.5, 0.86, 0.86, red, { round = 0.5, ink = 4 })
			grid(f, 3, 2)
		elseif part:find("Foot") then
			K.cut(f, 0.5, 0.48, 0.9, 0.8, red, { round = 0.45, ink = 4 })
			grid(f, 4, 2)
			f:Box(0.5, 0.84, 0.82, 0.12, blue, { round = 0.5, stroke = 3, strokeColor = INK, z = 60 })
		end
	end
	return {
		cards = {
			Head = { w = 2.6, h = 2.6, y = 0.55 },
			LeftHand = { w = 0.75, h = 0.75, y = -0.15 }, RightHand = { w = 0.75, h = 0.75, y = -0.15 },
			LeftFoot = { w = 1.0, h = 0.6, y = 0.05 }, RightFoot = { w = 1.0, h = 0.6, y = 0.05 },
		},
		draw = draw,
	}
end
