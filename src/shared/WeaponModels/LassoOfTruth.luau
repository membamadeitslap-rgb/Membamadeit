-- Weapon model builder: return function(m, H) that builds parts into model m around a "Grip" part (the hand).
-- H = helpers from Weapons.luau: p(model, name, size, cframe, color, mat, shape), round(...) ellipsoid, C, cyl, up, wedge(part), katana(...)
-- Long/bladed weapons name their main part "Blade" (tip toward +Y) so the swing trails attach to it.
-- glowing gold coil at the hip/hand
return function(m, H)
	local p, C, cyl, up, wedge, katana, round = H.p, H.C, H.cyl, H.up, H.wedge, H.katana, H.round
	local g = p(m, "Grip", Vector3.new(0.15, 1.1, 1.1), CFrame.new(), C(255, 210, 80), Enum.Material.Neon, cyl); g.Transparency = 0.2
end
