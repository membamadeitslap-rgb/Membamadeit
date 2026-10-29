-- Weapon model builder: return function(m, H) that builds parts into model m around a "Grip" part (the hand).
-- H = helpers from Weapons.luau: p(model, name, size, cframe, color, mat, shape), round(...) ellipsoid, C, cyl, up, wedge(part), katana(...)
-- Long/bladed weapons name their main part "Blade" (tip toward +Y) so the swing trails attach to it.
-- Johnny Blaze's hellfire chain: wrapped around the fist, heavy oval links draping down past the knee and swinging forward,
-- a steel hook-dart on the end, burning along its length.
-- Weapon space on the hand: +Y = forward, -Z = down toward the ground.
return function(m, H)
	local p, C, round = H.p, H.C, H.round
	local STEEL, HOT = C(150, 145, 140), C(255, 140, 40)
	local grip = round(m, "Grip", Vector3.new(0.5, 0.5, 0.42), CFrame.new(0, 0.05, 0.05), C(120, 115, 110), Enum.Material.Metal)
	-- wraps around the knuckles
	for i = 0, 1 do
		p(m, "Wrap", Vector3.new(0.12, 0.62, 0.62), CFrame.new(-0.12 + i * 0.22, 0.05, 0.02) * CFrame.Angles(0, 0, 0), STEEL, Enum.Material.Metal, Enum.PartType.Cylinder)
	end
	-- drape: down from the fist, then curving forward (a hanging whip)
	local pts = {}
	local n = 14
	for i = 0, n do
		local t = i / n
		table.insert(pts, Vector3.new(0.05 * math.sin(t * 6), 0.15 + 0.9 * t * t, -0.25 - 1.55 * t + 0.35 * t * t))
	end
	for i = 1, n do
		local a, b = pts[i], pts[i + 1]
		local mid = (a + b) / 2
		local link = round(m, "Link" .. i, Vector3.new(0.09, 0.3, 0.18), CFrame.lookAt(mid, b) * CFrame.Angles(-math.pi / 2, 0, 0) * CFrame.Angles(0, (i % 2) * math.pi / 2, 0),
			STEEL:Lerp(HOT, i / n * 0.6), Enum.Material.Metal)
		if i % 4 == 0 then
			local f = Instance.new("ParticleEmitter"); f.Texture = "rbxasset://textures/particles/fire_main.dds"; f.LightEmission = 1; f.LightInfluence = 0
			f.Color = ColorSequence.new(C(255, 220, 120), C(255, 90, 20)); f.Size = NumberSequence.new(0.5, 0); f.Rate = 20
			f.Lifetime = NumberRange.new(0.25, 0.45); f.Speed = NumberRange.new(1, 2); f.Parent = link
		end
	end
	-- hook-dart at the end, pointing along the swing
	local last, prev = pts[n + 1], pts[n]
	local dir = (last - prev).Unit
	local dart = round(m, "Dart", Vector3.new(0.18, 0.5, 0.18), CFrame.lookAt(last + dir * 0.25, last + dir) * CFrame.Angles(-math.pi / 2, 0, 0), C(200, 205, 215), Enum.Material.Metal)
	round(m, "DartBarb", Vector3.new(0.08, 0.3, 0.08), dart.CFrame * CFrame.new(0, -0.05, 0.1) * CFrame.Angles(math.rad(35), 0, 0), C(200, 205, 215), Enum.Material.Metal)
end
