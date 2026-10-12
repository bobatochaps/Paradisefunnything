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
- Fatoray variants, Salamander and Matador energy guns, and AL-T-Ray metabolism/reversal modes using Paradise's firing, armor, and cell systems. Original gun/projectile/in-hand sprites are included. These are currently admin-spawnable; research and cargo distribution depend on the remaining calorite work.
- Seventeen focused game regression tests for preferences, limits, rate arithmetic, serialization, nutrition, movement, concealment, reagents, virology, projectile impacts, and energy weapons.
- Resource filename case corrections in 22 existing Paradise files, required for the pinned upstream revision to compile on Linux.

## Still incomplete

Most of GS13 remains to be ported. Its source has 302 DM files in `modular_gs`, plus base-code modifications and inherited Bubber/Skyrat systems. Remaining areas include multistage body/clothing rendering, body size and taurs, helplessness, blueberry transformations and bursting, gases/MILLA integration, calorite, power machinery, weapons and spells, diseases and genetics, species and organs, quirks, maps, jobs, research, food/drinks, and inherited systems. Digestive speech effects and most additional chemicals are still pending.

Rendering currently uses Paradise's appearance system, and mass measurements assume GS13's default body size. Chemistry uses Paradise's discrete reactions and temperature limits; TG pH/purity simulation is not implemented. Starting-weight edits apply on the next spawn. During-round preference edits affect a body only when editing its original character slot; snapshots stay with disconnected bodies.

Source arithmetic fixes: changes report the actual bounded amount applied, muscle gain uses its configured multiplier, repeated withdrawal cannot stack the galbanic modifier without limit, and excess food cannot create an automatic negative fullness adjustment. Metabolism rays respect weapon preferences and complete armor immunity. Projectile weight effects use Paradise's armor equation. Gun power costs are scaled to Paradise's 1,000-unit standard cell, preserving the source's ratios to its 10,000-unit cell.

## Testing this checkpoint

Use BYOND **516.1666**, Paradise's pinned stable version. Compile `paradise.dme` in Dream Maker and host it with Dream Daemon. Follow Paradise's existing setup instructions for the server and TGUI assets.

For an existing schema-73 database, apply `SQL/updates/73-74.sql` and update the configured SQL version to 74. A new database uses `SQL/paradise_schema.sql`. Without a database, preference edits are session-only.

Open **Character Setup → GS13: Weight preferences**, enable weight gain and the sources to test, save, and spawn. The autolathe's Medical category contains the weight analyzer; cargo offers the Body Composition Equipment Crate. Admin-spawnable items include `/obj/item/portable_weight_scanner`, `/obj/structure/scale`, `/obj/item/bluespace_belt`, and `/obj/item/reagent_containers/glass/bottle/lipoifier`.

The focused test build uses `GAME_TESTS`, `GS13_TESTS`, `CIBUILDING`, and `TEST_CONFIG_OVERRIDE="gs13_tests"`. Set `data/next_map.txt` to `/datum/map/test_tiny`, ensure `tmp/` exists, and run `tools/ci/run_server.sh`. The GS13 Actions workflow performs these steps when Actions is enabled for the fork. This focused suite disables SQL; it does not validate the database migration against a running database.

## Validation record

Commit `effef62a83b6cfff886634211aee4ed2ca290be2` compiled with BYOND 516.1666 with zero errors and zero warnings and passed all fourteen core, fullness, chemistry, and virology game tests without runtime failures in [GitHub Actions](https://github.com/bobatochaps/Paradisefunnything/actions/runs/38204514551). The expanded seventeen-test weapon suite is being validated separately.

DreamChecker 1.11.0 reports zero diagnostics on the expanded game code. The duplicate-definition and define-sanity checks have passed. The BYOND installer uses the community mirror when the official download host fails. No manual client gameplay test or live SQL migration test has been performed yet.

Source and asset attribution is in `modular_gs/ATTRIBUTION.md`.
