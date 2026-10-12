// Calorite construction uses Paradise's stack recipes, turfs, and MILLA connectivity.
GLOBAL_LIST_INIT(calorite_recipes, list(
	new /datum/stack_recipe("calorite tile", /obj/item/stack/tile/mineral/calorite, 1, 4, 20),
	new /datum/stack_recipe("calorite statue", /obj/structure/statue/calorite/fatty, 5, time = 10 SECONDS, one_per_turf = TRUE, on_floor = TRUE),
	new /datum/stack_recipe("calorite door", /obj/structure/mineral_door/calorite, 5, time = 5 SECONDS, one_per_turf = TRUE, on_floor = TRUE)))

/turf/simulated/wall/mineral/calorite
	name = "calorite wall"
	desc = "A wall with calorite plating."
	icon = 'modular_gs/icons/turf/calorite_wall.dmi'
	icon_state = "calorite_wall-0"
	base_icon_state = "calorite_wall"
	sheet_type = /obj/item/stack/sheet/mineral/calorite
	smoothing_groups = list(SMOOTH_GROUP_SIMULATED_TURFS, SMOOTH_GROUP_WALLS, SMOOTH_GROUP_CALORITE_WALLS)
	canSmoothWith = list(SMOOTH_GROUP_CALORITE_WALLS)

/turf/simulated/wall/mineral/calorite/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/fattening, 10, FATTENING_TYPE_ITEM, item_touch = TRUE)

/obj/structure/falsewall/calorite
	name = "calorite wall"
	desc = "A wall with calorite plating."
	icon = 'modular_gs/icons/turf/calorite_wall.dmi'
	icon_state = "calorite_wall-0"
	base_icon_state = "calorite_wall"
	open_icon = 'modular_gs/icons/turf/false_walls.dmi'
	open_icon_state = "calorite_wall-open"
	opening_icon_state = "calorite_wall-opening"
	closing_icon_state = "calorite_wall-closing"
	mineral = /obj/item/stack/sheet/mineral/calorite
	walltype = /turf/simulated/wall/mineral/calorite
	smoothing_groups = list(SMOOTH_GROUP_SIMULATED_TURFS, SMOOTH_GROUP_WALLS, SMOOTH_GROUP_CALORITE_WALLS)
	canSmoothWith = list(SMOOTH_GROUP_CALORITE_WALLS)

/obj/structure/falsewall/calorite/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/fattening, 10, FATTENING_TYPE_ITEM, item_touch = TRUE)

/turf/simulated/floor/mineral/calorite
	name = "calorite floor"
	icon = 'modular_gs/icons/turf/floors.dmi'
	icon_state = "calorite"
	floor_tile = /obj/item/stack/tile/mineral/calorite
	icons = list("calorite")
	var/fat_to_add = 10

/turf/simulated/floor/mineral/calorite/Entered(atom/movable/entered, atom/old_loc)
	. = ..()
	if(iscarbon(entered))
		var/mob/living/carbon/subject = entered
		subject.adjust_fatness(fat_to_add, FATTENING_TYPE_ITEM)

/turf/simulated/floor/mineral/calorite/get_broken_states()
	return list("calorite_dam")

/turf/simulated/floor/mineral/calorite/get_burnt_states()
	return list(mutable_appearance('icons/turf/floors.dmi', "floorscorched1"), mutable_appearance('icons/turf/floors.dmi', "floorscorched2"))

/turf/simulated/floor/mineral/calorite/hide
	name = "steel floor"
	icon_state = "calorite_hide"
	floor_tile = /obj/item/stack/tile/mineral/calorite/hide
	icons = list("calorite_hide")

/turf/simulated/floor/mineral/calorite/strong
	name = "infused calorite floor"
	icon_state = "calorite_strong"
	floor_tile = /obj/item/stack/tile/mineral/calorite/strong
	icons = list("calorite_strong")
	fat_to_add = 40

/turf/simulated/floor/mineral/calorite/dance
	name = "calorite dance floor"
	icon_state = "calorite_dance"
	floor_tile = /obj/item/stack/tile/mineral/calorite/dance
	icons = list("calorite_dance")

/obj/item/stack/tile/mineral/calorite
	name = "calorite tile"
	singular_name = "calorite floor tile"
	desc = "A floor tile made from calorite."
	icon = 'modular_gs/icons/obj/tiles.dmi'
	icon_state = "tile_calorite"
	turf_type = /turf/simulated/floor/mineral/calorite
	mineralType = "calorite"
	materials = list(MAT_CALORITE = 500)
	merge_type = /obj/item/stack/tile/mineral/calorite

/obj/item/stack/tile/mineral/calorite/hide
	name = "floor tile"
	desc = "A tile that looks like steel."
	icon_state = "tile"
	turf_type = /turf/simulated/floor/mineral/calorite/hide
	merge_type = /obj/item/stack/tile/mineral/calorite/hide

