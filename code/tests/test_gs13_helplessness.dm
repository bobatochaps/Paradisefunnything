/datum/game_test/room_test/gs13_helplessness_preferences/Run()
	var/list/loaded = gs13_sanitize_preferences(json_encode(list("no_movement" = 500, "clumsy" = -5, "mute" = "invalid", "lisp" = 250.5)))
	TEST_ASSERT_EQUAL(loaded["no_movement"], 500, "Thresholds remain numeric after JSON roundtrip")
	TEST_ASSERT_EQUAL(loaded["clumsy"], 0, "Negative thresholds are disabled")
	TEST_ASSERT_EQUAL(loaded["mute"], 0, "Invalid thresholds fall back to disabled")
	TEST_ASSERT_EQUAL(loaded["lisp"], 250.5, "Thresholds preserve fractional BFI")
	var/datum/character_save/character = allocate(/datum/character_save)
	var/mob/living/carbon/human/subject = allocate(/mob/living/carbon/human)
	subject.adjust_fatness(600, FATTENING_TYPE_ALMIGHTY, TRUE)
	TEST_ASSERT_NOT(HAS_TRAIT(subject, TRAIT_IMMOBILIZED), "Older saves default to no helplessness")
	character.gs13_preferences = loaded
	character.apply_gs13_preferences(subject, FALSE)
	TEST_ASSERT(HAS_TRAIT_FROM(subject, TRAIT_IMMOBILIZED, HELPLESSNESS_TRAIT), "Live character edits activate the threshold even with weight gain off")
	TEST_ASSERT_EQUAL(subject.fatness_real, 600, "Live threshold edits preserve body weight")
	character.gs13_preferences["no_movement"] = 0
	character.apply_gs13_preferences(subject, FALSE)
	TEST_ASSERT_NOT(HAS_TRAIT(subject, TRAIT_IMMOBILIZED), "Zero disables a live threshold immediately")
	TEST_ASSERT(gs13_numeric_preference("no_movement"), "The preference editor must use numeric input")
	TEST_ASSERT_NOT(gs13_numeric_preference("master_wg_pref"), "Ordinary preferences remain toggles")

/datum/game_test/room_test/gs13_helplessness_effective_weight/Run()
	var/mob/living/carbon/human/subject = allocate(/mob/living/carbon/human)
	subject.gs13_preferences["no_movement"] = 500
	subject.gs13_preferences["muscle_gain"] = TRUE
	subject.adjust_fatness(300, FATTENING_TYPE_ALMIGHTY, TRUE)
	subject.adjust_perma(200, FATTENING_TYPE_ALMIGHTY, TRUE)
	TEST_ASSERT_NOT(subject.mobility_flags & MOBILITY_MOVE, "The exact effective-weight boundary blocks native movement")
	subject.adjust_muscle(1, TRUE)
	TEST_ASSERT(subject.mobility_flags & MOBILITY_MOVE, "Muscle relief removes helplessness immediately")
	subject.adjust_muscle(-1, TRUE)
	TEST_ASSERT_NOT(subject.mobility_flags & MOBILITY_MOVE, "Removing muscle reapplies the threshold")
	var/obj/item/bluespace_belt/belt = allocate(/obj/item/bluespace_belt)
	belt.forceMove(subject)
	belt.equipped(subject, ITEM_SLOT_BELT)
	TEST_ASSERT(subject.mobility_flags & MOBILITY_MOVE, "Concealed fat does not count toward helplessness")
	qdel(belt)
	TEST_ASSERT_NOT(subject.mobility_flags & MOBILITY_MOVE, "Revealing weight reapplies helplessness")
	subject.set_gs13_body_size(2)
	TEST_ASSERT_NOT(subject.mobility_flags & MOBILITY_MOVE, "Physical scale does not change the BFI threshold")
	subject.fully_heal_fatness(TRUE, null, null)
	TEST_ASSERT(subject.mobility_flags & MOBILITY_MOVE, "Weight recovery restores native mobility")

