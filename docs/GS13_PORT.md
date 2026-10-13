# GS13 to Paradise port

**Work in progress. This is not a complete GS13 port.**

Source: `sheepishgoat/GS13-Blubberstation@ec3ad13bd34b64451813004e32892d49de745404`.
Base: `ParadiseSS13/Paradise@7084a06407db70b41389045dd38f54ae3eb2d1f1`.

## Implemented foundation

- Per-character preferences: master switch, source switches, starting weight, gain/loss multipliers, cap, permanent gain, and muscle gain. Gain is disabled by default, as in GS13.
- Native Paradise character SQL save/load integration and character-setup editor.
- Regular/permanent/apparent weight, rate modifiers, muscle, exercise, excess-nutrition conversion, movement penalty, and GS13 HUD alerts.
- Weight analyzer, floor scale, bluespace concealment belt, autolathe analyzer design, and cargo weighing-equipment crate.
- Initial chemistry: lipoifier, weak lipoifier, galbanic compound, macerinic solution, lipolicide integration, and caramel as a recipe ingredient. Overdoses preserve their normal GS13 effects.
- Strong/weak legs and lipolicide/macerinic tolerance quirks through Paradise character setup. Quirk costs use Paradise's smaller point scale.
- Fullness from nutrition and undigested food, temporary bloating/hunger recovery, larger feeding limits, fullness HUD and examine descriptions, and burp relief with a cooldown.
- Fizulphite/extilphite chemistry and galbanic addiction adapted to Paradise metabolism and withdrawal stages.
- Weight Gain disease symptom, available through native virology, with GS13 source preferences and lipolicide treatment.
- Fatoray variants, Salamander and Matador energy guns, and AL-T-Ray metabolism/reversal modes using Paradise's firing, armor, and cell systems. Original gun/projectile/in-hand sprites are included.
- Calorite ore generation, mining scan sprites, sheets, smelting/ORM points, R&D and recycler storage, and Basic Fatoray/cannon and AL-T-Ray research designs. Mining rarity follows gold in Paradise's ore tables; research uses native technology levels in place of TG techweb nodes.
- Calorite contact component, micro-calorite chemistry, severe exposure effects, and permanent Fatoray conversion. Exposure requires the new severe-effects preference; chemical and permanent-weight preferences remain independent. GS13's ordinary/permanent weight damage types are integrated with native armor and fall back to stamina when weight weapons are disabled.
- Calorite/galbanic whips and hammers, fattening batons and stunsword, native cargo and uplink distribution for ported weapons, and a researchable Fatoray cyborg upgrade. Stunsword stunning uses Paradise baton mechanics; its weight damage, size, sprites, and upgraded cell follow GS13. Cargo prices preserve ratios to native energy gun prices.
- Calorite walls/falsewalls, four floor variants, doors, and statues with source sprites. Native sheet recipes, girder construction, tile installation/recovery, material recovery, and air sealing are wired in. Door trapping uses an independent native timed status effect that respects item preferences.
- Lipoifier, galbanic, and mixed chemical smoke grenades; six prepared reagent beakers; ordinary/syndicate calorite pens; and the feeder mini energy crossbow. The Adipo-Warfare uplink now contains eighteen ported entries, including the pendant and hacked cyborg tube. The crossbow retains Paradise incapacitation, scales its payload with native armor, and respects weapon and chemical preferences independently.
- Memento Calori pendant with source ground/worn sprites, a neck-slot action, one binding per body, concealment of both weight channels, and the source removal penalties. Native movement/deletion cleanup prevents stale concealment and duplicate penalties.
- Cyborg feeding-tube base, expansion, and hacked modules with native installation, reagent selection, injection protection, and powered synthesis. Each reagent reservoir holds 25 units and refills five units every twelve seconds at 75 cell charge per depleted reservoir. Base/expanded designs are available in the exosuit fabricator; the hacked module is in the uplink. Alien honey and strawberry milk (including its mixing recipe) support the expanded palette.
- Forty focused game regression tests covering the above mechanics and their native integration.
- Resource filename case corrections in 22 existing Paradise files, required for the pinned upstream revision to compile on Linux.

