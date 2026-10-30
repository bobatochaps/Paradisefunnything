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

## Unarmed-hit ejection

The pinned source human unarmed-hit emitter (`code/modules/mob/living/carbon/human/_species.dm`, Git blob `9e992d41d5c35f2f08d859f75f3ddeb5f88e41f7`) supplies resolved raw damage, final armor blocking and kicking to the inherited stomach. Its receiver forces vomiting when retained items exist, damage is at least nine, no armor blocks and the attack is not a kick. It does not impose a chest-zone-only or sharpness restriction.

The native adapter emits a separate event after ordinary unarmed damage resolution, preserving native damage, armor, martial-art handling and knockdown. Native unarmed variants with a kick verb supply the source exclusion. A qualifying stomach requests forced physical-content vomiting, which can recover at least one object even when normal nutrition-based vomiting would dry-heave. Ordinary vomiting retains its existing nutrition guard and sixty-percent per-item chance. Native dead/unsupported synthetic bodies still cannot vomit; extraction disconnects both stomach events. Source specialized combat variants outside the ordinary native unarmed path remain separate integration gates.

Two integration tests exercise actual native harm resolution with fixed damage, a starving target and a real retained object; then real full-body armor, sub-threshold damage, kick variants, extraction and native death. Checkpoint `e05ac531ce3ebc8e97aed1ecdd9ed239d1d23bf6` passed 315 focused / 370 full native tests, clean compilation, UI and live MariaDB checks in run 40414171810. General acid/sharp-item digestion, incision wound/cavity migration and other species/organs remain open.

## Coating taste feedback

Accepted coated pills now use Paradise's existing taste cooldown, text and hallucination handling. Ordinary source coatings report starchy sugar; the exact pinned source formula `max(0, 100 * (layers - 20))` reveals the payload flavor above its twenty-layer threshold. This preserves the source's formula rather than assuming a thicker shell always hides flavor. The twenty-layer constant comes from the already reviewed pinned reagent defines. Uncoated medicine retains the existing oral route, rejected intake produces no accepted-intake flavor, and native species without taste do not receive coating feedback.

A single native integration test exercises actual consumption at default, above-threshold and zero coating, real full-stomach refusal, and the specialized native skeleton's absent taste sense. It passes in the focused suite. The ordinary native medical-container click/self-activation fixture now verifies both the swallow message and actual current-pill retention; additional source flavor feedback can follow the swallow message. Combined checkpoint `2643fc38de57c72a97c4757ced1442d5242b42d6` passed 318 focused / 373 full native tests, clean compilation, UI and live MariaDB checks in [run 40415922680](https://github.com/bobatochaps/Paradisefunnything/actions/runs/40415922680). Direct client feedback and other inherited taste consumers remain open.

## Researched cybernetic stomachs

The pinned inherited stomach file supplies three normally researched prostheses with these distinct physical properties:

| Source tier | Maximum health | Digestive coefficient | Existing source icon |
|---|---:|---:|---|
| Basic | 50 | 0.035 | `stomach-c` |
| Standard | 150 | 0.07 | `stomach-c-u` |
| Upgraded | 200 | 0.1 | `stomach-c-u2` |

The native adapter uses actual electronic internal organs and shared oral storage/absorption, transplant, native EMP injury and nanopaste repair. Organic tissue recovery cannot repair them. The original already-copied art remains unchanged. Enhanced item acid and progressive EMP failure are implemented and validated below. EMP-specific vomiting/cooldown feedback, disgust modifiers, the surplus/removal-danger variant and complete synthetic species remain open.

Pinned `code/modules/research/designs/medical_designs.dm` (Git blob `f75fc158b34055ac8d5349c89432b0098d8183ae`) supplies the three source designs and the extra silver for the highest tier. Native designs use the existing Medical protolathe/mech-fabricator catalogs. Native biotech/materials requirements are 4/4, then 5/5 with engineering 5, then 6/6 with engineering 6. Costs follow existing native electronic-organ units: 500 metal and 500 glass, plus 500 silver for the upgraded tier. This adapts source relative material roles and progression to Paradise's existing research and fabrication units. Normal source map/admin aliases and other acquisition remain separate gates.

Two integration tests cover actual transplantation, oral data/volume-preserving absorption at all three rates, native EMP/organic-repair exclusion/nanopaste, and ordinary research unlock/material accounting/native R&D production-callback construction for all three designs. Combined checkpoint `2643fc38de57c72a97c4757ced1442d5242b42d6` passed 318 focused / 373 full native tests with clean compilation, UI and live MariaDB checks. Full client R&D interaction remains unperformed.

