-- Weapon model builder: return function(m, H) that builds parts into model m around a "Grip" part (the hand).
-- H = helpers from Weapons.luau: p(model, name, size, cframe, color, mat, shape), round(...) ellipsoid, C, cyl, up, wedge(part), katana(...)
-- Long/bladed weapons name their main part "Blade" (tip toward +Y) so the swing trails attach to it.
-- Infinity Gauntlet (worn on the left hand): gold armored fist, four plated fingers + thumb, forearm cuff with a flared rim,
-- Space/Reality/Power/Time stones on the knuckles, Mind on the thumb, Soul set in the back of the hand.
-- Weapon space on the hand: +Y = forward out of the knuckles, -Z = down the fist, +Z = up the forearm, -X = back of the left hand.
return function(m, H)
	local p, C, cyl, round = H.p, H.C, H.cyl, H.round
	local GOLD, DGOLD = C(222, 178, 52), C(176, 132, 36)
	local function gem(name, pos, color, size)
		round(m, name .. "Setting", Vector3.one * (size + 0.07), CFrame.new(pos), DGOLD, Enum.Material.Metal)
		local g = round(m, name, Vector3.one * size, CFrame.new(pos) * CFrame.new(0, 0.02, 0), color, Enum.Material.Neon)
		return g
	end
	round(m, "Grip", Vector3.new(1.0, 1.0, 0.95), CFrame.new(0, 0, 0.02), GOLD, Enum.Material.Metal)
	-- forearm cuff and flared rim
	p(m, "Cuff", Vector3.new(0.75, 1.12, 1.12), CFrame.new(0, 0, 0.75) * CFrame.Angles(0, math.rad(90), 0), GOLD, Enum.Material.Metal, cyl)
	p(m, "CuffRim", Vector3.new(0.12, 1.3, 1.3), CFrame.new(0, 0, 1.12) * CFrame.Angles(0, math.rad(90), 0), DGOLD, Enum.Material.Metal, cyl)
	p(m, "CuffBand", Vector3.new(0.1, 1.17, 1.17), CFrame.new(0, 0, 0.5) * CFrame.Angles(0, math.rad(90), 0), DGOLD, Enum.Material.Metal, cyl)
	-- curled fingers across the front of the fist, each with a stone on the knuckle
	local stones = { C(40, 90, 255), C(230, 30, 40), C(160, 40, 255), C(40, 220, 90) } -- Space, Reality, Power, Time
	for i = 1, 4 do
		local x = -0.36 + (i - 1) * 0.24
		round(m, "Finger", Vector3.new(0.23, 0.36, 0.62), CFrame.new(x, 0.38, -0.12), GOLD, Enum.Material.Metal)
		gem("Stone", Vector3.new(x, 0.55, 0.0), stones[i], 0.15)
	end
	-- thumb (inner side of the left hand) with the Mind stone
	round(m, "Thumb", Vector3.new(0.26, 0.5, 0.3), CFrame.new(0.42, 0.24, -0.06) * CFrame.Angles(math.rad(-20), 0, 0), GOLD, Enum.Material.Metal)
	gem("Mind", Vector3.new(0.5, 0.42, -0.04), C(255, 225, 40), 0.13)
	-- back-of-hand plate with the Soul stone
	round(m, "BackPlate", Vector3.new(0.18, 0.78, 0.8), CFrame.new(-0.47, 0.02, 0.02), DGOLD, Enum.Material.Metal)
	local soul = gem("Soul", Vector3.new(-0.56, 0.02, 0.04), C(255, 140, 20), 0.24)
	soul.CFrame = CFrame.new(-0.58, 0.02, 0.04)
end
