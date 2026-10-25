# Fluid-organ implementation record

Source: `Gain-Station-13/GS13-Blubberstation@ec3ad13bd34b64451813004e32892d49de745404`.

## Native candidate

Optional breasts, testicles, and vagina organs use native ownership, slots, reservoir objects, item actions, and deletion/removal. They default absent and require explicit saved character choices. The server can disable them with `fluid_anatomy_enabled = false` in `[gs13_configuration]`. Initial support covers ordinary human anatomy with the appropriate organic parent body part; specialized species, external body rendering, and full inherited interaction systems remain open.

The GS13 editor supplies next-spawn presence, sizes, arrangement, lactation, and fluid choices. A separate live production/collection switch defaults off. Source-supported products with native reagent adapters are selectable; the two source products without native chemistry are not offered yet. Birth configuration creates independent DNA defaults. Those defaults survive DNA cloning/serialization/body changes; the recipient never inherits another physical organ's modified fluid type or stored dose. Ordinary appearance refreshes do not regrow an absent organ. Live next-spawn edits do not overwrite a current organ's state.

Breast reservoirs use `size * arrangement multiplier * 60`, capped at 3500 units, and begin empty. Pair/quadruple/sextuple multipliers are 2/2.5/3. Testicular reservoirs use `size * 20` and begin full of the source fluid. Vaginal reservoirs retain their empty ten-unit initial state. Reducing a reservoir removes all excess mixed fluid, avoiding the source's removal of only its currently selected product. Actual volume, free space, and finite inputs bound production and sampling.

Lactating breast organs produce five percent of their capacity per second through the native two-second life tick, only for a living online owner with production enabled and an intact installed organ. The shared bounded production API is also available to future inherited consumers. Broader arousal/release mechanics are not supplied by this checkpoint. Sampling uses an owner-only native organ action and an open container in the active hand: one interruptible second per dose, up to ten units or actual free space. Removal, opt-out, incapacitation, container swaps/lids, and completion stop it.

Neutron's actual native overdose path changes `internal_fluid_datum` on the three existing organs and enables breast lactation. It creates no absent organs, replaces no already stored fluid, and rewrites no DNA defaults. The product remains changed after the drink is metabolized/removed, ordinary appearance updates, native repair, death/revival, and organ transplantation. Temporary mass, light, and normal weight/chemical preferences remain independent.

The original source object sheets are copied unchanged from `modular_skyrat/master_files/icons/obj/genitals/{breasts,testicles,vagina}.dmi` into `modular_gs/icons/upstream/fluid_organs/`. Source breast-milk and reproductive-fluid IDs use native consumable reagents and neutral sample/glass descriptions.

Twelve integration tests cover default/serialized preferences, native creation/actions/artwork, source initial capacities/content, the real overdose threshold path and persistent state, absent organs, production gates, mixed-fluid capacity reduction, sampling/lids/ownership, the real timed action, transplantation, DNA and physical-state separation, live preference edits, all available products, and server configuration. Native validation is pending.

## Remaining gates

External organ rendering, full body-part size/color/layer customization, specialized species, unsupported source products, inherited arousal/release/interactions, and direct player SQL/client gameplay checks remain open. This record does not establish complete anatomy or GS13 parity.
