// Original GS13 indexed masks rendered through native Paradise icons.
GLOBAL_LIST_EMPTY(gs13_uniform_protection_cache)

/// List-valued type defaults are runtime initializers in DM. Resolve each
/// ordinary native uniform once, after its real armor initialization.
/proc/gs13_native_uniform_protection(uniform_path)
	var/list/protection = GLOB.gs13_uniform_protection_cache[uniform_path]
	if(protection)
		return protection
	var/obj/item/clothing/under/template = new uniform_path
	protection = list("armor" = template.armor, "permeability" = template.permeability_coefficient, "resistance" = template.resistance_flags)
	GLOB.gs13_uniform_protection_cache[uniform_path] = protection
	qdel(template)
	return protection

/obj/item/clothing/under/proc/gs13_clothing_belly_shape(shape)
	return shape

/obj/item/clothing/under/proc/gs13_add_modular_panels(list/standing, state, draw_layer, tint, skin_tint)
	if(!icon_exists(gs13_modular_icon, state))
		return
	standing += mutable_appearance(gs13_modular_icon, state, layer = draw_layer, alpha = alpha, color = tint)

/obj/item/clothing/under/gs13_dual_tone
	name = "white dual-tone modular jumpsuit"
	desc = "A stretchy jumpsuit with independently colored fabric and stripes."
	icon = 'modular_gs/icons/obj/clothing/modclothes/dual_tone_suit.dmi'
	icon_state = "dual_tone_jumpsuit"
	worn_icon = 'modular_gs/icons/mob/modclothes/dual_tone_suit_worn.dmi'
	inhand_icon_state = "w_suit"
	sprite_sheets = null
	gs13_modular_icon = 'modular_gs/icons/mob/modclothes/dual_tone_suit.dmi'
	/// Static object previews stay valid before native initialization.
	var/gs13_uniform_state = "dual_tone_jumpsuit"
	var/list/gs13_uniform_colors = list("#ffffff", "#ffffff")
	var/gs13_skin_masks = FALSE
	var/gs13_skin_mask_index = 4
	var/gs13_color_mask_offset = 0
	var/gs13_recolorable = TRUE
	/// A native uniform supplies ratings instead of importing TG armor units.
	var/gs13_protection_template
	/// Only requested color masks are cached, and only for this actual suit.
	var/list/gs13_panel_icons = list()

/obj/item/clothing/under/gs13_dual_tone/Initialize(mapload)
	. = ..()
	gs13_uniform_colors = gs13_uniform_colors.Copy()
	gs13_panel_icons = list()
	if(gs13_protection_template)
		var/list/protection = gs13_native_uniform_protection(gs13_protection_template)
		armor = protection["armor"]
		permeability_coefficient = protection["permeability"]
		resistance_flags = protection["resistance"]
	if(random_sensor)
		sensor_mode = pick(SENSOR_OFF, SENSOR_LIVING, SENSOR_VITALS, SENSOR_COORDS)
	if(!gs13_recolorable)
		verbs -= /obj/item/clothing/under/gs13_dual_tone/verb/customize_colors
	gs13_rebuild_uniform_icons()

/// Match the source GAGS recipe: main mask, stripe mask, then fixed details.
/obj/item/clothing/under/gs13_dual_tone/proc/gs13_compose_uniform_icon(source_icon)
	var/state = gs13_uniform_state
	var/icon/composite
	for(var/channel in 1 to length(gs13_uniform_colors))
		var/icon/mask = icon(source_icon, gs13_uniform_mask_state(state, channel))
		mask.Blend(gs13_uniform_colors[channel], ICON_MULTIPLY)
		if(composite)
			composite.Blend(mask, ICON_OVERLAY)
		else
			composite = mask
	if(icon_exists(source_icon, state))
		composite.Blend(icon(source_icon, state), ICON_OVERLAY)
	var/icon/named = icon()
	named.Insert(composite, state)
	return named

/obj/item/clothing/under/gs13_dual_tone/proc/gs13_rebuild_uniform_icons()
	icon = gs13_compose_uniform_icon(initial(icon))
	worn_icon = gs13_compose_uniform_icon(initial(worn_icon))
	icon_state = gs13_uniform_state
	gs13_panel_icons = list()
	update_slot_icon()

/obj/item/clothing/under/gs13_dual_tone/proc/set_gs13_uniform_color(channel, value)
	if(!gs13_recolorable || !isnum(channel) || !GS13_IS_FINITE(channel) || channel != round(channel) || channel < 1 || channel > length(gs13_uniform_colors) || !istext(value) || length(value) != 7)
		return FALSE
	var/clean = sanitize_hexcolor(value, "invalid")
	if(clean == "invalid")
		return FALSE
	if(gs13_uniform_colors[channel] != clean)
		gs13_uniform_colors[channel] = clean
		gs13_rebuild_uniform_icons()
	return TRUE

/obj/item/clothing/under/gs13_dual_tone/proc/can_customize_gs13_colors(mob/living/user)
	return gs13_recolorable && ishuman(user) && loc == user && !user.incapacitated() && !HAS_TRAIT(user, TRAIT_HANDS_BLOCKED)