## Still incomplete

Most of GS13 remains to be ported. Its source has 302 DM files in `modular_gs`, plus base-code modifications and inherited Bubber/Skyrat systems. Remaining areas include multistage body/clothing rendering, body size and taurs, remaining helplessness mechanics, blueberry transformations and bursting, gases/MILLA integration, calorite material transmutation and mood/quirk effects, power machinery, remaining weapons and spells, diseases and genetics, species and organs, quirks, maps, jobs, remaining research, food/drinks, and inherited systems. Digestive speech effects and most additional chemicals are still pending. Paradise's autolathe still accepts its original materials; calorite sheets are recovered through the smelter/ORM. The feeding-tube expansion and hacked palette currently omit blueberry juice and Starshine Neutron, whose transformation systems are still pending. Additional weapon families and cyborg tools also remain pending.

Rendering currently uses Paradise's appearance system, and mass measurements assume GS13's default body size. Chemistry uses Paradise's discrete reactions and temperature limits; TG pH/purity simulation is not implemented. Starting-weight edits apply on the next spawn. During-round preference edits affect a body only when editing its original character slot; snapshots stay with disconnected bodies.

Source arithmetic fixes: changes report the actual bounded amount applied, muscle gain uses its configured multiplier, repeated withdrawal cannot stack the galbanic modifier without limit, and excess food cannot create an automatic negative fullness adjustment. Metabolism rays respect weapon preferences and complete armor immunity. Projectile weight effects use Paradise's armor equation. Door trapping listens on the turf instead of the door contents, only affects the entering mob, and retains its delay across intermediate body stages. The weight stun has an explicit tick interval and cannot overwrite a normal stun. Gun power costs are scaled to Paradise's 1,000-unit standard cell, preserving the source's ratios to its 10,000-unit cell.

## Testing this checkpoint

Use BYOND **516.1666**, Paradise's pinned stable version. Compile `paradise.dme` in Dream Maker and host it with Dream Daemon. Follow Paradise's existing setup instructions for the server and TGUI assets.

For an existing schema-73 database, apply `SQL/updates/73-74.sql` and update the configured SQL version to 74. A new database uses `SQL/paradise_schema.sql`. Without a database, preference edits are session-only.

Open **Character Setup → GS13: Weight preferences**, enable weight gain and the sources to test, save, and spawn. The autolathe's Medical category contains the weight analyzer; cargo offers the Body Composition Equipment Crate. Admin-spawnable items include `/obj/item/portable_weight_scanner`, `/obj/structure/scale`, `/obj/item/bluespace_belt`, and `/obj/item/reagent_containers/glass/bottle/lipoifier`.

Mine calorite and process it in the ORM, then load the sheets into the protolathe. Basic Fatoray research requires Combat 4, Materials 4, and Biotech 4; the cannon requires Combat 5. AL-T-Ray models require Combat 4, Materials 5, and Biotech 5. For direct testing, spawn `/obj/item/gun/energy/fatoray`, `/obj/item/gun/energy/gun/fattening`, or `/obj/item/gun/energy/laser/alter_ray/gainrate`. Grind calorite sheets for lipoifier and micro calorite. Enable **Allow severe weight effects** to test exposure accumulation and its persistent effects. Security cargo has three-gun Salamander and Matador crates. The uplink has an **Adipo-Warfare** category. Research unlocks the Basic Fatoray cyborg upgrade in the exosuit fabricator; install it after the cyborg selects a module. For melee testing, spawn `/obj/item/melee/chainofcommand/fattening` or `/obj/item/gavelhammer/fattening`; their `/permanent` subtypes use galbanic damage. Use calorite sheets in hand to craft floor tiles, a statue, or a door; apply sheets to normal/displaced girders for walls/falsewalls. The stronger, disguised, and dance floor variants are available for mapping/admin testing, matching the source's recipe availability. Native weight batons are `/obj/item/melee/baton/loaded/fattening` (and `/stunsword`) and `/obj/item/melee/classic_baton/fattening`.

