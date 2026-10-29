-- Minimal Roblox API mock so shared character code (Skins, Costume, Weapons, Body) runs in the luau CLI.
-- Only what the character builders touch: Vector3, CFrame, Color3, Enum, Instance tree, a few services.
local mock = {}

-- ===== Vector3 =====
local V3 = {}
local V3mt = {}
local function v3(x, y, z) return setmetatable({ X = x or 0, Y = y or 0, Z = z or 0 }, V3mt) end
V3mt.__index = function(v, k)
	if k == "Magnitude" then return math.sqrt(v.X * v.X + v.Y * v.Y + v.Z * v.Z) end
	if k == "Unit" then local m = math.sqrt(v.X * v.X + v.Y * v.Y + v.Z * v.Z); if m == 0 then return v3(0, 0, 0) end return v3(v.X / m, v.Y / m, v.Z / m) end
	if k == "x" then return v.X elseif k == "y" then return v.Y elseif k == "z" then return v.Z end
	return V3[k]
end
local function isnum(a) return type(a) == "number" end
V3mt.__add = function(a, b) return v3(a.X + b.X, a.Y + b.Y, a.Z + b.Z) end
V3mt.__sub = function(a, b) return v3(a.X - b.X, a.Y - b.Y, a.Z - b.Z) end
V3mt.__mul = function(a, b)
	if isnum(a) then return v3(b.X * a, b.Y * a, b.Z * a) end
	if isnum(b) then return v3(a.X * b, a.Y * b, a.Z * b) end
	return v3(a.X * b.X, a.Y * b.Y, a.Z * b.Z)
end
V3mt.__div = function(a, b)
	if isnum(b) then return v3(a.X / b, a.Y / b, a.Z / b) end
	return v3(a.X / b.X, a.Y / b.Y, a.Z / b.Z)
end
V3mt.__unm = function(a) return v3(-a.X, -a.Y, -a.Z) end
V3mt.__eq = function(a, b) return a.X == b.X and a.Y == b.Y and a.Z == b.Z end
V3mt.__tostring = function(a) return ("%g, %g, %g"):format(a.X, a.Y, a.Z) end
function V3.Dot(a, b) return a.X * b.X + a.Y * b.Y + a.Z * b.Z end
function V3.Cross(a, b) return v3(a.Y * b.Z - a.Z * b.Y, a.Z * b.X - a.X * b.Z, a.X * b.Y - a.Y * b.X) end
function V3.Lerp(a, b, t) return a + (b - a) * t end
function V3.Abs(a) return v3(math.abs(a.X), math.abs(a.Y), math.abs(a.Z)) end
function V3.Max(a, b) return v3(math.max(a.X, b.X), math.max(a.Y, b.Y), math.max(a.Z, b.Z)) end
function V3.Min(a, b) return v3(math.min(a.X, b.X), math.min(a.Y, b.Y), math.min(a.Z, b.Z)) end
local Vector3 = { new = v3, zero = v3(0, 0, 0), one = v3(1, 1, 1), xAxis = v3(1, 0, 0), yAxis = v3(0, 1, 0), zAxis = v3(0, 0, 1) }
mock.Vector3 = Vector3
mock.Vector2 = { new = function(x, y) return { X = x or 0, Y = y or 0 } end }

-- ===== CFrame (row-major rotation r[1..9], position p) =====
local CFmt = {}
local CF = {}
local function cf(p, r) return setmetatable({ p = p, r = r }, CFmt) end
local IR = { 1, 0, 0, 0, 1, 0, 0, 0, 1 }
local function mulR(a, b)
	local r = {}
	for i = 0, 2 do for j = 0, 2 do
		r[i * 3 + j + 1] = a[i * 3 + 1] * b[j + 1] + a[i * 3 + 2] * b[3 + j + 1] + a[i * 3 + 3] * b[6 + j + 1]
	end end
	return r
