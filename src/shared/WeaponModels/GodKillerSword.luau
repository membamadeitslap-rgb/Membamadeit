-- Weapon model builder: return function(m, H) that builds parts into model m around a "Grip" part (the hand).
-- H = helpers from Weapons.luau: p(model, name, size, cframe, color, mat, shape), round(...) ellipsoid, C, cyl, up, wedge(part), katana(...)
-- Long/bladed weapons name their main part "Blade" (tip toward +Y) so the swing trails attach to it.
-- Wonder Woman: long silver blade, gold crossguard
return function(m, H)
	local p, C, cyl, up, wedge, katana, round = H.p, H.C, H.cyl, H.up, H.wedge, H.katana, H.round
	p(m, "Grip", Vector3.new(0.25, 0.9, 0.25), CFrame.new(), C(110, 70, 40), Enum.Material.Fabric)
	p(m, "Guard", Vector3.new(0.25, 0.2, 1.1), CFrame.new(0, 0.55, 0), C(215, 170, 50))
	p(m, "Blade", Vector3.new(0.08, 3.4, 0.35), CFrame.new(0, 2.35, 0), C(215, 220, 230))
end
