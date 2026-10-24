-- Rarity tiers. Purely cosmetic in combat; drives convoy spawn odds, price and base income.
local C = Color3.fromRGB
local R = {
	Order = { "Common", "Rare", "Epic", "Legendary", "Mythic", "Secret" },
	Tiers = {
		Common    = { Index = 1, Color = C(190, 190, 190), Weight = 55,  Price = 100,     Income = 2 },
		Rare      = { Index = 2, Color = C(60, 140, 255),  Weight = 25,  Price = 750,     Income = 10 },
		Epic      = { Index = 3, Color = C(170, 70, 255),  Weight = 12,  Price = 5000,    Income = 45 },
		Legendary = { Index = 4, Color = C(255, 190, 40),  Weight = 5,   Price = 30000,   Income = 200 },
		Mythic    = { Index = 5, Color = C(255, 50, 80),   Weight = 2.5, Price = 200000,  Income = 1000 },
		Secret    = { Index = 6, Color = C(255, 255, 255), Weight = 0.5, Price = 1500000, Income = 6000 },
	},
}
function R.Roll(rng)
	local total = 0
	for _, t in R.Tiers do total += t.Weight end
	local x = (rng or Random.new()):NextNumber() * total
	for _, name in R.Order do
		x -= R.Tiers[name].Weight
		if x <= 0 then return name end
	end
	return "Common"
end
function R.Format(n) -- 1500 -> "1.5K"
	for _, s in { { 1e9, "B" }, { 1e6, "M" }, { 1e3, "K" } } do
		if n >= s[1] then return (("%.1f"):format(n / s[1]):gsub("%.0$", "")) .. s[2] end
	end
	return tostring(math.floor(n))
end
return R
