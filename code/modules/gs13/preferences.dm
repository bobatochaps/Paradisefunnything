/// Saved keys match GS13 character preferences; each body receives its own copy.
/proc/gs13_default_preferences()
	return list(
		"master_wg_pref" = FALSE,
		"weight_body_sprites" = TRUE,
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

/proc/gs13_preference_labels()
	return list(
		"master_wg_pref" = "Enable weight gain",
		"weight_body_sprites" = "Show weight body sprites (human body and modular uniforms)",
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
		if(!isnum(value) || !GS13_IS_FINITE(value))
			continue
		switch(pref)
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
	character.gs13_preferences = gs13_preferences.Copy()
	character.gs13_character_slot = slot_number
	character.weight_gain_rate = gs13_preferences["weight_gain_rate"]
	character.weight_loss_rate = gs13_preferences["weight_loss_rate"]
	character.max_weight = gs13_preferences["max_weight"]
	if(initialize_weight)
		character.fatness_real = gs13_preferences["master_wg_pref"] ? gs13_preferences["starting_fatness"] : 0
	character.calculate_fatness()
	character.handle_weight_gain(0)

/datum/character_save/proc/show_gs13_preferences(mob/user)
	gs13_preferences = gs13_sanitize_preferences(gs13_preferences)
	var/list/labels = gs13_preference_labels()
	var/list/html = list("<h2>GS13 weight preferences</h2>", "<p>Enable weight gain and choose its allowed sources. Starting weight applies on your next spawn. Save your character to keep these settings.</p>")
	for(var/pref in labels)
		var/value = gs13_preferences[pref]
		if(!(pref in list("starting_fatness", "weight_gain_rate", "weight_loss_rate", "max_weight")))
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
		if(setting in list("starting_fatness", "weight_gain_rate", "weight_loss_rate", "max_weight"))
			var/maximum = SHORT_REAL_LIMIT
			if(setting == "starting_fatness")
				maximum = FATNESS_LEVEL_BLOB
			else if(setting != "max_weight")
				maximum = 2
			value = tgui_input_number(user, labels[setting], "GS13 preferences", value, maximum, 0, round_value = FALSE)
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
