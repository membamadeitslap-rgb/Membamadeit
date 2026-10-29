-- Ink-doodle look (from the user's reference): flat matte colors, no shine, no self-shadowing,
-- and a thick black ink outline drawn client-side by client/Toon.client.luau (Highlight on tagged models).
local CollectionService = game:GetService("CollectionService")
local Toon = {}
local KEEP = { Neon = true, Glass = true, ForceField = true } -- glows, lenses, energy stay as they are
Toon.Tag = "ToonOutline"

-- Call after skin, costume and weapons are on the model. outlineOnly: keep materials (players' own lobby avatars).
function Toon.Apply(model, outlineOnly)
	for _, p in outlineOnly and {} or model:GetDescendants() do
		if p:IsA("BasePart") then
			if not KEEP[p.Material.Name] then p.Material = Enum.Material.SmoothPlastic end
			p.Reflectance = 0
			p.CastShadow = false
		end
	end
	CollectionService:AddTag(model, Toon.Tag)
end
return Toon
