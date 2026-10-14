// Adapted from GS13 modular_gs/code/mechanics/fatness.dm and muscle.dm (AGPL-3.0).
/mob/living/carbon/proc/check_weight_prefs(type_of_fattening = FATTENING_TYPE_ITEM, perma = FALSE)
	if(type_of_fattening == FATTENING_TYPE_ALMIGHTY || HAS_TRAIT(src, TRAIT_UNIVERSAL_GAINER))
		return TRUE
	if(!gs13_preferences["master_wg_pref"] || (perma && !gs13_preferences["weight_gain_permanent"]))
		return FALSE
	switch(type_of_fattening)
		if(FATTENING_TYPE_WEIGHT_LOSS)
			return !HAS_TRAIT(src, TRAIT_WEIGHT_LOSS_IMMUNE)
		if(FATTENING_TYPE_ITEM)
			return gs13_preferences["weight_gain_items"]
		if(FATTENING_TYPE_FOOD)
			return gs13_preferences["weight_gain_food"]
		if(FATTENING_TYPE_CHEM)
			return gs13_preferences["weight_gain_chems"]
		if(FATTENING_TYPE_WEAPON)
			return gs13_preferences["weight_gain_weapons"]
		if(FATTENING_TYPE_MAGIC)
			return gs13_preferences["weight_gain_magic"]
		if(FATTENING_TYPE_VIRUS)
			return gs13_preferences["weight_gain_viruses"]
		if(FATTENING_TYPE_NANITES)
			return gs13_preferences["weight_gain_nanites"]
		if(FATTENING_TYPE_ATMOS)
			return gs13_preferences["weight_gain_atmos"]
		if(FATTENING_TYPE_MOBS)
			return gs13_preferences["weight_gain_mobs"]
		if(FATTENING_TYPE_MUTATIONS)
			return gs13_preferences["weight_gain_mutations"]
	return FALSE

/mob/living/carbon/proc/get_fatness_adjustment_amount(amount, ignore_rate = FALSE)
	if(ignore_rate)
		return amount
	return amount * (amount > 0 ? get_weight_gain_rate() : get_weight_loss_rate())

/// Returns actual gain/loss after applying bounds, not the unclamped request.
/mob/living/carbon/proc/adjust_fatness(amount, type_of_fattening = FATTENING_TYPE_ITEM, ignore_rate = FALSE)
	if(!isnum(amount) || !GS13_IS_FINITE(amount) || !check_weight_prefs(type_of_fattening))
		return 0
	var/before = fatness_real
	fatness_real = max(0, fatness_real + get_fatness_adjustment_amount(amount, ignore_rate))
	if(max_weight && !HAS_TRAIT(src, TRAIT_UNIVERSAL_GAINER))
		fatness_real = min(fatness_real, max(0, max_weight - 1))
	calculate_fatness()
	SEND_SIGNAL(src, COMSIG_FATNESS_REAL_CHANGED, fatness_real)
	return fatness_real - before

/mob/living/carbon/proc/adjust_perma(amount, type_of_fattening = FATTENING_TYPE_ITEM, ignore_rate = FALSE)
	if(!isnum(amount) || !GS13_IS_FINITE(amount) || !check_weight_prefs(type_of_fattening, TRUE))
		return 0
	var/before = fatness_perma
	fatness_perma = max(0, fatness_perma + get_fatness_adjustment_amount(amount, ignore_rate))
	if(max_weight && !HAS_TRAIT(src, TRAIT_UNIVERSAL_GAINER))
		fatness_perma = min(fatness_perma, max(0, max_weight - 1))
	calculate_fatness()
	SEND_SIGNAL(src, COMSIG_FATNESS_PERMA_CHANGED, fatness_perma)
	return fatness_perma - before

/mob/living/carbon/proc/calculate_fatness()
	fatness = max(0, fatness_real + fatness_perma + hiders_calc())
	if(max_weight && !HAS_TRAIT(src, TRAIT_UNIVERSAL_GAINER))
		fatness = min(fatness, max(0, max_weight - 1))
	SEND_SIGNAL(src, COMSIG_FATNESS_CHANGED, fatness)
	update_gs13_weight_appearance()

/mob/living/carbon/proc/fully_heal_fatness(remove_perma = FALSE, custom_remove_text = "You feel much lighter.", custom_perma_remove_text = "Your permanent weight vanishes.")
	fatness_real = 0
	if(remove_perma)
		fatness_perma = 0
		if(custom_perma_remove_text)
			to_chat(src, SPAN_NOTICE(custom_perma_remove_text))
	if(custom_remove_text)
		to_chat(src, SPAN_NOTICE(custom_remove_text))
	calculate_fatness()
	SEND_SIGNAL(src, COMSIG_FATNESS_REAL_CHANGED, fatness_real)
	if(remove_perma)
		SEND_SIGNAL(src, COMSIG_FATNESS_PERMA_CHANGED, fatness_perma)

/mob/living/carbon/proc/calculate_effective_fatness(list/skip_tags)
	return max(0, fatness - ((EW_SKIP_MUSCLE in skip_tags) ? 0 : muscle))

/mob/living/carbon/proc/adjust_muscle(amount, ignore_rate = FALSE)
	if(!gs13_preferences["muscle_gain"] || !isnum(amount) || !GS13_IS_FINITE(amount))
		return 0
	var/before = muscle_real
	if(!ignore_rate)
		amount *= amount > 0 ? muscle_gain_rate : muscle_loss_rate
	muscle_real = max(0, muscle_real + amount)
	muscle = muscle_real
	return muscle_real - before

