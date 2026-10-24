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

- DONE (session 3):
  - Movement penalties in the CombatService loop: Frozen (countdown) 0, stunned 3, blocking 7. Per-hero `WalkSpeed` (Flash 22, Hulk/Darkseid 14).
  - +7 characters: Hulk, Superman, Flash (heroes); Venom, Green Goblin with pumpkin bomb weapon (Marvel villains); Black Adam, Darkseid (DC villains). Roster is now 18.
  - 5 themed arenas in ArenaBuilder (`A.Themes`): Stark Tower, Gotham, Wakanda, Metropolis, Asgard. Random one per match; the name splashes on round 1.
  - DataService: Wins, Losses and Coins saved to DataStore "MvD_v1" (+25 coins per win, +5 per loss). Enable Studio API access to test saving.
- Syntax check: download the luau binary from github.com/luau-lang/luau releases and run `luau-compile --text file.luau` on every file (all pass).

## Next up (in order)
1. Test in Studio (Test > Clients and Servers, 2 players) and fix runtime errors. Nobody has run it yet.
2. Animations: AnimationIds per M1 combo step and per ability, played on the "Swing" / "Ability" Fx events.
3. Tune weapon grip offsets/rotation in Weapons.Attach once seen in Studio. Consider MeshParts.
4. Shop: spend Coins to unlock heroes (add `Price` to hero data, gate the pick remote server-side, grey out locked buttons).
5. Ranked ELO, spectate camera for lobby players, 2v2/FFA pads, emotes, daily reward.
6. Per-hero ability VFX (lightning for Thor/Black Adam, heat vision beam, symbiote tendrils).

## Rules for whoever picks this up
- Keep the server authoritative for damage and cooldowns; the client only does visuals and its own dash velocity.
- Put new tuning numbers in Config. Keep the code style (tabs, short helpers).
- Before stopping near your usage limit: update Status / Next up here and commit.
