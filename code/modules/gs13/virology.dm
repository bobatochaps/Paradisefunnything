// GS13 weight-gain symptom using Paradise's activation and treatment system.
/datum/symptom/gs13_weight_gain
	name = "Weight Gain"
	stealth = -3
	resistance = -2
	stage_speed = 3
	transmissibility = -2
	level = 6
	severity = 3
	activation_prob = 100
	chem_treatments = list("lipolicide" = list("multiplier" = 0, "timer" = 0))

/datum/symptom/gs13_weight_gain/symptom_act(datum/disease/advance/disease, unmitigated)
	if(!iscarbon(disease.affected_mob))
		return
	var/mob/living/carbon/host = disease.affected_mob
	if(!host.check_weight_prefs(FATTENING_TYPE_VIRUS))
		return
	if(disease.stage >= 5)
		var/speed = disease.totalStageSpeed()
		var/gain = speed >= 12 ? 10 : (speed >= 7 ? 4 : 2)
		host.adjust_fatness(gain * unmitigated, FATTENING_TYPE_VIRUS)
	if(prob(10))
		to_chat(host, SPAN_WARNING(disease.stage >= 5 ? "You feel heavier as your body churns." : "You feel oddly full."))

/datum/disease/advance/gs13_weight_gain/New(datum/disease/advance/to_copy, _event = FALSE, copy_stage = FALSE)
	if(!to_copy)
		name = "Weight Gain Disease"
		symptoms = list(new /datum/symptom/gs13_weight_gain)
	return ..()
