-- Weapon model builder: return function(m, H) that builds parts into model m around a "Grip" part (the hand).
-- H = helpers from Weapons.luau: p(model, name, size, cframe, color, mat, shape), round(...) ellipsoid, C, cyl, up, wedge(part), katana(...)
-- Long/bladed weapons name their main part "Blade" (tip toward +Y) so the swing trails attach to it.
-- Wonder Woman's God Killer: long straight double-edged silver blade with a fuller, gold winged crossguard,
-- leather-wrapped grip, gold pommel.
return function(m, H)
	local p, C, cyl, up, wedge, round = H.p, H.C, H.cyl, H.up, H.wedge, H.round
	local V, CF, A, rad = Vector3.new, CFrame.new, CFrame.Angles, math.rad
	local GOLD, STEEL, EDGE = C(225, 180, 55), C(200, 205, 215), C(235, 238, 245)
	p(m, "Grip", V(0.18, 0.75, 0.18), CF(), C(90, 55, 35), Enum.Material.Leather)
	for i = 0, 2 do p(m, "Wrap", V(0.2, 0.05, 0.2), CF(0, -0.25 + i * 0.25, 0), C(60, 35, 22), Enum.Material.Leather) end
	round(m, "Pommel", V(0.26, 0.24, 0.26), CF(0, -0.47, 0), GOLD, Enum.Material.Metal)
	-- crossguard: center block + wings swept up toward the blade
	p(m, "Guard", V(0.16, 0.18, 0.3), CF(0, 0.45, 0), GOLD, Enum.Material.Metal)
	for _, z in { -1, 1 } do
		local w = p(m, "GuardWing", V(0.12, 0.14, 0.42), CF(0, 0.5, z * 0.3) * A(z * rad(-18), 0, 0), GOLD, Enum.Material.Metal)
		wedge(p(m, "GuardTip", V(0.12, 0.2, 0.14), CF(0, 0.6, z * 0.55) * A(0, z > 0 and 0 or math.pi, 0), GOLD, Enum.Material.Metal))
	end
	local len = 3.0
	local bl = p(m, "Blade", V(0.06, len, 0.3), CF(0, 0.54 + len / 2, 0), STEEL, Enum.Material.Metal)
	p(m, "Fuller", V(0.07, len * 0.75, 0.06), CF(0, 0.54 + len * 0.42, 0), C(150, 155, 168), Enum.Material.Metal)
	for _, z in { -1, 1 } do p(m, "Edge", V(0.03, len, 0.05), CF(0, 0.54 + len / 2, z * 0.15), EDGE, Enum.Material.SmoothPlastic) end
	-- point: two wedges meeting at the tip
	for _, z in { -1, 1 } do
		wedge(p(m, "Tip", V(0.06, 0.4, 0.15), CF(0, 0.54 + len + 0.2, z * 0.075) * A(0, z > 0 and math.pi or 0, 0), STEEL, Enum.Material.Metal))
	end
end
