-- Weapon model builder: return function(m, H) that builds parts into model m around a "Grip" part (the hand).
-- H = helpers from Weapons.luau: p(model, name, size, cframe, color, mat, shape), round(...) ellipsoid, C, cyl, up, wedge(part), katana(...)
-- Long/bladed weapons name their main part "Blade" (tip toward +Y) so the swing trails attach to it.
-- oversized red/black mallet
return function(m, H)
	local p, C, cyl, up, wedge, katana, round = H.p, H.C, H.cyl, H.up, H.wedge, H.katana, H.round
	p(m, "Grip", Vector3.new(0.3, 3.4, 0.3), CFrame.new(0, 0.8, 0), C(30, 30, 30), Enum.Material.Wood)
	p(m, "HeadR", Vector3.new(1.5, 1.5, 1.2), CFrame.new(0, 2.8, 0.6) * CFrame.Angles(math.rad(90), 0, 0) * up, C(200, 30, 40), Enum.Material.SmoothPlastic, cyl)
	p(m, "HeadB", Vector3.new(1.5, 1.5, 1.2), CFrame.new(0, 2.8, -0.6) * CFrame.Angles(math.rad(90), 0, 0) * up, C(25, 25, 30), Enum.Material.SmoothPlastic, cyl)
end
