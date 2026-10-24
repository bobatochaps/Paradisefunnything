/datum/game_test/room_test/gs13_body_shape_preferences/Run()
	var/list/defaults = gs13_default_preferences()
	TEST_ASSERT_EQUAL(defaults["weight_belly_shape"], "Smooth without arms", "Existing characters retain the original native adapter's appearance")
	for(var/style in gs13_belly_styles())
		var/list/saved = gs13_sanitize_preferences(json_encode(list("weight_belly_shape" = style, "glutton_bursting_type" = "Critical")))
		TEST_ASSERT_EQUAL(saved["weight_belly_shape"], style, "Every human source style survives the character JSON preference path")
		TEST_ASSERT_EQUAL(saved["glutton_bursting_type"], "Critical", "The shared choice editor preserves existing outcome preferences")
	for(var/invalid in list("not a style", TRUE, list("Round")))
		var/list/saved = gs13_sanitize_preferences(list("weight_belly_shape" = invalid))
		TEST_ASSERT_EQUAL(saved["weight_belly_shape"], "Smooth without arms", "Malformed style values fall back to the compatible original style")

/datum/game_test/room_test/gs13_body_shape_live_character/Run()
	var/mob/living/carbon/human/subject = allocate(/mob/living/carbon/human)
	subject.adjust_fatness(FATNESS_LEVEL_OBESE, FATTENING_TYPE_ALMIGHTY, TRUE)
	var/datum/character_save/character = new
	character.slot_number = 2
	character.gs13_preferences = gs13_sanitize_preferences(list("master_wg_pref" = TRUE, "weight_belly_shape" = "Round"))
	character.apply_gs13_preferences(subject, FALSE)
	TEST_ASSERT("m_belly_round_4_FRONT" in gs13_weight_panel_states(subject), "Applying a saved character updates the body's current shape")
	TEST_ASSERT_EQUAL(subject.fatness_real, FATNESS_LEVEL_OBESE, "A live shape edit does not reset physical weight")
	var/list/previous_panels = subject.overlays_standing[GS13_WEIGHT_BODY_LAYER]
	character.gs13_preferences["weight_belly_shape"] = "Classic"
	TEST_ASSERT_EQUAL(subject.gs13_preferences["weight_belly_shape"], "Round", "An unapplied character edit cannot mutate the physical body's snapshot")
	character.apply_gs13_preferences(subject, FALSE)
	TEST_ASSERT("m_belly_belly_4_FRONT" in gs13_weight_panel_states(subject), "A live edit replaces a cached shape even within the same weight stage")
	TEST_ASSERT_NOTEQUAL(subject.overlays_standing[GS13_WEIGHT_BODY_LAYER], previous_panels, "Changing shape rebuilds the appropriate appearance cache")
	qdel(character)

/datum/game_test/room_test/gs13_body_shape_stages/Run()
	var/mob/living/carbon/human/subject = allocate(/mob/living/carbon/human)
	subject.gs13_preferences = gs13_default_preferences()
	subject.gs13_preferences["master_wg_pref"] = TRUE
	for(var/style in gs13_belly_styles())
		subject.gs13_preferences["weight_belly_shape"] = style
		var/key = subject.get_gs13_belly_style()
		var/stage = 0
		for(var/threshold in list(FATNESS_LEVEL_FAT, FATNESS_LEVEL_FATTER, FATNESS_LEVEL_VERYFAT, FATNESS_LEVEL_OBESE, FATNESS_LEVEL_MORBIDLY_OBESE, FATNESS_LEVEL_EXTREMELY_OBESE, FATNESS_LEVEL_BARELYMOBILE, FATNESS_LEVEL_IMMOBILE, FATNESS_LEVEL_BLOB))
			stage++
			subject.fatness_real = threshold
			subject.calculate_fatness()
			TEST_ASSERT("m_belly_[key]_[stage]_FRONT" in gs13_weight_panel_states(subject), "Every human shape selects its own original sprite at all nine native weight stages")
			for(var/mutable_appearance/panel as anything in subject.overlays_standing[GS13_WEIGHT_BODY_LAYER])
				TEST_ASSERT(icon_exists(panel.icon, panel.icon_state), "Every selected shape/stage has real source artwork")
			if(stage == 1 || stage == 4 || stage == 9)
				gs13_render_weight_preview(subject, "belly_shape_[key]_[stage]")

