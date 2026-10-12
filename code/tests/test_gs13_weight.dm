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

/datum/game_test/room_test/gs13_projectile_effects/Run()
	var/mob/living/carbon/human/subject = allocate(/mob/living/carbon/human)
	var/obj/projectile/beam/fattening/shot = allocate(/obj/projectile/beam/fattening)
	subject.gs13_preferences = gs13_default_preferences()
	subject.gs13_preferences["master_wg_pref"] = TRUE
	subject.bullet_act(shot, "chest")
	TEST_ASSERT_EQUAL(subject.fatness_real, 0, "Projectiles respect the weapon source switch")
	subject.gs13_preferences["weight_gain_weapons"] = TRUE
	subject.bullet_act(shot, "chest")
	TEST_ASSERT_EQUAL(subject.fatness_real, 100, "Native projectile impact applies the personal gain rate")
	shot.on_hit(subject, 50, "chest")
	TEST_ASSERT_EQUAL(subject.fatness_real, 150, "Paradise armor reduces projectile weight effects")
	shot.on_hit(subject, INFINITY, "chest")
	TEST_ASSERT_EQUAL(subject.fatness_real, 150, "Complete armor immunity blocks weight effects")
	subject.status_flags |= GODMODE
	subject.bullet_act(shot, "chest")
	TEST_ASSERT_EQUAL(subject.fatness_real, 150, "Godmode blocks projectile weight effects")

/datum/game_test/room_test/gs13_metabolism_rays/Run()
	var/mob/living/carbon/human/subject = allocate(/mob/living/carbon/human)
	var/obj/projectile/beam/alter_ray/gain_rate/increase/gain = allocate(/obj/projectile/beam/alter_ray/gain_rate/increase)
	var/obj/projectile/beam/alter_ray/loss_rate/decrease/loss = allocate(/obj/projectile/beam/alter_ray/loss_rate/decrease)
	var/obj/projectile/beam/alter_ray/lossrate_reverse/reverse = allocate(/obj/projectile/beam/alter_ray/lossrate_reverse)
	subject.gs13_preferences = gs13_default_preferences()
	subject.gs13_preferences["master_wg_pref"] = TRUE
	subject.bullet_act(gain, "chest")
	subject.bullet_act(reverse, "chest")
	TEST_ASSERT_EQUAL(subject.get_weight_gain_rate(), 0.5, "Disabled weapons cannot alter metabolism")
	TEST_ASSERT_NOT(subject.flip_loss_rate, "Disabled weapons cannot reverse metabolism")
	subject.gs13_preferences["weight_gain_weapons"] = TRUE
	subject.bullet_act(gain, "chest")
	subject.bullet_act(loss, "chest")
	TEST_ASSERT(abs(subject.get_weight_gain_rate() - (0.6)) < 0.0001, "Gain mode increases only the gain multiplier")
	TEST_ASSERT(abs(subject.get_weight_loss_rate() - (0.4)) < 0.0001, "Loss mode decreases only the loss multiplier")
	gain.on_hit(subject, INFINITY, "chest")
	reverse.on_hit(subject, INFINITY, "chest")
	TEST_ASSERT(abs(subject.get_weight_gain_rate() - (0.6)) < 0.0001, "Immunity blocks rate changes")
	TEST_ASSERT_NOT(subject.flip_loss_rate, "Immunity blocks reversal")
	subject.bullet_act(reverse, "chest")
	TEST_ASSERT(abs(subject.get_weight_loss_rate() - (-0.4)) < 0.0001, "Reverser inverts the final loss multiplier")
	subject.bullet_act(reverse, "chest")
	TEST_ASSERT(abs(subject.get_weight_loss_rate() - (0.4)) < 0.0001, "A second reverser hit restores the multiplier")

