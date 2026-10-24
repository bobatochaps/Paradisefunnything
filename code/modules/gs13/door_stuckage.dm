// GS13 stuckage.dm adapted to native movement and structural damage.
// A body snapshot supplies preferences even without an attached client.
/mob/living/carbon/proc/gs13_door_stuck_chance()
	var/threshold = gs13_preferences["stuckage"]
	var/custom_chance = gs13_preferences["stuckage_custom"]
	if(HAS_TRAIT(src, TRAIT_HELPLESS_STUCKAGE))
		threshold = FATNESS_LEVEL_EXTREMELY_OBESE
		custom_chance = 0
	if(threshold <= 0 || fatness <= threshold)
		return 0
	if(custom_chance > 0)
		return clamp(custom_chance, 0, 100)
	return fatness > 2 * threshold ? 66 : 40

/datum/component/gs13_door_stuckage
	dupe_mode = COMPONENT_DUPE_UNIQUE
	var/turf/listening_turf

/datum/component/gs13_door_stuckage/Initialize()
	if(!istype(parent, /obj/machinery/door) && !istype(parent, /obj/structure/mineral_door))
		return COMPONENT_INCOMPATIBLE

/datum/component/gs13_door_stuckage/RegisterWithParent()
	RegisterSignal(parent, COMSIG_MOVABLE_MOVED, PROC_REF(on_door_moved))
	update_location()

/datum/component/gs13_door_stuckage/UnregisterFromParent()
	UnregisterSignal(parent, COMSIG_MOVABLE_MOVED)
	if(listening_turf)
		UnregisterSignal(listening_turf, COMSIG_ATOM_EXIT)
	listening_turf = null

/datum/component/gs13_door_stuckage/Destroy(force = FALSE, silent = FALSE)
	UnregisterFromParent()
	return ..()

/datum/component/gs13_door_stuckage/proc/on_door_moved(datum/source)
	SIGNAL_HANDLER
	update_location()

/datum/component/gs13_door_stuckage/proc/update_location()
	if(listening_turf)
		UnregisterSignal(listening_turf, COMSIG_ATOM_EXIT)
	var/obj/door = parent
	listening_turf = isturf(door.loc) ? door.loc : null
	if(listening_turf)
		RegisterSignal(listening_turf, COMSIG_ATOM_EXIT, PROC_REF(on_attempt_exit))

/datum/component/gs13_door_stuckage/proc/on_attempt_exit(datum/source, atom/movable/leaving, direction)
	SIGNAL_HANDLER
	var/obj/door = parent
	if(QDELETED(door) || source != listening_turf || door.loc != source || !iscarbon(leaving) || leaving.loc != source || door.density)
		return
	// Border doors only occupy their glazed edge; moving alongside one is free.
	if((door.flags & ON_BORDER) && direction != door.dir)
		return
	var/mob/living/carbon/subject = leaving
	var/chance = subject.gs13_door_stuck_chance()
	if(!chance || !prob(chance))
		return
	subject.visible_message(SPAN_WARNING("[subject] gets stuck in the doorway!"), SPAN_WARNING("Your sides catch in the doorway as you try to squeeze through!"))
	subject.Shake(1, 1, 0.1 SECONDS)
	// Native damage preserves indestructibility, armor, and destruction cleanup.
	door.take_damage(1, BRUTE, sound_effect = FALSE)
	return COMPONENT_ATOM_BLOCK_EXIT
