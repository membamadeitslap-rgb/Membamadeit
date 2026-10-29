-- Weapon model builder: return function(m, H) that builds parts into model m around a "Grip" part (the hand).
-- H = helpers from Weapons.luau: p(model, name, size, cframe, color, mat, shape), round(...) ellipsoid, C, cyl, up, wedge(part), katana(...)
-- Long/bladed weapons name their main part "Blade" (tip toward +Y) so the swing trails attach to it.
-- Iron Man palm repulsor: glowing emitter disc in a dark metal ring on the palm/underside of the gauntlet fist.
-- Model axes once attached: +Z = up the forearm, -Z = down past the knuckles, +Y = forward.
return function(m, H)
	local p, C, cyl = H.p, H.C, H.cyl
	local g = p(m, "Grip", Vector3.new(0.2, 0.2, 0.2), CFrame.new(), C(60, 60, 60)); g.Transparency = 1
	local flat = CFrame.Angles(0, math.rad(90), 0) -- cylinder axis along Z (facing down the arm)
	p(m, "Ring", Vector3.new(0.06, 0.36, 0.36), CFrame.new(0, 0, -0.17) * flat, C(60, 62, 70), Enum.Material.Metal, cyl)
	local glow = p(m, "Glow", Vector3.new(0.05, 0.26, 0.26), CFrame.new(0, 0, -0.2) * flat, C(190, 240, 255), Enum.Material.Neon, cyl)
	local l = Instance.new("PointLight"); l.Color = C(170, 225, 255); l.Range = 6; l.Brightness = 1.5; l.Parent = glow
end
