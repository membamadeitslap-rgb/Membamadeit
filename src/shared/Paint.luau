-- Paint: printed-suit graphics drawn in code onto part faces (SurfaceGui + Frames), so characters get
-- texture-level detail (web lines, armor plates, seams, logos, buttons) without uploading images.
-- Coordinates are fractions of the face as you look at it: x 0 = left, 1 = right; y 0 = top, 1 = bottom.
--   local f = Paint.Face(part, "Front")           -- "Front" | "Back" | "Left" | "Right" | "Top" | "Bottom"
--   f:Fill(color, opt)                              -- base color of the whole face (+ dark bevel rim unless opt.bevel == false)
--   f:Rect(x, y, w, h, color, opt)                  -- box from its top-left; opt.rot (deg), opt.round (0..0.5), opt.stroke/strokeColor (px), opt.alpha, opt.z, opt.grad = { colorA, colorB, rotDeg }
--   f:Box(cx, cy, w, h, color, opt)                 -- same, from its center
--   f:Line(x1, y1, x2, y2, thick, color, opt)       -- thick = fraction of the face height
--   f:Circle(cx, cy, r, color, opt)                 -- r = fraction of the face height
--   f:Ring(cx, cy, r, thick, color, opt)            -- outline circle
--   f:Text(str, cx, cy, w, h, color, opt)           -- opt.font, opt.rot
--   f:Poly({ {x,y}, ... }, thick, color, opt)       -- open polyline (use for curves)
-- Faces auto-size their pixel density; keep each face under ~60 shapes.
local Paint = {}
local PPS = 48 -- pixels per stud

local NORMALS = { Front = Enum.NormalId.Front, Back = Enum.NormalId.Back, Left = Enum.NormalId.Left, Right = Enum.NormalId.Right, Top = Enum.NormalId.Top, Bottom = Enum.NormalId.Bottom }
local function faceSize(part, face)
	local s = part.Size
	if face == "Front" or face == "Back" then return s.X, s.Y end
	if face == "Left" or face == "Right" then return s.Z, s.Y end
	return s.X, s.Z
end

local F = {}
F.__index = F

function Paint.Face(part, face)
	face = face or "Front"
	local name = "Paint_" .. face
	local gui = part:FindFirstChild(name)
	local w, h = faceSize(part, face)
	if not gui then
		gui = Instance.new("SurfaceGui"); gui.Name = name; gui.Face = NORMALS[face]
		gui.SizingMode = Enum.SurfaceGuiSizingMode.PixelsPerStud; gui.PixelsPerStud = PPS
		gui.LightInfluence = 1; gui.ClipsDescendants = true; gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling; gui.MaxDistance = 150 -- culled far away (many heroes on pedestals)
		gui.Parent = part
	end
	return setmetatable({ gui = gui, w = w * PPS, h = h * PPS, z = 1 }, F)
end

local function frame(self, opt)
	local f = Instance.new("Frame"); f.BorderSizePixel = 0
	opt = opt or {}
	self.z += 1
	f.ZIndex = opt.z or self.z
	f.BackgroundTransparency = opt.alpha and (1 - opt.alpha) or 0
	if opt.round then local c = Instance.new("UICorner"); c.CornerRadius = UDim.new(opt.round, 0); c.Parent = f end
	if opt.stroke then
		local s = Instance.new("UIStroke"); s.Thickness = opt.stroke; s.Color = opt.strokeColor or Color3.new(0, 0, 0)
		s.ApplyStrokeMode = Enum.ApplyStrokeMode.Border; s.Parent = f
	end
	if opt.grad then
		local g = Instance.new("UIGradient"); g.Color = ColorSequence.new(opt.grad[1], opt.grad[2]); g.Rotation = opt.grad[3] or 90; g.Parent = f
	end
	f.Rotation = opt.rot or 0
	f.Parent = self.gui
	return f
end

