-- Weapon model builder: return function(m, H) that builds parts into model m around a "Grip" part (the hand).
-- H = helpers from Weapons.luau: p(model, name, size, cframe, color, mat, shape), round(...) ellipsoid, C, cyl, up, wedge(part), katana(...)
-- Long/bladed weapons name their main part "Blade" (tip toward +Y) so the swing trails attach to it.
-- Lasso of Truth: glowing golden rope in three loose coils with a hanging tail.
return function(m, H)
	local p, C = H.p, H.C
	local V, CF, A = Vector3.new, CFrame.new, CFrame.Angles
	local ROPE = C(255, 210, 80)
	local g = p(m, "Grip", V(0.16, 0.3, 0.16), CF(), ROPE, Enum.Material.Neon)
	for c, r in { 0.55, 0.48, 0.42 } do
		local n = 10
		for i = 0, n - 1 do
			local a0, a1 = i / n * math.pi * 2, (i + 1) / n * math.pi * 2
			local p0 = V(-0.06 * c, math.cos(a0) * r + r, math.sin(a0) * r)
			local p1 = V(-0.06 * c, math.cos(a1) * r + r, math.sin(a1) * r)
			p(m, "Coil", V(0.07, 0.07, (p1 - p0).Magnitude * 1.1), CF((p0 + p1) / 2, p1), ROPE, Enum.Material.Neon)
		end
	end
	p(m, "Tail", V(0.07, 0.07, 0.9), CF(0, -0.3, 0.2) * A(1.2, 0, 0), ROPE, Enum.Material.Neon)
	local l = Instance.new("PointLight"); l.Color = ROPE; l.Range = 8; l.Brightness = 1; l.Parent = g
end
