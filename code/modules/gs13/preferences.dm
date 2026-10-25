/// Saved keys match GS13 character preferences; each body receives its own copy.
/proc/gs13_default_preferences()
	. = list(
		"master_wg_pref" = FALSE,
		"weight_body_sprites" = TRUE,
		"weight_belly_shape" = "Smooth without arms",
		"blueberry_inflation" = FALSE,
		"body_size" = RESIZE_DEFAULT_SIZE,
		"weight_size_scaling" = FALSE,
		"size_xwg" = FALSE,
		"starting_fatness" = 0,
		"weight_gain_rate" = 0.5,
		"weight_loss_rate" = 0.5,
		"max_weight" = 0,
		"weight_gain_permanent" = FALSE,
		"severe_fatness_penalty" = FALSE,
		"weight_gain_food" = FALSE,
		"weight_gain_chems" = FALSE,
		"weight_gain_items" = FALSE,
		"weight_gain_weapons" = FALSE,
		"weight_gain_magic" = FALSE,
		"weight_gain_viruses" = FALSE,
		"weight_gain_nanites" = FALSE,
		"weight_gain_atmos" = FALSE,
		"weight_gain_mobs" = FALSE,
		"weight_gain_mutations" = FALSE,
		"muscle_gain" = FALSE,
	)
	for(var/key in gs13_helplessness_labels())
		.[key] = 0
	. += gs13_burst_default_preferences()
	. += gs13_anatomy_default_preferences()
	. += gs13_shape_default_preferences()
	. += gs13_shape_color_preferences()
	.["weight_belly_custom_color"] = FALSE
	.["weight_hips_custom_color"] = FALSE

/proc/gs13_preference_labels()
	. = list(
		"master_wg_pref" = "Enable weight gain",
		"weight_body_sprites" = "Show weight body sprites (human body and modular uniforms)",
		"weight_belly_shape" = "Human belly shape",
		"blueberry_inflation" = "Allow blueberry transformations (independent of ordinary weight gain)",
		"body_size" = "Starting body size (0.8 to 2; 1 = normal)",
		"weight_size_scaling" = "Grow in size above the blob weight stage",
		"size_xwg" = "Allow growth up to six times normal size in supported areas",
		"starting_fatness" = "Starting body fat index",
		"weight_gain_rate" = "Weight gain multiplier",
		"weight_loss_rate" = "Weight loss multiplier",
		"max_weight" = "Maximum body fat index (0 = unlimited)",
		"weight_gain_permanent" = "Allow permanent weight gain",
		"severe_fatness_penalty" = "Allow severe weight effects (including calorite poisoning)",
		"weight_gain_food" = "Food",
		"weight_gain_chems" = "Chemicals",
		"weight_gain_items" = "Items",
		"weight_gain_weapons" = "Weapons",
		"weight_gain_magic" = "Magic",
		"weight_gain_viruses" = "Viruses",
		"weight_gain_nanites" = "Nanites",
		"weight_gain_atmos" = "Atmospherics",
		"weight_gain_mobs" = "Mobs",
		"weight_gain_mutations" = "Mutations",
		"muscle_gain" = "Allow muscle gain",
	)
	. += gs13_helplessness_labels()
	. += gs13_burst_preference_labels()
	. += gs13_anatomy_preference_labels()
	. += gs13_shape_preference_labels()

/proc/gs13_preference_choices(setting)
	switch(setting)
		if("glutton_bursting_type")
			return gs13_burst_modes()
		if("weight_belly_shape")
			return gs13_belly_styles()
		if("breasts_type")
			return list("Pair", "Quadruple", "Sextuple")
		if("breast_produce")
			return gs13_breast_products()

/proc/gs13_sanitize_preferences(saved)
	if(istext(saved))
		try
			saved = json_decode(saved)
		catch
			saved = null
	var/list/result = gs13_default_preferences()
	if(!islist(saved))
		return result
	for(var/pref in result)
		var/value = saved[pref]
		var/list/choices = gs13_preference_choices(pref)
		if(choices)
			if(value in choices)
				result[pref] = value
			continue
		if(pref in gs13_shape_color_preferences())
			if(istext(value) && length(value) == 7)
				result[pref] = sanitize_hexcolor(value, result[pref])
			continue
		if(!isnum(value) || !GS13_IS_FINITE(value))
			continue
		if(pref in gs13_shape_default_preferences())
			result[pref] = clamp(round(value), 0, 9)
			continue
		if(pref in gs13_anatomy_numeric_preferences())
			result[pref] = clamp(value, pref == "max_breast_size" ? 0 : 0.5, 80)
			continue
		if(pref in gs13_burst_numeric_preferences())
			result[pref] = clamp(value, 0, SHORT_REAL_LIMIT)
			if(pref == "blueberry_lives")
				result[pref] = round(result[pref])
			continue
		if(pref in gs13_helplessness_labels())
			result[pref] = clamp(value, 0, pref == "stuckage_custom" ? 100 : SHORT_REAL_LIMIT)
			continue
		switch(pref)
			if("body_size")
				result[pref] = gs13_sanitize_body_size(value)
			if("starting_fatness")
				result[pref] = clamp(value, 0, FATNESS_LEVEL_BLOB)
			if("weight_gain_rate", "weight_loss_rate")
				result[pref] = clamp(value, 0, 2)
			if("max_weight")
				result[pref] = clamp(value, 0, SHORT_REAL_LIMIT)
			else
				result[pref] = (value == TRUE)
	return result

