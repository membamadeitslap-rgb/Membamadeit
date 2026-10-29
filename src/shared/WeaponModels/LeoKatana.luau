-- Weapon model builder: return function(m, H) that builds parts into model m around a "Grip" part (the hand).
-- H = helpers from Weapons.luau: p(model, name, size, cframe, color, mat, shape), round(...) ellipsoid, C, cyl, up, wedge(part), katana(...)
-- Long/bladed weapons name their main part "Blade" (tip toward +Y) so the swing trails attach to it.
-- Leonardo's ninjaken: blue-wrapped grip, black square-ish guard
return function(m, H)
	local p, C, cyl, up, wedge, katana, round = H.p, H.C, H.cyl, H.up, H.wedge, H.katana, H.round
	katana(m, C(35, 70, 170), C(20, 20, 25), C(30, 30, 35), C(210, 215, 225), 2.6)
	p(m, "Sageo", Vector3.new(0.05, 0.5, 0.05), CFrame.new(0.12, -0.75, 0), C(35, 70, 170), Enum.Material.Fabric)
end
