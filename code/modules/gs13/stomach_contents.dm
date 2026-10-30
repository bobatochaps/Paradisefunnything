// Native item ownership for the pinned inherited stomach consume/empty contract.
// Native carbon.stomach_contents remains the separate swallowed-mob subsystem.
/obj/item/organ/internal/gs13_stomach
	var/list/gs13_stomach_contents

/// Actual native inventory transfer owns hand/slot cleanup and NODROP checks.
/obj/item/organ/internal/gs13_stomach/proc/consume_gs13_item(obj/item/item)
	if(QDELETED(src) || !istype(item) || QDELETED(item) || item == src || (item in gs13_stomach_contents))
		return FALSE
	if(owner && (QDELETED(owner) || owner.get_organ_slot(slot) != src))
		return FALSE
	var/atom/storage = owner || src
	if(item.contains(storage))
		return FALSE
	if(ismob(item.loc))
		var/mob/carrier = item.loc
		if(!carrier.transfer_item_to(item, storage))
			return FALSE
	else
		item.forceMove(storage)
	if(QDELETED(src) || QDELETED(item) || item.loc != storage)
		return FALSE
	LAZYADD(gs13_stomach_contents, item)
	RegisterSignal(item, COMSIG_MOVABLE_MOVED, PROC_REF(on_gs13_content_moved))
	RegisterSignal(item, COMSIG_PARENT_QDELETING, PROC_REF(on_gs13_content_deleted))
	return TRUE

/obj/item/organ/internal/gs13_stomach/proc/forget_gs13_content(obj/item/item)
	LAZYREMOVE(gs13_stomach_contents, item)
	UnregisterSignal(item, list(COMSIG_MOVABLE_MOVED, COMSIG_PARENT_QDELETING))

/// Item callbacks use elapsed native seconds. The separate native swallowed-
/// mob subsystem continues to own its own lifecycle and digestion rules.
/obj/item/organ/internal/gs13_stomach/proc/process_gs13_stomach_items(seconds = 2)
	if(!owner || QDELETED(owner) || owner.stat == DEAD || owner.get_organ_slot(slot) != src || !isnum(seconds) || !GS13_IS_FINITE(seconds) || seconds <= 0)
		return
	gs13_item_acid_elapsed += seconds
	var/acid_tick = gs13_item_acid_elapsed >= 6
	gs13_item_acid_elapsed %= 6
	var/mob/living/carbon/holder = owner
	for(var/obj/item/item as anything in gs13_stomach_contents?.Copy())
		if(QDELETED(src) || owner != holder || QDELETED(holder) || holder.stat == DEAD || holder.get_organ_slot(slot) != src)
			break
		if(!QDELETED(item) && item.loc == holder)
			var/handled = SEND_SIGNAL(item, COMSIG_GS13_STOMACH_DIGEST_ITEM, src, holder, seconds)
			if(QDELETED(src) || owner != holder || QDELETED(holder) || holder.stat == DEAD || holder.get_organ_slot(slot) != src)
				break
			if(!acid_tick || QDELETED(item) || item.loc != holder || (handled & GS13_CANCEL_ITEM_DIGESTION))
				continue
			var/power = get_gs13_item_acid_power(item)
			if(power > 0)
				item.acid_act(power, 10)
			if(!QDELETED(src) && owner == holder && !QDELETED(holder) && holder.stat != DEAD && !QDELETED(item) && item.loc == holder)
				process_gs13_item_trauma(item)

/// Source advanced prostheses use twenty/thirty-five acid power, skip edible
/// food, and leave living swallowed mobs to their separate native subsystem.
/obj/item/organ/internal/gs13_stomach/proc/get_gs13_item_acid_power(obj/item/item)
	if(!istype(item) || QDELETED(item) || istype(item, /obj/item/food) || !isnum(gs13_item_acid_power) || !GS13_IS_FINITE(gs13_item_acid_power))
		return 0
	var/power = max(0, gs13_item_acid_power)
	if(owner && HAS_TRAIT(owner, TRAIT_GS13_STRONG_STOMACH))
		power = max(power, 10)
	return power

/obj/item/organ/internal/gs13_stomach/proc/on_gs13_content_deleted(obj/item/source)
	SIGNAL_HANDLER
	forget_gs13_content(source)

/obj/item/organ/internal/gs13_stomach/proc/on_gs13_content_moved(obj/item/source)
	SIGNAL_HANDLER
	if(source.loc == src || (owner && source.loc == owner))
		return
	forget_gs13_content(source)

/obj/item/organ/internal/gs13_stomach/insert(mob/living/carbon/recipient, special = 0, dont_remove_slot = 0)
	var/mob/living/carbon/old_owner = owner
	. = ..()
	if(!owner || QDELETED(owner) || owner == old_owner)
		return
	for(var/trait in gs13_organ_traits)
		ADD_TRAIT(owner, trait, "gs13_stomach_[UID()]")
	RegisterSignal(owner, COMSIG_GS13_CARBON_VOMITED, PROC_REF(on_gs13_owner_vomit))
	RegisterSignal(owner, COMSIG_GS13_HUMAN_UNARMED_HIT, PROC_REF(on_gs13_owner_unarmed_hit))
	for(var/obj/item/item as anything in gs13_stomach_contents?.Copy())
		item.forceMove(owner)

