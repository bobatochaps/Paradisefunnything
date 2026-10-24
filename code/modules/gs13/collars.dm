// GS13 collars, adapted to Paradise neck slots, internal storage and ingestion.
/obj/item/storage/internal/gs13_collar
	storage_slots = 1
	max_w_class = WEIGHT_CLASS_SMALL
	can_hold = list(/obj/item/food/cookie, /obj/item/key/collar)

/obj/item/clothing/neck/human_petcollar
	name = "pet collar"
	desc = "A collar with a name tag and a tiny pocket for a treat."
	icon = 'modular_gs/icons/upstream/gs13_collar.dmi'
	icon_state = "pet_collar_obj"
	w_class = WEIGHT_CLASS_SMALL
	new_attack_chain = TRUE
	var/obj/item/storage/internal/gs13_collar/pocket
	var/treat_path = /obj/item/food/cookie
	var/calorite_style = FALSE
	var/weight_gain_rate_modifier = 0

/obj/item/clothing/neck/human_petcollar/Initialize(mapload)
	. = ..()
	pocket = new(src, src)
	if(treat_path)
		new treat_path(pocket)
	ADD_TRAIT(src, TRAIT_ADJACENCY_TRANSPARENT, ROUNDSTART_TRAIT)
	// Reproduce the source GAGS layers once, retaining the original sprite sheets.
	var/static/list/collar_icons = list()
	var/style = calorite_style ? "calorite" : "pet"
	if(!collar_icons[style])
		var/icon/object_icon
		var/icon/body_icon
		if(calorite_style)
			object_icon = icon('modular_gs/icons/obj/clothing/cal_collar.dmi', "collar_recolorable")
			object_icon.Blend("#303030", ICON_MULTIPLY)
			object_icon.Blend(icon('modular_gs/icons/obj/clothing/cal_collar.dmi', "collar_obj_pendant"), ICON_OVERLAY)
			body_icon = icon('modular_gs/icons/mob/clothing/cal_collar.dmi', "collar_mob_recolorable")
			body_icon.Blend("#303030", ICON_MULTIPLY)
			body_icon.Blend(icon('modular_gs/icons/mob/clothing/cal_collar.dmi', "collar_mob_pendant"), ICON_OVERLAY)
		else
			object_icon = icon(icon, "pet_collar_obj")
			object_icon.Blend("#44BBEE", ICON_MULTIPLY)
			var/icon/tag = icon(icon, "pet_tag_obj")
			tag.Blend("#FFCC00", ICON_MULTIPLY)
			object_icon.Blend(tag, ICON_OVERLAY)
			body_icon = icon(icon, "pet_collar_mob")
			body_icon.Blend("#44BBEE", ICON_MULTIPLY)
			tag = icon(icon, "pet_tag_mob")
			tag.Blend("#FFCC00", ICON_MULTIPLY)
			body_icon.Blend(tag, ICON_OVERLAY)
		collar_icons[style] = list(object_icon, body_icon)
	var/list/sprites = collar_icons[style]
	icon = sprites[1]
	worn_icon = sprites[2]
	icon_state = ""
	worn_icon_state = ""

/obj/item/clothing/neck/human_petcollar/Destroy()
	QDEL_NULL(pocket)
	return ..()

/// Resolve inventory now; no retained wearer or equip-time preference snapshot.
/obj/item/clothing/neck/human_petcollar/proc/get_wearer()
	if(QDELETED(src) || !ishuman(loc))
		return null
	var/mob/living/carbon/human/wearer = loc
	if(!QDELETED(wearer) && wearer.neck == src)
		return wearer

/obj/item/clothing/neck/human_petcollar/proc/can_manipulate(mob/user)
	return !QDELETED(src) && isliving(user) && !user.incapacitated() && !HAS_TRAIT(user, TRAIT_HANDS_BLOCKED) && user.Adjacent(src) && (loc == user || isturf(loc) || get_wearer())

