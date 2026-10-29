-- Weapon model builder: return function(m, H) that builds parts into model m around a "Grip" part (the hand).
-- H = helpers from Weapons.luau: p(model, name, size, cframe, color, mat, shape), round(...) ellipsoid, C, cyl, up, wedge(part), katana(...)
-- Long/bladed weapons name their main part "Blade" (tip toward +Y) so the swing trails attach to it.
-- Harley's giant mallet: long wooden handle, barrel head half red / half black with banded rims and diamond inlays.
return function(m, H)
	local p, C, cyl, round = H.p, H.C, H.cyl, H.round
	local wood, red, black, rim = C(120, 80, 45), C(200, 30, 40), C(25, 25, 30), C(230, 230, 235)
	p(m, "Grip", Vector3.new(0.2, 0.8, 0.2), CFrame.new(), black, Enum.Material.Fabric)
	p(m, "Blade", Vector3.new(0.17, 2.6, 0.17), CFrame.new(0, 1.5, 0), wood, Enum.Material.Wood)
	round(m, "Pommel", Vector3.new(0.3, 0.22, 0.3), CFrame.new(0, -0.45, 0), black)
	local y = 2.95
	p(m, "HeadR", Vector3.new(0.72, 0.95, 0.95), CFrame.new(0.36, y, 0), red, Enum.Material.SmoothPlastic, cyl)
	p(m, "HeadL", Vector3.new(0.72, 0.95, 0.95), CFrame.new(-0.36, y, 0), black, Enum.Material.SmoothPlastic, cyl)
	for _, x in { -0.74, 0, 0.74 } do p(m, "Rim", Vector3.new(0.1, 1.02, 1.02), CFrame.new(x, y, 0), rim, Enum.Material.Metal, cyl) end
	for _, x in { -1, 1 } do
		p(m, "Face", Vector3.new(0.06, 0.78, 0.78), CFrame.new(x * 0.79, y, 0), x > 0 and black or red, Enum.Material.SmoothPlastic, cyl)
		p(m, "Diamond", Vector3.new(0.26, 0.26, 0.04), CFrame.new(x * 0.36, y, -0.48) * CFrame.Angles(0, 0, math.rad(45)), x > 0 and black or red)
		p(m, "Diamond", Vector3.new(0.26, 0.26, 0.04), CFrame.new(x * 0.36, y, 0.48) * CFrame.Angles(0, 0, math.rad(45)), x > 0 and black or red)
	end
end
