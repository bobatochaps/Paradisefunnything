# Native anatomy implementation record

Source: `Gain-Station-13/GS13-Blubberstation@ec3ad13bd34b64451813004e32892d49de745404`.

## Digestive-organ checkpoint

The first anatomy adapter adds a physical stomach to existing native species layouts that contain a liver. Reduced and synthetic layouts stay unchanged until their specialized source anatomy is adapted. Each species copies its layout before adding the organ. Native construction, transplantation, parent-chest registration, organ treatment, death/revival, and deletion own the organ's lifecycle.

Paradise already assigns the string slot `stomach` to its nutriment implant. The physical organ uses `GS13_ORGAN_STOMACH` (`gs13_stomach`) so ordinary and turbo implants retain their existing slot and can coexist with it.

The source's glutton Injure/Critical outcomes add 30/100 stomach damage only when fullness pressure is strictly greater than one. The adapter uses a 100 maximum, 10 minor, and 45 major thresholds. Fatness-only bursts, the exact fullness boundary, and Safe do not add this explicit organ trauma. Paradise's ordinary chest trauma can still inflict its normal random internal-organ injuries; the integration tests isolate that chance when checking the source's exact amounts and boundaries. A missing stomach is not recreated by bursting. Native scanners, chest surgery, generic organ repair, and transplantation can access the real organ. A destroyed organ needs native revival/rejuvenation or replacement; ordinary organic mending alone does not revive necrotic tissue.

The source's damaged-stomach food response uses pending native nutriment and ordinary vomiting. Its probabilities are converted from seconds to Paradise's two-second organ tick. Healthy stomachs, empty holders, corpses, removed organs, and bodies without a turf do not trigger this response. The source `icons/obj/medical/organs/organs.dmi` is copied unchanged to `modular_gs/icons/upstream/organs.dmi` (Git blob `7b73c7edbaee16d35a7193ade11cd8d9feb154a6`).

This checkpoint does not replace Paradise's single reagent holder with TG's separate stomach/blood ingestion pipeline. Source drip digestion, missing-stomach ingestion restrictions, swallowed-item digestion, specialized species, automatic tissue healing, and the broader anatomy/body-shape systems remain open. Existing native food, chemical, nutriment-pump, and weight-conversion paths continue to use the body holder.

Six integration tests cover species/slot coexistence, native transplant/death/deletion, real chest treatment, over-full burst trauma, strict boundaries/safe/missing-organ cases, and live food-response cleanup. Checkpoint `e0cb900b9e80d8b403290a562fc8edd6e14a978e` passed 218 focused and 273 full native tests with zero compiler errors/warnings, no runtime failures, and successful UI and live MariaDB checks in [run 40115680251](https://github.com/bobatochaps/Paradisefunnything/actions/runs/40115680251).

## Next dependencies

Review the inherited fluid-organ contract used by Neutron's persistent overdose effect, with source-specific preferences, organ ownership, surgical transfer, and regeneration. Then extend supported species and body-shape/clothing rendering together. This candidate does not complete the broader anatomy milestone or the blueberry group. Direct client gameplay, rendering, and performance checks remain open.

## Human body-shape candidate

The character GS13 editor now offers the source Classic, Round, Smooth, and Smooth without arms belly styles. The last remains the default to preserve existing characters. All choices use original, unchanged source sheets and the existing nine weight stages. The selected style uses the character JSON/SQL snapshot, applies during the round, remains with the physical body across mind transfers, and participates in the native appearance cache. Invalid saved values use the compatible default. Existing glutton outcome choices use the same native choice editor.

The three additional sheets include arm/hand pixels. A body with any missing or robotic arm/hand uses the original sheet without arms while retaining its saved style; restoring the anatomy restores the selected style. Separate per-limb source masks are still pending. Native torso coverage, modular uniform panels, current skin coloring, appearance opt-out, and unadapted-species cleanup remain applicable. The new styles do not add unsupported species, independent minimum/maximum body-part sizes, or the source's full modular anatomy model.

Six integration tests cover preference serialization, live saved-character changes, all 36 style/stage pairs with actual BYOND previews, missing/prosthetic limb fallback and recovery, clothing/appearance/species cleanup, and body ownership through mind transfer/death/revival. Native validation is pending; generated preview inspection and direct client verification are separate gates.
