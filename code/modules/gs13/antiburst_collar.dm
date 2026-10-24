// Native locking collar and signaler receiver for the GS13 stabilizing field.
/proc/gs13_antiburst_sprites()
	var/static/list/sprites
	if(sprites)
		return sprites
	var/resource = 'modular_gs/icons/upstream/antiburst_collar.dmi'
	var/icon/object = icon(resource, "collar_band_gray")
	object.Blend("#0B2A8F", ICON_MULTIPLY)
	var/icon/tracker = icon(resource, "collar_tracker_gray")
	tracker.Blend("#0A0F1D", ICON_MULTIPLY)
	object.Blend(tracker, ICON_OVERLAY)
	object.Blend(icon(resource, "collar_screen"), ICON_OVERLAY)
	var/icon/body = icon(resource, "collar_mob_tracker_gray")
	body.Blend("#0A0F1D", ICON_MULTIPLY)
	var/icon/band = icon(resource, "collar_mob_band_gray")
	band.Blend("#0B2A8F", ICON_MULTIPLY)
	body.Blend(band, ICON_OVERLAY)
	var/icon/left = icon(resource, "collar_inhand_tracker_l_gray")
	left.Blend("#0A0F1D", ICON_MULTIPLY)
	band = icon(resource, "collar_inhand_band_l_gray")
	band.Blend("#0B2A8F", ICON_MULTIPLY)
	left.Blend(band, ICON_OVERLAY)
	var/icon/right = icon(resource, "collar_inhand_tracker_r_gray")
	right.Blend("#0A0F1D", ICON_MULTIPLY)
	band = icon(resource, "collar_inhand_band_r_gray")
	band.Blend("#0B2A8F", ICON_MULTIPLY)
	right.Blend(band, ICON_OVERLAY)
	sprites = list(object, body, left, right)
	return sprites

/obj/item/clothing/neck/human_petcollar/locked/antiburst
	name = "WT field generator collar"
	desc = "A locking collar that prevents accidental bursting by generating a water-tight stabilizing field."
	resistance_flags = FIRE_PROOF | ACID_PROOF
	materials = list(MAT_METAL = 1000, MAT_CALORITE = 1000, MAT_BLUESPACE = 500)
	origin_tech = "materials=4;biotech=4;bluespace=3"
	var/field_active = FALSE
	var/mob/living/carbon/human/field_wearer
	var/obj/item/assembly/signaler/gs13_antiburst/integrated_signaler

/obj/item/clothing/neck/human_petcollar/locked/antiburst/Initialize(mapload)
	. = ..()
	var/list/sprites = gs13_antiburst_sprites()
	icon = sprites[1]
	worn_icon = sprites[2]
	lefthand_file = sprites[3]
	righthand_file = sprites[4]
	icon_state = ""
	worn_icon_state = ""
	inhand_icon_state = ""
	integrated_signaler = new(src, src)
	update_icon(UPDATE_OVERLAYS)

/obj/item/clothing/neck/human_petcollar/locked/antiburst/Destroy()
	clear_field_wearer()
	QDEL_NULL(integrated_signaler)
	return ..()

/obj/item/clothing/neck/human_petcollar/locked/antiburst/proc/clear_field_wearer()
	if(field_wearer)
		REMOVE_TRAIT(field_wearer, TRAIT_NO_BURST, UID())
	field_wearer = null

/obj/item/clothing/neck/human_petcollar/locked/antiburst/proc/refresh_field()
	var/mob/living/carbon/human/new_wearer = field_active ? get_wearer() : null
	if(field_wearer != new_wearer)
		clear_field_wearer()
		field_wearer = new_wearer
	if(field_wearer)
		ADD_TRAIT(field_wearer, TRAIT_NO_BURST, UID())
	update_icon(UPDATE_OVERLAYS)
	get_wearer()?.update_inv_neck()

/obj/item/clothing/neck/human_petcollar/locked/antiburst/proc/toggle_field()
	field_active = !field_active
	refresh_field()
	return TRUE

/obj/item/clothing/neck/human_petcollar/locked/antiburst/equipped(mob/user, slot, initial = FALSE)
	. = ..()
	refresh_field()

/obj/item/clothing/neck/human_petcollar/locked/antiburst/dropped(mob/user, silent = FALSE)
	clear_field_wearer()
	return ..()

/obj/item/clothing/neck/human_petcollar/locked/antiburst/Moved(atom/oldloc, dir, forced = FALSE)
	. = ..()
	refresh_field()

