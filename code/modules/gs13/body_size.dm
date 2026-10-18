// Adapted from GS13's inherited body_size preference and weight_helpers.dm.
/proc/gs13_sanitize_body_size(value)
	if(!isnum(value) || !GS13_IS_FINITE(value))
		return RESIZE_DEFAULT_SIZE
	return clamp(round(value, 0.01), GS13_BODY_SIZE_MIN, GS13_BODY_SIZE_MAX)

/// Replace only our own scale factor, preserving native mutations and other transforms.
/mob/living/carbon/human/proc/set_gs13_body_size(value)
	value = gs13_sanitize_body_size(value)
	if(dna)
		dna.gs13_body_size = value
	if(value == starting_size)
		return
	resize *= value / starting_size
	starting_size = value
	update_transform()

/// Starting size, rather than the current render transform, determines physical mass.
/mob/living/carbon/proc/calculate_weight_scale()
	return starting_size ** 2

/mob/living/carbon/proc/calculate_adjusted_total_weight_in_bfi()
	return calculate_total_weight_in_bfi() * calculate_weight_scale()
