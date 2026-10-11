/proc/gs13_weight_stage(amount)
	var/stage = 0
	for(var/threshold in list(FATNESS_LEVEL_FAT, FATNESS_LEVEL_FATTER, FATNESS_LEVEL_VERYFAT, FATNESS_LEVEL_OBESE, FATNESS_LEVEL_MORBIDLY_OBESE, FATNESS_LEVEL_EXTREMELY_OBESE, FATNESS_LEVEL_BARELYMOBILE, FATNESS_LEVEL_IMMOBILE, FATNESS_LEVEL_BLOB))
		if(amount < threshold)
			break
		stage++
	return stage

/proc/get_fatness_level_name(amount)
	var/static/list/names = list("Normal", "Rounded", "Fat", "Very fat", "Obese", "Morbidly obese", "Extremely obese", "Barely mobile", "Immobile", "Fatty blob")
	return names[gs13_weight_stage(amount) + 1]

/mob/living/carbon/proc/update_gs13_weight_alerts()
	var/static/list/fat_alerts = list(
		/atom/movable/screen/alert/gs13/fat,
		/atom/movable/screen/alert/gs13/fatter,
		/atom/movable/screen/alert/gs13/veryfat,
		/atom/movable/screen/alert/gs13/obese,
		/atom/movable/screen/alert/gs13/morbidlyobese,
		/atom/movable/screen/alert/gs13/extremelyobese,
		/atom/movable/screen/alert/gs13/barelymobile,
		/atom/movable/screen/alert/gs13/immobile,
		/atom/movable/screen/alert/gs13/blob,
	)
	var/static/list/muscle_alerts = list(
		/atom/movable/screen/alert/gs13/toned,
		/atom/movable/screen/alert/gs13/sporty,
		/atom/movable/screen/alert/gs13/athletic,
		/atom/movable/screen/alert/gs13/muscular,
		/atom/movable/screen/alert/gs13/beefy,
		/atom/movable/screen/alert/gs13/herculean,
		/atom/movable/screen/alert/gs13/hulking,
		/atom/movable/screen/alert/gs13/titanic,
		/atom/movable/screen/alert/gs13/mountainous,
	)
	var/stage = gs13_weight_stage(fatness)
	if(stage && gs13_preferences["master_wg_pref"])
		throw_alert("gs13_fatness", fat_alerts[stage])
	else
		clear_alert("gs13_fatness")
	stage = gs13_weight_stage(muscle)
	if(stage && gs13_preferences["muscle_gain"])
		throw_alert("gs13_muscle", muscle_alerts[stage])
	else
		clear_alert("gs13_muscle")