/datum/game_test/room_test/gs13_energy_weapons/Run()
	var/mob/living/carbon/human/shooter = allocate(/mob/living/carbon/human)
	var/mob/living/carbon/human/subject = allocate(/mob/living/carbon/human)
	// The room allocator chooses random tiles. Keep these hits point-blank and synchronous.
	subject.forceMove(get_turf(shooter))
	subject.gs13_preferences = gs13_default_preferences()
	subject.gs13_preferences["master_wg_pref"] = TRUE
	subject.gs13_preferences["weight_gain_weapons"] = TRUE
	var/list/gun_types = list(
		/obj/item/gun/energy/fatoray,
		/obj/item/gun/energy/fatoray/weak,
		/obj/item/gun/energy/fatoray/cannon,
		/obj/item/gun/energy/fatoray/cannon/weak,
		/obj/item/gun/energy/fatoray/stunning,
		/obj/item/gun/energy/fatoray/stunning/antag,
		/obj/item/gun/energy/gun/fattening,
		/obj/item/gun/energy/gun/fattening/antag)
	for(var/gun_type in gun_types)
		var/obj/item/gun/energy/gun = allocate(gun_type)
		gun.forceMove(shooter)
		TEST_ASSERT(gun.can_shoot(), "[gun_type] starts with enough charge to fire")
		TEST_ASSERT_NOTNULL(gun.chambered?.BB, "[gun_type] prepares its projectile")
		var/obj/item/ammo_casing/energy/casing = gun.chambered
		var/expected_weight = subject.fatness_real + casing.BB.fat_added * 0.5
		var/expected_charge = gun.cell.charge - casing.e_cost
		gun.process_fire(subject, shooter, FALSE, zone_override = "chest")
		TEST_ASSERT_EQUAL(subject.fatness_real, expected_weight, "[gun_type] fires through Paradise's gun and impact pipeline")
		TEST_ASSERT_EQUAL(gun.cell.charge, expected_charge, "[gun_type] consumes power once")
		TEST_ASSERT(gun.icon_state in icon_states(gun.icon), "[gun_type] has a valid ground sprite")
		TEST_ASSERT(gun.inhand_icon_state in icon_states(gun.lefthand_file), "[gun_type] has a valid in-hand sprite")

	var/obj/item/gun/energy/gun/fattening/matador = allocate(/obj/item/gun/energy/gun/fattening)
	matador.select_fire(shooter)
	TEST_ASSERT(istype(matador.chambered.BB, /obj/projectile/beam/disabler), "Matador switches to the native disabler")
	var/obj/item/gun/energy/laser/alter_ray/gainrate/alter = allocate(/obj/item/gun/energy/laser/alter_ray/gainrate)
	TEST_ASSERT_EQUAL(length(alter.ammo_type), 4, "Metabolism gun provides all four source modes")
	alter.forceMove(shooter)
	alter.select_fire(shooter)
	alter.process_fire(subject, shooter, FALSE, zone_override = "chest")
	TEST_ASSERT(abs(subject.get_weight_gain_rate() - (0.6)) < 0.0001, "Selected metabolism mode reaches the target")
	for(var/i in 1 to alter.charge_delay)
		alter.process()
	TEST_ASSERT_EQUAL(alter.cell.charge, alter.cell.maxcharge, "Alter-ray self-charging restores the spent shot")

