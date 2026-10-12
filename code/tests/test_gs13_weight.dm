// These tests need the native room fixture; test_tiny has no station event area.
/datum/game_test/room_test/gs13_weight_preferences/Run()
	var/mob/living/carbon/human/subject = allocate(/mob/living/carbon/human)
	TEST_ASSERT_EQUAL(subject.adjust_fatness(100), 0, "Weight gain defaults to disabled")
	subject.gs13_preferences = gs13_default_preferences()
	subject.gs13_preferences["master_wg_pref"] = TRUE
	TEST_ASSERT_EQUAL(subject.adjust_fatness(100), 0, "Master switch must not bypass source preferences")
	subject.gs13_preferences["weight_gain_items"] = TRUE
	TEST_ASSERT_EQUAL(subject.adjust_fatness(100), 50, "Default gain multiplier must apply")
	TEST_ASSERT_EQUAL(subject.adjust_fatness(100, FATTENING_TYPE_CHEM), 0, "Source switches must be independent")
	TEST_ASSERT_EQUAL(subject.adjust_perma(100), 0, "Permanent gain requires its own preference")
	subject.gs13_preferences["weight_gain_permanent"] = TRUE
	TEST_ASSERT_EQUAL(subject.adjust_perma(100), 50, "Permanent gain uses the gain multiplier")
	subject.gs13_preferences["master_wg_pref"] = FALSE
	TEST_ASSERT_EQUAL(subject.adjust_fatness(-100, FATTENING_TYPE_WEIGHT_LOSS), 0, "Master switch gates ordinary loss")
	TEST_ASSERT_EQUAL(subject.adjust_fatness(20, FATTENING_TYPE_ALMIGHTY, TRUE), 20, "Administrative adjustment remains available")

/datum/game_test/room_test/gs13_weight_bounds/Run()
	var/mob/living/carbon/human/subject = allocate(/mob/living/carbon/human)
	subject.max_weight = 101
	TEST_ASSERT_EQUAL(subject.adjust_fatness(1000, FATTENING_TYPE_ALMIGHTY, TRUE), 100, "Return actual gain at the cap")
	TEST_ASSERT_EQUAL(subject.fatness, 100, "Apparent weight must be capped")
	TEST_ASSERT_EQUAL(subject.adjust_fatness(-1000, FATTENING_TYPE_ALMIGHTY, TRUE), -100, "Return actual loss at zero")
	TEST_ASSERT_EQUAL(subject.fatness, 0, "Weight must not be negative")
	subject.max_weight = 0.5
	subject.adjust_fatness(100, FATTENING_TYPE_ALMIGHTY, TRUE)
	TEST_ASSERT_EQUAL(subject.fatness, 0, "A cap below one must not create negative weight")
	subject.max_weight = 0
	subject.adjust_fatness(100, FATTENING_TYPE_ALMIGHTY, TRUE)
	subject.adjust_perma(50, FATTENING_TYPE_ALMIGHTY, TRUE)
	subject.fully_heal_fatness(FALSE, "", "")
	TEST_ASSERT_EQUAL(subject.fatness, 50, "Ordinary healing preserves permanent weight")
	subject.fully_heal_fatness(TRUE, "", "")
	TEST_ASSERT_EQUAL(subject.fatness, 0, "Permanent healing recalculates apparent weight")

/datum/game_test/room_test/gs13_weight_rates/Run()
	var/mob/living/carbon/human/subject = allocate(/mob/living/carbon/human)
	subject.set_weight_gain_modifier("test", 100)
	TEST_ASSERT_EQUAL(subject.get_weight_gain_rate(), 2.5, "Individual modifiers are bounded")
	subject.set_weight_gain_modifier("test", 0.5)
	subject.set_weight_loss_modifier("test", 1)
	TEST_ASSERT_EQUAL(subject.get_weight_gain_rate(), 1, "Replacing a modifier must not accumulate it")
	TEST_ASSERT_EQUAL(subject.get_weight_loss_rate(), 1.5, "Gain and loss modifiers are independent")
	subject.flip_gain_rate = TRUE
	TEST_ASSERT_EQUAL(subject.get_weight_gain_rate(), -1, "Inversion applies after modifiers")
	subject.remove_weight_gain_modifier("test")
	TEST_ASSERT_EQUAL(subject.get_weight_gain_rate(), -0.5, "Removing a modifier restores the base rate")
	subject.gs13_preferences["muscle_gain"] = TRUE
	TEST_ASSERT_EQUAL(subject.adjust_muscle(100), 50, "Muscle gain uses its multiplier")
	TEST_ASSERT_EQUAL(subject.adjust_muscle(-100), -50, "Muscle loss cannot exceed available muscle")

