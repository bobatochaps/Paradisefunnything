# GS13 attribution

Adapted from sheepishgoat/GS13-Blubberstation at ec3ad13bd34b64451813004e32892d49de745404. Original authors retain their copyrights. Code is AGPL-3.0; see LICENSE-AGPLv3.txt. Icons retain the source CC-BY-SA-3.0 license; see LICENSE-CC-BY-SA-3.0.txt. Modular icons retain their source paths. Source base-code baton, energy-gun, and 64x64 in-hand icons are copied unchanged under `modular_gs/icons/upstream/` to avoid overwriting Paradise assets. The weight-analyzer and portable-blender artwork is credited in source to greeenwoman. The fattening interaction component is credited in source to Swan. The Caloray is credited in source to WG13 and M16nPregnant for its concept and backbone. Full original attribution is available in the source repository and its commit history.

Collar behavior is adapted from GS13 `modular_gs/code/clothing/{calorite_collar,bluespace_collar}.dm` and its inherited Skyrat `modules/customization/modules/clothing/neck/collars.dm`. The unchanged Skyrat GAGS collar sheet is preserved as `modular_gs/icons/upstream/gs13_collar.dmi`; GS13 calorite collar sheets and gurgle sounds retain their source paths. Layer colors match the original GAGS JSON configurations.

The turbo nutriment pump and mobility nanite core are adapted from GS13 `modular_gs/code/modules/surgery/organs/augments.dm` and its nutritional research designs, with native Paradise implant assets.

Hydraulic assistance and calovoltaic MOD modules are adapted from GS13 `modular_gs/code/modules/mod/modules/modules_fat.dm`; additive/multiplicative movement modifiers follow its `modular_gs/code/modules/mob/living/species.dm`. The MOD module sheet is copied unchanged at its original `modular_gs/icons/obj/clothing/modsuit/mod_modules.dmi` path.

The exoskeleton suit is adapted from GS13 `modular_gs/code/modules/mod/mod_exoskeleton.dm`. Its object, worn, and plating sheets are copied unchanged at their original `modular_gs/icons/{obj,mob}/clothing/modsuit/` paths. The invisible worn variant uses Paradise's explicit blank effect state.

Gain, its teaching book, and the Wand of Gluttony are adapted from GS13 `modular_gs/code/modules/spells/spells_type/touch/add_weight.dm`, `modular_gs/code/game/objects/granters/magic/add_weight.dm`, and `modular_gs/code/modules/weapons/magic/wand.dm`. Original `magic.dmi`, `spell_items.dmi`, and `spellbooks.dmi` sheets are copied unchanged at their source paths. The touch spell uses Paradise's existing directional magic-hand animation; food models use native Paradise equivalents.

Fattening and belch traps, their conjuration spells, and their tomes are adapted from GS13 `modular_gs/code/mechanics/fattening_trap.dm`, `modular_gs/code/modules/spells/spells_type/conjure/traps.dm`, and `modular_gs/code/game/objects/granters/magic/traps.dm`, using Paradise's existing trap and conjuration foundations. The original `modular_gs/icons/obj/structure/traps.dmi` sheet is copied unchanged.

The five added necropolis chest rewards follow GS13 `code/game/objects/effects/spawners/random/mining_loot.dm`, retaining the native Paradise rewards and adapting the whip/book paths.

Calorite glass, shards, windows, and reflectors are adapted from GS13 `modular_gs/code/mechanics/calorite_glass.dm` and `modular_gs/code/game/objects/structures/{calorite_window,calorite_reflector}.dm`. The original `debris.dmi`, structure/window sheets, and left/right melee in-hand sheets are copied unchanged at their source paths.

Adipolipus/lipofruit and munchies weed are adapted from GS13 `modular_gs/code/modules/hydroponics/{lipoplant,munchies_weed}.dm`. The three original hydroponics icon sheets are copied unchanged under `modular_gs/icons/obj/hydroponics/`. Lipofruit’s coconut liqueur follows the inherited `code/modules/reagents/chemistry/reagents/drinks/alcohol_reagents.dm`, with native Paradise alcohol strength.

`icons/obj/drinks.dmi` is copied unchanged from the pinned GS13 source for cocktail glass artwork.

Directional vision is adapted from the same pinned source's inherited `code/modules/mob/living/living_fov.dm`, `code/datums/components/fov_handler.dm`, and `code/_onclick/hud/rendering/render_plate.dm`, together with GS13's helplessness rules. The original `icons/effects/fov/field_of_view.dmi` is copied unchanged to `modular_gs/icons/upstream/field_of_view.dmi`. The source repository now lives at `Gain-Station-13/GS13-Blubberstation` (repository ID 991425722); the pinned source revision and original authorship remain unchanged.

Volume-driven transformations follow `modular_gs/code/modules/reagents/chemistry/reagents/{blueberry,starshine}.dm`, its body-weight/hider contracts, and its saved blueberry preference. Paradise tracks the participating sources in `transformations.dm` and retains its own DNA, organs, color priorities, and native body rendering. The separate transformation color priority preserves native paints and temporary effects when the transformation clears.

Berrification and juice collection follow `modular_gs/code/datums/diseases/advance/symptoms/berry.dm`; blueberry crops follow `modular_gs/code/modules/hydroponics/grown/berries.dm`; Permaberry follows `modular_gs/code/datums/quirks/negative/negative_quirks.dm`. The crop artwork is part of the already preserved hydroponics sheets. The original `modular_gs/sound/effects/inflation/berryloop.ogg` is copied unchanged for the shared per-body infection loop.

Capacity and bursting follow `modular_gs/code/modules/reagents/chemistry/reagents/blueberry.dm`, `modular_gs/code/modules/mob/living/bursting.dm`, and their saved preference definitions. The original berry decal and inflation/creaking/sloshing/pop sounds retain their source paths. The WT collar follows `modular_gs/code/modules/berry/clothing/collar.dm`. Its original `modular_zubbers/icons/obj/clothing/GAGS/collar.dmi` is preserved at `modular_gs/icons/upstream/antiburst_collar.dmi`; native object/worn/in-hand composition follows the pinned Skyrat `GAGS/json_configs/collar/gps*.json` layers and source colors.

Starshine, its recipes, prefills, vendor, refill, and supply pack follow `modular_gs/code/modules/reagents/chemistry/reagents/starshine.dm`. The original `modular_gs/icons/obj/{starshine,vending,vending_restock}.dmi` sheets are copied unchanged. Native vendor overlays resolve both Paradise underscore and source hyphen state names. The remaining cyborg feeding choices now use the source blueberry and Starshine Neutron palette.