/datum/game_test/room_test/gs13_calorite_materials/Run()
	var/obj/machinery/mineral/ore_redemption/orm = allocate(/obj/machinery/mineral/ore_redemption)
	var/obj/item/stack/ore/calorite/ore = allocate(/obj/item/stack/ore/calorite, null, 2)
	orm.smelt_ore(ore)
	TEST_ASSERT_EQUAL(orm.mat_container.amount(MAT_CALORITE), 4000, "ORM smelts calorite into stored sheet material")
	TEST_ASSERT_EQUAL(orm.points, 80, "Calorite awards its source mining points")
	var/obj/machinery/r_n_d/protolathe/lathe = allocate(/obj/machinery/r_n_d/protolathe)
	TEST_ASSERT_EQUAL(orm.mat_container.retrieve_sheets(1, MAT_CALORITE, get_turf(lathe)), 1, "ORM dispenses a calorite sheet")
	var/obj/item/stack/sheet/mineral/calorite/sheet = locate() in get_turf(lathe)
	TEST_ASSERT_NOTNULL(sheet, "ORM outputs the registered sheet type")
	TEST_ASSERT(sheet.inhand_icon_state in icon_states(sheet.lefthand_file), "Calorite has a valid in-hand sprite")
	TEST_ASSERT_EQUAL(lathe.materials.insert_item(sheet), 1, "Protolathe accepts the dispensed sheet")
	TEST_ASSERT_EQUAL(lathe.materials.amount(MAT_CALORITE), 2000, "Protolathe stores the full sheet value")
	lathe.materials.insert_amount(800, MAT_METAL)
	lathe.materials.insert_amount(600, MAT_GLASS)
	var/datum/design/fatoray_weak/design = allocate(/datum/design/fatoray_weak)
	TEST_ASSERT(lathe.materials.has_materials(design.materials), "Basic Fatoray requirements include calorite")
	lathe.materials.use_amount(design.materials)
	TEST_ASSERT_EQUAL(lathe.materials.amount(MAT_CALORITE), 1000, "Building consumes the required calorite")
	TEST_ASSERT_NOT(lathe.materials.has_materials(design.materials), "A second build requires additional materials")
	var/datum/research/research = allocate(/datum/research)
	TEST_ASSERT_NOT(research.known_designs["fatoray_weak"], "GS13 weapons require research")
	for(var/id in research.known_tech)
		var/datum/tech/technology = research.known_tech[id]
		technology.level = 6
	research.RefreshResearch()
	TEST_ASSERT(research.known_designs["fatoray_weak"], "Native research unlocks the Basic Fatoray")
	TEST_ASSERT(research.known_designs["alter_ray_reverser"], "Native research unlocks the AL-T-Ray")

/datum/game_test/room_test/gs13_calorite_contact/Run()
	var/mob/living/carbon/human/subject = allocate(/mob/living/carbon/human)
	var/obj/item/stack/sheet/mineral/calorite/sheet = allocate(/obj/item/stack/sheet/mineral/calorite)
	subject.gs13_preferences = gs13_default_preferences()
	subject.gs13_preferences["master_wg_pref"] = TRUE
	SEND_SIGNAL(sheet, COMSIG_ATOM_ATTACK_HAND, subject)
	TEST_ASSERT_EQUAL(subject.fatness_real, 0, "Calorite contact respects the item preference")
	subject.gs13_preferences["weight_gain_items"] = TRUE
	SEND_SIGNAL(sheet, COMSIG_ATOM_ATTACK_HAND, subject)
	TEST_ASSERT_EQUAL(subject.fatness_real, 1, "Bare-handed contact applies the source effect")
	var/obj/item/clothing/gloves/color/black/gloves = allocate(/obj/item/clothing/gloves/color/black)
	TEST_ASSERT(subject.equip_to_slot_if_possible(gloves, ITEM_SLOT_GLOVES), "Test subject can wear protective gloves")
	SEND_SIGNAL(sheet, COMSIG_ATOM_ATTACK_HAND, subject)
	TEST_ASSERT_EQUAL(subject.fatness_real, 1, "Gloves prevent direct contact with calorite")
	SEND_SIGNAL(sheet, COMSIG_ATOM_BUMPED, subject)
	TEST_ASSERT_EQUAL(subject.fatness_real, 2, "Bumping uses the independent contact signal")
	qdel(sheet.GetComponent(/datum/component/fattening))
	SEND_SIGNAL(sheet, COMSIG_ATOM_BUMPED, subject)
	TEST_ASSERT_EQUAL(subject.fatness_real, 2, "Removing the component unregisters contact effects")

