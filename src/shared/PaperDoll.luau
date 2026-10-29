-- Paper Mario style heroes: every R15 body part carries a flat paper card with a drawn illustration
-- (thick black ink lines, white paper border) on its front and back. The box body parts are hidden; the
-- skeleton still animates, and client/LiveFx turns the whole doll to face the camera so it never goes edge-on.
-- A hero opts in with a design module in src/shared/PaperDesigns/<HeroId>.luau:
--   return function(skin, rarity, kit) -> { cards = { [PartName] = { w, h, x, y, z } }, draw = function(part, face, f, kit) }
-- `kit` has helpers that draw outlined paper shapes with Paint (see below).
local Paint = require(script.Parent.Paint)
local PaperDoll = {}

local PARTS = { "Head", "UpperTorso", "LowerTorso", "LeftUpperArm", "LeftLowerArm", "LeftHand", "RightUpperArm", "RightLowerArm", "RightHand",
	"LeftUpperLeg", "LeftLowerLeg", "LeftFoot", "RightUpperLeg", "RightLowerLeg", "RightFoot" }
-- default draw order front-to-back (negative z = toward the front of the character)
local LAYER = { Head = -0.07, UpperTorso = 0, LowerTorso = -0.012, LeftUpperArm = -0.04, RightUpperArm = -0.04, LeftLowerArm = -0.045, RightLowerArm = -0.045,
	LeftHand = -0.05, RightHand = -0.05, LeftUpperLeg = 0.02, RightUpperLeg = 0.02, LeftLowerLeg = 0.015, RightLowerLeg = 0.015, LeftFoot = 0.01, RightFoot = 0.01 }

local INK, PAPER = Color3.fromRGB(20, 20, 24), Color3.fromRGB(252, 252, 248)

-- Drawing kit for designs. All sizes are fractions of the card face (x right, y down).
local Kit = {}
Kit.INK, Kit.PAPER = INK, PAPER
Kit.BORDER = 0.06 -- white paper margin around a cutout shape
-- Outlined cutout: white paper border, then the colored shape with an ink outline
function Kit.cut(f, cx, cy, w, h, color, opt)
	opt = opt or {}
	local b = opt.border or Kit.BORDER
	local round = opt.round or 0.25
	f:Box(cx, cy, w + b, h + b * (f.w / f.h), PAPER, { round = round, rot = opt.rot, stroke = 1.5, strokeColor = Color3.fromRGB(190, 190, 185), z = opt.z })
	return f:Box(cx, cy, w, h, color, { round = round, rot = opt.rot, stroke = opt.ink or 4, strokeColor = INK, z = opt.z and opt.z + 1 })
end
-- Plain shape with an ink outline, no paper border (details inside a cutout)
function Kit.shape(f, cx, cy, w, h, color, opt)
	opt = opt or {}
	return f:Box(cx, cy, w, h, color, { round = opt.round, rot = opt.rot, stroke = opt.ink or 3, strokeColor = INK, z = opt.z })
end
function Kit.circle(f, cx, cy, r, color, opt)
	opt = opt or {}
	return f:Circle(cx, cy, r, color, { stroke = opt.ink or 3, strokeColor = INK, z = opt.z })
end
function Kit.line(f, x1, y1, x2, y2, thick, opt)
	return f:Line(x1, y1, x2, y2, thick or 0.012, (opt and opt.color) or INK, { cap = true, z = opt and opt.z })
end
-- Spider-web: spokes from (cx, cy) out to radius r (fraction of face height) + rings
function Kit.web(f, cx, cy, r, spokes, rings, thick, aspect)
	aspect = aspect or (f.h / f.w)
	for i = 0, spokes - 1 do
		local a = i / spokes * math.pi * 2
		Kit.line(f, cx, cy, cx + math.cos(a) * r * aspect, cy + math.sin(a) * r, thick)
	end
	for k = 1, rings do
		local rr = r * k / (rings + 0.4)
		local pts = {}
		for i = 0, spokes do
			local a = i / spokes * math.pi * 2
			local sag = (i % 1 == 0) and 1 or 0.9
			table.insert(pts, { cx + math.cos(a) * rr * aspect * sag, cy + math.sin(a) * rr * sag })
			local am = (i + 0.5) / spokes * math.pi * 2
			if i < spokes then table.insert(pts, { cx + math.cos(am) * rr * aspect * 0.88, cy + math.sin(am) * rr * 0.88 }) end
		end
		f:Poly(pts, thick or 0.01, INK)
	end
end

function PaperDoll.Has(designs, heroId) return designs and designs:FindFirstChild(heroId) ~= nil end

function PaperDoll.Build(model, design, skin, rarity)
	local d = design(skin, rarity, Kit)
	for _, n in PARTS do
		local p = model:FindFirstChild(n)
		if p then
			p.Transparency = 1
			local face = p:FindFirstChild("face"); if face then face:Destroy() end
			local spec = d.cards[n] or {}
			local w, h = spec.w or p.Size.X * 1.15, spec.h or p.Size.Y * 1.3 -- cards overlap at the joints so the doll reads as one piece
			local card = Instance.new("Part"); card.Name = "Paper_" .. n
			card.Size = Vector3.new(w, h, 0.04); card.Transparency = 1
			card.CanCollide = false; card.CanQuery = false; card.CanTouch = false; card.Massless = true; card.CastShadow = false
			card.Anchored = p.Anchored
			card.CFrame = p.CFrame * CFrame.new(spec.x or 0, spec.y or 0, spec.z or LAYER[n] or 0)
			local wc = Instance.new("WeldConstraint"); wc.Part0 = p; wc.Part1 = card; wc.Parent = card
			card.Parent = model
			for _, faceName in { "Front", "Back" } do
				d.draw(n, faceName, Paint.Face(card, faceName), Kit)
			end
		end
	end
	model:SetAttribute("Paper", true)
end
PaperDoll.Kit = Kit
return PaperDoll