end
local function rotV(r, v) return v3(r[1] * v.X + r[2] * v.Y + r[3] * v.Z, r[4] * v.X + r[5] * v.Y + r[6] * v.Z, r[7] * v.X + r[8] * v.Y + r[9] * v.Z) end
local function rx(a) local c, s = math.cos(a), math.sin(a); return { 1, 0, 0, 0, c, -s, 0, s, c } end
local function ry(a) local c, s = math.cos(a), math.sin(a); return { c, 0, s, 0, 1, 0, -s, 0, c } end
local function rz(a) local c, s = math.cos(a), math.sin(a); return { c, -s, 0, s, c, 0, 0, 0, 1 } end
CFmt.__index = function(c, k)
	if k == "Position" or k == "p" then return rawget(c, "p") end
	if k == "X" then return c.p.X elseif k == "Y" then return c.p.Y elseif k == "Z" then return c.p.Z end
	local r = rawget(c, "r")
	if k == "LookVector" then return v3(-r[3], -r[6], -r[9]) end
	if k == "RightVector" then return v3(r[1], r[4], r[7]) end
	if k == "UpVector" then return v3(r[2], r[5], r[8]) end
	if k == "XVector" then return v3(r[1], r[4], r[7]) end
	if k == "YVector" then return v3(r[2], r[5], r[8]) end
	if k == "ZVector" then return v3(r[3], r[6], r[9]) end
	if k == "Rotation" then return cf(v3(0, 0, 0), r) end
	return CF[k]
end
CFmt.__mul = function(a, b)
	if getmetatable(b) == V3mt then return a.p + rotV(a.r, b) end
	return cf(a.p + rotV(a.r, b.p), mulR(a.r, b.r))
end
CFmt.__add = function(a, b) return cf(a.p + b, a.r) end
CFmt.__sub = function(a, b) return cf(a.p - b, a.r) end
function CF.Inverse(c)
	local r = c.r
	local t = { r[1], r[4], r[7], r[2], r[5], r[8], r[3], r[6], r[9] }
	return cf(-rotV(t, c.p), t)
end
function CF.PointToWorldSpace(c, v) return c * v end
function CF.PointToObjectSpace(c, v) return CF.Inverse(c) * v end
function CF.VectorToWorldSpace(c, v) return rotV(c.r, v) end
function CF.ToWorldSpace(c, o) return c * o end
function CF.ToObjectSpace(c, o) return CF.Inverse(c) * o end
function CF.GetComponents(c) local r = c.r; return c.p.X, c.p.Y, c.p.Z, r[1], r[2], r[3], r[4], r[5], r[6], r[7], r[8], r[9] end
function CF.Lerp(a, b, t) return cf(a.p:Lerp(b.p, t), t < 0.5 and a.r or b.r) end
function CF.ToEulerAnglesXYZ(c) local r = c.r; return math.atan2(-r[6], r[9]), math.asin(math.clamp(r[3], -1, 1)), math.atan2(-r[2], r[1]) end
local function fromMatrix(pos, x, y, z)
	z = z or x:Cross(y).Unit
	return cf(pos, { x.X, y.X, z.X, x.Y, y.Y, z.Y, x.Z, y.Z, z.Z })
end
local CFrame = {
	identity = cf(v3(0, 0, 0), IR),
	new = function(a, b, c, ...)
		if a == nil then return cf(v3(0, 0, 0), IR) end
		if type(a) == "number" then
			local rest = { ... }
			if #rest == 9 then return cf(v3(a, b, c), rest) end
			return cf(v3(a, b, c), IR)
		end
		if b then -- CFrame.new(pos, lookAt)
			local look = (b - a).Unit
			local z = -look
			local x = Vector3.yAxis:Cross(z)
			if x.Magnitude < 1e-6 then x = Vector3.xAxis else x = x.Unit end
			return fromMatrix(a, x, z:Cross(x), z)
		end
		return cf(a, IR)
	end,
	Angles = function(x, y, z) return cf(v3(0, 0, 0), mulR(mulR(rx(x), ry(y)), rz(z))) end,
	fromEulerAnglesYXZ = function(x, y, z) return cf(v3(0, 0, 0), mulR(mulR(ry(y), rx(x)), rz(z))) end,
	fromOrientation = function(x, y, z) return cf(v3(0, 0, 0), mulR(mulR(ry(y), rx(x)), rz(z))) end,
	fromAxisAngle = function(axis, a)
		local u = axis.Unit; local c, s, t = math.cos(a), math.sin(a), 1 - math.cos(a)
		return cf(v3(0, 0, 0), { t * u.X * u.X + c, t * u.X * u.Y - s * u.Z, t * u.X * u.Z + s * u.Y,
			t * u.X * u.Y + s * u.Z, t * u.Y * u.Y + c, t * u.Y * u.Z - s * u.X,
			t * u.X * u.Z - s * u.Y, t * u.Y * u.Z + s * u.X, t * u.Z * u.Z + c })
	end,
	fromMatrix = fromMatrix,
}
CFrame.fromEulerAnglesXYZ = CFrame.Angles
CFrame.lookAt = function(at, target, up)
	up = up or Vector3.yAxis
	local z = -(target - at).Unit
	local x = up:Cross(z)
	if x.Magnitude < 1e-6 then x = Vector3.xAxis else x = x.Unit end
	return fromMatrix(at, x, z:Cross(x), z)