/obj/item/clothing/neck/human_petcollar/locked/antiburst/update_overlays()
	. = ..()
	if(field_active)
		. += mutable_appearance('modular_gs/icons/upstream/antiburst_collar.dmi', "light")
		. += emissive_appearance('modular_gs/icons/upstream/antiburst_collar.dmi', "light")

/obj/item/proc/get_gs13_neck_overlays()
	return null

/obj/item/clothing/neck/human_petcollar/locked/antiburst/get_gs13_neck_overlays()
	if(field_active)
		return list(mutable_appearance('modular_gs/icons/upstream/antiburst_collar.dmi', "collar_mob_tracker_light"), emissive_appearance('modular_gs/icons/upstream/antiburst_collar.dmi', "collar_mob_tracker_light"))

/obj/item/clothing/neck/human_petcollar/locked/antiburst/gs13_activation_hint()
	return "Activate it in hand to configure its stabilizing field, frequency, and code."

/obj/item/clothing/neck/human_petcollar/locked/antiburst/examine(mob/user)
	. = ..()
	. += SPAN_NOTICE("The stabilizing field is [field_active ? "on" : "off"]. A matching remote signal toggles it.")

/obj/item/clothing/neck/human_petcollar/locked/antiburst/activate_self(mob/user)
	if(can_manipulate(user) && loc == user)
		ui_interact(user)
	return ITEM_INTERACT_COMPLETE

/obj/item/clothing/neck/human_petcollar/locked/antiburst/ui_state(mob/user)
	return GLOB.deep_inventory_state

/obj/item/clothing/neck/human_petcollar/locked/antiburst/ui_interact(mob/user, datum/tgui/ui = null)
	if(!can_manipulate(user) || loc != user)
		return
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "Electropack", name)
		ui.open()

/obj/item/clothing/neck/human_petcollar/locked/antiburst/ui_data(mob/user)
	return list("power" = field_active, "frequency" = integrated_signaler.frequency, "code" = integrated_signaler.code, "minFrequency" = RADIO_LOW_FREQ, "maxFrequency" = RADIO_HIGH_FREQ - 1)

/obj/item/clothing/neck/human_petcollar/locked/antiburst/ui_act(action, list/params)
	if(..())
		return
	return apply_field_control(action, params, usr)

/obj/item/clothing/neck/human_petcollar/locked/antiburst/proc/apply_field_control(action, list/params, mob/user)
	if(QDELETED(integrated_signaler) || !can_manipulate(user) || loc != user)
		return FALSE
	switch(action)
		if("power")
			return toggle_field()
		if("freq", "code")
			var/value = params[action]
			if(istext(value))
				value = text2num(value)
			if(!isnum(value) || !GS13_IS_FINITE(value))
				return FALSE
			if(action == "freq")
				integrated_signaler.frequency = sanitize_frequency(clamp(value, RADIO_LOW_FREQ / 10, (RADIO_HIGH_FREQ - 1) / 10) * 10, RADIO_LOW_FREQ, RADIO_HIGH_FREQ - 1)
			else
				integrated_signaler.code = clamp(round(value), 1, 100)
			return TRUE
		if("reset")
			if(params["reset"] == "freq")
				integrated_signaler.frequency = initial(integrated_signaler.frequency)
				return TRUE
			if(params["reset"] == "code")
				integrated_signaler.code = initial(integrated_signaler.code)
				return TRUE
	return FALSE

/obj/item/assembly/signaler/gs13_antiburst
	frequency = ELECTROPACK_FREQ
	code = 2
	receiving = TRUE
	var/obj/item/clothing/neck/human_petcollar/locked/antiburst/collar

/obj/item/assembly/signaler/gs13_antiburst/Initialize(mapload, new_collar)
	. = ..()
	collar = new_collar

/obj/item/assembly/signaler/gs13_antiburst/signal_callback()
	if(!QDELETED(collar))
		collar.toggle_field()

/obj/item/assembly/signaler/gs13_antiburst/Destroy()
	collar = null
	return ..()

/datum/design/gs13_antiburst_collar
	name = "WT Field Generator Collar"
	id = "gs13_antiburst_collar"
	req_tech = list("materials" = 4, "biotech" = 4, "bluespace" = 3)
	build_type = PROTOLATHE
	materials = list(MAT_METAL = 1000, MAT_CALORITE = 1000, MAT_BLUESPACE = 500)
	build_path = /obj/item/clothing/neck/human_petcollar/locked/antiburst
	category = list("Medical")
