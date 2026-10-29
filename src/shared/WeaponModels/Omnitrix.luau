-- Weapon model builder: return function(m, H) that builds parts into model m around a "Grip" part (the hand).
-- H = helpers from Weapons.luau: p(model, name, size, cframe, color, mat, shape), round(...) ellipsoid, C, cyl, up, wedge(part), katana(...)
-- Long/bladed weapons name their main part "Blade" (tip toward +Y) so the swing trails attach to it.
-- The original-series Omnitrix on Ben's left wrist, sized to a kid's forearm: chunky white/gray rounded band with black side panels,
-- raised round housing, black faceplate with the green hourglass dial, two green side buttons.
return function(m, H)
	local p, C, cyl, round = H.p, H.C, H.cyl, H.round
	local g = p(m, "Grip", Vector3.one * 0.2, CFrame.new(), C(0, 0, 0)); g.Transparency = 1
	-- weapon +Z runs up the forearm, -X is the outer side of the left wrist
	local z = 0.42
	local SHELL, DARK, GLOW = C(225, 228, 232), C(30, 30, 35), C(80, 255, 90)
	p(m, "Band", Vector3.new(0.3, 0.64, 0.64), CFrame.new(0, 0, z) * CFrame.Angles(0, math.rad(90), 0), SHELL, Enum.Material.SmoothPlastic, cyl)
	p(m, "BandStripe", Vector3.new(0.08, 0.66, 0.66), CFrame.new(0, 0, z - 0.08) * CFrame.Angles(0, math.rad(90), 0), DARK, Enum.Material.SmoothPlastic, cyl)
	p(m, "BandStripe", Vector3.new(0.08, 0.66, 0.66), CFrame.new(0, 0, z + 0.08) * CFrame.Angles(0, math.rad(90), 0), DARK, Enum.Material.SmoothPlastic, cyl)
	round(m, "Housing", Vector3.new(0.3, 0.5, 0.5), CFrame.new(-0.3, 0, z), SHELL, Enum.Material.SmoothPlastic)
	p(m, "Face", Vector3.new(0.06, 0.4, 0.4), CFrame.new(-0.44, 0, z), DARK, Enum.Material.SmoothPlastic, cyl)
	local dialCF = CFrame.new(-0.475, 0, z)
	for _, a in { 35, -35 } do p(m, "Hourglass", Vector3.new(0.02, 0.05, 0.34), dialCF * CFrame.Angles(math.rad(a), 0, 0), GLOW, Enum.Material.Neon) end
	for _, dz in { -0.14, 0.14 } do p(m, "HourCap", Vector3.new(0.02, 0.22, 0.04), dialCF * CFrame.new(0, 0, dz), GLOW, Enum.Material.Neon) end
	p(m, "DialRing", Vector3.new(0.03, 0.44, 0.44), CFrame.new(-0.455, 0, z), C(90, 200, 90), Enum.Material.SmoothPlastic, cyl)
	for _, y in { -0.24, 0.24 } do p(m, "Button", Vector3.new(0.12, 0.08, 0.1), CFrame.new(-0.3, y, z), C(80, 210, 90), Enum.Material.SmoothPlastic) end
	local l = Instance.new("PointLight"); l.Color = C(90, 255, 100); l.Range = 5; l.Brightness = 1; l.Parent = m.Face
end
