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
	addiction_threshold = 80
	addiction_chance = 100

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

/datum/reagent/fermi_fat/overdose_start(mob/living/subject)
	to_chat(subject, SPAN_WARNING("You took too much [name]! Your body is growing out of control!"))

// Map GS13's three withdrawal stages onto Paradise's native addiction stages.
/datum/reagent/fermi_fat/addiction_act_stage2(mob/living/subject)
	return gs13_withdrawal(subject, 1)

/datum/reagent/fermi_fat/addiction_act_stage3(mob/living/subject)
	return gs13_withdrawal(subject, 2)

/datum/reagent/fermi_fat/addiction_act_stage4(mob/living/subject)
	return gs13_withdrawal(subject, 3)

/datum/reagent/fermi_fat/addiction_act_stage5(mob/living/subject)
	return gs13_withdrawal(subject, 3)

/datum/reagent/fermi_fat/proc/gs13_withdrawal(mob/living/subject, stage)
	if(!iscarbon(subject))
		return STATUS_UPDATE_NONE
	var/mob/living/carbon/carbon = subject
	if(!carbon.check_weight_prefs(FATTENING_TYPE_CHEM))
		return STATUS_UPDATE_NONE
	var/growth = 2 ** (stage - 1)
	carbon.adjust_fatness(growth, FATTENING_TYPE_CHEM)
	carbon.adjust_hunger(growth)
	// As in GS13, the increased gain rate remains after withdrawal ends.
	// Repeated processing or later addictions must not accumulate it without limit.
	carbon.set_weight_gain_modifier("galbanic", max(carbon.get_weight_gain_modifier("galbanic"), 0.25 * growth))
	if(prob(30))
		var/withdrawal_message = stage == 3 ? "You are ravenous and crave more galbanic compound!" : "You feel hungry and think about galbanic compound."
		to_chat(carbon, SPAN_NOTICE(withdrawal_message))
	return STATUS_UPDATE_NONE

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
		carbon.adjust_hunger(5)
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

/datum/reagent/consumable/fizulphite
	name = "Fizulphite"
	id = "fizulphite"
	description = "A chemical that produces large amounts of gas in organic environments."
	color = "#4CFFED"
	taste_description = "fizziness"
	metabolization_rate = 2 * REAGENTS_METABOLISM

/datum/reagent/consumable/fizulphite/on_mob_life(mob/living/subject)
	if(iscarbon(subject))
		var/mob/living/carbon/carbon = subject
		if(carbon.check_weight_prefs(FATTENING_TYPE_CHEM))
			carbon.fullness_adjustment += 35
			if(prob(10))
				carbon.emote("burp")
	return ..()

/datum/reagent/consumable/extilphite
	name = "Extilphite"
	id = "extilphite"
	description = "A chemical that soothes bloated stomachs."
	color = "#2AED96"
	taste_description = "smoothness"
	metabolization_rate = 0.8 * REAGENTS_METABOLISM

/datum/reagent/consumable/extilphite/on_mob_life(mob/living/subject)
	if(iscarbon(subject))
		var/mob/living/carbon/carbon = subject
		if(carbon.check_weight_prefs(FATTENING_TYPE_CHEM) && carbon.get_fullness() > FULLNESS_LEVEL_BLOATED)
			carbon.fullness_adjustment -= 50
	return ..()

/datum/chemical_reaction/gs13_fizulphite
	name = "Fizulphite"
	id = "gs13_fizulphite"
	result = "fizulphite"
	required_reagents = list("sugar" = 1, "nitrogen" = 1, "oxygen" = 3)
	result_amount = 5

/datum/chemical_reaction/gs13_extilphite
	name = "Extilphite"
	id = "gs13_extilphite"
	result = "extilphite"
	required_reagents = list("sugar" = 1, "hydrogen" = 2, "carbon" = 2)
	result_amount = 5

