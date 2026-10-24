// Native Paradise adapter for GS13 species.dm and modular_items.dm.
// The first compatible body is the standard human. Other species keep their
// native appearance until their body-specific sprites have been adapted.
/proc/gs13_belly_styles()
	return list("Smooth without arms", "Classic", "Round", "Smooth")

/proc/gs13_belly_style_icon(style)
	switch(style)
		if("belly")
			return 'modular_gs/icons/mob/human/genitals/belly.dmi'
		if("round")
			return 'modular_gs/icons/mob/human/genitals/belly_round.dmi'
		if("smooth")
			return 'modular_gs/icons/mob/human/genitals/belly_smooth.dmi'
	return 'modular_gs/icons/mob/human/genitals/belly_smooth_noarms.dmi'

/mob/living/carbon/human/proc/get_gs13_belly_style()
	var/style = "smoothnoarms"
	switch(gs13_preferences["weight_belly_shape"])
		if("Classic")
			style = "belly"
		if("Round")
			style = "round"
		if("Smooth")
			style = "smooth"
	if(style != "smoothnoarms")
		// These source sheets include fat arms/hands. Keep native amputations and
		// prosthetics visible until those shapes have separate limb masks.
		for(var/zone in list(BODY_ZONE_L_ARM, BODY_ZONE_R_ARM, BODY_ZONE_PRECISE_L_HAND, BODY_ZONE_PRECISE_R_HAND))
			var/obj/item/organ/external/limb = get_organ(zone)
			if(!limb || limb.is_robotic())
				return "smoothnoarms"
	return style

/mob/living/carbon/proc/update_gs13_weight_appearance(force = FALSE)
	return

/mob/living/carbon/human/update_gs13_weight_appearance(force = FALSE)
	if(!dna || !istype(dna.species, /datum/species/human) || !gs13_body_effects_enabled() || !gs13_preferences["weight_body_sprites"] || notransform || HAS_TRAIT(src, TRAIT_SKELETONIZED))
		if(overlays_standing[GS13_WEIGHT_BODY_LAYER])
			remove_overlay(GS13_WEIGHT_BODY_LAYER)
		gs13_weight_appearance_key = null
		return

	// Use apparent weight, so belts and the pendant also conceal the silhouette.
	var/stage = gs13_weight_stage(fatness)
	var/current_fullness = get_fullness()
	var/shape = current_fullness > FULLNESS_LEVEL_BLOATED ? "stuffed" : "soft"
	var/belly_stage = stage
	if(current_fullness >= FULLNESS_LEVEL_NOMOREPLZ)
		belly_stage += 2
	else if(current_fullness >= FULLNESS_LEVEL_BEEG)
		belly_stage++
	belly_stage = min(belly_stage, 9)
	var/belly_style = get_gs13_belly_style()
	var/render_key = "[stage]:[shape]:[belly_stage]:[belly_style]:[HAS_TRAIT(src, TRAIT_HULK)]:[HAS_TRAIT(src, TRAIT_HUSK)]"
	if(!force && render_key == gs13_weight_appearance_key)
		return
	gs13_weight_appearance_key = render_key
	remove_overlay(GS13_WEIGHT_BODY_LAYER)
	if(!stage && !belly_stage)
		return

	var/list/standing = list()
	var/obj/item/organ/external/chest = get_organ(BODY_ZONE_CHEST)
	var/obj/item/organ/external/groin = get_organ(BODY_ZONE_PRECISE_GROIN)
	var/obj/item/organ/external/left_leg = get_organ(BODY_ZONE_L_LEG)
	var/obj/item/organ/external/right_leg = get_organ(BODY_ZONE_R_LEG)
	var/has_belly = chest && !chest.is_robotic()
	// The source hip sprite includes both thighs. Do not draw phantom limbs.
	var/has_hips = groin && !groin.is_robotic() && left_leg && !left_leg.is_robotic() && right_leg && !right_leg.is_robotic()
	var/suit_coverage = wear_suit?.gs13_shows_weight_body ? NONE : wear_suit?.body_parts_covered
	var/chest_covered = (w_uniform?.body_parts_covered & UPPER_TORSO) || (suit_coverage & UPPER_TORSO)
	var/hips_covered = (w_uniform?.body_parts_covered & (LOWER_TORSO | LEGS)) || (suit_coverage & (LOWER_TORSO | LEGS))
	if(has_belly && stage && !chest_covered)
		var/mutable_appearance/belly = mutable_appearance(gs13_belly_style_icon(belly_style), "m_belly_[belly_style]_[stage]_FRONT", layer = -LIMBS_LAYER + 0.5)
		belly.color = gs13_weight_skin_color(chest, 18)
		standing += belly
	if(has_hips && stage && !hips_covered)
		var/mutable_appearance/hips = mutable_appearance('modular_gs/icons/mob/human/genitals/butt.dmi', "m_butt_pair_gs_[stage]_ADJ_primary", layer = -LIMBS_LAYER + 0.4)
		hips.color = gs13_weight_skin_color(groin, 10)
		standing += hips

	var/obj/item/clothing/under/uniform = w_uniform
	if(istype(uniform) && uniform.gs13_modular_icon && !(wear_suit?.flags_inv & HIDEJUMPSUIT) && !HAS_TRAIT(uniform, TRAIT_NO_WORN_ICON))
		var/tint = uniform.gs13_modular_color()
		var/suffix = uniform.rolled_down ? "_d" : ""
		if(has_belly)
			gs13_add_weight_clothing(standing, uniform, "belly_[shape]_[belly_stage][suffix]", -UNIFORM_LAYER + 0.1, tint)
			gs13_add_weight_clothing(standing, uniform, "belly_[shape]_[belly_stage][suffix]_SOUTH", -UNIFORM_LAYER + 0.2, tint)
		if(has_hips && stage)
			gs13_add_weight_clothing(standing, uniform, "butt_[stage]", -UNIFORM_LAYER + 0.1, tint)
			gs13_add_weight_clothing(standing, uniform, "butt_[stage]_NORTH", -UNIFORM_LAYER + 0.2, tint)
	if(length(standing))
		overlays_standing[GS13_WEIGHT_BODY_LAYER] = standing
		apply_overlay(GS13_WEIGHT_BODY_LAYER)