/datum/game_test/room_test/gs13_helplessness_native_actions/Run()
	var/mob/living/carbon/human/subject = allocate(/mob/living/carbon/human)
	var/obj/item/toy/crayon/red/held = allocate(/obj/item/toy/crayon/red)
	subject.put_in_active_hand(held)
	subject.gs13_preferences["immobile_arms"] = 100
	subject.gs13_preferences["clumsy"] = 100
	subject.adjust_fatness(100, FATTENING_TYPE_ALMIGHTY, TRUE)
	TEST_ASSERT_NOT(subject.mobility_flags & MOBILITY_USE, "Native hand use is blocked")
	TEST_ASSERT_NOT(subject.mobility_flags & MOBILITY_PICKUP, "Native pickup is blocked")
	TEST_ASSERT_EQUAL(held.loc, subject.loc, "The normal hands-blocked handler drops held items")
	TEST_ASSERT_NOT(subject.put_in_active_hand(held), "Blocked hands cannot pick the item back up")
	var/obj/item/gun/energy/gun/weapon = allocate(/obj/item/gun/energy/gun)
	TEST_ASSERT_NOT(subject.can_use_guns(weapon), "Clumsy fingers use the native trigger guard check")
	ADD_TRAIT(subject, TRAIT_HANDS_BLOCKED, "independent")
	subject.fully_heal_fatness(FALSE, null, null)
	TEST_ASSERT(HAS_TRAIT_FROM(subject, TRAIT_HANDS_BLOCKED, "independent"), "Recovery preserves independently blocked hands")
	TEST_ASSERT_NOT(HAS_TRAIT_FROM(subject, TRAIT_HANDS_BLOCKED, HELPLESSNESS_TRAIT), "Recovery removes only its own restriction")
	REMOVE_TRAIT(subject, TRAIT_HANDS_BLOCKED, "independent")
	TEST_ASSERT(subject.mobility_flags & MOBILITY_USE, "Normal hand use returns after the final blocker is removed")
	TEST_ASSERT(subject.can_use_guns(weapon), "Trigger use recovers after weight loss")

/datum/game_test/room_test/gs13_helplessness_speech_and_face/Run()
	var/mob/living/carbon/human/subject = allocate(/mob/living/carbon/human)
	subject.gs13_preferences["lisp"] = 100
	subject.gs13_preferences["hidden_face"] = 100
	subject.adjust_fatness(100, FATTENING_TYPE_ALMIGHTY, TRUE)
	var/datum/multilingual_say_piece/spoken = new(null, "six socks")
	var/datum/multilingual_say_piece/noise = new(GLOB.all_languages["Noise"], "six socks")
	subject.handle_speech_problems(list(spoken, noise), "says")
	TEST_ASSERT_EQUAL(spoken.message, "thith thockth", "Native speech applies the source lisp substitutions")
	TEST_ASSERT_EQUAL(noise.message, "six socks", "Nonspoken/no-stutter language is preserved")
	qdel(spoken)
	qdel(noise)
	TEST_ASSERT_EQUAL(subject.get_face_name(), "Unknown", "Native face recognition respects the temporary effect")
	var/obj/item/organ/external/head/head = subject.get_organ("head")
	TEST_ASSERT_NOT(head.status & ORGAN_DISFIGURED, "Concealing a face does not injure the organ")
	subject.gs13_preferences["mute"] = 100
	subject.handle_gs13_helplessness()
	TEST_ASSERT_NOT(subject.IsVocal(), "Muteness uses the native vocal check")
	ADD_TRAIT(subject, TRAIT_MUTE, "independent")
	head.status |= ORGAN_DISFIGURED
	subject.fully_heal_fatness(FALSE, null, null)
	TEST_ASSERT_NOT(HAS_TRAIT(subject, TRAIT_GS13_LISP), "The lisp clears after weight loss")
	TEST_ASSERT_NOT(HAS_TRAIT(subject, TRAIT_GS13_HIDDEN_FACE), "The face effect clears after weight loss")
	TEST_ASSERT_EQUAL(subject.get_face_name(), "Unknown", "Recovery cannot heal unrelated facial injuries")
	TEST_ASSERT(HAS_TRAIT_FROM(subject, TRAIT_MUTE, "independent"), "Recovery preserves independent muteness")
	head.status &= ~ORGAN_DISFIGURED
	REMOVE_TRAIT(subject, TRAIT_MUTE, "independent")
	TEST_ASSERT_EQUAL(subject.get_face_name(), subject.real_name, "An uninjured face is recognized again")

