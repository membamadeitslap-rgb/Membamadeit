-- Weapon model builder: return function(m, H) that builds parts into model m around a "Grip" part (the hand).
-- H = helpers from Weapons.luau: p(model, name, size, cframe, color, mat, shape), round(...) ellipsoid, C, cyl, up, wedge(part), katana(...)
-- Long/bladed weapons name their main part "Blade" (tip toward +Y) so the swing trails attach to it.
-- Spider-Man's web-shooter: slim steel bracelet at the wrist with a fluid cartridge housing and a spinneret nozzle on the thumb side.
-- Model axes once attached: +Z = up the forearm, +Y = forward (thumb side), X = across the wrist.
return function(m, H)
	local p, C, cyl, round = H.p, H.C, H.cyl, H.round
	local g = p(m, "Grip", Vector3.new(0.2, 0.2, 0.2), CFrame.new(), C(170, 175, 185)); g.Transparency = 1
	local steel, dark = C(185, 190, 200), C(55, 58, 66)
	local wrist = CFrame.new(0, 0, 0.36)
	p(m, "Band", Vector3.new(0.07, 0.7, 0.7), wrist * CFrame.Angles(0, math.rad(90), 0), steel, Enum.Material.Metal, cyl)
	p(m, "Band2", Vector3.new(0.04, 0.71, 0.71), wrist * CFrame.new(0, 0, 0.08) * CFrame.Angles(0, math.rad(90), 0), dark, Enum.Material.Metal, cyl)
	p(m, "Housing", Vector3.new(0.18, 0.09, 0.2), wrist * CFrame.new(0, 0.35, 0.03), steel, Enum.Material.Metal)
	p(m, "Cartridge", Vector3.new(0.07, 0.07, 0.2), wrist * CFrame.new(0.07, 0.4, 0.03), dark, Enum.Material.Metal, cyl)
	p(m, "Nozzle", Vector3.new(0.08, 0.06, 0.06), wrist * CFrame.new(0, 0.39, -0.09) * CFrame.Angles(0, math.rad(90), 0), dark, Enum.Material.Metal, cyl)
end