end
mock.CFrame = CFrame

-- ===== Color3 =====
local C3mt = {}
local C3 = {}
C3mt.__index = C3
local function c3(r, g, b) return setmetatable({ R = r or 0, G = g or 0, B = b or 0 }, C3mt) end
function C3.Lerp(a, b, t) return c3(a.R + (b.R - a.R) * t, a.G + (b.G - a.G) * t, a.B + (b.B - a.B) * t) end
function C3.ToHSV(c)
	local r, g, b = c.R, c.G, c.B
	local mx, mn = math.max(r, g, b), math.min(r, g, b)
	local d = mx - mn
	local h = 0
	if d > 0 then
		if mx == r then h = ((g - b) / d) % 6 elseif mx == g then h = (b - r) / d + 2 else h = (r - g) / d + 4 end
		h /= 6
	end
	return h, mx == 0 and 0 or d / mx, mx
end
local function fromHSV(h, s, v)
	local i = math.floor(h * 6) % 6; local f = h * 6 - math.floor(h * 6)
	local p, q, t = v * (1 - s), v * (1 - f * s), v * (1 - (1 - f) * s)
	local m = ({ { v, t, p }, { q, v, p }, { p, v, t }, { p, q, v }, { t, p, v }, { v, p, q } })[i + 1]
	return c3(m[1], m[2], m[3])
end
mock.Color3 = { new = c3, fromRGB = function(r, g, b) return c3((r or 0) / 255, (g or 0) / 255, (b or 0) / 255) end, fromHSV = fromHSV,
	fromHex = function(h) h = h:gsub("#", ""); return c3(tonumber(h:sub(1, 2), 16) / 255, tonumber(h:sub(3, 4), 16) / 255, tonumber(h:sub(5, 6), 16) / 255) end }

-- ===== Misc value types (opaque) =====
local function opaque(name) return { new = function(...) return { __type = name, ... } end } end
mock.ColorSequence = opaque("ColorSequence")
mock.ColorSequenceKeypoint = opaque("ColorSequenceKeypoint")
mock.NumberSequence = opaque("NumberSequence")
mock.NumberSequenceKeypoint = opaque("NumberSequenceKeypoint")
mock.NumberRange = opaque("NumberRange")
mock.UDim = opaque("UDim")
mock.UDim2 = { new = function(...) return { ... } end, fromScale = function(...) return { ... } end, fromOffset = function(...) return { ... } end }
mock.TweenInfo = opaque("TweenInfo")
mock.Rect = opaque("Rect")
mock.PhysicalProperties = opaque("PhysicalProperties")

-- ===== Enum =====
local enumCache = {}
mock.Enum = setmetatable({}, { __index = function(_, typ)
	enumCache[typ] = enumCache[typ] or setmetatable({}, { __index = function(t, name)
		local e = { Name = name, EnumType = typ, Value = 0 }
		rawset(t, name, e); return e
	end })
	return enumCache[typ]
end })

-- ===== Signals =====
local function signal()
	return { Connect = function() return { Disconnect = function() end } end, Wait = function() return 0 end, Once = function() return { Disconnect = function() end } end }
end

