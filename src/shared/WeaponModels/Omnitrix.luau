-- Weapon model builder: return function(m, H) that builds parts into model m around a "Grip" part (the hand).
-- H = helpers from Weapons.luau: p(model, name, size, cframe, color, mat, shape), round(...) ellipsoid, C, cyl, up, wedge(part), katana(...)
-- Long/bladed weapons name their main part "Blade" (tip toward +Y) so the swing trails attach to it.
-- Ben's watch on the left wrist: gray band, black faceplate, green hourglass dial
return function(m, H)
	local p, C, cyl, up, wedge, katana, round = H.p, H.C, H.cyl, H.up, H.wedge, H.katana, H.round
	local g = p(m, "Grip", Vector3.one * 0.2, CFrame.new(), C(0, 0, 0)); g.Transparency = 1
	-- weapon +Z runs up the forearm, -X is the outer side of the left wrist
	p(m, "Band", Vector3.new(1.12, 1.12, 0.42), CFrame.new(0, 0, 0.45), C(205, 208, 212), Enum.Material.Metal)
	p(m, "BandStripe", Vector3.new(1.16, 1.16, 0.1), CFrame.new(0, 0, 0.45), C(30, 30, 35), Enum.Material.SmoothPlastic)
	p(m, "Housing", Vector3.new(0.22, 0.82, 0.82), CFrame.new(-0.62, 0, 0.45), C(210, 212, 216), Enum.Material.Metal, cyl)
	p(m, "Face", Vector3.new(0.08, 0.66, 0.66), CFrame.new(-0.75, 0, 0.45), C(20, 20, 24), Enum.Material.SmoothPlastic, cyl)
	local dialCF = CFrame.new(-0.8, 0, 0.45)
	for _, a in { 35, -35 } do -- hourglass: two crossing bars + top/bottom caps
		p(m, "Hourglass", Vector3.new(0.03, 0.06, 0.6), dialCF * CFrame.Angles(math.rad(a), 0, 0), C(80, 255, 90), Enum.Material.Neon)
	end
	for _, z in { -0.24, 0.24 } do p(m, "HourCap", Vector3.new(0.03, 0.36, 0.06), dialCF * CFrame.new(0, 0, z), C(80, 255, 90), Enum.Material.Neon) end
	p(m, "DialRing", Vector3.new(0.05, 0.72, 0.72), CFrame.new(-0.77, 0, 0.45), C(80, 255, 90), Enum.Material.Neon, cyl).Transparency = 0.6
	for _, y in { -0.35, 0.35 } do p(m, "Button", Vector3.new(0.18, 0.12, 0.16), CFrame.new(-0.6, y, 0.45), C(80, 220, 90), Enum.Material.SmoothPlastic) end
	local l = Instance.new("PointLight"); l.Color = C(90, 255, 100); l.Range = 5; l.Brightness = 1; l.Parent = m.Face
end
