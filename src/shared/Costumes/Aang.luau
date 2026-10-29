-- Aang (Avatar): bald head with the blue airbender arrow (forehead, crown, back of head) + arrows on the hands and forearms,
-- yellow shirt and pants, orange shawl cape with collar and chest drape, sash belt, ankle wraps, brown shoes.
-- Costume module: return function(s, H, rarity) -> { colors = { group = Color3 }, pieces = { { "Piece", args... } | function(m) end } }
-- s = skin variant (Name, Primary = shirt/pants, Secondary = shawl, Headband, Hair, Glow, Goatee, Ghost...), H = shared helpers, rarity = tier name
return function(s, H, rarity)
	local C, SKIN, GOLD, WHITE = H.C, H.SKIN, H.GOLD, H.WHITE
	local piece, find, chestOf, waistOf, front, glyph = H.piece, H.find, H.chestOf, H.waistOf, H.front, H.glyph
	local function each(m, names, fn) for _, n in names do local a = m:FindFirstChild(n); if a then fn(a, n:find("Left") and -1 or 1) end end end
	local skin = s.Ghost and C(190, 225, 245) or C(245, 205, 165)
	local ink = s.Glow and C(215, 245, 255) or C(40, 120, 220)
	local pants = s.Pants or s.Primary
	local pieces = {
		{ "Face", C(110, 110, 125), C(70, 50, 35), s.Glow and "angry" or "grin" },
	}
	table.insert(pieces, function(m) -- the arrow: forehead arrowhead, stripe over the crown and down the back of the head
		local hd = find(m, "Head"); if not hd then return end
		local sz = hd.Size
		if not s.Headband then
			local tip = piece(m, hd, "ArrowHead", Vector3.new(sz.X * 0.34, sz.Y * 0.24, 0.04), CFrame.new(0, sz.Y * 0.25, -sz.Z * 0.52), ink); tip.Transparency = 1
			glyph(tip, Enum.NormalId.Front, "▼", ink)
			piece(m, hd, "ArrowFront", Vector3.new(sz.X * 0.12, sz.Y * 0.18, 0.03), CFrame.new(0, sz.Y * 0.42, -sz.Z * 0.505), ink)
		end
		if not s.Hair then
			piece(m, hd, "ArrowCrown", Vector3.new(sz.X * 0.12, 0.03, sz.Z * 1.02), CFrame.new(0, sz.Y * 0.505, 0), ink)
			piece(m, hd, "ArrowBack", Vector3.new(sz.X * 0.12, sz.Y * 0.95, 0.03), CFrame.new(0, 0, sz.Z * 0.505), ink)
		else -- Book 3: short dark hair grown in over the arrow
			piece(m, hd, "Hair", Vector3.new(sz.X * 1.05, sz.Y * 0.3, sz.Z * 1.05), CFrame.new(0, sz.Y * 0.4, sz.Z * 0.03), C(40, 30, 25))
			piece(m, hd, "HairBack", Vector3.new(sz.X * 1.05, sz.Y * 0.55, sz.Z * 0.2), CFrame.new(0, sz.Y * 0.12, sz.Z * 0.45), C(40, 30, 25))
		end
		if s.Headband then -- Fire Nation school disguise: red headband hides the arrow
			piece(m, hd, "Headband", Vector3.new(sz.X * 1.06, sz.Y * 0.16, sz.Z * 1.06), CFrame.new(0, sz.Y * 0.3, 0), C(170, 30, 30), Enum.Material.Fabric)
			for _, a in { -12, 12 } do piece(m, hd, "BandTail", Vector3.new(0.1, sz.Y * 0.5, 0.05), CFrame.new(a * 0.008, sz.Y * 0.08, sz.Z * 0.56) * CFrame.Angles(0, 0, math.rad(a)), C(170, 30, 30), Enum.Material.Fabric) end
		end
		if s.Goatee then -- Legend of Korra era: goatee + moustache
			piece(m, hd, "Goatee", Vector3.new(sz.X * 0.2, sz.Y * 0.22, 0.08), CFrame.new(0, -sz.Y * 0.42, -sz.Z * 0.52), C(60, 45, 35))
			for _, x in { -1, 1 } do piece(m, hd, "Moustache", Vector3.new(sz.X * 0.22, 0.05, 0.05), CFrame.new(x * sz.X * 0.12, -sz.Y * 0.22, -sz.Z * 0.54) * CFrame.Angles(0, 0, math.rad(x * -18)), C(60, 45, 35)) end
		end
		if s.Glow then -- Avatar State: eyes and arrows blaze white (bright SmoothPlastic, no Neon)
			for _, x in { -1, 1 } do piece(m, hd, "GlowEye", Vector3.new(sz.X * 0.18, sz.Y * 0.1, 0.03), CFrame.new(x * sz.X * 0.19, sz.Y * 0.06, -sz.Z * 0.505 - 0.015), C(235, 250, 255), Enum.Material.SmoothPlastic) end
			local l = Instance.new("PointLight"); l.Color = C(180, 230, 255); l.Range = 10; l.Brightness = 1.5; l.Parent = hd
		end
	end)
	table.insert(pieces, function(m) -- hand + forearm arrows (outer side)
		each(m, { "LeftLowerArm", "RightLowerArm", "LeftArm", "RightArm" }, function(a, side)
			piece(m, a, "ArmArrow", Vector3.new(0.03, a.Size.Y * 0.95, a.Size.Z * 0.18), CFrame.new(side * (a.Size.X / 2 + 0.015), 0, 0), ink)
		end)
		each(m, { "LeftHand", "RightHand" }, function(h, side)
			local g = piece(m, h, "HandArrow", Vector3.new(h.Size.Z * 0.9, h.Size.Y * 0.9, 0.03), CFrame.new(side * (h.Size.X / 2 + 0.02), 0, 0) * CFrame.Angles(0, math.rad(-side * 90), 0), ink); g.Transparency = 1
			glyph(g, Enum.NormalId.Front, "▼", ink)
		end)
	end)
	table.insert(pieces, function(m) -- orange shawl: collar ring, drape across the chest, short back cape
		local t = chestOf(m); if not t then return end
		local sz = t.Size
		local sh = s.Secondary
		piece(m, t, "ShawlCollar", Vector3.new(sz.X * 1.1, 0.28, sz.Z * 1.2), CFrame.new(0, sz.Y / 2 + 0.02, 0), sh, Enum.Material.Fabric)
		piece(m, t, "Neck", Vector3.new(sz.X * 0.34, 0.3, sz.Z * 0.6), CFrame.new(0, sz.Y / 2 + 0.05, 0), skin)
		local diag = math.sqrt((sz.X * 0.9) ^ 2 + (sz.Y * 0.9) ^ 2)
		piece(m, t, "Drape", Vector3.new(sz.X * 0.36, diag, 0.06), CFrame.new(sz.X * 0.04, -sz.Y * 0.02, front(t, 0.04)) * CFrame.Angles(0, 0, math.atan2(sz.X * 0.9, sz.Y * 0.9)), sh, Enum.Material.Fabric)
		piece(m, t, "DrapeEdge", Vector3.new(0.05, diag, 0.07), CFrame.new(sz.X * 0.04, -sz.Y * 0.02, front(t, 0.045)) * CFrame.Angles(0, 0, math.atan2(sz.X * 0.9, sz.Y * 0.9)) * CFrame.new(sz.X * 0.18, 0, 0), sh:Lerp(C(0, 0, 0), 0.25), Enum.Material.Fabric)
		local cape = piece(m, t, "BackCape", Vector3.new(sz.X * 1.05, sz.Y * (s.Goatee and 2.2 or 1.15), 0.1), CFrame.new(0, -sz.Y * (s.Goatee and 0.6 or 0.08), sz.Z / 2 + 0.08) * CFrame.Angles(math.rad(-4), 0, 0), sh, Enum.Material.Fabric)
		piece(m, cape, "CapeHem", Vector3.new(cape.Size.X * 1.01, 0.08, 0.11), CFrame.new(0, -cape.Size.Y / 2 + 0.04, 0), sh:Lerp(C(0, 0, 0), 0.25), Enum.Material.Fabric)
		for _, x in { -1, 1 } do
			piece(m, t, "ShawlShoulder", Vector3.new(sz.X * 0.36, 0.16, sz.Z * 1.15), CFrame.new(x * sz.X * 0.36, sz.Y / 2 - 0.02, 0) * CFrame.Angles(0, 0, math.rad(-x * 15)), sh, Enum.Material.Fabric)
		end
	end)
	table.insert(pieces, { "Belt", s.Secondary:Lerp(C(255, 220, 120), 0.3) })
	table.insert(pieces, function(m) -- loose sleeves, ankle wraps, brown shoes
		each(m, { "LeftUpperArm", "RightUpperArm" }, function(a)
			piece(m, a, "SleeveCuff", Vector3.new(a.Size.X * 1.15, 0.14, a.Size.Z * 1.15), CFrame.new(0, -a.Size.Y * 0.42, 0), s.Primary:Lerp(C(0, 0, 0), 0.12), Enum.Material.Fabric)
		end)
		each(m, { "LeftLowerLeg", "RightLowerLeg", "LeftLeg", "RightLeg" }, function(a)
			for k = 0, 2 do piece(m, a, "Wrap", Vector3.new(a.Size.X * 1.06, 0.1, a.Size.Z * 1.06), CFrame.new(0, -a.Size.Y * (0.18 + k * 0.1), 0) * CFrame.Angles(0, 0, math.rad(k % 2 == 0 and 6 or -6)), C(170, 140, 100), Enum.Material.Fabric) end
		end)
	end)
	if s.Ghost then
		table.insert(pieces, function(m)
			for _, p in m:GetDescendants() do if p:IsA("BasePart") and p.Name ~= "HumanoidRootPart" then p.Transparency = math.max(p.Transparency, 0.3) end end
		end)
	end
	return { colors = { Head = skin, Chest = s.Primary, Waist = pants, UpperArms = s.Primary, LowerArms = skin, Hands = skin, Legs = pants, Feet = C(110, 70, 40) },
		pieces = pieces }
end
