-- Signature weapons built from parts (no external meshes needed).
-- Weapons.Build(id) -> Model with a "Grip" part; Weapons.Attach(char, id, hand) welds it.
local W = {}
local function p(model, name, size, cf, color, mat, shape)
	local x = Instance.new("Part"); x.Name = name; x.Size = size; x.CFrame = cf; x.Color = color
	x.Material = mat or Enum.Material.Metal; x.CanCollide = false; x.CanQuery = false; x.Massless = true
	if shape then x.Shape = shape end
	x.Parent = model; return x
end
local C = Color3.fromRGB
local cyl = Enum.PartType.Cylinder
local up = CFrame.Angles(0, 0, math.rad(90)) -- cylinders are X-aligned; rotate to Y
local function wedge(part) local sm = Instance.new("SpecialMesh"); sm.MeshType = Enum.MeshType.Wedge; sm.Parent = part; return part end
local function round(model, name, size, cf, color, mat) -- ellipsoid part
	local x = p(model, name, size, cf, color, mat)
	local sm = Instance.new("SpecialMesh"); sm.MeshType = Enum.MeshType.Sphere; sm.Parent = x
	return x
end
local function katana(m, wrap, diamond, tsuba, blade, len) -- shared katana: wrapped tsuka, diamond hishigami, tsuba, curved blade "Blade"
	p(m, "Grip", Vector3.new(0.22, 1.1, 0.24), CFrame.new(), wrap, Enum.Material.Fabric)
	for i = 0, 3 do p(m, "Hishigami" .. i, Vector3.new(0.23, 0.12, 0.12), CFrame.new(0, -0.38 + i * 0.25, -0.06) * CFrame.Angles(math.rad(45), 0, 0), diamond, Enum.Material.SmoothPlastic) end
	p(m, "Kashira", Vector3.new(0.25, 0.12, 0.27), CFrame.new(0, -0.6, 0), C(40, 35, 30), Enum.Material.Metal)
	p(m, "Tsuba", Vector3.new(0.12, 0.62, 0.62), CFrame.new(0, 0.6, 0) * up, tsuba, Enum.Material.Metal, cyl)
	p(m, "Habaki", Vector3.new(0.12, 0.18, 0.28), CFrame.new(0, 0.74, 0.01), C(215, 175, 80), Enum.Material.Metal)
	len = len or 3.2
	local bl = p(m, "Blade", Vector3.new(0.06, len, 0.24), CFrame.new(0, 0.83 + len / 2, 0.06) * CFrame.Angles(math.rad(-3), 0, 0), blade, Enum.Material.Metal)
	p(m, "Edge", Vector3.new(0.04, len * 0.98, 0.05), bl.CFrame * CFrame.new(0, 0, -0.13), blade:Lerp(Color3.new(1, 1, 1), 0.5), Enum.Material.SmoothPlastic)
	local tip = wedge(p(m, "Kissaki", Vector3.new(0.06, 0.32, 0.24), bl.CFrame * CFrame.new(0, len / 2 + 0.16, 0), blade, Enum.Material.Metal))
	return bl, tip
end

-- One builder module per weapon: src/shared/WeaponModels/<WeaponId>.luau
local H = { p = p, C = C, cyl = cyl, up = up, wedge = wedge, katana = katana, round = round }
local B = {}
for _, mod in script.Parent:WaitForChild("WeaponModels"):GetChildren() do
	if mod:IsA("ModuleScript") then
		local build = require(mod)
		B[mod.Name] = function(m) build(m, H) end
	end
end

function W.Build(id)
	local m = Instance.new("Model"); m.Name = id
	B[id](m); m.PrimaryPart = m.Grip
	return m
end

-- Weld weapon to a hand. hand: "Right" | "Left". Supports R15 and R6.
function W.Attach(char, id, hand)
	local limb = char:FindFirstChild(hand .. "Hand") or char:FindFirstChild(hand .. " Arm")
	if not limb or not B[id] then return end
	local m = W.Build(id)
	local tipDown = limb.Name:find("Arm") and -1 or -0.2
	m:PivotTo(limb.CFrame * CFrame.new(0, tipDown, 0) * CFrame.Angles(math.rad(-90), 0, 0))
	for _, part in m:GetDescendants() do
		if part:IsA("BasePart") and part ~= m.Grip then
			local w = Instance.new("WeldConstraint"); w.Part0 = m.Grip; w.Part1 = part; w.Parent = part
		end
	end
	local w = Instance.new("WeldConstraint"); w.Part0 = limb; w.Part1 = m.Grip; w.Parent = m.Grip
	m.Name = "Weapon_" .. hand; m:SetAttribute("WeaponId", id); m.Parent = char
	return m
end

W.Ids = B
return W
