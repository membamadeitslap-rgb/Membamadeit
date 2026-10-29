-- Weapon model builder: return function(m, H) that builds parts into model m around a "Grip" part (the hand).
-- H = helpers from Weapons.luau: p(model, name, size, cframe, color, mat, shape), round(...) ellipsoid, C, cyl, up, wedge(part), katana(...)
-- Long/bladed weapons name their main part "Blade" (tip toward +Y) so the swing trails attach to it.
-- axe blade + hammer back, Groot-wood handle
return function(m, H)
	local p, C, cyl, up, wedge, katana, round = H.p, H.C, H.cyl, H.up, H.wedge, H.katana, H.round
	p(m, "Grip", Vector3.new(0.3, 3.2, 0.3), CFrame.new(0, 0.6, 0), C(110, 80, 50), Enum.Material.Wood)
	p(m, "Blade", Vector3.new(0.15, 1.3, 1.4), CFrame.new(0, 2.0, 0.75), C(190, 195, 205))
	p(m, "Hammer", Vector3.new(0.6, 0.6, 0.7), CFrame.new(0, 2.0, -0.4), C(150, 150, 160))
end