/obj/item/clothing/neck/human_petcollar/examine(mob/user)
	. = ..()
	. += SPAN_NOTICE("[gs13_activation_hint()] Drag it onto yourself to open its small pocket.")

/obj/item/clothing/neck/human_petcollar/proc/gs13_activation_hint()
	return "Activate it in hand to rename its tag."

/obj/item/clothing/neck/human_petcollar/activate_self(mob/user)
	if(..() || !can_manipulate(user))
		return ITEM_INTERACT_COMPLETE
	var/tagname = tgui_input_text(user, "What should the tag say?", "Collar tag", max_length = MAX_NAME_LEN)
	if(tagname && can_manipulate(user))
		name = "[initial(name)] - [sanitize(tagname)]"
	return ITEM_INTERACT_COMPLETE

/obj/item/clothing/neck/human_petcollar/MouseDrop(atom/over_object)
	if(over_object == usr && can_manipulate(usr))
		pocket.open(usr)

/obj/item/clothing/neck/human_petcollar/item_interaction(mob/living/user, obj/item/used, list/modifiers)
	if(!can_manipulate(user) || used.loc != user || (user.get_active_hand() != used && user.get_inactive_hand() != used))
		return ITEM_INTERACT_COMPLETE
	pocket.attackby__legacy__attackchain(used, user, modifiers)
	return ITEM_INTERACT_COMPLETE

/obj/item/clothing/neck/human_petcollar/equipped(mob/user, slot, initial = FALSE)
	. = ..()
	pocket?.update_viewers()

/obj/item/clothing/neck/human_petcollar/Moved(atom/oldloc, dir, forced = FALSE)
	. = ..()
	pocket?.update_viewers()

/obj/item/clothing/neck/human_petcollar/emp_act(severity)
	. = ..()
	pocket?.emp_act(severity)

/obj/item/key/collar
	name = "collar key"
	desc = "A key for the small lock on a collar."

/obj/item/clothing/neck/human_petcollar/locked
	name = "locking collar"
	desc = "A collar with a small lock to keep it from being removed."
	treat_path = /obj/item/key/collar
	var/locked = FALSE

/obj/item/clothing/neck/human_petcollar/locked/Initialize(mapload)
	. = ..()
	RegisterSignal(src, COMSIG_ITEM_PRE_UNEQUIP, PROC_REF(block_locked_removal))

/obj/item/clothing/neck/human_petcollar/locked/proc/block_locked_removal(datum/source)
	SIGNAL_HANDLER
	if(locked && get_wearer())
		return COMPONENT_ITEM_BLOCK_UNEQUIP

/obj/item/clothing/neck/human_petcollar/locked/canStrip(mob/stripper, mob/owner)
	return ..() && !(locked && get_wearer())

/obj/item/clothing/neck/human_petcollar/locked/item_interaction(mob/living/user, obj/item/used, list/modifiers)
	if(istype(used, /obj/item/key/collar))
		if(can_manipulate(user) && used.loc == user && (user.get_active_hand() == used || user.get_inactive_hand() == used))
			locked = !locked
			to_chat(user, SPAN_NOTICE("You [locked ? "lock" : "unlock"] [src]."))
		return ITEM_INTERACT_COMPLETE
	return ..()

/obj/item/clothing/neck/human_petcollar/locked/examine(mob/user)
	. = ..()
	. += SPAN_NOTICE("It is [locked ? "locked" : "unlocked"]. A collar key toggles the lock.")

/obj/item/clothing/neck/human_petcollar/calorite
	name = "calorite collar"
	desc = "A collar infused with calorite that increases its wearer's weight gain rate."
	calorite_style = TRUE
	weight_gain_rate_modifier = 0.5
	materials = list(MAT_METAL = 1000, MAT_CALORITE = 6000)

