-- Weapon model builder: return function(m, H) that builds parts into model m around a "Grip" part (the hand).
-- H = helpers from Weapons.luau: p(model, name, size, cframe, color, mat, shape), round(...) ellipsoid, C, cyl, up, wedge(part), katana(...)
-- Long/bladed weapons name their main part "Blade" (tip toward +Y) so the swing trails attach to it.
-- black bat-wing blade
return function(m, H)
	local p, C, cyl, up, wedge, katana, round = H.p, H.C, H.cyl, H.up, H.wedge, H.katana, H.round
	p(m, "Grip", Vector3.new(0.3, 0.1, 0.3), CFrame.new(), C(25, 25, 30))
	p(m, "WingL", Vector3.new(0.7, 0.08, 0.25), CFrame.new(-0.45, 0, 0.05) * CFrame.Angles(0, math.rad(-20), 0), C(25, 25, 30))
	p(m, "WingR", Vector3.new(0.7, 0.08, 0.25), CFrame.new(0.45, 0, 0.05) * CFrame.Angles(0, math.rad(20), 0), C(25, 25, 30))
end