/obj/item/stack/tile/mineral/calorite/strong
	name = "infused calorite tile"
	singular_name = "infused calorite floor tile"
	icon_state = "tile_calorite_strong"
	turf_type = /turf/simulated/floor/mineral/calorite/strong
	merge_type = /obj/item/stack/tile/mineral/calorite/strong

/obj/item/stack/tile/mineral/calorite/dance
	name = "calorite dance floor tile"
	icon_state = "tile_calorite_dance"
	turf_type = /turf/simulated/floor/mineral/calorite/dance
	merge_type = /obj/item/stack/tile/mineral/calorite/dance

/obj/structure/mineral_door/calorite
	name = "calorite door"
	icon = 'modular_gs/icons/obj/structure/calorite_door.dmi'
	icon_state = "calorite"
	sheetType = /obj/item/stack/sheet/mineral/calorite
	sheetAmount = 5
	max_integrity = 200
	light_range = 1
	density = FALSE
	opacity = FALSE
	state_open = TRUE

/obj/structure/mineral_door/calorite/Initialize(mapload)
	. = ..()
	// Listen on the doorway's turf, not the door's own contents.
	var/list/connections = list(COMSIG_ATOM_ENTERED = PROC_REF(on_entered))
	AddElement(/datum/element/connect_loc, connections)
	update_icon(UPDATE_ICON_STATE)

/obj/structure/mineral_door/calorite/proc/on_entered(datum/source, atom/movable/entered)
	SIGNAL_HANDLER
	if(!state_open || !iscarbon(entered))
		return
	var/mob/living/carbon/subject = entered
	if(subject.fatness < FATNESS_LEVEL_FAT || subject.AmountFatStunned())
		return
	var/stuck_delay = 0.5 SECONDS
	if(subject.fatness >= FATNESS_LEVEL_BARELYMOBILE)
		stuck_delay = 12 SECONDS
	else if(subject.fatness > FATNESS_LEVEL_FATTER)
		stuck_delay = 5 SECONDS
	else if(subject.fatness > FATNESS_LEVEL_FAT)
		stuck_delay = 1.5 SECONDS
	if(subject.FatStun(stuck_delay, fatAmount = 2))
		subject.visible_message(SPAN_NOTICE("[subject] gets stuck in the calorite doorway!"), SPAN_WARNING("Your sides catch against the calorite doorway!"))

/obj/structure/statue/calorite
	name = "calorite statue"
	desc = "A statue made from calorite."
	icon = 'modular_gs/icons/obj/structure/statue.dmi'
	icon_state = "pillar"
	max_integrity = 200
	material_drop_type = /obj/item/stack/sheet/mineral/calorite

/obj/structure/statue/calorite/pillar
	name = "calorite pillar"
	desc = "A support pillar made from calorite."
	max_integrity = 400
	anchored = TRUE

/obj/structure/statue/calorite/fatty
	name = "fatty statue"
	desc = "A calorite statue of a well-rounded figure."
	icon_state = "fatty"
	var/last_beckon = 0
	var/datum/proximity_monitor/gs13_proximity_monitor

/obj/structure/statue/calorite/fatty/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/fattening, 75, FATTENING_TYPE_ITEM, item_touch = TRUE)
	gs13_proximity_monitor = new(src, 1)

/obj/structure/statue/calorite/fatty/Destroy()
	QDEL_NULL(gs13_proximity_monitor)
	return ..()

/obj/structure/statue/calorite/fatty/attack_hand(mob/user)
	. = ..()
	// Paradise's statue parent handles the hand interaction without emitting this.
	SEND_SIGNAL(src, COMSIG_ATOM_ATTACK_HAND, user)

/obj/structure/statue/calorite/fatty/HasProximity(atom/movable/entered)
	beckon()

/obj/structure/statue/calorite/fatty/proc/beckon()
	if(world.time < last_beckon + 1.5 SECONDS)
		return
	last_beckon = world.time
	for(var/mob/living/carbon/human/subject in orange(3, src))
		if(subject.check_weight_prefs(FATTENING_TYPE_ITEM))
			to_chat(subject, SPAN_NOTICE("The calorite statue seems to beckon you closer."))

/obj/structure/statue/calorite/fatty/fattha
	name = "statue of a sitting fatty"
	desc = "A sitting figure carved from calorite."
	icon_state = "fattha_statue"
	anchored = TRUE

/obj/structure/statue/calorite/fatty/huge
	name = "Monument to Hedonism"
	desc = "A sprawling monument carved from calorite."
	icon = 'modular_gs/icons/obj/structure/statue_64x64.dmi'
	icon_state = "hugecalorite"
	oreAmount = 15
	max_integrity = 600
	anchored = TRUE
	pixel_x = -16
	pixel_y = -16
