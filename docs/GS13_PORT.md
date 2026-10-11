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
- Nine focused game regression tests for preferences, limits, rate arithmetic, serialization, nutrition, movement, concealment, and reagent behavior.
- Resource filename case corrections in 22 existing Paradise files, required for the pinned upstream revision to compile on Linux.

## Still incomplete

Most of GS13 remains to be ported. Its source has 302 DM files in `modular_gs`, plus base-code modifications and inherited Bubber/Skyrat systems. Remaining areas include multistage body/clothing rendering, body size and taurs, fullness and helplessness, blueberry transformations and bursting, gases/MILLA integration, calorite, power machinery, weapons and spells, diseases and genetics, species and organs, quirks, maps, jobs, research, food/drinks, and inherited systems. Galbanic addiction is also pending.

Rendering currently uses Paradise's appearance system, and mass measurements assume GS13's default body size. Chemistry uses Paradise's discrete reactions and temperature limits; TG pH/purity simulation is not implemented. Starting-weight edits apply on the next spawn. During-round preference edits affect a body only when editing its original character slot; snapshots stay with disconnected bodies.

Two source arithmetic bugs were corrected: changes now report the actual bounded amount applied, and muscle gain uses its configured multiplier.

## Testing this checkpoint

Use BYOND **516.1666**, Paradise's pinned stable version. Compile `paradise.dme` in Dream Maker and host it with Dream Daemon. Follow Paradise's existing setup instructions for the server and TGUI assets.

For an existing schema-73 database, apply `SQL/updates/73-74.sql` and update the configured SQL version to 74. A new database uses `SQL/paradise_schema.sql`. Without a database, preference edits are session-only.

Open **Character Setup → GS13: Weight preferences**, enable weight gain and the sources to test, save, and spawn. The autolathe's Medical category contains the weight analyzer; cargo offers the Body Composition Equipment Crate. Admin-spawnable items include `/obj/item/portable_weight_scanner`, `/obj/structure/scale`, `/obj/item/bluespace_belt`, and `/obj/item/reagent_containers/glass/bottle/lipoifier`.

The focused test build uses `GAME_TESTS`, `GS13_TESTS`, `CIBUILDING`, and `TEST_CONFIG_OVERRIDE="gs13_tests"`. Set `data/next_map.txt` to `/datum/map/test_tiny`, ensure `tmp/` exists, and run `tools/ci/run_server.sh`. The GS13 Actions workflow performs these steps when Actions is enabled for the fork. This focused suite disables SQL; it does not validate the database migration against a running database.

## Validation record

The initial implementation compiled with BYOND 516.1666 with zero errors and zero warnings, including the seven game tests. DreamChecker 1.11.0 reported zero diagnostics. A later workspace reset required restoration from the recorded changes; the restored revision passes DreamChecker with zero diagnostics and the duplicate-definition check. The first native CI attempt failed before compilation because the official BYOND host returned a non-ZIP response; the installer now has the same community-mirror fallback used by tgstation. No successful runtime test result has yet been established. Compilation and static analysis alone do not establish gameplay correctness.

Source and asset attribution is in `modular_gs/ATTRIBUTION.md`.
