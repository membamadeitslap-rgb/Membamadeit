-- Weapon model builder: return function(m, H) that builds parts into model m around a "Grip" part (the hand).
-- H = helpers from Weapons.luau: p(model, name, size, cframe, color, mat, shape), round(...) ellipsoid, C, cyl, up, wedge(part), katana(...)
-- Long/bladed weapons name their main part "Blade" (tip toward +Y) so the swing trails attach to it.
-- Vibranium shield: shallow dome (each ring a little proud of the one outside it), red/white/red rings,
-- blue center disc with a five-point white star built from wedge triangles, steel rim and arm straps on the back.
-- The face points along -X (outward from the left forearm).
return function(m, H)
	local p, C, cyl, wedge = H.p, H.C, H.cyl, H.wedge
	local g = p(m, "Grip", Vector3.new(0.2, 0.2, 0.2), CFrame.new(), C(60, 60, 60)); g.Transparency = 1
	local RED, WHITE, BLUE = C(190, 25, 35), C(238, 238, 240), C(25, 55, 145)
	local base = -0.32 -- back plane of the shield (just outside the forearm)
	p(m, "Rim", Vector3.new(0.12, 2.75, 2.75), CFrame.new(base, 0, 0), C(150, 152, 160), Enum.Material.Metal, cyl)
	local rings = { { 2.68, RED }, { 2.15, WHITE }, { 1.62, RED }, { 1.1, BLUE } }
	for i, r in rings do
		p(m, "Ring" .. i, Vector3.new(0.08 + i * 0.05, r[1], r[1]), CFrame.new(base - (0.04 + i * 0.025), 0, 0), r[2], Enum.Material.SmoothPlastic, cyl)
	end
	-- star: five isosceles triangles (two wedge halves each) around a pentagon core, in the YZ plane facing -X
	local face = CFrame.new(base - 0.31, 0, 0) * CFrame.Angles(0, math.rad(90), 0) -- local -Z now points to -X
	local k = 0.24
	p(m, "StarCore", Vector3.new(0.05, k * 1.4, k * 1.4), face * CFrame.Angles(0, math.rad(90), 0), WHITE, Enum.Material.SmoothPlastic, cyl)
	for i = 0, 4 do
		local cf = face * CFrame.Angles(0, 0, math.rad(i * 72)) * CFrame.new(0, k * 0.98, 0)
		local w, h = k * 0.95, k * 1.25
		wedge(p(m, "StarRay", Vector3.new(0.05, h, w / 2), cf * CFrame.new(-w / 4, 0, 0) * CFrame.Angles(0, math.rad(90), 0), WHITE, Enum.Material.SmoothPlastic))
		wedge(p(m, "StarRay", Vector3.new(0.05, w / 2, h), cf * CFrame.new(w / 4, 0, 0) * CFrame.Angles(0, 0, math.rad(-90)) * CFrame.Angles(0, math.rad(90), 0), WHITE, Enum.Material.SmoothPlastic))
	end
	-- arm straps on the inside
	for _, z in { -0.35, 0.35 } do p(m, "Strap", Vector3.new(0.1, 0.12, 0.7), CFrame.new(base + 0.1, z * 0.6, z), C(90, 60, 40), Enum.Material.Leather) end
end
