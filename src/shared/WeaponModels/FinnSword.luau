-- Weapon model builder: return function(m, H) that builds parts into model m around a "Grip" part (the hand).
-- H = helpers from Weapons.luau: p(model, name, size, cframe, color, mat, shape), round(...) ellipsoid, C, cyl, up, wedge(part), katana(...)
-- Long/bladed weapons name their main part "Blade" (tip toward +Y) so the swing trails attach to it.
-- Finn's golden sword (seasons 1-3): brown leather-wrapped grip, round gold pommel with a red gem, short gold crossguard
-- with ball ends, straight gold blade with a darker fuller and a pointed tip. Sized for a kid (about the length of his legs+torso).
return function(m, H)
	local p, C, cyl, up, wedge, round = H.p, H.C, H.cyl, H.up, H.wedge, H.round
	local GOLD, DARK = C(240, 200, 70), C(200, 150, 40)
	p(m, "Grip", Vector3.new(0.18, 0.6, 0.18), CFrame.new(), C(120, 70, 40), Enum.Material.Fabric)
	for i = -1, 1 do p(m, "Wrap", Vector3.new(0.05, 0.2, 0.2), CFrame.new(0, i * 0.18, 0) * up, C(90, 50, 30), Enum.Material.Fabric, cyl) end
	p(m, "Pommel", Vector3.new(0.28, 0.28, 0.28), CFrame.new(0, -0.4, 0), GOLD, Enum.Material.Metal, Enum.PartType.Ball)
	p(m, "Gem", Vector3.new(0.3, 0.14, 0.14), CFrame.new(0, -0.4, 0), C(200, 30, 50), Enum.Material.SmoothPlastic, cyl)
	round(m, "Guard", Vector3.new(0.16, 0.16, 0.95), CFrame.new(0, 0.36, 0), GOLD, Enum.Material.Metal)
	for _, z in { -1, 1 } do p(m, "GuardTip", Vector3.new(0.2, 0.2, 0.2), CFrame.new(0, 0.36, z * 0.47), GOLD, Enum.Material.Metal, Enum.PartType.Ball) end
	local bl = p(m, "Blade", Vector3.new(0.07, 2.1, 0.3), CFrame.new(0, 1.5, 0), GOLD, Enum.Material.Metal)
	p(m, "Fuller", Vector3.new(0.09, 1.7, 0.07), CFrame.new(0, 1.35, 0), DARK, Enum.Material.Metal)
	for _, z in { -1, 1 } do
		wedge(p(m, "Point", Vector3.new(0.07, 0.3, 0.15), bl.CFrame * CFrame.new(0, 1.2, z * 0.075) * CFrame.Angles(0, z > 0 and 0 or math.rad(180), 0), GOLD, Enum.Material.Metal))
	end
end