-- ===== Instances =====
local PART_CLASSES = { Part = true, MeshPart = true, WedgePart = true, CornerWedgePart = true, TrussPart = true, UnionOperation = true }
local DEFAULTS = {
	Part = { Size = v3(4, 1, 2), Transparency = 0, Anchored = false, CanCollide = true, Material = mock.Enum.Material.Plastic, Shape = mock.Enum.PartType.Block, Reflectance = 0 },
	SpecialMesh = { MeshType = mock.Enum.MeshType.Head, Scale = v3(1, 1, 1), Offset = v3(0, 0, 0), MeshId = "", TextureId = "" },
	TextLabel = { Text = "", TextTransparency = 0, BackgroundTransparency = 0, Rotation = 0 },
	SurfaceGui = { Face = mock.Enum.NormalId.Front },
	Decal = { Face = mock.Enum.NormalId.Front, Texture = "", Transparency = 0 },
	Attachment = { Position = v3(0, 0, 0) },
}
DEFAULTS.MeshPart = DEFAULTS.Part; DEFAULTS.WedgePart = DEFAULTS.Part; DEFAULTS.CornerWedgePart = DEFAULTS.Part
local ISA = {
	BasePart = PART_CLASSES, PVInstance = { Model = true, Part = true, MeshPart = true, WedgePart = true },
	Light = { PointLight = true, SpotLight = true, SurfaceLight = true },
	GuiObject = { TextLabel = true, Frame = true, ImageLabel = true, TextButton = true },
	JointInstance = { Weld = true, Motor6D = true }, Constraint = { WeldConstraint = true },
	DataModelMesh = { SpecialMesh = true }, FileMesh = { SpecialMesh = true },
}
local Inst = {}
local Imt = {}
local function children(o) return rawget(o, "_children") end
local function props(o) return rawget(o, "_props") end
function Imt.__index(o, k)
	local m = Inst[k]; if m then return m end
	local p = props(o)
	if p[k] ~= nil then return p[k] end
	if k == "Position" and p.CFrame then return p.CFrame.p end
	if k == "Orientation" and p.CFrame then local x, y, z = CF.ToEulerAnglesXYZ(p.CFrame); return v3(math.deg(x), math.deg(y), math.deg(z)) end
	if k == "WorldPosition" and o.ClassName == "Attachment" then local par = p.Parent; return par and par.CFrame * p.Position or p.Position end
	if k == "WorldCFrame" and o.ClassName == "Attachment" then local par = p.Parent; return par and par.CFrame * CFrame.new(p.Position) or CFrame.new(p.Position) end
	for _, c in children(o) do if c.Name == k then return c end end
	if k == "Changed" or k == "ChildAdded" or k == "ChildRemoved" or k == "Touched" or k == "AncestryChanged" or k == "Died" or k == "Triggered" then return signal() end
	return nil
end
function Imt.__newindex(o, k, v)
	local p = props(o)
	if k == "Parent" then
		local old = p.Parent
		if old then local list = children(old); for i, c in list do if c == o then table.remove(list, i); break end end end
		p.Parent = v
		if v then table.insert(children(v), o) end
		return
	end
	if k == "Position" and PART_CLASSES[o.ClassName] then p.CFrame = cf(v, (p.CFrame or CFrame.identity).r); return end
	if k == "WorldPosition" and o.ClassName == "Attachment" then
		local par = p.Parent; p.Position = par and CF.Inverse(par.CFrame) * v or v; return
	end
	if k == "Orientation" and PART_CLASSES[o.ClassName] then
		local r = CFrame.fromOrientation(math.rad(v.X), math.rad(v.Y), math.rad(v.Z))
		p.CFrame = cf((p.CFrame or CFrame.identity).p, r.r); return
	end
	if k == "Shape" and v.Name == "Ball" then local s = p.Size; p.Shape = v; p.Size = v3(s.X, s.X, s.X); return end
	p[k] = v
end
Imt.__tostring = function(o) return o.Name end

local function new(class, parent)
	local o = setmetatable({ _children = {}, _props = { ClassName = class, Name = class, Attributes = {} } }, Imt)
	for k, v in DEFAULTS[class] or {} do props(o)[k] = v end
	if PART_CLASSES[class] then props(o).CFrame = CFrame.identity; props(o).Color = c3(0.64, 0.64, 0.64) end
	if parent then o.Parent = parent end
	return o
end
mock.Instance = { new = new }

function Inst.IsA(o, c) return o.ClassName == c or (ISA[c] and ISA[c][o.ClassName]) or c == "Instance" or false end
function Inst.GetChildren(o) return table.clone(children(o)) end
function Inst.GetDescendants(o)
	local out = {}
	local function walk(x) for _, c in children(x) do table.insert(out, c); walk(c) end end
	walk(o); return out
end
function Inst.FindFirstChild(o, name, rec)
	for _, c in children(o) do if c.Name == name then return c end end
	if rec then for _, c in children(o) do local f = Inst.FindFirstChild(c, name, true); if f then return f end end end
	return nil
