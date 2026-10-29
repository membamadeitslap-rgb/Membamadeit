-- Weapon model builder: return function(m, H) that builds parts into model m around a "Grip" part (the hand).
-- H = helpers from Weapons.luau: p(model, name, size, cframe, color, mat, shape), round(...) ellipsoid, C, cyl, up, wedge(part), katana(...)
-- Long/bladed weapons name their main part "Blade" (tip toward +Y) so the swing trails attach to it.
-- gold staff, curved blade, blue mind stone gem
return function(m, H)
	local p, C, cyl, up, wedge, katana, round = H.p, H.C, H.cyl, H.up, H.wedge, H.katana, H.round
	p(m, "Grip", Vector3.new(0.2, 3.4, 0.2), CFrame.new(0, 0.8, 0), C(210, 170, 60))
	p(m, "Gem", Vector3.new(0.45, 0.45, 0.45), CFrame.new(0, 2.6, 0), C(80, 180, 255), Enum.Material.Neon, Enum.PartType.Ball)
	p(m, "BladeA", Vector3.new(0.08, 1.1, 0.3), CFrame.new(0, 3.0, 0.25) * CFrame.Angles(math.rad(-20), 0, 0), C(200, 200, 210))
	p(m, "BladeB", Vector3.new(0.08, 0.7, 0.25), CFrame.new(0, 2.8, -0.3) * CFrame.Angles(math.rad(35), 0, 0), C(200, 200, 210))
end
