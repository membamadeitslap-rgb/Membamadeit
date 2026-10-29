-- Weapon model builder: return function(m, H) that builds parts into model m around a "Grip" part (the hand).
-- H = helpers from Weapons.luau: p(model, name, size, cframe, color, mat, shape), round(...) ellipsoid, C, cyl, up, wedge(part), katana(...)
-- Long/bladed weapons name their main part "Blade" (tip toward +Y) so the swing trails attach to it.
-- the infamous crowbar
return function(m, H)
	local p, C, cyl, up, wedge, katana, round = H.p, H.C, H.cyl, H.up, H.wedge, H.katana, H.round
	p(m, "Grip", Vector3.new(0.18, 3, 0.18), CFrame.new(0, 0.9, 0), C(120, 120, 125))
	p(m, "Hook", Vector3.new(0.18, 0.18, 0.7), CFrame.new(0, 2.4, 0.3), C(120, 120, 125))
	p(m, "Claw", Vector3.new(0.18, 0.18, 0.45), CFrame.new(0, -0.6, -0.15), C(120, 120, 125))
end
