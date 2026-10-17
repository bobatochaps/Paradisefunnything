# GS13 completion plan

The deliverable is every active GS13-specific feature and its required inherited behavior integrated into playable Paradise, with source assets, normal acquisition, preferences, persistence, and validation. This remains unfinished. A passing focused suite is not a feature-parity certificate.

## Revisions and scope evidence

- GS13 source: `ec3ad13bd34b64451813004e32892d49de745404`.
- Historical Bubber merge base: `2968992d556348d5ac3815c034614e441faa8261`, obtained by comparing the pinned GS13 source against Bubberstation master on 2026-10-17.
- Original Paradise base: `7084a06407db70b41389045dd38f54ae3eb2d1f1`.
- Audited Paradise master: `4657875a140bf9b49416a154fe4bc4cd364ce925`, retrieved on 2026-10-17.
- Last validated feature checkpoint before this audit: `1efc82c0ef0f0eb8204e9cf3db3dd6df3abb5a18`, 120 focused native tests, clean compile, and successful UI checks.

The [generated inventory](source_inventory.md) lists all 302 modular DM files. The historical source delta has 1,279 file changes, 406 outside `modular_gs`; 252 of those outside changes are DM or TypeScript. The marker search adds 249 candidate files, and the type-reference scan identifies 232 inherited provider candidates. These sets overlap and must not be added together as a feature count.

`source_inventory.json` records source hashes, declarations, asset literals, dependency-provider candidates, all historical branch changes, marker locations, identified native adapters, and the 134-file Paradise update. The scan deliberately does not infer completeness from matching type names. Unchanged inherited systems can still be required. Dynamic calls, macros, conditional compilation, parent behavior, resource selectors, and UI contracts need semantic review.

## Completion ledger

| Milestone | Current evidence | Work required before closure |
|---|---|---|
| A. Source scope | Full modular file enumeration and historical delta recorded; 53 source files have explicitly identified partial adapters | Review each row, identify behavior-level dependencies, attach destination paths and tests, record justified exclusions such as source-disabled code |
| B. Paradise baseline | 134 upstream file changes; trial merge has fabricator and generated-bundle conflicts | Preserve calorite and upstream iridium in the fabricator, validate merged native code, rebuild and save UI from merged sources, record the new target pin |
| C. Body model and measurements | Regular/permanent/apparent weight, rates, fullness, exercise, and initial human appearance work | Body size scaling, taur/body-shape anatomy, all affected measurements, supported species and body changes |
| D. Helplessness | Native weight movement penalties and fat stun exist; source threshold system absent | Threshold preferences and quirks, source-scoped cleanup, movement/hand/speech/equipment/buckle rules, immunity integration, vision adapters, door stuckage and server configuration |
| E. Transformations | Blueberry and bursting systems absent | Stage/state model, appearance restoration, exposure and preference gates, pressure/bursting rules, recovery/death cleanup, blueberry disease/crops/collars, Starshine and dependent cyborg palette |
| F. Appearance and clothing | Nine human stages and initial modular uniforms; MOD exoskeleton adapts to them | Species/body-shape/digitigrade/taur fits, all source clothing families, accessories and layers, previews and missing/prosthetic parts |
| G. Atmosphere and calorite | Calorite ore, structures, optics, and contact chemistry exist | GS13 gas behavior through MILLA, lungs/synthetic exposure, synthesis/reactions/canisters, material transmutation and associated effects |
| H. Species and medical systems | Two nutritional implants and Weight Gain symptom exist | Required inherited species and organs, including Protean dependencies; remaining symptoms/mutations/quirks/nanites; treatment and surgery integration |
| I. Equipment and power | Initial weapons, spells, MOD modules, feeding tools, generator and transformer exist | Remaining weapon/tool families, abilities, powerator/SMES/persistence, gym and other machinery, construction and cleanup |
| J. Chemistry and food | Initial reagents, three crops, and four mixed drinks exist | Remaining drinks/foods/recipes/containers, exposure effects, processing, distribution, source nutrient/timing conversions |
| K. World and distribution | Selected cargo/uplink/research/mining integrations exist | Vendors, remaining research/loadout/crafting, xenoarch, maps/shuttles/jobs/events/ghost roles, configuration, acquisition for every feature |
| L. Interfaces and persistence | Weight editor/SQL column and feeding/autolathe interfaces exist | All required preference/UI contracts, live SQL migration, save/load/body-transfer coverage, permission checks and production bundles |
| M. Release verification | Focused CI available; no manual client or live SQL validation | All scoped rows resolved; native and relevant ordinary Paradise tests; representative maps/rounds; client gameplay checks; runtime/performance review; reproducible install and known limitations |

No milestone is currently marked complete. Inventory discovery is complete for the enumerated paths; semantic feature review is ongoing.

## Dependency order

1. Finish baseline integration and keep the tested commit reproducible.
2. Audit and complete the body-size/effective-weight contract shared by measurement, movement, appearance, and thresholds.
3. Implement the helplessness framework as one feature group: saved thresholds, effects, immunity, and cleanup. Then integrate equipment, speech, buckling, and door checks.
4. Implement transformation state and appearance restoration before blueberry chemistry, diseases, crops, and the remaining cyborg choices.
5. Extend species/anatomy and rendering together; use that foundation for clothing and inherited species systems.
6. Adapt gas exposure and material behavior to native atmosphere and machinery APIs.
7. Close remaining equipment, medical, food, and world groups with their normal acquisition paths.
8. Finish persistence and release gates throughout integration; perform final end-to-end testing after the complete feature set is present.

## Required record for each completed feature

- Exact source behavior and active entry points; source-disabled blocks noted separately.
- Native destination paths and the reason for API or balance-unit adaptations.
- Required inherited systems and their reviewed scope.
- Assets, normal acquisition, research/cargo/vendor/crafting placement, and applicable settings.
- Preference behavior and cleanup through removal, deletion, death, revival, species/body changes, and disconnects where applicable.
- Appropriate native integration tests and a client test procedure/result.
- Remaining differences explicitly recorded; a missing dependency prevents closure.

## Baseline integration checkpoint

The isolated candidate preserves both `MAT_CALORITE` and the new upstream `MAT_IRIDIUM` in the exosuit fabricator. Automatic merges in the human life loop, MOD themes, research disks, AI core, and test includes were reviewed. The production UI must be rebuilt from the merged source; selecting either prebuilt bundle does not resolve the source combination. Native and UI CI validation is pending.

Unrelated local changes in the user's original working checkout are outside this candidate and are not published with it.
