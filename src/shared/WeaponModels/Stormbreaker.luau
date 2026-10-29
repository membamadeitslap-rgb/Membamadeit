-- Weapon model builder: return function(m, H) that builds parts into model m around a "Grip" part (the hand).
-- H = helpers from Weapons.luau: p(model, name, size, cframe, color, mat, shape), round(...) ellipsoid, C, cyl, up, wedge(part), katana(...)
-- Long/bladed weapons name their main part "Blade" (tip toward +Y) so the swing trails attach to it.
-- Stormbreaker: long Groot-wood haft, broad crescent axe blade (two curved horns built from wedges) on one side,
-- square hammer face on the other, uru collar bands, spike tip and wrapped grip.
return function(m, H)
	local p, C, cyl, up, wedge, round = H.p, H.C, H.cyl, H.up, H.wedge, H.round
	local wood, uru, edge = C(105, 75, 45), C(150, 152, 162), C(205, 210, 220)
	local g = p(m, "Grip", Vector3.new(0.2, 0.2, 0.2), CFrame.new(), C(60, 45, 32)); g.Transparency = 1 -- unrotated: the model is pivoted on it
	p(m, "Wrap", Vector3.new(1.0, 0.22, 0.22), CFrame.new(0, 0, 0) * up, C(60, 45, 32), Enum.Material.Leather, cyl)
	p(m, "Haft", Vector3.new(2.8, 0.2, 0.2), CFrame.new(0, 1.85, 0) * up, wood, Enum.Material.Wood, cyl)
	round(m, "Pommel", Vector3.new(0.28, 0.3, 0.28), CFrame.new(0, -0.58, 0), uru, Enum.Material.Metal)
	for _, y in { 0.55, 2.55, 3.45 } do p(m, "Band", Vector3.new(0.08, 0.26, 0.26), CFrame.new(0, y, 0) * up, uru, Enum.Material.Metal, cyl) end
	local hy = 3.0 -- head center along the haft
	p(m, "Socket", Vector3.new(0.3, 0.75, 0.36), CFrame.new(0, hy, 0), uru, Enum.Material.Metal)
	-- axe blade on +Z: thick cheek tapering to a broad edge with upper and lower horns
	local bl = p(m, "Blade", Vector3.new(0.09, 0.62, 0.7), CFrame.new(0, hy, 0.5), uru, Enum.Material.Metal)
	p(m, "Edge", Vector3.new(0.05, 1.5, 0.12), CFrame.new(0, hy, 0.93), edge, Enum.Material.Metal)
	wedge(p(m, "HornUp", Vector3.new(0.08, 0.45, 0.72), CFrame.new(0, hy + 0.535, 0.56), uru, Enum.Material.Metal))
	wedge(p(m, "HornDown", Vector3.new(0.08, 0.45, 0.72), CFrame.new(0, hy - 0.535, 0.56) * CFrame.Angles(0, 0, math.pi), uru, Enum.Material.Metal))
	p(m, "Rune", Vector3.new(0.11, 0.22, 0.22), CFrame.new(0, hy, 0.5) * CFrame.Angles(math.rad(45), 0, 0), C(80, 160, 230), Enum.Material.Metal)
	-- hammer back on -Z
	p(m, "Hammer", Vector3.new(0.34, 0.42, 0.34), CFrame.new(0, hy, -0.32), uru, Enum.Material.Metal)
	p(m, "HammerFace", Vector3.new(0.4, 0.48, 0.08), CFrame.new(0, hy, -0.5), C(120, 122, 132), Enum.Material.Metal)
	-- spike tip above the head
	wedge(p(m, "Tip", Vector3.new(0.14, 0.4, 0.14), CFrame.new(0, 3.65, 0), uru, Enum.Material.Metal))
end
