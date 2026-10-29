-- Weapon model builder: return function(m, H) that builds parts into model m around a "Grip" part (the hand).
-- H = helpers from Weapons.luau: p(model, name, size, cframe, color, mat, shape), round(...) ellipsoid, C, cyl, up, wedge(part), katana(...)
-- Long/bladed weapons name their main part "Blade" (tip toward +Y) so the swing trails attach to it.
-- Aang's airbender glider staff: long wooden shaft, folded orange glider wings at the top, red cap
return function(m, H)
	local p, C, cyl, up, wedge, katana, round = H.p, H.C, H.cyl, H.up, H.wedge, H.katana, H.round
	p(m, "Grip", Vector3.new(0.24, 1.0, 0.24), CFrame.new(), C(140, 95, 55), Enum.Material.Wood)
	local shaft = p(m, "Blade", Vector3.new(0.2, 5.6, 0.2), CFrame.new(0, 1.3, 0), C(150, 105, 60), Enum.Material.Wood) -- "Blade" = trail axis, tip at +Y
	p(m, "Butt", Vector3.new(0.24, 0.3, 0.24), CFrame.new(0, -1.55, 0), C(170, 40, 30), Enum.Material.Wood)
	p(m, "Cap", Vector3.new(0.26, 0.3, 0.26), CFrame.new(0, 4.15, 0), C(170, 40, 30), Enum.Material.Wood)
	for _, y in { 0.7, 2.0 } do p(m, "Band", Vector3.new(0.24, 0.1, 0.24), CFrame.new(0, y, 0), C(60, 40, 25), Enum.Material.Wood) end
	for _, x in { -1, 1 } do -- folded wings hugging the top of the shaft
		p(m, "Wing", Vector3.new(0.12, 1.6, 0.36), CFrame.new(x * 0.16, 3.2, 0) * CFrame.Angles(0, 0, math.rad(-x * 4)), C(230, 130, 40), Enum.Material.Fabric)
		p(m, "WingRib", Vector3.new(0.05, 1.6, 0.06), CFrame.new(x * 0.23, 3.2, 0) * CFrame.Angles(0, 0, math.rad(-x * 4)), C(170, 40, 30), Enum.Material.Wood)
		wedge(p(m, "WingTip", Vector3.new(0.12, 0.4, 0.36), CFrame.new(x * 0.18, 2.2, 0) * CFrame.Angles(math.rad(180), 0, 0), C(230, 130, 40), Enum.Material.Fabric))
	end
	return shaft
end
