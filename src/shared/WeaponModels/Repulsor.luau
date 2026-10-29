-- Weapon model builder: return function(m, H) that builds parts into model m around a "Grip" part (the hand).
-- H = helpers from Weapons.luau: p(model, name, size, cframe, color, mat, shape), round(...) ellipsoid, C, cyl, up, wedge(part), katana(...)
-- Long/bladed weapons name their main part "Blade" (tip toward +Y) so the swing trails attach to it.
-- gold palm plate with glowing repulsor
return function(m, H)
	local p, C, cyl, up, wedge, katana, round = H.p, H.C, H.cyl, H.up, H.wedge, H.katana, H.round
	p(m, "Grip", Vector3.new(1.05, 1.2, 1.05), CFrame.new(), C(200, 30, 30))
	p(m, "Glow", Vector3.new(0.1, 0.5, 0.5), CFrame.new(0, -0.45, 0) * up * CFrame.Angles(0, 0, 0), C(180, 240, 255), Enum.Material.Neon, cyl)
end
