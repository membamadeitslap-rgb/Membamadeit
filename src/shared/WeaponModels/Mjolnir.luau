-- Weapon model builder: return function(m, H) that builds parts into model m around a "Grip" part (the hand).
-- H = helpers from Weapons.luau: p(model, name, size, cframe, color, mat, shape), round(...) ellipsoid, C, cyl, up, wedge(part), katana(...)
-- Long/bladed weapons name their main part "Blade" (tip toward +Y) so the swing trails attach to it.
-- short leather-wrapped handle, rectangular uru head, wrist strap
return function(m, H)
	local p, C, cyl, up, wedge, katana, round = H.p, H.C, H.cyl, H.up, H.wedge, H.katana, H.round
	p(m, "Grip", Vector3.new(0.35, 1.6, 0.35), CFrame.new(), C(90, 60, 40), Enum.Material.Fabric)
	p(m, "Head", Vector3.new(1.0, 1.0, 1.7), CFrame.new(0, 1.2, 0), C(160, 165, 175), Enum.Material.Metal)
	p(m, "Pommel", Vector3.new(0.45, 0.25, 0.45), CFrame.new(0, -0.9, 0), C(140, 140, 150))
	p(m, "Strap", Vector3.new(0.08, 0.6, 0.3), CFrame.new(0, -1.25, 0), C(70, 45, 30), Enum.Material.Fabric)
end
