// Source extracted-stomach recovery through ordinary native surgical tools.
/obj/item/organ/internal/gs13_stomach
	var/gs13_cut_open_damage = 0

/obj/item/organ/internal/gs13_stomach/examine(mob/user)
	. = ..()
	if(gs13_cut_open_damage > 0)
		. += SPAN_WARNING("It has an open incision exposing its contents.")

/// Every actual native repair first closes the tracked incision. Unrelated
/// injury remains available to the ordinary native medical systems.
/obj/item/organ/internal/gs13_stomach/heal_internal_damage(amount, robo_repair = FALSE)
	var/before = damage
	. = ..()
	gs13_cut_open_damage = max(0, gs13_cut_open_damage - max(0, before - damage))

/obj/item/organ/internal/gs13_stomach/rejuvenate()
	. = ..()
	gs13_cut_open_damage = 0

/// Source retained-object trauma follows the slower six-second item scan.
/// Native cavity surgery owns an item once it has passed into the chest.
/obj/item/organ/internal/gs13_stomach/proc/process_gs13_item_trauma(obj/item/item)
	if(!owner || QDELETED(owner) || owner.stat == DEAD || owner.get_organ_slot(slot) != src || !istype(item) || QDELETED(item) || item.loc != owner || istype(item, /obj/item/food) || HAS_TRAIT(owner, TRAIT_GS13_STRONG_STOMACH))
		return
	if(!isnum(item.w_class) || !GS13_IS_FINITE(item.w_class) || item.w_class <= 0)
		return
	var/mob/living/carbon/human/body = owner
	var/obj/item/organ/external/chest = body.get_organ(parent_organ)
	if(gs13_cut_open_damage > 0)
		if(chest && !chest.hidden && item.w_class <= WEIGHT_CLASS_NORMAL)
			chest.hidden = item
			forget_gs13_content(item)
			return
		body.apply_damage(item.w_class * (item.sharp ? 2 : 1), BRUTE, parent_organ)
	if(QDELETED(src) || owner != body || QDELETED(body) || body.stat == DEAD || QDELETED(item) || item.loc != body || !item.sharp)
		return
	var/was_dead = status & ORGAN_DEAD
	receive_damage(item.w_class)
	if(was_dead || !(status & ORGAN_DEAD) || QDELETED(body))
		return
	gs13_cut_open_damage = max_damage * 0.5
	if(body.can_feel_pain())
		to_chat(body, SPAN_WARNING("A sharp swallowed object has torn through your stomach!"))
		body.Paralyse(1 SECONDS)
		body.AdjustEyeBlurry(5 SECONDS)

/obj/item/organ/internal/gs13_stomach/proc/can_gs13_operate(mob/living/user, obj/item/tool, opening)
	if(QDELETED(src) || owner || is_robotic() || QDELETED(user) || QDELETED(tool) || !user || !tool || user.incapacitated() || HAS_TRAIT(user, TRAIT_HANDS_BLOCKED) || user.get_active_hand() != tool || !user.Adjacent(src))
		return FALSE
	return opening ? gs13_cut_open_damage <= 0 : gs13_cut_open_damage > 0

/obj/item/organ/internal/gs13_stomach/item_interaction(mob/living/user, obj/item/used, list/modifiers)
	if(used?.tool_behaviour != TOOL_SCALPEL && used?.tool_behaviour != TOOL_CAUTERY)
		return ..()
	var/opening = used.tool_behaviour == TOOL_SCALPEL
	if(!can_gs13_operate(user, used, opening))
		return ITEM_INTERACT_COMPLETE
	to_chat(user, SPAN_NOTICE("You begin [opening ? "opening" : "closing"] the incision in [src]."))
	var/interruption_damage = max(0, used.force)
	if(!used.use_tool(src, user, 3 SECONDS, volume = 50, extra_checks = CALLBACK(src, PROC_REF(can_gs13_operate), user, used, opening)))
		// Revalidate ownership after the timed action: transplanting the organ
		// cannot leave a delayed operation affecting its new physical owner.
		if(!QDELETED(src) && !owner)
			receive_damage(interruption_damage, TRUE)
		return ITEM_INTERACT_COMPLETE
	if(!can_gs13_operate(user, used, opening))
		return ITEM_INTERACT_COMPLETE
	if(opening)
		var/emptied = empty_gs13_contents()
		var/before = damage
		receive_damage(max_damage * 0.5, TRUE)
		gs13_cut_open_damage += max(0, damage - before)
		to_chat(user, SPAN_NOTICE("You open [src][emptied ? ", recovering its contents" : ""]."))
	else
		heal_internal_damage(gs13_cut_open_damage)
		gs13_cut_open_damage = 0
		to_chat(user, SPAN_NOTICE("You close the incision in [src]."))
	return ITEM_INTERACT_COMPLETE
