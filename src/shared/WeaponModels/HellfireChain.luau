-- Weapon model builder: return function(m, H) that builds parts into model m around a "Grip" part (the hand).
-- H = helpers from Weapons.luau: p(model, name, size, cframe, color, mat, shape), round(...) ellipsoid, C, cyl, up, wedge(part), katana(...)
-- Long/bladed weapons name their main part "Blade" (tip toward +Y) so the swing trails attach to it.
-- Johnny Blaze's chain whip: links hanging from the fist, steel dart tip, burning
return function(m, H)
	local p, C, cyl, up, wedge, katana, round = H.p, H.C, H.cyl, H.up, H.wedge, H.katana, H.round
	p(m, "Grip", Vector3.new(0.4, 0.4, 0.4), CFrame.new(), C(150, 150, 160), Enum.Material.Metal)
	for i = 1, 11 do
		p(m, "Link" .. i, Vector3.new(0.12, 0.2, 0.28), CFrame.new(0, -i * 0.22, -0.04 * i) * CFrame.Angles(0, (i % 2) * math.rad(90), 0), C(175, 170, 165), Enum.Material.Metal)
	end
	local dart = p(m, "Dart", Vector3.new(0.22, 0.5, 0.22), CFrame.new(0, -2.75, -0.48), C(200, 205, 215), Enum.Material.Metal)
	local sm = Instance.new("SpecialMesh"); sm.MeshType = Enum.MeshType.Sphere; sm.Scale = Vector3.new(0.6, 1.4, 0.6); sm.Parent = dart
	local f = Instance.new("ParticleEmitter"); f.Texture = "rbxasset://textures/particles/fire_main.dds"; f.LightEmission = 1
	f.Color = ColorSequence.new(C(255, 220, 120), C(255, 90, 20)); f.Size = NumberSequence.new(0.6, 0); f.Rate = 30
	f.Lifetime = NumberRange.new(0.3, 0.5); f.Speed = NumberRange.new(1, 2); f.Parent = m.Link6
end
