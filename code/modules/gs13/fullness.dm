// GS13 fullness counts distinct pending food in the blood and physical stomach.
/mob/living/carbon/proc/gs13_weight_enabled()
	return gs13_preferences["master_wg_pref"] || HAS_TRAIT(src, TRAIT_UNIVERSAL_GAINER)

/mob/living/carbon/proc/get_fullness()
	fullness = nutrition
	fullness += gs13_pending_food_nutrition(reagents, metabolism_efficiency)
	var/obj/item/organ/internal/gs13_stomach/stomach = get_organ_slot(GS13_ORGAN_STOMACH)
	if(istype(stomach) && stomach.owner == src)
		fullness += gs13_pending_food_nutrition(stomach.reagents, metabolism_efficiency, stomach)
	return max(0, fullness + fullness_adjustment)

/mob/living/carbon/proc/get_gs13_fullness_limit()
	// Paradise counts overeating in life cycles rather than deciseconds.
	return FULLNESS_MAX * (1 + overeatduration / 2000)

/mob/living/carbon/proc/handle_gs13_fullness(seconds = 2)
	if(!gs13_weight_enabled())
		clear_alert("gs13_fullness")
		return
	get_fullness()
	var/recovery = max(seconds, 0) * 7.5
	if(fullness_adjustment > 0)
		fullness_adjustment = max(0, fullness_adjustment - recovery)
	else
		fullness_adjustment = min(0, fullness_adjustment + recovery)
	// Do not invent a negative adjustment when food alone exceeds the limit.
	fullness_adjustment = clamp(fullness_adjustment, -max(fullness + 500, 600), max(0, FULLNESS_MAX - fullness))
	var/current_fullness = get_fullness()
	if(current_fullness >= FULLNESS_LEVEL_NOMOREPLZ)
		throw_alert("gs13_fullness", /atom/movable/screen/alert/gs13/beegbelly)
	else if(current_fullness >= FULLNESS_LEVEL_BEEG)
		throw_alert("gs13_fullness", /atom/movable/screen/alert/gs13/stuffed)
	else if(current_fullness >= FULLNESS_LEVEL_BLOATED)
		throw_alert("gs13_fullness", /atom/movable/screen/alert/gs13/bloated)
	else
		clear_alert("gs13_fullness")

/mob/living/carbon/proc/adjust_hunger(amount)
	if(isnum(amount) && GS13_IS_FINITE(amount))
		// Include the normal two-second recovery so ongoing hunger has a net effect.
		fullness_adjustment -= 15 + amount

/mob/living/carbon/proc/reduce_fullness(amount, notify = TRUE)
	if(!gs13_weight_enabled() || !isnum(amount) || !GS13_IS_FINITE(amount) || amount <= 0)
		return FALSE
	if(get_fullness() < FULLNESS_LEVEL_BLOATED || world.time < fullness_reduction_timer + FULLNESS_REDUCTION_COOLDOWN)
		return FALSE
	fullness_adjustment -= amount
	fullness_reduction_timer = world.time
	if(notify)
		to_chat(src, SPAN_NOTICE("You feel some room open up in your stomach."))
	return TRUE

/datum/emote/living/burp/run_emote(mob/user, params, type_override, intentional)
	. = ..()
	if(. && iscarbon(user))
		var/mob/living/carbon/carbon = user
		carbon.reduce_fullness(rand(50, 70))