/obj/item/clothing/neck/human_petcollar/locked/calorite
	name = "locking calorite collar"
	desc = "A locking collar infused with calorite that increases its wearer's weight gain rate."
	calorite_style = TRUE
	weight_gain_rate_modifier = 0.5
	materials = list(MAT_METAL = 1000, MAT_CALORITE = 6000)

/mob/living/carbon/proc/gs13_equipment_gain_modifier()
	return 0

/mob/living/carbon/human/gs13_equipment_gain_modifier()
	var/obj/item/clothing/neck/human_petcollar/collar = neck
	if(istype(collar) && collar.get_wearer() == src && !(status_flags & GODMODE) && check_weight_prefs(FATTENING_TYPE_ITEM))
		return collar.weight_gain_rate_modifier
	return 0

/obj/item/clothing/neck/human_petcollar/locked/bluespace_collar_receiver
	name = "bluespace collar receiver"
	desc = "A collar that receives food and drink from linked transmitter collars directly into its wearer's stomach."
	calorite_style = TRUE
	materials = list(MAT_METAL = 1000, MAT_CALORITE = 2500, MAT_BLUESPACE = 250)

/obj/item/clothing/neck/human_petcollar/locked/bluespace_collar_receiver/proc/get_recipient()
	var/mob/living/carbon/human/wearer = get_wearer()
	if(wearer && wearer.reagents && !(wearer.status_flags & GODMODE) && wearer.check_weight_prefs(FATTENING_TYPE_ITEM))
		return wearer

/obj/item/clothing/neck/human_petcollar/locked/bluespace_collar_receiver/item_interaction(mob/living/user, obj/item/used, list/modifiers)
	if(istype(used, /obj/item/clothing/neck/human_petcollar/locked/bluespace_collar_transmitter))
		var/obj/item/clothing/neck/human_petcollar/locked/bluespace_collar_transmitter/transmitter = used
		if(used.loc == user && (user.get_active_hand() == used || user.get_inactive_hand() == used))
			transmitter.link_receiver(src, user)
		return ITEM_INTERACT_COMPLETE
	return ..()

/obj/item/clothing/neck/human_petcollar/locked/bluespace_collar_transmitter
	name = "bluespace collar transmitter"
	desc = "A collar that sends swallowed food and drink to a linked receiver collar."
	calorite_style = TRUE
	materials = list(MAT_METAL = 1000, MAT_CALORITE = 1000, MAT_BLUESPACE = 500)
	/// A UID does not keep a deleted receiver (or its former wearer) alive.
	var/linked_receiver_uid

/obj/item/clothing/neck/human_petcollar/locked/bluespace_collar_transmitter/proc/get_receiver()
	var/obj/item/clothing/neck/human_petcollar/locked/bluespace_collar_receiver/receiver = locateUID(linked_receiver_uid)
	if(istype(receiver) && !QDELETED(receiver))
		return receiver

/obj/item/clothing/neck/human_petcollar/locked/bluespace_collar_transmitter/proc/link_receiver(obj/item/clothing/neck/human_petcollar/locked/bluespace_collar_receiver/receiver, mob/user)
	if(!istype(receiver) || !can_manipulate(user) || !receiver.can_manipulate(user) || !(user.get_active_hand() == src || user.get_inactive_hand() == src || user.get_active_hand() == receiver || user.get_inactive_hand() == receiver))
		return FALSE
	linked_receiver_uid = receiver.UID()
	to_chat(user, SPAN_NOTICE("You link [src] to [receiver]."))
	return TRUE

/obj/item/clothing/neck/human_petcollar/locked/bluespace_collar_transmitter/item_interaction(mob/living/user, obj/item/used, list/modifiers)
	if(istype(used, /obj/item/clothing/neck/human_petcollar/locked/bluespace_collar_receiver))
		if(used.loc == user && (user.get_active_hand() == used || user.get_inactive_hand() == used))
			link_receiver(used, user)
		return ITEM_INTERACT_COMPLETE
	return ..()

