-- Weapon model builder: return function(m, H) that builds parts into model m around a "Grip" part (the hand).
-- H = helpers from Weapons.luau: p(model, name, size, cframe, color, mat, shape), round(...) ellipsoid, C, cyl, up, wedge(part), katana(...)
-- Long/bladed weapons name their main part "Blade" (tip toward +Y) so the swing trails attach to it.
-- Samurai Jack's god-forged katana: white/black diamond-wrapped grip, round gold tsuba, long clean blade
return function(m, H)
	local p, C, cyl, up, wedge, katana, round = H.p, H.C, H.cyl, H.up, H.wedge, H.katana, H.round
	katana(m, C(240, 238, 230), C(25, 25, 30), C(205, 165, 60), C(225, 230, 240), 3.4)
end
