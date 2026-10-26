# Native digestion implementation record

Source: `Gain-Station-13/GS13-Blubberstation@ec3ad13bd34b64451813004e32892d49de745404`, inherited `code/modules/surgery/organs/internal/stomach/_stomach.dm`.

## Validated compartment foundation

The actual native stomach now owns a 1000-unit food/reagent holder. Its live processing drips metabolizing material into the body, preserving reagent data and respecting blood capacity. Source volume efficiency is 0.05 per second, with a 0.25-unit minimum constant and the native reagent rate converted from the two-second life tick. Inert material remains stored. Removal, death, and deletion stop processing; transplantation moves the existing contents to the new owner.

Fullness counts the distinct pending nutritional potential in both holders. Native reagent transfer adds to the destination before removing from the source; the adapter excludes only that temporarily duplicated dose during callbacks, preventing transient false pressure/fullness spikes. Safe glutton recovery clears both holders through their normal reagent lifecycle. Damaged-stomach vomiting now reads food in the actual stomach.

`gs13_ingest` is an explicit oral API that resolves the current digestive target, bounds effects and transfer to the accepted dose, preserves undelivered supply, and rejects a missing required organ. Native species without an adapted stomach retain their prior body route. Existing direct blood-transfer APIs remain unchanged: Paradise also uses `REAGENT_INGEST` for injections, IVs, and internal surgery, so that flag cannot safely select the destination.