/datum/character_save/proc/apply_gs13_preferences(mob/living/carbon/character, initialize_weight = TRUE)
	gs13_preferences = gs13_sanitize_preferences(gs13_preferences)
	character.set_gs13_preference_snapshot(gs13_preferences, slot_number)
	if(ishuman(character))
		var/mob/living/carbon/human/human_character = character
		if(initialize_weight)
			human_character.set_gs13_body_size(gs13_preferences["body_size"])
			human_character.initialize_gs13_anatomy(gs13_preferences)
		else
			human_character.update_gs13_anatomy_limits(gs13_preferences)
	if(initialize_weight)
		character.fatness_real = gs13_preferences["master_wg_pref"] ? gs13_preferences["starting_fatness"] : 0
	character.sync_gs13_transformations()
	character.calculate_fatness()
	character.handle_weight_gain(0)
	character.refresh_gs13_bursting()

/// Apply body-owned policy without changing physical weight, size, DNA, or organs.
/mob/living/carbon/proc/set_gs13_preference_snapshot(saved, character_slot = 0)
	gs13_preferences = gs13_sanitize_preferences(saved)
	gs13_character_slot = isnum(character_slot) && GS13_IS_FINITE(character_slot) ? max(0, round(character_slot)) : 0
	weight_gain_rate = gs13_preferences["weight_gain_rate"]
	weight_loss_rate = gs13_preferences["weight_loss_rate"]
	max_weight = gs13_preferences["max_weight"]

/datum/character_save/proc/show_gs13_preferences(mob/user)
	gs13_preferences = gs13_sanitize_preferences(gs13_preferences)
	var/list/labels = gs13_preference_labels()
	var/list/html = list("<h2>GS13 weight preferences</h2>", "<p>Enable weight gain and choose its allowed sources. Starting weight and body size apply on your next spawn. Body size also works with weight gain disabled. Save your character to keep these settings.</p><p>Helplessness thresholds use apparent fat minus muscle. Zero disables an effect. Related quirks and server settings can override thresholds. Hydraulic MOD assistance suspends threshold effects. Chair breakage and doorway squeezing use apparent fat, independently of muscle and hydraulic assistance.</p>")
	for(var/pref in labels)
		var/value = gs13_preferences[pref]
		if(!gs13_numeric_preference(pref) && !gs13_preference_choices(pref) && !(pref in gs13_shape_color_preferences()))
			value = value ? "Enabled" : "Disabled"
		html += "[labels[pref]]: <a href='byond://?_src_=prefs;preference=gs13;setting=[pref]'>[value]</a><br>"
	var/datum/browser/popup = new(user, "gs13_preferences", "GS13 preferences", 520, 640)
	popup.set_content(html.Join())
	popup.open()

/datum/preferences/proc/process_gs13_preferences(mob/user, setting)
	var/datum/character_save/character = active_character
	character.gs13_preferences = gs13_sanitize_preferences(character.gs13_preferences)
	var/list/labels = gs13_preference_labels()
	if(setting in labels)
		var/value = character.gs13_preferences[setting]
		var/list/choices = gs13_preference_choices(setting)
		if(choices)
			value = tgui_input_list(user, labels[setting], "GS13 preferences", choices, value)
			if(isnull(value) || character != active_character)
				return
		else if(setting in gs13_shape_color_preferences())
			value = tgui_input_color(user, labels[setting], "GS13 preferences", value)
			if(isnull(value) || character != active_character)
				return
		else if(gs13_numeric_preference(setting))
			var/minimum = 0
			var/maximum = SHORT_REAL_LIMIT
			if(setting == "body_size")
				minimum = GS13_BODY_SIZE_MIN
				maximum = GS13_BODY_SIZE_MAX
			else if(setting in gs13_shape_default_preferences())
				maximum = 9
			else if(setting in gs13_anatomy_numeric_preferences())
				minimum = setting == "max_breast_size" ? 0 : 0.5
				maximum = 80
			else if(setting == "starting_fatness")
				maximum = FATNESS_LEVEL_BLOB
			else if(setting in list("weight_gain_rate", "weight_loss_rate"))
				maximum = 2
			else if(setting == "stuckage_custom")
				maximum = 100
			value = tgui_input_number(user, labels[setting], "GS13 preferences", value, maximum, minimum, round_value = FALSE)
			if(isnull(value) || character != active_character)
				return
		else
			value = !value
		character.gs13_preferences[setting] = value
		character.gs13_preferences = gs13_sanitize_preferences(character.gs13_preferences)
		if(iscarbon(user))
			var/mob/living/carbon/player = user
			if(player.gs13_character_slot == character.slot_number)
				character.apply_gs13_preferences(player, FALSE)
	character.show_gs13_preferences(user)