/datum/game_test/room_test/gs13_helplessness_nearsight/Run()
	var/mob/living/carbon/human/subject = allocate(/mob/living/carbon/human)
	subject.gs13_preferences["nearsighted"] = 100
	subject.adjust_fatness(100, FATTENING_TYPE_ALMIGHTY, TRUE)
	TEST_ASSERT_NOTNULL(subject.screens["nearsighted"], "The native vision overlay activates immediately")
	var/obj/item/clothing/glasses/regular/glasses = allocate(/obj/item/clothing/glasses/regular)
	TEST_ASSERT(subject.equip_to_slot_if_possible(glasses, ITEM_SLOT_EYES), "The fixture equips prescription glasses normally")
	TEST_ASSERT_NULL(subject.screens["nearsighted"], "Prescription glasses correct weight-driven nearsightedness")
	subject.drop_item_to_ground(glasses)
	TEST_ASSERT_NOTNULL(subject.screens["nearsighted"], "Removing glasses restores the impairment")
	ADD_TRAIT(subject, TRAIT_NEARSIGHT, "independent")
	subject.fully_heal_fatness(FALSE, null, null)
	TEST_ASSERT_NOTNULL(subject.screens["nearsighted"], "Weight recovery cannot remove an independent vision impairment")
	TEST_ASSERT_NOT(HAS_TRAIT_FROM(subject, TRAIT_NEARSIGHT, HELPLESSNESS_TRAIT), "The weight source has been removed")

/datum/game_test/room_test/gs13_helplessness_quirks/Run()
	var/mob/living/carbon/human/subject = allocate(/mob/living/carbon/human)
	subject.adjust_fatness(FATNESS_LEVEL_BARELYMOBILE, FATTENING_TYPE_ALMIGHTY, TRUE)
	var/datum/quirk/gs13_helplessness_immobile/quirk = new
	quirk.apply_quirk_effects(subject)
	TEST_ASSERT_NOT(HAS_TRAIT(subject, TRAIT_IMMOBILIZED), "The quirk uses the source's normal immobility threshold")
	ADD_TRAIT(subject, TRAIT_WEAKLEGS, "independent")
	TEST_ASSERT(HAS_TRAIT_FROM(subject, TRAIT_IMMOBILIZED, HELPLESSNESS_TRAIT), "Weak Legs lowers the quirk threshold immediately")
	REMOVE_TRAIT(subject, TRAIT_WEAKLEGS, "independent")
	TEST_ASSERT_NOT(HAS_TRAIT(subject, TRAIT_IMMOBILIZED), "Removing Weak Legs restores the higher quirk threshold immediately")
	ADD_TRAIT(subject, TRAIT_WEAKLEGS, "independent")
	qdel(quirk)
	TEST_ASSERT_NOT(HAS_TRAIT(subject, TRAIT_IMMOBILIZED), "Removing the quirk restores the disabled preference")
	TEST_ASSERT(HAS_TRAIT(subject, TRAIT_WEAKLEGS), "Quirk removal preserves unrelated leg traits")
	var/datum/quirk/gs13_helplessness_clumsy/clumsy = new
	clumsy.apply_quirk_effects(subject)
	TEST_ASSERT(HAS_TRAIT_FROM(subject, TRAIT_CHUNKYFINGERS, HELPLESSNESS_TRAIT), "The clumsy quirk applies at its source threshold")
	qdel(clumsy)
	TEST_ASSERT_NOT(HAS_TRAIT(subject, TRAIT_CHUNKYFINGERS), "Quirk removal cleans up its effect immediately")