## Advanced prosthetic item acid

The reviewed inherited stomach file gives standard/upgraded cybernetic tiers acid powers 20/35, uses ten units per object and skips edible food. The native adapter forwards these exact values into Paradise's existing object-acid API. Ordinary organic, bone/crystal and basic cybernetic stomachs remain non-corrosive. This adds no digestion of living swallowed mobs, whose native subsystem remains separate.

Acid scans run after six elapsed native seconds, matching the source's every-third two-second mob tick, while coating callbacks still advance their own actual seconds. Item callbacks run first and can cancel generic digestion; coated pills retain their complete payload until controlled release. Ownership/deletion checks run again after each callback so a departed object or changed owner cannot receive stale acid effects. Native acid resistance, object damage and destruction continue to use their existing APIs.

Two integration tests exercise real retained metal objects and actual native acid levels at the source cadence across ordinary/basic/standard/upgraded organs, edible-food and coated-pill exclusions, and real callback-driven movement out of an eligible acid scan. Checkpoint `cb6206db81cb90ee9c88ef2eb348e6a919e19e3c` passed 323 focused / 378 full native tests in run 40418154488. Strong-stomach and sharp-item/cavity consumers follow below.

## Progressive prosthetic EMP failure

The reviewed inherited root organ applies damage from `STANDARD_ORGAN_DECAY` (111/100000) times maximum health per second while EMP-derived failure is present. The stomach's source decay multiplier is 1.15. Source cybernetic-stomach vulnerabilities are 80/40/20 percent for the three normal tiers. The native adapter preserves existing acute electronic-organ EMP injury and adds the physical organ's persistent source fault and proportional deterioration.

Source heavy/light severity 1/2 maps to native heavy/light 1/3; native intermediate/resisted/weakened strengths interpolate along that severity scale. Native EMP-proof protection remains effective. Living installed organs advance failure through the real two-second callback; death/extraction stop it, and actual transplantation carries the same fault to the new living owner. Fractional damage carries native hundredth-health rounding forward, preserving the source rate without systematic drift or accidental healing on tiny intervals.

Ordinary native electronic rejuvenation, including actual nanopaste repair, clears both the persistent fault and fractional remainder. Organic tissue recovery remains unavailable to prostheses. Examine reports the fault. Two integration tests cover actual EMP/native life callbacks/source fractional rate, invalid/tiny durations, real native repair and obsolete-fault cleanup, plus protection/death/extraction/transplant/deletion. Checkpoint `e09e29625701aef643908b80de91030c3858706f` passed 325 focused / 380 full native tests in run 40419077220, with clean compilation, UI and database checks. Source EMP-specific vomiting/cooldown/scanner feedback and other organ/trait consumers remain open.

## Strong Stomach and retained-object injury

Pinned `code/datums/quirks/positive_quirks/strong_stomach.dm` (Git blob `3cfcc085233379d9f088c7d2a238f60218cbe6f4`) supplies the body-owned positive trait. Native character selection applies it through the existing quirk registry, using two native points. This partial adapter implements the root stomach consumers: acid power at least ten and protection from retained-object trauma. Native oral-infection and vomiting-nutrition consumers follow below. Source status-duration, aged-rum grants and mail behavior remain open; the native description states only implemented effects.

The pinned root stomach permits tiny sharp objects below five force through accidental food swallowing. Its six-second retained-item scan damages the physical organ for sharp objects and tracks a half-health incision on the transition to native failure. An open incision moves normal-sized or smaller objects into the actual native chest cavity when empty; native cavity surgery retrieves that same object. Larger retained objects cause source weight-scaled chest trauma. Food and callback-cancelled items retain their exclusions. Source embedding on biting high-force objects and critical wound spilling remain open.

Three integration tests cover native quirk selection/application/cleanup, actual hidden-food intake and sharp-object failure/protection, and migration followed by the native cavity-recovery step plus oversized-item chest injury. Checkpoint `231be2f50bd62685c4f071459c6e58e90e64925f` passed 328 focused / 383 full native tests with clean compilation, UI and live database checks in run 40420717538.

## High-force hidden-object bites

The reviewed inherited `code/game/objects/items.dm` applies a sharp bite at force five or above: at least 15 head brute damage and two lost breath cycles, followed by forced chest embedding with at least 25 (or 1.5 times force) chest damage and six additional breath cycles. The adapter uses the real native chest embedded-object list, movement cleanup, blood marking and native embedded-object surgery. Native piercing immunity and missing chest anatomy prevent embedding and its conditional injury. Strong Stomach does not protect the initial bite, matching the source's separate retained-item consumer.

