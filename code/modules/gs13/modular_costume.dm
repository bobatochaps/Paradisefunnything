// Source six-channel costume: mask one is current body skin, two to seven
// are the six independently saved garment colors.
/obj/item/clothing/under/gs13_dual_tone/bunny_suit
	name = "modular bunny suit"
	desc = "A stretchy costume with independently colored fabric and details."
	icon = 'modular_gs/icons/obj/clothing/modclothes/bunny_suit.dmi'
	icon_state = "bunny_suit_preview"
	gs13_uniform_state = "bunny_suit"
	worn_icon = 'modular_gs/icons/mob/modclothes/bunny_suit_worn.dmi'
	gs13_modular_icon = 'modular_gs/icons/mob/modclothes/bunny_suit.dmi'
	gs13_uniform_colors = list("#ffffff", "#ffffff", "#ffffff", "#ffffff", "#ffffff", "#ffffff")
	gs13_skin_masks = TRUE
	gs13_skin_mask_index = 1
	gs13_color_mask_offset = 1

/datum/gear/uniform/suit/gs13_costume
	main_typepath = /datum/gear/uniform/suit/gs13_costume
	subtype_selection_cost = FALSE

/datum/gear/uniform/suit/gs13_costume/New()
	gear_tweaks = list(new /datum/gear_tweak/gs13_uniform_color/fabric, new /datum/gear_tweak/gs13_uniform_color/stripes, new /datum/gear_tweak/gs13_uniform_color/trim, new /datum/gear_tweak/gs13_uniform_color/detail_4, new /datum/gear_tweak/gs13_uniform_color/detail_5, new /datum/gear_tweak/gs13_uniform_color/detail_6)
	return ..()

/datum/gear/uniform/suit/gs13_costume/bunny_suit
	display_name = "Bunny suit (Modular)"
	path = /obj/item/clothing/under/gs13_dual_tone/bunny_suit
