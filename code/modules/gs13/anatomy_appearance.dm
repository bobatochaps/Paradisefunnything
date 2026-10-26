// Native paired anatomy using the unchanged source Smooth/Classic sheets.
/mob/living/carbon/human/proc/get_gs13_render_breasts()
	if(!gs13_preferences["anatomy_body_sprites"] || !GLOB.configuration.gs13?.fluid_anatomy_enabled || !dna || !istype(dna.species, /datum/species/human))
		return null
	var/obj/item/organ/internal/gs13_fluid_organ/breasts/breasts = get_organ_slot(GS13_ORGAN_BREASTS)
	var/obj/item/organ/external/chest = get_organ(BODY_ZONE_CHEST)
	if(!istype(breasts) || QDELETED(breasts) || breasts.owner != src || breasts.gs13_arrangement_multiplier != 2 || !isnum(breasts.gs13_size) || !GS13_IS_FINITE(breasts.gs13_size) || breasts.gs13_size <= 0 || !chest || chest.is_robotic())
		return null
	return breasts

/// Source clothing uses named states above size fifteen. Bound larger physical
/// sizes to the available art without changing the actual organ or reservoir.
/proc/gs13_breast_clothing_state(size)
	size = FLOOR(clamp(size, 0, 19), 1)
	switch(size)
		if(16)
			return "breasts_huge"
		if(17)
			return "breasts_massive"
		if(18)
			return "breasts_giga"
		if(19)
			return "breasts_impossible"
	return "breasts_[size]"

/mob/living/carbon/human/proc/gs13_add_breast_body(list/standing, size, obj/item/organ/external/chest, style = "Smooth")
	var/source_icon = style == "Classic" ? 'modular_gs/icons/mob/human/genitals/breasts_classic.dmi' : 'modular_gs/icons/mob/human/genitals/breasts_smooth.dmi'
	var/prefix = style == "Classic" ? "pair_gs" : "pair_gs_smooth"
	for(var/side in list("BEHIND", "FRONT"))
		var/state = "m_breasts_[prefix]_[size]_[side]"
		if(!icon_exists(source_icon, state))
			continue
		var/draw_layer = side == "BEHIND" ? -LIMBS_LAYER - 0.1 : -LIMBS_LAYER + 0.7
		var/mutable_appearance/part = mutable_appearance(source_icon, state, layer = draw_layer)
		part.color = gs13_weight_skin_color(chest, 18)
		standing += part

// Native transplants and extraction update the owned appearance immediately.
/obj/item/organ/internal/gs13_fluid_organ/breasts/insert(mob/living/carbon/recipient, special = 0)
	. = ..()
	if(reagents && owner && !QDELETED(owner))
		owner.update_gs13_fluid_sizes()
		owner.update_gs13_weight_appearance(TRUE)

/obj/item/organ/internal/gs13_fluid_organ/breasts/remove(mob/living/carbon/previous_owner, special = 0)
	var/mob/living/carbon/old_owner = owner
	. = ..()
	if(old_owner && !QDELETED(old_owner))
		old_owner.update_gs13_weight_appearance(TRUE)
