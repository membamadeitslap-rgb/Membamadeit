-- Deathstroke (Slade Wilson). Classic: dark blue scale-mail bodysuit, full-head mask split down the middle (black over his
-- lost right eye, orange with the single eye hole on his left), orange flared gauntlets + boots, gray belt with pouches,
-- shoulder-to-hip sword strap and an empty scabbard on the back (katana in hand, power staff in the other).
-- Variant flags (SkinData/Deathstroke): Mask (orange half), MaskDark (black half), Suit, Accent (gloves/boots), Armor (plate color),
-- Trim (armor stripes), Belt, Holster.
-- Costume module: return function(s, H, rarity) -> { colors = { group = Color3 }, pieces = { ... } }
return function(s, H, rarity)
	local C, WHITE = H.C, H.WHITE
	local piece, round, band, ring, find, chestOf, waistOf, front = H.piece, H.round, H.band, H.ring, H.find, H.chestOf, H.waistOf, H.front
	local V, CF, rad = Vector3.new, CFrame.new, math.rad
	local function each(m, names, fn) for _, n in names do local a = m:FindFirstChild(n); if a then fn(a, n:find("Left") and -1 or 1) end end end
	local mask, maskDark = s.Mask or s.Primary, s.MaskDark or C(22, 22, 26)
	local suit, accent = s.Suit or s.Secondary, s.Accent or s.Primary
	local armor, trim = s.Armor, s.Trim or accent
	local beltC = s.Belt or C(70, 70, 78)
	local metal = Enum.Material.Metal

	local pieces = {
		function(m) -- split mask: congruent ellipsoids offset along X meet on the center plane
			local hd = find(m, "Head"); if not hd then return end
			local sz = hd.Size
			local d = 0.03
			round(m, hd, "MaskOrange", V(sz.X * 1.1, sz.Y * 1.1, sz.Z * 1.12), CF(-d, sz.Y * 0.02, 0), mask)
			round(m, hd, "MaskBlack", V(sz.X * 1.1, sz.Y * 1.1, sz.Z * 1.12), CF(d, sz.Y * 0.02, 0), maskDark)
			local fz = -sz.Z * 0.56
			-- single eye hole on his left (-X): dark socket + white lens
			round(m, hd, "EyeHole", V(sz.X * 0.3, sz.Y * 0.15, 0.08), CF(-sz.X * 0.2, sz.Y * 0.08, fz + 0.03) * CFrame.Angles(0, rad(-18), rad(8)), C(15, 15, 18))
			round(m, hd, "EyeLens", V(sz.X * 0.2, sz.Y * 0.08, 0.06), CF(-sz.X * 0.205, sz.Y * 0.08, fz) * CFrame.Angles(0, rad(-18), rad(8)), C(235, 235, 230))
			-- molded brow ridge + nose bridge + ear discs
			for _, x in { -1, 1 } do
				piece(m, hd, "Brow", V(sz.X * 0.32, sz.Y * 0.05, 0.08), CF(x * sz.X * 0.2, sz.Y * 0.2, fz + 0.04) * CFrame.Angles(0, rad(x * 18), rad(x * 10)), x < 0 and mask:Lerp(C(0, 0, 0), 0.2) or C(35, 35, 40))
				band(m, hd, "EarDisc", sz.Y * 0.32, 0.08, CF(x * sz.X * 0.56, sz.Y * 0.0, sz.Z * 0.04) * CFrame.Angles(0, 0, rad(90)), x < 0 and mask:Lerp(C(0, 0, 0), 0.25) or C(40, 40, 45), metal)
			end
			piece(m, hd, "Seam", V(0.05, sz.Y * 0.9, 0.06), CF(0, sz.Y * 0.0, fz + 0.01), C(15, 15, 18))
			round(m, hd, "Nose", V(sz.X * 0.12, sz.Y * 0.18, 0.12), CF(0, -sz.Y * 0.08, fz + 0.01), maskDark:Lerp(mask, 0.5))
			round(m, hd, "Mouthguard", V(sz.X * 0.42, sz.Y * 0.06, 0.06), CF(0, -sz.Y * 0.3, fz + 0.035), C(15, 15, 18))
		end,
		function(m) -- flared gauntlet + boot tops
			each(m, { "LeftLowerArm", "RightLowerArm" }, function(a)
				round(m, a, "GauntletFlare", V(a.Size.X * 1.35, a.Size.Y * 0.32, a.Size.Z * 1.35), CF(0, a.Size.Y * 0.3, 0), accent)
			end)
			each(m, { "LeftLowerLeg", "RightLowerLeg" }, function(a)
				round(m, a, "BootFlare", V(a.Size.X * 1.3, a.Size.Y * 0.32, a.Size.Z * 1.3), CF(0, a.Size.Y * 0.36, 0), accent)
			end)
		end,
		function(m) -- utility belt: segmented ring, buckle, rounded pouches
			local w = waistOf(m); if not w then return end
			local l = w.Size
			ring(m, w, "Belt", l.X * 0.53, l.Z * 0.56, 0.26, 0.1, CF(0, l.Y * 0.15, 0), beltC, Enum.Material.Leather, 12)
			piece(m, w, "Buckle", V(l.X * 0.2, 0.3, 0.1), CF(0, l.Y * 0.15, -l.Z * 0.6), accent, metal)
			for _, a in { 50, 85, 120, 240, 275, 310 } do
				local r = rad(a)
				piece(m, w, "Pouch", V(0.26, 0.3, 0.16), CF(math.sin(r) * l.X * 0.56, l.Y * 0.05, -math.cos(r) * l.Z * 0.6) * CFrame.Angles(0, -r, 0), beltC:Lerp(C(0, 0, 0), 0.25), Enum.Material.Leather)
			end
		end,
		function(m) -- sword strap over the right shoulder + scabbard across the back
			local t = chestOf(m); if not t then return end
			local sz = t.Size
			local diag = math.sqrt((sz.X * 0.75) ^ 2 + sz.Y ^ 2)
			local ang = math.atan2(sz.X * 0.75, sz.Y)
			piece(m, t, "Strap", V(sz.X * 0.11, diag, 0.07), CF(0, -sz.Y * 0.02, front(t, 0.0)) * CFrame.Angles(0, 0, -ang), beltC, Enum.Material.Leather)
			piece(m, t, "StrapBack", V(sz.X * 0.11, diag, 0.07), CF(0, -sz.Y * 0.02, sz.Z / 2 + 0.03) * CFrame.Angles(0, 0, ang), beltC, Enum.Material.Leather)
			piece(m, t, "StrapTop", V(sz.X * 0.12, 0.07, sz.Z * 1.06), CF(sz.X * 0.3, sz.Y * 0.5, 0), beltC, Enum.Material.Leather)
			local sc = piece(m, t, "Scabbard", V(0.2, sz.Y * 1.7, 0.16), CF(sz.X * 0.05, -sz.Y * 0.05, sz.Z / 2 + 0.16) * CFrame.Angles(0, 0, rad(-35)), C(28, 28, 32))
			piece(m, sc, "Throat", V(0.26, 0.14, 0.22), CF(0, sc.Size.Y / 2, 0), accent, metal)
			piece(m, sc, "Chape", V(0.26, 0.14, 0.22), CF(0, -sc.Size.Y / 2, 0), accent, metal)
		end,
	}
	if armor then -- modern armor: chest plate, ab plates, layered pauldrons, shin guards, thigh holster
		table.insert(pieces, function(m)
			local t = chestOf(m)
			if t then
				local sz = t.Size
				for _, x in { -1, 1 } do
					round(m, t, "ChestPlate", V(sz.X * 0.5, sz.Y * 0.42, sz.Z * 0.26), CF(x * sz.X * 0.21, sz.Y * 0.22, -sz.Z * 0.42) * CFrame.Angles(0, rad(x * 12), 0), armor, metal)
					piece(m, t, "PlateTrim", V(sz.X * 0.3, 0.06, 0.05), CF(x * sz.X * 0.22, sz.Y * 0.03, front(t, 0.04)) * CFrame.Angles(0, 0, rad(x * -10)), trim)
				end
				for k = 0, 1 do for _, x in { -1, 1 } do
					piece(m, t, "AbPlate", V(sz.X * 0.16, sz.Y * 0.13, 0.06), CF(x * sz.X * 0.095, -sz.Y * (0.1 + k * 0.16), front(t, 0.0)), armor, metal)
				end end
			end
			each(m, { "LeftUpperArm", "RightUpperArm" }, function(a, x)
				local s2 = a.Size
				round(m, a, "Pauldron", V(s2.X * 1.45, s2.Y * 0.7, s2.Z * 1.35), CF(x * s2.X * 0.08, s2.Y * 0.4, 0), armor, metal)
				band(m, a, "PauldronStripe", s2.X * 1.3, 0.06, CF(x * s2.X * 0.06, s2.Y * 0.62, 0) * CFrame.Angles(0, 0, rad(x * -12)), trim)
			end)
			each(m, { "LeftLowerLeg", "RightLowerLeg" }, function(a)
				round(m, a, "ShinGuard", V(a.Size.X * 0.7, a.Size.Y * 0.75, a.Size.Z * 0.35), CF(0, a.Size.Y * 0.0, -a.Size.Z * 0.37), armor, metal)
				round(m, a, "KneeCap", V(a.Size.X * 0.55, a.Size.Y * 0.24, a.Size.Z * 0.3), CF(0, a.Size.Y * 0.45, -a.Size.Z * 0.4), trim, metal)
			end)
			each(m, { "LeftLowerArm", "RightLowerArm" }, function(a)
				round(m, a, "Vambrace", V(a.Size.X * 1.12, a.Size.Y * 0.6, a.Size.Z * 1.12), CF(0, -a.Size.Y * 0.05, 0), armor, metal)
			end)
			local leg = m:FindFirstChild("RightUpperLeg")
			if leg then -- pistol in a thigh holster
				local hs = piece(m, leg, "Holster", V(0.18, leg.Size.Y * 0.5, leg.Size.Z * 0.5), CF(leg.Size.X * 0.55, -leg.Size.Y * 0.05, 0), C(30, 30, 33), Enum.Material.Leather)
				piece(m, hs, "PistolGrip", V(0.14, 0.3, 0.16), CF(0, hs.Size.Y * 0.6, 0.06) * CFrame.Angles(rad(-15), 0, 0), C(20, 20, 22), metal)
				band(m, leg, "HolsterStrap", leg.Size.X * 1.08, 0.08, CF(0, -leg.Size.Y * 0.15, 0), C(30, 30, 33))
			end
		end)
	end
	local colors = { Head = maskDark, Chest = suit, Waist = suit, Arms = suit, Gloves = accent, Legs = suit, Boots = accent }
	return { colors = colors, pieces = pieces }
end
