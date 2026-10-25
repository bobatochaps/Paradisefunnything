# Native modular clothing

Source: `Gain-Station-13/GS13-Blubberstation@ec3ad13bd34b64451813004e32892d49de745404`, especially `modular_gs/code/modules/clothing/under/jobs/modular_items.dm`, `code/modules/loadout/under.dm`, and `code/modules/vending/wardrobes.dm` under the same modular root.

## Validated human rendering

The existing grey family supplies original-source belly/hip panels through native Paradise inventory and appearance ownership. Four human belly styles, independent base sizes and growth caps, and independent custom colors are available in the GS13 editor. Native sizes currently use the 0-to-9 body/uniform palette. Round uses its matching uniform panels; fullness independently expands clothing by up to two sizes, capped at nine, without changing the body part's growth limit. Native dyeing, rolling, torso coverage, modular exoskeleton exposure, missing/prosthetic limb handling, and cleanup remain applicable.

Checkpoint `fe3eca09c6c6229189e390ba644341acacfb7b7d` passed 265 focused / 320 full native tests, zero compiler errors/warnings, no runtime failures, UI checks, and live MariaDB in [run 40169413941](https://github.com/bobatochaps/Paradisefunnything/actions/runs/40169413941). Six additional tests cover sizes/colors; the cloning fixture captures these settings too. Four additional native BYOND previews were inspected in all four directions: independent naked sizes, Round uniform panels, fullness expansion, and independent part colors. These are native renders, not live-client gameplay verification.

## Acquisition candidate

The existing native grey-jumpsuit loadout choice keeps its saved type path. Eight additional native choices cover source science, engineering, cargo, medical, security, blue security, command, and service variants. They use the ordinary one-point native uniform cost. Departmental restrictions map to native science, engineering, supply, medical, active-security, and command roles; the blue security choice inherits its restriction. Service remains unrestricted. Native outfit spawning continues to enforce the role list.

ClothesMate supplies five ordinary modular grey suits. The source-matched native departmental wardrobes supply three of their relevant implemented variant: SecDrobe/DetDrobe, MediDrobe/ViroDrobe/ChemDrobe/GeneDrobe, SciDrobe/RoboDrobe, EngiDrobe/AtmosDrobe, CargoDrobe, and the chef/bar/hydroponics/janitorial/legal/chaplain wardrobes. Stock merges before native inventory/refill construction. Existing products, prices, and type defaults remain intact. New suits use each vendor's ordinary uniform price, currently 50 credits in the departmental wardrobes and 75 in ClothesMate. Existing free-vendor pricing is retained.

Ordinary native refill canisters and recovered stock handle the additional suits. Three integration tests exercise real loadout registration/interface data/spawning/equipment, role metadata and inherited blue-security restrictions, all eighteen native vendor catalogs, actual vending/restocking, separate stock records, and deconstruction recovery. Native validation of this acquisition candidate is pending.

## Remaining gates

Breast panels and full source organ-size DNA, higher size ranges, multi-channel layers/colors, digitigrade/taur/species fits, dual-tone/button-up/turtleneck and other clothing families, source-specific armor/palette details, missing native curator/command-access wardrobe equivalents, additional distribution, and direct player/client verification remain open. This is a partial human rendering/acquisition adapter, not complete clothing parity.
