# Native anatomy implementation record

Source: `Gain-Station-13/GS13-Blubberstation@ec3ad13bd34b64451813004e32892d49de745404`.

## Digestive-organ checkpoint

The first anatomy adapter adds a physical stomach to existing native species layouts that contain a liver. Reduced and synthetic layouts stay unchanged until their specialized source anatomy is adapted. Each species copies its layout before adding the organ. Native construction, transplantation, parent-chest registration, organ treatment, death/revival, and deletion own the organ's lifecycle.

Paradise already assigns the string slot `stomach` to its nutriment implant. The physical organ uses `GS13_ORGAN_STOMACH` (`gs13_stomach`) so ordinary and turbo implants retain their existing slot and can coexist with it.

The source's glutton Injure/Critical outcomes add 30/100 stomach damage only when fullness pressure is strictly greater than one. The adapter uses a 100 maximum, 10 minor, and 45 major thresholds. Fatness-only bursts, the exact fullness boundary, and Safe do not add this explicit organ trauma. Paradise's ordinary chest trauma can still inflict its normal random internal-organ injuries; the integration tests isolate that chance when checking the source's exact amounts and boundaries. A missing stomach is not recreated by bursting. Native scanners, chest surgery, generic organ repair, and transplantation can access the real organ. A destroyed organ needs native revival/rejuvenation or replacement; ordinary organic mending alone does not revive necrotic tissue.

The source's damaged-stomach food response uses pending native nutriment and ordinary vomiting. Its probabilities are converted from seconds to Paradise's two-second organ tick. Healthy stomachs, empty holders, corpses, removed organs, and bodies without a turf do not trigger this response. The source `icons/obj/medical/organs/organs.dmi` is copied unchanged to `modular_gs/icons/upstream/organs.dmi` (Git blob `7b73c7edbaee16d35a7193ade11cd8d9feb154a6`).

The later [digestion adapter](digestion.md) adds a separate physical stomach holder, drip absorption, and explicit oral routing. Medical injections, nutriment pumps, and weight conversion retain their native body holder. Swallowed-item digestion, specialized species, automatic tissue healing, and the broader anatomy/body-shape systems remain open.