For the new consumables, use the Adipo-Warfare uplink or spawn `/obj/item/grenade/chem_grenade/lipoifier`, `/obj/item/grenade/chem_grenade/galbanic`, `/obj/item/grenade/chem_grenade/fatmix`, `/obj/item/pen/calorite/syndicate`, and `/obj/item/gun/energy/kinetic_accelerator/crossbow/feeder`. Native gas masks block these smoke payloads. Pens require item effects; the crossbow requires weapon effects for injection and chemical effects for the resulting weight gain.

The Memento Calori pendant is available from the uplink or as `/obj/item/clothing/neck/necklace/memento_mori/calori`. Equip it in the neck slot and use its action to bind for four seconds. Removing it reveals concealed weight and adds 600 ordinary and 600 permanent weight, subject to the magic/permanent switches and configured cap. The same body cannot bind to that pendant again.

Cyborg feeding-tube research requires Biotech 2 and Programming 2; the expansion requires Biotech 4, Programming 3, and Materials 3. Install a base module before adding its expansion. Like the GS13 source, these tubes use hypospray injection mechanics; they are separate from the unported freestanding feeding machine. The base palette has cream, milk, and nutriment; expansion adds alien honey, strawberry milk, chocolate milk, and weak lipoifier. The hacked module also provides lipoifier, galbanic compound, and micro calorite. Native injection protection and chemical/permanent preferences still apply.

The focused test build uses `GAME_TESTS`, `GS13_TESTS`, `CIBUILDING`, and `TEST_CONFIG_OVERRIDE="gs13_tests"`. Set `data/next_map.txt` to `/datum/map/test_tiny`, ensure `tmp/` exists, and run `tools/ci/run_server.sh`. The GS13 Actions workflow performs these steps when Actions is enabled for the fork. This focused suite disables SQL; it does not validate the database migration against a running database.

## Validation record

Commit `f3587e311244e977eba6818fd679ab9cee0bb5fe` compiled with BYOND 516.1666 with zero errors and zero warnings and passed all forty core, calorite, equipment, construction, consumable, pendant, and cyborg-feeding game tests without runtime failures in [GitHub Actions](https://github.com/bobatochaps/Paradisefunnything/actions/runs/38338205315).

DreamChecker 1.11.0 reports zero diagnostics on the expanded game code. The duplicate-definition and define-sanity checks have passed. The BYOND installer uses the community mirror when the official download host fails. No manual client gameplay test or live SQL migration test has been performed yet.

Source and asset attribution is in `modular_gs/ATTRIBUTION.md`.

## Resume notes

The published work lives on `bobatochaps/Paradisefunnything:gs13-paradise-port`; the fork's master branch is unchanged. The source and target pins above are intentional. Resume from this branch rather than reconstructing changes from an older checkout. Port code is concentrated in `code/modules/gs13/`, with native integration changes in the corresponding Paradise systems. Regression tests are in `code/tests/test_gs13_weight.dm`; `.github/workflows/gs13-port.yml` builds and runs them on each branch push.

The next feeding-system work is the freestanding machine and portable blender (`modular_gs/code/machinery/feeding_tube.dm` and `modular_gs/code/obj/items/portable_blender.dm` in the pinned source). Blueberry juice and Starshine Neutron remain prerequisites for the final two cyborg reagent choices. The largest remaining compatibility task is multistage body and clothing rendering: the source depends on Skyrat organs and modular clothing overlays that Paradise does not provide. Those systems need a native adapter, not direct inclusion of the source files.

Keep the native tests on a `/datum/game_test/room_test` fixture. Paradise armor uses `INFINITY` for complete immunity. BYOND does not support `locate(arglist(coordinates))`; pass coordinates separately. Conditional test code is checked by the BYOND build; the ordinary DreamChecker pass does not include it. A clean compile and this focused suite do not establish full GS13 feature parity or substitute for a client gameplay test.
