// Adapted from GS13. Source sprites by greeenwoman.
/obj/item/portable_blender
	name = "portable blender"
	desc = "A portable food blender. Activate it in hand to remove the container. It only grinds food."
	icon = 'modular_gs/icons/obj/items/blender.dmi'
	icon_state = "blender"
	new_attack_chain = TRUE
	var/obj/item/reagent_containers/loaded_reagent_container
	var/starting_container = /obj/item/reagent_containers/glass/beaker/large
	var/blending = FALSE

/obj/item/portable_blender/Initialize(mapload)
	. = ..()
	if(ispath(starting_container))
		set_container(new starting_container(src))
	var/obj/machinery/iv_drip/feeding_tube/tube = loc
	if(istype(tube))
		tube.insert_blender(src)

/obj/item/portable_blender/Destroy()
	var/obj/item/reagent_containers/old_container = loaded_reagent_container
	set_container(null)
	QDEL_NULL(old_container)
	return ..()

/obj/item/portable_blender/update_overlays()
	. = ..()
	if(loaded_reagent_container)
		. += "blender-beaker"

/obj/item/portable_blender/proc/set_container(obj/item/reagent_containers/container)
	if(loaded_reagent_container)
		UnregisterSignal(loaded_reagent_container, list(COMSIG_MOVABLE_MOVED, COMSIG_PARENT_QDELETING))
	loaded_reagent_container = container
	if(container)
		RegisterSignal(container, list(COMSIG_MOVABLE_MOVED, COMSIG_PARENT_QDELETING), PROC_REF(on_container_changed))
	update_icon(UPDATE_OVERLAYS)
	SEND_SIGNAL(src, COMSIG_GS13_BLENDER_CONTAINER_CHANGED)

/obj/item/portable_blender/proc/on_container_changed(datum/source)
	SIGNAL_HANDLER
	if(QDELETED(loaded_reagent_container) || loaded_reagent_container.loc != src)
		set_container(null)

/obj/item/portable_blender/proc/can_operate(mob/living/user)
	if(!istype(user) || QDELETED(user) || user.incapacitated() || HAS_TRAIT(user, TRAIT_HANDS_BLOCKED) || !user.IsAdvancedToolUser())
		return FALSE
	if(istype(loc, /obj/machinery/iv_drip/feeding_tube))
		return isturf(loc.loc) && user.Adjacent(loc)
	return (loc == user || isturf(loc)) && user.Adjacent(src)

/obj/item/portable_blender/proc/can_blend(obj/item/food/food, mob/living/user)
	if(QDELETED(src) || !can_operate(user) || !istype(food) || QDELETED(food) || food.loc != user)
		return FALSE
	if((user.get_active_hand() != food && user.get_inactive_hand() != food) || (food.flags & NODROP) || !food.reagents?.total_volume)
		return FALSE
	return !QDELETED(loaded_reagent_container) && loaded_reagent_container.loc == src && loaded_reagent_container.reagents.total_volume < loaded_reagent_container.reagents.maximum_volume

/// The installed machine skips the delay, but never the inventory or distance checks.
/obj/item/portable_blender/proc/insert_food(obj/item/food/food, mob/living/user, instant = FALSE)
	if(blending || !can_blend(food, user))
		return FALSE
	var/obj/item/reagent_containers/original_container = loaded_reagent_container
	blending = TRUE
	playsound(src, 'sound/machines/blender.ogg', 50, TRUE)
	var/completed = instant || do_after(user, max(food.reagents.total_volume * 0.25, 2), target = src)
	blending = FALSE
	if(!completed || original_container != loaded_reagent_container || !can_blend(food, user))
		return FALSE
	if(!food.reagents.trans_to(original_container, food.reagents.total_volume))
		return FALSE
	// A full beaker must not destroy the untransferred portion of a meal.
	if(!QDELETED(food) && !food.reagents.total_volume)
		qdel(food)
	to_chat(user, SPAN_NOTICE("You blend the food into [original_container]."))
	SEND_SIGNAL(src, COMSIG_GS13_BLENDER_CONTAINER_CHANGED)
	return TRUE

/obj/item/portable_blender/item_interaction(mob/living/user, obj/item/used, list/modifiers)
	if(!can_operate(user) || used.loc != user || (user.get_active_hand() != used && user.get_inactive_hand() != used))
		return ITEM_INTERACT_COMPLETE
	if(istype(used, /obj/item/food))
		insert_food(used, user)
		return ITEM_INTERACT_COMPLETE
	if(istype(used, /obj/item/reagent_containers))
		var/obj/item/reagent_containers/container = used
		if(!loaded_reagent_container && (container.container_type & OPENCONTAINER) && user.transfer_item_to(container, src))
			set_container(container)
		return ITEM_INTERACT_COMPLETE
	return ..()

/obj/item/portable_blender/proc/eject_container(mob/living/user)
	if(!can_operate(user) || loc != user || !loaded_reagent_container)
		return FALSE
	var/obj/item/reagent_containers/container = loaded_reagent_container
	set_container(null)
	container.forceMove(get_turf(user))
	user.put_in_hands(container)
	return TRUE

/obj/item/portable_blender/activate_self(mob/living/user)
	if(..())
		return ITEM_INTERACT_COMPLETE
	eject_container(user)
	return ITEM_INTERACT_COMPLETE

/obj/item/portable_blender/attack_hand(mob/user)
	if(user.get_inactive_hand() == src && eject_container(user))
		return
	return ..()