/datum/game_test/room_test/gs13_preference_roundtrip/Run()
	var/list/saved = list("master_wg_pref" = TRUE, "weight_gain_food" = TRUE, "weight_gain_rate" = 99, "weight_loss_rate" = -1, "starting_fatness" = "bad", "unknown" = TRUE)
	var/list/loaded = gs13_sanitize_preferences(json_encode(saved))
	TEST_ASSERT_EQUAL(loaded["master_wg_pref"], TRUE, "Boolean survives JSON roundtrip")
	TEST_ASSERT_EQUAL(loaded["weight_gain_food"], TRUE, "Source switch survives JSON roundtrip")
	TEST_ASSERT_EQUAL(loaded["weight_gain_rate"], 2, "Rate upper bound")
	TEST_ASSERT_EQUAL(loaded["weight_loss_rate"], 0, "Rate lower bound")
	TEST_ASSERT_EQUAL(loaded["starting_fatness"], 0, "Invalid numbers fall back to defaults")
	TEST_ASSERT(!("unknown" in loaded), "Unknown keys must be dropped")
	loaded = gs13_sanitize_preferences("broken JSON")
	TEST_ASSERT_EQUAL(loaded["master_wg_pref"], FALSE, "Malformed saves default to disabled")
	var/datum/character_save/character = new
	character.gs13_preferences = list("master_wg_pref" = TRUE, "starting_fatness" = 300)
	var/mob/living/carbon/human/subject = allocate(/mob/living/carbon/human)
	character.apply_gs13_preferences(subject)
	TEST_ASSERT_EQUAL(subject.fatness, 300, "Starting weight applies on spawn")
	character.gs13_preferences["master_wg_pref"] = FALSE
	TEST_ASSERT_EQUAL(subject.gs13_preferences["master_wg_pref"], TRUE, "Body preferences are not a shared mutable list")
	qdel(character)

/datum/game_test/room_test/gs13_food_and_movement/Run()
	var/mob/living/carbon/human/subject = allocate(/mob/living/carbon/human)
	subject.gs13_preferences = gs13_default_preferences()
	subject.gs13_preferences["master_wg_pref"] = TRUE
	subject.nutrition = NUTRITION_LEVEL_FULL + 100
	subject.handle_weight_gain(2)
	TEST_ASSERT_EQUAL(subject.fatness, 0, "Disabled food source blocks conversion")
	subject.gs13_preferences["weight_gain_food"] = TRUE
	subject.handle_weight_gain(2)
	TEST_ASSERT_EQUAL(subject.fatness, 20, "GS13 nutrition efficiency and gain rate apply")
	TEST_ASSERT_EQUAL(subject.nutrition, NUTRITION_LEVEL_FULL + 50, "Converted nutrition is consumed once")
	subject.nutrition = NUTRITION_LEVEL_FULL
	subject.fatness_real = FATNESS_LEVEL_BLOB
	subject.handle_weight_gain(2)
	TEST_ASSERT_EQUAL(subject.gs13_movement_delay, FATNESS_MAX_MOVE_PENALTY, "Movement penalty is capped")
	subject.muscle_real = FATNESS_LEVEL_BLOB
	subject.handle_weight_gain(2)
	TEST_ASSERT_EQUAL(subject.gs13_movement_delay, 0, "Muscle offsets effective weight")
	TEST_ASSERT_EQUAL(gs13_weight_stage(FATNESS_LEVEL_BLOB), 9, "Stage boundary selects the new stage")

