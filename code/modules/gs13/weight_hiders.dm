// GS13 interface for equipment that conceals apparent weight.
/mob/living/carbon/proc/hider_add(datum/hide_source)
	if(QDELETED(hide_source) || !hascall(hide_source, "fat_hide"))
		return FALSE
	fat_hiders |= hide_source
	calculate_fatness()
	return TRUE

/mob/living/carbon/proc/hider_remove(datum/hide_source)
	fat_hiders -= hide_source
	calculate_fatness()
	return TRUE

/mob/living/carbon/proc/hiders_calc()
	var/total = 0
	for(var/datum/hider as anything in fat_hiders.Copy())
		if(QDELETED(hider))
			fat_hiders -= hider
			continue
		var/values = call(hider, "fat_hide")(src)
		if(isnum(values))
			total += values
		else if(islist(values))
			for(var/value in values)
				if(isnum(value))
					total += value
	return total
