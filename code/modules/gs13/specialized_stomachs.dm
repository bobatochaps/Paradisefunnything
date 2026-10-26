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

// Three normally researched source prostheses. Native electronic-organ EMP,
// repair, necrosis and transplant APIs own their ordinary medical lifecycle.
/obj/item/organ/internal/gs13_stomach/cybernetic
	name = "basic cybernetic stomach"
	desc = "A basic electronic replacement for a digestive stomach."
	icon_state = "stomach-c"
	status = ORGAN_ROBOT
	max_damage = 50
	gs13_digestive_efficiency = 0.035

/obj/item/organ/internal/gs13_stomach/cybernetic/tier2
	name = "cybernetic stomach"
	desc = "An electronic stomach with improved digestion and durability."
	icon_state = "stomach-c-u"
	max_damage = 150
	gs13_digestive_efficiency = 0.07

/obj/item/organ/internal/gs13_stomach/cybernetic/tier3
	name = "upgraded cybernetic stomach"
	desc = "An upgraded electronic stomach with rapid digestive processing."
	icon_state = "stomach-c-u2"
	max_damage = 200
	gs13_digestive_efficiency = 0.1

/datum/design/gs13_cybernetic_stomach
	name = "Basic Cybernetic Stomach"
	desc = "A basic prosthetic digestive stomach."
	id = "gs13_cybernetic_stomach"
	req_tech = list("biotech" = 4, "materials" = 4)
	build_type = PROTOLATHE | MECHFAB
	materials = list(MAT_METAL = 500, MAT_GLASS = 500)
	construction_time = 60
	build_path = /obj/item/organ/internal/gs13_stomach/cybernetic
	category = list("Medical")

/datum/design/gs13_cybernetic_stomach/tier2
	name = "Cybernetic Stomach"
	desc = "An improved prosthetic digestive stomach."
	id = "gs13_cybernetic_stomach_tier2"
	req_tech = list("biotech" = 5, "materials" = 5, "engineering" = 5)
	build_path = /obj/item/organ/internal/gs13_stomach/cybernetic/tier2

/datum/design/gs13_cybernetic_stomach/tier3
	name = "Upgraded Cybernetic Stomach"
	desc = "An upgraded prosthetic digestive stomach."
	id = "gs13_cybernetic_stomach_tier3"
	req_tech = list("biotech" = 6, "materials" = 6, "engineering" = 6)
	materials = list(MAT_METAL = 500, MAT_GLASS = 500, MAT_SILVER = 500)
	build_path = /obj/item/organ/internal/gs13_stomach/cybernetic/tier3
