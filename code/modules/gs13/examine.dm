/mob/living/carbon/proc/get_gs13_weight_text()
	var/stage = gs13_weight_stage(fatness)
	if(!stage)
		return ""
	return "[p_their(TRUE)] build is [lowertext(get_fatness_level_name(fatness))].\n"

/mob/living/carbon/proc/get_gs13_fullness_text()
	var/current_fullness = get_fullness()
	if(current_fullness >= FULLNESS_LEVEL_NOMOREPLZ)
		return "[p_their(TRUE)] stomach is stretched to enormous proportions.\n"
	if(current_fullness >= FULLNESS_LEVEL_BEEG)
		return "[p_their(TRUE)] stomach looks very round and very full.\n"
	if(current_fullness >= FULLNESS_LEVEL_BLOATED)
		return "[p_they(TRUE)] look[p_s()] like [p_they()] ate a bit too much.\n"
	return ""
