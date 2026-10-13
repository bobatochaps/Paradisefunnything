// The GS13 pendant conceals both weight channels until its binding is broken.
// It uses Paradise's neck slot and action system, without the life-linked parent.
/obj/item/clothing/neck/necklace/memento_mori/calori
	parent_type = /obj/item/clothing/neck/necklace
	name = "Memento Calori"
	desc = "A mysterious pendant. An inscription on it says: \"Certain obesity tomorrow means certain fitness today.\""
	icon = 'modular_gs/icons/obj/clothing/neck.dmi'
	worn_icon = 'modular_gs/icons/mob/clothing/neck.dmi'
	icon_state = "memento_calori"
	worn_icon_state = "memento_calori"
	actions_types = list(/datum/action/item_action/gs13_memento_calori)
	resistance_flags = INDESTRUCTIBLE | LAVA_PROOF | FIRE_PROOF | UNACIDABLE | ACID_PROOF
	var/mob/living/carbon/human/active_owner
	/// Native UIDs preserve one-use-per-body behavior without retaining deleted mobs.
	var/list/past_users = list()
	var/binding = FALSE

/obj/item/clothing/neck/necklace/memento_mori/calori/sprinkled
	icon_state = "memento_calori_sprinkled"

/obj/item/clothing/neck/necklace/memento_mori/calori/item_action_slot_check(slot, mob/user)
	return slot == ITEM_SLOT_NECK

/obj/item/clothing/neck/necklace/memento_mori/calori/ui_action_click(mob/user, actiontype)
	return memento(user)

/obj/item/clothing/neck/necklace/memento_mori/calori/proc/can_bind(mob/living/carbon/human/user)
	return !QDELETED(src) && istype(user) && !QDELETED(user) && user.neck == src && loc == user && !active_owner && !(user.UID() in past_users)

/obj/item/clothing/neck/necklace/memento_mori/calori/proc/memento(mob/living/carbon/human/user)
	if(binding || !can_bind(user))
		return FALSE
	binding = TRUE
	to_chat(user, SPAN_WARNING("You feel your weight being drawn into the pendant..."))
	var/completed = do_after(user, 4 SECONDS, target = user)
	binding = FALSE
	if(!completed)
		return FALSE
	return bind_owner(user)

/// Recheck ownership after the interruptible binding delay.
/obj/item/clothing/neck/necklace/memento_mori/calori/proc/bind_owner(mob/living/carbon/human/user)
	if(!can_bind(user))
		return FALSE
	active_owner = user
	past_users |= user.UID()
	RegisterSignal(src, COMSIG_MOVABLE_MOVED, PROC_REF(on_moved))
	RegisterSignal(user, COMSIG_PARENT_QDELETING, PROC_REF(on_owner_deleted))
	user.hider_add(src)
	icon_state = "[initial(icon_state)]_active"
	worn_icon_state = "[initial(worn_icon_state)]_active"
	user.update_inv_neck()
	for(var/datum/action/action as anything in actions)
		action.Remove(user)
	to_chat(user, SPAN_NOTICE("Your weight is linked to the pendant. Removing it will restore your concealed weight and add more. This pendant can only bind to you once."))
	return TRUE

/obj/item/clothing/neck/necklace/memento_mori/calori/proc/fat_hide(mob/living/carbon/user)
	if(user != active_owner)
		return 0
	return -(user.fatness_real + user.fatness_perma)

/obj/item/clothing/neck/necklace/memento_mori/calori/proc/mori()
	icon_state = initial(icon_state)
	worn_icon_state = initial(worn_icon_state)
	if(!active_owner)
		return
	var/mob/living/carbon/human/stored_owner = active_owner
	active_owner = null // Clear first so removal cannot charge the penalty twice.
	UnregisterSignal(src, COMSIG_MOVABLE_MOVED)
	UnregisterSignal(stored_owner, COMSIG_PARENT_QDELETING)
	if(QDELETED(stored_owner))
		return
	stored_owner.hider_remove(src)
	if(!(stored_owner.status_flags & GODMODE))
		stored_owner.adjust_fatness(FATNESS_LEVEL_OBESE, FATTENING_TYPE_MAGIC, TRUE)
		stored_owner.adjust_perma(FATNESS_LEVEL_OBESE, FATTENING_TYPE_MAGIC, TRUE)
	stored_owner.update_inv_neck()
	to_chat(stored_owner, SPAN_WARNING("Your weight returns as your link to the pendant breaks!"))

/obj/item/clothing/neck/necklace/memento_mori/calori/proc/on_moved(datum/source)
	SIGNAL_HANDLER
	if(active_owner && loc != active_owner)
		mori()

/obj/item/clothing/neck/necklace/memento_mori/calori/proc/on_owner_deleted(datum/source)
	SIGNAL_HANDLER
	mori()

/obj/item/clothing/neck/necklace/memento_mori/calori/equipped(mob/user, slot, initial = FALSE)
	. = ..()
	if(active_owner && (user != active_owner || slot != ITEM_SLOT_NECK))
		mori()

/obj/item/clothing/neck/necklace/memento_mori/calori/dropped(mob/user, silent = FALSE)
	mori()
	return ..()

/obj/item/clothing/neck/necklace/memento_mori/calori/Destroy()
	mori()
	past_users.Cut()
	return ..()

/datum/action/item_action/gs13_memento_calori
	name = "Memento Calori"
	desc = "Bind your weight to the pendant. Once removed, it cannot bind to you again."
	check_flags = NONE

/datum/uplink_item/adipowarfare/memento_calori
	name = "Memento Calori"
	desc = "A pendant that conceals ordinary and permanent weight while bound to its wearer. Removing it restores that weight and adds more. Each wearer can bind to it once."
	item = /obj/item/clothing/neck/necklace/memento_mori/calori/sprinkled
	reference = "GSMEM"
	cost = 2