A rejected or oversized hidden item is discovered on the eater's turf before finished-food deletion. This preserves the physical item rather than deleting it with the food. Two integration tests exercise native Alt-click insertion/final-bite intake, actual shard injury/embedding, actual native removal, piercing-immunity rejection and intact oversized-object discovery. Source material-specific biting, wound bonus/severity semantics, and client feedback remain open. Combined checkpoint `2523afa4e5d7a4367790d29601d7014297f44c39` passed 332 focused / 387 full tests, clean compilation, UI and live database checks in run 40421626161.

## Strong Stomach oral infection

Pinned `code/datums/components/infective.dm` (Git blob `83a56890e85046d25b443da5e7a73e7e2f063bbc`) rejects Strong Stomach eat/drink infection callbacks. The native adapter checks the equivalent existing food and drinking-container reagent-exchange callback, preserving native disease copies and other exposure routes. This is infection protection, not general poison resistance. Native quirks now describe this implemented consumer; source mood, infectious-organ filtering, weak contamination and feeder behavior are not imported.

One integration test uses actual native quirk application, contaminated-food bites before/after trait removal and a real contaminated beaker drinking interaction. It bypasses only random contraction resistance and uses actual disease copying; a nonoral container callback proves independent exposure still works. Combined checkpoint `2523afa4e5d7a4367790d29601d7014297f44c39` passed 332 focused / 387 full tests, clean compilation, UI and live database checks in run 40421626161. Source vomiting nutrition/status effects and aged-rum trait grants remain open.

## Strong Stomach vomiting nutrition

Pinned `code/modules/mob/living/carbon/carbon.dm` (Git blob `73e656d3f12d46829bc1b6242324eecfd097eba8`) halves lost nutrition for non-forced vomiting with Strong Stomach. The adapter applies that fraction to native ordinary vomiting; forced ejection, bloody-vomit blood loss, dry heaves and dead-body rejection preserve their native behavior. One integration test exercises these real paths and native quirk cleanup. Combined checkpoint `2523afa4e5d7a4367790d29601d7014297f44c39` passed 332 focused / 387 full tests, clean compilation, UI and live database checks in run 40421626161. The source stun-duration consumer has no direct equivalent in Paradise's vomiting confusion/slowdown/knockdown mixture and remains an explicit gate; no status duration is silently substituted.

## Remaining specialized stomach dependencies

The pinned inherited stomach provider contains these additional variants. They remain open rather than being treated as complete merely because their scalar properties are known.

| Source variant | Reviewed contract | Dependency before implementation can be closed |
|---|---|---|
| Moth | Ordinary stomach rate/health, `spinner-x` art and organ-owned cloth-eating trait | Native trait/feeding/metabolism candidate below; complete source species, bodyparts and diet remain separate gates. |
| Surplus prosthesis | 35 maximum health, coefficient 0.025, EMP vulnerability 100, `stomach-c-s` art | Native distinction between surgical removal and ordinary extraction/transplant, source failure/EMP exemption, explosion and surgeon injury, plus reviewed normal acquisition. |
| Pod chloroplast | Plant food-type contract and lime organ tint | Complete plant food/species dependencies; native Diona is not automatically equivalent to source Podpeople. |
| Ghost | Phasing organ and ghost-specific organ flag | Source ghost anatomy/species/physical ownership and acquisition; no ordinary organic substitute. |
| Evolved | 120 maximum health, coefficient 0.08, disgust metabolism 2.5 | Actual source vat-grown cell-line acquisition and disgust consumers; scalar-only organ creation would leave those contracts incomplete. |

Pinned `code/datums/elements/dangerous_surgical_removal.dm` (Git blob `ce78ba92b4c7a28f4b0af25754899cda8ea4d47d`) supplies the surplus removal dependency. Its surgical mode ignores organs already failing or EMP-faulted, injures an adjacent remover for 15 body damage, makes a one-tile light-impact explosion and normally deletes the organ. It listens to a surgical-removal signal distinct from general removal. Paradise's ordinary internal-organ `remove()` is shared by extraction, transplantation and other cleanup; attaching this hazard indiscriminately there would change those behaviors. This provider has been reviewed for dependency planning, with no native adapter or validation claimed.

Ethereal and Protean remain separate earlier gates requiring their actual power/overcharge and MOD/metal-food behavior. Complete those dependencies before changing their native species anatomy or claiming source parity.

