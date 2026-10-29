-- Paper-cutout look (Paper Mario style): squash a finished character to a thin sheet along its
-- facing axis. Works on display models and characters: welds are re-seated after the parts move.
local Paper = {}

-- k = remaining depth fraction (0.15 = thin card)
function Paper.Flatten(model, k)
	k = k or 0.15
	local root = model:FindFirstChild("HumanoidRootPart"); if not root then return end
	local rootCF = root.CFrame
	local welds = {}
	for _, w in model:GetDescendants() do
		if w:IsA("WeldConstraint") and w.Enabled then w.Enabled = false; table.insert(welds, w) end
	end
	for _, p in model:GetDescendants() do
		if p:IsA("BasePart") and p ~= root then
			local cf = rootCF:ToObjectSpace(p.CFrame)
			-- balls/cylinders would stay round: turn them into scalable mesh shapes first
			if p.Shape == Enum.PartType.Ball and not p:FindFirstChildOfClass("SpecialMesh") then
				p.Shape = Enum.PartType.Block
				local m = Instance.new("SpecialMesh"); m.MeshType = Enum.MeshType.Sphere; m.Parent = p
			end
			local s = p.Size
			local function f(axis) return math.sqrt(axis.X ^ 2 + axis.Y ^ 2 + (k * axis.Z) ^ 2) end
			local ns = Vector3.new(s.X * f(cf.RightVector), s.Y * f(cf.UpVector), s.Z * f(cf.LookVector))
			if p.Shape == Enum.PartType.Cylinder then ns = Vector3.new(ns.X, s.Y, s.Z) end -- keep round tubes round
			p.Size = ns
			p.CFrame = rootCF * (CFrame.new(cf.X, cf.Y, cf.Z * k) * cf.Rotation)
		end
	end
	for _, j in model:GetDescendants() do -- body joints
		if j:IsA("Motor6D") then
			j.C0 = CFrame.new(j.C0.X, j.C0.Y, j.C0.Z * k) * j.C0.Rotation
			j.C1 = CFrame.new(j.C1.X, j.C1.Y, j.C1.Z * k) * j.C1.Rotation
		end
	end
	for _, w in welds do w.Enabled = true end
	model:SetAttribute("Paper", true)
end
return Paper