/datum/game_test/room_test/gs13_bluespace_belt/Run()
	var/mob/living/carbon/human/subject = allocate(/mob/living/carbon/human)
	var/obj/item/bluespace_belt/belt = allocate(/obj/item/bluespace_belt)
	subject.adjust_fatness(100, FATTENING_TYPE_ALMIGHTY, TRUE)
	subject.adjust_perma(30, FATTENING_TYPE_ALMIGHTY, TRUE)
	belt.forceMove(subject)
	belt.equipped(subject, ITEM_SLOT_BELT)
	TEST_ASSERT_EQUAL(subject.fatness, 30, "Belt preserves permanent weight")
	TEST_ASSERT_EQUAL(subject.fatness_real, 100, "Concealment does not destroy real weight")
	belt.hidden_percentage = 50
	subject.calculate_fatness()
	TEST_ASSERT_EQUAL(subject.fatness, 80, "Percentage controls concealed weight")
	belt.dropped(subject)
	TEST_ASSERT_EQUAL(subject.fatness, 130, "Removing belt restores apparent weight")
	belt.equipped(subject, ITEM_SLOT_BELT)
	qdel(belt)
	TEST_ASSERT_EQUAL(subject.fatness, 130, "Deleting belt removes concealment")

/datum/game_test/room_test/gs13_chemistry/Run()
	var/mob/living/carbon/human/subject = allocate(/mob/living/carbon/human)
	subject.gs13_preferences = gs13_default_preferences()
	subject.gs13_preferences["master_wg_pref"] = TRUE
	subject.reagents.add_reagent("lipoifier", 10)
	var/datum/reagent/consumable/lipoifier/lipoifier = subject.reagents.has_reagent("lipoifier")
	TEST_ASSERT_NOTNULL(lipoifier, "Reagent registered in Paradise chemistry")
	lipoifier.on_mob_life(subject)
	TEST_ASSERT_EQUAL(subject.fatness, 0, "Chemical respects source preference")
	subject.gs13_preferences["weight_gain_chems"] = TRUE
	lipoifier.on_mob_life(subject)
	TEST_ASSERT_EQUAL(subject.fatness, 6, "Two-second metabolism cycle uses configured gain rate")
	subject.reagents.add_reagent("fermi_fat", 10)
	var/datum/reagent/fermi_fat/galbanic = subject.reagents.has_reagent("fermi_fat")
	TEST_ASSERT_NOTNULL(galbanic, "Galbanic compound registered")
	galbanic.on_mob_life(subject)
	TEST_ASSERT_EQUAL(subject.fatness_perma, 0, "Galbanic compound respects permanent preference")
	subject.gs13_preferences["weight_gain_permanent"] = TRUE
	galbanic.on_mob_life(subject)
	TEST_ASSERT_EQUAL(subject.fatness_perma, 2, "Galbanic permanent weight when enabled")

/datum/game_test/room_test/gs13_weight_loss_chemistry/Run()
	var/mob/living/carbon/human/subject = allocate(/mob/living/carbon/human)
	subject.gs13_preferences = gs13_default_preferences()
	subject.gs13_preferences["master_wg_pref"] = TRUE
	subject.gs13_preferences["weight_gain_permanent"] = TRUE
	subject.adjust_fatness(100, FATTENING_TYPE_ALMIGHTY, TRUE)
	subject.adjust_perma(30, FATTENING_TYPE_ALMIGHTY, TRUE)
	subject.nutrition = 0
	subject.reagents.add_reagent("lipolicide", 10)
	subject.reagents.metabolize(subject)
	TEST_ASSERT_EQUAL(subject.fatness_real, 91.25, "Lipolicide reduces ordinary weight through native metabolism")
	TEST_ASSERT_EQUAL(subject.fatness_perma, 30, "Lipolicide cannot remove permanent weight")
	TEST_ASSERT_EQUAL(subject.getToxLoss(), 0, "GS13 lipolicide does not poison a starving subject")
	ADD_TRAIT(subject, TRAIT_LIPOLICIDE_TOLERANCE, "test")
	subject.reagents.metabolize(subject)
	TEST_ASSERT_EQUAL(subject.fatness_real, 91, "Lipolicide tolerance reduces its weight-loss effect")
	subject.reagents.clear_reagents()
	subject.reagents.add_reagent("fermi_slim", 10)
	subject.reagents.metabolize(subject)
	TEST_ASSERT_EQUAL(subject.fatness_real, 66, "Macerinic removes ordinary weight")
	TEST_ASSERT_EQUAL(subject.fatness_perma, 27.5, "Macerinic removes permanent weight")
	ADD_TRAIT(subject, TRAIT_MACERINIC_TOLERANCE, "test")
	subject.reagents.metabolize(subject)
	TEST_ASSERT_EQUAL(subject.fatness_real, 61, "Macerinic tolerance reduces ordinary loss")
	TEST_ASSERT_EQUAL(subject.fatness_perma, 27, "Macerinic tolerance reduces permanent loss")