/datum/game_test/room_test/gs13_weight_damage/Run()
	var/mob/living/carbon/human/subject = allocate(/mob/living/carbon/human)
	subject.gs13_preferences = gs13_default_preferences()
	subject.apply_damage(10, FAT, "chest")
	TEST_ASSERT_EQUAL(subject.getStaminaLoss(), 10, "Disabled weight damage falls back to stamina")
	subject.gs13_preferences["master_wg_pref"] = TRUE
	subject.gs13_preferences["weight_gain_weapons"] = TRUE
	subject.apply_damage(10, FAT, "chest", 50)
	TEST_ASSERT_EQUAL(subject.fatness_real, 10, "Melee weight damage uses Paradise's armor equation")
	subject.apply_damage(10, PERMA_FAT, "chest")
	TEST_ASSERT_EQUAL(subject.fatness_real, 30, "Disabled permanent damage falls back to ordinary weight")
	TEST_ASSERT_EQUAL(subject.fatness_perma, 0, "Permanent preference remains enforced")
	subject.gs13_preferences["weight_gain_permanent"] = TRUE
	subject.apply_damage(10, PERMA_FAT, "chest")
	TEST_ASSERT_EQUAL(subject.fatness_perma, 15, "Permanent damage applies its separate conversion factor")
	subject.apply_damage(100, FAT, "chest", INFINITY)
	TEST_ASSERT_EQUAL(subject.fatness_real, 30, "Immune armor blocks weight damage")
	TEST_ASSERT_EQUAL(subject.getBruteLoss(), 0, "Weight damage does not become brute damage")
	var/mob/living/carbon/alien/alien = allocate(/mob/living/carbon/alien)
	alien.gs13_preferences = subject.gs13_preferences.Copy()
	alien.apply_damage(10, FAT)
	TEST_ASSERT_EQUAL(alien.fatness_real, 20, "Non-human carbons also receive weight damage")

/datum/game_test/room_test/gs13_micro_calorite/Run()
	var/mob/living/carbon/human/subject = allocate(/mob/living/carbon/human)
	subject.gs13_preferences = gs13_default_preferences()
	subject.gs13_preferences["master_wg_pref"] = TRUE
	subject.reagents.add_reagent("micro_calorite", 10)
	subject.reagents.metabolize(subject)
	TEST_ASSERT_EQUAL(subject.get_weight_gain_rate(), 0.5, "Disabled chemicals cannot alter metabolism")
	TEST_ASSERT_EQUAL(subject.micro_calorite_poisoning, 0, "Severe effects default to disabled")
	subject.gs13_preferences["weight_gain_chems"] = TRUE
	subject.gs13_preferences["severe_fatness_penalty"] = TRUE
	subject.reagents.metabolize(subject)
	TEST_ASSERT(abs(subject.get_weight_gain_rate() - 0.8) < 0.0001, "Micro calorite increases gain rate")
	TEST_ASSERT(abs(subject.get_weight_loss_rate() - 0.2) < 0.0001, "Micro calorite decreases loss rate")
	TEST_ASSERT(subject.micro_calorite_poisoning > 0, "Metabolism accumulates permitted exposure")
	subject.reagents.clear_reagents()
	TEST_ASSERT_EQUAL(subject.get_weight_gain_rate(), 0.5, "Removing the reagent cleans up its gain modifier")
	TEST_ASSERT_EQUAL(subject.get_weight_loss_rate(), 0.5, "Removing the reagent cleans up its loss modifier")
	subject.reagents.add_reagent("micro_calorite", 110)
	subject.reagents.metabolize(subject)
	TEST_ASSERT(abs(subject.get_weight_gain_modifier("micro_calorite") - 0.6) < 0.0001, "Overdose doubles the temporary modifier")
	TEST_ASSERT(abs(subject.fatness_real - 2.2) < 0.0001, "Overdose delivers native-cycle weight gain")
	subject.reagents.metabolize(subject)
	TEST_ASSERT(abs(subject.get_weight_gain_modifier("micro_calorite") - 0.6) < 0.0001, "Repeated overdose processing cannot stack the modifier")
	subject.gs13_preferences["weight_gain_chems"] = FALSE
	var/before = subject.fatness_real
	subject.reagents.metabolize(subject)
	TEST_ASSERT_EQUAL(subject.get_weight_gain_rate(), 0.5, "Disabling chemicals clears an active modifier")
	TEST_ASSERT_EQUAL(subject.fatness_real, before, "Disabling chemicals blocks further overdose gain")
	TEST_ASSERT_EQUAL(subject.getToxLoss(), 0, "Micro calorite does not inherit generic toxic overdose")