Additional pinned acquisition review resolves the source routes. `code/modules/research/xenobiology/vatgrowing/samples/cell_lines/organs.dm` (Git blob `2685885644c75a2baf000ac24b33b66dbf4e66f0`) produces the evolved stomach from its dedicated cell line, requiring stomach-lining organ tissue and supplementary mutagen, organ tissue, nutriment and blood. `code/datums/quirks/negative_quirks/prosthetic_organ.dm` (Git blob `2ea9a56fa2e23d6ce776a1f773c2fe1bc0ee08b9`) selects a surplus heart/lungs/liver/stomach through a character choice with random fallback and physiological exclusions; it stores the replaced original organ for actual quirk removal. Both acquisition providers remain unadapted and require their own native production/selection and ownership work.

Resume checkpoint: combined code `2523afa4e5d7a4367790d29601d7014297f44c39` passed 332 focused / 387 full native tests, clean compilation, UI and live database checks in run 40421626161. The workspace has been restored to remote documentation checkpoint `0ec4f8b483c2bffe25902b6acd092bbb948ec885`. Implementation continues; the complete port remains unfinished.

## Moth stomach and contextual cloth feeding candidate

Reviewed pinned providers: `code/modules/mob/living/carbon/human/species_types/mothmen.dm` (Git blob `efea3ea7feb81be1c78fe8cdf8998b4e4255c8aa`), `code/modules/clothing/clothing.dm` (`6525997802ce41f6a4d086e436381b2349076772`), `code/modules/reagents/chemistry/reagents/food_reagents.dm` (`c304dc6a8d2e4cd9835bb1a081f950b264ca8aa5`), `code/__DEFINES/clothing.dm` (`a85dcc8d4d09dc9acaaada293ae04c7f42d2389c`) and `code/__DEFINES/mobs.dm` (`cf3447577a078fd07d8c05925ea31764ad0997a9`). Their complete reviewed bytes were checked against the pinned Git blob hashes. The source commented-out inherent species trait is inactive: actual cloth eating comes from the physical stomach.

The native Nian layout now selects the source moth stomach with ordinary 100 health/0.05 digestion and the unchanged `spinner-x` art. This adapts its digestive organ to the native moth species; it does not replace Nian bodyparts, wings, cocoon, language, diet or claim the full source species. Shared physical-organ trait ownership preserves the previously validated bone/crystal behavior. Extraction and replacement remove cloth eating; transplantation, death/revival and deletion use native organ/trait ownership and preserve independent trait sources.

A held garment can enter the native food interaction only for a cloth eater outside harm intent. Clothing remains clothing. Its private food proxy stays in nullspace, supplies one unit of textile reagent per bite, and consumes fifteen real garment integrity through native object damage. Repeated bites use the same proxy; deleting the actual clothing deletes that proxy. The source muzzle and native indestructible/living-facehugger exclusions are enforced. Source bomb/antimagic collars have no mapped native equivalent yet; their future adapters must opt out through `gs13_cloth_edible`. Human mouth coverage, dead bodies, hand restrictions, held-item ownership and adjacency are checked. Actual native delayed feeding revalidates both physical source and initiating organ-owned trait before oral exposure and transfer. Gut capacity and native feeding redirection remain in the existing oral path.

The source textile reagent uses nutriment factor thirty and zero wound healing, adds fifteen temporary nutrition below satiety 600 each native life tick, and repays both its initial thirty-nutrition debt and accumulated temporary gain on native chemical deletion. Native baseline nutrition uses the existing per-tick reagent scale. The native final-dose parent callback deletes immediately, so the temporary credit/debt is recorded before that callback to prevent an unrepaid last-tick credit. Saturated and chemically removed doses retain the same repayment rule. Broader source consumable purity/metabolism and nonhuman infection/diet systems remain gates.

Four integration tests cover real species creation/organ transplant/death/revival/independent-trait deletion; actual repeated clothing bites, physical damage, mouth/gut rejection and final garment/proxy destruction; real native metabolism/final deletion/satiety/chemical removal; and actual timed feeding invalidated by stomach extraction plus inedible/indestructible exclusions. Native validation is pending (expected 336 focused / 391 full tests). No UI source or art changes are required.

The active modular food override (`modular_gs/code/modules/reagents/chemistry/reagents/food_reagents.dm`, Git blob `9639342ecc9d5e1bbcec3214aa0e352cb79a9ec6`) also extends source nutriment processing to synthetics/Proteans and overrides NOHUNGER nutrition. This candidate covers native human cloth digestion; those broader source metabolism/species contracts remain explicit gates.
