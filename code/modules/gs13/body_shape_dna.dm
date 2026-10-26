// Source belly/hip size, accessory and color traits belong to creation DNA.
// Rendering permission and allowed weight sources remain with the body policy.
/proc/gs13_shape_blueprint(saved)
	if(!islist(saved))
		return null
	var/list/clean = gs13_sanitize_preferences(saved)
	var/list/shape = gs13_shape_default_preferences()
	shape += gs13_shape_color_preferences()
	shape["weight_belly_shape"] = clean["weight_belly_shape"]
	shape["weight_belly_custom_color"] = clean["weight_belly_custom_color"]
	shape["weight_hips_custom_color"] = clean["weight_hips_custom_color"]
	for(var/key in shape)
		shape[key] = clean[key]
	return shape

/mob/living/carbon/human/proc/get_gs13_shape_setting(setting)
	if(islist(dna?.gs13_body_shape) && (setting in dna.gs13_body_shape))
		return dna.gs13_body_shape[setting]
	// Older DNA keeps the compatible policy-backed appearance until a native
	// character edit initializes its independent trait snapshot.
	return gs13_preferences[setting]

/// Initial creation supplies the complete blueprint. A live edit updates only
/// changed traits, preserving DNA transformations when unrelated policy changes.
/mob/living/carbon/human/proc/update_gs13_shape_dna(list/settings, list/previous_policy)
	if(!dna)
		return
	var/list/shape = gs13_shape_blueprint(settings)
	if(!shape)
		return
	if(!length(dna.gs13_body_shape) || !islist(previous_policy))
		dna.gs13_body_shape = shape
		return
	for(var/key in shape)
		if(shape[key] != previous_policy[key])
			dna.gs13_body_shape[key] = shape[key]
	// Enabling override explicitly selects the color shown in that character's
	// editor, even if a DNA transformation supplied a different stored color.
	for(var/part in list("belly", "hips"))
		var/flag = "weight_[part]_custom_color"
		if(shape[flag] && shape[flag] != previous_policy[flag])
			dna.gs13_body_shape["weight_[part]_color"] = shape["weight_[part]_color"]