/datum/game_test/room_test/gs13_calorite_poisoning/Run()
	var/mob/living/carbon/human/subject = allocate(/mob/living/carbon/human)
	subject.gs13_preferences = gs13_default_preferences()
	subject.gs13_preferences["master_wg_pref"] = TRUE
	TEST_ASSERT_NOT(subject.adjust_calorite_poisoning(100), "Exposure requires the severe-effects preference")
	subject.gs13_preferences["severe_fatness_penalty"] = TRUE
	subject.adjust_calorite_poisoning(1000)
	TEST_ASSERT_EQUAL(subject.micro_calorite_poisoning, 100, "Exposure is bounded at 100 percent")
	subject.handle_weight_gain(0)
	TEST_ASSERT_EQUAL(subject.get_weight_gain_rate(), 1.5, "Severe exposure changes body metabolism")
	TEST_ASSERT(subject.gs13_movement_delay > 0, "Severe exposure affects movement")
	subject.gs13_preferences["severe_fatness_penalty"] = FALSE
	subject.handle_weight_gain(0)
	TEST_ASSERT_EQUAL(subject.get_weight_gain_rate(), 0.5, "Turning severe effects off removes their modifier")
	TEST_ASSERT_EQUAL(subject.gs13_movement_delay, 0, "Turning severe effects off removes their slowdown")
	subject.gs13_preferences["severe_fatness_penalty"] = TRUE
	subject.gs13_preferences["weight_gain_weapons"] = TRUE
	subject.micro_calorite_poisoning = 10
	var/obj/projectile/beam/fattening/shot = allocate(/obj/projectile/beam/fattening)
	subject.bullet_act(shot, "chest")
	TEST_ASSERT_EQUAL(subject.fatness_perma, 0, "Calorite reaction respects permanent-weight preference")
	TEST_ASSERT_EQUAL(subject.micro_calorite_poisoning, 10, "Blocked permanent conversion does not consume exposure")
	subject.gs13_preferences["weight_gain_permanent"] = TRUE
	subject.bullet_act(shot, "chest")
	TEST_ASSERT_EQUAL(subject.fatness_perma, 200, "Fatoray converts exposure into permanent weight")
	TEST_ASSERT_EQUAL(subject.micro_calorite_poisoning, 8, "Conversion consumes the source amount of exposure")
	shot.on_hit(subject, INFINITY, "chest")
	TEST_ASSERT_EQUAL(subject.fatness_perma, 200, "Armor immunity blocks the calorite reaction")

/datum/game_test/room_test/gs13_melee_weapons/Run()
	var/mob/living/carbon/human/attacker = allocate(/mob/living/carbon/human)
	var/mob/living/carbon/human/subject = allocate(/mob/living/carbon/human)
	subject.forceMove(get_turf(attacker))
	attacker.a_intent = INTENT_HARM
	subject.gs13_preferences = gs13_default_preferences()
	subject.gs13_preferences["master_wg_pref"] = TRUE
	subject.gs13_preferences["weight_gain_weapons"] = TRUE
	for(var/weapon_type in list(/obj/item/melee/baton/loaded/fattening, /obj/item/melee/baton/loaded/fattening/stunsword, /obj/item/melee/classic_baton/fattening, /obj/item/melee/chainofcommand/fattening, /obj/item/gavelhammer/fattening))
		var/obj/item/weapon = allocate(weapon_type)
		weapon.forceMove(attacker)
		var/before = subject.fatness_real
		weapon.melee_attack_chain(attacker, subject)
		TEST_ASSERT_EQUAL(subject.fatness_real - before, weapon.force * 2, "[weapon.type] applies weight through the native attack chain")
		TEST_ASSERT(weapon.icon_state in icon_states(weapon.icon), "[weapon.type] has a valid object sprite")
	TEST_ASSERT_EQUAL(subject.getBruteLoss(), 0, "Weight melee attacks do not deal brute damage")
	var/obj/item/gavelhammer/fattening/permanent/hammer = allocate(/obj/item/gavelhammer/fattening/permanent)
	hammer.forceMove(attacker)
	subject.gs13_preferences["weight_gain_permanent"] = TRUE
	hammer.melee_attack_chain(attacker, subject)
	TEST_ASSERT_EQUAL(subject.fatness_perma, 45, "Galbanic melee damage reaches the permanent-weight channel")
	subject.gs13_preferences["weight_gain_weapons"] = FALSE
	hammer.melee_attack_chain(attacker, subject)
	TEST_ASSERT_EQUAL(subject.getStaminaLoss(), 30, "Disabled weapon effects fall back to stamina in real melee combat")
	var/obj/item/melee/baton/loaded/fattening/baton = allocate(/obj/item/melee/baton/loaded/fattening)
	baton.forceMove(attacker)
	subject.gs13_preferences["weight_gain_weapons"] = TRUE
	attacker.a_intent = INTENT_DISARM
	baton.turned_on = TRUE
	var/before_fat = subject.fatness_real
	var/before_charge = baton.cell.charge
	baton.melee_attack_chain(attacker, subject)
	TEST_ASSERT_EQUAL(subject.fatness_real, before_fat, "Non-harm baton intent retains the native stun without weight damage")
	TEST_ASSERT_EQUAL(baton.cell.charge, before_charge - baton.hitcost, "Native stun consumes the baton cell")