end
function Inst.WaitForChild(o, name)
	local c = Inst.FindFirstChild(o, name); if not c then error("WaitForChild: missing " .. name .. " in " .. o.Name) end
	return c
end
function Inst.FindFirstChildOfClass(o, cls) for _, c in children(o) do if c.ClassName == cls then return c end end return nil end
function Inst.FindFirstChildWhichIsA(o, cls, rec)
	for _, c in children(o) do if Inst.IsA(c, cls) then return c end end
	if rec then for _, c in children(o) do local f = Inst.FindFirstChildWhichIsA(c, cls, true); if f then return f end end end
	return nil
end
function Inst.FindFirstAncestorOfClass(o, cls) local p = o.Parent; while p do if p.ClassName == cls then return p end; p = p.Parent end return nil end
function Inst.FindFirstAncestorWhichIsA(o, cls) local p = o.Parent; while p do if Inst.IsA(p, cls) then return p end; p = p.Parent end return nil end
function Inst.FindFirstAncestor(o, name) local p = o.Parent; while p do if p.Name == name then return p end; p = p.Parent end return nil end
function Inst.IsDescendantOf(o, a) local p = o.Parent; while p do if p == a then return true end; p = p.Parent end return false end
function Inst.Destroy(o) o.Parent = nil; props(o).Destroyed = true end
function Inst.ClearAllChildren(o) for _, c in Inst.GetChildren(o) do c.Parent = nil end end
function Inst.SetAttribute(o, k, v) props(o).Attributes[k] = v end
function Inst.GetAttribute(o, k) return props(o).Attributes[k] end
function Inst.GetAttributes(o) return table.clone(props(o).Attributes) end
function Inst.GetAttributeChangedSignal() return signal() end
function Inst.GetPropertyChangedSignal() return signal() end
function Inst.Emit() end
function Inst.Play() end
function Inst.Stop() end
function Inst.Clone(o)
	local c = new(o.ClassName)
	for k, v in props(o) do if k ~= "Parent" then props(c)[k] = (k == "Attributes") and table.clone(v) or v end end
	for _, ch in children(o) do Inst.Clone(ch).Parent = c end
	return c
end
function Inst.GetPivot(o)
	if PART_CLASSES[o.ClassName] then return o.CFrame end
	if o.PrimaryPart then return o.PrimaryPart.CFrame end
	return props(o).WorldPivot or CFrame.identity
end
function Inst.PivotTo(o, target)
	local delta = target * CF.Inverse(Inst.GetPivot(o))
	if PART_CLASSES[o.ClassName] then o.CFrame = target; return end
	for _, d in Inst.GetDescendants(o) do if PART_CLASSES[d.ClassName] then d.CFrame = delta * d.CFrame end end
	if not o.PrimaryPart then props(o).WorldPivot = target end
end
function Inst.SetPrimaryPartCFrame(o, t) Inst.PivotTo(o, t) end
function Inst.GetBoundingBox(o)
	local mn, mx
	for _, d in Inst.GetDescendants(o) do
		if PART_CLASSES[d.ClassName] then
			mn = mn and mn:Min(d.Position) or d.Position; mx = mx and mx:Max(d.Position) or d.Position
		end
	end
	mn = mn or v3(0, 0, 0); mx = mx or v3(0, 0, 0)
	return CFrame.new((mn + mx) / 2), mx - mn
end
function Inst.GetMass(o) return (o.Size.X * o.Size.Y * o.Size.Z) end
function Inst.ScaleTo() end
function Inst.GetScale() return 1 end
function Inst.BuildRigFromAttachments(hum) -- re-seat every Motor6D from its rig attachments (as Roblox does)
	local model = hum.Parent
	for _, d in Inst.GetDescendants(model) do
		if d.ClassName == "Motor6D" and d.Part0 and d.Part1 then
			local name = d.Name .. "RigAttachment"
			local a0, a1 = Inst.FindFirstChild(d.Part0, name), Inst.FindFirstChild(d.Part1, name)
			if a0 and a1 then
				d.C0 = CFrame.new(a0.Position); d.C1 = CFrame.new(a1.Position)
			end
		end
	end
	mock.SolveRig(model)
end

