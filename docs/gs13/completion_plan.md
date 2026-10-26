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
| A. Source scope | Full modular file enumeration and historical delta recorded; 85 modular files and 12 reviewed inherited providers have identified partial adapters | Review each row, identify behavior-level dependencies, attach destination paths and tests, record justified exclusions such as source-disabled code |
| B. Paradise baseline | Complete for the recorded target: merged, both calorite and iridium preserved, rebuilt UI saved, full native and live SQL checks pass | Recheck when updating the target pin |
| C. Body model and measurements | Weight/fullness/exercise, physical size/mass/BMI, DNA/cloning, optional weight-driven growth, and initial human appearance pass native tests | Taur/body-shape anatomy, remaining measurements, supported species, previews and body changes |
| D. Helplessness | Saved thresholds, quirks, movement/hands/speech/face/nearsight, directional FOV, immunity, server configuration, clothing fit, buckling, chair breakage, waddling, and doorway squeezing pass focused/full native tests | Direct client FOV rendering/performance, remaining source feedback and variants, complete client gameplay checks |
| E. Transformations | Shared state/restoration, blueberry chemistry, pressure/bursting with native stomach trauma, disease/drain cure, crops, Permaberry, WT collar, Starshine with persistent Neutron overdose, and complete dependent cyborg palette have native adapters | Full digestive/anatomy/species integration, source liquid/audio details, direct client appearance/gameplay checks |
| F. Appearance and clothing | Nine human stages, four belly styles, independent belly/hip sizes/colors, native loadout/wardrobe acquisition for grey, dual-tone, button-up, turtleneck and six-channel costume families, optional smooth paired anatomy/body-uniform layers, and MOD exoskeleton compatibility pass native tests | Remaining anatomy arrangements/styles, full source part-size DNA/ranges and color channels, species/digitigrade/taur fits, remaining clothing families/armor/palettes/layers, previews and missing/prosthetic parts |
| G. Atmosphere and calorite | Calorite ore, structures, optics, and contact chemistry exist | GS13 gas behavior through MILLA, lungs/synthetic exposure, synthesis/reactions/canisters, material transmutation and associated effects |
| H. Species and medical systems | A physical stomach with oral contents/absorption, three optional fluid organs with source breast growth/live DNA limits, two nutritional implants, Weight Gain and Berrification symptoms, and selected quirks exist | Required inherited species and specialized organs, including Protean dependencies; remaining symptoms/mutations/quirks/nanites; treatment and surgery integration |
| I. Equipment and power | Initial weapons, spells, MOD modules, feeding tools with all reservoir choices, WT collar, generator and transformer exist | Remaining weapon/tool families, soulcatcher/transmogrifier, abilities, powerator/SMES/persistence, gym and other machinery, construction and cleanup |
| J. Chemistry and food | Initial reagents/crops/mixed drinks plus blueberry and all four Starshine flavors exist | Remaining drinks/foods/recipes/containers, exposure effects, processing, distribution, source nutrient/timing conversions |
| K. World and distribution | Selected cargo/uplink/research/mining integrations and constructible Starshine vendor/refill exist | Remaining vendors/research/loadout/crafting, xenoarch, maps/shuttles/jobs/events/ghost roles, configuration, acquisition for every feature |
| L. Interfaces and persistence | Weight editor/SQL column and feeding/autolathe interfaces exist; live migrations/fresh schema pass; native cloning restores independent scan-time policy and birth anatomy; merged UI saved | Remaining preference/UI contracts, real player save/load/body-transfer/reconnect coverage, permission checks and updated bundles |
| M. Release verification | Focused/full native CI, UI and live SQL checks pass; no manual client gameplay test | All scoped rows resolved; native and relevant ordinary Paradise tests; representative maps/rounds; client gameplay checks; runtime/performance review; reproducible install and known limitations |

Milestone B is complete for the recorded Paradise target; all other milestones remain open. Inventory discovery is complete for the enumerated paths; semantic feature review is ongoing.

## Dependency order

1. Keep the validated baseline reproducible; update the target pin deliberately.
2. Audit and complete the body-size/effective-weight contract shared by measurement, movement, appearance, and thresholds.
3. Implement the helplessness framework as one feature group: saved thresholds, effects, immunity, and cleanup. Then integrate equipment, speech, buckling, and door checks.
4. Implement transformation state and appearance restoration before blueberry chemistry, diseases, crops, and the remaining cyborg choices.
5. Extend species/anatomy and rendering together; use that foundation for clothing and inherited species systems.
6. Adapt gas exposure and material behavior to native atmosphere and machinery APIs.
7. Close remaining equipment, medical, food, and world groups with their normal acquisition paths.
8. Finish persistence and release gates throughout integration; perform final end-to-end testing after the complete feature set is present.

## Ordered work queue (2026-10-25)

Work through this queue in order. A checked implementation item requires reviewed source behavior, native lifecycle handling, acquisition where applicable, passing integration tests, and a saved checkpoint. Client-only verification stays explicit in the release gates and does not silently become an automated pass. The broader milestones above remain open until all of their gates are resolved.