/datum/game_test/room_test/gs13_chemical_overdose/Run()
	var/mob/living/carbon/human/subject = allocate(/mob/living/carbon/human)
	subject.gs13_preferences = gs13_default_preferences()
	subject.gs13_preferences["master_wg_pref"] = TRUE
	subject.gs13_preferences["weight_gain_chems"] = TRUE
	subject.gs13_preferences["weight_gain_permanent"] = TRUE
	subject.reagents.add_reagent("fermi_fat", 60)
	subject.reagents.metabolize(subject)
	TEST_ASSERT_EQUAL(subject.fatness_real, 20, "Galbanic normal and overdose effects both apply")
	TEST_ASSERT_EQUAL(subject.fatness_perma, 5, "Galbanic overdose adds to normal permanent gain")
	TEST_ASSERT_EQUAL(subject.getToxLoss(), 0, "Galbanic does not inherit Paradise's generic toxic overdose")
	subject.reagents.clear_reagents()
	subject.adjust_fatness(100, FATTENING_TYPE_ALMIGHTY, TRUE)
	subject.reagents.add_reagent("fermi_slim", 60)
	ADD_TRAIT(subject, TRAIT_MACERINIC_TOLERANCE, "test")
	subject.reagents.metabolize(subject)
	TEST_ASSERT_EQUAL(subject.fatness_real, 115, "Macerinic keeps working during overdose")
	TEST_ASSERT_EQUAL(subject.weight_loss_rate, 0.5, "Tolerance blocks the overdose rate boost")

/datum/game_test/room_test/gs13_fullness/Run()
	var/mob/living/carbon/human/subject = allocate(/mob/living/carbon/human)
	subject.gs13_preferences = gs13_default_preferences()
	subject.gs13_preferences["master_wg_pref"] = TRUE
	subject.nutrition = 300
	subject.reagents.add_reagent("nutriment", 10)
	TEST_ASSERT_EQUAL(subject.get_fullness(), 450, "Undigested food contributes its future nutrition")
	subject.fullness_adjustment = 30
	subject.handle_gs13_fullness(1)
	TEST_ASSERT_EQUAL(subject.fullness_adjustment, 22.5, "Bloating recovery scales with tick duration")
	subject.fullness_adjustment = -30
	subject.handle_gs13_fullness(1)
	TEST_ASSERT_EQUAL(subject.fullness_adjustment, -22.5, "Hunger recovers toward zero without overshooting")
	subject.fullness_adjustment = 9999
	subject.handle_gs13_fullness(0)
	TEST_ASSERT_EQUAL(subject.get_fullness(), FULLNESS_MAX, "Temporary bloating is bounded")
	subject.fullness_adjustment = -9999
	subject.handle_gs13_fullness(0)
	TEST_ASSERT_EQUAL(subject.get_fullness(), 0, "Hunger cannot make displayed fullness negative")
	subject.reagents.clear_reagents()
	subject.nutrition = FULLNESS_MAX + 1
	subject.fullness_adjustment = 0
	subject.handle_gs13_fullness(0)
	TEST_ASSERT_EQUAL(subject.get_fullness(), FULLNESS_MAX + 1, "Real excess food must not be hidden by an invented negative adjustment")
	TEST_ASSERT(subject.reduce_fullness(60, FALSE), "A full subject can relieve some fullness")
	TEST_ASSERT_NOT(subject.reduce_fullness(60, FALSE), "Repeated relief respects its cooldown")

/datum/game_test/room_test/gs13_feeding_limit/Run()
	var/mob/living/carbon/human/subject = allocate(/mob/living/carbon/human)
	var/obj/item/food/food = allocate(/obj/item/food)
	subject.gs13_preferences = gs13_default_preferences()
	TEST_ASSERT_NOT(subject.selfFeed(food, 800), "Paradise's original capacity remains when GS13 is disabled")
	subject.gs13_preferences["master_wg_pref"] = TRUE
	TEST_ASSERT(subject.selfFeed(food, 800), "GS13 allows eating beyond Paradise's original capacity")
	TEST_ASSERT_NOT(subject.selfFeed(food, FULLNESS_MAX + 1), "GS13 still enforces a capacity limit")