-- Place parts from their Motor6Ds (root first), like the engine does every frame
function mock.SolveRig(model)
	local root = Inst.FindFirstChild(model, "HumanoidRootPart")
	if not root then return end
	local done = { [root] = true }
	local motors = {}
	for _, d in Inst.GetDescendants(model) do if d.ClassName == "Motor6D" then table.insert(motors, d) end end
	local changed = true
	while changed do
		changed = false
		for _, m in motors do
			if m.Part0 and m.Part1 and done[m.Part0] and not done[m.Part1] then
				m.Part1.CFrame = m.Part0.CFrame * m.C0 * CF.Inverse(m.C1)
				done[m.Part1] = true; changed = true
			end
		end
	end
end

-- ===== R15 blocky rig (default CreateHumanoidModelFromDescription) =====
local R15 = {
	-- name, size, parent, joint name, C0 (in parent), C1 (in part)
	{ "LowerTorso", v3(2, 0.4, 1), "HumanoidRootPart", "Root", v3(0, -0.8, 0), v3(0, 0, 0) },
	{ "UpperTorso", v3(2, 1.6, 1), "LowerTorso", "Waist", v3(0, 0.2, 0), v3(0, -0.8, 0) },
	{ "Head", v3(1.2, 1.2, 1.2), "UpperTorso", "Neck", v3(0, 0.8, 0), v3(0, -0.6, 0) },
	{ "LeftUpperArm", v3(1, 0.85, 1), "UpperTorso", "LeftShoulder", v3(-1, 0.8, 0), v3(0.5, 0.425, 0) },
	{ "LeftLowerArm", v3(1, 0.85, 1), "LeftUpperArm", "LeftElbow", v3(0, -0.425, 0), v3(0, 0.425, 0) },
	{ "LeftHand", v3(1, 0.3, 1), "LeftLowerArm", "LeftWrist", v3(0, -0.425, 0), v3(0, 0.15, 0) },
	{ "RightUpperArm", v3(1, 0.85, 1), "UpperTorso", "RightShoulder", v3(1, 0.8, 0), v3(-0.5, 0.425, 0) },
	{ "RightLowerArm", v3(1, 0.85, 1), "RightUpperArm", "RightElbow", v3(0, -0.425, 0), v3(0, 0.425, 0) },
	{ "RightHand", v3(1, 0.3, 1), "RightLowerArm", "RightWrist", v3(0, -0.425, 0), v3(0, 0.15, 0) },
	{ "LeftUpperLeg", v3(1, 0.85, 1), "LowerTorso", "LeftHip", v3(-0.5, -0.2, 0), v3(0, 0.425, 0) },
	{ "LeftLowerLeg", v3(1, 0.85, 1), "LeftUpperLeg", "LeftKnee", v3(0, -0.425, 0), v3(0, 0.425, 0) },
	{ "LeftFoot", v3(1, 0.3, 1), "LeftLowerLeg", "LeftAnkle", v3(0, -0.425, 0), v3(0, 0.15, 0) },
	{ "RightUpperLeg", v3(1, 0.85, 1), "LowerTorso", "RightHip", v3(0.5, -0.2, 0), v3(0, 0.425, 0) },
	{ "RightLowerLeg", v3(1, 0.85, 1), "RightUpperLeg", "RightKnee", v3(0, -0.425, 0), v3(0, 0.425, 0) },
	{ "RightFoot", v3(1, 0.3, 1), "RightLowerLeg", "RightAnkle", v3(0, -0.425, 0), v3(0, 0.15, 0) },
}
function mock.BuildR15()
	local m = new("Model"); m.Name = "Rig"
	local hum = new("Humanoid", m); hum.HipHeight = 2 -- ground at y = -3 under the root
	local root = new("Part", m); root.Name = "HumanoidRootPart"; root.Size = v3(2, 2, 1); root.Transparency = 1
	m.PrimaryPart = root
	local parts = { HumanoidRootPart = root }
	for _, j in R15 do
		local p = new("MeshPart"); p.Name = j[1]; p.Size = j[2]; p.Color = c3(0.64, 0.64, 0.64); p.Parent = m
		parts[j[1]] = p
		local a0 = new("Attachment", parts[j[3]]); a0.Name = j[4] .. "RigAttachment"; a0.Position = j[5]
		local a1 = new("Attachment", p); a1.Name = j[4] .. "RigAttachment"; a1.Position = j[6]
		local mo = new("Motor6D", p); mo.Name = j[4]; mo.Part0 = parts[j[3]]; mo.Part1 = p; mo.C0 = CFrame.new(j[5]); mo.C1 = CFrame.new(j[6])
	end
	local face = new("Decal", parts.Head); face.Name = "face"
	mock.SolveRig(m)
	return m