/obj/item/clothing/under/gs13_dual_tone/verb/customize_colors()
	set name = "Set uniform colors"
	set category = "Object"
	set src in usr
	var/mob/living/user = usr
	if(!can_customize_gs13_colors(user))
		return
	var/list/channels = list("Main fabric" = 1, "Secondary fabric" = 2)
	if(length(gs13_uniform_colors) >= 3)
		channels["Trim"] = 3
	for(var/index in 4 to length(gs13_uniform_colors))
		channels["Color [index]"] = index
	var/choice = tgui_input_list(user, "Choose a color channel.", "Uniform colors", channels)
	if(!can_customize_gs13_colors(user) || !(choice in channels))
		return
	var/channel = channels[choice]
	var/picked = tgui_input_color(user, "Choose the [lowertext(choice)] color.", "Uniform colors", gs13_uniform_colors[channel])
	if(!can_customize_gs13_colors(user))
		return
	set_gs13_uniform_color(channel, picked)

/obj/item/clothing/under/gs13_dual_tone/examine(mob/user)
	. = ..()
	if(gs13_recolorable)
		. += SPAN_NOTICE("Use Set uniform colors while holding or wearing it to change its separate color channels.")

/obj/item/clothing/under/gs13_dual_tone/serialize()
	var/list/data = ..()
	data["gs13_uniform_colors"] = gs13_uniform_colors.Copy()
	return data

/obj/item/clothing/under/gs13_dual_tone/vars_to_save()
	. = ..()
	// Rebuild runtime icon resources from persistent source masks and colors.
	. -= "icon"

/obj/item/clothing/under/gs13_dual_tone/deserialize(list/data)
	. = ..()
	var/list/saved = data["gs13_uniform_colors"]
	if(islist(saved) && length(saved) == length(gs13_uniform_colors))
		for(var/channel in 1 to length(gs13_uniform_colors))
			set_gs13_uniform_color(channel, saved[channel])
	gs13_rebuild_uniform_icons()

/obj/item/clothing/under/gs13_dual_tone/gs13_clothing_belly_shape(shape)
	// This family deliberately uses soft panels even on Round/stuffed bodies.
	return "soft"

/obj/item/clothing/under/gs13_dual_tone/proc/gs13_uniform_mask_state(state, channel)
	return channel ? "[state]-[channel + gs13_color_mask_offset]" : state

/obj/item/clothing/under/gs13_dual_tone/gs13_add_modular_panels(list/standing, state, draw_layer, tint, skin_tint)
	var/list/channels = list(0)
	if(gs13_skin_masks && skin_tint)
		channels += -1 // Source cutout skin precedes the garment's color masks.
	for(var/index in 1 to length(gs13_uniform_colors))
		channels += index
	for(var/channel in channels)
		var/is_skin = channel == -1
		var/mask_state = is_skin ? "[state]-[gs13_skin_mask_index]" : gs13_uniform_mask_state(state, channel)
		if(!icon_exists(gs13_modular_icon, mask_state))
			continue
		var/panel_icon = gs13_modular_icon
		if(channel)
			var/mask_color = is_skin ? skin_tint : gs13_uniform_colors[channel]
			var/cache_key = is_skin ? "[mask_state]:[mask_color]" : mask_state
			panel_icon = gs13_panel_icons[cache_key]
			if(!panel_icon)
				var/icon/mask = icon(gs13_modular_icon, mask_state)
				mask.Blend(mask_color, ICON_MULTIPLY)
				var/icon/named = icon()
				named.Insert(mask, mask_state)
				panel_icon = named
				gs13_panel_icons[cache_key] = panel_icon
		// Palette colors are baked into the owned icon; native tint/alpha still
		// apply to every layer, including arbitrary color matrices.
		standing += mutable_appearance(panel_icon, mask_state, layer = draw_layer, alpha = alpha, color = color)

// The two channels use native loadout metadata and character persistence.
/datum/gear_tweak/gs13_uniform_color
	fa_icon = "palette"
	var/channel

/datum/gear_tweak/gs13_uniform_color/New()
	switch(channel)
		if(1)
			display_type = "Primary color"
		if(2)
			display_type = "Secondary color"
		if(3)
			display_type = "Trim color"
		else
			display_type = "Color [channel]"
	info = "Choose this uniform color channel."
	return ..()

/datum/gear_tweak/gs13_uniform_color/fabric
	channel = 1

/datum/gear_tweak/gs13_uniform_color/stripes
	channel = 2

/datum/gear_tweak/gs13_uniform_color/trim
	channel = 3

/datum/gear_tweak/gs13_uniform_color/detail_4
	channel = 4

/datum/gear_tweak/gs13_uniform_color/detail_5
	channel = 5

/datum/gear_tweak/gs13_uniform_color/detail_6
	channel = 6

/datum/gear_tweak/gs13_uniform_color/get_default()
	return "#ffffff"

/datum/gear_tweak/gs13_uniform_color/get_metadata(user, metadata)
	return tgui_input_color(user, "Choose the [lowertext(display_type)].", "Uniform colors", metadata || get_default())

/datum/gear_tweak/gs13_uniform_color/tweak_item(obj/item/clothing/under/gs13_dual_tone/uniform, metadata)
	if(istype(uniform))
		uniform.set_gs13_uniform_color(channel, metadata)