/datum/game_test/room_test/gs13_whip_disarm/Run()
	var/mob/living/carbon/human/attacker = allocate(/mob/living/carbon/human)
	var/mob/living/carbon/human/subject = allocate(/mob/living/carbon/human)
	subject.forceMove(get_turf(attacker))
	attacker.a_intent = INTENT_HARM
	var/obj/item/melee/chainofcommand/fattening/whip = allocate(/obj/item/melee/chainofcommand/fattening)
	whip.forceMove(attacker)
	var/obj/item/pen/left = allocate(/obj/item/pen)
	var/obj/item/pen/right = allocate(/obj/item/pen)
	subject.put_in_l_hand(left)
	subject.put_in_r_hand(right)
	whip.after_attack(subject, attacker, FALSE)
	TEST_ASSERT_EQUAL(subject.l_hand, left, "Ranged clicks cannot disarm the left hand")
	TEST_ASSERT_EQUAL(subject.r_hand, right, "Ranged clicks cannot disarm the right hand")
	whip.melee_attack_chain(attacker, subject)
	TEST_ASSERT_NULL(subject.l_hand, "Close-range whip strikes drop the left-hand item")
	TEST_ASSERT_NULL(subject.r_hand, "Close-range whip strikes drop the right-hand item")
	TEST_ASSERT_EQUAL(left.loc, get_turf(subject), "Disarmed items remain on the floor")

/datum/game_test/room_test/gs13_cyborg_fatoray/Run()
	var/mob/living/carbon/human/installer = allocate(/mob/living/carbon/human)
	var/mob/living/silicon/robot/robot = allocate(/mob/living/silicon/robot)
	var/obj/item/borg/upgrade/fatoray/upgrade = allocate(/obj/item/borg/upgrade/fatoray)
	TEST_ASSERT_NOT(upgrade.pre_install_checks(installer, robot), "A module-less cyborg cannot receive the upgrade")
	robot.module = allocate(/obj/item/robot_module/engineering, robot)
	installer.put_in_active_hand(upgrade)
	TEST_ASSERT(upgrade.action(installer, robot), "The Fatoray installs using the native upgrade action")
	var/obj/item/gun/energy/fatoray/weak/cyborg/gun = locate() in robot.module.modules
	TEST_ASSERT_NOTNULL(gun, "The installed weapon appears in the cyborg's usable module list")
	var/obj/item/borg/upgrade/fatoray/duplicate = allocate(/obj/item/borg/upgrade/fatoray)
	TEST_ASSERT_NOT(duplicate.pre_install_checks(installer, robot), "Duplicate upgrades are rejected")
	var/mob/living/carbon/human/subject = allocate(/mob/living/carbon/human)
	subject.forceMove(get_turf(robot))
	subject.gs13_preferences = gs13_default_preferences()
	subject.gs13_preferences["master_wg_pref"] = TRUE
	subject.gs13_preferences["weight_gain_weapons"] = TRUE
	gun.forceMove(robot)
	robot.cell.charge = robot.cell.maxcharge
	var/before_charge = robot.cell.charge
	gun.process_fire(subject, robot, FALSE, zone_override = "chest")
	TEST_ASSERT_EQUAL(subject.fatness_real, 50, "The mounted weapon fires its Basic Fatoray projectile")
	TEST_ASSERT_EQUAL(robot.cell.charge, before_charge - 100, "Mounted weapon recharging consumes cyborg power")
	TEST_ASSERT_EQUAL(gun.cell.charge, gun.cell.maxcharge, "Cyborg power restores the internal gun cell")