/datum/game_test/room_test/gs13_helplessness_lifecycle/Run()
	var/mob/living/carbon/human/subject = allocate(/mob/living/carbon/human)
	subject.gs13_preferences["no_movement"] = 100
	subject.gs13_preferences["mute"] = 100
	subject.adjust_fatness(100, FATTENING_TYPE_ALMIGHTY, TRUE)
	ADD_TRAIT(subject, TRAIT_NO_HELPLESSNESS, "first")
	ADD_TRAIT(subject, TRAIT_NO_HELPLESSNESS, "second")
	TEST_ASSERT_NOT(HAS_TRAIT_FROM(subject, TRAIT_IMMOBILIZED, HELPLESSNESS_TRAIT), "Immunity clears an existing effect")
	REMOVE_TRAIT(subject, TRAIT_NO_HELPLESSNESS, "first")
	TEST_ASSERT_NOT(HAS_TRAIT(subject, TRAIT_MUTE), "One remaining immunity source still protects the body")
	REMOVE_TRAIT(subject, TRAIT_NO_HELPLESSNESS, "second")
	TEST_ASSERT(HAS_TRAIT(subject, TRAIT_MUTE), "Removing the last immunity source reevaluates thresholds")
	ADD_TRAIT(subject, TRAIT_NO_HELPLESSNESS, "bulk")
	REMOVE_TRAITS_IN(subject, "bulk")
	TEST_ASSERT(HAS_TRAIT(subject, TRAIT_MUTE), "Bulk source removal without a trait argument also reevaluates thresholds")
	subject.death()
	TEST_ASSERT_NOT(HAS_TRAIT_FROM(subject, TRAIT_MUTE, HELPLESSNESS_TRAIT), "Death clears helplessness effects")
	subject.update_revive()
	TEST_ASSERT(HAS_TRAIT_FROM(subject, TRAIT_MUTE, HELPLESSNESS_TRAIT), "Revival reapplies the body's thresholds")
	var/datum/component/gs13_helplessness/controller = subject.GetComponent(/datum/component/gs13_helplessness)
	qdel(controller)
	TEST_ASSERT_NOT(HAS_TRAIT_FROM(subject, TRAIT_MUTE, HELPLESSNESS_TRAIT), "Component deletion removes owned effects")
	subject.handle_gs13_helplessness()
	controller = subject.GetComponent(/datum/component/gs13_helplessness)
	qdel(subject)
	TEST_ASSERT(QDELETED(controller), "Body deletion also deletes its controller")

/datum/game_test/room_test/gs13_helplessness_server_thresholds
	var/list/old_forced
	var/turf/allowed_turf
	var/area/original_area
	var/area/allowed_area

/datum/game_test/room_test/gs13_helplessness_server_thresholds/Destroy()
	if(old_forced)
		GLOB.configuration.gs13.forced_helplessness = old_forced
	if(allowed_turf && original_area)
		original_area.contents += allowed_turf
		allowed_turf.change_area(allowed_area, original_area)
	QDEL_NULL(allowed_area)
	return ..()

/datum/game_test/room_test/gs13_helplessness_server_thresholds/Run()
	old_forced = GLOB.configuration.gs13.forced_helplessness
	GLOB.configuration.gs13.forced_helplessness = list()
	GLOB.configuration.gs13.load_data(list("forced_helplessness" = list("mute" = 200, "clumsy" = -5, "lisp" = INFINITY, "unknown" = 1)))
	TEST_ASSERT_EQUAL(GLOB.configuration.gs13.forced_helplessness["clumsy"], 0, "Server thresholds reject negatives")
	TEST_ASSERT_NULL(GLOB.configuration.gs13.forced_helplessness["lisp"], "Nonfinite server thresholds are ignored")
	TEST_ASSERT_NULL(GLOB.configuration.gs13.forced_helplessness["unknown"], "Unknown config keys are ignored")
	var/list/turfs = get_available_turfs()
	allowed_turf = turfs[1]
	var/turf/outside = turfs[2]
	original_area = get_area(allowed_turf)
	allowed_area = new /area/station/public/dorms
	allowed_area.contents += allowed_turf
	allowed_turf.change_area(original_area, allowed_area)
	var/mob/living/carbon/human/subject = allocate(/mob/living/carbon/human, outside)
	subject.adjust_fatness(200, FATTENING_TYPE_ALMIGHTY, TRUE)
	TEST_ASSERT(HAS_TRAIT(subject, TRAIT_MUTE), "Forcing applies outside the allowed areas even with a disabled character threshold")
	subject.forceMove(allowed_turf)
	TEST_ASSERT_NOT(HAS_TRAIT(subject, TRAIT_MUTE), "Actual movement into a safe area removes forced helplessness")
	subject.gs13_preferences["mute"] = 200
	subject.handle_gs13_helplessness()
	TEST_ASSERT(HAS_TRAIT(subject, TRAIT_MUTE), "Safe areas do not override a voluntarily enabled threshold")
	subject.gs13_preferences["mute"] = 0
	subject.forceMove(outside)
	ADD_TRAIT(subject, TRAIT_NO_HELPLESSNESS, "independent")
	TEST_ASSERT_NOT(HAS_TRAIT(subject, TRAIT_MUTE), "Immunity overrides server forcing")