function F:Fill(color, opt)
	local f = frame(self, opt); f.BackgroundColor3 = color; f.Size = UDim2.fromScale(1, 1); f.ZIndex = 1
	if not (opt and opt.bevel == false) then -- soft darker rim on every block face, like the bevelled Roblox block parts in the references
		local edge = color:Lerp(Color3.new(0, 0, 0), 0.35)
		local t = math.max(2, 0.05 * math.min(self.w, self.h))
		for _, r in { { 0, 0, 1, 0, 0, t }, { 0, 1, 1, 0, 0, -t }, { 0, 0, 0, 1, t, 0 }, { 1, 0, 0, 1, -t, 0 } } do
			local e = Instance.new("Frame"); e.BorderSizePixel = 0; e.BackgroundColor3 = edge; e.BackgroundTransparency = 0.45; e.ZIndex = 1000
			e.AnchorPoint = Vector2.new(r[1], r[2]); e.Position = UDim2.fromScale(r[1], r[2])
			e.Size = UDim2.new(r[3], math.abs(r[5]), r[4], math.abs(r[6]))
			e.Parent = self.gui
		end
	end
	return f
end
function F:Rect(x, y, w, h, color, opt)
	return self:Box(x + w / 2, y + h / 2, w, h, color, opt)
end
function F:Box(cx, cy, w, h, color, opt)
	local f = frame(self, opt); f.BackgroundColor3 = color
	f.AnchorPoint = Vector2.new(0.5, 0.5); f.Position = UDim2.fromScale(cx, cy); f.Size = UDim2.fromScale(w, h)
	return f
end
function F:Line(x1, y1, x2, y2, thick, color, opt)
	local dx, dy = (x2 - x1) * self.w, (y2 - y1) * self.h
	local len = math.sqrt(dx * dx + dy * dy)
	local f = frame(self, opt); f.BackgroundColor3 = color
	f.AnchorPoint = Vector2.new(0.5, 0.5); f.Position = UDim2.fromScale((x1 + x2) / 2, (y1 + y2) / 2)
	f.Size = UDim2.fromOffset(len + thick * self.h, math.max(1, thick * self.h))
	f.Rotation = math.deg(math.atan2(dy, dx))
	if opt and opt.cap then local c = Instance.new("UICorner"); c.CornerRadius = UDim.new(0.5, 0); c.Parent = f end
	return f
end
function F:Poly(points, thick, color, opt)
	for i = 1, #points - 1 do
		self:Line(points[i][1], points[i][2], points[i + 1][1], points[i + 1][2], thick, color, opt)
	end
end
function F:Circle(cx, cy, r, color, opt)
	local d = r * 2 * self.h
	local f = frame(self, opt); f.BackgroundColor3 = color
	f.AnchorPoint = Vector2.new(0.5, 0.5); f.Position = UDim2.fromScale(cx, cy); f.Size = UDim2.fromOffset(d, d)
	local c = Instance.new("UICorner"); c.CornerRadius = UDim.new(0.5, 0); c.Parent = f
	return f
end
function F:Ring(cx, cy, r, thick, color, opt)
	opt = table.clone(opt or {}); opt.alpha = 0; opt.stroke = math.max(1, thick * self.h); opt.strokeColor = color
	local f = self:Circle(cx, cy, r, color, opt)
	return f
end
function F:Text(str, cx, cy, w, h, color, opt)
	opt = opt or {}
	self.z += 1
	local t = Instance.new("TextLabel"); t.BackgroundTransparency = 1; t.ZIndex = opt.z or self.z
	t.AnchorPoint = Vector2.new(0.5, 0.5); t.Position = UDim2.fromScale(cx, cy); t.Size = UDim2.fromScale(w, h)
	t.Text = str; t.TextColor3 = color; t.TextScaled = true; t.Font = opt.font or Enum.Font.GothamBlack; t.Rotation = opt.rot or 0
	t.Parent = self.gui
	return t
end

-- Paint every visible side of a part the same base color + a callback per face: Paint.All(part, color, function(face, f) ... end)
function Paint.All(part, color, fn)
	for _, face in { "Front", "Back", "Left", "Right" } do
		local f = Paint.Face(part, face)
		if color then f:Fill(color) end
		if fn then fn(face, f) end
	end
end
return Paint
