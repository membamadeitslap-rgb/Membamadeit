# Marvel vs DC — HANDOFF (shared between Claude and the other AI)

Read this first. Update the "Status" and "Next up" sections before you stop.

## What it is
A Roblox game that mixes Steal a Brainrot with Dueling Grounds, using Marvel and DC characters.
- **Base world:** a convoy of trucks drives down a road. Each truck carries a random hero variant whose rarity is rolled by weight. Buy it with cash and it walks to your base and stands on a pedestal (10 slots). Heroes earn $/s by rarity.
- **Stealing:** hold E on another player's pedestal hero (when their base isn't locked). It floats over your head, you're slowed, and you must run into your own base to keep it. Getting slapped (M1 in the lobby does knockback only) makes you drop it. Owners step on the lock pad for a 60s laser door (15s cooldown).
- **Fight mode:** the FIGHT button queues you. Two players get paired and see a Mortal Kombat vs DC style select screen (big P1/P2 portraits, VS, roster grid of your own base heroes, lock-in reveal), then a best-of-3 duel in a random themed arena.
- **Rarity** (Common, Rare, Epic, Legendary, Mythic, Secret) is cosmetic in combat: a different skin per hero (e.g. Spider-Man: Classic, Miles, Iron Spider, Symbiote, 2099, Cosmic). Legendary and above get a particle aura, Mythic and above an outline glow, and Secret a rainbow outline and tag. Rarity changes price and income only.
- **Duel UI reference** (from the user's Dueling Grounds footage): diamond avatar portraits top left/right, slanted red HP bars with a white damage trail, ROUND and timer at center, win pips, ult meter at the bottom, red tint on ultimates.

## Project layout (Rojo: `rojo serve`, or `rojo build -o MvD.rbxlx`)
- `src/shared/Config.luau`: all combat tuning numbers
- `src/shared/Net.luau`: RemoteEvents (Action c->s, Fx s->c, Match s->c)
- `src/shared/Heroes/*.luau`: hero data (abilities 1-4 + Ultimate). Kinds: Melee, Projectile, Leap, Grab, Counter
- `src/server/CombatService.luau`: server-authoritative hits, block/guard break, knockback (LinearVelocity), ragdoll (PlatformStand), stun, i-frames, ult meter
- `src/server/DuelService.luau`: `Duel.Run(a, b, picks)` best-of-3 -> back to base. Fires OnMatchEnd(winner, loser)
- `src/server/MatchmakingService.luau`: queue remote `MvD_Queue` (Join/Leave/Pick), one select session at a time
- `src/server/ConvoyService.luau`: trucks, buy prompt, hero walks to the base
- `src/server/BaseService.luau`: plot assignment, pedestal render, income tick, lock door, steal/carry/deliver/drop
- `src/server/HeroModel.luau`: R15 display rig with skin, weapons and overhead tag
- `src/server/DataService.luau`: DataStore "MvD_v2" {Cash, Wins, Losses, Owned={{H,R}}}
- `src/shared/Rarity.luau`: tiers (weight, price, income, color), Roll, Format
- `src/shared/Skins.luau`: 18 heroes x 6 rarity variants (name + colors), `Skins.Apply(model, hero, rarity)`
- `src/shared/Costume.luau`: costume pieces (Cape, Cowl, Helmet, Eyes, Visor, Hair, Emblem, Reactor, NovaOrbs, Belt, Harness, Shoulders, Spikes, Cuffs) plus a per-hero default look. Variants in Skins can pass `Colors` / `Extra` / `Pieces`.
  Policy: do NOT download or upload official Marvel/DC art (copyright, and Roblox moderation would take the game down). Recreate details from the user's references with parts.
- `src/shared/HellCycle.luau`: Ghost Rider bike (skins with `HellCycle = true` park it beside display models; ridden during "Hellcycle Charge"). Tag `HellfireFlicker` animates glow client-side.
- `src/shared/Mannequin.luau`: blocky figure for ViewportFrame portraits
- `src/client/BaseHUD.client.luau`: cash, $/s, slots, FIGHT button, alerts, carry banner, Secret rainbow
- `src/client/SelectScreen.client.luau`: MK vs DC style fighter select
- `src/server/GothamTheme.luau`: Halloween 90s-animated-Batman art deco night: lighting, deco skyline, convoy gateway, searchlights, Bat-Signal, bats, pumpkins, fog
- `src/server/ArenaBuilder.luau`: base world (road, 8 plots) and 5 floating duel arenas
- `src/server/Main.server.luau`: bootstrap (Base.Start must run before Data.Start)
- `src/client/Input.client.luau`: LMB M1, hold F block, Q dash, 1-4 abilities, G ult
- `src/client/Fx.client.luau`: sparks, camera shake, ult red flash, projectile visuals
- `src/client/HUD.client.luau`: in-duel fighting-game HUD only

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
  - +7 characters: Hulk, Superman, Flash (heroes); Venom, Green Goblin with pumpkin bomb weapon (Marvel villains); Black Adam, Darkseid (DC villains). Roster is now 22 (+ Nova, Cyclops, Red Hood, Ghost Rider).
  - 5 themed arenas in ArenaBuilder (`A.Themes`): Stark Tower, Gotham, Wakanda, Metropolis, Asgard. Random one per match; the name splashes on round 1.
  - DataService: Wins, Losses and Coins saved to DataStore "MvD_v1" (+25 coins per win, +5 per loss). Enable Studio API access to test saving.
- Syntax check: download the luau binary from github.com/luau-lang/luau releases and run `luau-compile --text file.luau` on every file (all pass).

- DONE (session 4): pivot to the Steal a Brainrot loop (convoy, bases, income, stealing, lock), rarity skins, matchmaking, MK-style select. All files compile with luau-compile.

## Next up (in order)
1. Test in Studio with 2 to 3 players. Check: convoy buy, the hero walking home, income, steal plus deliver, drop on slap, lock door, queue to select to duel to back to base. Nobody has run any of it yet.
2. Sell button on pedestal heroes (refund around 50% of price) so full bases can make room.
3. Slot upgrades bought with cash (10 -> 15 -> 20), with pedestals added to the plot.
4. Rebirths (reset cash for an income multiplier), the classic Brainrot progression.
5. Animations: idle on pedestal heroes, walk on convoy/walk-home, M1 and ability anims in duels.
6. Ranked ELO for fight mode, a leaderboard board in the world, a robux shop (lock-time boost, 2x cash) via MarketplaceService.
7. Custom meshes: the user REJECTED the generated-mesh attempts ("goofy"). Do not build meshes; stick to the part-built Roblox style (see the user's Ghost Rider reference: blocky body, detailed accessories).

## Publishing
Live at place 95876647985129 (universe 10772668310). Run `ROBLOX_API_KEY=<key> ./scripts/publish.sh` (needs rojo; the environment must allow apis.roblox.com). Ask the user for the key; never commit it. Last published: version 15 (comic-accuracy + detailed faces + glow fix).

## Visual rules (learned)
- Never use Neon on faces/eyes/visors; bloom threshold is 2.2 in GothamTheme so only real light sources glow. Head flames use negative ZOffset so they draw behind the skull.
- Every hero has a built face (`Face` / `LowerFace` pieces); the default Roblox face decal is always removed.

## Rules for whoever picks this up
- Keep the server authoritative for damage and cooldowns; the client only does visuals and its own dash velocity.
- Put new tuning numbers in Config. Keep the code style (tabs, short helpers).
- Before stopping near your usage limit: update Status / Next up here and commit.
