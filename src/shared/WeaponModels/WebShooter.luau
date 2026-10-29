-- Weapon model builder: return function(m, H) that builds parts into model m around a "Grip" part (the hand).
-- H = helpers from Weapons.luau: p(model, name, size, cframe, color, mat, shape), round(...) ellipsoid, C, cyl, up, wedge(part), katana(...)
-- Long/bladed weapons name their main part "Blade" (tip toward +Y) so the swing trails attach to it.
-- silver wrist cartridge band
return function(m, H)
	local p, C, cyl, up, wedge, katana, round = H.p, H.C, H.cyl, H.up, H.wedge, H.katana, H.round
	p(m, "Grip", Vector3.new(0.9, 0.25, 0.9), CFrame.new(0, 0.3, 0), C(170, 175, 185), Enum.Material.Metal, nil)
	p(m, "Nozzle", Vector3.new(0.15, 0.15, 0.15), CFrame.new(0, 0.3, -0.48), C(60, 60, 70))
end
