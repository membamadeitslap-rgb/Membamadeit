-- Paper Mario style Cyclops (X-Men '97): athletic leader build, blue suit, yellow X harness with a center ring,
-- yellow gloves/boots with flared cuffs, belt with the red X buckle, blue cowl over a strong jaw, brown hair
-- spiking out the top, gold wraparound visor with the ruby lens and ear pods.
return function(skin, rarity, K)
	local blue, gold = skin.Primary, skin.Secondary
	local INK = K.INK
	local SKIN, HAIR, RUBY = Color3.fromRGB(236, 190, 150), Color3.fromRGB(120, 70, 40), Color3.fromRGB(225, 30, 45)
	local function band(f, y, h, color)
		f:Box(0.5, y, 0.9, h, color, { round = 0.3, stroke = 3, strokeColor = INK, z = 40 })
	end
	local function draw(part, face, f)
		local back = face == "Back"
		if part == "Head" then
			if back then
				K.union(f, { { 0.5, 0.38, 0.86, 0.62, 0.5 }, { 0.5, 0.62, 0.72, 0.42, 0.45 }, { 0.5, 0.86, 0.34, 0.24, 0.3 } }, blue, { ink = 0.028 })
			else
				-- skin face, then the cowl over the top and down the cheeks
				K.union(f, { { 0.5, 0.42, 0.8, 0.6, 0.5 }, { 0.5, 0.64, 0.66, 0.4, 0.45 }, { 0.5, 0.78, 0.46, 0.24, 0.5 }, { 0.5, 0.92, 0.32, 0.18, 0.3 } }, SKIN, { ink = 0.028 })
				K.union(f, { { 0.5, 0.3, 0.86, 0.46, 0.5 }, { 0.17, 0.55, 0.2, 0.42, 0.5 }, { 0.83, 0.55, 0.2, 0.42, 0.5 } }, blue, { border = false, ink = 0.02, z = 20 })
				K.line(f, 0.5, 0.56, 0.47, 0.64, 0.01) -- nose
				K.line(f, 0.42, 0.74, 0.58, 0.73, 0.014) -- set, serious mouth
				K.line(f, 0.46, 0.82, 0.54, 0.82, 0.008) -- chin cleft
			end
			for i = -3, 3 do -- brown hair spiking up out of the cowl
				f:Box(0.5 + i * 0.09, 0.07 + math.abs(i) * 0.015, 0.1, 0.18, HAIR, { round = 0.3, rot = i * 14, stroke = 2, strokeColor = INK, z = 5 })
			end
			-- wraparound gold visor with ruby lens, round ear pods
			f:Box(0.5, 0.42, 0.9, 0.17, gold, { round = 0.5, stroke = 4, strokeColor = INK, z = 60 })
			if not back then
				f:Box(0.5, 0.42, 0.72, 0.085, RUBY, { round = 0.5, stroke = 2, strokeColor = INK, z = 61 })
				f:Box(0.38, 0.405, 0.2, 0.022, Color3.fromRGB(255, 170, 170), { round = 0.5, z = 62 }) -- lens glint
			end
			for _, x in { 0.06, 0.94 } do f:Circle(x, 0.43, 0.075, gold, { stroke = 3, strokeColor = INK, z = 63 }) end
		elseif part == "UpperTorso" then
			K.union(f, { { 0.5, 0.2, 0.98, 0.36, 0.45 }, { 0.5, 0.42, 0.8, 0.34, 0.35 }, { 0.5, 0.62, 0.62, 0.34, 0.3 }, { 0.5, 0.82, 0.52, 0.32, 0.25 } }, blue)
			-- yellow X harness: straps from each shoulder crossing at a ring mid-chest
			for _, x in { -1, 1 } do
				f:Line(0.5 + x * 0.38, 0.06, 0.5 - x * 0.22, 0.95, 0.09, INK, { z = 30 })
				f:Line(0.5 + x * 0.38, 0.06, 0.5 - x * 0.22, 0.95, 0.065, gold, { z = 31 })
			end
			f:Circle(0.5, 0.43, 0.07, gold, { stroke = 4, strokeColor = INK, z = 32 })
			f:Circle(0.5, 0.43, 0.035, blue, { stroke = 2, strokeColor = INK, z = 33 })
			if not back then K.line(f, 0.5, 0.6, 0.5, 0.82, 0.008, { z = 25 }) end -- ab line under the harness
		elseif part == "LowerTorso" then
			K.union(f, { { 0.5, 0.5, 0.86, 0.86, 0.4 } }, gold, { ink = 0.05 })
			if not back then
				f:Circle(0.5, 0.5, 0.33, RUBY, { stroke = 3, strokeColor = INK, z = 50 })
				f:Text("X", 0.5, 0.5, 0.18, 0.6, gold, { z = 51 })
			end
		elseif part:find("UpperArm") then
			K.union(f, { { 0.5, 0.5, 0.82, 0.92, 0.5 } }, blue)
			band(f, 0.45, 0.14, gold)
		elseif part:find("LowerArm") then
			K.union(f, { { 0.5, 0.36, 0.84, 0.62, 0.5 }, { 0.5, 0.7, 0.66, 0.56, 0.5 } }, blue)
			-- yellow glove with flared cuff up the forearm
			f:Box(0.5, 0.74, 0.7, 0.5, gold, { round = 0.4, stroke = 3, strokeColor = INK, z = 40 })
			f:Box(0.5, 0.5, 0.92, 0.16, gold, { round = 0.3, stroke = 3, strokeColor = INK, z = 41 })
		elseif part:find("Hand") then
			K.union(f, { { 0.5, 0.52, 0.86, 0.74, 0.45 }, { part:find("Left") and 0.84 or 0.16, 0.42, 0.3, 0.4, 0.5 } }, gold)
		elseif part:find("UpperLeg") then
			K.union(f, { { 0.5, 0.36, 0.92, 0.68, 0.45 }, { 0.5, 0.72, 0.74, 0.56, 0.45 } }, blue)
			band(f, 0.32, 0.12, gold)
			if not back then f:Box(part:find("Left") and 0.74 or 0.26, 0.48, 0.26, 0.2, gold, { round = 0.25, stroke = 3, strokeColor = INK, z = 45 }) end -- thigh pouch
		elseif part:find("LowerLeg") then
			K.union(f, { { 0.5, 0.34, 0.82, 0.62, 0.45 }, { 0.5, 0.72, 0.64, 0.58, 0.4 } }, gold)
			f:Box(0.5, 0.12, 0.98, 0.2, gold, { round = 0.3, stroke = 3, strokeColor = INK, z = 41 }) -- flared boot top
			K.line(f, 0.5, 0.3, 0.5, 0.9, 0.012, { color = gold:Lerp(INK, 0.35) })
		elseif part:find("Foot") then
			K.union(f, { { 0.5, 0.42, 0.86, 0.7, 0.45 } }, gold)
			f:Box(0.5, 0.82, 0.86, 0.14, Color3.fromRGB(60, 50, 40), { round = 0.5, stroke = 3, strokeColor = INK, z = 60 })
		end
	end
	return {
		cards = {
			Head = { w = 1.55, h = 2.05, y = 0.2 },
			UpperTorso = { sw = 1.08, sh = 1.2, y = 0.02 },
			LowerTorso = { sw = 0.8, sh = 1.6, z = 0.012 },
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
