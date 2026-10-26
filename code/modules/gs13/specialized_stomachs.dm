// Pinned source bone/crystal stomachs through native species and organ APIs.
/datum/species/skeleton
	gs13_stomach_type = /obj/item/organ/internal/gs13_stomach/bone
	gs13_stomach_requires_liver = FALSE

/datum/species/plasmaman
	gs13_stomach_type = /obj/item/organ/internal/gs13_stomach/bone/plasmaman

/obj/item/organ/internal/gs13_stomach/bone
	name = "mass of bones"
	desc = "A dense cluster of bones that slowly processes swallowed material."
	icon_state = "stomach-bone"
	gs13_digestive_efficiency = 0.025
	var/list/gs13_organ_traits = list(TRAIT_NOHUNGER)

/obj/item/organ/internal/gs13_stomach/bone/insert(mob/living/carbon/recipient, special = 0, dont_remove_slot = 0)
	. = ..()
	if(owner && owner.get_organ_slot(slot) == src)
		for(var/trait in gs13_organ_traits)
			ADD_TRAIT(owner, trait, "gs13_stomach_[UID()]")

/obj/item/organ/internal/gs13_stomach/bone/remove(mob/living/carbon/previous_owner, special = 0)
	if(owner)
		for(var/trait in gs13_organ_traits)
			REMOVE_TRAIT(owner, trait, "gs13_stomach_[UID()]")
	return ..()

/obj/item/organ/internal/gs13_stomach/bone/plasmaman
	name = "digestive crystal"
	desc = "A crystal organ that processes swallowed material for a Plasmaman."
	icon_state = "stomach-p"
	gs13_digestive_efficiency = 0.06
	gs13_organ_traits = null
