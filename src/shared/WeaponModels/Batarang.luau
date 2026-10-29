-- Weapon model builder: return function(m, H) that builds parts into model m around a "Grip" part (the hand).
-- H = helpers from Weapons.luau: p(model, name, size, cframe, color, mat, shape), round(...) ellipsoid, C, cyl, up, wedge(part), katana(...)
-- Long/bladed weapons name their main part "Blade" (tip toward +Y) so the swing trails attach to it.
-- Batarang: flat black bat silhouette (raised wing tips, scalloped trailing edge) pinched between the fingers.
-- Lies in the model's XZ plane (Z = up once held), thin along Y (pointing out of the fist).
return function(m, H)
	local p, C, wedge, round = H.p, H.C, H.wedge, H.round
	local A, rad, CF, V = CFrame.Angles, math.rad, CFrame.new, Vector3.new
	local BLK, EDGE = C(28, 28, 34), C(70, 72, 82)
	local g = p(m, "Grip", V(0.2, 0.2, 0.2), CF(), BLK); g.Transparency = 1
	local base = CF(0, 0.32, -0.12) -- just in front of / above the knuckles
	-- flat triangle in the XZ plane, apex toward local +Z after `cf`
	local function tri(name, w, h, cf, color)
		local f = cf * A(rad(90), 0, 0) * A(0, rad(90), 0)
		wedge(p(m, name, V(0.05, h, w / 2), f * CF(0, 0, -w / 4), color, Enum.Material.Metal))
		wedge(p(m, name, V(0.05, h, w / 2), f * CF(0, 0, w / 4) * A(0, math.pi, 0), color, Enum.Material.Metal))
	end
	round(m, "Blade", V(0.16, 0.07, 0.36), base, BLK, Enum.Material.Metal) -- body
	round(m, "BatHead", V(0.12, 0.07, 0.14), base * CF(0, 0, 0.2), BLK, Enum.Material.Metal)
	for _, x in { -1, 1 } do
		tri("Ear", 0.06, 0.1, base * CF(x * 0.04, 0, 0.3), BLK)
		tri("Wing", 0.3, 0.55, base * CF(x * 0.32, 0, 0.07) * A(0, rad(x * 80), 0), BLK)
		tri("Scallop", 0.2, 0.22, base * CF(x * 0.36, 0, -0.08) * A(0, math.pi + rad(-x * 10), 0), BLK)
		tri("Scallop", 0.18, 0.18, base * CF(x * 0.18, 0, -0.1) * A(0, math.pi, 0), BLK)
		p(m, "Edge", V(0.5, 0.075, 0.02), base * CF(x * 0.31, 0, 0.17) * A(0, rad(x * 12), 0), EDGE, Enum.Material.Metal) -- sharpened leading edge
	end
end