/mob/living/carbon/proc/work_out(intensity, custom_stamina_cost = null)
	if(!isnum(intensity) || intensity <= 0 || getStaminaLoss() >= WORKOUT_STAMINA_THRESHOLD || stat != CONSCIOUS)
		return FALSE
	var/stamina_cost = isnull(custom_stamina_cost) ? intensity * INTENSITY_TO_STAMINA_RATIO : custom_stamina_cost
	adjustStaminaLoss(stamina_cost)
	var/fat_burned = -adjust_fatness(-intensity * INTENSITY_TO_FAT_BURNED_RATIO, FATTENING_TYPE_WEIGHT_LOSS)
	adjust_muscle(intensity * INTENSITY_TO_MUSCLE_RATIO + max(0, fat_burned))
	return TRUE

/// Paradise supplies the life tick duration in seconds.
/mob/living/carbon/proc/handle_weight_gain(seconds = 2)
	calculate_fatness()
	muscle = muscle_real
	gs13_movement_delay = 0
	if(gs13_preferences["master_wg_pref"] || HAS_TRAIT(src, TRAIT_UNIVERSAL_GAINER))
		if(stat != DEAD && !HAS_TRAIT(src, TRAIT_NOHUNGER) && nutrition > NUTRITION_LEVEL_FULL && check_weight_prefs(FATTENING_TYPE_FOOD))
			var/converted = (nutrition - NUTRITION_LEVEL_FULL) * (1 - (1 - NUTRITION_CONVERSION_EFFICIENCY) ** (seconds / 2))
			adjust_nutrition(-converted)
			adjust_fatness(converted * NUTRITION_TO_FAT_RATIO, FATTENING_TYPE_FOOD)
		if(!HAS_TRAIT(src, TRAIT_NO_FAT_SLOWDOWN))
			gs13_movement_delay = min(calculate_effective_fatness() / FATNESS_DIVISOR, FATNESS_MAX_MOVE_PENALTY)
			if(HAS_TRAIT(src, TRAIT_STRONGLEGS))
				gs13_movement_delay *= FATNESS_STRONGLEGS_MODIFIER
			if(HAS_TRAIT(src, TRAIT_WEAKLEGS))
				gs13_movement_delay *= FATNESS_WEAKLEGS_MODIFIER
			if(gs13_movement_delay)
				gs13_movement_delay = apply_fatness_speed_modifiers(gs13_movement_delay)
		if(fatness >= FATNESS_LEVEL_FATTER)
			ADD_TRAIT(src, TRAIT_FAT, GS13_WEIGHT_TRAIT)
		else
			REMOVE_TRAIT(src, TRAIT_FAT, GS13_WEIGHT_TRAIT)
	else
		REMOVE_TRAIT(src, TRAIT_FAT, GS13_WEIGHT_TRAIT)
	handle_calorite_poisoning(seconds)
	update_gs13_weight_alerts()
	handle_gs13_fullness(seconds)
	update_gs13_weight_appearance()

/// Match GS13's replace-by-name API without allocating unowned modifier datums.
/mob/living/carbon/proc/add_fat_delay_modifier(name = "", amount = 0, multiplier = 1)
	if(!istext(name) || !isnum(amount) || !GS13_IS_FINITE(amount) || !isnum(multiplier) || !GS13_IS_FINITE(multiplier))
		return FALSE
	fatness_delay_modifiers[name] = list("amount" = amount, "multiplier" = multiplier)
	return TRUE

/mob/living/carbon/proc/remove_fat_delay_modifier(name)
	fatness_delay_modifiers -= name

/mob/living/carbon/proc/apply_fatness_speed_modifiers(fatness_delay)
	var/delay_cap = FATNESS_MAX_MOVE_PENALTY
	if(HAS_TRAIT(src, TRAIT_WEAKLEGS))
		delay_cap *= FATNESS_WEAKLEGS_MODIFIER
	for(var/source in fatness_delay_modifiers)
		fatness_delay += fatness_delay_modifiers[source]["amount"]
	for(var/source in fatness_delay_modifiers)
		fatness_delay *= fatness_delay_modifiers[source]["multiplier"]
	return clamp(fatness_delay, 0, delay_cap)

/mob/living/carbon/proc/calculate_fatness_weight_in_pounds(amount)
	return round(amount * FATNESS_TO_WEIGHT_RATIO, 0.1)

/mob/living/carbon/proc/calculate_total_fatness_weight_in_pounds()
	return calculate_fatness_weight_in_pounds(fatness)

/mob/living/carbon/proc/calculate_muscle_weight_in_pounds(amount)
	return round(amount * MUSCLE_TO_WEIGHT_RATIO, 0.1)

/mob/living/carbon/proc/calculate_total_muscle_weight_in_pounds()
	return calculate_muscle_weight_in_pounds(muscle)

/mob/living/carbon/proc/calculate_weight_in_pounds()
	return BASE_WEIGHT_VALUE + calculate_total_fatness_weight_in_pounds() + calculate_total_muscle_weight_in_pounds()

/mob/living/carbon/proc/calculate_bmi_from_weight(weight)
	return round(weight * LB_TO_KG / ((BASE_HEIGHT * FEET_TO_METER) ** 2), 0.1)

/mob/living/carbon/proc/calculate_bmi()
	return calculate_bmi_from_weight(calculate_weight_in_pounds())

/mob/living/carbon/proc/calculate_total_weight_in_bfi()
	return muscle * MUSCLE_TO_FATNESS_RATIO + fatness
