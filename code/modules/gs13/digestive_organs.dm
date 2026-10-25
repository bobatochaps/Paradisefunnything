// Native anatomy for the source's fullness-burst stomach injury.
/datum/species
	/// Override for inherited species with specialized digestive anatomy.
	var/gs13_stomach_type = /obj/item/organ/internal/gs13_stomach

/datum/species/proc/add_gs13_digestive_organs()
	// Existing organic digestive layouts have a liver. Preserve reduced/synthetic
	// layouts until their own source species adapters supply specialized organs.
	if(!gs13_stomach_type || !has_organ["liver"] || has_organ[GS13_ORGAN_STOMACH])
		return
	has_organ = has_organ.Copy()
	has_organ[GS13_ORGAN_STOMACH] = gs13_stomach_type

/obj/item/organ/internal/gs13_stomach
	name = "stomach"
	desc = "A digestive organ. Damage makes it difficult to keep food down."
	icon = 'modular_gs/icons/upstream/organs.dmi'
	icon_state = "stomach"
	organ_tag = GS13_ORGAN_STOMACH
	slot = GS13_ORGAN_STOMACH
	parent_organ = BODY_ZONE_CHEST
	max_damage = 100
	min_bruised_damage = 10
	min_broken_damage = 45
	var/gs13_digestive_efficiency = 0.05
	var/gs13_digesting = FALSE
	var/gs13_transfer_id
	var/gs13_transfer_volume = 0
	var/gs13_transfer_start_volume = 0

/obj/item/organ/internal/gs13_stomach/Initialize(mapload, mob/living/carbon/holder)
	. = ..()
	create_reagents(1000)

/obj/item/organ/internal/gs13_stomach/on_life()
	if(!owner || owner.stat == DEAD)
		return
	digest_gs13_reagents(2)
	if(damage < min_bruised_damage || !get_turf(owner))
		return
	var/datum/reagent/consumable/nutriment/food = locate(/datum/reagent/consumable/nutriment) in reagents?.reagent_list
	if(!food || food.volume <= 0)
		return
	var/food_volume = min(1000, food.volume)
	var/minor_chance = clamp(0.0125 * damage * food_volume * food_volume, 0, 100) / 100
	var/major_chance = damage > min_broken_damage ? clamp(0.05 * damage * food_volume * food_volume, 0, 100) / 100 : 0
	// Source probabilities are per second; native organs tick every two seconds.
	if(prob(100 * (1 - (1 - minor_chance) ** 2 * (1 - major_chance) ** 2)))
		owner.vomit(lost_nutrition = damage)
		to_chat(owner, SPAN_WARNING("Your injured stomach cannot hold down all that food!"))
