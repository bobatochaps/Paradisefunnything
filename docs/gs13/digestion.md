# Native digestion implementation record

Source: `Gain-Station-13/GS13-Blubberstation@ec3ad13bd34b64451813004e32892d49de745404`, inherited `code/modules/surgery/organs/internal/stomach/_stomach.dm`.

## Validated compartment foundation

The actual native stomach now owns a 1000-unit food/reagent holder. Its live processing drips metabolizing material into the body, preserving reagent data and respecting blood capacity. Source volume efficiency is 0.05 per second, with a 0.25-unit minimum constant and the native reagent rate converted from the two-second life tick. Inert material remains stored. Removal, death, and deletion stop processing; transplantation moves the existing contents to the new owner.

Fullness counts the distinct pending nutritional potential in both holders. Native reagent transfer adds to the destination before removing from the source; the adapter excludes only that temporarily duplicated dose during callbacks, preventing transient false pressure/fullness spikes. Safe glutton recovery clears both holders through their normal reagent lifecycle. Damaged-stomach vomiting now reads food in the actual stomach.

`gs13_ingest` is an explicit oral API that resolves the current digestive target, bounds effects and transfer to the accepted dose, preserves undelivered supply, and rejects a missing required organ. Native species without an adapted stomach retain their prior body route. Existing direct blood-transfer APIs remain unchanged: Paradise also uses `REAGENT_INGEST` for injections, IVs, and internal surgery, so that flag cannot safely select the destination.

Nine integration tests cover physical routing/data preservation, dose-scaled oral effects, blood backpressure, missing organs versus injection, native fallback species, fullness during real transfer callbacks, death/transplant/deletion, inert/invalid processing, and two-holder burst cleanup. Checkpoint `123d45d8de36fab75ecdd92f65f2f4c738638b25` passed 246 focused / 301 full native tests, zero compiler errors/warnings, UI checks, and live MariaDB in [run 40166809588](https://github.com/bobatochaps/Paradisefunnything/actions/runs/40166809588).

## Oral entry-point integration candidate

Native food, utensils, drinks/chugging, pills, condiments, glass gulps, and the feeding machine now use the explicit oral API. Bites and sips are bounded by actual stomach capacity; rejected bites cannot invoke food callbacks. Pills require room for the whole dose and remain available when refused. Glass gulps retain their native delay and recheck the source, open lid, held item, reach, mouth, current bluespace recipient, and current capacity at completion. Bluespace food/drink/machine routing still follows the current eligible receiver; physical leftovers and tube reach remain native. Ordinary syringes, IVs, hyposprays, medical implants, and surgery keep their direct blood route.

Seven additional integration tests exercise actual native food, drink, pill, condiment, delayed glass, feeding-machine, and syringe entry points. Existing feeding and bluespace tests now inspect the physical stomach and explicitly digest doses before checking body chemistry. Native validation of this candidate is pending.

Remaining special oral sources (including edible restraints and dental pill implants), source swallowing/items, specialized stomachs, automatic tissue healing, broader species, and live client gameplay remain open.

## Special oral compatibility candidate

Native dental implant actions and edible candy restraints now use the oral compartment. Dental surgery creates the real pill action from its actual target; activation rejects a detached implant or insufficient room without deleting the pill. Candy restraints remain breakable when swallowing is impossible, so missing/full digestive anatomy cannot trap their wearer. A feeding-machine completion validator preserves its post-reaction physical connection, mouth, and current receiver checks before transferring fluid.

Three additional tests exercise actual dental surgery/action activation, candy restraint escape/intake, and a native chemical reaction that disconnects the feeding machine before transfer. Native validation of this candidate is pending. The audit deliberately leaves non-oral plant prickles, blood-brood reabsorption, injection pens/projectiles, IVs, syringes, medical bots/mecha, and internal-tissue surgery on their prior body route.