Nine integration tests cover physical routing/data preservation, dose-scaled oral effects, blood backpressure, missing organs versus injection, native fallback species, fullness during real transfer callbacks, death/transplant/deletion, inert/invalid processing, and two-holder burst cleanup. Checkpoint `123d45d8de36fab75ecdd92f65f2f4c738638b25` passed 246 focused / 301 full native tests, zero compiler errors/warnings, UI checks, and live MariaDB in [run 40166809588](https://github.com/bobatochaps/Paradisefunnything/actions/runs/40166809588).

## Validated oral entry-point integration

Native food, utensils, drinks/chugging, pills, condiments, glass gulps, and the feeding machine now use the explicit oral API. Bites and sips are bounded by actual stomach capacity; rejected bites cannot invoke food callbacks. Pills require room for the whole dose and remain available when refused. Glass gulps retain their native delay and recheck the source, open lid, held item, reach, mouth, current bluespace recipient, and current capacity at completion. Bluespace food/drink/machine routing still follows the current eligible receiver; physical leftovers and tube reach remain native. Ordinary syringes, IVs, hyposprays, medical implants, and surgery keep their direct blood route.

Seven additional integration tests exercise actual native food, drink, pill, condiment, delayed glass, feeding-machine, and syringe entry points. Existing feeding and bluespace tests now inspect the physical stomach and explicitly digest doses before checking body chemistry. Checkpoint `127d8e15c95d06f06dbe66ab51a6b2388c9f2e90` passed 253 focused / 308 full native tests, zero compiler errors/warnings, UI checks, and live MariaDB in [run 40167204070](https://github.com/bobatochaps/Paradisefunnything/actions/runs/40167204070).

Source-rate tissue healing, initial benign tiny-item swallowing and surgical recovery are now validated; see the anatomy record below. Specialized stomachs, complete item digestion, broader species and live client gameplay remain open.

## Validated special oral compatibility

Native dental implant actions and edible candy restraints now use the oral compartment. Dental surgery creates the real pill action from its actual target; activation rejects a detached implant or insufficient room without deleting the pill. Candy restraints remain breakable when swallowing is impossible, so missing/full digestive anatomy cannot trap their wearer. A feeding-machine completion validator preserves its post-reaction physical connection, mouth, and current receiver checks before transferring fluid.

Three additional tests exercise actual dental surgery/action activation, candy restraint escape/intake, and a native chemical reaction that disconnects the feeding machine before transfer. Checkpoint `1619eda65aa848b5ceacc2cf34b6adc6fa899518` passed 256 focused / 311 full native tests, zero compiler errors/warnings, UI checks, and live MariaDB in [run 40167478086](https://github.com/bobatochaps/Paradisefunnything/actions/runs/40167478086). The audit deliberately leaves non-oral plant prickles, blood-brood reabsorption, injection pens/projectiles, IVs, syringes, medical bots/mecha, and internal-tissue surgery on their prior body route.

## Physical items, tissue recovery and surgery

Combined checkpoint `00d175c45dd20acbaec76adca32c108b6d5160a9` passed 304 focused / 359 full native tests, clean compilation, UI checks and live MariaDB in [run 40278044018](https://github.com/bobatochaps/Paradisefunnything/actions/runs/40278044018). Source-rate tissue recovery uses native food satiety. Benign tiny objects hidden through actual native food insertion stay with the physical stomach through extraction and transplantation; native vomiting and timed scalpel recovery can release those same items. Native repair and cautery track the incision separately from unrelated injury. See [the detailed anatomy record](anatomy.md).

## Coated pills

The pinned inherited pill file (Git blob `22bd3c3d05703eaef2c2427fd792ca6f71202eb6`) supplies a default three-layer coating, one second per layer, a guarded final partial-tick timer and physical stomach storage. The pinned reagent defines (Git blob `1e3b65dc760b4f583d1911e8fa6d411335e44b39`) set maximum coating to sixty layers and printable coating to thirty. The source ChemMaster (Git blob `e1486cd65f02f74ffebeeeed8636a29d8db5d498`) supplies the normal production control.

Ordinary native pills now retain their actual payload inside the stomach until their coating dissolves. Native digestion advances coating in elapsed seconds on its normal two-second organ callback, using native UID lookup for a shorter final timer interval without retaining its former body. The source's every-third-mob-tick item scan is replaced by native elapsed-time callbacks so a coating layer still represents one second. Death/extraction stop digestion; stale timers cannot spend a dose in the former body. Actual transplantation carries the pill and its remaining coating. Released medication follows the explicit native oral compartment and normal absorption; full-capacity backpressure preserves any unaccepted remainder without repeating oral effects. The existing uncoated entry-point fixture explicitly selects zero layers. Native dental activation bursts its shell and retains its existing direct oral-dose behavior.

Normal ChemMaster pill synthesis and the existing native control panel now support a separate 0–30-second coating choice per machine, default three. Existing bottles, quantities, sprites and doses remain native. Item JSON carries the coating scalar without copying active timers or body ownership; this does not add complete reagent-payload persistence to native item storage. Four integration tests cover actual native intake/timed release, preserved reagent data and one oral exposure, death/extraction/transplant/backpressure, stale timers and normally synthesized bottle stock/UI/JSON. Checkpoint `b365e4fcdd278a822c54b609e3e5ad72b9887a2c` passed 308 focused / 363 full native tests, clean compilation, UI and live MariaDB checks in [run 40318701198](https://github.com/bobatochaps/Paradisefunnything/actions/runs/40318701198). Taste masking, complete accidental-consumption/embedding, general acid digestion, specialized species and direct client checks remain open.

## Manual coating

The same pinned source pill file allows ordinary droppers and open pouring containers to add sugar or dissolve coating with water. The native adapter follows its per-transfer whole-unit limit, sixty-layer cap, exact reagent consumption and sugar-before-water priority for mixed containers. It leaves the medicine payload untouched and preserves unused external reagent. Closed pouring containers cannot apply coating. Coating zero remains an immediate oral dose.

Changing or restoring a pill's coating cancels its obsolete final-interval timer. This avoids a recovered and recoated pill releasing early if reinserted into the same body before that old timer expires. Two additional tests cover real native dropper/beaker interactions, sugar/water/medicine conservation and caps, plus actual recovery/recoating/reinsertion across the old timer and subsequent normal release. Combined checkpoint `658044867aaeb14ea119b9cf30a0287002ddea1c` passed 310 focused / 365 full native tests, zero compiler errors/warnings, UI and live MariaDB checks in [run 40319159289](https://github.com/bobatochaps/Paradisefunnything/actions/runs/40319159289).

The compiled production UI is saved at `126ee862514fe3e294a6619bc64bebb7f0a151ec`. Its unchanged build output comes from the successful UI artifact in run 40318701198 (ZIP SHA-256 `545a0059b1162e739ccb74ab8e62994e26880acd4fe603fe5b5f9f79d52b9780`); the bundle Git blob is `e562161755dfc172d4b8320ea81749478979e810`. The UI source and dependency inputs are identical in the final manual-coating checkpoint. All other generated UI files were byte-identical. Direct client gameplay remains unperformed.

## Bone and Plasmaman stomachs

The pinned inherited stomach file defines a bone stomach with absorption coefficient 0.025 and an organ-owned no-hunger trait, and a Plasmaman digestive crystal with coefficient 0.06 and no organ-owned trait. Its ordinary human coefficient is 0.05. The source species providers select these exact types: `species_types/skeletons.dm` (Git blob `ad5ef52c4f6fa6b9930fb9ac7a807a0d7f119d9b`) and `species_types/plasmamen.dm` (Git blob `65ae620cf980272a2e0e76463877eea7d83dac64`).

Native Skeleton and Plasmaman layouts now select those specialized physical organs during ordinary species creation/change. The reduced skeleton layout explicitly permits its reviewed bone organ despite lacking a liver; unadapted reduced/synthetic layouts still receive no invented organic stomach. The original already-copied source bone/crystal icon states remain unchanged. Native oral storage, absorption, contents, surgery and transplant APIs remain shared, with each actual physical organ's own coefficient.

Bone-organ transplantation grants no-hunger under that organ's unique native trait source; removal/deletion releases only that source. Native species-owned and independently supplied hunger traits remain intact. The crystal explicitly grants no organ-owned hunger immunity, matching the source, while native Plasmaman species immunity remains separate. These are organ/layout adapters, not a replacement for complete source species, hunger, nutrition, organ-food or power systems.

Three added native integration tests cover actual species layouts and return to human/synthetic bodies, real oral compartment/data-conserving absorption at both rates, and actual transplant/deletion trait ownership. Checkpoint `28df46b0adb85bf8d1d3d45fa45a5126f37ecb93` passed 313 focused / 368 full native tests, clean compilation, UI and live MariaDB checks in [run 40413394679](https://github.com/bobatochaps/Paradisefunnything/actions/runs/40413394679). Other specialized organs, source organ-food/trait consumers and complete Ethereal/Protean dependencies remain open.

## Unarmed-hit ejection candidate

The pinned source human unarmed-hit emitter (`code/modules/mob/living/carbon/human/_species.dm`, Git blob `9e992d41d5c35f2f08d859f75f3ddeb5f88e41f7`) supplies resolved raw damage, final armor blocking and kicking to the inherited stomach. Its receiver forces vomiting when retained items exist, damage is at least nine, no armor blocks and the attack is not a kick. It does not impose a chest-zone-only or sharpness restriction.

The native adapter emits a separate event after ordinary unarmed damage resolution, preserving native damage, armor, martial-art handling and knockdown. Native unarmed variants with a kick verb supply the source exclusion. A qualifying stomach requests forced physical-content vomiting, which can recover at least one object even when normal nutrition-based vomiting would dry-heave. Ordinary vomiting retains its existing nutrition guard and sixty-percent per-item chance. Native dead/unsupported synthetic bodies still cannot vomit; extraction disconnects both stomach events. Source specialized combat variants outside the ordinary native unarmed path remain separate integration gates.

Two integration tests exercise actual native harm resolution with fixed damage, a starving target and a real retained object; then real full-body armor, sub-threshold damage, kick variants, extraction and native death. Static checks pass; native validation is pending. General acid/sharp-item digestion, incision wound/cavity migration and other species/organs remain open.

## Coating taste-feedback candidate

Accepted coated pills now use Paradise's existing taste cooldown, text and hallucination handling. Ordinary source coatings report starchy sugar; the exact pinned source formula `max(0, 100 * (layers - 20))` reveals the payload flavor above its twenty-layer threshold. This preserves the source's formula rather than assuming a thicker shell always hides flavor. The twenty-layer constant comes from the already reviewed pinned reagent defines. Uncoated medicine retains the existing oral route, rejected intake produces no accepted-intake flavor, and native species without taste do not receive coating feedback.

A single native integration test exercises actual consumption at default, above-threshold and zero coating, real full-stomach refusal, and the specialized native skeleton's absent taste sense. Static checks pass; native validation is pending. Direct client feedback and other inherited taste consumers remain open.

## Researched cybernetic-stomach candidates

The pinned inherited stomach file supplies three normally researched prostheses with these distinct physical properties:

| Source tier | Maximum health | Digestive coefficient | Existing source icon |
|---|---:|---:|---|
| Basic | 50 | 0.035 | `stomach-c` |
| Standard | 150 | 0.07 | `stomach-c-u` |
| Upgraded | 200 | 0.1 | `stomach-c-u2` |

The native adapter uses actual electronic internal organs and shared oral storage/absorption, transplant, native EMP injury and nanopaste repair. Organic tissue recovery cannot repair them. The original already-copied art remains unchanged. This does not yet implement the source's additional EMP-derived progressive failure/cooldown feedback, disgust modifiers, enhanced acid digestion, surplus/removal-danger variant or complete synthetic species.

Pinned `code/modules/research/designs/medical_designs.dm` (Git blob `f75fc158b34055ac8d5349c89432b0098d8183ae`) supplies the three source designs and the extra silver for the highest tier. Native designs use the existing Medical protolathe/mech-fabricator catalogs. Native biotech/materials requirements are 4/4, then 5/5 with engineering 5, then 6/6 with engineering 6. Costs follow existing native electronic-organ units: 500 metal and 500 glass, plus 500 silver for the upgraded tier. This adapts source relative material roles and progression to Paradise's existing research and fabrication units. Normal source map/admin aliases and other acquisition remain separate gates.

Two integration tests cover actual transplantation, oral data/volume-preserving absorption at all three rates, native EMP/organic-repair exclusion/nanopaste, and ordinary research unlock/material accounting/native R&D production-callback construction for all three designs. Static checks pass; native validation is pending. Full client R&D interaction remains unperformed.
