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
- Twenty-five focused game regression tests covering the above mechanics and their native integration.
- Resource filename case corrections in 22 existing Paradise files, required for the pinned upstream revision to compile on Linux.

## Still incomplete

Most of GS13 remains to be ported. Its source has 302 DM files in `modular_gs`, plus base-code modifications and inherited Bubber/Skyrat systems. Remaining areas include multistage body/clothing rendering, body size and taurs, helplessness, blueberry transformations and bursting, gases/MILLA integration, calorite construction/material transmutation and mood/quirk effects, power machinery, remaining weapons and spells, diseases and genetics, species and organs, quirks, maps, jobs, remaining research, food/drinks, and inherited systems. Digestive speech effects and most additional chemicals are still pending. Paradise's autolathe still accepts its original materials; calorite sheets are recovered through the smelter/ORM. Additional uplink consumables, cyborg upgrades, and weapon families remain pending.

Rendering currently uses Paradise's appearance system, and mass measurements assume GS13's default body size. Chemistry uses Paradise's discrete reactions and temperature limits; TG pH/purity simulation is not implemented. Starting-weight edits apply on the next spawn. During-round preference edits affect a body only when editing its original character slot; snapshots stay with disconnected bodies.

Source arithmetic fixes: changes report the actual bounded amount applied, muscle gain uses its configured multiplier, repeated withdrawal cannot stack the galbanic modifier without limit, and excess food cannot create an automatic negative fullness adjustment. Metabolism rays respect weapon preferences and complete armor immunity. Projectile weight effects use Paradise's armor equation. Gun power costs are scaled to Paradise's 1,000-unit standard cell, preserving the source's ratios to its 10,000-unit cell.

## Testing this checkpoint

Use BYOND **516.1666**, Paradise's pinned stable version. Compile `paradise.dme` in Dream Maker and host it with Dream Daemon. Follow Paradise's existing setup instructions for the server and TGUI assets.

For an existing schema-73 database, apply `SQL/updates/73-74.sql` and update the configured SQL version to 74. A new database uses `SQL/paradise_schema.sql`. Without a database, preference edits are session-only.

Open **Character Setup → GS13: Weight preferences**, enable weight gain and the sources to test, save, and spawn. The autolathe's Medical category contains the weight analyzer; cargo offers the Body Composition Equipment Crate. Admin-spawnable items include `/obj/item/portable_weight_scanner`, `/obj/structure/scale`, `/obj/item/bluespace_belt`, and `/obj/item/reagent_containers/glass/bottle/lipoifier`.

Mine calorite and process it in the ORM, then load the sheets into the protolathe. Basic Fatoray research requires Combat 4, Materials 4, and Biotech 4; the cannon requires Combat 5. AL-T-Ray models require Combat 4, Materials 5, and Biotech 5. For direct testing, spawn `/obj/item/gun/energy/fatoray`, `/obj/item/gun/energy/gun/fattening`, or `/obj/item/gun/energy/laser/alter_ray/gainrate`. Grind calorite sheets for lipoifier and micro calorite. Enable **Allow severe weight effects** to test exposure accumulation and its persistent effects. Security cargo has three-gun Salamander and Matador crates. The uplink has an **Adipo-Warfare** category. Research unlocks the Basic Fatoray cyborg upgrade in the exosuit fabricator; install it after the cyborg selects a module. For melee testing, spawn `/obj/item/melee/chainofcommand/fattening` or `/obj/item/gavelhammer/fattening`; their `/permanent` subtypes use galbanic damage. Native weight batons are `/obj/item/melee/baton/loaded/fattening` (and `/stunsword`) and `/obj/item/melee/classic_baton/fattening`.

The focused test build uses `GAME_TESTS`, `GS13_TESTS`, `CIBUILDING`, and `TEST_CONFIG_OVERRIDE="gs13_tests"`. Set `data/next_map.txt` to `/datum/map/test_tiny`, ensure `tmp/` exists, and run `tools/ci/run_server.sh`. The GS13 Actions workflow performs these steps when Actions is enabled for the fork. This focused suite disables SQL; it does not validate the database migration against a running database.

## Validation record

Commit `41b646941eeb177e7d37977314a1a45903e9e95e` compiled with BYOND 516.1666 with zero errors and zero warnings and passed all twenty-two core, weapon, and calorite game tests without runtime failures in [GitHub Actions](https://github.com/bobatochaps/Paradisefunnything/actions/runs/38247116000). The expanded twenty-five-test equipment suite is being validated separately.

DreamChecker 1.11.0 reports zero diagnostics on the expanded game code. The duplicate-definition and define-sanity checks have passed. The BYOND installer uses the community mirror when the official download host fails. No manual client gameplay test or live SQL migration test has been performed yet.

Source and asset attribution is in `modular_gs/ATTRIBUTION.md`.