/obj/item/clothing/neck/human_petcollar/locked/bluespace_collar_transmitter/AltClick(mob/user)
	if(can_manipulate(user))
		linked_receiver_uid = null
		to_chat(user, SPAN_NOTICE("You unlink [src]."))

/obj/item/clothing/neck/human_petcollar/locked/bluespace_collar_transmitter/examine(mob/user)
	. = ..()
	. += SPAN_NOTICE("It is [get_receiver() ? "linked" : "unlinked"]. Apply one collar to the other to link them. Alt-click to unlink.")

/// A single routing hop. An absent/inactive receiver falls back to normal eating.
/mob/living/carbon/proc/get_gs13_food_recipient()
	return src

/mob/living/carbon/human/get_gs13_food_recipient()
	var/obj/item/clothing/neck/human_petcollar/locked/bluespace_collar_transmitter/transmitter = neck
	if(istype(transmitter) && transmitter.get_wearer() == src)
		var/obj/item/clothing/neck/human_petcollar/locked/bluespace_collar_receiver/receiver = transmitter.get_receiver()
		var/mob/living/carbon/human/recipient = receiver?.get_recipient()
		if(recipient)
			return recipient
	return src

/mob/living/carbon/proc/gs13_receiving_feedback()
	playsound(loc, pick('modular_gs/sound/voice/gurgle1.ogg', 'modular_gs/sound/voice/gurgle2.ogg', 'modular_gs/sound/voice/gurgle3.ogg'), 25, TRUE)
	to_chat(src, SPAN_NOTICE("You feel your stomach fill through the bluespace collar."))

/datum/design/calorite_collar
	name = "Calorite Collar"
	id = "calorite_collar"
	req_tech = list("materials" = 3, "biotech" = 3)
	build_type = PROTOLATHE
	materials = list(MAT_METAL = 1000, MAT_CALORITE = 6000)
	build_path = /obj/item/clothing/neck/human_petcollar/calorite
	category = list("Medical")

/datum/design/bluespace_collar_receiver
	name = "Bluespace Collar Receiver"
	id = "bluespace_collar_receiver"
	req_tech = list("materials" = 4, "biotech" = 4, "bluespace" = 3)
	build_type = PROTOLATHE
	materials = list(MAT_METAL = 1000, MAT_CALORITE = 2500, MAT_BLUESPACE = 250)
	build_path = /obj/item/clothing/neck/human_petcollar/locked/bluespace_collar_receiver
	category = list("Medical")

/datum/design/bluespace_collar_transmitter
	name = "Bluespace Collar Transmitter"
	id = "bluespace_collar_transmitter"
	req_tech = list("materials" = 4, "biotech" = 4, "bluespace" = 3)
	build_type = PROTOLATHE
	materials = list(MAT_METAL = 1000, MAT_CALORITE = 1000, MAT_BLUESPACE = 500)
	build_path = /obj/item/clothing/neck/human_petcollar/locked/bluespace_collar_transmitter
	category = list("Medical")

/datum/crafting_recipe/calorite_collar
	name = "Calorite Collar"
	tools = list(TOOL_WRENCH, TOOL_WELDER)
	result = list(/obj/item/clothing/neck/human_petcollar/calorite)
	reqs = list(/obj/item/clothing/neck/human_petcollar = 1, /obj/item/stack/sheet/mineral/calorite = 3)
	time = 25 SECONDS
	category = CAT_CLOTHING
	subcategory = CAT_CLOTHING_GENERAL

/datum/crafting_recipe/locked_calorite_collar
	name = "Locking Calorite Collar"
	tools = list(TOOL_WRENCH, TOOL_WELDER)
	result = list(/obj/item/clothing/neck/human_petcollar/locked/calorite)
	reqs = list(/obj/item/clothing/neck/human_petcollar/locked = 1, /obj/item/stack/sheet/mineral/calorite = 3)
	time = 25 SECONDS
	category = CAT_CLOTHING
	subcategory = CAT_CLOTHING_GENERAL