- [x] 1. Transformation state and appearance restoration: independent effects, volume-driven stages, apparent weight, tint ownership, recovery, preference edits, deletion, death/revival, species changes, and body transfers. Native foundation `6c9447f1bd279e35bf3b01cef65e90ede78b7279` passed 173 focused / 228 full tests in [run 40094428981](https://github.com/bobatochaps/Paradisefunnything/actions/runs/40094428981). Client rendering remains a release gate.
- [ ] 2. Blueberry and dependent content: juice chemistry, pressure and bursting settings/actions, disease and treatment, crops, Permaberry, anti-burst collars, all Starshine/cyborg choices, persistent Neutron organ changes with weight-driven reservoirs, and separate oral stomach contents/absorption are implemented. Combined native checkpoint `72a5176c073048383a3995d2151d54ce4c6867c3` passed 288 focused / 343 full tests. Keep this item open for complete digestive/anatomy support in item 3 and the documented liquid/audio and client gates. See [the implementation record](transformations.md).
- [ ] 3. Species, anatomy, and appearance: native stomach trauma/treatment/transplantation, oral routing, optional fluid organs with weight growth/live maxima, independent human belly/hip sizes/colors, four belly styles, normal acquisition and two-channel palettes for grey/dual-tone modular uniforms, optional smooth paired body/clothing layers, and native cloning compatibility are implemented. Continue remaining anatomy arrangements/styles, full source part-size DNA/ranges and color channels, swallowing/items, specialized organs/healing, required species, complete shapes/digitigrade/taur fits, remaining clothing families/layers, missing/prosthetic parts, and previews. See [the anatomy record](anatomy.md), [clothing record](clothing.md), [digestion record](digestion.md), and [cloning record](persistence.md).
- [ ] 4. Atmosphere and calorite: native MILLA gases, organic/synthetic exposure, synthesis and canisters, material transmutation, and remaining calorite effects.
- [ ] 5. Medical systems: remaining symptoms, mutations, quirks, nanites, treatment, surgery, and medical acquisition.
- [ ] 6. Equipment and power: remaining weapons/tools/spells, soulcatcher/transmogrifier and curse behavior, MOD and cyborg abilities, gym and other machinery, powerator/SMES/persistence, construction, and cleanup. The shared volume transformation controller does not implement the separate source `new_tf_item.dm` feature.
- [ ] 7. Chemistry and food: remaining reagents, drinks, food, recipes, containers, processing, timing/nutrition conversions, and normal distribution.
- [ ] 8. World and acquisition: vendors, research, cargo, loadouts/crafting, xenoarchaeology, maps/shuttles, jobs/events/ghost roles, and configuration. Cross-check acquisition for every implemented feature.
- [ ] 9. Interfaces and persistence: remaining UI/preference contracts, permission checks, player SQL save/load, body transfers, reconnects, and updated production bundles.
- [ ] 10. Source closure and release: disposition every source/dependency row; run the complete native/UI/SQL suites and representative maps/rounds; perform client gameplay, rendering, and performance checks; document installation and remaining differences.

Preserve unrelated workspace edits while preparing each checkpoint.

Save and publish small checkpoints as work proceeds. Record the code revision, last passing validation, current limitations, and next dependency so a usage-limit interruption can resume from Git without relying on conversation state.

## Required record for each completed feature

- Exact source behavior and active entry points; source-disabled blocks noted separately.
- Native destination paths and the reason for API or balance-unit adaptations.
- Required inherited systems and their reviewed scope.
- Assets, normal acquisition, research/cargo/vendor/crafting placement, and applicable settings.
- Preference behavior and cleanup through removal, deletion, death, revival, species/body changes, and disconnects where applicable.
- Appropriate native integration tests and a client test procedure/result.
- Remaining differences explicitly recorded; a missing dependency prevents closure.

## Baseline integration checkpoint

The validated merge preserves both `MAT_CALORITE` and the new upstream `MAT_IRIDIUM` in the exosuit fabricator. Automatic merges in the human life loop, MOD themes, research disks, AI core, and test includes were reviewed. The production UI was rebuilt from the merged source and saved at `f6528aea67b020fcc382fda4ad1cbfad30d69fbd`; full native, UI, and live SQL validation passed.

Unrelated local changes in the user's original working checkout are outside this candidate and are not published with it.

## Latest saved checkpoint

`72a5176c073048383a3995d2151d54ce4c6867c3` passed 288 focused and 343 full game tests, zero compiler errors/warnings and no runtime failures, plus UI and live MariaDB checks in [run 40207618184](https://github.com/bobatochaps/Paradisefunnything/actions/runs/40207618184). Three tests added since the shirt checkpoint cover actual six-channel loadout/item JSON and visible object/side-detail pixels, separate current-body skin and equipment cleanup, and ordinary vending/refill/recovery. Two new native BYOND previews were inspected in all four directions, bringing inspected appearance previews to thirty. Direct client verification remains unperformed.

The source grey, dual-tone, button-up, turtleneck and six-channel costume families now have native indexed colors and normal mapped loadout/wardrobe acquisition. Original assets and static previews are retained. Next are body-shape DNA and remaining anatomy styles/arrangements/ranges/colors, specialized organs/healing/swallowed items, broader species, and other clothing. Direct client appearance, FOV, gameplay, and performance checks have not been performed. [The anatomy record](anatomy.md) and [clothing record](clothing.md) state adaptations, differences, and verification. Inventory mappings identify 85 partial modular adapters and twelve reviewed inherited providers; gate notes survive regeneration only for matching source pins/hashes. The complete port remains unfinished.

## Body-shape DNA continuation

The validated costume record and body-shape DNA candidate are prepared for the existing testing branch. Publication of continuing port checkpoints and CI is explicitly authorized. The candidate implements native trait cloning/storage/identity transfer, separate body-owned visual gates, legacy compatibility and changed-trait-only live updates. Four new integration tests and extended real-cloning coverage are prepared; static checks pass. Native validation has not run for this candidate. Resolve native results before closing any gate. Unrelated workspace changes remain outside the port commits.