/datum/reagent/consumable/ethanol/blobby_mary
	name = "Blobby Mary"
	id = "blobby_mary"
	description = "A bloody mary that may make you immobile. Still wondering if it is blood or tomato juice?"
	color = "#C2707E"
	alcohol_perc = 0.55
	taste_description = "tomatoes and an anvil on your stomach"
	drink_icon_file = 'modular_gs/icons/obj/drinks.dmi'
	drink_icon = "blobby_mary"
	drink_name = "blobby mary"
	drink_desc = "For the morbidly obese ladies and gentlemen."

/datum/reagent/consumable/ethanol/blobby_mary/on_mob_life(mob/living/subject)
	if(iscarbon(subject))
		var/mob/living/carbon/carbon = subject
		carbon.adjust_nutrition(carbon.check_weight_prefs(FATTENING_TYPE_FOOD) ? 25 * REAGENTS_METABOLISM : 1)
	return ..()

/datum/chemical_reaction/gs13_blobby_mary
	name = "Blobby Mary"
	id = "gs13_blobby_mary"
	result = "blobby_mary"
	required_reagents = list("tomatojuice" = 1, "vodka" = 1, "lipoifier" = 1)
	result_amount = 3

/datum/reagent/consumable/ethanol/beltbuster_mead
	name = "Beltbuster Mead"
	id = "beltbuster_mead"
	description = "Kiss sobriety and clothes goodbye."
	color = "#664300"
	alcohol_perc = 0.85
	taste_description = "honey, alcohol and immobility"
	drink_icon_file = 'modular_gs/icons/obj/drinks.dmi'
	drink_icon = "beltbuster_mead"
	drink_name = "beltbuster mead"
	drink_desc = "The ambrosia of the blubbery gods."

/datum/reagent/consumable/ethanol/beltbuster_mead/on_mob_life(mob/living/subject)
	if(iscarbon(subject))
		var/mob/living/carbon/carbon = subject
		carbon.adjust_nutrition(carbon.check_weight_prefs(FATTENING_TYPE_FOOD) ? 30 * REAGENTS_METABOLISM : 1)
	return ..()

/datum/chemical_reaction/gs13_beltbuster_mead
	name = "Beltbuster Mead"
	id = "gs13_beltbuster_mead"
	result = "beltbuster_mead"
	required_reagents = list("mead" = 1, "ethanol" = 1, "cream" = 1, "lipoifier" = 1)
	result_amount = 4

/datum/reagent/consumable/snakebite
	name = "Snakebite"
	id = "snakebite"
	description = "Guaranteed to stop 100% of all moving."
	color = "#00CC33"
	taste_description = "bitter immobility"
	drink_icon_file = 'modular_gs/icons/obj/drinks.dmi'
	drink_icon = "snakebite"
	drink_name = "snakebite"
	drink_desc = "Won't hurt like a real bite, but you'll still regret drinking this."

/datum/reagent/consumable/snakebite/on_mob_life(mob/living/subject)
	if(iscarbon(subject))
		var/mob/living/carbon/carbon = subject
		carbon.adjust_nutrition(carbon.check_weight_prefs(FATTENING_TYPE_FOOD) ? 25 * REAGENTS_METABOLISM : 1)
	return ..()

/datum/chemical_reaction/gs13_snakebite
	name = "Snakebite"
	id = "gs13_snakebite"
	result = "snakebite"
	required_reagents = list("toxin" = 1, "limejuice" = 1, "lipoifier" = 1)
	result_amount = 3

/datum/reagent/consumable/milkshake_chocolate
	name = "Chocolate Milkshake"
	id = "milkshake_chocolate"
	description = "It's like chocolate milk, but for even cooler kids."
	color = "#7D4E29"
	taste_description = "creamy chocolate"
	nutriment_factor = 8 * REAGENTS_METABOLISM
	drink_icon_file = 'modular_gs/icons/obj/drinks.dmi'
	drink_icon = "milkshake_chocolate"
	drink_name = "chocolate milkshake"
	drink_desc = "Nothing better than cream AND cocoa!"

/datum/chemical_reaction/gs13_milkshake_chocolate
	name = "Chocolate Milkshake"
	id = "gs13_milkshake_chocolate"
	result = "milkshake_chocolate"
	required_reagents = list("chocolate_milk" = 1, "cream" = 1, "cocoa" = 1)
	result_amount = 3
