-- Weapon model builder: return function(m, H) that builds parts into model m around a "Grip" part (the hand).
-- H = helpers from Weapons.luau: p(model, name, size, cframe, color, mat, shape), round(...) ellipsoid, C, cyl, up, wedge(part), katana(...)
-- Long/bladed weapons name their main part "Blade" (tip toward +Y) so the swing trails attach to it.
-- orange jack-o'-lantern grenade with glowing face
return function(m, H)
	local p, C, cyl, up, wedge, katana, round = H.p, H.C, H.cyl, H.up, H.wedge, H.katana, H.round
	p(m, "Grip", Vector3.one * 0.9, CFrame.new(), C(230, 110, 20), Enum.Material.SmoothPlastic, Enum.PartType.Ball)
	p(m, "Stem", Vector3.new(0.15, 0.3, 0.15), CFrame.new(0, 0.5, 0), C(60, 120, 40))
	p(m, "Face", Vector3.new(0.5, 0.2, 0.05), CFrame.new(0, -0.05, -0.44), C(255, 230, 80), Enum.Material.Neon)
end
