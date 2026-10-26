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
	var/gs13_healing_factor = GS13_STANDARD_ORGAN_HEALING
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
	heal_gs13_tissue(2)
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

/// Source organic repair is a fraction of maximum health per second, with up
/// to four extra portions from positive satiety. Native food already uses the
/// same 600-point quality scale; nutrition/fullness are distinct from satiety.
/obj/item/organ/internal/gs13_stomach/proc/heal_gs13_tissue(seconds = 2)
	if(QDELETED(src) || !owner || QDELETED(owner) || owner.stat == DEAD || owner.get_organ_slot(slot) != src || is_robotic() || (status & ORGAN_DEAD))
		return 0
	if(!isnum(seconds) || !GS13_IS_FINITE(seconds) || seconds <= 0 || !isnum(damage) || !GS13_IS_FINITE(damage) || damage <= 0 || damage >= max_damage)
		return 0
	if(!isnum(max_damage) || !GS13_IS_FINITE(max_damage) || max_damage <= 0 || !isnum(gs13_healing_factor) || !GS13_IS_FINITE(gs13_healing_factor) || gs13_healing_factor <= 0)
		return 0
	var/quality = isnum(owner.satiety) && GS13_IS_FINITE(owner.satiety) ? clamp(owner.satiety, 0, GS13_MAX_SATIETY) : 0
	var/amount = min(damage, gs13_healing_factor * max_damage * seconds * (1 + 4 * quality / GS13_MAX_SATIETY))
	var/before = damage
	heal_internal_damage(amount)
	return max(0, before - damage)
