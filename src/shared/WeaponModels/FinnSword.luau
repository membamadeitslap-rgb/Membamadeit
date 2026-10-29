-- Weapon model builder: return function(m, H) that builds parts into model m around a "Grip" part (the hand).
-- H = helpers from Weapons.luau: p(model, name, size, cframe, color, mat, shape), round(...) ellipsoid, C, cyl, up, wedge(part), katana(...)
-- Long/bladed weapons name their main part "Blade" (tip toward +Y) so the swing trails attach to it.
-- Finn's golden sword: red-wrapped grip, round pommel gem, straight gold blade with a fuller
return function(m, H)
	local p, C, cyl, up, wedge, katana, round = H.p, H.C, H.cyl, H.up, H.wedge, H.katana, H.round
	p(m, "Grip", Vector3.new(0.24, 0.9, 0.24), CFrame.new(), C(170, 40, 40), Enum.Material.Fabric)
	p(m, "Pommel", Vector3.new(0.36, 0.36, 0.36), CFrame.new(0, -0.6, 0), C(225, 185, 60), Enum.Material.Metal, Enum.PartType.Ball)
	p(m, "Gem", Vector3.new(0.4, 0.18, 0.18), CFrame.new(0, -0.6, 0), C(200, 30, 50), Enum.Material.SmoothPlastic, cyl)
	p(m, "Guard", Vector3.new(0.24, 0.22, 1.3), CFrame.new(0, 0.55, 0), C(225, 185, 60), Enum.Material.Metal)
	for _, z in { -1, 1 } do p(m, "GuardTip", Vector3.new(0.28, 0.28, 0.28), CFrame.new(0, 0.55, z * 0.68), C(225, 185, 60), Enum.Material.Metal, Enum.PartType.Ball) end
	local bl = p(m, "Blade", Vector3.new(0.1, 2.9, 0.4), CFrame.new(0, 2.1, 0), C(240, 200, 70), Enum.Material.Metal)
	p(m, "Fuller", Vector3.new(0.12, 2.3, 0.08), CFrame.new(0, 1.95, 0), C(200, 150, 40), Enum.Material.Metal)
	for _, z in { -1, 1 } do
		wedge(p(m, "Point", Vector3.new(0.1, 0.4, 0.2), bl.CFrame * CFrame.new(0, 1.65, z * 0.1) * CFrame.Angles(0, z > 0 and 0 or math.rad(180), 0), C(240, 200, 70), Enum.Material.Metal))
	end
end
