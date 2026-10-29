-- Weapon model builder: return function(m, H) that builds parts into model m around a "Grip" part (the hand).
-- H = helpers from Weapons.luau: p(model, name, size, cframe, color, mat, shape), round(...) ellipsoid, C, cyl, up, wedge(part), katana(...)
-- Long/bladed weapons name their main part "Blade" (tip toward +Y) so the swing trails attach to it.
-- The crowbar (A Death in the Family): hex steel bar, gooseneck hook with a split claw at the far end, bent chisel at the butt.
-- Model +Z points up once held (Weapons.Attach turns +Y forward).
return function(m, H)
	local p, C, wedge = H.p, H.C, H.wedge
	local steel, worn = C(70, 72, 78), C(140, 140, 145)
	p(m, "Grip", Vector3.new(0.14, 0.7, 0.14), CFrame.new(), steel)
	local shaft = p(m, "Blade", Vector3.new(0.13, 2.2, 0.13), CFrame.new(0, 1.0, 0), steel)
	-- gooseneck: arc of short segments bending over toward -Z (down in the hand)
	local r, top = 0.28, 2.1
	local n = 5
	for i = 1, n do
		local a0, a1 = (i - 1) / n * math.pi, i / n * math.pi
		local am = (a0 + a1) / 2
		local pos = Vector3.new(0, top + math.sin(am) * r, -r + math.cos(am) * r)
		p(m, "Neck", Vector3.new(0.13, r * (a1 - a0) * 1.15, 0.13), CFrame.new(pos) * CFrame.Angles(-am, 0, 0), steel)
	end
	-- split claw pointing back down along the shaft
	for _, x in { -1, 1 } do
		local c = wedge(p(m, "Claw", Vector3.new(0.06, 0.3, 0.12), CFrame.new(x * 0.04, top - 0.12, -r * 2) * CFrame.Angles(0, 0, math.rad(180)), worn))
	end
	-- butt end: slight bend + flat chisel
	p(m, "Bend", Vector3.new(0.13, 0.3, 0.13), CFrame.new(0, -0.2, 0.04) * CFrame.Angles(math.rad(-20), 0, 0), steel)
	wedge(p(m, "Chisel", Vector3.new(0.13, 0.18, 0.13), CFrame.new(0, -0.42, 0.12) * CFrame.Angles(math.rad(160), 0, 0), worn))
end
