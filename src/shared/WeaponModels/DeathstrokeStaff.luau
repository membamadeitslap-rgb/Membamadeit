-- Weapon model builder: return function(m, H) that builds parts into model m around a "Grip" part (the hand).
-- H = helpers from Weapons.luau: p(model, name, size, cframe, color, mat, shape), round(...) ellipsoid, C, cyl, up, wedge(part), katana(...)
-- Long/bladed weapons name their main part "Blade" (tip toward +Y) so the swing trails attach to it.
-- Deathstroke's collapsible power staff: gunmetal shaft held a third of the way along, grip wraps, telescoping collars, orange-capped ends.
return function(m, H)
	local p, C, cyl, up = H.p, H.C, H.cyl, H.up
	local gun, dark, orange = C(75, 78, 86), C(30, 30, 34), C(225, 125, 30)
	p(m, "Grip", Vector3.new(0.18, 0.9, 0.18), CFrame.new(), dark, Enum.Material.Fabric)
	p(m, "Blade", Vector3.new(4.6, 0.14, 0.14), CFrame.new(0, 1.0, 0) * up, gun, Enum.Material.Metal, cyl)
	for _, y in { -0.55, 0.55, 1.9, 2.4 } do p(m, "Collar", Vector3.new(0.1, 0.2, 0.2), CFrame.new(0, y, 0) * up, dark, Enum.Material.Metal, cyl) end
	for _, y in { -1.3, 3.3 } do
		p(m, "Cap", Vector3.new(0.22, 0.2, 0.2), CFrame.new(0, y, 0) * up, orange, Enum.Material.Metal, cyl)
		p(m, "Tip", Vector3.new(0.08, 0.12, 0.12), CFrame.new(0, y + (y > 0 and 0.15 or -0.15), 0) * up, dark, Enum.Material.Metal, cyl)
	end
end
