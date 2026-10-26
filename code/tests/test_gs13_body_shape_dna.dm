/datum/game_test/room_test/gs13_shape_dna_clone_and_storage/Run()
	var/mob/living/carbon/human/subject = allocate(/mob/living/carbon/human)
	var/datum/character_save/character = allocate(/datum/character_save)
	character.gs13_preferences = gs13_sanitize_preferences(list("master_wg_pref" = TRUE, "weight_body_sprites" = TRUE, "weight_belly_shape" = "Round", "weight_belly_base" = 3, "weight_hips_max" = 2, "weight_belly_custom_color" = TRUE, "weight_belly_color" = "#3366cc"))
	character.apply_gs13_preferences(subject)
	TEST_ASSERT_EQUAL(subject.dna.gs13_body_shape["weight_belly_base"], 3, "Actual character creation initializes independent body-shape DNA")
	for(var/permission in list("master_wg_pref", "weight_body_sprites", "anatomy_body_sprites", "fluid_production", "weight_gain_chems"))
		TEST_ASSERT_NOT(permission in subject.dna.gs13_body_shape, "Body-shape DNA cannot encode live rendering or chemical permission")
	var/datum/dna/copied = subject.dna.Clone()
	LAZYADD(allocated, copied)
	copied.gs13_body_shape["weight_belly_base"] = 1
	TEST_ASSERT_EQUAL(subject.dna.gs13_body_shape["weight_belly_base"], 3, "Native DNA clones never alias body-shape data")
	var/list/serialized = subject.dna.serialize()
	serialized["gs13_body_shape"] = json_decode(json_encode(serialized["gs13_body_shape"]))
	var/datum/dna/restored = allocate(/datum/dna)
	restored.deserialize(serialized)
	TEST_ASSERT_EQUAL(restored.gs13_body_shape["weight_belly_shape"], "Round", "Native DNA storage retains the source accessory choice")
	TEST_ASSERT_EQUAL(restored.gs13_body_shape["weight_belly_color"], "#3366cc", "The body-shape JSON payload retains its independent color")
	restored.gs13_body_shape["weight_belly_color"] = "#abcdef"
	TEST_ASSERT_EQUAL(serialized["gs13_body_shape"]["weight_belly_color"], "#3366cc", "Restored DNA cannot mutate its saved payload")
	serialized -= "gs13_body_shape"
	restored.deserialize(serialized)
	TEST_ASSERT_NULL(restored.gs13_body_shape, "Legacy DNA retains policy-backed compatibility rather than inventing a new shape")
	var/list/clean = gs13_shape_blueprint(list("weight_belly_base" = 99, "weight_belly_color" = "#ffffff00", "weight_belly_shape" = "invalid", "master_wg_pref" = TRUE))
	TEST_ASSERT_EQUAL(clean["weight_belly_base"], 9, "Untrusted stored shape sizes remain inside the native art range")
	TEST_ASSERT_EQUAL(clean["weight_belly_color"], "#fcccb3", "Stored DNA cannot use transparent or malformed part colors")
	TEST_ASSERT_NOT("master_wg_pref" in clean, "Malformed stored DNA cannot acquire visual permission")

/datum/game_test/room_test/gs13_shape_dna_identity_transfer/Run()
	var/mob/living/carbon/human/donor = allocate(/mob/living/carbon/human)
	var/mob/living/carbon/human/recipient = allocate(/mob/living/carbon/human)
	var/datum/character_save/character = allocate(/datum/character_save)
	character.gs13_preferences = gs13_sanitize_preferences(list("master_wg_pref" = TRUE, "weight_belly_shape" = "Round", "weight_belly_base" = 3, "weight_hips_base" = 1, "weight_hips_max" = 2, "weight_belly_custom_color" = TRUE, "weight_belly_color" = "#3366cc"))
	character.apply_gs13_preferences(donor)
	recipient.gs13_preferences["weight_belly_shape"] = "Classic"
	recipient.gs13_character_slot = 7
	donor.dna.transfer_identity(recipient)
	TEST_ASSERT_EQUAL(recipient.get_gs13_shape_setting("weight_belly_shape"), "Round", "The real native identity transfer carries the DNA's physical shape")
	TEST_ASSERT_EQUAL(recipient.gs13_preferences["weight_belly_shape"], "Classic", "DNA transfer preserves the destination's saved policy")
	TEST_ASSERT_EQUAL(recipient.gs13_character_slot, 7, "DNA transfer cannot change the destination's character-slot association")
	TEST_ASSERT_NOT(recipient.gs13_preferences["master_wg_pref"], "The donor cannot opt another body into weight rendering")
	TEST_ASSERT_NULL(recipient.overlays_standing[GS13_WEIGHT_BODY_LAYER], "Inherited shape alone cannot bypass the destination visual gate")
	recipient.gs13_preferences["master_wg_pref"] = TRUE
	recipient.fatness_real = FATNESS_LEVEL_FATTER
	recipient.calculate_fatness()
	TEST_ASSERT("m_belly_round_5_FRONT" in gs13_weight_panel_states(recipient), "Opted-in native rendering combines inherited base shape with the destination's actual weight")
	TEST_ASSERT_EQUAL(gs13_weight_panel_color(recipient, "m_belly_round_5_FRONT"), "#3366cc", "The inherited independent color reaches actual native appearance")
	TEST_ASSERT_EQUAL(recipient.get_gs13_part_size("hips", gs13_weight_stage(recipient.fatness)), 2, "Inherited hip limits remain independent of the belly")
	recipient.dna.gs13_body_shape["weight_belly_base"] = 0
	TEST_ASSERT_EQUAL(donor.dna.gs13_body_shape["weight_belly_base"], 3, "The transferred body's later mutation cannot rewrite donor DNA")

