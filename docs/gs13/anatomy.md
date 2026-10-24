# Native anatomy implementation record

Source: `Gain-Station-13/GS13-Blubberstation@ec3ad13bd34b64451813004e32892d49de745404`.

## Digestive-organ candidate

The first anatomy adapter adds a physical stomach to existing native species layouts that contain a liver. Reduced and synthetic layouts stay unchanged until their specialized source anatomy is adapted. Each species copies its layout before adding the organ. Native construction, transplantation, parent-chest registration, organ treatment, death/revival, and deletion own the organ's lifecycle.

Paradise already assigns the string slot `stomach` to its nutriment implant. The physical organ uses `GS13_ORGAN_STOMACH` (`gs13_stomach`) so ordinary and turbo implants retain their existing slot and can coexist with it.

The source's glutton Injure/Critical outcomes inflict 30/100 stomach damage only when fullness pressure is strictly greater than one. The adapter retains those values and the source 100 maximum, 10 minor, and 45 major thresholds. Fatness-only bursts, the exact fullness boundary, and Safe do not injure it. A missing stomach is not recreated by bursting. Native scanners, chest surgery, generic organ repair, and transplantation can access the real organ. A destroyed organ needs native revival/rejuvenation or replacement; ordinary organic mending alone does not revive necrotic tissue.

The source's damaged-stomach food response uses pending native nutriment and ordinary vomiting. Its probabilities are converted from seconds to Paradise's two-second organ tick. Healthy stomachs, empty holders, corpses, removed organs, and bodies without a turf do not trigger this response. The source `icons/obj/medical/organs/organs.dmi` is copied unchanged to `modular_gs/icons/upstream/organs.dmi` (Git blob `7b73c7edbaee16d35a7193ade11cd8d9feb154a6`).

This checkpoint does not replace Paradise's single reagent holder with TG's separate stomach/blood ingestion pipeline. Source drip digestion, missing-stomach ingestion restrictions, swallowed-item digestion, specialized species, automatic tissue healing, and the broader anatomy/body-shape systems remain open. Existing native food, chemical, nutriment-pump, and weight-conversion paths continue to use the body holder.

Six integration tests cover species/slot coexistence, native transplant/death/deletion, real chest treatment, over-full burst trauma, strict boundaries/safe/missing-organ cases, and live food-response cleanup. Native validation is pending.

## Next dependencies

Review the inherited fluid-organ contract used by Neutron's persistent overdose effect, with source-specific preferences, organ ownership, surgical transfer, and regeneration. Then extend supported species and body-shape/clothing rendering together. This candidate does not complete the broader anatomy milestone or the blueberry group. Direct client gameplay, rendering, and performance checks remain open.
