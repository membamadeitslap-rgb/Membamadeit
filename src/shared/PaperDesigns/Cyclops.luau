-- Paper Mario style Cyclops (X-Men '97). Six paper pieces like Spider-Man's: head, torso, whole arms, whole legs,
-- each one outline + paper border + cel shading. Blue suit, yellow X harness with the center ring, yellow gloves
-- and boots with flared cuffs, belt with the red X buckle, cowl over a strong jaw, brown hair, ruby visor.
return function(skin, rarity, K)
	local blue, gold = skin.Primary, skin.Secondary
	local INK = K.INK
	local SKIN, HAIR, RUBY = Color3.fromRGB(236, 190, 150), Color3.fromRGB(120, 70, 40), Color3.fromRGB(225, 30, 45)
	local HEAD = { { 0.5, 0.4, 0.82, 0.6, 0.5 }, { 0.5, 0.62, 0.68, 0.4, 0.45 }, { 0.5, 0.77, 0.48, 0.26, 0.5 }, { 0.5, 0.92, 0.3, 0.16, 0.3 } }
	local TORSO = { { 0.5, 0.15, 0.98, 0.28, 0.45 }, { 0.5, 0.33, 0.84, 0.28, 0.35 }, { 0.5, 0.5, 0.66, 0.28, 0.3 }, { 0.5, 0.66, 0.56, 0.26, 0.25 }, { 0.5, 0.86, 0.62, 0.26, 0.4 } }
	local ARM = { { 0.5, 0.27, 0.86, 0.42, 0.5 }, { 0.5, 0.6, 0.72, 0.4, 0.5 }, { 0.5, 0.86, 0.9, 0.16, 0.45 } }
	local LEG = { { 0.5, 0.21, 0.94, 0.44, 0.45 }, { 0.5, 0.6, 0.74, 0.44, 0.45 }, { 0.5, 0.92, 0.88, 0.14, 0.45 } }
	local function strap(f, x1, y1, x2, y2, w, z)
		f:Line(x1, y1, x2, y2, w + 0.02, INK, { z = z })
		f:Line(x1, y1, x2, y2, w, gold, { z = z + 1 })
	end
	local function draw(part, face, f)
		local back = face == "Back"
		if part == "Head" then
			if back then
				K.union(f, HEAD, blue, { ink = 0.028 })
				K.shade(f, { { 0.5, 0.45, 0.78, 0.7, 0.5 } }, blue)
			else
				K.union(f, HEAD, SKIN, { ink = 0.028 })
				K.shade(f, { { 0.5, 0.66, 0.6, 0.4, 0.5 } }, SKIN, { amount = 0.15 })
				-- cowl over the crown and down both cheeks, leaving the jaw bare
				K.union(f, { { 0.5, 0.3, 0.84, 0.44, 0.5 }, { 0.17, 0.56, 0.2, 0.42, 0.5 }, { 0.83, 0.56, 0.2, 0.42, 0.5 } }, blue, { border = false, ink = 0.018, z = 20 })
				K.shade(f, { { 0.5, 0.3, 0.8, 0.38, 0.5 } }, blue, { z = 30 })
				K.line(f, 0.51, 0.55, 0.47, 0.63, 0.01, { z = 40 }) -- nose
				K.line(f, 0.47, 0.64, 0.53, 0.64, 0.008, { z = 40 })
				f:Poly({ { 0.41, 0.73 }, { 0.5, 0.72 }, { 0.59, 0.73 } }, 0.014, INK, { z = 40 }) -- set, serious mouth
				K.line(f, 0.47, 0.83, 0.53, 0.83, 0.007, { z = 40 }) -- chin cleft
			end
			for i = -3, 3 do -- brown hair spiking up out of the cowl
				f:Box(0.5 + i * 0.085, 0.09 + math.abs(i) * 0.015, 0.1, 0.17, HAIR, { round = 0.3, rot = i * 14, stroke = 2, strokeColor = INK, z = 3 })
			end
			-- wraparound gold visor with the ruby lens, round ear pods
			f:Box(0.5, 0.43, 0.9, 0.16, gold, { round = 0.5, stroke = 4, strokeColor = INK, z = 500 })
			if not back then
				f:Box(0.5, 0.43, 0.72, 0.08, RUBY, { round = 0.5, stroke = 2, strokeColor = INK, z = 501 })
				f:Box(0.38, 0.416, 0.22, 0.02, Color3.fromRGB(255, 180, 180), { round = 0.5, z = 502 })
			end
			for _, x in { 0.07, 0.93 } do f:Circle(x, 0.44, 0.07, gold, { stroke = 3, strokeColor = INK, z = 503 }) end
		elseif part == "UpperTorso" then
			K.union(f, TORSO, blue)
			K.shade(f, { { 0.5, 0.45, 0.7, 0.78, 0.35 } }, blue, { amount = 0.2 })
			for _, x in { -1, 1 } do -- X harness, front and back, crossing at a ring
				strap(f, 0.5 + x * 0.38, 0.05, 0.5 - x * 0.18, 0.78, 0.05, 40)
			end
			f:Circle(0.5, 0.36, 0.055, gold, { stroke = 4, strokeColor = INK, z = 50 })
			f:Circle(0.5, 0.36, 0.026, blue, { stroke = 2, strokeColor = INK, z = 51 })
			-- belt with the red X buckle
			f:Box(0.5, 0.84, 0.64, 0.08, gold, { round = 0.4, stroke = 3, strokeColor = INK, z = 55 })
			if not back then
				f:Circle(0.5, 0.84, 0.055, RUBY, { stroke = 3, strokeColor = INK, z = 56 })
				f:Text("X", 0.5, 0.84, 0.1, 0.07, gold, { z = 57 })
			end
		elseif part:find("UpperArm") then -- blue arm, yellow band, yellow glove with a flared cuff
			K.union(f, ARM, blue)
			K.shade(f, { { 0.5, 0.3, 0.78, 0.36, 0.5 } }, blue, { z = 15 })
			f:Box(0.5, 0.32, 0.88, 0.07, gold, { round = 0.3, stroke = 3, strokeColor = INK, z = 30 })
			K.union(f, { { 0.5, 0.7, 0.7, 0.26, 0.45 }, { 0.5, 0.86, 0.86, 0.15, 0.45 } }, gold, { border = false, ink = 0.008, z = 35 })
			f:Box(0.5, 0.58, 0.92, 0.07, gold, { round = 0.3, stroke = 3, strokeColor = INK, z = 45 }) -- flared cuff
			K.shade(f, { { 0.5, 0.78, 0.74, 0.3, 0.45 } }, gold, { z = 46 })
		elseif part:find("UpperLeg") then -- blue thigh with band + pouch, yellow boot with flared top
			K.union(f, LEG, blue)
			K.shade(f, { { 0.5, 0.22, 0.86, 0.4, 0.45 } }, blue, { z = 15 })
			f:Box(0.5, 0.16, 0.94, 0.05, gold, { round = 0.3, stroke = 3, strokeColor = INK, z = 30 })
			if not back then f:Box(part:find("Left") and 0.72 or 0.28, 0.25, 0.3, 0.1, gold, { round = 0.25, stroke = 3, strokeColor = INK, z = 31 }) end
			K.union(f, { { 0.5, 0.66, 0.72, 0.34, 0.45 }, { 0.5, 0.92, 0.88, 0.14, 0.45 } }, gold, { border = false, ink = 0.008, z = 35 })
			f:Box(0.5, 0.49, 0.9, 0.06, gold, { round = 0.3, stroke = 3, strokeColor = INK, z = 45 }) -- flared boot top
			K.shade(f, { { 0.5, 0.72, 0.74, 0.4, 0.45 } }, gold, { z = 46 })
			f:Box(0.5, 0.985, 0.88, 0.03, Color3.fromRGB(60, 50, 40), { round = 0.5, stroke = 2, strokeColor = INK, z = 70 })
		end
	end
	local arm = { sw = 1.55, sh = 1.2, y = 0.12, span = { "UpperArm", "LowerArm", "Hand" }, z = -0.04 }
	local leg = { sw = 1.32, span = { "UpperLeg", "LowerLeg", "Foot" }, z = 0.02 }
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
