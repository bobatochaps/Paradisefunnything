# GS13 source inventory

Source: `ec3ad13bd34b64451813004e32892d49de745404`. Audited Paradise master: `4657875a140bf9b49416a154fe4bc4cd364ce925`.

302 modular DM files; 302 listed in the root DME. 249 outside-module files contain attribution/integration markers. 232 inherited provider files are lexical dependency candidates.

Historical Bubber merge base: `2968992d556348d5ac3815c034614e441faa8261`. The exact source branch delta contains 1279 file changes, including 406 outside `modular_gs`; this also captures unmarked changes and deletions.

These are discovery counts, not a completion percentage. No file is marked complete until its semantic and gameplay gates are checked. `partial-adapter` means an existing adapter was identified; `needs-semantic-audit` does not assert that every declaration is missing.

Regenerate with `python3 tools/gs13/audit_source.py ../gs13-source`. Detailed declarations, provider candidates, asset literals, hashes, marker lines, and upstream changes are in [source_inventory.json](source_inventory.json). See [completion_plan.md](completion_plan.md) for the dependency order and release gates.

| Domain | Source files |
|---|---:|
| atmosphere-and-materials | 24 |
| body-and-appearance | 32 |
| chemistry-food-botany | 24 |
| distribution-and-research | 25 |
| equipment-and-abilities | 20 |
| helplessness-and-transformations | 13 |
| machinery-and-power | 15 |
| preferences-and-core | 37 |
| species-medical-and-quirks | 34 |
| world-and-round | 18 |
| world-content-and-misc | 60 |

## File checklist