end

-- ===== Services / globals =====
local services = {
	Players = { CreateHumanoidModelFromDescription = function() return mock.BuildR15() end, LocalPlayer = nil, GetPlayers = function() return {} end,
		GetPlayerFromCharacter = function() return nil end, PlayerAdded = signal(), PlayerRemoving = signal() },
	CollectionService = { AddTag = function() end, GetTagged = function() return {} end, HasTag = function() return false end, GetInstanceAddedSignal = function() return signal() end },
	RunService = { IsServer = function() return true end, IsClient = function() return false end, IsStudio = function() return false end, Heartbeat = signal(), RenderStepped = signal(), Stepped = signal() },
	TweenService = { Create = function() return { Play = function() end, Completed = signal(), Cancel = function() end } end },
	Debris = { AddItem = function() end },
	Lighting = new("Folder"),
	ReplicatedStorage = new("Folder"),
}
mock.game = { GetService = function(_, name) return services[name] or new("Folder") end }
mock.workspace = new("Folder"); mock.workspace.Name = "Workspace"
mock.services = services
mock.task = { wait = function() return 0 end, spawn = function(f, ...) return f(...) end, delay = function() end, defer = function() end }
mock.warn = function(...) print("WARN", ...) end
mock.typeof = function(v)
	local mt = getmetatable(v)
	if mt == V3mt then return "Vector3" elseif mt == CFmt then return "CFrame" elseif mt == C3mt then return "Color3" elseif mt == Imt then return "Instance" end
	return type(v)
end
mock.tick = function() return 0 end
mock.os = { clock = function() return 0 end, time = function() return 0 end }
mock.Random = { new = function() return { NextNumber = function(_, a, b) return (a or 0) + ((b or 1) - (a or 0)) * 0.5 end, NextInteger = function(_, a) return a end } end }

-- ===== Scene dump =====
local function enc(v)
	local t = type(v)
	if t == "number" then return (v ~= v or v == math.huge or v == -math.huge) and "0" or ("%.4f"):format(v) end
	if t == "string" then return '"' .. v:gsub('\\', '\\\\'):gsub('"', '\\"'):gsub("\n", "\\n") .. '"' end
	if t == "boolean" then return tostring(v) end
	if t == "table" then
		if v[1] ~= nil or next(v) == nil then
			local out = {}
			for _, x in v do table.insert(out, enc(x)) end
			return "[" .. table.concat(out, ",") .. "]"
		end
		local out = {}
		for k, x in v do table.insert(out, enc(tostring(k)) .. ":" .. enc(x)) end
		return "{" .. table.concat(out, ",") .. "}"
	end
	return "null"
end
mock.json = enc
function mock.Dump(model)
	local parts = {}
	for _, d in Inst.GetDescendants(model) do
		if PART_CLASSES[d.ClassName] and d.Name ~= "HumanoidRootPart" and (d.Transparency or 0) < 0.98 then
			local c = d.CFrame
			local e = { name = d.Name, class = d.ClassName, size = { d.Size.X, d.Size.Y, d.Size.Z },
				cf = { c.p.X, c.p.Y, c.p.Z, table.unpack(c.r) }, color = { d.Color.R, d.Color.G, d.Color.B },
				mat = d.Material and d.Material.Name or "Plastic", shape = d.Shape and d.Shape.Name or "Block", tr = d.Transparency or 0 }
			local sm = Inst.FindFirstChildOfClass(d, "SpecialMesh")
			if sm then e.mesh = sm.MeshType.Name; e.meshScale = { sm.Scale.X, sm.Scale.Y, sm.Scale.Z } end
			for _, g in Inst.GetChildren(d) do
				if g.ClassName == "SurfaceGui" then
					for _, l in Inst.GetDescendants(g) do
						if l.ClassName == "TextLabel" and l.Text ~= "" then
							e.texts = e.texts or {}
							table.insert(e.texts, { face = g.Face.Name, text = l.Text, color = { l.TextColor3 and l.TextColor3.R or 1, l.TextColor3 and l.TextColor3.G or 1, l.TextColor3 and l.TextColor3.B or 1 } })
						end
					end
				end
			end
			table.insert(parts, e)
		end
	end
	return parts
end
return mock
