# Fluid-organ implementation record

Source: `Gain-Station-13/GS13-Blubberstation@ec3ad13bd34b64451813004e32892d49de745404`.

## Native implementation

Optional breasts, testicles, and vagina organs use native ownership, slots, reservoir objects, item actions, and deletion/removal. They default absent and require explicit saved character choices. The server can disable them with `fluid_anatomy_enabled = false` in `[gs13_configuration]`. Initial support covers ordinary human anatomy with the appropriate organic parent body part; specialized species, external body rendering, and full inherited interaction systems remain open.

The GS13 editor supplies next-spawn presence, sizes, arrangement, lactation, and fluid choices. A separate live production/collection switch defaults off. Source-supported products with native reagent adapters are selectable; the two source products without native chemistry are not offered yet. Birth configuration creates independent DNA defaults. Those defaults survive DNA cloning/serialization/body changes; the recipient never inherits another physical organ's modified fluid type or stored dose. Ordinary appearance refreshes do not regrow an absent organ. Live next-spawn edits do not overwrite a current organ's state.

Breast reservoirs use `size * arrangement multiplier * 60`, capped at 3500 units, and begin empty. Pair/quadruple/sextuple multipliers are 2/2.5/3. Testicular reservoirs use `size * 20` and begin full of the source fluid. Vaginal reservoirs retain their empty ten-unit initial state. Reducing a reservoir removes all excess mixed fluid, avoiding the source's removal of only its currently selected product. Actual volume, free space, and finite inputs bound production and sampling.

Lactating breast organs produce five percent of their capacity per second through the native two-second life tick, only for a living online owner with production enabled and an intact installed organ. The shared bounded production API is also available to future inherited consumers. Broader arousal/release mechanics are not supplied by this checkpoint. Sampling uses an owner-only native organ action and an open container in the active hand: one interruptible second per dose, up to ten units or actual free space. Removal, opt-out, incapacitation, container swaps/lids, and completion stop it.

Neutron's actual native overdose path changes `internal_fluid_datum` on the three existing organs and enables breast lactation. It creates no absent organs, replaces no already stored fluid, and rewrites no DNA defaults. The product remains changed after the drink is metabolized/removed, ordinary appearance updates, native repair, death/revival, and organ transplantation. Temporary mass, light, and normal weight/chemical preferences remain independent.

The original source object sheets are copied unchanged from `modular_skyrat/master_files/icons/obj/genitals/{breasts,testicles,vagina}.dmi` into `modular_gs/icons/upstream/fluid_organs/`. Source breast-milk and reproductive-fluid IDs use native consumable reagents and neutral sample/glass descriptions.

Thirteen integration tests cover default/serialized preferences, native creation/actions/artwork, source initial capacities/content, the real overdose threshold path and persistent state, absent organs, production gates, mixed and fractional-fluid capacity reduction, sampling/lids/ownership, the real timed item-action trigger, transplantation, DNA and physical-state separation, live preference edits, all available products, server configuration, and body deletion during collection. Checkpoint `92f78358cbdc7a083c098dbe15efa7d4d06042fc` passed 237 focused / 292 full native tests. The following combined checkpoint `123d45d8de36fab75ecdd92f65f2f4c738638b25` passed 246 focused / 301 full native tests, zero compiler errors/warnings, UI checks, and live MariaDB in [run 40166809588](https://github.com/bobatochaps/Paradisefunnything/actions/runs/40166809588).

## Remaining gates

External organ rendering, full body-part size/color/layer customization, specialized species, unsupported source products, inherited arousal/release/interactions, and direct player SQL/client gameplay checks remain open. This record does not establish complete anatomy or GS13 parity.

The [validated cloning adapter](persistence.md) additionally restores scan-time body policy and exercises the real staged limb-growth/ejection cycle while preserving native organ identity. Combined checkpoint `e3b038775cef81c76c0de22e92f77e7c96bcbe2c` passed 259 focused / 314 full native tests with clean compilation, UI checks, and live MariaDB in [run 40168066763](https://github.com/bobatochaps/Paradisefunnything/actions/runs/40168066763).

## Weight-driven reservoir candidate

The reviewed source `update_size_from_weight` contract now reaches actual breast reservoirs: current size is the organ's birth base plus the native apparent-weight stage, bounded by its maximum and the native size limit of 80. Capacity still uses its source arrangement multiplier and sixty units per size, with the existing 3500-unit ceiling. Ordinary fat, apparent concealment, and Neutron/blueberry mass therefore feed the same stage contract. This changes the actual existing organ and its available production capacity; it adds no external breast rendering.

The source `max_breast_size` preference defaults to 80 and supports a live 0-to-80 maximum. A maximum below the birth base wins, and zero is a real zero-capacity limit. Live editing updates the actual organ and that specific creation-DNA constraint without incrementing the anatomy-rebuild revision or overwriting product, lactation, birth base, or unrelated DNA. Excess mixed fluid is removed proportionally through native reagent lifecycle calls. Ordinary appearance updates retain the same organ and its persistent Neutron alteration. Future DNA-created anatomy inherits the chosen maximum and birth chemistry, not active fluid chemistry.

Native ownership limits automatic updates to the installed organ. An extracted organ is no longer resized by its former body's weight; transplantation uses the new owner's subsequent native weight processing while retaining physical product/base state. Three additional integration tests cover normal gain/loss, actual Neutron temporary mass, live mixed-fluid reduction and DNA copying, transplanted growth, zero capacity, revival, and malformed maximums. Native validation is pending.
