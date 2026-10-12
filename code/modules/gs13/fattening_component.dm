// Adapted from GS13's fattening component by Swan (AGPL-3.0).
/datum/component/fattening
	dupe_mode = COMPONENT_DUPE_UNIQUE
	var/real_fatness_amount
	var/perma_fatness_amount
	var/fattening_type
	var/ignore_rate
	var/on_touch
	var/on_item_touch
	var/on_bump

/datum/component/fattening/Initialize(real_fatness_amount, fattening_type, perma_fatness_amount = 0, ignore_rate = FALSE, touch = TRUE, item_touch = FALSE, bumped = TRUE)
	if(!isatom(parent))
		return COMPONENT_INCOMPATIBLE
	src.real_fatness_amount = real_fatness_amount
	src.fattening_type = fattening_type
	src.perma_fatness_amount = perma_fatness_amount
	src.ignore_rate = ignore_rate
	on_touch = touch
	on_item_touch = item_touch
	on_bump = bumped

/datum/component/fattening/RegisterWithParent()
	if(on_touch)
		RegisterSignal(parent, COMSIG_ATOM_ATTACK_HAND, PROC_REF(touch))
	if(on_item_touch)
		RegisterSignal(parent, COMSIG_ATTACK_BY, PROC_REF(item_touch))
	if(on_bump)
		RegisterSignal(parent, COMSIG_ATOM_BUMPED, PROC_REF(bump))

/datum/component/fattening/UnregisterFromParent()
	UnregisterSignal(parent, list(COMSIG_ATOM_ATTACK_HAND, COMSIG_ATTACK_BY, COMSIG_ATOM_BUMPED))

/datum/component/fattening/proc/fatten(mob/living/carbon/target)
	target.adjust_fatness(real_fatness_amount, fattening_type, ignore_rate)
	target.adjust_perma(perma_fatness_amount, fattening_type, ignore_rate)

/datum/component/fattening/proc/touch(datum/source, mob/user)
	SIGNAL_HANDLER
	if(!ishuman(user))
		return
	var/mob/living/carbon/human/human = user
	if(human.gloves && !on_item_touch)
		return
	fatten(human)

/datum/component/fattening/proc/item_touch(datum/source, obj/item/item, mob/living/user, params)
	SIGNAL_HANDLER
	if(iscarbon(user))
		fatten(user)

/datum/component/fattening/proc/bump(datum/source, atom/movable/bumped_atom)
	SIGNAL_HANDLER
	if(iscarbon(bumped_atom))
		fatten(bumped_atom)
