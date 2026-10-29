# Marvel vs DC — HANDOFF (shared between Claude and the other AI)

Read this first. Update the "Status" and "Next up" sections before you stop.

## What it is
A Roblox game that mixes Steal a Brainrot with a Soul Calibur style 3D weapon fighter, using Marvel, DC, Cartoon Network and Nickelodeon characters.
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
- `src/client/Input.client.luau`: LMB Horizontal, RMB Vertical, R Kick, hold F guard (tap = Guard Impact), Q dash (A/D + Q = sidestep), 1-4 abilities, G Critical Edge, T lock-on toggle. Lock-on auto-faces the opponent in duels (8-way run).
- `src/client/Movement.client.luau`: parkour. Shift sprint, Space in air double jump (flip), hold Space beside a wall to wall-run (release = wall jump), C/Ctrl slide, auto-vault low obstacles (lobby only). Client-simulated; server relays `Move` so others see the anim.
- `src/client/Fx.client.luau`: routes server events (Swing, Hit, Ability, Projectile, ProjHit, Slam, GuardImpact, Evade, GuardBreak, Counter, Dashed, Move, RingOut) to Anim + VFX
- `src/shared/Anim.luau`: procedural keyframe animator on R15 Motor6D.C0 (no uploaded animation assets). Pose library `Anim.Moves` per Style (Blade, Dual, Staff, Heavy, Fists) x H/V/K, finishers, abilities (Thrust, Cast, Throw, Grab, Counter, Leap, Slam, Spin, Uppercut, Kick, Flurry), Critical Edge charge, block, hit, launch, parkour poses. R6 rigs are a no-op.
- `src/shared/VFX.luau`: smear slash arcs, crossed slash marks, black/white impact frames, shockwave rings, crater rocks, speed lines, afterimages, weapon trails, charge orb, Critical Edge banner, combo counter, damage numbers, popups
- `src/client/HUD.client.luau`: in-duel fighting-game HUD only

State lives as Character attributes: Hero, Stamina, Ult, Blocking, StunUntil, IFrameUntil, InDuel.

## Soul Calibur combat (session 5)
- M1 is now 3 buttons: H (wide, `Tracks` sidesteps), V (strong, linear, whiffs vs sidestep), K (fast). Tuning in `Config.Attacks`. Each has startup (hit lands after the windup, and getting stunned during startup cancels it) and recovery.
- 4th hit of a string = finisher: V launches (Up 62, air juggle), H spins for big knockback (ring out), K guard-breaks.
- Guard Impact: guard pressed within `Config.GuardImpact.Window` before a close hit parries it and stuns the attacker.
- Sidestep: Q while holding A/D. Verticals and projectiles whiff during `Config.Sidestep.Window`; horizontals connect.
- Critical Edge: the ultimate now has a `Config.CritEdgeCharge` invulnerable windup with banner + charge orb + impact frames.
- Ring Out: arenas lost their invisible walls (knee-high rail only). Falling `Config.RingOutDepth` below the arena ends the round.
- Hero fields: `Style` ("Blade" | "Dual" | "Staff" | "Heavy" | "Fists", default Fists), per ability `Element` (VFX color) and `Anim` (pose name in Anim.Moves).
- Weapon trails attach to the weapon part named "Blade" (else "Grip"); unarmed heroes trail from the hands/feet.

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
0. Mobile controls (ContextActionService buttons for H/V/K/guard/dash/abilities). Current input is keyboard + mouse only.
1. Test in Studio with 2 to 3 players. Check: convoy buy, the hero walking home, income, steal plus deliver, drop on slap, lock door, queue to select to duel to back to base. Nobody has run any of it yet.
2. Sell button on pedestal heroes (refund around 50% of price) so full bases can make room.
3. Slot upgrades bought with cash (10 -> 15 -> 20), with pedestals added to the plot.
4. Rebirths (reset cash for an income multiplier), the classic Brainrot progression.
5. Animations: idle on pedestal heroes, walk on convoy/walk-home, M1 and ability anims in duels.
6. Ranked ELO for fight mode, a leaderboard board in the world, a robux shop (lock-time boost, 2x cash) via MarketplaceService.
7. Custom meshes: the user REJECTED the generated-mesh attempts ("goofy"). Characters stay part-built (see "Character art (session 6)").

## Character art (session 6)
- User complaints: "blocky, all the same, ugly"; wants accurate proportions, weapons, accessories and uniforms. Chosen art style: **option 3 = 3D characters + white paper-border outline** (Paper Mario feel without flattening, so 3D moves stay readable). Flat cutouts (`src/shared/Paper.luau`, `Paper.Flatten`) exist as an unused prototype.
- `src/shared/Body.luau`: `Body.Shape` resizes R15 parts per hero (presets Hero, Lean, Brute, Titan, Female, Teen, Kid, Chibi, Sponge, Turtle, Armored; each hero picks one with `Build = { "Preset", { overrides } }` in `Heroes/<Id>.luau`), then `Body.Sculpt` covers the box parts with rounded forms in the costume colors and hides the boxes. Called from `Skins.Apply` (Shape before costume, Sculpt after).
- `src/shared/Toon.luau` + `client/Toon.client.luau`: matte SmoothPlastic, no self-shadows, white Highlight outline on the closest 24 characters (Roblox renders max 31 Highlights). Lobby avatars get the outline only. Mythic+ keep their colored RarityGlow outline.
- One file per hero/weapon so work can run in parallel: `Costumes/<Id>`, `SkinData/<Id>` (6 rarities), `WeaponModels/<WeaponId>` ("Grip" = hand, main part "Blade" with tip at +Y, cylinders are X-length).
- Many costumes hide the R15 head and build their own rounded head; never set Transparency on every part of a model blindly (BaseService stolen display only touches parts with Transparency < 1).
- Duels reset the player's avatar to a blank HumanoidDescription before applying the hero (R15 only).
- **Preview tool** `tools/preview/preview.sh` (see its README): runs the real shared code under luau with a Roblox mock and renders front/3-4/back PNGs. Use it to check every visual change. Roster renders are in `progress/`.
- Red Hood now holds twin pistols (his "All-Caste Blade" move has no blade model); ask the user whether to give him a knife.

## Publishing
Live at place 95876647985129 (universe 10772668310). Run `ROBLOX_API_KEY=<key> ./scripts/publish.sh` (needs rojo; the environment must allow apis.roblox.com). Ask the user for the key; never commit it. Last published: version 15 (comic-accuracy + detailed faces + glow fix).

## Visual rules (learned)
- Never use Neon on faces/eyes/visors; bloom threshold is 2.2 in GothamTheme so only real light sources glow. Head flames use negative ZOffset so they draw behind the skull.
- Every hero has a built face (`Face` / `LowerFace` pieces); the default Roblox face decal is always removed.

## Rules for whoever picks this up
- Keep the server authoritative for damage and cooldowns; the client only does visuals and its own dash velocity.
- Put new tuning numbers in Config. Keep the code style (tabs, short helpers).
- Before stopping near your usage limit: update Status / Next up here and commit.