Six integration tests cover species/slot coexistence, native transplant/death/deletion, real chest treatment, over-full burst trauma, strict boundaries/safe/missing-organ cases, and live food-response cleanup. Checkpoint `e0cb900b9e80d8b403290a562fc8edd6e14a978e` passed 218 focused and 273 full native tests with zero compiler errors/warnings, no runtime failures, and successful UI and live MariaDB checks in [run 40115680251](https://github.com/bobatochaps/Paradisefunnything/actions/runs/40115680251).

## Next dependencies

The reviewed optional fluid-organ/preferences contract and Neutron's persistent overdose are now implemented; see [the fluid-organ record](fluid_organs.md). Continue digestive compatibility, independent part sizes/colors, supported species, and body-shape/clothing rendering together. These checkpoints do not complete the broader anatomy milestone or the blueberry group. Direct client gameplay, rendering, and performance checks remain open.

## Neutron fluid-organ dependency review

The pinned `starshine.dm` overdose changes existing human anatomy: it sets `internal_fluid_datum` to Neutron on the breasts, testicles, and vagina slots, and enables `lactates` on the breasts. It creates no missing organs and does not immediately replace the fluid already stored in their reagent holders. The change belongs to the actual organ and persists when the drink metabolizes; clearing it with the temporary volume/light effects would be incorrect. It does not rewrite DNA defaults.

The required inherited implementation is split between `modular_skyrat/modules/customization/modules/surgery/organs/genitals.dm` and `modular_skyrat/modules/modular_items/lewd_items/code/lewd_organs/{_genital,breasts,testicles,vagina}.dm`, with GS13 production/size changes in `modular_gs/code/modules/mob/living/genitals.dm` and saved customization in `modular_gs/code/modules/client/preferences/genitals.dm`. These exact pinned files have partial native adapters in `fluid_organs.dm` and `anatomy_preferences.dm`. Optional anatomy defaults absent; production/collection has a separate live opt-in and server switch. Actual organ state, birth DNA, and live preference snapshots stay distinct. Thirteen tests exercise the real overdose, creation/storage/production, actions, surgical transfer, native repair/revival, DNA, capacity reduction, server settings, and deletion. External rendering, the broader inherited interaction system, unsupported products, and specialized species remain open.

## Human body-shape checkpoint

The character GS13 editor now offers the source Classic, Round, Smooth, and Smooth without arms belly styles. The last remains the default to preserve existing characters. All choices use original, unchanged source sheets and the existing nine weight stages. The selected style uses the character JSON/SQL snapshot, applies during the round, remains with the physical body across mind transfers, and participates in the native appearance cache. Invalid saved values use the compatible default. Existing glutton outcome choices use the same native choice editor.

The three additional sheets include arm/hand pixels. A body with any missing or robotic arm/hand uses the original sheet without arms while retaining its saved style; restoring the anatomy restores the selected style. Separate per-limb source masks are still pending. Native torso coverage, modular uniform panels, current skin coloring, appearance opt-out, and unadapted-species cleanup remain applicable. The new styles do not add unsupported species, independent minimum/maximum body-part sizes, or the source's full modular anatomy model.

Six integration tests cover preference serialization, live saved-character changes, all 36 style/stage pairs with actual BYOND previews, missing/prosthetic limb fallback and recovery, clothing/appearance/species cleanup, and body ownership through mind transfer/death/revival. Final checkpoint `49dd09382c99a2e017845d3d777a39b5d6048510` passed 224 focused and 279 full native tests with zero compiler errors/warnings, no runtime failures, and successful UI and live MariaDB checks in [run 40116638947](https://github.com/bobatochaps/Paradisefunnything/actions/runs/40116638947). Thirteen native BYOND PNG previews were inspected: four styles at stages 1, 4, and 9, plus a clothed case, each in all four directions. These confirm the generated native images; direct client gameplay/rendering and performance checks remain unperformed.


## Independent human part-size candidate

The GS13 editor now exposes separate base and maximum sprite sizes for the human belly and hips. Source `modular_gs/code/modules/mob/living/species.dm` adds the current weight stage to each part's saved base, while the size setters in `genitals.dm` apply their maximum. The native adapter follows that growth/cap contract within its current 0-to-9 body/uniform palette. Defaults of base zero and maximum nine retain the previous appearance. A maximum below the base wins; zero maximum removes that part's extra overlay. These settings change the display, not physical fat/muscle, measured mass, movement, or fullness pressure.

Native modular uniform panels use the same independent part sizes; the belly's visible maximum also bounds fullness-driven panels. Current source style choices, skin shading, prosthetic/missing-limb safety, torso coverage, appearance opt-out, and cache cleanup remain applicable. The settings use the existing body-owned character snapshot and are captured by native cloning. Ordinary DNA transfer still preserves the destination body's visual policy. Full source organ-size DNA, higher-range palettes, independent colors, other body parts/species, and complete clothing compatibility remain open.

Three additional integration tests cover numeric save/default/editor handling, live independent body sizes and limits without changing measured mass, real uniform/fullness/limb cleanup, and two additional native BYOND previews. The cloning snapshot fixture also checks both a base size and a maximum. Native validation is pending.

## Client verification still required

In Character Setup's GS13 editor, save and reload each Human belly shape, enable weight gain/body sprites, and test gaining/losing weight at different stages. Repeat with blueberry transformation independent of ordinary weight gain, native skin changes, clothing concealment, dyed/rolled modular uniforms, and an unsupported species. Verify live style changes update the current body's appearance and other saved character slots do not change it.

With Classic, Round, or Smooth selected, test a missing/prosthetic arm or hand: the visible fallback must preserve that limb while retaining the saved style, and organic replacement must restore the selected shape. Repeat after reconnect, mind transfer, death/revival, and native icon regeneration.

Test opted-in Injure/Critical fullness bursting with a native scanner and chest surgery. Verify the stomach remains the same damaged organ, ordinary mending treats non-necrotic injury, and native revival/replacement handles destruction. Fit a nutriment implant at the same time, then extract/transplant the physical stomach and verify its damage and ownership. Native random chest-organ injury remains separate from the explicit fullness amount. This procedure has not been performed in a live client.
