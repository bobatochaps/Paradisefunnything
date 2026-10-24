// Adapted from GS13 helplessness.dm and chair_brekage.dm using native inventory.
// The fit check is shared by new equipment and by clothing already being worn.
/mob/living/carbon/human/proc/gs13_can_equip(obj/item/item, slot, disable_warning = FALSE)
	var/blocked = FALSE
	switch(slot)
		if(ITEM_SLOT_JUMPSUIT)
			var/obj/item/clothing/under/uniform = item
			blocked = HAS_TRAIT(src, TRAIT_NO_JUMPSUIT) && (!istype(uniform) || !uniform.gs13_modular_icon)
		if(ITEM_SLOT_OUTER_SUIT, ITEM_SLOT_GLOVES, ITEM_SLOT_SHOES)
			blocked = HAS_TRAIT(src, TRAIT_NO_MISC) && !gs13_is_mod_equipment(item)
		if(ITEM_SLOT_BACK)
			blocked = HAS_TRAIT(src, TRAIT_NO_BACKPACK) && !gs13_is_mod_equipment(item)
		if(ITEM_SLOT_BELT)
			blocked = HAS_TRAIT(src, TRAIT_NO_BELT) && !istype(item, /obj/item/bluespace_belt)
		if(ITEM_SLOT_NECK)
			blocked = HAS_TRAIT(src, TRAIT_NO_NECK)
	if(blocked && !disable_warning)
		to_chat(src, SPAN_WARNING("Your weight prevents you from wearing [item]."))
	return !blocked

/proc/gs13_is_mod_equipment(obj/item/item)
	return istype(item, /obj/item/mod) || istype(item, /obj/item/clothing/head/mod) || istype(item, /obj/item/clothing/suit/mod) || istype(item, /obj/item/clothing/gloves/mod) || istype(item, /obj/item/clothing/shoes/mod)

/mob/living/carbon/human/proc/gs13_shed_incompatible_clothing()
	for(var/slot in list(ITEM_SLOT_JUMPSUIT, ITEM_SLOT_OUTER_SUIT, ITEM_SLOT_GLOVES, ITEM_SLOT_SHOES, ITEM_SLOT_BACK, ITEM_SLOT_BELT, ITEM_SLOT_NECK))
		var/obj/item/item = get_item_by_slot(slot)
		if(!item || gs13_can_equip(item, slot, TRUE))
			continue
		// Native unequipping preserves locks/NODROP and handles dependent slots,
		// internals, storage, actions, concealment, and appearance updates.
		if(drop_item_to_ground(item))
			visible_message(SPAN_WARNING("[src]'s [item.name] can no longer fit and falls away!"), SPAN_WARNING("Your [item.name] can no longer fit and falls away!"))

/mob/living/carbon/human/can_buckle()
	return !HAS_TRAIT(src, TRAIT_NO_BUCKLE) && ..()

// Environmental chair breakage follows apparent fat, independently of muscle,
// as in GS13. It does not forcibly unbuckle a mob when only no_buckle activates.
/mob/living/carbon/proc/gs13_check_chair(removing_trait)
	if(!istype(buckled, /obj/structure/chair))
		return FALSE
	var/threshold = gs13_preferences["chair_breakage"]
	if(removing_trait != TRAIT_HELPLESS_CHAIR_DESTROYER && HAS_TRAIT(src, TRAIT_HELPLESS_CHAIR_DESTROYER))
		threshold = FATNESS_LEVEL_BARELYMOBILE
	if(threshold <= 0 || fatness <= threshold)
		return FALSE
	var/obj/structure/chair/chair = buckled
	visible_message(SPAN_WARNING("[chair] breaks under [src]'s weight!"), SPAN_WARNING("[chair] breaks under your weight!"))
	playsound(chair, 'sound/effects/snap.ogg', 50, TRUE)
	chair.deconstruct()
	return TRUE

/obj/structure/chair/buckle_mob(mob/living/subject, force = FALSE, check_loc = TRUE)
	. = ..()
	if(. && iscarbon(subject))
		var/mob/living/carbon/occupant = subject
		if(occupant.gs13_check_chair())
			return FALSE
