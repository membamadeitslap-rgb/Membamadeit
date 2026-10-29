-- Weapon model builder: return function(m, H) that builds parts into model m around a "Grip" part (the hand).
-- H = helpers from Weapons.luau: p(model, name, size, cframe, color, mat, shape), round(...) ellipsoid, C, cyl, up, wedge(part), katana(...)
-- Long/bladed weapons name their main part "Blade" (tip toward +Y) so the swing trails attach to it.
-- Wonder Woman's round Amazon shield: polished silver face, gold rim and inner ring, gold star boss.
-- Strapped on the forearm, face turned forward/outward.
return function(m, H)
	local p, C, cyl, round = H.p, H.C, H.cyl, H.round
	local V, CF, A, rad = Vector3.new, CFrame.new, CFrame.Angles, math.rad
	local GOLD, SILVER = C(225, 180, 55), C(200, 204, 214)
	local g = p(m, "Grip", V(0.2, 0.2, 0.2), CF(), C(0, 0, 0)); g.Transparency = 1
	local face = CF(-0.42, 0.15, 0.5) * A(0, 0, rad(148)) -- disc axis (X) points forward and out
	p(m, "Rim", V(0.14, 1.9, 1.9), face, GOLD, Enum.Material.Metal, cyl)
	p(m, "Face", V(0.18, 1.74, 1.74), face * CF(0.02, 0, 0), SILVER, Enum.Material.Metal, cyl)
	p(m, "Ring", V(0.2, 1.1, 1.1), face * CF(0.03, 0, 0), GOLD, Enum.Material.Metal, cyl)
	p(m, "Inner", V(0.22, 0.94, 0.94), face * CF(0.04, 0, 0), SILVER, Enum.Material.Metal, cyl)
	round(m, "Boss", V(0.3, 0.46, 0.46), face * CF(0.1, 0, 0), GOLD, Enum.Material.Metal)
	local s = p(m, "Star", V(0.02, 0.8, 0.8), face * CF(0.2, 0, 0), GOLD, Enum.Material.SmoothPlastic); s.Transparency = 0.97
	local sg = Instance.new("SurfaceGui"); sg.Face = Enum.NormalId.Right; sg.Parent = s
	local t = Instance.new("TextLabel"); t.Size = UDim2.fromScale(1, 1); t.BackgroundTransparency = 1; t.TextScaled = true
	t.Font = Enum.Font.GothamBlack; t.Text = "★"; t.TextColor3 = C(190, 30, 40); t.Parent = sg
end
