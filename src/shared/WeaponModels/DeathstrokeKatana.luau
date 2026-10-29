-- Weapon model builder: return function(m, H) that builds parts into model m around a "Grip" part (the hand).
-- H = helpers from Weapons.luau: p(model, name, size, cframe, color, mat, shape), round(...) ellipsoid, C, cyl, up, wedge(part), katana(...)
-- Long/bladed weapons name their main part "Blade" (tip toward +Y) so the swing trails attach to it.
-- Deathstroke's katana: black-wrapped tsuka with gunmetal diamonds, round dark tsuba, long polished blade.
return function(m, H)
	local p, C, katana = H.p, H.C, H.katana
	katana(m, C(22, 22, 25), C(70, 72, 80), C(35, 35, 40), C(215, 220, 230), 3.0)
	p(m, "Tassel", Vector3.new(0.05, 0.4, 0.05), CFrame.new(0, -0.85, 0.05), C(225, 125, 30), Enum.Material.Fabric)
end