/obj/item/organ/internal/gs13_stomach/remove(mob/living/carbon/previous_owner, special = 0)
	if(owner)
		for(var/trait in gs13_organ_traits)
			REMOVE_TRAIT(owner, trait, "gs13_stomach_[UID()]")
		UnregisterSignal(owner, list(COMSIG_GS13_CARBON_VOMITED, COMSIG_GS13_HUMAN_UNARMED_HIT))
	// Move before native removal clears owner, preserving the source's accepted
	// owner-or-organ locations during each real movement signal.
	for(var/obj/item/item as anything in gs13_stomach_contents?.Copy())
		item.forceMove(src)
	return ..()

/obj/item/organ/internal/gs13_stomach/Destroy()
	// The inherited organ owns its retained contents on actual destruction.
	for(var/obj/item/item as anything in gs13_stomach_contents?.Copy())
		forget_gs13_content(item)
		qdel(item)
	return ..()

/// Source ordinary vomiting ejects each retained item with a sixty-percent
/// chance and chest trauma proportional to its native weight class.
/obj/item/organ/internal/gs13_stomach/proc/on_gs13_owner_vomit(mob/living/carbon/vomiter, distance, forced = FALSE)
	SIGNAL_HANDLER
	if(vomiter == owner)
		empty_gs13_contents(60, TRUE, forced ? 1 : 0)

/// The pinned receiver uses raw resolved damage >= 9, no armor block and no
/// kicking. Native unarmed variants with a kick verb supply that exclusion.
/obj/item/organ/internal/gs13_stomach/proc/on_gs13_owner_unarmed_hit(mob/living/carbon/hit_body, mob/living/carbon/human/attacker, damage, armor_block, kicking)
	SIGNAL_HANDLER
	if(hit_body != owner || !owner || QDELETED(owner) || owner.get_organ_slot(slot) != src || !length(gs13_stomach_contents) || !isnum(damage) || !GS13_IS_FINITE(damage) || damage < 9 || armor_block || kicking)
		return
	if(owner.vomit(gs13_force_contents = TRUE))
		owner.visible_message(SPAN_WARNING("[owner] reels from [attacker]'s strike and vomits up swallowed contents!"))

/obj/item/organ/internal/gs13_stomach/proc/empty_gs13_contents(chance = 100, damaging = FALSE, min_amount = 0)
	if(!isnum(chance) || !GS13_IS_FINITE(chance) || !isnum(min_amount) || !GS13_IS_FINITE(min_amount))
		return 0
	var/atom/drop_as = owner || src
	var/atom/drop = drop_as.drop_location()
	if(!drop)
		return 0
	chance = clamp(chance, 0, 100)
	min_amount = clamp(round(min_amount), 0, length(gs13_stomach_contents))
	var/emptied = 0
	for(var/obj/item/item as anything in gs13_stomach_contents?.Copy())
		var/total_chance = chance
		if(min_amount)
			total_chance += 100 / (length(gs13_stomach_contents) + 1 - min_amount)
		if(!prob(total_chance))
			continue
		item.forceMove(drop)
		if(QDELETED(item) || item.loc != drop)
			continue
		emptied++
		min_amount = max(0, min_amount - 1)
		if(damaging && owner && !QDELETED(owner))
			owner.apply_damage(item.w_class * 2, BRUTE, BODY_ZONE_CHEST)
	return emptied

/// Tiny objects hidden through native food insertion can be swallowed with
/// the final accepted bite. Source high-force sharp objects injure and embed.
/obj/item/proc/try_gs13_accidental_swallow(mob/living/carbon/consumer)
	if(!istype(consumer) || QDELETED(consumer) || consumer.stat == DEAD)
		return FALSE
	if(sharp && isnum(force) && GS13_IS_FINITE(force) && force >= 5)
		return bite_gs13_sharp_object(consumer)
	if(w_class > WEIGHT_CLASS_TINY)
		return FALSE
	var/obj/item/organ/internal/gs13_stomach/stomach = consumer.get_organ_slot(GS13_ORGAN_STOMACH)
	if(!istype(stomach) || stomach.owner != consumer || !stomach.consume_gs13_item(src))
		return FALSE
	// Two source breathing cycles become the native timed breath-loss effect.
	consumer.AdjustLoseBreath(4 SECONDS)
	to_chat(consumer, SPAN_WARNING("You swallow something small with your food."))
	return TRUE

/// Source forceful bites use the native physical limb's embedded-item lifecycle.
/// Strong Stomach protects retained objects, not the initial sharp bite.
/obj/item/proc/bite_gs13_sharp_object(mob/living/carbon/consumer)
	consumer.visible_message(SPAN_WARNING("[consumer] bites into something sharp!"), SPAN_USERDANGER("You bite into something sharp!"))
	consumer.apply_damage(max(15, force), BRUTE, BODY_ZONE_HEAD, sharp = TRUE)
	consumer.AdjustLoseBreath(4 SECONDS)
	if(QDELETED(src) || QDELETED(consumer) || !ishuman(consumer))
		return FALSE
	var/mob/living/carbon/human/body = consumer
	var/obj/item/organ/external/chest = body.get_organ(BODY_ZONE_CHEST)
	if(!chest || HAS_TRAIT(body, TRAIT_PIERCEIMMUNE))
		return FALSE
	chest.add_embedded_object(src)
	if(QDELETED(src) || QDELETED(body) || loc != body)
		return FALSE
	add_mob_blood(body)
	body.apply_damage(max(25, force * 1.5), BRUTE, BODY_ZONE_CHEST, sharp = TRUE)
	body.AdjustLoseBreath(12 SECONDS)
	return TRUE
