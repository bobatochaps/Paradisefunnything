// The source shirt families share the native indexed-mask adapter.
/obj/item/clothing/under/gs13_dual_tone/button_up
	name = "modular button-up shirt"
	desc = "A button-up shirt with matching trousers and adjustable colors."
	icon = 'modular_gs/icons/obj/clothing/modclothes/button_up.dmi'
	icon_state = "button_up"
	worn_icon = 'modular_gs/icons/mob/modclothes/button_up_worn.dmi'
	gs13_modular_icon = 'modular_gs/icons/mob/modclothes/button_up.dmi'
	gs13_uniform_colors = list("#ffffff", "#ffffff", "#ffffff")
	gs13_skin_masks = TRUE

/obj/item/clothing/under/gs13_dual_tone/button_up/turtleneck
	name = "modular turtleneck shirt"
	desc = "A turtleneck shirt with matching trousers and adjustable colors."
	icon = 'modular_gs/icons/obj/clothing/modclothes/turtleneck.dmi'
	icon_state = "turtleneck"
	worn_icon = 'modular_gs/icons/mob/modclothes/turtleneck_worn.dmi'
	gs13_modular_icon = 'modular_gs/icons/mob/modclothes/turtleneck.dmi'

/obj/item/clothing/under/gs13_dual_tone/button_up/turtleneck/gs13_uniform_mask_state(state, channel)
	. = ..()
	// This unchanged source sheet uses hyphens for front breast panels but
	// underscores for its south panels. Resolve the real state without editing art.
	if(!icon_exists(gs13_modular_icon, .) && findtext(state, "breasts_") == 1)
		. = "[replacetext(state, "breasts_", "breasts-")][channel ? "-[channel]" : ""]"

/datum/gear/uniform/suit/gs13_shirt
	main_typepath = /datum/gear/uniform/suit/gs13_shirt
	subtype_selection_cost = FALSE

/datum/gear/uniform/suit/gs13_shirt/New()
	gear_tweaks = list(new /datum/gear_tweak/gs13_uniform_color/fabric, new /datum/gear_tweak/gs13_uniform_color/stripes, new /datum/gear_tweak/gs13_uniform_color/trim)
	return ..()

/datum/gear/uniform/suit/gs13_shirt/button_up
	display_name = "Button-up shirt (Modular)"
	path = /obj/item/clothing/under/gs13_dual_tone/button_up

/datum/gear/uniform/suit/gs13_shirt/turtleneck
	display_name = "Turtleneck shirt (Modular)"
	path = /obj/item/clothing/under/gs13_dual_tone/button_up/turtleneck
