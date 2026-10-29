-- Hero registry. Each hero: Name, Faction, Color, Abilities[1..4], Ultimate.
-- Ability: { Name, Cooldown, Damage, Range(Vector3), Offset(studs forward), Knockback, Stun, Kind }
-- Kind: "Melee" (box in front) | "Projectile" | "Leap" | "Grab" | "Counter" | "Beam" (hit-scan; Distance, Width, Duration)
-- From = "Eyes" | "Mouth" | "Chest" | "RightHand" | "LeftHand": where projectiles and beams leave the body (VFX + hit origin)
local Heroes = {}
for _, m in script:GetChildren() do Heroes[m.Name] = require(m) end
return Heroes