/datum/game_test/room_test/gs13_shape_dna_live_edits/Run()
	var/mob/living/carbon/human/subject = gs13_fluid_subject()
	var/obj/item/organ/internal/gs13_fluid_organ/breasts/breasts = subject.get_organ_slot(GS13_ORGAN_BREASTS)
	breasts.internal_fluid_datum = /datum/reagent/consumable/starshine/blue
	breasts.lactates = TRUE
	// A native DNA transformation may differ from the saved character policy.
	subject.dna.gs13_body_shape["weight_belly_shape"] = "Round"
	subject.dna.gs13_body_shape["weight_belly_base"] = 4
	subject.dna.gs13_body_shape["weight_belly_color"] = "#112233"
	var/datum/character_save/character = allocate(/datum/character_save)
	character.gs13_preferences = subject.gs13_preferences.Copy()
	character.gs13_preferences["master_wg_pref"] = TRUE
	character.gs13_preferences["weight_gain_rate"] = 1.5
	character.apply_gs13_preferences(subject, FALSE)
	TEST_ASSERT_EQUAL(subject.get_gs13_shape_setting("weight_belly_shape"), "Round", "An unrelated live policy edit cannot reset a transformed accessory")
	TEST_ASSERT_EQUAL(subject.get_gs13_shape_setting("weight_belly_base"), 4, "An unrelated edit preserves the actual DNA's base size")
	character.gs13_preferences["weight_belly_base"] = 2
	character.apply_gs13_preferences(subject, FALSE)
	TEST_ASSERT_EQUAL(subject.get_gs13_shape_setting("weight_belly_base"), 2, "The explicitly edited live trait updates current and birth DNA")
	TEST_ASSERT_EQUAL(subject.get_gs13_shape_setting("weight_belly_shape"), "Round", "Editing a size cannot reset an independently inherited shape")
	character.gs13_preferences["weight_belly_color"] = "#ff2200"
	character.gs13_preferences["weight_belly_custom_color"] = TRUE
	character.apply_gs13_preferences(subject, FALSE)
	TEST_ASSERT_EQUAL(gs13_weight_panel_color(subject, "m_belly_round_2_FRONT"), "#ff2200", "Native live color editing refreshes the actual inherited body layer")
	TEST_ASSERT_EQUAL(subject.get_organ_slot(GS13_ORGAN_BREASTS), breasts, "Live body-shape DNA edits cannot recreate physical anatomy")
	TEST_ASSERT_EQUAL(breasts.fluid_id(), "starshine_blue", "Independent body edits preserve persistent organ chemistry")
	TEST_ASSERT(breasts.lactates, "Independent body edits preserve the actual organ's lactation state")

/datum/game_test/room_test/gs13_shape_dna_body_ownership/Run()
	var/mob/living/carbon/human/original = allocate(/mob/living/carbon/human)
	var/mob/living/carbon/human/other = allocate(/mob/living/carbon/human)
	original.gs13_preferences = gs13_sanitize_preferences(list("master_wg_pref" = TRUE, "weight_belly_shape" = "Round", "weight_belly_base" = 3))
	other.gs13_preferences = gs13_sanitize_preferences(list("master_wg_pref" = TRUE, "weight_belly_shape" = "Classic", "weight_belly_base" = 1))
	original.update_gs13_shape_dna(original.gs13_preferences)
	other.update_gs13_shape_dna(other.gs13_preferences)
	var/datum/mind/mind = allocate(/datum/mind)
	mind.transfer_to(original)
	mind.transfer_to(other)
	TEST_ASSERT_EQUAL(original.get_gs13_shape_setting("weight_belly_shape"), "Round", "Mind transfer leaves the original body's physical shape in place")
	TEST_ASSERT_EQUAL(other.get_gs13_shape_setting("weight_belly_shape"), "Classic", "The moving mind acquires the destination body's actual DNA shape")
	other.death()
	other.revive()
	TEST_ASSERT_EQUAL(other.get_gs13_shape_setting("weight_belly_base"), 1, "Native death/revival retain the same body-shape DNA")
	other.set_species(/datum/species/skrell)
	TEST_ASSERT_NULL(other.overlays_standing[GS13_WEIGHT_BODY_LAYER], "Unsupported species cannot retain human shape layers")
	other.set_species(/datum/species/human)
	TEST_ASSERT_EQUAL(other.get_gs13_shape_setting("weight_belly_shape"), "Classic", "Returning to supported anatomy preserves the actual DNA trait")
