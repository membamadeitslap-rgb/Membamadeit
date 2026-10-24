# Marvel vs DC — HANDOFF (shared between Claude and the other AI)

Read this first. Update the "Status" and "Next up" sections before you stop.

## What it is
A Roblox 1v1 arena fighter modeled on Dueling Grounds (reference footage from the user).
- **UI reference:** diamond avatar portraits at the top left and right with slanted red HP bars and a white damage trail, "ROUND" plus a timer in the center, diamond win pips under each bar, an ult meter at the bottom center, and a red screen tint on ultimates.
- **Arena reference:** a circular arena with a red wooden railing and a blue swirl floor (Japanese temple vibe).

## Project layout (Rojo: `rojo serve`, or `rojo build -o MvD.rbxlx`)
- `src/shared/Config.luau`: all combat tuning numbers
- `src/shared/Net.luau`: RemoteEvents (Action c->s, Fx s->c, Match s->c)
- `src/shared/Heroes/*.luau`: hero data (abilities 1-4 + Ultimate). Kinds: Melee, Projectile, Leap, Grab, Counter
- `src/server/CombatService.luau`: server-authoritative hits, block/guard break, knockback (LinearVelocity), ragdoll (PlatformStand), stun, i-frames, ult meter
- `src/server/DuelService.luau`: two lobby pads -> best-of-3 -> back to lobby
- `src/server/ArenaBuilder.luau`: placeholder lobby and arena built in code
- `src/server/Main.server.luau`: bootstrap, hero pick remote, leaderstats
- `src/client/Input.client.luau`: LMB M1, hold F block, Q dash, 1-4 abilities, G ult
- `src/client/Fx.client.luau`: sparks, camera shake, ult red flash, projectile visuals
- `src/client/HUD.client.luau`: full fighting-game HUD plus hero select buttons

State lives as Character attributes: Hero, Stamina, Ult, Blocking, StunUntil, IFrameUntil, InDuel.

## Status
- DONE (untested in Studio, written blind): structure, combat core, duel loop, HUD, FX.
- DONE: signature weapons in `src/shared/Weapons.luau`, built from parts and welded to RightHand/LeftHand (R15) or Arms (R6) via `Hero.Weapons = { Right=, Left= }`.
  Thrown weapons (`Visual = "<WeaponId>", Returns = true` on a Projectile ability) fly as the real model, spin, return to the thrower, and the held copy is hidden meanwhile.
- Roster (11):
  - Marvel heroes: Spider-Man (web shooters), Iron Man (repulsors), Thor (Mjolnir + Stormbreaker), Captain America (vibranium shield)
  - Marvel villains: Loki (scepter with Mind Stone), Thanos (Infinity Gauntlet, 6 stones)
  - DC heroes: Batman (batarangs), Wonder Woman (God Killer sword, Amazon shield, Lasso of Truth as a Grab)
  - DC villains: Harley Quinn (mallet), Joker (crowbar), Deathstroke (katana + bo staff)

## Next up (in order)
1. Test in Studio and fix runtime errors.
2. Stunned or blocking players should have their WalkSpeed reduced (stun currently only blocks actions).
3. Animations: add AnimationIds per M1 combo step and per ability (Fx "Swing" / "Ability" events already fire).
4. Remaining roster: Hulk, Superman, Flash (no weapons, power-based), plus more villains (Venom, Green Goblin with glider and pumpkin bombs, Black Adam, Darkseid). Copy the Heroes/*.luau format.
4b. Tune weapon grip offsets/rotation in Weapons.Attach once seen in Studio (written blind; shields/gauntlet may need a different rotation than swords). Consider swapping in MeshParts later.
5. Real arena builds (Stark Tower, Gotham, Wakanda, Metropolis, Asgard) plus random arena pick.
6. DataStore (coins, wins, unlocks), shop, ranked ELO, spectate, 2v2/FFA pads.

## Rules for whoever picks this up
- Keep the server authoritative for damage and cooldowns; the client only does visuals and its own dash velocity.
- Put new tuning numbers in Config. Keep the code style (tabs, short helpers).
- Before stopping near your usage limit: update Status / Next up here and commit.
