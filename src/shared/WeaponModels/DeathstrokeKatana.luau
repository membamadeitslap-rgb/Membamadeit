-- Weapon model builder: return function(m, H) that builds parts into model m around a "Grip" part (the hand).
-- H = helpers from Weapons.luau: p(model, name, size, cframe, color, mat, shape), round(...) ellipsoid, C, cyl, up, wedge(part), katana(...)
-- Long/bladed weapons name their main part "Blade" (tip toward +Y) so the swing trails attach to it.
-- black-handled katana, silver blade
return function(m, H)
	local p, C, cyl, up, wedge, katana, round = H.p, H.C, H.cyl, H.up, H.wedge, H.katana, H.round
	p(m, "Grip", Vector3.new(0.22, 1.0, 0.22), CFrame.new(), C(20, 20, 20), Enum.Material.Fabric)
	p(m, "Tsuba", Vector3.new(0.6, 0.08, 0.6), CFrame.new(0, 0.55, 0), C(30, 30, 30), Enum.Material.Metal, nil)
	p(m, "Blade", Vector3.new(0.06, 3.0, 0.22), CFrame.new(0, 2.1, 0) * CFrame.Angles(math.rad(4), 0, 0), C(215, 220, 230))
end
