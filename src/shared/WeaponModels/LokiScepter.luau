-- Weapon model builder: return function(m, H) that builds parts into model m around a "Grip" part (the hand).
-- H = helpers from Weapons.luau: p(model, name, size, cframe, color, mat, shape), round(...) ellipsoid, C, cyl, up, wedge(part), katana(...)
-- Long/bladed weapons name their main part "Blade" (tip toward +Y) so the swing trails attach to it.
-- Loki's Chitauri scepter: long gold shaft with ribbed collars and a spiked pommel, a silver cage holding the blue Mind Stone,
-- a long curved blade sweeping up off the head and a short hooked prong on the opposite side.
return function(m, H)
	local p, C, cyl, up, round = H.p, H.C, H.cyl, H.up, H.round
	local GOLD, SILVER, DARK = C(214, 172, 62), C(200, 204, 214), C(60, 50, 40)
	local GEM = C(70, 170, 255)
	round(m, "Grip", Vector3.new(0.17, 0.5, 0.17), CFrame.new(), DARK, Enum.Material.Leather)
	p(m, "Blade", Vector3.new(3.0, 0.15, 0.15), CFrame.new(0, 1.2, 0) * up, GOLD, Enum.Material.Metal, cyl) -- upper shaft
	p(m, "Shaft", Vector3.new(0.95, 0.15, 0.15), CFrame.new(0, -0.75, 0) * up, GOLD, Enum.Material.Metal, cyl)
	for _, y in { -1.25, 0.35, 2.55 } do p(m, "Collar", Vector3.new(0.12, 0.24, 0.24), CFrame.new(0, y, 0) * up, GOLD, Enum.Material.Metal, cyl) end
	round(m, "Pommel", Vector3.new(0.26, 0.5, 0.26), CFrame.new(0, -1.45, 0), GOLD, Enum.Material.Metal)
	round(m, "PommelTip", Vector3.new(0.12, 0.4, 0.12), CFrame.new(0, -1.75, 0), SILVER, Enum.Material.Metal)
	-- head: flared socket, silver cage of four curved prongs around the gem
	round(m, "Socket", Vector3.new(0.32, 0.45, 0.32), CFrame.new(0, 2.78, 0), GOLD, Enum.Material.Metal)
	local gem = round(m, "Gem", Vector3.new(0.36, 0.42, 0.36), CFrame.new(0, 3.15, 0), GEM, Enum.Material.Glass)
	local l = Instance.new("PointLight"); l.Color = GEM; l.Range = 6; l.Brightness = 1.5; l.Parent = gem
	for i = 0, 3 do
		local a = i * math.pi / 2 + math.pi / 4
		local dir = Vector3.new(math.cos(a), 0, math.sin(a))
		local base = Vector3.new(0, 2.95, 0) + dir * 0.2
		local top = Vector3.new(0, 3.38, 0) + dir * 0.1
		local mid = (base + top) / 2 + dir * 0.08
		p(m, "Cage", Vector3.new(0.06, 0.5, 0.06), CFrame.lookAt(mid, mid + (top - base)) * CFrame.Angles(-math.pi / 2, 0, 0), SILVER, Enum.Material.Metal)
	end
	-- long curved blade: rises from the head, bows forward (-Z), tip up
	local pts = { Vector3.new(0, 3.3, -0.05), Vector3.new(0, 3.7, -0.22), Vector3.new(0, 4.1, -0.3), Vector3.new(0, 4.45, -0.25), Vector3.new(0, 4.75, -0.1) }
	for i = 1, #pts - 1 do
		local a, b = pts[i], pts[i + 1]
		local w = 0.3 - i * 0.05
		p(m, "BladeArc", Vector3.new(0.05, (b - a).Magnitude + 0.06, w), CFrame.lookAt((a + b) / 2, b) * CFrame.Angles(-math.pi / 2, 0, 0) * CFrame.new(0, 0, -w * 0.3), SILVER, Enum.Material.Metal)
	end
	-- short hooked back prong
	p(m, "Prong", Vector3.new(0.05, 0.6, 0.16), CFrame.new(0, 3.15, 0.32) * CFrame.Angles(math.rad(-40), 0, 0), SILVER, Enum.Material.Metal)
	p(m, "ProngHook", Vector3.new(0.05, 0.3, 0.12), CFrame.new(0, 3.4, 0.55) * CFrame.Angles(math.rad(25), 0, 0), SILVER, Enum.Material.Metal)
	-- authored at 1.6x: scale the whole scepter to ~3.9 studs (about 70% of Loki's height)
	local k = 0.6
	for _, x in m:GetChildren() do
		if x:IsA("BasePart") and x.Name ~= "Grip" then x.Size *= k; x.CFrame = CFrame.new(x.CFrame.Position * k) * x.CFrame.Rotation end
	end
end
