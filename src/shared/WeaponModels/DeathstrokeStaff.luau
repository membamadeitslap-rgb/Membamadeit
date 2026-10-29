-- Weapon model builder: return function(m, H) that builds parts into model m around a "Grip" part (the hand).
-- H = helpers from Weapons.luau: p(model, name, size, cframe, color, mat, shape), round(...) ellipsoid, C, cyl, up, wedge(part), katana(...)
-- Long/bladed weapons name their main part "Blade" (tip toward +Y) so the swing trails attach to it.
-- folding bo staff on the back hand
return function(m, H)
	local p, C, cyl, up, wedge, katana, round = H.p, H.C, H.cyl, H.up, H.wedge, H.katana, H.round
	p(m, "Grip", Vector3.new(0.18, 4.5, 0.18), CFrame.new(0, 0, 0), C(40, 40, 45))
	p(m, "CapA", Vector3.new(0.24, 0.3, 0.24), CFrame.new(0, 2.2, 0), C(220, 130, 30))
	p(m, "CapB", Vector3.new(0.24, 0.3, 0.24), CFrame.new(0, -2.2, 0), C(220, 130, 30))
end
