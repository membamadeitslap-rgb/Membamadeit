-- Weapon model builder: return function(m, H) that builds parts into model m around a "Grip" part (the hand).
-- H = helpers from Weapons.luau: p(model, name, size, cframe, color, mat, shape), round(...) ellipsoid, C, cyl, up, wedge(part), katana(...)
-- Long/bladed weapons name their main part "Blade" (tip toward +Y) so the swing trails attach to it.
-- gold glove with 6 stones on knuckles + back
return function(m, H)
	local p, C, cyl, up, wedge, katana, round = H.p, H.C, H.cyl, H.up, H.wedge, H.katana, H.round
	p(m, "Grip", Vector3.new(1.1, 1.3, 1.1), CFrame.new(), C(215, 170, 50))
	local stones = { C(255, 140, 0), C(170, 40, 255), C(40, 90, 255), C(230, 30, 30), C(255, 230, 40), C(40, 220, 80) }
	for i, c in stones do
		local cf = i == 6 and CFrame.new(0, 0, -0.58) or CFrame.new(-0.4 + (i - 1) * 0.2, -0.55, -0.45)
		p(m, "Stone" .. i, Vector3.one * 0.22, cf, c, Enum.Material.Neon, Enum.PartType.Ball)
	end
end
