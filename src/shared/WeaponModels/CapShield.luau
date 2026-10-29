-- Weapon model builder: return function(m, H) that builds parts into model m around a "Grip" part (the hand).
-- H = helpers from Weapons.luau: p(model, name, size, cframe, color, mat, shape), round(...) ellipsoid, C, cyl, up, wedge(part), katana(...)
-- Long/bladed weapons name their main part "Blade" (tip toward +Y) so the swing trails attach to it.
-- vibranium disc: red/white/red rings, blue center, white star
return function(m, H)
	local p, C, cyl, up, wedge, katana, round = H.p, H.C, H.cyl, H.up, H.wedge, H.katana, H.round
	local g = p(m, "Grip", Vector3.new(0.2, 0.2, 0.2), CFrame.new(), C(60, 60, 60)); g.Transparency = 1
	local rings = { { 3.2, C(190, 20, 30) }, { 2.6, C(235, 235, 235) }, { 2.0, C(190, 20, 30) }, { 1.4, C(20, 50, 140) } }
	for i, r in rings do p(m, "Ring" .. i, Vector3.new(0.12 + i * 0.02, r[1], r[1]), CFrame.new(-0.3 - i * 0.02, 0, 0), r[2], Enum.Material.Metal, cyl) end
	p(m, "Star", Vector3.new(0.05, 0.6, 0.6), CFrame.new(-0.42, 0, 0) * CFrame.Angles(math.rad(45), 0, 0), C(240, 240, 240), Enum.Material.SmoothPlastic)
end
