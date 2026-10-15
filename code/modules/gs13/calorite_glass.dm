// Calorite glass uses native alloys, window construction, and projectile movement.
GLOBAL_LIST_INIT(calorite_glass_recipes, list(
	new /datum/stack_recipe/window("directional calorite window", /obj/structure/window/calorite/unanchored, time = 0.5 SECONDS, on_floor = TRUE, window_checks = TRUE),
	new /datum/stack_recipe/window("fulltile calorite window", /obj/structure/window/calorite/fulltile/unanchored, 2, time = 1 SECONDS, on_floor = TRUE, window_checks = TRUE),
	new /datum/stack_recipe("calorite glass shard", /obj/item/shard/calorite_glass),
))

/obj/item/stack/sheet/calorite_glass
	name = "calorite glass"
	desc = "A soft, orange alloy of calorite and glass."
	icon = 'modular_gs/icons/obj/stack_objects.dmi'
	icon_state = "sheet-calorite_glass"
	inhand_icon_state = "sheet-glass"
	singular_name = "calorite glass sheet"
	resistance_flags = ACID_PROOF
	armor = list(MELEE = 0, BULLET = 0, LASER = 0, ENERGY = 0, BOMB = 0, RAD = 0, FIRE = 50, ACID = 100)
	materials = list(MAT_CALORITE = MINERAL_MATERIAL_AMOUNT, MAT_GLASS = MINERAL_MATERIAL_AMOUNT / 2)
	merge_type = /obj/item/stack/sheet/calorite_glass
	created_window = /obj/structure/window/calorite
	full_window = /obj/structure/window/calorite/fulltile

/obj/item/stack/sheet/calorite_glass/Initialize(mapload, new_amount, merge)
	. = ..()
	recipes = GLOB.calorite_glass_recipes
	AddComponent(/datum/component/fattening, 1, FATTENING_TYPE_ITEM)

/obj/item/stack/sheet/calorite_glass/five
	amount = 5

/obj/item/stack/sheet/calorite_glass/ten
	amount = 10

/obj/item/stack/sheet/calorite_glass/fifty
	amount = 50

/obj/item/shard/calorite_glass
	name = "orange shard"
	desc = "A sharp shard of calorite glass."
	force = 4
	throwforce = 9
	damtype = FAT
	icon = 'modular_gs/icons/obj/debris.dmi'
	icon_state = "calorite_large"
	icon_prefix = "calorite_"
	inhand_icon_state = "shard_calorite"
	lefthand_file = 'modular_gs/icons/mob/inhands/melee_lefthand.dmi'
	righthand_file = 'modular_gs/icons/mob/inhands/melee_righthand.dmi'
	materials = list(MAT_CALORITE = MINERAL_MATERIAL_AMOUNT, MAT_GLASS = MINERAL_MATERIAL_AMOUNT / 2)
	welded_type = /obj/item/stack/sheet/calorite_glass

/obj/item/shard/calorite_glass/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/fattening, 1, FATTENING_TYPE_ITEM, bumped = FALSE)

/datum/design/calorite_glass
	name = "Calorite Glass"
	desc = "Calorite infused glass for windows and optical reflectors."
	id = "calorite_glass"
	build_type = AUTOLATHE | SMELTER | PROTOLATHE
	materials = list(MAT_CALORITE = MINERAL_MATERIAL_AMOUNT, MAT_GLASS = MINERAL_MATERIAL_AMOUNT / 2)
	build_path = /obj/item/stack/sheet/calorite_glass
	category = list("initial", "Construction", "Stock Parts")
	maxstack = MAX_STACK_SIZE

/obj/structure/window/calorite
	name = "calorite window"
	desc = "A window made from a calorite-silicate alloy. Passing lasers acquire calorite energy."
	icon = 'modular_gs/icons/obj/structure/structures.dmi'
	icon_state = "calorite_window"
	armor = list(MELEE = 10, BULLET = 0, LASER = 0, ENERGY = 0, BOMB = 0, RAD = 0, FIRE = 80, ACID = 100)
	max_integrity = 30
	glass_type = /obj/item/stack/sheet/calorite_glass
	shardtype = /obj/item/shard/calorite_glass

/obj/structure/window/calorite/Initialize(mapload, direct)
	. = ..()
	AddComponent(/datum/component/fattening, 5, FATTENING_TYPE_ITEM, item_touch = TRUE)
	var/static/list/optical_connections = list(
		COMSIG_ATOM_ENTERED = PROC_REF(on_beam_entered),
		COMSIG_ATOM_EXITED = PROC_REF(on_beam_exited),
	)
	AddElement(/datum/element/connect_loc, optical_connections)

/obj/structure/window/calorite/proc/on_beam_entered(datum/source, atom/movable/entering, atom/old_loc)
	SIGNAL_HANDLER
	if(!istype(entering, /obj/projectile/beam) || source != loc || !isturf(loc) || entering.loc != loc || !isturf(old_loc) || old_loc.z != z || get_dist(old_loc, src) != 1)
		return
	if(fulltile || (get_dir(src, old_loc) & dir))
		var/obj/projectile/beam/beam = entering
		if(beam.checkpass(PASSGLASS))
			beam.amplify_calorite()

/obj/structure/window/calorite/proc/on_beam_exited(datum/source, atom/movable/leaving)
	SIGNAL_HANDLER
	// Exited has committed the movement; use the projectile's actual destination.
	if(fulltile || !istype(leaving, /obj/projectile/beam) || source != loc || !isturf(loc) || !isturf(leaving.loc) || leaving.z != z || get_dist(leaving, src) != 1)
		return
	if(get_dir(src, leaving) & dir)
		var/obj/projectile/beam/beam = leaving
		if(beam.checkpass(PASSGLASS))
			beam.amplify_calorite()

/obj/structure/window/calorite/unanchored
	anchored = FALSE

/obj/structure/window/calorite/fulltile
	name = "full tile calorite window"
	icon = 'modular_gs/icons/obj/structure/window_calorite.dmi'
	icon_state = "window-0"
	base_icon_state = "window"
	fulltile = TRUE
	dir = FULLTILE_WINDOW_DIR
	level = 3
	flags = PREVENT_CLICK_UNDER
	smoothing_flags = SMOOTH_BITMASK
	smoothing_groups = list(SMOOTH_GROUP_WINDOW_FULLTILE, SMOOTH_GROUP_REGULAR_WALLS, SMOOTH_GROUP_REINFORCED_WALLS)
	canSmoothWith = list(SMOOTH_GROUP_AIRLOCK, SMOOTH_GROUP_WINDOW_FULLTILE, SMOOTH_GROUP_WALLS)
	glass_amount = 2
	max_integrity = 60

/obj/structure/window/calorite/fulltile/unanchored
	anchored = FALSE

/obj/projectile/proc/amplify_calorite()
	if(!isnum(fat_added) || !GS13_IS_FINITE(fat_added))
		return
	fat_added = min(max(fat_added + 25, fat_added * 1.1), 5000 + initial(fat_added))

/obj/structure/reflector/single/calorite
	name = "calorite reflector"
	desc = "An angled calorite mirror that adds calorite energy to reflected lasers."
	icon = 'modular_gs/icons/obj/structure/structures.dmi'
	icon_state = "calorite_reflector"
	build_stack_type = /obj/item/stack/sheet/calorite_glass
	build_stack_amount = 5

/obj/structure/reflector/single/calorite/anchored
	anchored = TRUE

/obj/structure/reflector/single/calorite/bullet_act(obj/projectile/projectile)
	. = ..()
	if(. == -1 && !QDELETED(projectile))
		projectile.amplify_calorite()
