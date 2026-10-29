-- Weapon model builder: return function(m, H) that builds parts into model m around a "Grip" part (the hand).
-- H = helpers from Weapons.luau: p(model, name, size, cframe, color, mat, shape), round(...) ellipsoid, C, cyl, up, wedge(part), katana(...)
-- Long/bladed weapons name their main part "Blade" (tip toward +Y) so the swing trails attach to it.
-- Krusty Krab spatula: black handle, steel shank, slotted flipper head
return function(m, H)
	local p, C, cyl, up, wedge, katana, round = H.p, H.C, H.cyl, H.up, H.wedge, H.katana, H.round
	p(m, "Grip", Vector3.new(0.22, 1.1, 0.16), CFrame.new(), C(30, 30, 34), Enum.Material.SmoothPlastic)
	for i = -1, 1 do p(m, "Rivet", Vector3.new(0.24, 0.07, 0.07), CFrame.new(0, i * 0.3, 0), C(190, 190, 195), Enum.Material.Metal) end
	p(m, "Shank", Vector3.new(0.08, 1.0, 0.1), CFrame.new(0, 1.05, 0), C(195, 198, 205), Enum.Material.Metal)
	local bl = p(m, "Blade", Vector3.new(0.05, 1.1, 0.85), CFrame.new(0, 2.05, 0.08) * CFrame.Angles(math.rad(-12), 0, 0), C(205, 208, 215), Enum.Material.Metal)
	for i = -1, 1 do p(m, "Slot", Vector3.new(0.07, 0.65, 0.08), bl.CFrame * CFrame.new(0, 0.05, i * 0.22), C(60, 60, 65), Enum.Material.SmoothPlastic) end
end