| Source | Status | Identified native adapters |
|---|---|---|
| [modular_gs/code/__DEFINES/powerator.dm](https://github.com/sheepishgoat/GS13-Blubberstation/blob/ec3ad13bd34b64451813004e32892d49de745404/modular_gs/code/__DEFINES/powerator.dm) | needs-semantic-audit | Audit required |
| [modular_gs/code/__DEFINES/status_effects.dm](https://github.com/sheepishgoat/GS13-Blubberstation/blob/ec3ad13bd34b64451813004e32892d49de745404/modular_gs/code/__DEFINES/status_effects.dm) | needs-semantic-audit | Audit required |
| [modular_gs/code/__HELPERS/fatness.dm](https://github.com/sheepishgoat/GS13-Blubberstation/blob/ec3ad13bd34b64451813004e32892d49de745404/modular_gs/code/__HELPERS/fatness.dm) | needs-semantic-audit | Audit required |
| [modular_gs/code/_globalvars/lists/fatness.dm](https://github.com/sheepishgoat/GS13-Blubberstation/blob/ec3ad13bd34b64451813004e32892d49de745404/modular_gs/code/_globalvars/lists/fatness.dm) | needs-semantic-audit | Audit required |
| [modular_gs/code/_globalvars/lists/quirks.dm](https://github.com/sheepishgoat/GS13-Blubberstation/blob/ec3ad13bd34b64451813004e32892d49de745404/modular_gs/code/_globalvars/lists/quirks.dm) | needs-semantic-audit | Audit required |
| [modular_gs/code/_globalvars/powerator.dm](https://github.com/sheepishgoat/GS13-Blubberstation/blob/ec3ad13bd34b64451813004e32892d49de745404/modular_gs/code/_globalvars/powerator.dm) | needs-semantic-audit | Audit required |
| [modular_gs/code/clothing/accessory.dm](https://github.com/sheepishgoat/GS13-Blubberstation/blob/ec3ad13bd34b64451813004e32892d49de745404/modular_gs/code/clothing/accessory.dm) | needs-semantic-audit | Audit required |
| [modular_gs/code/clothing/bluespace_collar.dm](https://github.com/sheepishgoat/GS13-Blubberstation/blob/ec3ad13bd34b64451813004e32892d49de745404/modular_gs/code/clothing/bluespace_collar.dm) | partial-adapter | `code/modules/gs13/collars.dm` |
| [modular_gs/code/clothing/calorite_collar.dm](https://github.com/sheepishgoat/GS13-Blubberstation/blob/ec3ad13bd34b64451813004e32892d49de745404/modular_gs/code/clothing/calorite_collar.dm) | partial-adapter | `code/modules/gs13/collars.dm` |
| [modular_gs/code/clothing/head.dm](https://github.com/sheepishgoat/GS13-Blubberstation/blob/ec3ad13bd34b64451813004e32892d49de745404/modular_gs/code/clothing/head.dm) | needs-semantic-audit | Audit required |
| [modular_gs/code/clothing/supermatter_pendant.dm](https://github.com/sheepishgoat/GS13-Blubberstation/blob/ec3ad13bd34b64451813004e32892d49de745404/modular_gs/code/clothing/supermatter_pendant.dm) | needs-semantic-audit | Audit required |
| [modular_gs/code/clothing/under.dm](https://github.com/sheepishgoat/GS13-Blubberstation/blob/ec3ad13bd34b64451813004e32892d49de745404/modular_gs/code/clothing/under.dm) | needs-semantic-audit | Audit required |
| [modular_gs/code/controllers/configuration/configuration.dm](https://github.com/sheepishgoat/GS13-Blubberstation/blob/ec3ad13bd34b64451813004e32892d49de745404/modular_gs/code/controllers/configuration/configuration.dm) | needs-semantic-audit | Audit required |
| [modular_gs/code/controllers/configuration/entries/auto_storyteller_vote.dm](https://github.com/sheepishgoat/GS13-Blubberstation/blob/ec3ad13bd34b64451813004e32892d49de745404/modular_gs/code/controllers/configuration/entries/auto_storyteller_vote.dm) | needs-semantic-audit | Audit required |
| [modular_gs/code/controllers/configuration/entries/helplessness.dm](https://github.com/sheepishgoat/GS13-Blubberstation/blob/ec3ad13bd34b64451813004e32892d49de745404/modular_gs/code/controllers/configuration/entries/helplessness.dm) | partial-adapter | `code/modules/gs13/helplessness.dm` |
| [modular_gs/code/controllers/subsystem/mapping.dm](https://github.com/sheepishgoat/GS13-Blubberstation/blob/ec3ad13bd34b64451813004e32892d49de745404/modular_gs/code/controllers/subsystem/mapping.dm) | needs-semantic-audit | Audit required |
| [modular_gs/code/controllers/subsystem/persistence/_persistence.dm](https://github.com/sheepishgoat/GS13-Blubberstation/blob/ec3ad13bd34b64451813004e32892d49de745404/modular_gs/code/controllers/subsystem/persistence/_persistence.dm) | needs-semantic-audit | Audit required |
| [modular_gs/code/controllers/subsystem/persistence/powerator.dm](https://github.com/sheepishgoat/GS13-Blubberstation/blob/ec3ad13bd34b64451813004e32892d49de745404/modular_gs/code/controllers/subsystem/persistence/powerator.dm) | needs-semantic-audit | Audit required |
| [modular_gs/code/datums/_helplessness.dm](https://github.com/sheepishgoat/GS13-Blubberstation/blob/ec3ad13bd34b64451813004e32892d49de745404/modular_gs/code/datums/_helplessness.dm) | partial-adapter | `code/modules/gs13/helplessness.dm` |
| [modular_gs/code/datums/_id_trim.dm](https://github.com/sheepishgoat/GS13-Blubberstation/blob/ec3ad13bd34b64451813004e32892d49de745404/modular_gs/code/datums/_id_trim.dm) | needs-semantic-audit | Audit required |
| [modular_gs/code/datums/components/crafting/cargo.dm](https://github.com/sheepishgoat/GS13-Blubberstation/blob/ec3ad13bd34b64451813004e32892d49de745404/modular_gs/code/datums/components/crafting/cargo.dm) | needs-semantic-audit | Audit required |
| [modular_gs/code/datums/components/fattening.dm](https://github.com/sheepishgoat/GS13-Blubberstation/blob/ec3ad13bd34b64451813004e32892d49de745404/modular_gs/code/datums/components/fattening.dm) | partial-adapter | `code/modules/gs13/fattening_component.dm` |
| [modular_gs/code/datums/components/fattening_door.dm](https://github.com/sheepishgoat/GS13-Blubberstation/blob/ec3ad13bd34b64451813004e32892d49de745404/modular_gs/code/datums/components/fattening_door.dm) | partial-adapter | `code/modules/gs13/calorite_construction.dm` |
| [modular_gs/code/datums/components/weight_scale.dm](https://github.com/sheepishgoat/GS13-Blubberstation/blob/ec3ad13bd34b64451813004e32892d49de745404/modular_gs/code/datums/components/weight_scale.dm) | partial-adapter | `code/modules/gs13/equipment.dm` |
| [modular_gs/code/datums/debuffs/burpslurring.dm](https://github.com/sheepishgoat/GS13-Blubberstation/blob/ec3ad13bd34b64451813004e32892d49de745404/modular_gs/code/datums/debuffs/burpslurring.dm) | needs-semantic-audit | Audit required |
| [modular_gs/code/datums/diseases/advance/presets.dm](https://github.com/sheepishgoat/GS13-Blubberstation/blob/ec3ad13bd34b64451813004e32892d49de745404/modular_gs/code/datums/diseases/advance/presets.dm) | needs-semantic-audit | Audit required |
| [modular_gs/code/datums/diseases/advance/symptoms/berry.dm](https://github.com/sheepishgoat/GS13-Blubberstation/blob/ec3ad13bd34b64451813004e32892d49de745404/modular_gs/code/datums/diseases/advance/symptoms/berry.dm) | needs-semantic-audit | Audit required |
| [modular_gs/code/datums/diseases/advance/symptoms/weight_gain.dm](https://github.com/sheepishgoat/GS13-Blubberstation/blob/ec3ad13bd34b64451813004e32892d49de745404/modular_gs/code/datums/diseases/advance/symptoms/weight_gain.dm) | partial-adapter | `code/modules/gs13/virology.dm` |
| [modular_gs/code/datums/helplessness/helplessness.dm](https://github.com/sheepishgoat/GS13-Blubberstation/blob/ec3ad13bd34b64451813004e32892d49de745404/modular_gs/code/datums/helplessness/helplessness.dm) | partial-adapter | `code/modules/gs13/helplessness.dm`, `code/modules/gs13/helplessness_effects.dm`, `code/modules/gs13/helplessness_equipment.dm` |
| [modular_gs/code/datums/interaction_datum.dm](https://github.com/sheepishgoat/GS13-Blubberstation/blob/ec3ad13bd34b64451813004e32892d49de745404/modular_gs/code/datums/interaction_datum.dm) | needs-semantic-audit | Audit required |
| [modular_gs/code/datums/keybinds.dm](https://github.com/sheepishgoat/GS13-Blubberstation/blob/ec3ad13bd34b64451813004e32892d49de745404/modular_gs/code/datums/keybinds.dm) | needs-semantic-audit | Audit required |
| [modular_gs/code/datums/mutations/adipohazard.dm](https://github.com/sheepishgoat/GS13-Blubberstation/blob/ec3ad13bd34b64451813004e32892d49de745404/modular_gs/code/datums/mutations/adipohazard.dm) | needs-semantic-audit | Audit required |
| [modular_gs/code/datums/mutations/fatfang.dm](https://github.com/sheepishgoat/GS13-Blubberstation/blob/ec3ad13bd34b64451813004e32892d49de745404/modular_gs/code/datums/mutations/fatfang.dm) | needs-semantic-audit | Audit required |
| [modular_gs/code/datums/mutations/radfat.dm](https://github.com/sheepishgoat/GS13-Blubberstation/blob/ec3ad13bd34b64451813004e32892d49de745404/modular_gs/code/datums/mutations/radfat.dm) | needs-semantic-audit | Audit required |
| [modular_gs/code/datums/outfits.dm](https://github.com/sheepishgoat/GS13-Blubberstation/blob/ec3ad13bd34b64451813004e32892d49de745404/modular_gs/code/datums/outfits.dm) | needs-semantic-audit | Audit required |
| [modular_gs/code/datums/pod_style.dm](https://github.com/sheepishgoat/GS13-Blubberstation/blob/ec3ad13bd34b64451813004e32892d49de745404/modular_gs/code/datums/pod_style.dm) | needs-semantic-audit | Audit required |
| [modular_gs/code/datums/quirks/defines.dm](https://github.com/sheepishgoat/GS13-Blubberstation/blob/ec3ad13bd34b64451813004e32892d49de745404/modular_gs/code/datums/quirks/defines.dm) | needs-semantic-audit | Audit required |
| [modular_gs/code/datums/quirks/negative/cold_blooded.dm](https://github.com/sheepishgoat/GS13-Blubberstation/blob/ec3ad13bd34b64451813004e32892d49de745404/modular_gs/code/datums/quirks/negative/cold_blooded.dm) | needs-semantic-audit | Audit required |
| [modular_gs/code/datums/quirks/negative/demonic.dm](https://github.com/sheepishgoat/GS13-Blubberstation/blob/ec3ad13bd34b64451813004e32892d49de745404/modular_gs/code/datums/quirks/negative/demonic.dm) | needs-semantic-audit | Audit required |
| [modular_gs/code/datums/quirks/negative/fat_aversion.dm](https://github.com/sheepishgoat/GS13-Blubberstation/blob/ec3ad13bd34b64451813004e32892d49de745404/modular_gs/code/datums/quirks/negative/fat_aversion.dm) | needs-semantic-audit | Audit required |
| [modular_gs/code/datums/quirks/negative/negative_quirks.dm](https://github.com/sheepishgoat/GS13-Blubberstation/blob/ec3ad13bd34b64451813004e32892d49de745404/modular_gs/code/datums/quirks/negative/negative_quirks.dm) | partial-adapter | `code/modules/gs13/quirks.dm` |
| [modular_gs/code/datums/quirks/neutral/cosglow.dm](https://github.com/sheepishgoat/GS13-Blubberstation/blob/ec3ad13bd34b64451813004e32892d49de745404/modular_gs/code/datums/quirks/neutral/cosglow.dm) | needs-semantic-audit | Audit required |
| [modular_gs/code/datums/quirks/neutral/lisp.dm](https://github.com/sheepishgoat/GS13-Blubberstation/blob/ec3ad13bd34b64451813004e32892d49de745404/modular_gs/code/datums/quirks/neutral/lisp.dm) | needs-semantic-audit | Audit required |
| [modular_gs/code/datums/quirks/neutral/metal_cruncher.dm](https://github.com/sheepishgoat/GS13-Blubberstation/blob/ec3ad13bd34b64451813004e32892d49de745404/modular_gs/code/datums/quirks/neutral/metal_cruncher.dm) | needs-semantic-audit | Audit required |
| [modular_gs/code/datums/quirks/neutral/neutral_quirks.dm](https://github.com/sheepishgoat/GS13-Blubberstation/blob/ec3ad13bd34b64451813004e32892d49de745404/modular_gs/code/datums/quirks/neutral/neutral_quirks.dm) | needs-semantic-audit | Audit required |
| [modular_gs/code/datums/quirks/neutral/porcine.dm](https://github.com/sheepishgoat/GS13-Blubberstation/blob/ec3ad13bd34b64451813004e32892d49de745404/modular_gs/code/datums/quirks/neutral/porcine.dm) | needs-semantic-audit | Audit required |
| [modular_gs/code/datums/quirks/neutral/tail_sweep.dm](https://github.com/sheepishgoat/GS13-Blubberstation/blob/ec3ad13bd34b64451813004e32892d49de745404/modular_gs/code/datums/quirks/neutral/tail_sweep.dm) | needs-semantic-audit | Audit required |
| [modular_gs/code/datums/quirks/neutral/water_sponde.dm](https://github.com/sheepishgoat/GS13-Blubberstation/blob/ec3ad13bd34b64451813004e32892d49de745404/modular_gs/code/datums/quirks/neutral/water_sponde.dm) | needs-semantic-audit | Audit required |
| [modular_gs/code/datums/quirks/positive/fat_affinity.dm](https://github.com/sheepishgoat/GS13-Blubberstation/blob/ec3ad13bd34b64451813004e32892d49de745404/modular_gs/code/datums/quirks/positive/fat_affinity.dm) | needs-semantic-audit | Audit required |
| [modular_gs/code/datums/quirks/positive/genetic_mutation.dm](https://github.com/sheepishgoat/GS13-Blubberstation/blob/ec3ad13bd34b64451813004e32892d49de745404/modular_gs/code/datums/quirks/positive/genetic_mutation.dm) | needs-semantic-audit | Audit required |
| [modular_gs/code/datums/quirks/positive/pleasant_softness.dm](https://github.com/sheepishgoat/GS13-Blubberstation/blob/ec3ad13bd34b64451813004e32892d49de745404/modular_gs/code/datums/quirks/positive/pleasant_softness.dm) | needs-semantic-audit | Audit required |
| [modular_gs/code/datums/quirks/positive/positive_quirks.dm](https://github.com/sheepishgoat/GS13-Blubberstation/blob/ec3ad13bd34b64451813004e32892d49de745404/modular_gs/code/datums/quirks/positive/positive_quirks.dm) | needs-semantic-audit | Audit required |
| [modular_gs/code/datums/ruins.dm](https://github.com/sheepishgoat/GS13-Blubberstation/blob/ec3ad13bd34b64451813004e32892d49de745404/modular_gs/code/datums/ruins.dm) | needs-semantic-audit | Audit required |
| [modular_gs/code/datums/status_effects/fatstun.dm](https://github.com/sheepishgoat/GS13-Blubberstation/blob/ec3ad13bd34b64451813004e32892d49de745404/modular_gs/code/datums/status_effects/fatstun.dm) | partial-adapter | `code/modules/gs13/fat_stun.dm` |
| [modular_gs/code/datums/wires/airlock.dm](https://github.com/sheepishgoat/GS13-Blubberstation/blob/ec3ad13bd34b64451813004e32892d49de745404/modular_gs/code/datums/wires/airlock.dm) | needs-semantic-audit | Audit required |
| [modular_gs/code/game/donator.dm](https://github.com/sheepishgoat/GS13-Blubberstation/blob/ec3ad13bd34b64451813004e32892d49de745404/modular_gs/code/game/donator.dm) | needs-semantic-audit | Audit required |
| [modular_gs/code/game/lore_papers.dm](https://github.com/sheepishgoat/GS13-Blubberstation/blob/ec3ad13bd34b64451813004e32892d49de745404/modular_gs/code/game/lore_papers.dm) | needs-semantic-audit | Audit required |
| [modular_gs/code/game/machinery/airlock.dm](https://github.com/sheepishgoat/GS13-Blubberstation/blob/ec3ad13bd34b64451813004e32892d49de745404/modular_gs/code/game/machinery/airlock.dm) | needs-semantic-audit | Audit required |
| [modular_gs/code/game/objects/circuitboards.dm](https://github.com/sheepishgoat/GS13-Blubberstation/blob/ec3ad13bd34b64451813004e32892d49de745404/modular_gs/code/game/objects/circuitboards.dm) | needs-semantic-audit | Audit required |
| [modular_gs/code/game/objects/effects/decals/cleanable/misc.dm](https://github.com/sheepishgoat/GS13-Blubberstation/blob/ec3ad13bd34b64451813004e32892d49de745404/modular_gs/code/game/objects/effects/decals/cleanable/misc.dm) | needs-semantic-audit | Audit required |
| [modular_gs/code/game/objects/effects/posters.dm](https://github.com/sheepishgoat/GS13-Blubberstation/blob/ec3ad13bd34b64451813004e32892d49de745404/modular_gs/code/game/objects/effects/posters.dm) | needs-semantic-audit | Audit required |
| [modular_gs/code/game/objects/effects/spawners/decals.dm](https://github.com/sheepishgoat/GS13-Blubberstation/blob/ec3ad13bd34b64451813004e32892d49de745404/modular_gs/code/game/objects/effects/spawners/decals.dm) | needs-semantic-audit | Audit required |
| [modular_gs/code/game/objects/granters/magic/add_weight.dm](https://github.com/sheepishgoat/GS13-Blubberstation/blob/ec3ad13bd34b64451813004e32892d49de745404/modular_gs/code/game/objects/granters/magic/add_weight.dm) | needs-semantic-audit | Audit required |
| [modular_gs/code/game/objects/granters/magic/traps.dm](https://github.com/sheepishgoat/GS13-Blubberstation/blob/ec3ad13bd34b64451813004e32892d49de745404/modular_gs/code/game/objects/granters/magic/traps.dm) | needs-semantic-audit | Audit required |
| [modular_gs/code/game/objects/items/AI_modules.dm](https://github.com/sheepishgoat/GS13-Blubberstation/blob/ec3ad13bd34b64451813004e32892d49de745404/modular_gs/code/game/objects/items/AI_modules.dm) | needs-semantic-audit | Audit required |
| [modular_gs/code/game/objects/items/RSF.dm](https://github.com/sheepishgoat/GS13-Blubberstation/blob/ec3ad13bd34b64451813004e32892d49de745404/modular_gs/code/game/objects/items/RSF.dm) | needs-semantic-audit | Audit required |
| [modular_gs/code/game/objects/items/cards_ids.dm](https://github.com/sheepishgoat/GS13-Blubberstation/blob/ec3ad13bd34b64451813004e32892d49de745404/modular_gs/code/game/objects/items/cards_ids.dm) | needs-semantic-audit | Audit required |
| [modular_gs/code/game/objects/items/choice_beacon.dm](https://github.com/sheepishgoat/GS13-Blubberstation/blob/ec3ad13bd34b64451813004e32892d49de745404/modular_gs/code/game/objects/items/choice_beacon.dm) | needs-semantic-audit | Audit required |
| [modular_gs/code/game/objects/items/devices/scannners/health_analyzer.dm](https://github.com/sheepishgoat/GS13-Blubberstation/blob/ec3ad13bd34b64451813004e32892d49de745404/modular_gs/code/game/objects/items/devices/scannners/health_analyzer.dm) | needs-semantic-audit | Audit required |
| [modular_gs/code/game/objects/items/fat_plushies.dm](https://github.com/sheepishgoat/GS13-Blubberstation/blob/ec3ad13bd34b64451813004e32892d49de745404/modular_gs/code/game/objects/items/fat_plushies.dm) | needs-semantic-audit | Audit required |
| [modular_gs/code/game/objects/items/holosign_creator.dm](https://github.com/sheepishgoat/GS13-Blubberstation/blob/ec3ad13bd34b64451813004e32892d49de745404/modular_gs/code/game/objects/items/holosign_creator.dm) | needs-semantic-audit | Audit required |
| [modular_gs/code/game/objects/items/plushes.dm](https://github.com/sheepishgoat/GS13-Blubberstation/blob/ec3ad13bd34b64451813004e32892d49de745404/modular_gs/code/game/objects/items/plushes.dm) | needs-semantic-audit | Audit required |
| [modular_gs/code/game/objects/items/reagent_containers.dm](https://github.com/sheepishgoat/GS13-Blubberstation/blob/ec3ad13bd34b64451813004e32892d49de745404/modular_gs/code/game/objects/items/reagent_containers.dm) | needs-semantic-audit | Audit required |
| [modular_gs/code/game/objects/items/robot_upgrades.dm](https://github.com/sheepishgoat/GS13-Blubberstation/blob/ec3ad13bd34b64451813004e32892d49de745404/modular_gs/code/game/objects/items/robot_upgrades.dm) | needs-semantic-audit | Audit required |
| [modular_gs/code/game/objects/items/stacks/sheets/sheet_types.dm](https://github.com/sheepishgoat/GS13-Blubberstation/blob/ec3ad13bd34b64451813004e32892d49de745404/modular_gs/code/game/objects/items/stacks/sheets/sheet_types.dm) | needs-semantic-audit | Audit required |
| [modular_gs/code/game/objects/items/stacks/tiles/tile_types.dm](https://github.com/sheepishgoat/GS13-Blubberstation/blob/ec3ad13bd34b64451813004e32892d49de745404/modular_gs/code/game/objects/items/stacks/tiles/tile_types.dm) | needs-semantic-audit | Audit required |
| [modular_gs/code/game/objects/items/storage/fancy.dm](https://github.com/sheepishgoat/GS13-Blubberstation/blob/ec3ad13bd34b64451813004e32892d49de745404/modular_gs/code/game/objects/items/storage/fancy.dm) | needs-semantic-audit | Audit required |
| [modular_gs/code/game/objects/items/storage/garment.dm](https://github.com/sheepishgoat/GS13-Blubberstation/blob/ec3ad13bd34b64451813004e32892d49de745404/modular_gs/code/game/objects/items/storage/garment.dm) | needs-semantic-audit | Audit required |
| [modular_gs/code/game/objects/items/toys.dm](https://github.com/sheepishgoat/GS13-Blubberstation/blob/ec3ad13bd34b64451813004e32892d49de745404/modular_gs/code/game/objects/items/toys.dm) | needs-semantic-audit | Audit required |
| [modular_gs/code/game/objects/structures/beds_chairs/bed.dm](https://github.com/sheepishgoat/GS13-Blubberstation/blob/ec3ad13bd34b64451813004e32892d49de745404/modular_gs/code/game/objects/structures/beds_chairs/bed.dm) | needs-semantic-audit | Audit required |
| [modular_gs/code/game/objects/structures/beds_chairs/chair.dm](https://github.com/sheepishgoat/GS13-Blubberstation/blob/ec3ad13bd34b64451813004e32892d49de745404/modular_gs/code/game/objects/structures/beds_chairs/chair.dm) | needs-semantic-audit | Audit required |
| [modular_gs/code/game/objects/structures/calorite_reflector.dm](https://github.com/sheepishgoat/GS13-Blubberstation/blob/ec3ad13bd34b64451813004e32892d49de745404/modular_gs/code/game/objects/structures/calorite_reflector.dm) | needs-semantic-audit | Audit required |
| [modular_gs/code/game/objects/structures/calorite_window.dm](https://github.com/sheepishgoat/GS13-Blubberstation/blob/ec3ad13bd34b64451813004e32892d49de745404/modular_gs/code/game/objects/structures/calorite_window.dm) | needs-semantic-audit | Audit required |
| [modular_gs/code/game/objects/structures/crates_lockers/crates.dm](https://github.com/sheepishgoat/GS13-Blubberstation/blob/ec3ad13bd34b64451813004e32892d49de745404/modular_gs/code/game/objects/structures/crates_lockers/crates.dm) | needs-semantic-audit | Audit required |
| [modular_gs/code/game/objects/structures/crates_lockers/crates/wooden.dm](https://github.com/sheepishgoat/GS13-Blubberstation/blob/ec3ad13bd34b64451813004e32892d49de745404/modular_gs/code/game/objects/structures/crates_lockers/crates/wooden.dm) | needs-semantic-audit | Audit required |
| [modular_gs/code/game/objects/structures/dresser.dm](https://github.com/sheepishgoat/GS13-Blubberstation/blob/ec3ad13bd34b64451813004e32892d49de745404/modular_gs/code/game/objects/structures/dresser.dm) | needs-semantic-audit | Audit required |
| [modular_gs/code/game/objects/structures/sofa.dm](https://github.com/sheepishgoat/GS13-Blubberstation/blob/ec3ad13bd34b64451813004e32892d49de745404/modular_gs/code/game/objects/structures/sofa.dm) | needs-semantic-audit | Audit required |
| [modular_gs/code/game/objects/structures/statues.dm](https://github.com/sheepishgoat/GS13-Blubberstation/blob/ec3ad13bd34b64451813004e32892d49de745404/modular_gs/code/game/objects/structures/statues.dm) | needs-semantic-audit | Audit required |
| [modular_gs/code/game/objects/tiles.dm](https://github.com/sheepishgoat/GS13-Blubberstation/blob/ec3ad13bd34b64451813004e32892d49de745404/modular_gs/code/game/objects/tiles.dm) | needs-semantic-audit | Audit required |
| [modular_gs/code/game/objects/turfs.dm](https://github.com/sheepishgoat/GS13-Blubberstation/blob/ec3ad13bd34b64451813004e32892d49de745404/modular_gs/code/game/objects/turfs.dm) | needs-semantic-audit | Audit required |
| [modular_gs/code/game/turfs/closed.dm](https://github.com/sheepishgoat/GS13-Blubberstation/blob/ec3ad13bd34b64451813004e32892d49de745404/modular_gs/code/game/turfs/closed.dm) | needs-semantic-audit | Audit required |
| [modular_gs/code/game/turfs/closed/wall/calorite_walls.dm](https://github.com/sheepishgoat/GS13-Blubberstation/blob/ec3ad13bd34b64451813004e32892d49de745404/modular_gs/code/game/turfs/closed/wall/calorite_walls.dm) | needs-semantic-audit | Audit required |
| [modular_gs/code/game/turfs/open.dm](https://github.com/sheepishgoat/GS13-Blubberstation/blob/ec3ad13bd34b64451813004e32892d49de745404/modular_gs/code/game/turfs/open.dm) | needs-semantic-audit | Audit required |
| [modular_gs/code/game/turfs/open/calorite_floor.dm](https://github.com/sheepishgoat/GS13-Blubberstation/blob/ec3ad13bd34b64451813004e32892d49de745404/modular_gs/code/game/turfs/open/calorite_floor.dm) | needs-semantic-audit | Audit required |
| [modular_gs/code/game/turfs/open/effect_water.dm](https://github.com/sheepishgoat/GS13-Blubberstation/blob/ec3ad13bd34b64451813004e32892d49de745404/modular_gs/code/game/turfs/open/effect_water.dm) | needs-semantic-audit | Audit required |
| [modular_gs/code/game/turfs/simulated/floor/fancy_floor.dm](https://github.com/sheepishgoat/GS13-Blubberstation/blob/ec3ad13bd34b64451813004e32892d49de745404/modular_gs/code/game/turfs/simulated/floor/fancy_floor.dm) | needs-semantic-audit | Audit required |
| [modular_gs/code/machinery/adipoelectric_generator.dm](https://github.com/sheepishgoat/GS13-Blubberstation/blob/ec3ad13bd34b64451813004e32892d49de745404/modular_gs/code/machinery/adipoelectric_generator.dm) | partial-adapter | `code/modules/gs13/adipoelectric.dm` |
| [modular_gs/code/machinery/adipoelectric_transformer.dm](https://github.com/sheepishgoat/GS13-Blubberstation/blob/ec3ad13bd34b64451813004e32892d49de745404/modular_gs/code/machinery/adipoelectric_transformer.dm) | partial-adapter | `code/modules/gs13/adipoelectric.dm` |
| [modular_gs/code/machinery/cryogenic.dm](https://github.com/sheepishgoat/GS13-Blubberstation/blob/ec3ad13bd34b64451813004e32892d49de745404/modular_gs/code/machinery/cryogenic.dm) | needs-semantic-audit | Audit required |
| [modular_gs/code/machinery/fattening_turret.dm](https://github.com/sheepishgoat/GS13-Blubberstation/blob/ec3ad13bd34b64451813004e32892d49de745404/modular_gs/code/machinery/fattening_turret.dm) | needs-semantic-audit | Audit required |
| [modular_gs/code/machinery/feeding_tube.dm](https://github.com/sheepishgoat/GS13-Blubberstation/blob/ec3ad13bd34b64451813004e32892d49de745404/modular_gs/code/machinery/feeding_tube.dm) | partial-adapter | `code/modules/gs13/feeding_machine.dm` |
| [modular_gs/code/machinery/gato_respawner.dm](https://github.com/sheepishgoat/GS13-Blubberstation/blob/ec3ad13bd34b64451813004e32892d49de745404/modular_gs/code/machinery/gato_respawner.dm) | needs-semantic-audit | Audit required |
| [modular_gs/code/machinery/gym.dm](https://github.com/sheepishgoat/GS13-Blubberstation/blob/ec3ad13bd34b64451813004e32892d49de745404/modular_gs/code/machinery/gym.dm) | needs-semantic-audit | Audit required |
| [modular_gs/code/machinery/powered_quantum_pad.dm](https://github.com/sheepishgoat/GS13-Blubberstation/blob/ec3ad13bd34b64451813004e32892d49de745404/modular_gs/code/machinery/powered_quantum_pad.dm) | needs-semantic-audit | Audit required |
| [modular_gs/code/machinery/supply_teleporter.dm](https://github.com/sheepishgoat/GS13-Blubberstation/blob/ec3ad13bd34b64451813004e32892d49de745404/modular_gs/code/machinery/supply_teleporter.dm) | needs-semantic-audit | Audit required |
| [modular_gs/code/mechanics/calorite.dm](https://github.com/sheepishgoat/GS13-Blubberstation/blob/ec3ad13bd34b64451813004e32892d49de745404/modular_gs/code/mechanics/calorite.dm) | partial-adapter | `code/modules/gs13/calorite.dm`, `code/modules/gs13/calorite_construction.dm` |
| [modular_gs/code/mechanics/calorite_glass.dm](https://github.com/sheepishgoat/GS13-Blubberstation/blob/ec3ad13bd34b64451813004e32892d49de745404/modular_gs/code/mechanics/calorite_glass.dm) | partial-adapter | `code/modules/gs13/calorite_glass.dm` |
| [modular_gs/code/mechanics/chair_brekage.dm](https://github.com/sheepishgoat/GS13-Blubberstation/blob/ec3ad13bd34b64451813004e32892d49de745404/modular_gs/code/mechanics/chair_brekage.dm) | partial-adapter | `code/modules/gs13/helplessness_equipment.dm` |
| [modular_gs/code/mechanics/effective_fatness.dm](https://github.com/sheepishgoat/GS13-Blubberstation/blob/ec3ad13bd34b64451813004e32892d49de745404/modular_gs/code/mechanics/effective_fatness.dm) | partial-adapter | `code/modules/gs13/weight.dm` |
| [modular_gs/code/mechanics/fatness.dm](https://github.com/sheepishgoat/GS13-Blubberstation/blob/ec3ad13bd34b64451813004e32892d49de745404/modular_gs/code/mechanics/fatness.dm) | partial-adapter | `code/modules/gs13/weight.dm`, `code/modules/gs13/preferences.dm` |
| [modular_gs/code/mechanics/fatness/fatness_hiders.dm](https://github.com/sheepishgoat/GS13-Blubberstation/blob/ec3ad13bd34b64451813004e32892d49de745404/modular_gs/code/mechanics/fatness/fatness_hiders.dm) | partial-adapter | `code/modules/gs13/weight_hiders.dm` |
| [modular_gs/code/mechanics/fatness/weight_gain_rate.dm](https://github.com/sheepishgoat/GS13-Blubberstation/blob/ec3ad13bd34b64451813004e32892d49de745404/modular_gs/code/mechanics/fatness/weight_gain_rate.dm) | partial-adapter | `code/modules/gs13/weight_rates.dm` |
| [modular_gs/code/mechanics/fatrousal.dm](https://github.com/sheepishgoat/GS13-Blubberstation/blob/ec3ad13bd34b64451813004e32892d49de745404/modular_gs/code/mechanics/fatrousal.dm) | needs-semantic-audit | Audit required |
| [modular_gs/code/mechanics/fattening_gasses.dm](https://github.com/sheepishgoat/GS13-Blubberstation/blob/ec3ad13bd34b64451813004e32892d49de745404/modular_gs/code/mechanics/fattening_gasses.dm) | needs-semantic-audit | Audit required |
| [modular_gs/code/mechanics/fattening_trap.dm](https://github.com/sheepishgoat/GS13-Blubberstation/blob/ec3ad13bd34b64451813004e32892d49de745404/modular_gs/code/mechanics/fattening_trap.dm) | partial-adapter | `code/modules/gs13/magic_traps.dm` |
| [modular_gs/code/mechanics/fullness.dm](https://github.com/sheepishgoat/GS13-Blubberstation/blob/ec3ad13bd34b64451813004e32892d49de745404/modular_gs/code/mechanics/fullness.dm) | partial-adapter | `code/modules/gs13/fullness.dm` |
| [modular_gs/code/mechanics/muscle.dm](https://github.com/sheepishgoat/GS13-Blubberstation/blob/ec3ad13bd34b64451813004e32892d49de745404/modular_gs/code/mechanics/muscle.dm) | partial-adapter | `code/modules/gs13/weight.dm` |
| [modular_gs/code/mechanics/persistent_fat.dm](https://github.com/sheepishgoat/GS13-Blubberstation/blob/ec3ad13bd34b64451813004e32892d49de745404/modular_gs/code/mechanics/persistent_fat.dm) | needs-semantic-audit | Audit required |
| [modular_gs/code/mechanics/recipes.dm](https://github.com/sheepishgoat/GS13-Blubberstation/blob/ec3ad13bd34b64451813004e32892d49de745404/modular_gs/code/mechanics/recipes.dm) | needs-semantic-audit | Audit required |
| [modular_gs/code/mechanics/stuckage.dm](https://github.com/sheepishgoat/GS13-Blubberstation/blob/ec3ad13bd34b64451813004e32892d49de745404/modular_gs/code/mechanics/stuckage.dm) | partial-adapter | `code/modules/gs13/door_stuckage.dm` |
| [modular_gs/code/mechanics/transformation/new_tf_item.dm](https://github.com/sheepishgoat/GS13-Blubberstation/blob/ec3ad13bd34b64451813004e32892d49de745404/modular_gs/code/mechanics/transformation/new_tf_item.dm) | needs-semantic-audit | Audit required |
| [modular_gs/code/mechanics/water_sponge.dm](https://github.com/sheepishgoat/GS13-Blubberstation/blob/ec3ad13bd34b64451813004e32892d49de745404/modular_gs/code/mechanics/water_sponge.dm) | needs-semantic-audit | Audit required |
| [modular_gs/code/mechanics/xwg.dm](https://github.com/sheepishgoat/GS13-Blubberstation/blob/ec3ad13bd34b64451813004e32892d49de745404/modular_gs/code/mechanics/xwg.dm) | partial-adapter | `code/modules/gs13/weight_size.dm` |
| [modular_gs/code/mobs/chocoslime.dm](https://github.com/sheepishgoat/GS13-Blubberstation/blob/ec3ad13bd34b64451813004e32892d49de745404/modular_gs/code/mobs/chocoslime.dm) | needs-semantic-audit | Audit required |
| [modular_gs/code/modules/art/statues.dm](https://github.com/sheepishgoat/GS13-Blubberstation/blob/ec3ad13bd34b64451813004e32892d49de745404/modular_gs/code/modules/art/statues.dm) | needs-semantic-audit | Audit required |
| [modular_gs/code/modules/atmospherics/gasmixtures/gas_types.dm](https://github.com/sheepishgoat/GS13-Blubberstation/blob/ec3ad13bd34b64451813004e32892d49de745404/modular_gs/code/modules/atmospherics/gasmixtures/gas_types.dm) | needs-semantic-audit | Audit required |
| [modular_gs/code/modules/atmospherics/gasmixtures/reaction_factors.dm](https://github.com/sheepishgoat/GS13-Blubberstation/blob/ec3ad13bd34b64451813004e32892d49de745404/modular_gs/code/modules/atmospherics/gasmixtures/reaction_factors.dm) | needs-semantic-audit | Audit required |
| [modular_gs/code/modules/atmospherics/gasmixtures/reactions.dm](https://github.com/sheepishgoat/GS13-Blubberstation/blob/ec3ad13bd34b64451813004e32892d49de745404/modular_gs/code/modules/atmospherics/gasmixtures/reactions.dm) | needs-semantic-audit | Audit required |
| [modular_gs/code/modules/atmospherics/machinery/components/gas_recipe_machines/atmos_machine_recipes.dm](https://github.com/sheepishgoat/GS13-Blubberstation/blob/ec3ad13bd34b64451813004e32892d49de745404/modular_gs/code/modules/atmospherics/machinery/components/gas_recipe_machines/atmos_machine_recipes.dm) | needs-semantic-audit | Audit required |
| [modular_gs/code/modules/atmospherics/machinery/portable/canister.dm](https://github.com/sheepishgoat/GS13-Blubberstation/blob/ec3ad13bd34b64451813004e32892d49de745404/modular_gs/code/modules/atmospherics/machinery/portable/canister.dm) | needs-semantic-audit | Audit required |
| [modular_gs/code/modules/berry/clothing/collar.dm](https://github.com/sheepishgoat/GS13-Blubberstation/blob/ec3ad13bd34b64451813004e32892d49de745404/modular_gs/code/modules/berry/clothing/collar.dm) | needs-semantic-audit | Audit required |
| [modular_gs/code/modules/bitrunning/virtual_domain/domains/calorite_temple.dm](https://github.com/sheepishgoat/GS13-Blubberstation/blob/ec3ad13bd34b64451813004e32892d49de745404/modular_gs/code/modules/bitrunning/virtual_domain/domains/calorite_temple.dm) | needs-semantic-audit | Audit required |
| [modular_gs/code/modules/bloopers/bark_list.dm](https://github.com/sheepishgoat/GS13-Blubberstation/blob/ec3ad13bd34b64451813004e32892d49de745404/modular_gs/code/modules/bloopers/bark_list.dm) | needs-semantic-audit | Audit required |
| [modular_gs/code/modules/borg/feeding_tools.dm](https://github.com/sheepishgoat/GS13-Blubberstation/blob/ec3ad13bd34b64451813004e32892d49de745404/modular_gs/code/modules/borg/feeding_tools.dm) | partial-adapter | `code/modules/gs13/cyborg_feeding.dm` |
| [modular_gs/code/modules/cargo/exports.dm](https://github.com/sheepishgoat/GS13-Blubberstation/blob/ec3ad13bd34b64451813004e32892d49de745404/modular_gs/code/modules/cargo/exports.dm) | needs-semantic-audit | Audit required |
| [modular_gs/code/modules/cargo/packs.dm](https://github.com/sheepishgoat/GS13-Blubberstation/blob/ec3ad13bd34b64451813004e32892d49de745404/modular_gs/code/modules/cargo/packs.dm) | needs-semantic-audit | Audit required |
| [modular_gs/code/modules/cargo/packs/engineering.dm](https://github.com/sheepishgoat/GS13-Blubberstation/blob/ec3ad13bd34b64451813004e32892d49de745404/modular_gs/code/modules/cargo/packs/engineering.dm) | needs-semantic-audit | Audit required |
| [modular_gs/code/modules/cargo/packs/organic.dm](https://github.com/sheepishgoat/GS13-Blubberstation/blob/ec3ad13bd34b64451813004e32892d49de745404/modular_gs/code/modules/cargo/packs/organic.dm) | needs-semantic-audit | Audit required |
| [modular_gs/code/modules/cargo/packs/security.dm](https://github.com/sheepishgoat/GS13-Blubberstation/blob/ec3ad13bd34b64451813004e32892d49de745404/modular_gs/code/modules/cargo/packs/security.dm) | needs-semantic-audit | Audit required |
| [modular_gs/code/modules/cargo/supplypod.dm](https://github.com/sheepishgoat/GS13-Blubberstation/blob/ec3ad13bd34b64451813004e32892d49de745404/modular_gs/code/modules/cargo/supplypod.dm) | needs-semantic-audit | Audit required |
| [modular_gs/code/modules/client/preferences/cosglow_preferences.dm](https://github.com/sheepishgoat/GS13-Blubberstation/blob/ec3ad13bd34b64451813004e32892d49de745404/modular_gs/code/modules/client/preferences/cosglow_preferences.dm) | needs-semantic-audit | Audit required |
| [modular_gs/code/modules/client/preferences/erp_preferences.dm](https://github.com/sheepishgoat/GS13-Blubberstation/blob/ec3ad13bd34b64451813004e32892d49de745404/modular_gs/code/modules/client/preferences/erp_preferences.dm) | needs-semantic-audit | Audit required |
| [modular_gs/code/modules/client/preferences/fatness_preferences.dm](https://github.com/sheepishgoat/GS13-Blubberstation/blob/ec3ad13bd34b64451813004e32892d49de745404/modular_gs/code/modules/client/preferences/fatness_preferences.dm) | partial-adapter | `code/modules/gs13/preferences.dm` |
| [modular_gs/code/modules/client/preferences/flavor_text.dm](https://github.com/sheepishgoat/GS13-Blubberstation/blob/ec3ad13bd34b64451813004e32892d49de745404/modular_gs/code/modules/client/preferences/flavor_text.dm) | needs-semantic-audit | Audit required |
| [modular_gs/code/modules/client/preferences/genital_layering.dm](https://github.com/sheepishgoat/GS13-Blubberstation/blob/ec3ad13bd34b64451813004e32892d49de745404/modular_gs/code/modules/client/preferences/genital_layering.dm) | needs-semantic-audit | Audit required |
| [modular_gs/code/modules/client/preferences/genitals.dm](https://github.com/sheepishgoat/GS13-Blubberstation/blob/ec3ad13bd34b64451813004e32892d49de745404/modular_gs/code/modules/client/preferences/genitals.dm) | needs-semantic-audit | Audit required |
| [modular_gs/code/modules/client/preferences/helplessness_prefs.dm](https://github.com/sheepishgoat/GS13-Blubberstation/blob/ec3ad13bd34b64451813004e32892d49de745404/modular_gs/code/modules/client/preferences/helplessness_prefs.dm) | partial-adapter | `code/modules/gs13/preferences.dm`, `code/modules/gs13/helplessness.dm` |
| [modular_gs/code/modules/client/preferences/noise_preferences.dm](https://github.com/sheepishgoat/GS13-Blubberstation/blob/ec3ad13bd34b64451813004e32892d49de745404/modular_gs/code/modules/client/preferences/noise_preferences.dm) | needs-semantic-audit | Audit required |
| [modular_gs/code/modules/client/preferences/size.dm](https://github.com/sheepishgoat/GS13-Blubberstation/blob/ec3ad13bd34b64451813004e32892d49de745404/modular_gs/code/modules/client/preferences/size.dm) | needs-semantic-audit | Audit required |
| [modular_gs/code/modules/client/preferences/verbs.dm](https://github.com/sheepishgoat/GS13-Blubberstation/blob/ec3ad13bd34b64451813004e32892d49de745404/modular_gs/code/modules/client/preferences/verbs.dm) | needs-semantic-audit | Audit required |
| [modular_gs/code/modules/client/preferences/wg_source_preferences.dm](https://github.com/sheepishgoat/GS13-Blubberstation/blob/ec3ad13bd34b64451813004e32892d49de745404/modular_gs/code/modules/client/preferences/wg_source_preferences.dm) | partial-adapter | `code/modules/gs13/preferences.dm` |
| [modular_gs/code/modules/clothing/under/bunny_suit.dm](https://github.com/sheepishgoat/GS13-Blubberstation/blob/ec3ad13bd34b64451813004e32892d49de745404/modular_gs/code/modules/clothing/under/bunny_suit.dm) | needs-semantic-audit | Audit required |
| [modular_gs/code/modules/clothing/under/button_up.dm](https://github.com/sheepishgoat/GS13-Blubberstation/blob/ec3ad13bd34b64451813004e32892d49de745404/modular_gs/code/modules/clothing/under/button_up.dm) | needs-semantic-audit | Audit required |
| [modular_gs/code/modules/clothing/under/dual_tone_jumpsuit.dm](https://github.com/sheepishgoat/GS13-Blubberstation/blob/ec3ad13bd34b64451813004e32892d49de745404/modular_gs/code/modules/clothing/under/dual_tone_jumpsuit.dm) | needs-semantic-audit | Audit required |
| [modular_gs/code/modules/clothing/under/jobs/modular_clothing/button_up.dm](https://github.com/sheepishgoat/GS13-Blubberstation/blob/ec3ad13bd34b64451813004e32892d49de745404/modular_gs/code/modules/clothing/under/jobs/modular_clothing/button_up.dm) | needs-semantic-audit | Audit required |
| [modular_gs/code/modules/clothing/under/jobs/modular_clothing/dual_tone.dm](https://github.com/sheepishgoat/GS13-Blubberstation/blob/ec3ad13bd34b64451813004e32892d49de745404/modular_gs/code/modules/clothing/under/jobs/modular_clothing/dual_tone.dm) | needs-semantic-audit | Audit required |
| [modular_gs/code/modules/clothing/under/jobs/modular_clothing/turtleneck.dm](https://github.com/sheepishgoat/GS13-Blubberstation/blob/ec3ad13bd34b64451813004e32892d49de745404/modular_gs/code/modules/clothing/under/jobs/modular_clothing/turtleneck.dm) | needs-semantic-audit | Audit required |
| [modular_gs/code/modules/clothing/under/jobs/modular_items.dm](https://github.com/sheepishgoat/GS13-Blubberstation/blob/ec3ad13bd34b64451813004e32892d49de745404/modular_gs/code/modules/clothing/under/jobs/modular_items.dm) | needs-semantic-audit | Audit required |
| [modular_gs/code/modules/clothing/under/jobs/turtleneck.dm](https://github.com/sheepishgoat/GS13-Blubberstation/blob/ec3ad13bd34b64451813004e32892d49de745404/modular_gs/code/modules/clothing/under/jobs/turtleneck.dm) | needs-semantic-audit | Audit required |
| [modular_gs/code/modules/condos/condo_templates.dm](https://github.com/sheepishgoat/GS13-Blubberstation/blob/ec3ad13bd34b64451813004e32892d49de745404/modular_gs/code/modules/condos/condo_templates.dm) | needs-semantic-audit | Audit required |
| [modular_gs/code/modules/customization/modules/client/augment/organs.dm](https://github.com/sheepishgoat/GS13-Blubberstation/blob/ec3ad13bd34b64451813004e32892d49de745404/modular_gs/code/modules/customization/modules/client/augment/organs.dm) | needs-semantic-audit | Audit required |
| [modular_gs/code/modules/customization/modules/mob/living/carbon/human/species/hemophage/hemophage_status_effects.dm](https://github.com/sheepishgoat/GS13-Blubberstation/blob/ec3ad13bd34b64451813004e32892d49de745404/modular_gs/code/modules/customization/modules/mob/living/carbon/human/species/hemophage/hemophage_status_effects.dm) | needs-semantic-audit | Audit required |
| [modular_gs/code/modules/customization/species/proteans/organs/protean_stomach.dm](https://github.com/sheepishgoat/GS13-Blubberstation/blob/ec3ad13bd34b64451813004e32892d49de745404/modular_gs/code/modules/customization/species/proteans/organs/protean_stomach.dm) | needs-semantic-audit | Audit required |
| [modular_gs/code/modules/customization/sprite_accessories/ears.dm](https://github.com/sheepishgoat/GS13-Blubberstation/blob/ec3ad13bd34b64451813004e32892d49de745404/modular_gs/code/modules/customization/sprite_accessories/ears.dm) | needs-semantic-audit | Audit required |
| [modular_gs/code/modules/customization/sprite_accessories/frills.dm](https://github.com/sheepishgoat/GS13-Blubberstation/blob/ec3ad13bd34b64451813004e32892d49de745404/modular_gs/code/modules/customization/sprite_accessories/frills.dm) | needs-semantic-audit | Audit required |
| [modular_gs/code/modules/customization/sprite_accessories/horns.dm](https://github.com/sheepishgoat/GS13-Blubberstation/blob/ec3ad13bd34b64451813004e32892d49de745404/modular_gs/code/modules/customization/sprite_accessories/horns.dm) | needs-semantic-audit | Audit required |
| [modular_gs/code/modules/customization/sprite_accessories/tails.dm](https://github.com/sheepishgoat/GS13-Blubberstation/blob/ec3ad13bd34b64451813004e32892d49de745404/modular_gs/code/modules/customization/sprite_accessories/tails.dm) | needs-semantic-audit | Audit required |
| [modular_gs/code/modules/event_perk_redeemer/event_perk.dm](https://github.com/sheepishgoat/GS13-Blubberstation/blob/ec3ad13bd34b64451813004e32892d49de745404/modular_gs/code/modules/event_perk_redeemer/event_perk.dm) | needs-semantic-audit | Audit required |
| [modular_gs/code/modules/events/carp_infestation.dm](https://github.com/sheepishgoat/GS13-Blubberstation/blob/ec3ad13bd34b64451813004e32892d49de745404/modular_gs/code/modules/events/carp_infestation.dm) | needs-semantic-audit | Audit required |
| [modular_gs/code/modules/events/fatty_alert.dm](https://github.com/sheepishgoat/GS13-Blubberstation/blob/ec3ad13bd34b64451813004e32892d49de745404/modular_gs/code/modules/events/fatty_alert.dm) | needs-semantic-audit | Audit required |
| [modular_gs/code/modules/food_and_drinks/big_pizza.dm](https://github.com/sheepishgoat/GS13-Blubberstation/blob/ec3ad13bd34b64451813004e32892d49de745404/modular_gs/code/modules/food_and_drinks/big_pizza.dm) | needs-semantic-audit | Audit required |
| [modular_gs/code/modules/food_and_drinks/big_shake.dm](https://github.com/sheepishgoat/GS13-Blubberstation/blob/ec3ad13bd34b64451813004e32892d49de745404/modular_gs/code/modules/food_and_drinks/big_shake.dm) | needs-semantic-audit | Audit required |
| [modular_gs/code/modules/food_and_drinks/bigbottle.dm](https://github.com/sheepishgoat/GS13-Blubberstation/blob/ec3ad13bd34b64451813004e32892d49de745404/modular_gs/code/modules/food_and_drinks/bigbottle.dm) | needs-semantic-audit | Audit required |
| [modular_gs/code/modules/food_and_drinks/drinks.dm](https://github.com/sheepishgoat/GS13-Blubberstation/blob/ec3ad13bd34b64451813004e32892d49de745404/modular_gs/code/modules/food_and_drinks/drinks.dm) | needs-semantic-audit | Audit required |
| [modular_gs/code/modules/food_and_drinks/drinks/drinks/bottled_drinks.dm](https://github.com/sheepishgoat/GS13-Blubberstation/blob/ec3ad13bd34b64451813004e32892d49de745404/modular_gs/code/modules/food_and_drinks/drinks/drinks/bottled_drinks.dm) | needs-semantic-audit | Audit required |
| [modular_gs/code/modules/food_and_drinks/drinks/drinks/drink_reagents.dm](https://github.com/sheepishgoat/GS13-Blubberstation/blob/ec3ad13bd34b64451813004e32892d49de745404/modular_gs/code/modules/food_and_drinks/drinks/drinks/drink_reagents.dm) | needs-semantic-audit | Audit required |
| [modular_gs/code/modules/food_and_drinks/food.dm](https://github.com/sheepishgoat/GS13-Blubberstation/blob/ec3ad13bd34b64451813004e32892d49de745404/modular_gs/code/modules/food_and_drinks/food.dm) | needs-semantic-audit | Audit required |
| [modular_gs/code/modules/food_and_drinks/hotbar.dm](https://github.com/sheepishgoat/GS13-Blubberstation/blob/ec3ad13bd34b64451813004e32892d49de745404/modular_gs/code/modules/food_and_drinks/hotbar.dm) | needs-semantic-audit | Audit required |
| [modular_gs/code/modules/food_and_drinks/lipo_foods.dm](https://github.com/sheepishgoat/GS13-Blubberstation/blob/ec3ad13bd34b64451813004e32892d49de745404/modular_gs/code/modules/food_and_drinks/lipo_foods.dm) | needs-semantic-audit | Audit required |
| [modular_gs/code/modules/food_and_drinks/metal_food.dm](https://github.com/sheepishgoat/GS13-Blubberstation/blob/ec3ad13bd34b64451813004e32892d49de745404/modular_gs/code/modules/food_and_drinks/metal_food.dm) | needs-semantic-audit | Audit required |
| [modular_gs/code/modules/food_and_drinks/objects/candy_flora.dm](https://github.com/sheepishgoat/GS13-Blubberstation/blob/ec3ad13bd34b64451813004e32892d49de745404/modular_gs/code/modules/food_and_drinks/objects/candy_flora.dm) | needs-semantic-audit | Audit required |
| [modular_gs/code/modules/food_and_drinks/recipes/big_food.dm](https://github.com/sheepishgoat/GS13-Blubberstation/blob/ec3ad13bd34b64451813004e32892d49de745404/modular_gs/code/modules/food_and_drinks/recipes/big_food.dm) | needs-semantic-audit | Audit required |
| [modular_gs/code/modules/gym/gym.dm](https://github.com/sheepishgoat/GS13-Blubberstation/blob/ec3ad13bd34b64451813004e32892d49de745404/modular_gs/code/modules/gym/gym.dm) | needs-semantic-audit | Audit required |
| [modular_gs/code/modules/holiday/gato_founding_day.dm](https://github.com/sheepishgoat/GS13-Blubberstation/blob/ec3ad13bd34b64451813004e32892d49de745404/modular_gs/code/modules/holiday/gato_founding_day.dm) | needs-semantic-audit | Audit required |
| [modular_gs/code/modules/hud/BFI.dm](https://github.com/sheepishgoat/GS13-Blubberstation/blob/ec3ad13bd34b64451813004e32892d49de745404/modular_gs/code/modules/hud/BFI.dm) | partial-adapter | `code/modules/gs13/weight_hud.dm` |
| [modular_gs/code/modules/hud/alert.dm](https://github.com/sheepishgoat/GS13-Blubberstation/blob/ec3ad13bd34b64451813004e32892d49de745404/modular_gs/code/modules/hud/alert.dm) | partial-adapter | `code/modules/gs13/alerts.dm` |
| [modular_gs/code/modules/hydroponics/grown/berries.dm](https://github.com/sheepishgoat/GS13-Blubberstation/blob/ec3ad13bd34b64451813004e32892d49de745404/modular_gs/code/modules/hydroponics/grown/berries.dm) | needs-semantic-audit | Audit required |
| [modular_gs/code/modules/hydroponics/grown/milkmelon.dm](https://github.com/sheepishgoat/GS13-Blubberstation/blob/ec3ad13bd34b64451813004e32892d49de745404/modular_gs/code/modules/hydroponics/grown/milkmelon.dm) | partial-adapter | `code/modules/gs13/hydroponics.dm` |
| [modular_gs/code/modules/hydroponics/lipoplant.dm](https://github.com/sheepishgoat/GS13-Blubberstation/blob/ec3ad13bd34b64451813004e32892d49de745404/modular_gs/code/modules/hydroponics/lipoplant.dm) | partial-adapter | `code/modules/gs13/hydroponics.dm` |
| [modular_gs/code/modules/hydroponics/munchies_weed.dm](https://github.com/sheepishgoat/GS13-Blubberstation/blob/ec3ad13bd34b64451813004e32892d49de745404/modular_gs/code/modules/hydroponics/munchies_weed.dm) | partial-adapter | `code/modules/gs13/hydroponics.dm` |
| [modular_gs/code/modules/jobs/nanotrasen_consultant.dm](https://github.com/sheepishgoat/GS13-Blubberstation/blob/ec3ad13bd34b64451813004e32892d49de745404/modular_gs/code/modules/jobs/nanotrasen_consultant.dm) | needs-semantic-audit | Audit required |
| [modular_gs/code/modules/loadout/belt.dm](https://github.com/sheepishgoat/GS13-Blubberstation/blob/ec3ad13bd34b64451813004e32892d49de745404/modular_gs/code/modules/loadout/belt.dm) | needs-semantic-audit | Audit required |
| [modular_gs/code/modules/loadout/donator_personal.dm](https://github.com/sheepishgoat/GS13-Blubberstation/blob/ec3ad13bd34b64451813004e32892d49de745404/modular_gs/code/modules/loadout/donator_personal.dm) | needs-semantic-audit | Audit required |
| [modular_gs/code/modules/loadout/inhands.dm](https://github.com/sheepishgoat/GS13-Blubberstation/blob/ec3ad13bd34b64451813004e32892d49de745404/modular_gs/code/modules/loadout/inhands.dm) | needs-semantic-audit | Audit required |
| [modular_gs/code/modules/loadout/toys.dm](https://github.com/sheepishgoat/GS13-Blubberstation/blob/ec3ad13bd34b64451813004e32892d49de745404/modular_gs/code/modules/loadout/toys.dm) | needs-semantic-audit | Audit required |
| [modular_gs/code/modules/loadout/under.dm](https://github.com/sheepishgoat/GS13-Blubberstation/blob/ec3ad13bd34b64451813004e32892d49de745404/modular_gs/code/modules/loadout/under.dm) | needs-semantic-audit | Audit required |
| [modular_gs/code/modules/mapping/areas.dm](https://github.com/sheepishgoat/GS13-Blubberstation/blob/ec3ad13bd34b64451813004e32892d49de745404/modular_gs/code/modules/mapping/areas.dm) | needs-semantic-audit | Audit required |
| [modular_gs/code/modules/mapping/ghost_roles.dm](https://github.com/sheepishgoat/GS13-Blubberstation/blob/ec3ad13bd34b64451813004e32892d49de745404/modular_gs/code/modules/mapping/ghost_roles.dm) | needs-semantic-audit | Audit required |
| [modular_gs/code/modules/mapping/map_templates.dm](https://github.com/sheepishgoat/GS13-Blubberstation/blob/ec3ad13bd34b64451813004e32892d49de745404/modular_gs/code/modules/mapping/map_templates.dm) | needs-semantic-audit | Audit required |
| [modular_gs/code/modules/mapping/shuttles.dm](https://github.com/sheepishgoat/GS13-Blubberstation/blob/ec3ad13bd34b64451813004e32892d49de745404/modular_gs/code/modules/mapping/shuttles.dm) | needs-semantic-audit | Audit required |
| [modular_gs/code/modules/mining/ores_coins.dm](https://github.com/sheepishgoat/GS13-Blubberstation/blob/ec3ad13bd34b64451813004e32892d49de745404/modular_gs/code/modules/mining/ores_coins.dm) | needs-semantic-audit | Audit required |
| [modular_gs/code/modules/mob/dead/new_player/sprite_accessories/ears.dm](https://github.com/sheepishgoat/GS13-Blubberstation/blob/ec3ad13bd34b64451813004e32892d49de745404/modular_gs/code/modules/mob/dead/new_player/sprite_accessories/ears.dm) | needs-semantic-audit | Audit required |
| [modular_gs/code/modules/mob/dead/new_player/sprite_accessories/hair.dm](https://github.com/sheepishgoat/GS13-Blubberstation/blob/ec3ad13bd34b64451813004e32892d49de745404/modular_gs/code/modules/mob/dead/new_player/sprite_accessories/hair.dm) | needs-semantic-audit | Audit required |
| [modular_gs/code/modules/mob/dead/new_player/sprite_accessories/legs_and_taurs.dm](https://github.com/sheepishgoat/GS13-Blubberstation/blob/ec3ad13bd34b64451813004e32892d49de745404/modular_gs/code/modules/mob/dead/new_player/sprite_accessories/legs_and_taurs.dm) | needs-semantic-audit | Audit required |
| [modular_gs/code/modules/mob/living/basic/calorite_slime.dm](https://github.com/sheepishgoat/GS13-Blubberstation/blob/ec3ad13bd34b64451813004e32892d49de745404/modular_gs/code/modules/mob/living/basic/calorite_slime.dm) | needs-semantic-audit | Audit required |
| [modular_gs/code/modules/mob/living/basic/carp.dm](https://github.com/sheepishgoat/GS13-Blubberstation/blob/ec3ad13bd34b64451813004e32892d49de745404/modular_gs/code/modules/mob/living/basic/carp.dm) | needs-semantic-audit | Audit required |
| [modular_gs/code/modules/mob/living/bursting.dm](https://github.com/sheepishgoat/GS13-Blubberstation/blob/ec3ad13bd34b64451813004e32892d49de745404/modular_gs/code/modules/mob/living/bursting.dm) | needs-semantic-audit | Audit required |
| [modular_gs/code/modules/mob/living/carbon/calorite_poisoning.dm](https://github.com/sheepishgoat/GS13-Blubberstation/blob/ec3ad13bd34b64451813004e32892d49de745404/modular_gs/code/modules/mob/living/carbon/calorite_poisoning.dm) | partial-adapter | `code/modules/gs13/calorite.dm` |
| [modular_gs/code/modules/mob/living/carbon/carbon.dm](https://github.com/sheepishgoat/GS13-Blubberstation/blob/ec3ad13bd34b64451813004e32892d49de745404/modular_gs/code/modules/mob/living/carbon/carbon.dm) | needs-semantic-audit | Audit required |
| [modular_gs/code/modules/mob/living/carbon/carbon_defines.dm](https://github.com/sheepishgoat/GS13-Blubberstation/blob/ec3ad13bd34b64451813004e32892d49de745404/modular_gs/code/modules/mob/living/carbon/carbon_defines.dm) | needs-semantic-audit | Audit required |
| [modular_gs/code/modules/mob/living/carbon/carbon_stripping.dm](https://github.com/sheepishgoat/GS13-Blubberstation/blob/ec3ad13bd34b64451813004e32892d49de745404/modular_gs/code/modules/mob/living/carbon/carbon_stripping.dm) | needs-semantic-audit | Audit required |
| [modular_gs/code/modules/mob/living/carbon/examine.dm](https://github.com/sheepishgoat/GS13-Blubberstation/blob/ec3ad13bd34b64451813004e32892d49de745404/modular_gs/code/modules/mob/living/carbon/examine.dm) | partial-adapter | `code/modules/gs13/examine.dm` |
| [modular_gs/code/modules/mob/living/carbon/human/human_defines.dm](https://github.com/sheepishgoat/GS13-Blubberstation/blob/ec3ad13bd34b64451813004e32892d49de745404/modular_gs/code/modules/mob/living/carbon/human/human_defines.dm) | needs-semantic-audit | Audit required |
| [modular_gs/code/modules/mob/living/carbon/human/species_types/mootant.dm](https://github.com/sheepishgoat/GS13-Blubberstation/blob/ec3ad13bd34b64451813004e32892d49de745404/modular_gs/code/modules/mob/living/carbon/human/species_types/mootant.dm) | needs-semantic-audit | Audit required |
| [modular_gs/code/modules/mob/living/carbon/weight_helpers.dm](https://github.com/sheepishgoat/GS13-Blubberstation/blob/ec3ad13bd34b64451813004e32892d49de745404/modular_gs/code/modules/mob/living/carbon/weight_helpers.dm) | partial-adapter | `code/modules/gs13/weight.dm`, `code/modules/gs13/body_size.dm` |
| [modular_gs/code/modules/mob/living/emote.dm](https://github.com/sheepishgoat/GS13-Blubberstation/blob/ec3ad13bd34b64451813004e32892d49de745404/modular_gs/code/modules/mob/living/emote.dm) | needs-semantic-audit | Audit required |
| [modular_gs/code/modules/mob/living/fullness.dm](https://github.com/sheepishgoat/GS13-Blubberstation/blob/ec3ad13bd34b64451813004e32892d49de745404/modular_gs/code/modules/mob/living/fullness.dm) | needs-semantic-audit | Audit required |
| [modular_gs/code/modules/mob/living/genital_sprite_accessories.dm](https://github.com/sheepishgoat/GS13-Blubberstation/blob/ec3ad13bd34b64451813004e32892d49de745404/modular_gs/code/modules/mob/living/genital_sprite_accessories.dm) | needs-semantic-audit | Audit required |
| [modular_gs/code/modules/mob/living/genitals.dm](https://github.com/sheepishgoat/GS13-Blubberstation/blob/ec3ad13bd34b64451813004e32892d49de745404/modular_gs/code/modules/mob/living/genitals.dm) | needs-semantic-audit | Audit required |
| [modular_gs/code/modules/mob/living/species.dm](https://github.com/sheepishgoat/GS13-Blubberstation/blob/ec3ad13bd34b64451813004e32892d49de745404/modular_gs/code/modules/mob/living/species.dm) | needs-semantic-audit | Audit required |
| [modular_gs/code/modules/mod/mod_clothes.dm](https://github.com/sheepishgoat/GS13-Blubberstation/blob/ec3ad13bd34b64451813004e32892d49de745404/modular_gs/code/modules/mod/mod_clothes.dm) | needs-semantic-audit | Audit required |
| [modular_gs/code/modules/mod/mod_exoskeleton.dm](https://github.com/sheepishgoat/GS13-Blubberstation/blob/ec3ad13bd34b64451813004e32892d49de745404/modular_gs/code/modules/mod/mod_exoskeleton.dm) | partial-adapter | `code/modules/gs13/mod_exoskeleton.dm` |
| [modular_gs/code/modules/mod/modules/modules_fat.dm](https://github.com/sheepishgoat/GS13-Blubberstation/blob/ec3ad13bd34b64451813004e32892d49de745404/modular_gs/code/modules/mod/modules/modules_fat.dm) | partial-adapter | `code/modules/gs13/mod_modules.dm` |
| [modular_gs/code/modules/nifs/nifs.dm](https://github.com/sheepishgoat/GS13-Blubberstation/blob/ec3ad13bd34b64451813004e32892d49de745404/modular_gs/code/modules/nifs/nifs.dm) | needs-semantic-audit | Audit required |
| [modular_gs/code/modules/nifs/nifsoft_disks.dm](https://github.com/sheepishgoat/GS13-Blubberstation/blob/ec3ad13bd34b64451813004e32892d49de745404/modular_gs/code/modules/nifs/nifsoft_disks.dm) | needs-semantic-audit | Audit required |
| [modular_gs/code/modules/nifs/nifsofts/weight_display.dm](https://github.com/sheepishgoat/GS13-Blubberstation/blob/ec3ad13bd34b64451813004e32892d49de745404/modular_gs/code/modules/nifs/nifsofts/weight_display.dm) | needs-semantic-audit | Audit required |
| [modular_gs/code/modules/nifs/nifsofts/weight_watcher.dm](https://github.com/sheepishgoat/GS13-Blubberstation/blob/ec3ad13bd34b64451813004e32892d49de745404/modular_gs/code/modules/nifs/nifsofts/weight_watcher.dm) | needs-semantic-audit | Audit required |
| [modular_gs/code/modules/overwrites/research.dm](https://github.com/sheepishgoat/GS13-Blubberstation/blob/ec3ad13bd34b64451813004e32892d49de745404/modular_gs/code/modules/overwrites/research.dm) | needs-semantic-audit | Audit required |
| [modular_gs/code/modules/paperwork/paperwork.dm](https://github.com/sheepishgoat/GS13-Blubberstation/blob/ec3ad13bd34b64451813004e32892d49de745404/modular_gs/code/modules/paperwork/paperwork.dm) | needs-semantic-audit | Audit required |
| [modular_gs/code/modules/power/powerator.dm](https://github.com/sheepishgoat/GS13-Blubberstation/blob/ec3ad13bd34b64451813004e32892d49de745404/modular_gs/code/modules/power/powerator.dm) | needs-semantic-audit | Audit required |
| [modular_gs/code/modules/power/smes.dm](https://github.com/sheepishgoat/GS13-Blubberstation/blob/ec3ad13bd34b64451813004e32892d49de745404/modular_gs/code/modules/power/smes.dm) | needs-semantic-audit | Audit required |
| [modular_gs/code/modules/projectiles/projectile.dm](https://github.com/sheepishgoat/GS13-Blubberstation/blob/ec3ad13bd34b64451813004e32892d49de745404/modular_gs/code/modules/projectiles/projectile.dm) | partial-adapter | `code/modules/gs13/weapons.dm` |
| [modular_gs/code/modules/projectiles/projectiles.dm](https://github.com/sheepishgoat/GS13-Blubberstation/blob/ec3ad13bd34b64451813004e32892d49de745404/modular_gs/code/modules/projectiles/projectiles.dm) | partial-adapter | `code/modules/gs13/weapons.dm` |
| [modular_gs/code/modules/reagents/chemistry/reagents/blueberry.dm](https://github.com/sheepishgoat/GS13-Blubberstation/blob/ec3ad13bd34b64451813004e32892d49de745404/modular_gs/code/modules/reagents/chemistry/reagents/blueberry.dm) | needs-semantic-audit | Audit required |
| [modular_gs/code/modules/reagents/chemistry/reagents/consumable_reagents.dm](https://github.com/sheepishgoat/GS13-Blubberstation/blob/ec3ad13bd34b64451813004e32892d49de745404/modular_gs/code/modules/reagents/chemistry/reagents/consumable_reagents.dm) | partial-adapter | `code/modules/gs13/chemistry.dm` |
| [modular_gs/code/modules/reagents/chemistry/reagents/fatty_drinks.dm](https://github.com/sheepishgoat/GS13-Blubberstation/blob/ec3ad13bd34b64451813004e32892d49de745404/modular_gs/code/modules/reagents/chemistry/reagents/fatty_drinks.dm) | partial-adapter | `code/modules/gs13/chemistry.dm` |
| [modular_gs/code/modules/reagents/chemistry/reagents/fermi_fat.dm](https://github.com/sheepishgoat/GS13-Blubberstation/blob/ec3ad13bd34b64451813004e32892d49de745404/modular_gs/code/modules/reagents/chemistry/reagents/fermi_fat.dm) | partial-adapter | `code/modules/gs13/chemistry.dm` |
| [modular_gs/code/modules/reagents/chemistry/reagents/food_reagents.dm](https://github.com/sheepishgoat/GS13-Blubberstation/blob/ec3ad13bd34b64451813004e32892d49de745404/modular_gs/code/modules/reagents/chemistry/reagents/food_reagents.dm) | partial-adapter | `code/modules/gs13/chemistry.dm` |
| [modular_gs/code/modules/reagents/chemistry/reagents/starshine.dm](https://github.com/sheepishgoat/GS13-Blubberstation/blob/ec3ad13bd34b64451813004e32892d49de745404/modular_gs/code/modules/reagents/chemistry/reagents/starshine.dm) | needs-semantic-audit | Audit required |
| [modular_gs/code/modules/reagents/chemistry/recipes/fatchem.dm](https://github.com/sheepishgoat/GS13-Blubberstation/blob/ec3ad13bd34b64451813004e32892d49de745404/modular_gs/code/modules/reagents/chemistry/recipes/fatchem.dm) | partial-adapter | `code/modules/gs13/chemistry.dm` |
| [modular_gs/code/modules/reagents/chemistry/recipes/fatdrinks.dm](https://github.com/sheepishgoat/GS13-Blubberstation/blob/ec3ad13bd34b64451813004e32892d49de745404/modular_gs/code/modules/reagents/chemistry/recipes/fatdrinks.dm) | partial-adapter | `code/modules/gs13/chemistry.dm` |
| [modular_gs/code/modules/reagents/reagent_containers/condiment.dm](https://github.com/sheepishgoat/GS13-Blubberstation/blob/ec3ad13bd34b64451813004e32892d49de745404/modular_gs/code/modules/reagents/reagent_containers/condiment.dm) | needs-semantic-audit | Audit required |
| [modular_gs/code/modules/research/designs/autolathe.dm](https://github.com/sheepishgoat/GS13-Blubberstation/blob/ec3ad13bd34b64451813004e32892d49de745404/modular_gs/code/modules/research/designs/autolathe.dm) | needs-semantic-audit | Audit required |
| [modular_gs/code/modules/research/designs/borg.dm](https://github.com/sheepishgoat/GS13-Blubberstation/blob/ec3ad13bd34b64451813004e32892d49de745404/modular_gs/code/modules/research/designs/borg.dm) | needs-semantic-audit | Audit required |
| [modular_gs/code/modules/research/designs/designs.dm](https://github.com/sheepishgoat/GS13-Blubberstation/blob/ec3ad13bd34b64451813004e32892d49de745404/modular_gs/code/modules/research/designs/designs.dm) | needs-semantic-audit | Audit required |
| [modular_gs/code/modules/research/designs/nutri_designs/nutritech_tools_designs.dm](https://github.com/sheepishgoat/GS13-Blubberstation/blob/ec3ad13bd34b64451813004e32892d49de745404/modular_gs/code/modules/research/designs/nutri_designs/nutritech_tools_designs.dm) | needs-semantic-audit | Audit required |
| [modular_gs/code/modules/research/designs/nutri_designs/nutritech_weapon_designs.dm](https://github.com/sheepishgoat/GS13-Blubberstation/blob/ec3ad13bd34b64451813004e32892d49de745404/modular_gs/code/modules/research/designs/nutri_designs/nutritech_weapon_designs.dm) | needs-semantic-audit | Audit required |
| [modular_gs/code/modules/research/nanites/nanite_programs/fattening.dm](https://github.com/sheepishgoat/GS13-Blubberstation/blob/ec3ad13bd34b64451813004e32892d49de745404/modular_gs/code/modules/research/nanites/nanite_programs/fattening.dm) | needs-semantic-audit | Audit required |
| [modular_gs/code/modules/research/techweb/nutritech_nodes.dm](https://github.com/sheepishgoat/GS13-Blubberstation/blob/ec3ad13bd34b64451813004e32892d49de745404/modular_gs/code/modules/research/techweb/nutritech_nodes.dm) | needs-semantic-audit | Audit required |
| [modular_gs/code/modules/shuttle/shuttle_console.dm](https://github.com/sheepishgoat/GS13-Blubberstation/blob/ec3ad13bd34b64451813004e32892d49de745404/modular_gs/code/modules/shuttle/shuttle_console.dm) | needs-semantic-audit | Audit required |
| [modular_gs/code/modules/spells/spells_type/conjure/traps.dm](https://github.com/sheepishgoat/GS13-Blubberstation/blob/ec3ad13bd34b64451813004e32892d49de745404/modular_gs/code/modules/spells/spells_type/conjure/traps.dm) | partial-adapter | `code/modules/gs13/magic_traps.dm` |
| [modular_gs/code/modules/spells/spells_type/touch/add_weight.dm](https://github.com/sheepishgoat/GS13-Blubberstation/blob/ec3ad13bd34b64451813004e32892d49de745404/modular_gs/code/modules/spells/spells_type/touch/add_weight.dm) | partial-adapter | `code/modules/gs13/magic.dm` |
| [modular_gs/code/modules/storyteller/auto_storyteller_subsystem.dm](https://github.com/sheepishgoat/GS13-Blubberstation/blob/ec3ad13bd34b64451813004e32892d49de745404/modular_gs/code/modules/storyteller/auto_storyteller_subsystem.dm) | needs-semantic-audit | Audit required |
| [modular_gs/code/modules/storyteller/auto_storyteller_vote.dm](https://github.com/sheepishgoat/GS13-Blubberstation/blob/ec3ad13bd34b64451813004e32892d49de745404/modular_gs/code/modules/storyteller/auto_storyteller_vote.dm) | needs-semantic-audit | Audit required |
| [modular_gs/code/modules/storyteller/gamemode.dm](https://github.com/sheepishgoat/GS13-Blubberstation/blob/ec3ad13bd34b64451813004e32892d49de745404/modular_gs/code/modules/storyteller/gamemode.dm) | needs-semantic-audit | Audit required |
| [modular_gs/code/modules/surgery/organs/augments.dm](https://github.com/sheepishgoat/GS13-Blubberstation/blob/ec3ad13bd34b64451813004e32892d49de745404/modular_gs/code/modules/surgery/organs/augments.dm) | partial-adapter | `code/modules/gs13/nutritech_implants.dm` |
| [modular_gs/code/modules/surgery/organs/internal/lungs.dm](https://github.com/sheepishgoat/GS13-Blubberstation/blob/ec3ad13bd34b64451813004e32892d49de745404/modular_gs/code/modules/surgery/organs/internal/lungs.dm) | needs-semantic-audit | Audit required |
| [modular_gs/code/modules/surgery/organs/internal/stomach/_stomach.dm](https://github.com/sheepishgoat/GS13-Blubberstation/blob/ec3ad13bd34b64451813004e32892d49de745404/modular_gs/code/modules/surgery/organs/internal/stomach/_stomach.dm) | needs-semantic-audit | Audit required |
| [modular_gs/code/modules/surgery/organs/internal/stomach/stomach_ethereal.dm](https://github.com/sheepishgoat/GS13-Blubberstation/blob/ec3ad13bd34b64451813004e32892d49de745404/modular_gs/code/modules/surgery/organs/internal/stomach/stomach_ethereal.dm) | needs-semantic-audit | Audit required |
| [modular_gs/code/modules/taur_mechanics/taur_body.dm](https://github.com/sheepishgoat/GS13-Blubberstation/blob/ec3ad13bd34b64451813004e32892d49de745404/modular_gs/code/modules/taur_mechanics/taur_body.dm) | needs-semantic-audit | Audit required |
| [modular_gs/code/modules/uplink/uplink_items/adipowarfare.dm](https://github.com/sheepishgoat/GS13-Blubberstation/blob/ec3ad13bd34b64451813004e32892d49de745404/modular_gs/code/modules/uplink/uplink_items/adipowarfare.dm) | partial-adapter | `code/modules/gs13/weapon_distribution.dm` |
| [modular_gs/code/modules/vending/games.dm](https://github.com/sheepishgoat/GS13-Blubberstation/blob/ec3ad13bd34b64451813004e32892d49de745404/modular_gs/code/modules/vending/games.dm) | needs-semantic-audit | Audit required |
| [modular_gs/code/modules/vending/gs_vendors.dm](https://github.com/sheepishgoat/GS13-Blubberstation/blob/ec3ad13bd34b64451813004e32892d49de745404/modular_gs/code/modules/vending/gs_vendors.dm) | needs-semantic-audit | Audit required |
| [modular_gs/code/modules/vending/vending.dm](https://github.com/sheepishgoat/GS13-Blubberstation/blob/ec3ad13bd34b64451813004e32892d49de745404/modular_gs/code/modules/vending/vending.dm) | needs-semantic-audit | Audit required |
| [modular_gs/code/modules/vending/wardrobes.dm](https://github.com/sheepishgoat/GS13-Blubberstation/blob/ec3ad13bd34b64451813004e32892d49de745404/modular_gs/code/modules/vending/wardrobes.dm) | needs-semantic-audit | Audit required |
| [modular_gs/code/modules/vore/absorb_fatness.dm](https://github.com/sheepishgoat/GS13-Blubberstation/blob/ec3ad13bd34b64451813004e32892d49de745404/modular_gs/code/modules/vore/absorb_fatness.dm) | needs-semantic-audit | Audit required |
| [modular_gs/code/modules/vore/mob.dm](https://github.com/sheepishgoat/GS13-Blubberstation/blob/ec3ad13bd34b64451813004e32892d49de745404/modular_gs/code/modules/vore/mob.dm) | needs-semantic-audit | Audit required |
| [modular_gs/code/modules/vore/show_weight.dm](https://github.com/sheepishgoat/GS13-Blubberstation/blob/ec3ad13bd34b64451813004e32892d49de745404/modular_gs/code/modules/vore/show_weight.dm) | needs-semantic-audit | Audit required |
| [modular_gs/code/modules/vore/weight_gain.dm](https://github.com/sheepishgoat/GS13-Blubberstation/blob/ec3ad13bd34b64451813004e32892d49de745404/modular_gs/code/modules/vore/weight_gain.dm) | needs-semantic-audit | Audit required |
| [modular_gs/code/modules/voting/vote.dm](https://github.com/sheepishgoat/GS13-Blubberstation/blob/ec3ad13bd34b64451813004e32892d49de745404/modular_gs/code/modules/voting/vote.dm) | needs-semantic-audit | Audit required |
| [modular_gs/code/modules/weapons/grenades.dm](https://github.com/sheepishgoat/GS13-Blubberstation/blob/ec3ad13bd34b64451813004e32892d49de745404/modular_gs/code/modules/weapons/grenades.dm) | partial-adapter | `code/modules/gs13/weapon_consumables.dm` |
| [modular_gs/code/modules/weapons/magic/wand.dm](https://github.com/sheepishgoat/GS13-Blubberstation/blob/ec3ad13bd34b64451813004e32892d49de745404/modular_gs/code/modules/weapons/magic/wand.dm) | partial-adapter | `code/modules/gs13/magic.dm` |
| [modular_gs/code/modules/weighing/heft_scale.dm](https://github.com/sheepishgoat/GS13-Blubberstation/blob/ec3ad13bd34b64451813004e32892d49de745404/modular_gs/code/modules/weighing/heft_scale.dm) | needs-semantic-audit | Audit required |
| [modular_gs/code/modules/weighing/scale.dm](https://github.com/sheepishgoat/GS13-Blubberstation/blob/ec3ad13bd34b64451813004e32892d49de745404/modular_gs/code/modules/weighing/scale.dm) | needs-semantic-audit | Audit required |
| [modular_gs/code/modules/weighing/weighing_datum.dm](https://github.com/sheepishgoat/GS13-Blubberstation/blob/ec3ad13bd34b64451813004e32892d49de745404/modular_gs/code/modules/weighing/weighing_datum.dm) | needs-semantic-audit | Audit required |
| [modular_gs/code/modules/weighing/weight_scanner.dm](https://github.com/sheepishgoat/GS13-Blubberstation/blob/ec3ad13bd34b64451813004e32892d49de745404/modular_gs/code/modules/weighing/weight_scanner.dm) | needs-semantic-audit | Audit required |
| [modular_gs/code/modules/xenoarch/xenoarch_machine.dm](https://github.com/sheepishgoat/GS13-Blubberstation/blob/ec3ad13bd34b64451813004e32892d49de745404/modular_gs/code/modules/xenoarch/xenoarch_machine.dm) | needs-semantic-audit | Audit required |
| [modular_gs/code/obj/items/bluespace_belt.dm](https://github.com/sheepishgoat/GS13-Blubberstation/blob/ec3ad13bd34b64451813004e32892d49de745404/modular_gs/code/obj/items/bluespace_belt.dm) | partial-adapter | `code/modules/gs13/equipment.dm`, `code/modules/gs13/weight_hiders.dm` |
| [modular_gs/code/obj/items/gato.dm](https://github.com/sheepishgoat/GS13-Blubberstation/blob/ec3ad13bd34b64451813004e32892d49de745404/modular_gs/code/obj/items/gato.dm) | needs-semantic-audit | Audit required |
| [modular_gs/code/obj/items/incense.dm](https://github.com/sheepishgoat/GS13-Blubberstation/blob/ec3ad13bd34b64451813004e32892d49de745404/modular_gs/code/obj/items/incense.dm) | needs-semantic-audit | Audit required |
| [modular_gs/code/obj/items/memento_calori.dm](https://github.com/sheepishgoat/GS13-Blubberstation/blob/ec3ad13bd34b64451813004e32892d49de745404/modular_gs/code/obj/items/memento_calori.dm) | partial-adapter | `code/modules/gs13/memento_calori.dm` |
| [modular_gs/code/obj/items/minor_items.dm](https://github.com/sheepishgoat/GS13-Blubberstation/blob/ec3ad13bd34b64451813004e32892d49de745404/modular_gs/code/obj/items/minor_items.dm) | needs-semantic-audit | Audit required |
| [modular_gs/code/obj/items/portable_blender.dm](https://github.com/sheepishgoat/GS13-Blubberstation/blob/ec3ad13bd34b64451813004e32892d49de745404/modular_gs/code/obj/items/portable_blender.dm) | partial-adapter | `code/modules/gs13/portable_blender.dm` |
| [modular_gs/code/obj/items/tiles.dm](https://github.com/sheepishgoat/GS13-Blubberstation/blob/ec3ad13bd34b64451813004e32892d49de745404/modular_gs/code/obj/items/tiles.dm) | needs-semantic-audit | Audit required |
| [modular_gs/code/obj/structure/calorite_doors.dm](https://github.com/sheepishgoat/GS13-Blubberstation/blob/ec3ad13bd34b64451813004e32892d49de745404/modular_gs/code/obj/structure/calorite_doors.dm) | needs-semantic-audit | Audit required |
| [modular_gs/code/obj/structure/calorite_falsewall.dm](https://github.com/sheepishgoat/GS13-Blubberstation/blob/ec3ad13bd34b64451813004e32892d49de745404/modular_gs/code/obj/structure/calorite_falsewall.dm) | needs-semantic-audit | Audit required |
| [modular_gs/code/obj/structure/calorite_statues.dm](https://github.com/sheepishgoat/GS13-Blubberstation/blob/ec3ad13bd34b64451813004e32892d49de745404/modular_gs/code/obj/structure/calorite_statues.dm) | needs-semantic-audit | Audit required |
| [modular_gs/code/obj/structure/fluff_decor.dm](https://github.com/sheepishgoat/GS13-Blubberstation/blob/ec3ad13bd34b64451813004e32892d49de745404/modular_gs/code/obj/structure/fluff_decor.dm) | needs-semantic-audit | Audit required |
| [modular_gs/code/obj/structure/fountain.dm](https://github.com/sheepishgoat/GS13-Blubberstation/blob/ec3ad13bd34b64451813004e32892d49de745404/modular_gs/code/obj/structure/fountain.dm) | needs-semantic-audit | Audit required |
| [modular_gs/code/obj/structure/signs.dm](https://github.com/sheepishgoat/GS13-Blubberstation/blob/ec3ad13bd34b64451813004e32892d49de745404/modular_gs/code/obj/structure/signs.dm) | needs-semantic-audit | Audit required |
| [modular_gs/code/obj/weapons/ammo_casings.dm](https://github.com/sheepishgoat/GS13-Blubberstation/blob/ec3ad13bd34b64451813004e32892d49de745404/modular_gs/code/obj/weapons/ammo_casings.dm) | partial-adapter | `code/modules/gs13/weapons.dm` |
| [modular_gs/code/obj/weapons/caloray.dm](https://github.com/sheepishgoat/GS13-Blubberstation/blob/ec3ad13bd34b64451813004e32892d49de745404/modular_gs/code/obj/weapons/caloray.dm) | partial-adapter | `code/modules/gs13/caloray.dm` |
| [modular_gs/code/obj/weapons/energy_guns.dm](https://github.com/sheepishgoat/GS13-Blubberstation/blob/ec3ad13bd34b64451813004e32892d49de745404/modular_gs/code/obj/weapons/energy_guns.dm) | partial-adapter | `code/modules/gs13/weapons.dm` |
| [modular_gs/code/obj/weapons/feeder_ebow.dm](https://github.com/sheepishgoat/GS13-Blubberstation/blob/ec3ad13bd34b64451813004e32892d49de745404/modular_gs/code/obj/weapons/feeder_ebow.dm) | partial-adapter | `code/modules/gs13/weapon_consumables.dm` |
| [modular_gs/code/obj/weapons/melee.dm](https://github.com/sheepishgoat/GS13-Blubberstation/blob/ec3ad13bd34b64451813004e32892d49de745404/modular_gs/code/obj/weapons/melee.dm) | partial-adapter | `code/modules/gs13/melee.dm` |
| [modular_gs/code/structures/chair.dm](https://github.com/sheepishgoat/GS13-Blubberstation/blob/ec3ad13bd34b64451813004e32892d49de745404/modular_gs/code/structures/chair.dm) | needs-semantic-audit | Audit required |
| [modular_gs/code/structures/sink.dm](https://github.com/sheepishgoat/GS13-Blubberstation/blob/ec3ad13bd34b64451813004e32892d49de745404/modular_gs/code/structures/sink.dm) | needs-semantic-audit | Audit required |
| [modular_gs/code/structures/trapped_items.dm](https://github.com/sheepishgoat/GS13-Blubberstation/blob/ec3ad13bd34b64451813004e32892d49de745404/modular_gs/code/structures/trapped_items.dm) | needs-semantic-audit | Audit required |
| [modular_gs/gatofication/obj/signs.dm](https://github.com/sheepishgoat/GS13-Blubberstation/blob/ec3ad13bd34b64451813004e32892d49de745404/modular_gs/gatofication/obj/signs.dm) | needs-semantic-audit | Audit required |
| [modular_gs/modules/modular_items/code/fan.dm](https://github.com/sheepishgoat/GS13-Blubberstation/blob/ec3ad13bd34b64451813004e32892d49de745404/modular_gs/modules/modular_items/code/fan.dm) | needs-semantic-audit | Audit required |
| [modular_gs/modules/peering/code/peering.dm](https://github.com/sheepishgoat/GS13-Blubberstation/blob/ec3ad13bd34b64451813004e32892d49de745404/modular_gs/modules/peering/code/peering.dm) | needs-semantic-audit | Audit required |
| [modular_gs/modules/plumbing/plumbing_machines.dm](https://github.com/sheepishgoat/GS13-Blubberstation/blob/ec3ad13bd34b64451813004e32892d49de745404/modular_gs/modules/plumbing/plumbing_machines.dm) | needs-semantic-audit | Audit required |

## Outside-module markers

These are candidates, including comments and configuration references. The historical delta below also covers unmarked changes.

| File | Marker lines |
|---|---|
| [.github/alternate_byond_versions.txt](https://github.com/sheepishgoat/GS13-Blubberstation/blob/ec3ad13bd34b64451813004e32892d49de745404/.github/alternate_byond_versions.txt) | 10, 12 |
| [.github/workflows/check_bt_compiled.yml](https://github.com/sheepishgoat/GS13-Blubberstation/blob/ec3ad13bd34b64451813004e32892d49de745404/.github/workflows/check_bt_compiled.yml) | 14, 15, 16 |
| [.github/workflows/compile_changelogs.yml](https://github.com/sheepishgoat/GS13-Blubberstation/blob/ec3ad13bd34b64451813004e32892d49de745404/.github/workflows/compile_changelogs.yml) | 50, 56, 57, 73, 76 |
| [.tgs.yml](https://github.com/sheepishgoat/GS13-Blubberstation/blob/ec3ad13bd34b64451813004e32892d49de745404/.tgs.yml) | 6, 9 |
| [_maps/RandomRuins/SpaceRuins/GS13/GATO_FastFood.dmm](https://github.com/sheepishgoat/GS13-Blubberstation/blob/ec3ad13bd34b64451813004e32892d49de745404/_maps/RandomRuins/SpaceRuins/GS13/GATO_FastFood.dmm) | 71, 1105, 1560 |
| [_maps/_basemap.dm](https://github.com/sheepishgoat/GS13-Blubberstation/blob/ec3ad13bd34b64451813004e32892d49de745404/_maps/_basemap.dm) | 27, 29 |
| [_maps/bubber/automapper/automapper_config.toml](https://github.com/sheepishgoat/GS13-Blubberstation/blob/ec3ad13bd34b64451813004e32892d49de745404/_maps/bubber/automapper/automapper_config.toml) | 388, 459 |
| [_maps/map_files/Blueshift/Blueshift.dmm](https://github.com/sheepishgoat/GS13-Blubberstation/blob/ec3ad13bd34b64451813004e32892d49de745404/_maps/map_files/Blueshift/Blueshift.dmm) | 18538 |
| [_maps/map_files/BoxStation/BoxStation.dmm](https://github.com/sheepishgoat/GS13-Blubberstation/blob/ec3ad13bd34b64451813004e32892d49de745404/_maps/map_files/BoxStation/BoxStation.dmm) | 45206, 51241, 77927 |
| [_maps/map_files/IceBoxStation/IceBoxStation.dmm](https://github.com/sheepishgoat/GS13-Blubberstation/blob/ec3ad13bd34b64451813004e32892d49de745404/_maps/map_files/IceBoxStation/IceBoxStation.dmm) | 18803, 68525 |
| [_maps/map_files/MetaStation/MetaStation.dmm](https://github.com/sheepishgoat/GS13-Blubberstation/blob/ec3ad13bd34b64451813004e32892d49de745404/_maps/map_files/MetaStation/MetaStation.dmm) | 7453, 36051, 40190 |
| [_maps/map_files/NebulaStation/NebulaStation.dmm](https://github.com/sheepishgoat/GS13-Blubberstation/blob/ec3ad13bd34b64451813004e32892d49de745404/_maps/map_files/NebulaStation/NebulaStation.dmm) | 79304 |
| [_maps/map_files/VoidRaptor/VoidRaptor.dmm](https://github.com/sheepishgoat/GS13-Blubberstation/blob/ec3ad13bd34b64451813004e32892d49de745404/_maps/map_files/VoidRaptor/VoidRaptor.dmm) | 33201 |
| [_maps/map_files/generic/CentCom.dmm](https://github.com/sheepishgoat/GS13-Blubberstation/blob/ec3ad13bd34b64451813004e32892d49de745404/_maps/map_files/generic/CentCom.dmm) | 14304 |
| [_maps/map_files/generic/CentCom_bubber_z2.dmm](https://github.com/sheepishgoat/GS13-Blubberstation/blob/ec3ad13bd34b64451813004e32892d49de745404/_maps/map_files/generic/CentCom_bubber_z2.dmm) | 4591 |
| [_maps/map_files/gs_maps/Lavaland_Xenoarch.dmm](https://github.com/sheepishgoat/GS13-Blubberstation/blob/ec3ad13bd34b64451813004e32892d49de745404/_maps/map_files/gs_maps/Lavaland_Xenoarch.dmm) | 479, 1447, 2189, 3193, 4617, 5388, 5914, 6609, 10277, 10420, 10641, 14974 … |
| [_maps/map_files/moonstation/moonstation.dmm](https://github.com/sheepishgoat/GS13-Blubberstation/blob/ec3ad13bd34b64451813004e32892d49de745404/_maps/map_files/moonstation/moonstation.dmm) | 90101 |
| [_maps/map_files/tramstation/tramstation.dmm](https://github.com/sheepishgoat/GS13-Blubberstation/blob/ec3ad13bd34b64451813004e32892d49de745404/_maps/map_files/tramstation/tramstation.dmm) | 33436 |
| [_maps/virtual_domains/calorite_temple.dmm](https://github.com/sheepishgoat/GS13-Blubberstation/blob/ec3ad13bd34b64451813004e32892d49de745404/_maps/virtual_domains/calorite_temple.dmm) | 50, 1548, 2430 |
| [code/__DEFINES/DNA.dm](https://github.com/sheepishgoat/GS13-Blubberstation/blob/ec3ad13bd34b64451813004e32892d49de745404/code/__DEFINES/DNA.dm) | 113, 168 |
| [code/__DEFINES/atmospherics/atmos_core.dm](https://github.com/sheepishgoat/GS13-Blubberstation/blob/ec3ad13bd34b64451813004e32892d49de745404/code/__DEFINES/atmospherics/atmos_core.dm) | 52 |
| [code/__DEFINES/icon_smoothing.dm](https://github.com/sheepishgoat/GS13-Blubberstation/blob/ec3ad13bd34b64451813004e32892d49de745404/code/__DEFINES/icon_smoothing.dm) | 160, 162, 258 |
| [code/__DEFINES/id_cards.dm](https://github.com/sheepishgoat/GS13-Blubberstation/blob/ec3ad13bd34b64451813004e32892d49de745404/code/__DEFINES/id_cards.dm) | 13 |
| [code/__DEFINES/is_helpers.dm](https://github.com/sheepishgoat/GS13-Blubberstation/blob/ec3ad13bd34b64451813004e32892d49de745404/code/__DEFINES/is_helpers.dm) | 323 |
| [code/__DEFINES/maps.dm](https://github.com/sheepishgoat/GS13-Blubberstation/blob/ec3ad13bd34b64451813004e32892d49de745404/code/__DEFINES/maps.dm) | 152, 158 |
| [code/__DEFINES/mobfactions.dm](https://github.com/sheepishgoat/GS13-Blubberstation/blob/ec3ad13bd34b64451813004e32892d49de745404/code/__DEFINES/mobfactions.dm) | 155, 157 |
| [code/__DEFINES/mobs.dm](https://github.com/sheepishgoat/GS13-Blubberstation/blob/ec3ad13bd34b64451813004e32892d49de745404/code/__DEFINES/mobs.dm) | 866, 882, 891, 893, 895, 897, 898, 907, 909, 911, 913, 915 … |
| [code/__DEFINES/~skyrat_defines/lewd_defines.dm](https://github.com/sheepishgoat/GS13-Blubberstation/blob/ec3ad13bd34b64451813004e32892d49de745404/code/__DEFINES/~skyrat_defines/lewd_defines.dm) | 79, 88 |
| [code/__DEFINES/~~bubber_defines/mobs.dm](https://github.com/sheepishgoat/GS13-Blubberstation/blob/ec3ad13bd34b64451813004e32892d49de745404/code/__DEFINES/~~bubber_defines/mobs.dm) | 66 |
| [code/__DEFINES/~~bubber_defines/nanites.dm](https://github.com/sheepishgoat/GS13-Blubberstation/blob/ec3ad13bd34b64451813004e32892d49de745404/code/__DEFINES/~~bubber_defines/nanites.dm) | 73 |
| [code/__DEFINES/~~bubber_defines/storyteller_defines.dm](https://github.com/sheepishgoat/GS13-Blubberstation/blob/ec3ad13bd34b64451813004e32892d49de745404/code/__DEFINES/~~bubber_defines/storyteller_defines.dm) | 91 |
| [code/__DEFINES/~~gs_defines/preferences.dm](https://github.com/sheepishgoat/GS13-Blubberstation/blob/ec3ad13bd34b64451813004e32892d49de745404/code/__DEFINES/~~gs_defines/preferences.dm) | 11, 12 |
| [code/__DEFINES/~~gs_defines/traits.dm](https://github.com/sheepishgoat/GS13-Blubberstation/blob/ec3ad13bd34b64451813004e32892d49de745404/code/__DEFINES/~~gs_defines/traits.dm) | 1, 36, 55, 75, 83 |
| [code/__HELPERS/global_lists.dm](https://github.com/sheepishgoat/GS13-Blubberstation/blob/ec3ad13bd34b64451813004e32892d49de745404/code/__HELPERS/global_lists.dm) | 75, 78 |
| [code/__HELPERS/roundend.dm](https://github.com/sheepishgoat/GS13-Blubberstation/blob/ec3ad13bd34b64451813004e32892d49de745404/code/__HELPERS/roundend.dm) | 256, 263, 272 |
| [code/_globalvars/lists/canisters.dm](https://github.com/sheepishgoat/GS13-Blubberstation/blob/ec3ad13bd34b64451813004e32892d49de745404/code/_globalvars/lists/canisters.dm) | 29, 30 |
| [code/_globalvars/lists/ores_spawned.dm](https://github.com/sheepishgoat/GS13-Blubberstation/blob/ec3ad13bd34b64451813004e32892d49de745404/code/_globalvars/lists/ores_spawned.dm) | 20, 32 |
| [code/_globalvars/traits/_traits.dm](https://github.com/sheepishgoat/GS13-Blubberstation/blob/ec3ad13bd34b64451813004e32892d49de745404/code/_globalvars/traits/_traits.dm) | 974 |
| [code/_onclick/hud/hud.dm](https://github.com/sheepishgoat/GS13-Blubberstation/blob/ec3ad13bd34b64451813004e32892d49de745404/code/_onclick/hud/hud.dm) | 19, 20, 21 |
| [code/_onclick/hud/screen_objects/action_button.dm](https://github.com/sheepishgoat/GS13-Blubberstation/blob/ec3ad13bd34b64451813004e32892d49de745404/code/_onclick/hud/screen_objects/action_button.dm) | 319, 320, 321, 324 |
| [code/controllers/configuration/configuration.dm](https://github.com/sheepishgoat/GS13-Blubberstation/blob/ec3ad13bd34b64451813004e32892d49de745404/code/controllers/configuration/configuration.dm) | 125 |
| [code/controllers/subsystem/mapping.dm](https://github.com/sheepishgoat/GS13-Blubberstation/blob/ec3ad13bd34b64451813004e32892d49de745404/code/controllers/subsystem/mapping.dm) | 496 |
| [code/controllers/subsystem/persistence/_persistence.dm](https://github.com/sheepishgoat/GS13-Blubberstation/blob/ec3ad13bd34b64451813004e32892d49de745404/code/controllers/subsystem/persistence/_persistence.dm) | 82, 95 |
| [code/controllers/subsystem/processing/quirks.dm](https://github.com/sheepishgoat/GS13-Blubberstation/blob/ec3ad13bd34b64451813004e32892d49de745404/code/controllers/subsystem/processing/quirks.dm) | 47, 54, 60 |
| [code/controllers/subsystem/radiation.dm](https://github.com/sheepishgoat/GS13-Blubberstation/blob/ec3ad13bd34b64451813004e32892d49de745404/code/controllers/subsystem/radiation.dm) | 116, 121 |
| [code/controllers/subsystem/shuttle.dm](https://github.com/sheepishgoat/GS13-Blubberstation/blob/ec3ad13bd34b64451813004e32892d49de745404/code/controllers/subsystem/shuttle.dm) | 476 |
| [code/controllers/subsystem/ticker.dm](https://github.com/sheepishgoat/GS13-Blubberstation/blob/ec3ad13bd34b64451813004e32892d49de745404/code/controllers/subsystem/ticker.dm) | 719 |
| [code/datums/changelog/changelog.dm](https://github.com/sheepishgoat/GS13-Blubberstation/blob/ec3ad13bd34b64451813004e32892d49de745404/code/datums/changelog/changelog.dm) | 38, 39, 41, 44, 45 |
| [code/datums/components/food/edible.dm](https://github.com/sheepishgoat/GS13-Blubberstation/blob/ec3ad13bd34b64451813004e32892d49de745404/code/datums/components/food/edible.dm) | 366, 393, 399, 401, 404, 416, 420, 421, 424, 462, 463, 490 … |
| [code/datums/components/irradiated.dm](https://github.com/sheepishgoat/GS13-Blubberstation/blob/ec3ad13bd34b64451813004e32892d49de745404/code/datums/components/irradiated.dm) | 43, 49 |
| [code/datums/components/squashable.dm](https://github.com/sheepishgoat/GS13-Blubberstation/blob/ec3ad13bd34b64451813004e32892d49de745404/code/datums/components/squashable.dm) | 60 |
| [code/datums/diseases/_disease.dm](https://github.com/sheepishgoat/GS13-Blubberstation/blob/ec3ad13bd34b64451813004e32892d49de745404/code/datums/diseases/_disease.dm) | 265, 273 |
| [code/datums/elements/basic_eating.dm](https://github.com/sheepishgoat/GS13-Blubberstation/blob/ec3ad13bd34b64451813004e32892d49de745404/code/datums/elements/basic_eating.dm) | 123, 127 |
| [code/datums/quirks/negative_quirks/addict.dm](https://github.com/sheepishgoat/GS13-Blubberstation/blob/ec3ad13bd34b64451813004e32892d49de745404/code/datums/quirks/negative_quirks/addict.dm) | 16, 28, 81 |
| [code/datums/quirks/positive_quirks/voracious.dm](https://github.com/sheepishgoat/GS13-Blubberstation/blob/ec3ad13bd34b64451813004e32892d49de745404/code/datums/quirks/positive_quirks/voracious.dm) | 5 |
| [code/datums/ruins/space.dm](https://github.com/sheepishgoat/GS13-Blubberstation/blob/ec3ad13bd34b64451813004e32892d49de745404/code/datums/ruins/space.dm) | 183 |
| [code/datums/weather/weather_types/radiation_storm.dm](https://github.com/sheepishgoat/GS13-Blubberstation/blob/ec3ad13bd34b64451813004e32892d49de745404/code/datums/weather/weather_types/radiation_storm.dm) | 6, 43, 46 |
| [code/datums/wires/airlock.dm](https://github.com/sheepishgoat/GS13-Blubberstation/blob/ec3ad13bd34b64451813004e32892d49de745404/code/datums/wires/airlock.dm) | 62, 64 |
| [code/game/machinery/_machinery.dm](https://github.com/sheepishgoat/GS13-Blubberstation/blob/ec3ad13bd34b64451813004e32892d49de745404/code/game/machinery/_machinery.dm) | 459 |
| [code/game/machinery/doors/door.dm](https://github.com/sheepishgoat/GS13-Blubberstation/blob/ec3ad13bd34b64451813004e32892d49de745404/code/game/machinery/doors/door.dm) | 140, 358, 361 |
| [code/game/machinery/fat_sucker.dm](https://github.com/sheepishgoat/GS13-Blubberstation/blob/ec3ad13bd34b64451813004e32892d49de745404/code/game/machinery/fat_sucker.dm) | 11, 16, 18, 29, 31, 33, 148, 152, 155, 171 |
| [code/game/machinery/iv_drip.dm](https://github.com/sheepishgoat/GS13-Blubberstation/blob/ec3ad13bd34b64451813004e32892d49de745404/code/game/machinery/iv_drip.dm) | 47, 74, 179, 303, 319, 328 |
| [code/game/machinery/newscaster/newscaster_machine.dm](https://github.com/sheepishgoat/GS13-Blubberstation/blob/ec3ad13bd34b64451813004e32892d49de745404/code/game/machinery/newscaster/newscaster_machine.dm) | 6 |
| [code/game/machinery/quantum_pad.dm](https://github.com/sheepishgoat/GS13-Blubberstation/blob/ec3ad13bd34b64451813004e32892d49de745404/code/game/machinery/quantum_pad.dm) | 187 |
| [code/game/machinery/requests_console.dm](https://github.com/sheepishgoat/GS13-Blubberstation/blob/ec3ad13bd34b64451813004e32892d49de745404/code/game/machinery/requests_console.dm) | 16 |
| [code/game/machinery/status_display.dm](https://github.com/sheepishgoat/GS13-Blubberstation/blob/ec3ad13bd34b64451813004e32892d49de745404/code/game/machinery/status_display.dm) | 17 |
| [code/game/objects/effects/spawners/random/maintenance.dm](https://github.com/sheepishgoat/GS13-Blubberstation/blob/ec3ad13bd34b64451813004e32892d49de745404/code/game/objects/effects/spawners/random/maintenance.dm) | 66, 72 |
| [code/game/objects/effects/spawners/random/mining_loot.dm](https://github.com/sheepishgoat/GS13-Blubberstation/blob/ec3ad13bd34b64451813004e32892d49de745404/code/game/objects/effects/spawners/random/mining_loot.dm) | 27, 33 |
| [code/game/objects/effects/spawners/random/trash.dm](https://github.com/sheepishgoat/GS13-Blubberstation/blob/ec3ad13bd34b64451813004e32892d49de745404/code/game/objects/effects/spawners/random/trash.dm) | 182 |
| [code/game/objects/items.dm](https://github.com/sheepishgoat/GS13-Blubberstation/blob/ec3ad13bd34b64451813004e32892d49de745404/code/game/objects/items.dm) | 1244, 1247 |
| [code/game/objects/items/cards_ids.dm](https://github.com/sheepishgoat/GS13-Blubberstation/blob/ec3ad13bd34b64451813004e32892d49de745404/code/game/objects/items/cards_ids.dm) | 24 |
| [code/game/objects/items/charter.dm](https://github.com/sheepishgoat/GS13-Blubberstation/blob/ec3ad13bd34b64451813004e32892d49de745404/code/game/objects/items/charter.dm) | 3 |
| [code/game/objects/items/circuitboards/machines/machine_circuitboards.dm](https://github.com/sheepishgoat/GS13-Blubberstation/blob/ec3ad13bd34b64451813004e32892d49de745404/code/game/objects/items/circuitboards/machines/machine_circuitboards.dm) | 585 |
| [code/game/objects/items/devices/scanners/health_analyzer.dm](https://github.com/sheepishgoat/GS13-Blubberstation/blob/ec3ad13bd34b64451813004e32892d49de745404/code/game/objects/items/devices/scanners/health_analyzer.dm) | 291, 293 |
| [code/game/objects/items/mail.dm](https://github.com/sheepishgoat/GS13-Blubberstation/blob/ec3ad13bd34b64451813004e32892d49de745404/code/game/objects/items/mail.dm) | 95, 258, 262 |
| [code/game/objects/items/plushes.dm](https://github.com/sheepishgoat/GS13-Blubberstation/blob/ec3ad13bd34b64451813004e32892d49de745404/code/game/objects/items/plushes.dm) | 69 |
| [code/game/objects/items/rcd/RPLD.dm](https://github.com/sheepishgoat/GS13-Blubberstation/blob/ec3ad13bd34b64451813004e32892d49de745404/code/game/objects/items/rcd/RPLD.dm) | 69, 70, 71, 72 |
| [code/game/objects/items/stacks/sheets/sheet_types.dm](https://github.com/sheepishgoat/GS13-Blubberstation/blob/ec3ad13bd34b64451813004e32892d49de745404/code/game/objects/items/stacks/sheets/sheet_types.dm) | 553, 563 |
| [code/game/objects/items/storage/belt.dm](https://github.com/sheepishgoat/GS13-Blubberstation/blob/ec3ad13bd34b64451813004e32892d49de745404/code/game/objects/items/storage/belt.dm) | 68, 77 |
| [code/game/objects/items/storage/boxes/food_boxes.dm](https://github.com/sheepishgoat/GS13-Blubberstation/blob/ec3ad13bd34b64451813004e32892d49de745404/code/game/objects/items/storage/boxes/food_boxes.dm) | 56, 73, 96 |
| [code/game/objects/items/storage/fancy.dm](https://github.com/sheepishgoat/GS13-Blubberstation/blob/ec3ad13bd34b64451813004e32892d49de745404/code/game/objects/items/storage/fancy.dm) | 93, 123 |
| [code/game/objects/items/tools/medical/cane.dm](https://github.com/sheepishgoat/GS13-Blubberstation/blob/ec3ad13bd34b64451813004e32892d49de745404/code/game/objects/items/tools/medical/cane.dm) | 20, 22, 49, 51 |
| [code/game/objects/items/wiki_manuals.dm](https://github.com/sheepishgoat/GS13-Blubberstation/blob/ec3ad13bd34b64451813004e32892d49de745404/code/game/objects/items/wiki_manuals.dm) | 83, 95 |
| [code/game/objects/structures/beds_chairs/chair.dm](https://github.com/sheepishgoat/GS13-Blubberstation/blob/ec3ad13bd34b64451813004e32892d49de745404/code/game/objects/structures/beds_chairs/chair.dm) | 159 |
| [code/game/objects/structures/crates_lockers/crates/secure.dm](https://github.com/sheepishgoat/GS13-Blubberstation/blob/ec3ad13bd34b64451813004e32892d49de745404/code/game/objects/structures/crates_lockers/crates/secure.dm) | 84 |
| [code/game/objects/structures/grille.dm](https://github.com/sheepishgoat/GS13-Blubberstation/blob/ec3ad13bd34b64451813004e32892d49de745404/code/game/objects/structures/grille.dm) | 292, 295 |
| [code/game/objects/structures/gym/punching_bag.dm](https://github.com/sheepishgoat/GS13-Blubberstation/blob/ec3ad13bd34b64451813004e32892d49de745404/code/game/objects/structures/gym/punching_bag.dm) | 4, 60 |
| [code/game/objects/structures/gym/weight_machine.dm](https://github.com/sheepishgoat/GS13-Blubberstation/blob/ec3ad13bd34b64451813004e32892d49de745404/code/game/objects/structures/gym/weight_machine.dm) | 176, 179 |
| [code/game/objects/structures/lavaland/ore_vent.dm](https://github.com/sheepishgoat/GS13-Blubberstation/blob/ec3ad13bd34b64451813004e32892d49de745404/code/game/objects/structures/lavaland/ore_vent.dm) | 528, 531, 534 |
| [code/game/objects/structures/reflector.dm](https://github.com/sheepishgoat/GS13-Blubberstation/blob/ec3ad13bd34b64451813004e32892d49de745404/code/game/objects/structures/reflector.dm) | 169, 177 |
| [code/game/say.dm](https://github.com/sheepishgoat/GS13-Blubberstation/blob/ec3ad13bd34b64451813004e32892d49de745404/code/game/say.dm) | 274 |
| [code/game/turfs/closed/minerals.dm](https://github.com/sheepishgoat/GS13-Blubberstation/blob/ec3ad13bd34b64451813004e32892d49de745404/code/game/turfs/closed/minerals.dm) | 191 |
| [code/modules/admin/spawn_panel/spawn_handling.dm](https://github.com/sheepishgoat/GS13-Blubberstation/blob/ec3ad13bd34b64451813004e32892d49de745404/code/modules/admin/spawn_panel/spawn_handling.dm) | 94 |
| [code/modules/art/statues.dm](https://github.com/sheepishgoat/GS13-Blubberstation/blob/ec3ad13bd34b64451813004e32892d49de745404/code/modules/art/statues.dm) | 31, 33, 34 |
| [code/modules/asset_cache/asset_list.dm](https://github.com/sheepishgoat/GS13-Blubberstation/blob/ec3ad13bd34b64451813004e32892d49de745404/code/modules/asset_cache/asset_list.dm) | 152, 159, 166, 173 |
| [code/modules/asset_cache/assets/paper.dm](https://github.com/sheepishgoat/GS13-Blubberstation/blob/ec3ad13bd34b64451813004e32892d49de745404/code/modules/asset_cache/assets/paper.dm) | 40 |
| [code/modules/asset_cache/assets/plumbing.dm](https://github.com/sheepishgoat/GS13-Blubberstation/blob/ec3ad13bd34b64451813004e32892d49de745404/code/modules/asset_cache/assets/plumbing.dm) | 38 |
| [code/modules/asset_cache/assets/sheetmaterials.dm](https://github.com/sheepishgoat/GS13-Blubberstation/blob/ec3ad13bd34b64451813004e32892d49de745404/code/modules/asset_cache/assets/sheetmaterials.dm) | 6, 7, 8 |
| [code/modules/asset_cache/assets/supplypods.dm](https://github.com/sheepishgoat/GS13-Blubberstation/blob/ec3ad13bd34b64451813004e32892d49de745404/code/modules/asset_cache/assets/supplypods.dm) | 7, 11, 13, 17, 22, 26 |
| [code/modules/cargo/exports/large_objects.dm](https://github.com/sheepishgoat/GS13-Blubberstation/blob/ec3ad13bd34b64451813004e32892d49de745404/code/modules/cargo/exports/large_objects.dm) | 149, 150 |
| [code/modules/cargo/packs/organic.dm](https://github.com/sheepishgoat/GS13-Blubberstation/blob/ec3ad13bd34b64451813004e32892d49de745404/code/modules/cargo/packs/organic.dm) | 193 |
| [code/modules/cargo/supplypod.dm](https://github.com/sheepishgoat/GS13-Blubberstation/blob/ec3ad13bd34b64451813004e32892d49de745404/code/modules/cargo/supplypod.dm) | 6 |
| [code/modules/client/preferences.dm](https://github.com/sheepishgoat/GS13-Blubberstation/blob/ec3ad13bd34b64451813004e32892d49de745404/code/modules/client/preferences.dm) | 198 |
| [code/modules/clothing/head/hat.dm](https://github.com/sheepishgoat/GS13-Blubberstation/blob/ec3ad13bd34b64451813004e32892d49de745404/code/modules/clothing/head/hat.dm) | 288 |
| [code/modules/clothing/spacesuits/_spacesuits.dm](https://github.com/sheepishgoat/GS13-Blubberstation/blob/ec3ad13bd34b64451813004e32892d49de745404/code/modules/clothing/spacesuits/_spacesuits.dm) | 87 |
| [code/modules/clothing/spacesuits/plasmamen.dm](https://github.com/sheepishgoat/GS13-Blubberstation/blob/ec3ad13bd34b64451813004e32892d49de745404/code/modules/clothing/spacesuits/plasmamen.dm) | 463, 464, 477, 478, 485, 486 |
| [code/modules/clothing/suits/wintercoats.dm](https://github.com/sheepishgoat/GS13-Blubberstation/blob/ec3ad13bd34b64451813004e32892d49de745404/code/modules/clothing/suits/wintercoats.dm) | 547, 554, 563, 570 |
| [code/modules/clothing/under/jobs/Plasmaman/centcom.dm](https://github.com/sheepishgoat/GS13-Blubberstation/blob/ec3ad13bd34b64451813004e32892d49de745404/code/modules/clothing/under/jobs/Plasmaman/centcom.dm) | 4, 5, 12, 13, 20, 21 |
| [code/modules/clothing/under/jobs/centcom.dm](https://github.com/sheepishgoat/GS13-Blubberstation/blob/ec3ad13bd34b64451813004e32892d49de745404/code/modules/clothing/under/jobs/centcom.dm) | 10, 11 |
| [code/modules/economy/holopay.dm](https://github.com/sheepishgoat/GS13-Blubberstation/blob/ec3ad13bd34b64451813004e32892d49de745404/code/modules/economy/holopay.dm) | 80, 85, 270, 275 |
| [code/modules/events/radiation_storm.dm](https://github.com/sheepishgoat/GS13-Blubberstation/blob/ec3ad13bd34b64451813004e32892d49de745404/code/modules/events/radiation_storm.dm) | 24 |
| [code/modules/holiday/holidays.dm](https://github.com/sheepishgoat/GS13-Blubberstation/blob/ec3ad13bd34b64451813004e32892d49de745404/code/modules/holiday/holidays.dm) | 995 |
| [code/modules/hydroponics/grown/melon.dm](https://github.com/sheepishgoat/GS13-Blubberstation/blob/ec3ad13bd34b64451813004e32892d49de745404/code/modules/hydroponics/grown/melon.dm) | 73 |
| [code/modules/jobs/job_types/_job.dm](https://github.com/sheepishgoat/GS13-Blubberstation/blob/ec3ad13bd34b64451813004e32892d49de745404/code/modules/jobs/job_types/_job.dm) | 730, 732, 733 |
| [code/modules/jobs/job_types/bridge_assistant.dm](https://github.com/sheepishgoat/GS13-Blubberstation/blob/ec3ad13bd34b64451813004e32892d49de745404/code/modules/jobs/job_types/bridge_assistant.dm) | 27 |
| [code/modules/jobs/job_types/captain.dm](https://github.com/sheepishgoat/GS13-Blubberstation/blob/ec3ad13bd34b64451813004e32892d49de745404/code/modules/jobs/job_types/captain.dm) | 10, 106, 124 |
| [code/modules/jobs/job_types/chief_engineer.dm](https://github.com/sheepishgoat/GS13-Blubberstation/blob/ec3ad13bd34b64451813004e32892d49de745404/code/modules/jobs/job_types/chief_engineer.dm) | 71 |
| [code/modules/jobs/job_types/psychologist.dm](https://github.com/sheepishgoat/GS13-Blubberstation/blob/ec3ad13bd34b64451813004e32892d49de745404/code/modules/jobs/job_types/psychologist.dm) | 43, 56 |
| [code/modules/mapfluff/ruins/objects_and_mobs/sin_ruins.dm](https://github.com/sheepishgoat/GS13-Blubberstation/blob/ec3ad13bd34b64451813004e32892d49de745404/code/modules/mapfluff/ruins/objects_and_mobs/sin_ruins.dm) | 16 |
| [code/modules/mining/boulder_processing/refinery.dm](https://github.com/sheepishgoat/GS13-Blubberstation/blob/ec3ad13bd34b64451813004e32892d49de745404/code/modules/mining/boulder_processing/refinery.dm) | 53 |
| [code/modules/mining/machine_redemption.dm](https://github.com/sheepishgoat/GS13-Blubberstation/blob/ec3ad13bd34b64451813004e32892d49de745404/code/modules/mining/machine_redemption.dm) | 39 |
| [code/modules/mob/living/carbon/carbon.dm](https://github.com/sheepishgoat/GS13-Blubberstation/blob/ec3ad13bd34b64451813004e32892d49de745404/code/modules/mob/living/carbon/carbon.dm) | 1362, 1377 |
| [code/modules/mob/living/carbon/examine.dm](https://github.com/sheepishgoat/GS13-Blubberstation/blob/ec3ad13bd34b64451813004e32892d49de745404/code/modules/mob/living/carbon/examine.dm) | 155, 168 |
| [code/modules/mob/living/carbon/life.dm](https://github.com/sheepishgoat/GS13-Blubberstation/blob/ec3ad13bd34b64451813004e32892d49de745404/code/modules/mob/living/carbon/life.dm) | 24, 25 |
| [code/modules/mob/living/silicon/ai/ai_defines.dm](https://github.com/sheepishgoat/GS13-Blubberstation/blob/ec3ad13bd34b64451813004e32892d49de745404/code/modules/mob/living/silicon/ai/ai_defines.dm) | 15 |
| [code/modules/mob/mob.dm](https://github.com/sheepishgoat/GS13-Blubberstation/blob/ec3ad13bd34b64451813004e32892d49de745404/code/modules/mob/mob.dm) | 194 |
| [code/modules/mob/mob_movement.dm](https://github.com/sheepishgoat/GS13-Blubberstation/blob/ec3ad13bd34b64451813004e32892d49de745404/code/modules/mob/mob_movement.dm) | 97, 100 |
| [code/modules/mod/mod_types.dm](https://github.com/sheepishgoat/GS13-Blubberstation/blob/ec3ad13bd34b64451813004e32892d49de745404/code/modules/mod/mod_types.dm) | 128 |
| [code/modules/mod/modules/modules_general.dm](https://github.com/sheepishgoat/GS13-Blubberstation/blob/ec3ad13bd34b64451813004e32892d49de745404/code/modules/mod/modules/modules_general.dm) | 262, 264 |
| [code/modules/modular_computers/computers/machinery/modular_computer.dm](https://github.com/sheepishgoat/GS13-Blubberstation/blob/ec3ad13bd34b64451813004e32892d49de745404/code/modules/modular_computers/computers/machinery/modular_computer.dm) | 7 |
| [code/modules/paperwork/folders.dm](https://github.com/sheepishgoat/GS13-Blubberstation/blob/ec3ad13bd34b64451813004e32892d49de745404/code/modules/paperwork/folders.dm) | 4 |
| [code/modules/power/apc/apc_attack.dm](https://github.com/sheepishgoat/GS13-Blubberstation/blob/ec3ad13bd34b64451813004e32892d49de745404/code/modules/power/apc/apc_attack.dm) | 5 |
| [code/modules/power/turbine/turbine_parts.dm](https://github.com/sheepishgoat/GS13-Blubberstation/blob/ec3ad13bd34b64451813004e32892d49de745404/code/modules/power/turbine/turbine_parts.dm) | 122, 124, 126 |
| [code/modules/reagents/chemistry/reagents/atmos_gas_reagents.dm](https://github.com/sheepishgoat/GS13-Blubberstation/blob/ec3ad13bd34b64451813004e32892d49de745404/code/modules/reagents/chemistry/reagents/atmos_gas_reagents.dm) | 89 |
| [code/modules/reagents/chemistry/reagents/other_reagents.dm](https://github.com/sheepishgoat/GS13-Blubberstation/blob/ec3ad13bd34b64451813004e32892d49de745404/code/modules/reagents/chemistry/reagents/other_reagents.dm) | 358, 362 |
| [code/modules/reagents/chemistry/reagents/toxin_reagents.dm](https://github.com/sheepishgoat/GS13-Blubberstation/blob/ec3ad13bd34b64451813004e32892d49de745404/code/modules/reagents/chemistry/reagents/toxin_reagents.dm) | 1096, 1104, 1109 |
| [code/modules/reagents/reagent_containers/cups/_cup.dm](https://github.com/sheepishgoat/GS13-Blubberstation/blob/ec3ad13bd34b64451813004e32892d49de745404/code/modules/reagents/reagent_containers/cups/_cup.dm) | 118, 123, 162, 167, 172, 174, 180, 182, 191 |
| [code/modules/reagents/reagent_containers/cups/soda.dm](https://github.com/sheepishgoat/GS13-Blubberstation/blob/ec3ad13bd34b64451813004e32892d49de745404/code/modules/reagents/reagent_containers/cups/soda.dm) | 21, 96, 97, 98, 99 |
| [code/modules/reagents/reagent_containers/jerrycan.dm](https://github.com/sheepishgoat/GS13-Blubberstation/blob/ec3ad13bd34b64451813004e32892d49de745404/code/modules/reagents/reagent_containers/jerrycan.dm) | 6, 7, 170, 171 |
| [code/modules/research/designs/machine_designs.dm](https://github.com/sheepishgoat/GS13-Blubberstation/blob/ec3ad13bd34b64451813004e32892d49de745404/code/modules/research/designs/machine_designs.dm) | 742 |
| [code/modules/research/designs/medical_designs.dm](https://github.com/sheepishgoat/GS13-Blubberstation/blob/ec3ad13bd34b64451813004e32892d49de745404/code/modules/research/designs/medical_designs.dm) | 286, 298, 310, 322 |
| [code/modules/research/techweb/nodes/biology_nodes.dm](https://github.com/sheepishgoat/GS13-Blubberstation/blob/ec3ad13bd34b64451813004e32892d49de745404/code/modules/research/techweb/nodes/biology_nodes.dm) | 15, 16 |
| [code/modules/research/techweb/nodes/cyborg_nodes.dm](https://github.com/sheepishgoat/GS13-Blubberstation/blob/ec3ad13bd34b64451813004e32892d49de745404/code/modules/research/techweb/nodes/cyborg_nodes.dm) | 62 |
| [code/modules/research/techweb/nodes/engi_nodes.dm](https://github.com/sheepishgoat/GS13-Blubberstation/blob/ec3ad13bd34b64451813004e32892d49de745404/code/modules/research/techweb/nodes/engi_nodes.dm) | 159, 161 |
| [code/modules/research/techweb/nodes/medbay_nodes.dm](https://github.com/sheepishgoat/GS13-Blubberstation/blob/ec3ad13bd34b64451813004e32892d49de745404/code/modules/research/techweb/nodes/medbay_nodes.dm) | 30 |
| [code/modules/research/techweb/nodes/mining_nodes.dm](https://github.com/sheepishgoat/GS13-Blubberstation/blob/ec3ad13bd34b64451813004e32892d49de745404/code/modules/research/techweb/nodes/mining_nodes.dm) | 23 |
| [code/modules/research/techweb/nodes/modsuit_nodes.dm](https://github.com/sheepishgoat/GS13-Blubberstation/blob/ec3ad13bd34b64451813004e32892d49de745404/code/modules/research/techweb/nodes/modsuit_nodes.dm) | 20, 24 |
| [code/modules/research/techweb/nodes/robo_nodes.dm](https://github.com/sheepishgoat/GS13-Blubberstation/blob/ec3ad13bd34b64451813004e32892d49de745404/code/modules/research/techweb/nodes/robo_nodes.dm) | 10 |
| [code/modules/research/techweb/nodes/service_nodes.dm](https://github.com/sheepishgoat/GS13-Blubberstation/blob/ec3ad13bd34b64451813004e32892d49de745404/code/modules/research/techweb/nodes/service_nodes.dm) | 59 |
| [code/modules/surgery/operations/operation_lipo.dm](https://github.com/sheepishgoat/GS13-Blubberstation/blob/ec3ad13bd34b64451813004e32892d49de745404/code/modules/surgery/operations/operation_lipo.dm) | 5, 6, 16, 47, 53, 74, 83, 102 |
| [code/modules/surgery/organs/internal/cyberimp/augments_chest.dm](https://github.com/sheepishgoat/GS13-Blubberstation/blob/ec3ad13bd34b64451813004e32892d49de745404/code/modules/surgery/organs/internal/cyberimp/augments_chest.dm) | 17, 28, 34 |
| [code/modules/surgery/organs/internal/stomach/_stomach.dm](https://github.com/sheepishgoat/GS13-Blubberstation/blob/ec3ad13bd34b64451813004e32892d49de745404/code/modules/surgery/organs/internal/stomach/_stomach.dm) | 138, 155, 200, 202 |
| [code/modules/surgery/organs/internal/tongue/_tongue.dm](https://github.com/sheepishgoat/GS13-Blubberstation/blob/ec3ad13bd34b64451813004e32892d49de745404/code/modules/surgery/organs/internal/tongue/_tongue.dm) | 284, 288, 319, 321, 356, 362 |
| [code/modules/unit_tests/_unit_tests.dm](https://github.com/sheepishgoat/GS13-Blubberstation/blob/ec3ad13bd34b64451813004e32892d49de745404/code/modules/unit_tests/_unit_tests.dm) | 377, 379 |
| [code/modules/unit_tests/quirks.dm](https://github.com/sheepishgoat/GS13-Blubberstation/blob/ec3ad13bd34b64451813004e32892d49de745404/code/modules/unit_tests/quirks.dm) | 14 |
| [code/modules/unit_tests/simple_animal_freeze.dm](https://github.com/sheepishgoat/GS13-Blubberstation/blob/ec3ad13bd34b64451813004e32892d49de745404/code/modules/unit_tests/simple_animal_freeze.dm) | 76 |
| [code/modules/unit_tests/trash_food.dm](https://github.com/sheepishgoat/GS13-Blubberstation/blob/ec3ad13bd34b64451813004e32892d49de745404/code/modules/unit_tests/trash_food.dm) | 38, 40 |
| [code/modules/vending/wardrobes.dm](https://github.com/sheepishgoat/GS13-Blubberstation/blob/ec3ad13bd34b64451813004e32892d49de745404/code/modules/vending/wardrobes.dm) | 735 |
| [config/config.txt](https://github.com/sheepishgoat/GS13-Blubberstation/blob/ec3ad13bd34b64451813004e32892d49de745404/config/config.txt) | 16 |
| [html/changelogs/gs13_archive/2026-01.yml](https://github.com/sheepishgoat/GS13-Blubberstation/blob/ec3ad13bd34b64451813004e32892d49de745404/html/changelogs/gs13_archive/2026-01.yml) | 108, 110, 112, 124, 128 |
| [html/changelogs/gs13_archive/2026-07.yml](https://github.com/sheepishgoat/GS13-Blubberstation/blob/ec3ad13bd34b64451813004e32892d49de745404/html/changelogs/gs13_archive/2026-07.yml) | 9 |
| [modular_skyrat/master_files/code/datums/id_trim/jobs.dm](https://github.com/sheepishgoat/GS13-Blubberstation/blob/ec3ad13bd34b64451813004e32892d49de745404/modular_skyrat/master_files/code/datums/id_trim/jobs.dm) | 67, 69, 70 |
| [modular_skyrat/master_files/code/game/objects/items/stacks/sheets/sheet_types.dm](https://github.com/sheepishgoat/GS13-Blubberstation/blob/ec3ad13bd34b64451813004e32892d49de745404/modular_skyrat/master_files/code/game/objects/items/stacks/sheets/sheet_types.dm) | 35 |
| [modular_skyrat/master_files/code/modules/client/preferences/body_size.dm](https://github.com/sheepishgoat/GS13-Blubberstation/blob/ec3ad13bd34b64451813004e32892d49de745404/modular_skyrat/master_files/code/modules/client/preferences/body_size.dm) | 15 |
| [modular_skyrat/master_files/code/modules/mob/living/carbon/carbon_defense.dm](https://github.com/sheepishgoat/GS13-Blubberstation/blob/ec3ad13bd34b64451813004e32892d49de745404/modular_skyrat/master_files/code/modules/mob/living/carbon/carbon_defense.dm) | 6, 10 |
| [modular_skyrat/master_files/code/modules/power/thermoelectric_generator.dm](https://github.com/sheepishgoat/GS13-Blubberstation/blob/ec3ad13bd34b64451813004e32892d49de745404/modular_skyrat/master_files/code/modules/power/thermoelectric_generator.dm) | 105, 108, 111, 114 |
| [modular_skyrat/modules/aesthetics/status_display/code/status_display.dm](https://github.com/sheepishgoat/GS13-Blubberstation/blob/ec3ad13bd34b64451813004e32892d49de745404/modular_skyrat/modules/aesthetics/status_display/code/status_display.dm) | 2 |
| [modular_skyrat/modules/aesthetics/tools/code/tools.dm](https://github.com/sheepishgoat/GS13-Blubberstation/blob/ec3ad13bd34b64451813004e32892d49de745404/modular_skyrat/modules/aesthetics/tools/code/tools.dm) | 30 |
| [modular_skyrat/modules/alerts/code/default_announcer.dm](https://github.com/sheepishgoat/GS13-Blubberstation/blob/ec3ad13bd34b64451813004e32892d49de745404/modular_skyrat/modules/alerts/code/default_announcer.dm) | 2 |
| [modular_skyrat/modules/automapper/code/area_spawn_entries.dm](https://github.com/sheepishgoat/GS13-Blubberstation/blob/ec3ad13bd34b64451813004e32892d49de745404/modular_skyrat/modules/automapper/code/area_spawn_entries.dm) | 29, 55 |
| [modular_skyrat/modules/bluespace_miner/code/bluespace_miner.dm](https://github.com/sheepishgoat/GS13-Blubberstation/blob/ec3ad13bd34b64451813004e32892d49de745404/modular_skyrat/modules/bluespace_miner/code/bluespace_miner.dm) | 31 |
| [modular_skyrat/modules/borgs/code/robot_model.dm](https://github.com/sheepishgoat/GS13-Blubberstation/blob/ec3ad13bd34b64451813004e32892d49de745404/modular_skyrat/modules/borgs/code/robot_model.dm) | 43, 71, 112, 119, 167, 171, 178, 210, 215, 247, 254, 279 … |
| [modular_skyrat/modules/carriers/code/carrier_tgui.dm](https://github.com/sheepishgoat/GS13-Blubberstation/blob/ec3ad13bd34b64451813004e32892d49de745404/modular_skyrat/modules/carriers/code/carrier_tgui.dm) | 365 |
| [modular_skyrat/modules/cryosleep/code/ai.dm](https://github.com/sheepishgoat/GS13-Blubberstation/blob/ec3ad13bd34b64451813004e32892d49de745404/modular_skyrat/modules/cryosleep/code/ai.dm) | 4 |
| [modular_skyrat/modules/cryosleep/code/cryopod.dm](https://github.com/sheepishgoat/GS13-Blubberstation/blob/ec3ad13bd34b64451813004e32892d49de745404/modular_skyrat/modules/cryosleep/code/cryopod.dm) | 536 |
| [modular_skyrat/modules/customization/modules/mob/living/carbon/human/species/hemophage/hemophage_organs.dm](https://github.com/sheepishgoat/GS13-Blubberstation/blob/ec3ad13bd34b64451813004e32892d49de745404/modular_skyrat/modules/customization/modules/mob/living/carbon/human/species/hemophage/hemophage_organs.dm) | 40 |
| [modular_skyrat/modules/customization/modules/surgery/organs/genitals.dm](https://github.com/sheepishgoat/GS13-Blubberstation/blob/ec3ad13bd34b64451813004e32892d49de745404/modular_skyrat/modules/customization/modules/surgery/organs/genitals.dm) | 6, 11, 49, 547, 552 |
| [modular_skyrat/modules/emotes/code/emotes.dm](https://github.com/sheepishgoat/GS13-Blubberstation/blob/ec3ad13bd34b64451813004e32892d49de745404/modular_skyrat/modules/emotes/code/emotes.dm) | 239, 248 |
| [modular_skyrat/modules/interaction_menu/code/interaction_datum.dm](https://github.com/sheepishgoat/GS13-Blubberstation/blob/ec3ad13bd34b64451813004e32892d49de745404/modular_skyrat/modules/interaction_menu/code/interaction_datum.dm) | 58, 61 |
| [modular_skyrat/modules/lorecaster/code/archive_viewer.dm](https://github.com/sheepishgoat/GS13-Blubberstation/blob/ec3ad13bd34b64451813004e32892d49de745404/modular_skyrat/modules/lorecaster/code/archive_viewer.dm) | 3, 6, 43 |
| [modular_skyrat/modules/lorecaster/code/story_manager.dm](https://github.com/sheepishgoat/GS13-Blubberstation/blob/ec3ad13bd34b64451813004e32892d49de745404/modular_skyrat/modules/lorecaster/code/story_manager.dm) | 37 |
| [modular_skyrat/modules/lorecaster/code/subsystem.dm](https://github.com/sheepishgoat/GS13-Blubberstation/blob/ec3ad13bd34b64451813004e32892d49de745404/modular_skyrat/modules/lorecaster/code/subsystem.dm) | 10, 32 |
| [modular_skyrat/modules/mapping/code/areas/station.dm](https://github.com/sheepishgoat/GS13-Blubberstation/blob/ec3ad13bd34b64451813004e32892d49de745404/modular_skyrat/modules/mapping/code/areas/station.dm) | 30 |
| [modular_skyrat/modules/modular_implants/code/nifs.dm](https://github.com/sheepishgoat/GS13-Blubberstation/blob/ec3ad13bd34b64451813004e32892d49de745404/modular_skyrat/modules/modular_implants/code/nifs.dm) | 207, 213, 529, 532 |
| [modular_skyrat/modules/modular_implants/code/nifs_tgui.dm](https://github.com/sheepishgoat/GS13-Blubberstation/blob/ec3ad13bd34b64451813004e32892d49de745404/modular_skyrat/modules/modular_implants/code/nifs_tgui.dm) | 81, 82, 83, 158, 162 |
| [modular_skyrat/modules/modular_implants/code/nifsoft_catalog.dm](https://github.com/sheepishgoat/GS13-Blubberstation/blob/ec3ad13bd34b64451813004e32892d49de745404/modular_skyrat/modules/modular_implants/code/nifsoft_catalog.dm) | 11, 14 |
| [modular_skyrat/modules/modular_implants/code/soulcatcher/soulcatcher_mob.dm](https://github.com/sheepishgoat/GS13-Blubberstation/blob/ec3ad13bd34b64451813004e32892d49de745404/modular_skyrat/modules/modular_implants/code/soulcatcher/soulcatcher_mob.dm) | 83 |
| [modular_skyrat/modules/modular_items/lewd_items/code/lewd_helpers/pref_checking.dm](https://github.com/sheepishgoat/GS13-Blubberstation/blob/ec3ad13bd34b64451813004e32892d49de745404/modular_skyrat/modules/modular_items/lewd_items/code/lewd_helpers/pref_checking.dm) | 39, 42, 47, 50 |
| [modular_skyrat/modules/modular_items/lewd_items/code/lewd_machinery/lustwish.dm](https://github.com/sheepishgoat/GS13-Blubberstation/blob/ec3ad13bd34b64451813004e32892d49de745404/modular_skyrat/modules/modular_items/lewd_items/code/lewd_machinery/lustwish.dm) | 51 |
| [modular_skyrat/modules/modular_items/lewd_items/code/lewd_organs/breasts.dm](https://github.com/sheepishgoat/GS13-Blubberstation/blob/ec3ad13bd34b64451813004e32892d49de745404/modular_skyrat/modules/modular_items/lewd_items/code/lewd_organs/breasts.dm) | 7 |
| [modular_skyrat/modules/modular_persistence/code/modular_persistence.dm](https://github.com/sheepishgoat/GS13-Blubberstation/blob/ec3ad13bd34b64451813004e32892d49de745404/modular_skyrat/modules/modular_persistence/code/modular_persistence.dm) | 78, 90 |
| [modular_skyrat/modules/pixel_shift/code/pixel_shift_component.dm](https://github.com/sheepishgoat/GS13-Blubberstation/blob/ec3ad13bd34b64451813004e32892d49de745404/modular_skyrat/modules/pixel_shift/code/pixel_shift_component.dm) | 38 |
| [modular_skyrat/modules/primitive_catgirls/code/spawner.dm](https://github.com/sheepishgoat/GS13-Blubberstation/blob/ec3ad13bd34b64451813004e32892d49de745404/modular_skyrat/modules/primitive_catgirls/code/spawner.dm) | 25, 27 |
| [modular_skyrat/modules/quirks/neutral.dm](https://github.com/sheepishgoat/GS13-Blubberstation/blob/ec3ad13bd34b64451813004e32892d49de745404/modular_skyrat/modules/quirks/neutral.dm) | 388 |
| [modular_skyrat/modules/self_actualization_device/code/self_actualization_device.dm](https://github.com/sheepishgoat/GS13-Blubberstation/blob/ec3ad13bd34b64451813004e32892d49de745404/modular_skyrat/modules/self_actualization_device/code/self_actualization_device.dm) | 216, 218 |
| [modular_skyrat/modules/title_screen/code/_title_screen_defines.dm](https://github.com/sheepishgoat/GS13-Blubberstation/blob/ec3ad13bd34b64451813004e32892d49de745404/modular_skyrat/modules/title_screen/code/_title_screen_defines.dm) | 3, 4 |
| [modular_skyrat/modules/title_screen/code/new_player.dm](https://github.com/sheepishgoat/GS13-Blubberstation/blob/ec3ad13bd34b64451813004e32892d49de745404/modular_skyrat/modules/title_screen/code/new_player.dm) | 175 |
| [modular_skyrat/modules/title_screen/code/title_screen_html.dm](https://github.com/sheepishgoat/GS13-Blubberstation/blob/ec3ad13bd34b64451813004e32892d49de745404/modular_skyrat/modules/title_screen/code/title_screen_html.dm) | 118, 121 |
| [modular_skyrat/modules/title_screen/code/title_screen_subsystem.dm](https://github.com/sheepishgoat/GS13-Blubberstation/blob/ec3ad13bd34b64451813004e32892d49de745404/modular_skyrat/modules/title_screen/code/title_screen_subsystem.dm) | 31, 33, 34, 38, 40, 41 |
| [modular_skyrat/modules/verbs/code/looc.dm](https://github.com/sheepishgoat/GS13-Blubberstation/blob/ec3ad13bd34b64451813004e32892d49de745404/modular_skyrat/modules/verbs/code/looc.dm) | 39, 46, 80, 83 |
| [modular_skyrat/modules/xenoarch/code/modules/research/xenoarch/strange_rock.dm](https://github.com/sheepishgoat/GS13-Blubberstation/blob/ec3ad13bd34b64451813004e32892d49de745404/modular_skyrat/modules/xenoarch/code/modules/research/xenoarch/strange_rock.dm) | 226, 228, 258, 260, 279, 281, 324, 326 |
| [modular_skyrat/modules/xenoarch/code/modules/research/xenoarch/xenoarch_machine.dm](https://github.com/sheepishgoat/GS13-Blubberstation/blob/ec3ad13bd34b64451813004e32892d49de745404/modular_skyrat/modules/xenoarch/code/modules/research/xenoarch/xenoarch_machine.dm) | 153, 184, 188 |
| [modular_zubbers/code/__DEFINES/send2relay.dm](https://github.com/sheepishgoat/GS13-Blubberstation/blob/ec3ad13bd34b64451813004e32892d49de745404/modular_zubbers/code/__DEFINES/send2relay.dm) | 16, 47 |
| [modular_zubbers/code/_globalvars/lists/maintenance_loot_common.dm](https://github.com/sheepishgoat/GS13-Blubberstation/blob/ec3ad13bd34b64451813004e32892d49de745404/modular_zubbers/code/_globalvars/lists/maintenance_loot_common.dm) | 984, 989 |
| [modular_zubbers/code/controllers/subsystem/ticker.dm](https://github.com/sheepishgoat/GS13-Blubberstation/blob/ec3ad13bd34b64451813004e32892d49de745404/modular_zubbers/code/controllers/subsystem/ticker.dm) | 100, 108 |
| [modular_zubbers/code/datums/components/vore/belly.dm](https://github.com/sheepishgoat/GS13-Blubberstation/blob/ec3ad13bd34b64451813004e32892d49de745404/modular_zubbers/code/datums/components/vore/belly.dm) | 44, 48, 51, 55, 140, 143, 256, 261 |
| [modular_zubbers/code/datums/components/vore/belly_serde.dm](https://github.com/sheepishgoat/GS13-Blubberstation/blob/ec3ad13bd34b64451813004e32892d49de745404/modular_zubbers/code/datums/components/vore/belly_serde.dm) | 40, 43, 102, 105 |
| [modular_zubbers/code/datums/components/vore/digest_modes.dm](https://github.com/sheepishgoat/GS13-Blubberstation/blob/ec3ad13bd34b64451813004e32892d49de745404/modular_zubbers/code/datums/components/vore/digest_modes.dm) | 94, 155, 162, 165, 168 |
| [modular_zubbers/code/datums/quirks/neutral_quirks/aphrodisiacal_bite/aphrodisiacal_bite_quirk.dm](https://github.com/sheepishgoat/GS13-Blubberstation/blob/ec3ad13bd34b64451813004e32892d49de745404/modular_zubbers/code/datums/quirks/neutral_quirks/aphrodisiacal_bite/aphrodisiacal_bite_quirk.dm) | 39 |
| [modular_zubbers/code/datums/quirks/neutral_quirks/pet_owner.dm](https://github.com/sheepishgoat/GS13-Blubberstation/blob/ec3ad13bd34b64451813004e32892d49de745404/modular_zubbers/code/datums/quirks/neutral_quirks/pet_owner.dm) | 101, 103 |
| [modular_zubbers/code/game/objects/items/more_pkas.dm](https://github.com/sheepishgoat/GS13-Blubberstation/blob/ec3ad13bd34b64451813004e32892d49de745404/modular_zubbers/code/game/objects/items/more_pkas.dm) | 237, 243 |
| [modular_zubbers/code/modules/asset_cache/assets/tgui.dm](https://github.com/sheepishgoat/GS13-Blubberstation/blob/ec3ad13bd34b64451813004e32892d49de745404/modular_zubbers/code/modules/asset_cache/assets/tgui.dm) | 4 |
| [modular_zubbers/code/modules/client/verbs/character_directory.dm](https://github.com/sheepishgoat/GS13-Blubberstation/blob/ec3ad13bd34b64451813004e32892d49de745404/modular_zubbers/code/modules/client/verbs/character_directory.dm) | 194, 195, 196, 197, 223, 224, 225, 226, 268, 273, 295, 300 |
| [modular_zubbers/code/modules/clothing/clothing_overrides/centcom.dm](https://github.com/sheepishgoat/GS13-Blubberstation/blob/ec3ad13bd34b64451813004e32892d49de745404/modular_zubbers/code/modules/clothing/clothing_overrides/centcom.dm) | 10, 11, 12, 16, 20, 21, 22, 26, 50, 51, 52, 56 … |
| [modular_zubbers/code/modules/customization/sprite_accessories/genitals.dm](https://github.com/sheepishgoat/GS13-Blubberstation/blob/ec3ad13bd34b64451813004e32892d49de745404/modular_zubbers/code/modules/customization/sprite_accessories/genitals.dm) | 107 |
| [modular_zubbers/code/modules/events/ghost_role/blob.dm](https://github.com/sheepishgoat/GS13-Blubberstation/blob/ec3ad13bd34b64451813004e32892d49de745404/modular_zubbers/code/modules/events/ghost_role/blob.dm) | 21, 24, 27, 35 |
| [modular_zubbers/code/modules/examine_tgui/examine_tgui.dm](https://github.com/sheepishgoat/GS13-Blubberstation/blob/ec3ad13bd34b64451813004e32892d49de745404/modular_zubbers/code/modules/examine_tgui/examine_tgui.dm) | 93, 94, 95, 96, 102, 103, 104, 105 |
| [modular_zubbers/code/modules/jobs/job_types/nanotrasen_consultant.dm](https://github.com/sheepishgoat/GS13-Blubberstation/blob/ec3ad13bd34b64451813004e32892d49de745404/modular_zubbers/code/modules/jobs/job_types/nanotrasen_consultant.dm) | 4, 44, 50, 133, 134, 142, 143, 170 |
| [modular_zubbers/code/modules/jobs/job_types/psychologist.dm](https://github.com/sheepishgoat/GS13-Blubberstation/blob/ec3ad13bd34b64451813004e32892d49de745404/modular_zubbers/code/modules/jobs/job_types/psychologist.dm) | 10 |
| [modular_zubbers/code/modules/languages/vampiric.dm](https://github.com/sheepishgoat/GS13-Blubberstation/blob/ec3ad13bd34b64451813004e32892d49de745404/modular_zubbers/code/modules/languages/vampiric.dm) | 22 |
| [modular_zubbers/code/modules/nanites/techweb_nodes.dm](https://github.com/sheepishgoat/GS13-Blubberstation/blob/ec3ad13bd34b64451813004e32892d49de745404/modular_zubbers/code/modules/nanites/techweb_nodes.dm) | 40, 58, 124 |
| [modular_zubbers/code/modules/power/powerator.dm](https://github.com/sheepishgoat/GS13-Blubberstation/blob/ec3ad13bd34b64451813004e32892d49de745404/modular_zubbers/code/modules/power/powerator.dm) | 188, 192 |
| [modular_zubbers/code/modules/silicons/borgs/code/robot_model.dm](https://github.com/sheepishgoat/GS13-Blubberstation/blob/ec3ad13bd34b64451813004e32892d49de745404/modular_zubbers/code/modules/silicons/borgs/code/robot_model.dm) | 46, 58, 134, 165, 177, 184, 225, 236, 240, 242, 249, 276 … |
| [modular_zubbers/code/modules/storyteller/gamemode.dm](https://github.com/sheepishgoat/GS13-Blubberstation/blob/ec3ad13bd34b64451813004e32892d49de745404/modular_zubbers/code/modules/storyteller/gamemode.dm) | 644, 647 |
| [modular_zubbers/code/modules/tarkon/code/borg_content.dm](https://github.com/sheepishgoat/GS13-Blubberstation/blob/ec3ad13bd34b64451813004e32892d49de745404/modular_zubbers/code/modules/tarkon/code/borg_content.dm) | 88, 98 |
| [modular_zubbers/code/modules/vending/comdrobe.dm](https://github.com/sheepishgoat/GS13-Blubberstation/blob/ec3ad13bd34b64451813004e32892d49de745404/modular_zubbers/code/modules/vending/comdrobe.dm) | 297 |
| [modular_zubbers/code/modules/voting/_votes.dm](https://github.com/sheepishgoat/GS13-Blubberstation/blob/ec3ad13bd34b64451813004e32892d49de745404/modular_zubbers/code/modules/voting/_votes.dm) | 21 |
| [modular_zubbers/maps/offstation/persistence/mob_spawns.dm](https://github.com/sheepishgoat/GS13-Blubberstation/blob/ec3ad13bd34b64451813004e32892d49de745404/modular_zubbers/maps/offstation/persistence/mob_spawns.dm) | 49, 50, 51, 52, 53, 153, 155, 156 |
| [modular_zubbers/master_files/code/datums/traits/slow.dm](https://github.com/sheepishgoat/GS13-Blubberstation/blob/ec3ad13bd34b64451813004e32892d49de745404/modular_zubbers/master_files/code/datums/traits/slow.dm) | 1 |
| [modular_zubbers/modules/plexagon_selfserve/code/plexagon_selfserve.dm](https://github.com/sheepishgoat/GS13-Blubberstation/blob/ec3ad13bd34b64451813004e32892d49de745404/modular_zubbers/modules/plexagon_selfserve/code/plexagon_selfserve.dm) | 74 |
| [modular_zubbers/modules/plexagon_selfserve/code/time_clock.dm](https://github.com/sheepishgoat/GS13-Blubberstation/blob/ec3ad13bd34b64451813004e32892d49de745404/modular_zubbers/modules/plexagon_selfserve/code/time_clock.dm) | 4 |
| [modular_zubbers/modules/taur_mechanics/taur_body.dm](https://github.com/sheepishgoat/GS13-Blubberstation/blob/ec3ad13bd34b64451813004e32892d49de745404/modular_zubbers/modules/taur_mechanics/taur_body.dm) | 114, 117 |
| [tgstation.dme](https://github.com/sheepishgoat/GS13-Blubberstation/blob/ec3ad13bd34b64451813004e32892d49de745404/tgstation.dme) | 7356, 7357, 7358, 7359, 7360, 7361, 7362, 7363, 7364, 7365, 7366, 7367 … |
| [tgui/packages/tgui/constants.ts](https://github.com/sheepishgoat/GS13-Blubberstation/blob/ec3ad13bd34b64451813004e32892d49de745404/tgui/packages/tgui/constants.ts) | 327, 342 |
| [tgui/packages/tgui/interfaces/EventPerkMaker.tsx](https://github.com/sheepishgoat/GS13-Blubberstation/blob/ec3ad13bd34b64451813004e32892d49de745404/tgui/packages/tgui/interfaces/EventPerkMaker.tsx) | 1 |
| [tgui/packages/tgui/interfaces/EventPerkRedeemer.tsx](https://github.com/sheepishgoat/GS13-Blubberstation/blob/ec3ad13bd34b64451813004e32892d49de745404/tgui/packages/tgui/interfaces/EventPerkRedeemer.tsx) | 1 |
| [tgui/packages/tgui/interfaces/Fabrication/MaterialIcon.tsx](https://github.com/sheepishgoat/GS13-Blubberstation/blob/ec3ad13bd34b64451813004e32892d49de745404/tgui/packages/tgui/interfaces/Fabrication/MaterialIcon.tsx) | 56, 62 |
| [tgui/packages/tgui/interfaces/MODsuit.tsx](https://github.com/sheepishgoat/GS13-Blubberstation/blob/ec3ad13bd34b64451813004e32892d49de745404/tgui/packages/tgui/interfaces/MODsuit.tsx) | 90, 568, 672, 678 |
| [tgui/packages/tgui/interfaces/NifPanel/data.ts](https://github.com/sheepishgoat/GS13-Blubberstation/blob/ec3ad13bd34b64451813004e32892d49de745404/tgui/packages/tgui/interfaces/NifPanel/data.ts) | 29 |
| [tgui/packages/tgui/interfaces/Orbit/JobIcon.tsx](https://github.com/sheepishgoat/GS13-Blubberstation/blob/ec3ad13bd34b64451813004e32892d49de745404/tgui/packages/tgui/interfaces/Orbit/JobIcon.tsx) | 16, 56, 58, 59 |
| [tgui/packages/tgui/interfaces/Orbit/constants.ts](https://github.com/sheepishgoat/GS13-Blubberstation/blob/ec3ad13bd34b64451813004e32892d49de745404/tgui/packages/tgui/interfaces/Orbit/constants.ts) | 44 |
| [tgui/packages/tgui/interfaces/PreferencesMenu/CharacterPreferences/MainPage.tsx](https://github.com/sheepishgoat/GS13-Blubberstation/blob/ec3ad13bd34b64451813004e32892d49de745404/tgui/packages/tgui/interfaces/PreferencesMenu/CharacterPreferences/MainPage.tsx) | 537, 554, 556, 565, 566, 572, 573, 574, 575, 576, 593, 610 … |
| [tgui/packages/tgui/interfaces/PreferencesMenu/preferences/features/character_preferences/gs13/cosglow.tsx](https://github.com/sheepishgoat/GS13-Blubberstation/blob/ec3ad13bd34b64451813004e32892d49de745404/tgui/packages/tgui/interfaces/PreferencesMenu/preferences/features/character_preferences/gs13/cosglow.tsx) | 1 |
| [tgui/packages/tgui/interfaces/PreferencesMenu/types.ts](https://github.com/sheepishgoat/GS13-Blubberstation/blob/ec3ad13bd34b64451813004e32892d49de745404/tgui/packages/tgui/interfaces/PreferencesMenu/types.ts) | 215, 220, 222, 244 |
| [tgui/packages/tgui/interfaces/StripMenu.tsx](https://github.com/sheepishgoat/GS13-Blubberstation/blob/ec3ad13bd34b64451813004e32892d49de745404/tgui/packages/tgui/interfaces/StripMenu.tsx) | 120, 125 |
| [tgui/packages/tgui/interfaces/VorePanel/BellyUI.tsx](https://github.com/sheepishgoat/GS13-Blubberstation/blob/ec3ad13bd34b64451813004e32892d49de745404/tgui/packages/tgui/interfaces/VorePanel/BellyUI.tsx) | 570, 608 |
| [tgui/packages/tgui/interfaces/VorePanel/types.ts](https://github.com/sheepishgoat/GS13-Blubberstation/blob/ec3ad13bd34b64451813004e32892d49de745404/tgui/packages/tgui/interfaces/VorePanel/types.ts) | 40, 43 |
| [tools/build/build.ts](https://github.com/sheepishgoat/GS13-Blubberstation/blob/ec3ad13bd34b64451813004e32892d49de745404/tools/build/build.ts) | 204, 241 |
| [tools/pull_request_hooks/autoChangelog.js](https://github.com/sheepishgoat/GS13-Blubberstation/blob/ec3ad13bd34b64451813004e32892d49de745404/tools/pull_request_hooks/autoChangelog.js) | 38 |

## Historical changes outside modular_gs

A/M/D mean added/modified/deleted relative to the historical Bubber merge base. All require semantic review; inherited systems may also be required when unchanged in this delta.

| Change | File |
|---|---|
| M | `.github/ISSUE_TEMPLATE/feature_request.md` |
| M | `.github/alternate_byond_versions.txt` |
| M | `.github/workflows/check_bt_compiled.yml` |
| M | `.github/workflows/compile_changelogs.yml` |
| M | `.tgs.yml` |
| M | `README.md` |
| A | `_maps/RandomRuins/LavaRuins/GS13/Lavaland_Ruin_BerryAltar.dmm` |
| A | `_maps/RandomRuins/LavaRuins/GS13/Lavaland_Ruin_CaloriteShrine.dmm` |
| A | `_maps/RandomRuins/LavaRuins/GS13/Lavaland_Ruin_CaloriteShrine2.dmm` |
| A | `_maps/RandomRuins/LavaRuins/GS13/Lavaland_Ruin_CandyPocket.dmm` |
| A | `_maps/RandomRuins/LavaRuins/GS13/Lavaland_Ruin_ChocoPocket.dmm` |
| A | `_maps/RandomRuins/LavaRuins/GS13/Lavaland_Ruin_CowBarn.dmm` |
| A | `_maps/RandomRuins/LavaRuins/GS13/Lavaland_Ruin_FeederDenRuin.dmm` |
| M | `_maps/RandomRuins/LavaRuins/lavaland_surface_syndicate_base1.dmm` |
| A | `_maps/RandomRuins/SpaceRuins/GS13/GATO_FastFood.dmm` |
| A | `_maps/RandomRuins/SpaceRuins/GS13/SpaceCaloriteForge.dmm` |
| A | `_maps/RandomRuins/SpaceRuins/GS13/SpaceCandyMaze.dmm` |
| A | `_maps/RandomRuins/SpaceRuins/GS13/SpeedFucking.dmm` |
| A | `_maps/RandomRuins/SpaceRuins/spacehotel_gs.dmm` |
| M | `_maps/RandomRuins/SpaceRuins/whiteshipdock.dmm` |
| M | `_maps/_basemap.dm` |
| M | `_maps/bubber/automapper/automapper_config.toml` |
| M | `_maps/bubber/automapper/templates/Birdshot/birdshot_cryo.dmm` |
| M | `_maps/bubber/automapper/templates/Birdshot/birdshot_ntrep_office.dmm` |
| M | `_maps/bubber/automapper/templates/Deltastation/deltastation_cryo.dmm` |
| M | `_maps/bubber/automapper/templates/IceBoxStation/iceboxstation_arrivals.dmm` |
| M | `_maps/bubber/automapper/templates/IceBoxStation/iceboxstation_cryo.dmm` |
| M | `_maps/bubber/automapper/templates/IceBoxStation/iceboxstation_persistence.dmm` |
| M | `_maps/bubber/automapper/templates/IceBoxStation/iceboxstation_persistence_roof.dmm` |
| M | `_maps/bubber/automapper/templates/MetaStation/metastation_arrivals.dmm` |
| M | `_maps/bubber/automapper/templates/MetaStation/metastation_cryo.dmm` |
| M | `_maps/bubber/automapper/templates/MetaStation/metastation_ntc_bs.dmm` |
| M | `_maps/bubber/automapper/templates/NebulaStation/nebulastation_aux.dmm` |
| M | `_maps/bubber/automapper/templates/NebulaStation/nebulastation_barber.dmm` |
| M | `_maps/bubber/automapper/templates/NebulaStation/nebulastation_centcom.dmm` |
| M | `_maps/bubber/automapper/templates/NebulaStation/nebulastation_corridor.dmm` |
| M | `_maps/bubber/automapper/templates/NebulaStation/nebulastation_cryo.dmm` |
| M | `_maps/bubber/automapper/templates/centcom/centcom_ferry_dock.dmm` |
| M | `_maps/bubber/automapper/templates/lavaland/lavaland_persistence.dmm` |
| M | `_maps/bubber/automapper/templates/tramstation/tramstation_cryo.dmm` |
| M | `_maps/bubber/automapper/templates/tramstation/tramstation_ntrep_office.dmm` |
| M | `_maps/bubber/automapper/templates/wawastation/wawastation_ntrep_office.dmm` |
| M | `_maps/map_files/Blueshift/Blueshift.dmm` |
| M | `_maps/map_files/BoxStation/BoxStation.dmm` |
| M | `_maps/map_files/IceBoxStation/IceBoxStation.dmm` |
| M | `_maps/map_files/KiloStation/KiloStation.dmm` |
| M | `_maps/map_files/MetaStation/MetaStation.dmm` |
| M | `_maps/map_files/Mining/Lavaland.dmm` |
| M | `_maps/map_files/NebulaStation/NebulaStation.dmm` |
| M | `_maps/map_files/PubbyStation/PubbyStation.dmm` |
| M | `_maps/map_files/VoidRaptor/VoidRaptor.dmm` |
| M | `_maps/map_files/biodome/biodome.dmm` |
| M | `_maps/map_files/debug/multiz.dmm` |
| M | `_maps/map_files/debug/runtimestation.dmm` |
| M | `_maps/map_files/generic/CentCom.dmm` |
| M | `_maps/map_files/generic/CentCom_bubber_z2.dmm` |
| A | `_maps/map_files/gs_maps/Lavaland_Xenoarch.dmm` |
| M | `_maps/map_files/moonstation/moonstation.dmm` |
| M | `_maps/map_files/tramstation/maintenance_modules/barcargoupper_2.dmm` |
| M | `_maps/map_files/tramstation/maintenance_modules/barcargoupper_attachment_a_3.dmm` |
| M | `_maps/map_files/tramstation/maintenance_modules/dormenginelower_attachment_b_1.dmm` |
| M | `_maps/map_files/tramstation/maintenance_modules/dormmedupper_attachment_b_3.dmm` |
| M | `_maps/map_files/tramstation/maintenance_modules/medsciupper_1.dmm` |
| M | `_maps/map_files/tramstation/maintenance_modules/medsciupper_2.dmm` |
| M | `_maps/map_files/tramstation/maintenance_modules/medsciupper_3.dmm` |
| M | `_maps/map_files/tramstation/maintenance_modules/secbarupper_1.dmm` |
| M | `_maps/map_files/tramstation/maintenance_modules/secbarupper_2.dmm` |
| M | `_maps/map_files/tramstation/maintenance_modules/secbarupper_3.dmm` |
| M | `_maps/map_files/tramstation/maintenance_modules/secservicelower_1.dmm` |
| M | `_maps/map_files/tramstation/maintenance_modules/secservicelower_2.dmm` |
| M | `_maps/map_files/tramstation/maintenance_modules/secservicelower_3.dmm` |
| M | `_maps/map_files/tramstation/tramstation.dmm` |
| D | `_maps/northstar.json` |
| M | `_maps/safehouses/README.md` |
| M | `_maps/shuttles/emergency/emergency_birdshot.dmm` |
| M | `_maps/shuttles/emergency/emergency_pubby.dmm` |
| M | `_maps/shuttles/escape_pod/escape_pod_luxury.dmm` |
| A | `_maps/shuttles/gs/food_truck.dmm` |
| M | `_maps/shuttles/pirate/pirate_ex_interdyne.dmm` |
| M | `_maps/templates/lazy_templates/ninja_den.dmm` |
| A | `_maps/virtual_domains/calorite_temple.dmm` |
| A | `build/behavior_trees/modular_gs/code/mobs/feeder_mob.bt.compiled.json` |
| M | `code/__DEFINES/DNA.dm` |
| M | `code/__DEFINES/atmospherics/atmos_core.dm` |
| M | `code/__DEFINES/icon_smoothing.dm` |
| M | `code/__DEFINES/id_cards.dm` |
| M | `code/__DEFINES/is_helpers.dm` |
| M | `code/__DEFINES/maps.dm` |
| M | `code/__DEFINES/mobfactions.dm` |
| M | `code/__DEFINES/mobs.dm` |
| M | `code/__DEFINES/~skyrat_defines/lewd_defines.dm` |
| M | `code/__DEFINES/~~bubber_defines/DNA.dm` |
| M | `code/__DEFINES/~~bubber_defines/mobs.dm` |
| M | `code/__DEFINES/~~bubber_defines/nanites.dm` |
| M | `code/__DEFINES/~~bubber_defines/storyteller_defines.dm` |
| A | `code/__DEFINES/~~gs_defines/DNA.dm` |
| A | `code/__DEFINES/~~gs_defines/achievements.dm` |
| A | `code/__DEFINES/~~gs_defines/atmospherics.dm` |
| A | `code/__DEFINES/~~gs_defines/colors.dm` |
| A | `code/__DEFINES/~~gs_defines/combat.dm` |
| A | `code/__DEFINES/~~gs_defines/declarations.dm` |
| A | `code/__DEFINES/~~gs_defines/effective_weight_skip_tags.dm` |
| A | `code/__DEFINES/~~gs_defines/food.dm` |
| A | `code/__DEFINES/~~gs_defines/misc.dm` |
| A | `code/__DEFINES/~~gs_defines/mobs.dm` |
| A | `code/__DEFINES/~~gs_defines/muscle.dm` |
| A | `code/__DEFINES/~~gs_defines/nifs.dm` |
| A | `code/__DEFINES/~~gs_defines/preferences.dm` |
| A | `code/__DEFINES/~~gs_defines/signals.dm` |
| A | `code/__DEFINES/~~gs_defines/traits.dm` |
| M | `code/__HELPERS/global_lists.dm` |
| M | `code/__HELPERS/roundend.dm` |
| M | `code/_globalvars/lists/canisters.dm` |
| M | `code/_globalvars/lists/ores_spawned.dm` |
| M | `code/_globalvars/traits/_traits.dm` |
| M | `code/_onclick/hud/hud.dm` |
| M | `code/_onclick/hud/screen_objects/action_button.dm` |
| M | `code/controllers/configuration/configuration.dm` |
| M | `code/controllers/subsystem/mapping.dm` |
| M | `code/controllers/subsystem/persistence/_persistence.dm` |
| M | `code/controllers/subsystem/processing/quirks.dm` |
| M | `code/controllers/subsystem/radiation.dm` |
| M | `code/controllers/subsystem/shuttle.dm` |
| M | `code/controllers/subsystem/ticker.dm` |
| M | `code/datums/changelog/changelog.dm` |
| M | `code/datums/components/food/edible.dm` |
| M | `code/datums/components/irradiated.dm` |
| M | `code/datums/components/squashable.dm` |
| M | `code/datums/diseases/_disease.dm` |
| M | `code/datums/elements/basic_eating.dm` |
| M | `code/datums/quirks/negative_quirks/addict.dm` |
| M | `code/datums/quirks/positive_quirks/voracious.dm` |
| M | `code/datums/ruins/space.dm` |
| M | `code/datums/weather/weather_types/radiation_storm.dm` |
| M | `code/datums/wires/airlock.dm` |
| M | `code/game/machinery/_machinery.dm` |
| M | `code/game/machinery/doors/door.dm` |
| M | `code/game/machinery/fat_sucker.dm` |
| M | `code/game/machinery/iv_drip.dm` |
| M | `code/game/machinery/newscaster/newscaster_machine.dm` |
| M | `code/game/machinery/quantum_pad.dm` |
| M | `code/game/machinery/requests_console.dm` |
| M | `code/game/machinery/status_display.dm` |
| M | `code/game/objects/effects/spawners/random/mining_loot.dm` |
| M | `code/game/objects/effects/spawners/random/trash.dm` |
| M | `code/game/objects/items.dm` |
| M | `code/game/objects/items/cards_ids.dm` |
| M | `code/game/objects/items/charter.dm` |
| M | `code/game/objects/items/circuitboards/machines/machine_circuitboards.dm` |
| M | `code/game/objects/items/devices/scanners/health_analyzer.dm` |
| M | `code/game/objects/items/mail.dm` |
| M | `code/game/objects/items/plushes.dm` |
| M | `code/game/objects/items/rcd/RPLD.dm` |
| M | `code/game/objects/items/stacks/sheets/sheet_types.dm` |
| M | `code/game/objects/items/storage/belt.dm` |
| M | `code/game/objects/items/storage/boxes/food_boxes.dm` |
| M | `code/game/objects/items/storage/fancy.dm` |
| M | `code/game/objects/items/tools/medical/cane.dm` |
| M | `code/game/objects/items/wiki_manuals.dm` |
| M | `code/game/objects/structures/beds_chairs/chair.dm` |
| M | `code/game/objects/structures/crates_lockers/crates/secure.dm` |
| M | `code/game/objects/structures/grille.dm` |
| M | `code/game/objects/structures/gym/punching_bag.dm` |
| M | `code/game/objects/structures/gym/weight_machine.dm` |
| M | `code/game/objects/structures/lavaland/ore_vent.dm` |
| M | `code/game/objects/structures/reflector.dm` |
| M | `code/game/say.dm` |
| M | `code/game/turfs/closed/minerals.dm` |
| M | `code/modules/admin/spawn_panel/spawn_handling.dm` |
| M | `code/modules/art/statues.dm` |
| M | `code/modules/asset_cache/asset_list.dm` |
| M | `code/modules/asset_cache/assets/paper.dm` |
| M | `code/modules/asset_cache/assets/plumbing.dm` |
| M | `code/modules/asset_cache/assets/sheetmaterials.dm` |
| M | `code/modules/asset_cache/assets/supplypods.dm` |
| M | `code/modules/cargo/exports/large_objects.dm` |
| M | `code/modules/cargo/packs/organic.dm` |
| M | `code/modules/cargo/supplypod.dm` |
| M | `code/modules/client/preferences.dm` |
| M | `code/modules/client/preferences/middleware/keybindings.dm` |
| M | `code/modules/clothing/head/hat.dm` |
| M | `code/modules/clothing/spacesuits/_spacesuits.dm` |
| M | `code/modules/clothing/spacesuits/plasmamen.dm` |
| M | `code/modules/clothing/suits/wintercoats.dm` |
| M | `code/modules/clothing/under/jobs/Plasmaman/centcom.dm` |
| M | `code/modules/clothing/under/jobs/centcom.dm` |
| M | `code/modules/economy/holopay.dm` |
| M | `code/modules/events/radiation_storm.dm` |
| M | `code/modules/holiday/holidays.dm` |
| M | `code/modules/hydroponics/grown/melon.dm` |
| M | `code/modules/jobs/job_types/_job.dm` |
| M | `code/modules/jobs/job_types/bridge_assistant.dm` |
| M | `code/modules/jobs/job_types/captain.dm` |
| M | `code/modules/jobs/job_types/chief_engineer.dm` |
| M | `code/modules/jobs/job_types/psychologist.dm` |
| M | `code/modules/mapfluff/ruins/objects_and_mobs/sin_ruins.dm` |
| M | `code/modules/mining/boulder_processing/refinery.dm` |
| M | `code/modules/mining/machine_redemption.dm` |
| M | `code/modules/mob/living/carbon/carbon.dm` |
| M | `code/modules/mob/living/carbon/examine.dm` |
| M | `code/modules/mob/living/carbon/life.dm` |
| M | `code/modules/mob/living/silicon/ai/ai_defines.dm` |
| M | `code/modules/mob/mob.dm` |
| M | `code/modules/mob/mob_movement.dm` |
| M | `code/modules/mod/mod_types.dm` |
| M | `code/modules/mod/modules/modules_general.dm` |
| M | `code/modules/modular_computers/computers/machinery/modular_computer.dm` |
| M | `code/modules/paperwork/folders.dm` |
| M | `code/modules/power/apc/apc_attack.dm` |
| M | `code/modules/power/turbine/turbine_parts.dm` |
| M | `code/modules/reagents/chemistry/reagents/atmos_gas_reagents.dm` |
| M | `code/modules/reagents/chemistry/reagents/other_reagents.dm` |
| M | `code/modules/reagents/chemistry/reagents/toxin_reagents.dm` |
| M | `code/modules/reagents/reagent_containers/cups/_cup.dm` |
| M | `code/modules/reagents/reagent_containers/cups/soda.dm` |
| M | `code/modules/reagents/reagent_containers/jerrycan.dm` |
| M | `code/modules/research/designs/machine_designs.dm` |
| M | `code/modules/research/designs/medical_designs.dm` |
| M | `code/modules/research/techweb/nodes/biology_nodes.dm` |
| M | `code/modules/research/techweb/nodes/cyborg_nodes.dm` |
| M | `code/modules/research/techweb/nodes/engi_nodes.dm` |
| M | `code/modules/research/techweb/nodes/medbay_nodes.dm` |
| M | `code/modules/research/techweb/nodes/mining_nodes.dm` |
| M | `code/modules/research/techweb/nodes/modsuit_nodes.dm` |
| M | `code/modules/research/techweb/nodes/robo_nodes.dm` |
| M | `code/modules/research/techweb/nodes/service_nodes.dm` |
| M | `code/modules/surgery/operations/operation_lipo.dm` |
| M | `code/modules/surgery/organs/internal/cyberimp/augments_chest.dm` |
| M | `code/modules/surgery/organs/internal/stomach/_stomach.dm` |
| M | `code/modules/surgery/organs/internal/tongue/_tongue.dm` |
| M | `code/modules/tooltip/tooltip.html` |
| M | `code/modules/unit_tests/_unit_tests.dm` |
| M | `code/modules/unit_tests/create_and_destroy.dm` |
| M | `code/modules/unit_tests/quirks.dm` |
| M | `code/modules/unit_tests/simple_animal_freeze.dm` |
| M | `code/modules/unit_tests/trash_food.dm` |
| A | `code/modules/unit_tests/~gs/helplessness.dm` |
| M | `code/modules/vending/wardrobes.dm` |
| M | `config/config.txt` |
| A | `config/gs13/gatocat_prog_900px.gif` |
| A | `config/gs13/gs13_config.txt` |
| A | `config/gs13/title_style.html` |
| A | `config/reboot_themes/CitadelStationHasSeenBetterDays.ogg` |
| A | `config/reboot_themes/approachingbaystation.ogg` |
| A | `config/reboot_themes/gondolabridge.ogg` |
| A | `config/reboot_themes/haveabeautifultime.ogg` |
| A | `config/reboot_themes/itsfuckingfusing.ogg` |
| A | `config/reboot_themes/seeyoulaterokay.ogg` |
| M | `config/spaceruinblacklist.txt` |
| M | `dependencies.sh` |
| A | `html/changelogs/AutoChangeLog-pr-92513.yml` |
| A | `html/changelogs/AutoChangeLog-pr-93208.yml` |
| A | `html/changelogs/AutoChangeLog-pr-93250.yml` |
| A | `html/changelogs/AutoChangeLog-pr-93257.yml` |
| A | `html/changelogs/AutoChangeLog-pr-93259.yml` |
| A | `html/changelogs/AutoChangeLog-pr-93260.yml` |
| A | `html/changelogs/AutoChangeLog-pr-93261.yml` |
| A | `html/changelogs/AutoChangeLog-pr-93262.yml` |
| A | `html/changelogs/AutoChangeLog-pr-93263.yml` |
| A | `html/changelogs/AutoChangeLog-pr-93264.yml` |
| A | `html/changelogs/AutoChangeLog-pr-93265.yml` |
| A | `html/changelogs/gs13_archive/2025-11.yml` |
| A | `html/changelogs/gs13_archive/2025-12.yml` |
| A | `html/changelogs/gs13_archive/2026-01.yml` |
| A | `html/changelogs/gs13_archive/2026-02.yml` |
| A | `html/changelogs/gs13_archive/2026-03.yml` |
| A | `html/changelogs/gs13_archive/2026-04.yml` |
| A | `html/changelogs/gs13_archive/2026-05.yml` |
| A | `html/changelogs/gs13_archive/2026-06.yml` |
| A | `html/changelogs/gs13_archive/2026-07.yml` |
| A | `html/changelogs/gs13_archive/2026-08.yml` |
| A | `html/changelogs/gs13_archive/2026-09.yml` |
| A | `html/changelogs/gs13_archive/2026-10.yml` |
| M | `icons/map_icons/clothing/neck.dmi` |
| M | `icons/map_icons/clothing/under/_under.dmi` |
| M | `icons/map_icons/clothing/under/color.dmi` |
| M | `icons/map_icons/items/pda.dmi` |
| M | `icons/map_icons/objects.dmi` |
| M | `interface/skin.dmf` |
| M | `modular_skyrat/master_files/code/datums/id_trim/jobs.dm` |
| M | `modular_skyrat/master_files/code/game/objects/items/stacks/sheets/sheet_types.dm` |
| M | `modular_skyrat/master_files/code/modules/client/preferences/body_size.dm` |
| M | `modular_skyrat/master_files/code/modules/mob/living/carbon/carbon_defense.dm` |
| M | `modular_skyrat/master_files/code/modules/power/thermoelectric_generator.dm` |
| M | `modular_skyrat/modules/GAGS/json_configs/collar/pet_worn.json` |
| A | `modular_skyrat/modules/GAGS/json_configs/items/_umbrella.json` |
| A | `modular_skyrat/modules/GAGS/json_configs/items/_umbrella_inhand.json` |
| M | `modular_skyrat/modules/aesthetics/status_display/code/status_display.dm` |
| M | `modular_skyrat/modules/aesthetics/tools/code/tools.dm` |
| M | `modular_skyrat/modules/alerts/code/default_announcer.dm` |
| M | `modular_skyrat/modules/automapper/code/area_spawn_entries.dm` |
| M | `modular_skyrat/modules/bluespace_miner/code/bluespace_miner.dm` |
| M | `modular_skyrat/modules/borgs/code/robot_model.dm` |
| M | `modular_skyrat/modules/carriers/code/carrier_tgui.dm` |
| M | `modular_skyrat/modules/cryosleep/code/ai.dm` |
| M | `modular_skyrat/modules/cryosleep/code/cryopod.dm` |
| M | `modular_skyrat/modules/customization/modules/mob/living/carbon/human/species/hemophage/hemophage_organs.dm` |
| M | `modular_skyrat/modules/customization/modules/surgery/organs/genitals.dm` |
| M | `modular_skyrat/modules/emotes/code/emotes.dm` |
| M | `modular_skyrat/modules/interaction_menu/code/interaction_datum.dm` |
| M | `modular_skyrat/modules/lorecaster/code/archive_viewer.dm` |
| M | `modular_skyrat/modules/lorecaster/code/story_manager.dm` |
| M | `modular_skyrat/modules/lorecaster/code/subsystem.dm` |
| M | `modular_skyrat/modules/mapping/code/areas/station.dm` |
| M | `modular_skyrat/modules/modular_implants/code/nifs.dm` |
| M | `modular_skyrat/modules/modular_implants/code/nifs_tgui.dm` |
| M | `modular_skyrat/modules/modular_implants/code/nifsoft_catalog.dm` |
| M | `modular_skyrat/modules/modular_implants/code/soulcatcher/soulcatcher_mob.dm` |
| M | `modular_skyrat/modules/modular_items/lewd_items/code/lewd_helpers/pref_checking.dm` |
| M | `modular_skyrat/modules/modular_items/lewd_items/code/lewd_machinery/lustwish.dm` |
| M | `modular_skyrat/modules/modular_items/lewd_items/code/lewd_organs/breasts.dm` |
| M | `modular_skyrat/modules/modular_persistence/code/modular_persistence.dm` |
| M | `modular_skyrat/modules/pixel_shift/code/pixel_shift_component.dm` |
| M | `modular_skyrat/modules/primitive_catgirls/code/spawner.dm` |
| M | `modular_skyrat/modules/quirks/neutral.dm` |
| M | `modular_skyrat/modules/self_actualization_device/code/self_actualization_device.dm` |
| M | `modular_skyrat/modules/title_screen/code/_title_screen_defines.dm` |
| M | `modular_skyrat/modules/title_screen/code/new_player.dm` |
| M | `modular_skyrat/modules/title_screen/code/title_screen_html.dm` |
| M | `modular_skyrat/modules/title_screen/code/title_screen_subsystem.dm` |
| M | `modular_skyrat/modules/verbs/code/looc.dm` |
| M | `modular_skyrat/modules/xenoarch/code/modules/research/xenoarch/strange_rock.dm` |
| M | `modular_skyrat/modules/xenoarch/code/modules/research/xenoarch/xenoarch_machine.dm` |
| M | `modular_zubbers/code/__DEFINES/send2relay.dm` |
| M | `modular_zubbers/code/_globalvars/lists/maintenance_loot_common.dm` |
| M | `modular_zubbers/code/controllers/subsystem/ticker.dm` |
| M | `modular_zubbers/code/datums/components/vore/belly.dm` |
| M | `modular_zubbers/code/datums/components/vore/belly_serde.dm` |
| M | `modular_zubbers/code/datums/components/vore/digest_modes.dm` |
| M | `modular_zubbers/code/datums/quirks/neutral_quirks/aphrodisiacal_bite/aphrodisiacal_bite_quirk.dm` |
| M | `modular_zubbers/code/datums/quirks/neutral_quirks/pet_owner.dm` |
| M | `modular_zubbers/code/game/machinery/crew_monitor.dm` |
| M | `modular_zubbers/code/game/objects/items/more_pkas.dm` |
| M | `modular_zubbers/code/modules/asset_cache/assets/tgui.dm` |
| M | `modular_zubbers/code/modules/client/verbs/character_directory.dm` |
| M | `modular_zubbers/code/modules/clothing/clothing_overrides/centcom.dm` |
| M | `modular_zubbers/code/modules/condos/_maps/apartment_dragonslair.dmm` |
| M | `modular_zubbers/code/modules/condos/_maps/apartment_mountainside.dmm` |
| M | `modular_zubbers/code/modules/condos/_maps/cinema.dmm` |
| M | `modular_zubbers/code/modules/condos/_maps/corporateoffice.dmm` |
| M | `modular_zubbers/code/modules/condos/_maps/foxbar.dmm` |
| M | `modular_zubbers/code/modules/condos/_maps/hilbertshotel.dmm` |
| M | `modular_zubbers/code/modules/condos/_maps/ship_bridge.dmm` |
| M | `modular_zubbers/code/modules/customization/sprite_accessories/genitals.dm` |
| M | `modular_zubbers/code/modules/events/ghost_role/blob.dm` |
| M | `modular_zubbers/code/modules/examine_tgui/examine_tgui.dm` |
| M | `modular_zubbers/code/modules/jobs/job_types/nanotrasen_consultant.dm` |
| M | `modular_zubbers/code/modules/jobs/job_types/psychologist.dm` |
| M | `modular_zubbers/code/modules/languages/vampiric.dm` |
| M | `modular_zubbers/code/modules/nanites/techweb_nodes.dm` |
| M | `modular_zubbers/code/modules/power/powerator.dm` |
| M | `modular_zubbers/code/modules/silicons/borgs/code/robot_model.dm` |
| M | `modular_zubbers/code/modules/storyteller/gamemode.dm` |
| M | `modular_zubbers/code/modules/tarkon/code/borg_content.dm` |
| M | `modular_zubbers/code/modules/vending/comdrobe.dm` |
| M | `modular_zubbers/code/modules/voting/_votes.dm` |
| A | `modular_zubbers/icons/hud/screen_pai.dmi` |
| A | `modular_zubbers/icons/mob/clothing/feet.dmi` |
| A | `modular_zubbers/icons/obj/clothing/head/glasses.dmi` |
| A | `modular_zubbers/icons/obj/clothing/shoes.dmi` |
| A | `modular_zubbers/icons/obj/machines/multisec.dmi` |
| M | `modular_zubbers/maps/offstation/persistence/mob_spawns.dm` |
| M | `modular_zubbers/master_files/code/datums/traits/slow.dm` |
| M | `modular_zubbers/modules/plexagon_selfserve/code/plexagon_selfserve.dm` |
| M | `modular_zubbers/modules/plexagon_selfserve/code/time_clock.dm` |
| M | `modular_zubbers/modules/taur_mechanics/taur_body.dm` |
| A | `strings/gs_slurring_burp_text.json` |
| M | `strings/quote_of_the_round.json` |
| M | `tgstation.dme` |
| M | `tgui/packages/tgui/constants.ts` |
| M | `tgui/packages/tgui/interfaces/AiAirlock.jsx` |
| A | `tgui/packages/tgui/interfaces/BluespaceBelt.jsx` |
| M | `tgui/packages/tgui/interfaces/BubberChangelog.jsx` |
| M | `tgui/packages/tgui/interfaces/CrewManifest.jsx` |
| A | `tgui/packages/tgui/interfaces/EventPerkMaker.tsx` |
| A | `tgui/packages/tgui/interfaces/EventPerkRedeemer.tsx` |
| M | `tgui/packages/tgui/interfaces/Fabrication/MaterialIcon.tsx` |
| M | `tgui/packages/tgui/interfaces/MODsuit.tsx` |
| M | `tgui/packages/tgui/interfaces/NifPanel/NifSettings.tsx` |
| M | `tgui/packages/tgui/interfaces/NifPanel/NifStats.tsx` |
| M | `tgui/packages/tgui/interfaces/NifPanel/data.ts` |
| M | `tgui/packages/tgui/interfaces/Orbit/JobIcon.tsx` |
| M | `tgui/packages/tgui/interfaces/Orbit/constants.ts` |
| M | `tgui/packages/tgui/interfaces/PreferencesMenu/CharacterPreferences/MainPage.tsx` |
| A | `tgui/packages/tgui/interfaces/PreferencesMenu/antagonists/antagonists/hereticsmuggler.ts` |
| A | `tgui/packages/tgui/interfaces/PreferencesMenu/preferences/features/character_preferences/gs13/cosglow.tsx` |
| A | `tgui/packages/tgui/interfaces/PreferencesMenu/preferences/features/character_preferences/gs13/fatness.tsx` |
| A | `tgui/packages/tgui/interfaces/PreferencesMenu/preferences/features/character_preferences/gs13/genetic_mutation.tsx` |
| A | `tgui/packages/tgui/interfaces/PreferencesMenu/preferences/features/character_preferences/gs13/genitals.tsx` |
| A | `tgui/packages/tgui/interfaces/PreferencesMenu/preferences/features/character_preferences/gs13/helplessness.tsx` |
| A | `tgui/packages/tgui/interfaces/PreferencesMenu/preferences/features/character_preferences/gs13/species_features.tsx` |
| A | `tgui/packages/tgui/interfaces/PreferencesMenu/preferences/features/game_preferences/gs13/content.tsx` |
| M | `tgui/packages/tgui/interfaces/PreferencesMenu/types.ts` |
| A | `tgui/packages/tgui/interfaces/ScalePanel.jsx` |
| M | `tgui/packages/tgui/interfaces/StripMenu.tsx` |
| M | `tgui/packages/tgui/interfaces/VorePanel/BellyUI.tsx` |
| M | `tgui/packages/tgui/interfaces/VorePanel/types.ts` |
| M | `tools/UpdatePaths/Scripts/93676_jetpack_repaths.txt` |
| M | `tools/build/build.ts` |
| M | `tools/build_bt.py` |
| M | `tools/ci/copy_build_output.sh` |
| M | `tools/define_sanity/check.py` |
| M | `tools/deploy.sh` |
| M | `tools/pull_request_hooks/autoChangelog.js` |
| M | `tools/ss13_genchangelog.py` |
| M | `tools/ticked_file_enforcement/ticked_file_enforcement.py` |
