-- Weapon model builder: return function(m, H) that builds parts into model m around a "Grip" part (the hand).
-- H = helpers from Weapons.luau: p(model, name, size, cframe, color, mat, shape), round(...) ellipsoid, C, cyl, up, wedge(part), katana(...)
-- Long/bladed weapons name their main part "Blade" (tip toward +Y) so the swing trails attach to it.
-- Red Hood's semi-auto pistol (one per hand). Held: +Y points forward (muzzle), +Z points up (slide above the fist).
return function(m, H)
	local p, C, cyl, up = H.p, H.C, H.cyl, H.up
	local black, steel = C(28, 28, 32), C(70, 72, 78)
	p(m, "Grip", Vector3.new(0.17, 0.26, 0.5), CFrame.new(0, -0.04, 0) * CFrame.Angles(math.rad(-12), 0, 0), black, Enum.Material.SmoothPlastic)
	p(m, "Blade", Vector3.new(0.17, 0.95, 0.22), CFrame.new(0, 0.28, 0.34), black, Enum.Material.Metal) -- slide
	p(m, "Frame", Vector3.new(0.15, 0.7, 0.12), CFrame.new(0, 0.32, 0.18), steel, Enum.Material.Metal)
	p(m, "Muzzle", Vector3.new(0.06, 0.1, 0.1), CFrame.new(0, 0.77, 0.36) * up, C(10, 10, 12), Enum.Material.Metal, cyl)
	p(m, "Guard", Vector3.new(0.05, 0.22, 0.04), CFrame.new(0, 0.18, 0.04), black, Enum.Material.Metal)
	p(m, "Sight", Vector3.new(0.05, 0.06, 0.05), CFrame.new(0, 0.7, 0.47), black, Enum.Material.Metal)
	p(m, "Mag", Vector3.new(0.12, 0.2, 0.08), CFrame.new(0, -0.09, -0.27) * CFrame.Angles(math.rad(-12), 0, 0), steel, Enum.Material.Metal)
end