/// Sample the limb's rendered skin, including its native skin-tone and decay
/// shading. Do not recolor a shared base-body cache entry.
/mob/living/carbon/human/proc/gs13_weight_skin_color(obj/item/organ/external/limb, sample_y)
	if(HAS_TRAIT(src, TRAIT_HUSK))
		return rgb(96, 88, 80)
	if(HAS_TRAIT(src, TRAIT_HULK))
		return rgb(48, 224, 40)
	var/skin = limb.mob_icon?.GetPixel(16, sample_y, SOUTH)
	if(skin && skin != "#00000000")
		return skin
	return dna.species.skin_tone_to_hex(clamp(s_tone, 1, 13))

/mob/living/carbon/human/proc/gs13_add_weight_clothing(list/standing, obj/item/clothing/under/uniform, state, draw_layer, tint)
	if(!icon_exists(uniform.gs13_modular_icon, state))
		return
	var/mutable_appearance/panel = mutable_appearance(uniform.gs13_modular_icon, state, layer = draw_layer, alpha = uniform.alpha, color = tint)
	standing += panel

/obj/item/clothing/under/proc/gs13_modular_color()
	return color

/obj/item/clothing/under/color/grey/gs13_modular_color()
	// Native dyeing selects the base suit palette. Tint the source panels with
	// its highlight, including after redyeing.
	var/list/palette = GLOB.palette_registry[DYE_REGISTRY_UNDER][gs13_modular_palette_key]
	return length(palette) ? palette[length(palette)] : color

/obj/item/clothing/under/color/grey/service
	name = "service modular jumpsuit"
	icon_palette_key = DYE_GREEN

/obj/item/clothing/under/color/grey/medical
	name = "medical modular jumpsuit"
	icon_palette_key = DYE_LIGHTBLUE

/obj/item/clothing/under/color/grey/cargo
	name = "cargo modular jumpsuit"
	icon_palette_key = DYE_LIGHTBROWN

/obj/item/clothing/under/color/grey/engi
	name = "engineering modular jumpsuit"
	icon_palette_key = DYE_ORANGE

/obj/item/clothing/under/color/grey/science
	name = "science modular jumpsuit"
	icon_palette_key = DYE_PURPLE

/obj/item/clothing/under/color/grey/security
	name = "security modular jumpsuit"
	icon_palette_key = DYE_RED

/obj/item/clothing/under/color/grey/security/blue
	name = "blue security modular jumpsuit"
	icon_palette_key = DYE_DARKBLUE

/obj/item/clothing/under/color/grey/command
	name = "command modular jumpsuit"
	icon_palette_key = DYE_BLUE
