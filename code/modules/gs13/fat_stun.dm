// GS13's timed weight-gain stun, using native traits and independent status identity.
// The source inherits a no-tick status; explicitly process so its growth can run.
/datum/status_effect/incapacitating/stun/gs13_fat
	id = "gs13_fat_stun"
	tick_interval = 0.2 SECONDS
	var/fat_amount = 1

/datum/status_effect/incapacitating/stun/gs13_fat/on_creation(mob/living/new_owner, set_duration, new_fat_amount = 1)
	if(isnum(new_fat_amount) && GS13_IS_FINITE(new_fat_amount))
		fat_amount = new_fat_amount
	return ..(new_owner, set_duration)

/datum/status_effect/incapacitating/stun/gs13_fat/on_apply()
	if(!iscarbon(owner))
		return FALSE
	var/mob/living/carbon/subject = owner
	if(!subject.check_weight_prefs(FATTENING_TYPE_ITEM) || (subject.status_flags & GODMODE))
		return FALSE
	. = ..()
	if(.)
		RegisterSignal(owner, COMSIG_LIVING_CLEAR_STUNS, PROC_REF(clear_stun))

/datum/status_effect/incapacitating/stun/gs13_fat/proc/clear_stun(datum/source)
	SIGNAL_HANDLER
	qdel(src)

/datum/status_effect/incapacitating/stun/gs13_fat/tick()
	var/mob/living/carbon/subject = owner
	if(!subject.check_weight_prefs(FATTENING_TYPE_ITEM) || (subject.status_flags & GODMODE))
		qdel(src)
		return
	subject.adjust_fatness(fat_amount, FATTENING_TYPE_ITEM)

/datum/status_effect/incapacitating/stun/gs13_fat/on_remove()
	UnregisterSignal(owner, COMSIG_LIVING_CLEAR_STUNS)
	return ..()

/mob/living/carbon/proc/IsFatStunned()
	return has_status_effect(STATUS_EFFECT_GS13_FATSTUN)

/mob/living/carbon/proc/AmountFatStunned()
	var/datum/status_effect/incapacitating/stun/gs13_fat/effect = IsFatStunned()
	return effect ? max(0, effect.duration - world.time) : 0

/mob/living/carbon/proc/FatStun(amount, fatAmount = 1, ignore_canstun = FALSE)
	if(!isnum(amount) || !GS13_IS_FINITE(amount) || amount <= 0 || !check_weight_prefs(FATTENING_TYPE_ITEM) || (status_flags & GODMODE))
		return
	if((!ignore_canstun && !(status_flags & CANSTUN)) || absorb_stun(amount, ignore_canstun))
		return
	var/datum/status_effect/incapacitating/stun/gs13_fat/effect = IsFatStunned()
	if(effect)
		effect.duration = max(effect.duration, world.time + amount)
	else
		effect = apply_status_effect(STATUS_EFFECT_GS13_FATSTUN, amount, fatAmount)
	return effect
