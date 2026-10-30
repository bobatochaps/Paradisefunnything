// Source cloth eating is contextual. Clothing remains ordinary native clothing;
// only an organ-owned cloth eater can use its private food proxy in nullspace.
/obj/item/clothing
	var/gs13_cloth_edible = TRUE
	var/gs13_cloth_feeding = FALSE
	var/obj/item/food/gs13_clothing/gs13_moth_snack

/obj/item/clothing/mask/muzzle
	gs13_cloth_edible = FALSE

/obj/item/clothing/interact_with_atom(atom/target, mob/living/user, list/modifiers)
	if(user.a_intent == INTENT_HARM || !HAS_TRAIT(user, TRAIT_GS13_CLOTH_EATER) || !ishuman(target) || !gs13_cloth_edible || (resistance_flags & INDESTRUCTIBLE) || istype(src, /obj/item/clothing/mask/facehugger))
		return ..()
	if(gs13_cloth_feeding || user.incapacitated() || HAS_TRAIT(user, TRAIT_HANDS_BLOCKED) || user.get_active_hand() != src || !user.Adjacent(target))
		return ITEM_INTERACT_COMPLETE
	var/mob/living/carbon/human/subject = target
	if(subject.stat == DEAD || subject.is_mouth_covered())
		return ITEM_INTERACT_COMPLETE
	if(QDELETED(gs13_moth_snack))
		gs13_moth_snack = new
		gs13_moth_snack.name = name
		gs13_moth_snack.gs13_clothing_uid = UID()
	gs13_cloth_feeding = TRUE
	gs13_moth_snack.gs13_feeder_uid = user.UID()
	gs13_moth_snack.gs13_target_uid = subject.UID()
	. = gs13_moth_snack.interact_with_atom(subject, user, modifiers)
	if(!QDELETED(src))
		gs13_cloth_feeding = FALSE
		if(!QDELETED(gs13_moth_snack))
			gs13_moth_snack.gs13_feeder_uid = null
			gs13_moth_snack.gs13_target_uid = null

/obj/item/clothing/Destroy()
	QDEL_NULL(gs13_moth_snack)
	return ..()

/obj/item/food
	/// Optional oral-context validation, including after delayed native feeding.
	var/datum/callback/gs13_bite_validator

/obj/item/food/gs13_clothing
	name = "temporary clothing snack"
	desc = "A private proxy for a moth eating an actual piece of clothing."
	list_reagents = list("gs13_cloth_fibers" = 2)
	bitesize = 1
	tastes = list("dust" = 1, "lint" = 1)
	antable = FALSE
	var/gs13_clothing_uid
	var/gs13_feeder_uid
	var/gs13_target_uid

/obj/item/food/gs13_clothing/Initialize(mapload)
	. = ..()
	gs13_bite_validator = CALLBACK(src, PROC_REF(valid_gs13_cloth_bite))

/obj/item/food/gs13_clothing/Destroy()
	QDEL_NULL(gs13_bite_validator)
	return ..()

/obj/item/food/gs13_clothing/proc/valid_gs13_cloth_bite()
	var/obj/item/clothing/garment = locateUID(gs13_clothing_uid)
	var/mob/living/feeder = locateUID(gs13_feeder_uid)
	var/mob/living/carbon/human/subject = locateUID(gs13_target_uid)
	return !QDELETED(src) && !QDELETED(garment) && !QDELETED(feeder) && !QDELETED(subject) && garment.gs13_moth_snack == src && garment.gs13_cloth_feeding && garment.gs13_cloth_edible && !(garment.resistance_flags & INDESTRUCTIBLE) && HAS_TRAIT(feeder, TRAIT_GS13_CLOTH_EATER) && !feeder.incapacitated() && !HAS_TRAIT(feeder, TRAIT_HANDS_BLOCKED) && feeder.get_active_hand() == garment && feeder.Adjacent(subject) && subject.stat != DEAD && !subject.is_mouth_covered()

/obj/item/food/gs13_clothing/On_Consume(mob/consumer, mob/user)
	if(!valid_gs13_cloth_bite())
		return
	var/obj/item/clothing/garment = locateUID(gs13_clothing_uid)
	// Source infinite proxy stock means repeated bites, not infinite real food.
	// Keep two units here so native final-bite cleanup cannot delete the proxy.
	reagents.add_reagent("gs13_cloth_fibers", max(0, 2 - reagents.total_volume))
	. = ..()
	if(!QDELETED(garment))
		garment.take_damage(GS13_MOTH_CLOTHING_DAMAGE, BRUTE, sound_effect = FALSE)

/datum/reagent/consumable/nutriment/gs13_cloth_fibers
	name = "Cloth Fibers"
	id = "gs13_cloth_fibers"
	description = "Textile fibers that temporarily keep a cloth eater going."
	taste_description = "cloth"
	nutriment_factor = 30 * REAGENTS_METABOLISM
	brute_heal = 0
	burn_heal = 0
	var/gs13_delayed_nutrition_drain = 2 * GS13_CLOTHING_NUTRITION_GAIN

/datum/reagent/consumable/nutriment/gs13_cloth_fibers/on_mob_life(mob/living/subject)
	// Native parent life removes the final dose immediately, so accrue the
	// temporary gain and matching debt before that deletion callback can run.
	if(ishuman(subject) && subject.satiety < GS13_MAX_SATIETY)
		subject.adjust_nutrition(GS13_CLOTHING_NUTRITION_GAIN)
		gs13_delayed_nutrition_drain += GS13_CLOTHING_NUTRITION_GAIN
	return ..()

/datum/reagent/consumable/nutriment/gs13_cloth_fibers/on_mob_delete(mob/living/subject)
	. = ..()
	if(ishuman(subject))
		subject.adjust_nutrition(-gs13_delayed_nutrition_drain)
	gs13_delayed_nutrition_drain = 0
