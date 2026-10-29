-- Weapon model builder: return function(m, H) that builds parts into model m around a "Grip" part (the hand).
-- H = helpers from Weapons.luau: p(model, name, size, cframe, color, mat, shape), round(...) ellipsoid, C, cyl, up, wedge(part), katana(...)
-- Long/bladed weapons name their main part "Blade" (tip toward +Y) so the swing trails attach to it.
-- round bronze shield
return function(m, H)
	local p, C, cyl, up, wedge, katana, round = H.p, H.C, H.cyl, H.up, H.wedge, H.katana, H.round
	local g = p(m, "Grip", Vector3.one * 0.2, CFrame.new(), C(0, 0, 0)); g.Transparency = 1
	p(m, "Face", Vector3.new(0.2, 2.6, 2.6), CFrame.new(-0.3, 0, 0), C(170, 120, 60), Enum.Material.Metal, cyl)
	p(m, "Boss", Vector3.new(0.25, 0.8, 0.8), CFrame.new(-0.42, 0, 0), C(215, 170, 50), Enum.Material.Metal, cyl)
end