/datum/game_test/room_test/gs13_body_shape_limb_safety/Run()
	var/mob/living/carbon/human/subject = allocate(/mob/living/carbon/human)
	subject.gs13_preferences = gs13_default_preferences()
	subject.gs13_preferences["master_wg_pref"] = TRUE
	subject.gs13_preferences["weight_belly_shape"] = "Round"
	subject.adjust_fatness(FATNESS_LEVEL_OBESE, FATTENING_TYPE_ALMIGHTY, TRUE)
	var/obj/item/organ/external/hand = subject.get_organ(BODY_ZONE_PRECISE_R_HAND)
	hand.status |= ORGAN_ROBOT
	subject.update_gs13_weight_appearance()
	TEST_ASSERT("m_belly_smoothnoarms_4_FRONT" in gs13_weight_panel_states(subject), "Source arms cannot paint flesh over a native prosthetic hand")
	TEST_ASSERT_EQUAL(subject.gs13_preferences["weight_belly_shape"], "Round", "Anatomy fallback preserves the selected character style")
	hand.status &= ~ORGAN_ROBOT
	subject.update_gs13_weight_appearance()
	TEST_ASSERT("m_belly_round_4_FRONT" in gs13_weight_panel_states(subject), "Restoring organic anatomy restores the selected style without a stale cache")
	hand.droplimb(clean = TRUE, nodamage = TRUE)
	subject.update_gs13_weight_appearance()
	TEST_ASSERT("m_belly_smoothnoarms_4_FRONT" in gs13_weight_panel_states(subject), "An amputation also selects the source sheet without arms")

/datum/game_test/room_test/gs13_body_shape_clothing_and_cleanup/Run()
	var/mob/living/carbon/human/subject = allocate(/mob/living/carbon/human)
	subject.gs13_preferences = gs13_default_preferences()
	subject.gs13_preferences["master_wg_pref"] = TRUE
	subject.gs13_preferences["weight_belly_shape"] = "Classic"
	subject.adjust_fatness(FATNESS_LEVEL_OBESE, FATTENING_TYPE_ALMIGHTY, TRUE)
	var/obj/item/clothing/under/color/grey/uniform = allocate(/obj/item/clothing/under/color/grey)
	subject.equip_to_slot_if_possible(uniform, ITEM_SLOT_JUMPSUIT)
	var/list/states = gs13_weight_panel_states(subject)
	TEST_ASSERT_NOT("m_belly_belly_4_FRONT" in states, "Native torso clothing still covers the selected skin shape")
	TEST_ASSERT("belly_soft_4" in states, "A modular uniform retains its compatible expansion panels")
	gs13_render_weight_preview(subject, "belly_shape_clothed")
	subject.drop_item_to_ground(uniform)
	TEST_ASSERT("m_belly_belly_4_FRONT" in gs13_weight_panel_states(subject), "Unequipping reveals the currently selected shape")
	subject.gs13_preferences["weight_body_sprites"] = FALSE
	subject.calculate_fatness()
	TEST_ASSERT_NULL(subject.overlays_standing[GS13_WEIGHT_BODY_LAYER], "Appearance opt-out clears every selected shape")
	subject.gs13_preferences["weight_body_sprites"] = TRUE
	subject.calculate_fatness()
	subject.set_species(/datum/species/unathi)
	TEST_ASSERT_NULL(subject.overlays_standing[GS13_WEIGHT_BODY_LAYER], "Unsupported species do not retain human body shapes")

/datum/game_test/room_test/gs13_body_shape_physical_ownership/Run()
	var/mob/living/carbon/human/original = allocate(/mob/living/carbon/human)
	var/mob/living/carbon/human/recipient = allocate(/mob/living/carbon/human)
	original.gs13_preferences = gs13_default_preferences()
	recipient.gs13_preferences = gs13_default_preferences()
	original.gs13_preferences["master_wg_pref"] = TRUE
	recipient.gs13_preferences["master_wg_pref"] = TRUE
	original.gs13_preferences["weight_belly_shape"] = "Round"
	recipient.gs13_preferences["weight_belly_shape"] = "Smooth"
	original.adjust_fatness(FATNESS_LEVEL_OBESE, FATTENING_TYPE_ALMIGHTY, TRUE)
	recipient.adjust_fatness(FATNESS_LEVEL_OBESE, FATTENING_TYPE_ALMIGHTY, TRUE)
	var/datum/mind/mind = new
	mind.transfer_to(original)
	mind.transfer_to(recipient)
	TEST_ASSERT("m_belly_round_4_FRONT" in gs13_weight_panel_states(original), "The old body retains its own anatomy preference after a mind transfer")
	TEST_ASSERT("m_belly_smooth_4_FRONT" in gs13_weight_panel_states(recipient), "The recipient retains its independent physical appearance")
	original.death()
	original.update_revive()
	original.update_gs13_weight_appearance()
	TEST_ASSERT("m_belly_round_4_FRONT" in gs13_weight_panel_states(original), "Revival preserves the current body's selected style")
	qdel(mind)
