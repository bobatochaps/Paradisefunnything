// Pinned specialized stomachs through native species and physical organ APIs.
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
	gs13_organ_traits = list(TRAIT_NOHUNGER)

/obj/item/organ/internal/gs13_stomach
	var/list/gs13_organ_traits

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
	var/gs13_emp_vulnerability = 80
	var/gs13_emp_failure = FALSE
	var/gs13_emp_damage_remainder = 0
	var/gs13_emp_decay_factor = GS13_STANDARD_ORGAN_DECAY * 1.15

/obj/item/organ/internal/gs13_stomach/cybernetic/emp_act(severity)
	if(emp_proof || !isnum(severity) || !GS13_IS_FINITE(severity) || severity < EMP_HEAVY || severity > EMP_WEAKENED)
		return
	. = ..()
	if(QDELETED(src) || !isnum(gs13_emp_vulnerability) || !GS13_IS_FINITE(gs13_emp_vulnerability))
		return
	// Preserve source heavy/light severity 1/2 across native levels 1/3;
	// native resisted/weakened levels occupy intermediate/fainter strengths.
	var/source_severity = 1 + (severity - EMP_HEAVY) / (EMP_LIGHT - EMP_HEAVY)
	if(prob(clamp(gs13_emp_vulnerability / source_severity, 0, 100)))
		gs13_emp_failure = TRUE

/obj/item/organ/internal/gs13_stomach/cybernetic/on_life()
	advance_gs13_emp_failure(2)
	return ..()

/// Carry native hundredth-health rounding forward so repeated small source
/// decay ticks neither lose damage nor accumulate a systematic timing error.
/obj/item/organ/internal/gs13_stomach/cybernetic/proc/advance_gs13_emp_failure(seconds)
	if(!gs13_emp_failure || !owner || QDELETED(owner) || owner.stat == DEAD || owner.get_organ_slot(slot) != src || (status & ORGAN_DEAD) || tough)
		return 0
	if(!isnum(seconds) || !GS13_IS_FINITE(seconds) || seconds <= 0 || !isnum(max_damage) || !GS13_IS_FINITE(max_damage) || max_damage <= 0 || !isnum(gs13_emp_decay_factor) || !GS13_IS_FINITE(gs13_emp_decay_factor) || gs13_emp_decay_factor <= 0)
		return 0
	var/requested = gs13_emp_decay_factor * max_damage * seconds + gs13_emp_damage_remainder
	if(requested <= 0)
		gs13_emp_damage_remainder = requested
		return 0
	var/before = damage
	receive_damage(requested, TRUE)
	var/applied = max(0, damage - before)
	gs13_emp_damage_remainder = requested - applied
	return applied

/obj/item/organ/internal/gs13_stomach/cybernetic/rejuvenate()
	. = ..()
	gs13_emp_failure = FALSE
	gs13_emp_damage_remainder = 0

/obj/item/organ/internal/gs13_stomach/cybernetic/examine(mob/user)
	. = ..()
	if(gs13_emp_failure)
		. += SPAN_WARNING("An electrical fault is causing progressive internal damage.")

/obj/item/organ/internal/gs13_stomach/cybernetic/tier2
	name = "cybernetic stomach"
	desc = "An electronic stomach with improved digestion and durability."
	icon_state = "stomach-c-u"
	max_damage = 150
	gs13_digestive_efficiency = 0.07
	gs13_item_acid_power = 20
	gs13_emp_vulnerability = 40

/obj/item/organ/internal/gs13_stomach/cybernetic/tier3
	name = "upgraded cybernetic stomach"
	desc = "An upgraded electronic stomach with rapid digestive processing."
	icon_state = "stomach-c-u2"
	max_damage = 200
	gs13_digestive_efficiency = 0.1
	gs13_item_acid_power = 35
	gs13_emp_vulnerability = 20

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

/datum/species/moth
	gs13_stomach_type = /obj/item/organ/internal/gs13_stomach/moth

/obj/item/organ/internal/gs13_stomach/moth
	name = "moth stomach"
	desc = "An insectoid stomach adapted to digesting textile fibers."
	icon_state = "spinner-x"
	gs13_organ_traits = list(TRAIT_GS13_CLOTH_EATER)
