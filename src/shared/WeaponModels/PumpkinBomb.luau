-- Weapon model builder: return function(m, H) that builds parts into model m around a "Grip" part (the hand).
-- H = helpers from Weapons.luau: p(model, name, size, cframe, color, mat, shape), round(...) ellipsoid, C, cyl, up, wedge(part), katana(...)
-- Long/bladed weapons name their main part "Blade" (tip toward +Y) so the swing trails attach to it.
-- Goblin pumpkin bomb: ribbed orange jack-o'-lantern grenade (lobed body, stem, fuse cap) with a carved glowing face facing out (+Y).
return function(m, H)
	local p, C, round = H.p, H.C, H.round
	local ORANGE, RIB = C(235, 112, 22), C(205, 88, 15)
	local GLOW = C(255, 225, 70)
	local c = Vector3.new(0, 0.12, -0.32) -- held in the fist, slightly forward and under the knuckles
	round(m, "Grip", Vector3.new(0.8, 0.78, 0.68), CFrame.new(c), ORANGE, Enum.Material.SmoothPlastic)
	for i = 0, 3 do -- four lobes give the ribbed pumpkin silhouette
		local a = i * math.pi / 2 + math.pi / 4
		round(m, "Lobe", Vector3.new(0.48, 0.48, 0.62), CFrame.new(c + Vector3.new(math.cos(a) * 0.2, math.sin(a) * 0.2, 0)), i % 2 == 0 and RIB or ORANGE, Enum.Material.SmoothPlastic)
	end
	p(m, "Stem", Vector3.new(0.12, 0.12, 0.2), CFrame.new(c + Vector3.new(0, 0, 0.4)), C(70, 110, 40), Enum.Material.Wood)
	p(m, "Fuse", Vector3.new(0.18, 0.18, 0.06), CFrame.new(c + Vector3.new(0, 0, 0.33)), C(60, 60, 64), Enum.Material.Metal)
	-- carved face on the outward side
	local fy = c.Y + 0.4
	for _, x in { -0.14, 0.14 } do
		p(m, "Eye", Vector3.new(0.13, 0.04, 0.13), CFrame.new(c.X + x, fy, c.Z + 0.08) * CFrame.Angles(0, math.rad(45), 0), GLOW, Enum.Material.Neon)
	end
	p(m, "Nose", Vector3.new(0.07, 0.04, 0.07), CFrame.new(c.X, fy + 0.005, c.Z - 0.02) * CFrame.Angles(0, math.rad(45), 0), GLOW, Enum.Material.Neon)
	p(m, "Mouth", Vector3.new(0.38, 0.04, 0.07), CFrame.new(c.X, fy - 0.01, c.Z - 0.14), GLOW, Enum.Material.Neon)
	for _, x in { -0.1, 0.1 } do p(m, "Tooth", Vector3.new(0.06, 0.05, 0.05), CFrame.new(c.X + x, fy, c.Z - 0.12), ORANGE, Enum.Material.SmoothPlastic) end
	local l = Instance.new("PointLight"); l.Color = C(255, 160, 40); l.Range = 5; l.Brightness = 1; l.Parent = m.Grip
end
