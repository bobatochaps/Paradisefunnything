// GS13 blueberry juice, adapted to Paradise's string IDs and body-owned state.
/datum/reagent/blueberry_juice
	name = "Blueberry Juice"
	id = "blueberry_juice"
	description = "A sweet blue juice that can transform a willing drinker."
	reagent_state = LIQUID
	metabolization_rate = 0.25 * REAGENTS_METABOLISM
	color = "#0004ff"
	taste_description = "blueberry pie"
	var/no_mob_color = FALSE

/datum/reagent/blueberry_juice/update_gs13_transformation(mob/living/carbon/subject)
	if(!subject.gs13_preferences["blueberry_inflation"])
		// Opt-out discards the dose, including on disconnected or dead bodies.
		holder?.del_reagent(id)
		return
	if(!subject.can_gs13_transform_with(src))
		subject.remove_gs13_body_change(src)
		return
	subject.set_gs13_body_change(src, gs13_volume_to_fatness(volume), no_mob_color ? null : color)

/datum/reagent/blueberry_juice/on_mob_life(mob/living/subject)
	if(iscarbon(subject))
		var/mob/living/carbon/carbon_subject = subject
		if(!carbon_subject.gs13_preferences["blueberry_inflation"])
			holder.del_reagent(id)
			return STATUS_UPDATE_NONE
		if(volume >= 999 && ishuman(carbon_subject))
			var/mob/living/carbon/human/human_subject = carbon_subject
			if(!(locate(/datum/quirk/gs13_permaberry) in human_subject.quirks))
				var/datum/quirk/gs13_permaberry/quirk = new
				quirk.apply_quirk_effects(human_subject)
	return ..()