/datum/game_test/room_test/gs13_bloating_chemistry/Run()
	var/mob/living/carbon/human/subject = allocate(/mob/living/carbon/human)
	subject.gs13_preferences = gs13_default_preferences()
	subject.gs13_preferences["master_wg_pref"] = TRUE
	subject.nutrition = 0
	subject.reagents.add_reagent("fizulphite", 10)
	subject.reagents.metabolize(subject)
	TEST_ASSERT_EQUAL(subject.fullness_adjustment, 0, "Bloating respects the chemical preference")
	subject.gs13_preferences["weight_gain_chems"] = TRUE
	subject.reagents.metabolize(subject)
	TEST_ASSERT_EQUAL(subject.fullness_adjustment, 35, "Fizulphite increases temporary fullness")
	subject.reagents.clear_reagents()
	subject.nutrition = 1000
	subject.reagents.add_reagent("extilphite", 10)
	subject.reagents.metabolize(subject)
	TEST_ASSERT_EQUAL(subject.fullness_adjustment, -15, "Extilphite reduces fullness in a bloated subject")

/datum/game_test/room_test/gs13_galbanic_withdrawal/Run()
	var/mob/living/carbon/human/subject = allocate(/mob/living/carbon/human)
	subject.gs13_preferences = gs13_default_preferences()
	subject.gs13_preferences["master_wg_pref"] = TRUE
	subject.gs13_preferences["weight_gain_chems"] = TRUE
	subject.reagents.add_reagent("fermi_fat", 10)
	var/datum/reagent/fermi_fat/galbanic = subject.reagents.has_reagent("fermi_fat")
	galbanic.handle_addiction(subject, 81)
	TEST_ASSERT_EQUAL(length(subject.reagents.addiction_list), 1, "Galbanic uses Paradise's native addiction tracking")
	var/datum/reagent/fermi_fat/withdrawal = subject.reagents.addiction_list[1]
	withdrawal.addiction_act_stage2(subject)
	TEST_ASSERT_EQUAL(subject.get_weight_gain_modifier("galbanic"), 0.25, "Early withdrawal increases gain rate")
	withdrawal.addiction_act_stage4(subject)
	withdrawal.addiction_act_stage5(subject)
	TEST_ASSERT_EQUAL(subject.get_weight_gain_modifier("galbanic"), 1, "Late withdrawal is bounded across repeated processing")
	TEST_ASSERT(subject.fullness_adjustment < 0, "Withdrawal causes hunger")
	var/before = subject.fatness_real
	subject.gs13_preferences["weight_gain_chems"] = FALSE
	withdrawal.addiction_act_stage5(subject)
	TEST_ASSERT_EQUAL(subject.fatness_real, before, "Withdrawal still respects source preferences")

/datum/game_test/room_test/gs13_virology/Run()
	var/datum/disease/advance/gs13_weight_gain/disease = allocate(/datum/disease/advance/gs13_weight_gain)
	var/mob/living/carbon/human/subject = allocate(/mob/living/carbon/human)
	disease.affected_mob = subject
	disease.stage = 5
	subject.gs13_preferences = gs13_default_preferences()
	subject.gs13_preferences["master_wg_pref"] = TRUE
	var/datum/symptom/gs13_weight_gain/symptom = disease.symptoms[1]
	symptom.symptom_act(disease, 1)
	TEST_ASSERT_EQUAL(subject.fatness_real, 0, "Viral weight gain requires its source preference")
	subject.gs13_preferences["weight_gain_viruses"] = TRUE
	disease.base_properties["stage rate"] = 1
	symptom.symptom_act(disease, 1)
	TEST_ASSERT_EQUAL(subject.fatness_real, 1, "Basic virus uses the configured gain multiplier")
	disease.base_properties["stage rate"] = 9
	symptom.symptom_act(disease, 1)
	TEST_ASSERT_EQUAL(subject.fatness_real, 6, "Fast virus uses the higher GS13 gain threshold")
	symptom.symptom_act(disease, 0)
	TEST_ASSERT_EQUAL(subject.fatness_real, 6, "Full treatment blocks the symptom's effect")
