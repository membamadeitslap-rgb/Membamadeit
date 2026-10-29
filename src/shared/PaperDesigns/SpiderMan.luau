-- Paper Mario style Spider-Man, Ultimate Spider-Man build. Six paper pieces like a real puppet: head, torso
-- (chest to hips), and each whole arm / leg drawn in one piece, each with one ink outline, a white paper border and
-- cel shading. Joints still bend the pieces at the shoulders/hips for animation.
return function(skin, rarity, K)
	local red, blue = skin.Primary, skin.Secondary
	local white = Color3.fromRGB(250, 250, 250)
	local INK = K.INK
	local function grid(f, x0, x1, cols, y0, y1, rows, t)
		for i = 1, cols - 1 do local x = x0 + (x1 - x0) * i / cols; K.line(f, x, y0, x, y1, t or 0.006, { z = 30 }) end
		for j = 1, rows - 1 do
			local y = y0 + (y1 - y0) * j / rows
			f:Poly({ { x0, y }, { (x0 + x1) / 2, y + 0.012 }, { x1, y } }, t or 0.006, INK, { z = 30 })
		end
	end
	local function spider(f, cx, cy, s)
		local ar = f.h / f.w
		f:Circle(cx, cy - 0.04 * s, 0.028 * s, INK, { z = 60 })
		f:Box(cx, cy + 0.05 * s, 0.06 * s * ar * 1.6, 0.11 * s, INK, { round = 0.5, z = 60 })
		for _, sx in { -1, 1 } do
			for _, l in {
				{ { 0.02, -0.05 }, { 0.14, -0.17 }, { 0.3, -0.22 } },
				{ { 0.02, -0.02 }, { 0.2, -0.07 }, { 0.36, -0.05 } },
				{ { 0.02, 0.03 }, { 0.2, 0.08 }, { 0.32, 0.22 } },
				{ { 0.02, 0.07 }, { 0.12, 0.2 }, { 0.2, 0.36 } },
			} do
				local pts = {}
				for _, q in l do table.insert(pts, { cx + sx * q[1] * s * ar * 1.4, cy + q[2] * s }) end
				f:Poly(pts, 0.012 * s, INK, { cap = true, z = 60 })
			end
		end
	end

	local HEAD = { { 0.5, 0.36, 0.84, 0.62, 0.5 }, { 0.5, 0.56, 0.74, 0.42, 0.45 }, { 0.5, 0.72, 0.52, 0.3, 0.5 }, { 0.5, 0.9, 0.3, 0.2, 0.3 } }
	local TORSO = { { 0.5, 0.15, 0.98, 0.28, 0.45 }, { 0.5, 0.33, 0.82, 0.28, 0.35 }, { 0.5, 0.5, 0.64, 0.28, 0.3 }, { 0.5, 0.66, 0.54, 0.26, 0.25 }, { 0.5, 0.86, 0.6, 0.26, 0.4 } }
	local CHEST = { { 0.5, 0.16, 0.9, 0.24, 0.45 }, { 0.5, 0.34, 0.6, 0.26, 0.3 }, { 0.5, 0.52, 0.42, 0.26, 0.25 }, { 0.5, 0.67, 0.38, 0.2, 0.2 } }
	local ARM = { { 0.5, 0.27, 0.84, 0.42, 0.5 }, { 0.5, 0.6, 0.7, 0.4, 0.5 }, { 0.5, 0.86, 0.86, 0.15, 0.45 } }
	local LEG = { { 0.5, 0.21, 0.92, 0.44, 0.45 }, { 0.5, 0.6, 0.72, 0.44, 0.45 }, { 0.5, 0.92, 0.86, 0.14, 0.45 } }

	local function draw(part, face, f)
		local back = face == "Back"
		if part == "Head" then
			K.union(f, HEAD, red, { ink = 0.028 })
			K.shade(f, { { 0.5, 0.42, 0.8, 0.72, 0.5 } }, red, { amount = 0.18 })
			K.web(f, 0.5, back and 0.42 or 0.5, back and 0.3 or 0.33, 12, 4, 0.0075, (f.h / f.w) * 0.82)
			if not back then
				for _, x in { -1, 1 } do
					local cx = 0.5 + x * 0.19
					f:Box(cx, 0.46, 0.38, 0.27, INK, { round = 0.3, rot = x * -30, z = 500 })
					f:Box(cx + x * 0.006, 0.462, 0.27, 0.165, white, { round = 0.3, rot = x * -30, z = 501 })
					f:Box(cx + x * 0.06, 0.43, 0.08, 0.03, Color3.fromRGB(255, 255, 255), { round = 0.5, rot = x * -30, z = 502 })
				end
			end
		elseif part == "UpperTorso" then -- whole torso: V chest down to the belt line
			K.union(f, TORSO, blue)
			K.shade(f, { { 0.5, 0.45, 0.7, 0.78, 0.35 } }, blue, { amount = 0.2 })
			K.union(f, CHEST, red, { border = false, ink = 0.01, z = 20 })
			K.union(f, { { 0.5, 0.84, 0.6, 0.12, 0.4 } }, red, { border = false, ink = 0.01, z = 20 }) -- belt
			K.web(f, 0.5, back and 0.34 or 0.3, back and 0.28 or 0.25, 10, 3, 0.006, (f.h / f.w) * 0.95)
			grid(f, 0.22, 0.78, 8, 0.79, 0.89, 2)
			spider(f, 0.5, back and 0.36 or 0.3, back and 1.25 or 0.9)
			if not back then K.line(f, 0.5, 0.48, 0.5, 0.68, 0.005, { z = 40 }) end
		elseif part:find("UpperArm") then -- whole arm: blue upper arm with red shoulder cap, red webbed forearm + fist
			K.union(f, ARM, blue)
			K.union(f, { { 0.5, 0.15, 0.82, 0.16, 0.5 }, { 0.5, 0.62, 0.7, 0.36, 0.5 }, { 0.5, 0.86, 0.86, 0.15, 0.45 } }, red, { border = false, ink = 0.008, z = 20 })
			K.shade(f, { { 0.5, 0.3, 0.78, 0.36, 0.5 } }, blue, { amount = 0.2, z = 15 })
			grid(f, 0.2, 0.8, 3, 0.45, 0.92, 7)
		elseif part:find("UpperLeg") then -- whole leg: blue thigh, red webbed shin, red boot with blue sole
			K.union(f, LEG, blue)
			K.union(f, { { 0.5, 0.62, 0.72, 0.42, 0.45 }, { 0.5, 0.92, 0.86, 0.14, 0.45 } }, red, { border = false, ink = 0.008, z = 20 })
			K.shade(f, { { 0.5, 0.22, 0.86, 0.4, 0.45 } }, blue, { amount = 0.2, z = 15 })
			grid(f, 0.2, 0.8, 3, 0.42, 0.96, 7)
			f:Box(0.5, 0.985, 0.86, 0.03, blue, { round = 0.5, stroke = 2, strokeColor = INK, z = 70 })
		end
	end
	local arm = { sw = 1.5, sh = 1.2, y = 0.12, span = { "UpperArm", "LowerArm", "Hand" }, z = -0.04 }
	local leg = { sw = 1.3, span = { "UpperLeg", "LowerLeg", "Foot" }, z = 0.02 }
	local function side(t, s)
		local c = table.clone(t); c.span = {}
		for i, n in t.span do c.span[i] = s .. n end
		return c
	end
	return {
		cards = {
			Head = { w = 1.55, h = 2.05, y = 0.2 },
			UpperTorso = { sw = 1.08, span = { "UpperTorso", "LowerTorso" }, sh = 1.08 },
			LowerTorso = { skip = true },
			LeftUpperArm = side(arm, "Left"), RightUpperArm = side(arm, "Right"),
			LeftLowerArm = { skip = true }, RightLowerArm = { skip = true }, LeftHand = { skip = true }, RightHand = { skip = true },
			LeftUpperLeg = side(leg, "Left"), RightUpperLeg = side(leg, "Right"),
			LeftLowerLeg = { skip = true }, RightLowerLeg = { skip = true }, LeftFoot = { skip = true }, RightFoot = { skip = true },
		},
		draw = draw,
	}
end
