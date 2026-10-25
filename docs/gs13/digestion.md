# Native digestion implementation record

Source: `Gain-Station-13/GS13-Blubberstation@ec3ad13bd34b64451813004e32892d49de745404`, inherited `code/modules/surgery/organs/internal/stomach/_stomach.dm`.

## Compartment foundation candidate

The actual native stomach now owns a 1000-unit food/reagent holder. Its live processing drips metabolizing material into the body, preserving reagent data and respecting blood capacity. Source volume efficiency is 0.05 per second, with a 0.25-unit minimum constant and the native reagent rate converted from the two-second life tick. Inert material remains stored. Removal, death, and deletion stop processing; transplantation moves the existing contents to the new owner.

Fullness counts the distinct pending nutritional potential in both holders. Native reagent transfer adds to the destination before removing from the source; the adapter excludes only that temporarily duplicated dose during callbacks, preventing transient false pressure/fullness spikes. Safe glutton recovery clears both holders through their normal reagent lifecycle. Damaged-stomach vomiting now reads food in the actual stomach.

`gs13_ingest` is an explicit oral API that resolves the current digestive target, bounds effects and transfer to the accepted dose, preserves undelivered supply, and rejects a missing required organ. Native species without an adapted stomach retain their prior body route. Existing direct blood-transfer APIs remain unchanged: Paradise also uses `REAGENT_INGEST` for injections, IVs, and internal surgery, so that flag cannot safely select the destination.

Nine integration tests cover physical routing/data preservation, dose-scaled oral effects, blood backpressure, missing organs versus injection, native fallback species, fullness during real transfer callbacks, death/transplant/deletion, inert/invalid processing, and two-holder burst cleanup. Native validation is pending.

## Next integration checkpoint

Adopt the explicit API at actual food, drink, utensil, pill, condiment, and feeding-machine entry points, including current bluespace routing and post-delay capacity checks. Those ordinary oral entry points still use the earlier direct-body behavior in this foundation checkpoint. Keep syringe, IV, hypospray, medical-implant, and surgery paths direct. Remaining source swallowing/items, specialized stomachs, automatic tissue healing, and live client gameplay remain open.
