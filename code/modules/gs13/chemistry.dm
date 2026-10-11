// GS13 reagents adapted to Paradise string IDs and two-second chemistry cycles.
/datum/reagent/consumable/caramel
	name = "Caramel"
	id = "caramel"
	description = "Delicious heated sugar."
	nutriment_factor = 10 * REAGENTS_METABOLISM
	color = "#D98736"
	taste_mult = 2
	taste_description = "caramel"

/datum/chemical_reaction/gs13_caramel
	name = "Caramel"
	id = "gs13_caramel"
	result = "caramel"
	required_reagents = list("sugar" = 1)
	result_amount = 1
	min_temp = 413.15
	max_temp = 600

/datum/reagent/consumable/lipoifier
	name = "Lipoifier"
	id = "lipoifier"
	description = "A potent chemical that causes those that ingest it to build up fat cells quickly."
	taste_description = "lard"
	color = "#E2E1B1"
	metabolization_rate = 0.5 * REAGENTS_METABOLISM
	process_flags = ORGANIC | SYNTHETIC
	nutriment_factor = 0
	var/fat_to_add = 6

/datum/reagent/consumable/lipoifier/weak
	name = "Weak Lipoifier"
	id = "weak_lipoifier"
	fat_to_add = 3

/datum/reagent/consumable/lipoifier/on_mob_life(mob/living/subject)
	if(iscarbon(subject))
		var/mob/living/carbon/carbon = subject
		carbon.adjust_fatness(fat_to_add * 2, FATTENING_TYPE_CHEM)
	return ..()

/datum/reagent/fermi_fat
	name = "Galbanic Compound"
	id = "fermi_fat"
	description = "A compound derived from lipoifier. Some of the resulting weight cannot be shed by ordinary means."
	color = "#E70C0C"
	taste_description = "hunger"
	metabolization_rate = REAGENTS_METABOLISM / 2
	process_flags = ORGANIC | SYNTHETIC
	overdose_threshold = 50
	allowed_overdose_process = TRUE

/datum/reagent/fermi_fat/on_mob_life(mob/living/subject)
	if(iscarbon(subject))
		var/mob/living/carbon/carbon = subject
		carbon.adjust_fatness(20, FATTENING_TYPE_CHEM)
		carbon.adjust_perma(4, FATTENING_TYPE_CHEM)
	return ..()

/datum/reagent/fermi_fat/overdose_process(mob/living/subject, severity)
	if(iscarbon(subject))
		var/mob/living/carbon/carbon = subject
		carbon.adjust_fatness(20, FATTENING_TYPE_CHEM)
		carbon.adjust_perma(6, FATTENING_TYPE_CHEM)
	return list(0, STATUS_UPDATE_NONE)

/datum/reagent/fermi_slim
	name = "Macerinic Solution"
	id = "fermi_slim"
	description = "A weight-loss solution capable of removing galbanic fat."
	color = "#3B0CE7"
	taste_description = "thinness"
	metabolization_rate = REAGENTS_METABOLISM / 2
	process_flags = ORGANIC | SYNTHETIC
	overdose_threshold = 50
	allowed_overdose_process = TRUE

/datum/reagent/fermi_slim/on_mob_life(mob/living/subject)
	if(iscarbon(subject))
		var/mob/living/carbon/carbon = subject
		var/weight_loss_modifier = HAS_TRAIT(carbon, TRAIT_MACERINIC_TOLERANCE) ? 1 : 5
		carbon.adjust_fatness(-10 * weight_loss_modifier, FATTENING_TYPE_WEIGHT_LOSS)
		carbon.adjust_perma(-weight_loss_modifier, FATTENING_TYPE_WEIGHT_LOSS)
	return ..()

/datum/reagent/fermi_slim/overdose_process(mob/living/subject, severity)
	if(iscarbon(subject) && !HAS_TRAIT(subject, TRAIT_MACERINIC_TOLERANCE))
		var/mob/living/carbon/carbon = subject
		carbon.adjust_nutrition(-5)
		carbon.weight_loss_rate = min(5, carbon.weight_loss_rate + 0.01)
	return list(0, STATUS_UPDATE_NONE)

/datum/chemical_reaction/gs13_lipoifier
	name = "Lipoifier"
	id = "gs13_lipoifier"
	result = "lipoifier"
	required_reagents = list("caramel" = 1, "cornoil" = 1, "synthflesh" = 1)
	result_amount = 3

/datum/chemical_reaction/gs13_fermi_fat
	name = "Galbanic Compound"
	id = "gs13_fermi_fat"
	result = "fermi_fat"
	required_reagents = list("lipoifier" = 0.1, "pen_acid" = 0.1, "iron" = 0.1)
	result_amount = 0.2
	min_temp = 700
	max_temp = 755
	mix_message = "The reaction appears to swell!"

/datum/chemical_reaction/gs13_fermi_slim
	name = "Macerinic Solution"
	id = "gs13_fermi_slim"
	result = "fermi_slim"
	required_reagents = list("lipolicide" = 0.1, "ammonia" = 0.1, "oxygen" = 0.1)
	result_amount = 0.2
	min_temp = 600
	max_temp = 700
	mix_message = "The reaction seems to become thinner!"

/obj/item/reagent_containers/glass/bottle/lipoifier
	name = "lipoifier bottle"
	desc = "A bottle of lipoifier."
	list_reagents = list("lipoifier" = 30)

/obj/item/reagent_containers/glass/bottle/fermi_fat
	name = "galbanic compound bottle"
	desc = "A bottle of galbanic compound."
	list_reagents = list("fermi_fat" = 30)

/obj/item/reagent_containers/glass/bottle/fermi_slim
	name = "macerinic solution bottle"
	desc = "A bottle of macerinic solution."
	list_reagents = list("fermi_slim" = 30)
