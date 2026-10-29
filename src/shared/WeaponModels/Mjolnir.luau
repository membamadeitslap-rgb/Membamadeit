-- Weapon model builder: return function(m, H) that builds parts into model m around a "Grip" part (the hand).
-- H = helpers from Weapons.luau: p(model, name, size, cframe, color, mat, shape), round(...) ellipsoid, C, cyl, up, wedge(part), katana(...)
-- Long/bladed weapons name their main part "Blade" (tip toward +Y) so the swing trails attach to it.
-- Mjolnir: brick-shaped uru head (long axis across the handle) with stepped end faces and a sunken knotwork panel,
-- short leather-wrapped handle with ring bands, round pommel and the wrist-strap loop.
return function(m, H)
	local p, C, cyl, up, round = H.p, H.C, H.cyl, H.up, H.round
	local uru, uruDark, leather = C(165, 168, 178), C(120, 122, 132), C(95, 62, 38)
	local g = p(m, "Grip", Vector3.new(0.2, 0.2, 0.2), CFrame.new(), leather); g.Transparency = 1 -- unrotated: the model is pivoted on it
	p(m, "Handle", Vector3.new(1.25, 0.2, 0.2), CFrame.new(0, 0.1, 0) * up, leather, Enum.Material.Leather, cyl)
	for i = 0, 3 do p(m, "Wrap" .. i, Vector3.new(0.05, 0.23, 0.23), CFrame.new(0, -0.35 + i * 0.3, 0) * up, C(70, 45, 28), Enum.Material.Leather, cyl) end
	p(m, "Collar", Vector3.new(0.12, 0.3, 0.3), CFrame.new(0, 0.76, 0) * up, uruDark, Enum.Material.Metal, cyl)
	round(m, "Pommel", Vector3.new(0.3, 0.26, 0.3), CFrame.new(0, -0.56, 0), uru, Enum.Material.Metal)
	-- head: main block + slightly smaller stepped caps on both ends + knot panels on the broad faces
	local hcf = CFrame.new(0, 1.12, 0)
	p(m, "Head", Vector3.new(0.58, 0.58, 1.0), hcf, uru, Enum.Material.Metal)
	for _, z in { -1, 1 } do
		p(m, "Face", Vector3.new(0.5, 0.5, 0.1), hcf * CFrame.new(0, 0, z * 0.53), uruDark, Enum.Material.Metal)
		p(m, "FaceRim", Vector3.new(0.62, 0.62, 0.06), hcf * CFrame.new(0, 0, z * 0.42), uruDark, Enum.Material.Metal)
	end
	for _, x in { -1, 1 } do
		p(m, "Knot", Vector3.new(0.04, 0.34, 0.6), hcf * CFrame.new(x * 0.29, 0, 0), uruDark, Enum.Material.Metal)
	end
	-- wrist strap loop hanging from the pommel
	p(m, "Strap", Vector3.new(0.04, 0.5, 0.1), CFrame.new(0.06, -0.85, 0) * CFrame.Angles(0, 0, math.rad(12)), C(70, 45, 28), Enum.Material.Leather)
	p(m, "Strap2", Vector3.new(0.04, 0.5, 0.1), CFrame.new(-0.06, -0.85, 0) * CFrame.Angles(0, 0, math.rad(-12)), C(70, 45, 28), Enum.Material.Leather)
end
