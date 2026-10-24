/datum/game_test/room_test/gs13_berry_symptom_production/Run()
	var/mob/living/carbon/human/subject = allocate(/mob/living/carbon/human)
	var/datum/disease/advance/gs13_berry/disease = allocate(/datum/disease/advance/gs13_berry)
	disease.affected_mob = subject
	disease.base_properties["stage rate"] = 4
	disease.stage = 5
	disease.processing = TRUE
	var/datum/symptom/gs13_berry/symptom = disease.symptoms[1]
	symptom.Start(disease)
	TEST_ASSERT_NOT(subject.reagents.has_reagent("blueberry_juice"), "Berrification does not produce juice without its separate opt-in")
	subject.gs13_preferences["blueberry_inflation"] = TRUE
	symptom.Start(disease)
	TEST_ASSERT_EQUAL(subject.reagents.get_reagent_amount("blueberry_juice"), 40, "The initial dose follows source stage speed")
	symptom.symptom_act(disease, 1)
	TEST_ASSERT_EQUAL(subject.reagents.get_reagent_amount("blueberry_juice"), 40, "The initial dose is not immediately duplicated by activation")
	symptom.next_production = 0
	symptom.symptom_act(disease, 1)
	TEST_ASSERT_EQUAL(subject.reagents.get_reagent_amount("blueberry_juice"), 60, "Each production interval uses source stage and stage speed")
	symptom.next_production = 0
	symptom.symptom_act(disease, 0)
	TEST_ASSERT_EQUAL(subject.reagents.get_reagent_amount("blueberry_juice"), 60, "A fully mitigated symptom does not produce juice")
	var/datum/component/gs13_berry_sound/controller = subject.GetComponent(/datum/component/gs13_berry_sound)
	TEST_ASSERT_NOTNULL(controller, "An active infection acquires the native sound controller")
	TEST_ASSERT_NOT(controller.inflation_loop.muted, "The original inflation loop starts for a living infected host")

/datum/game_test/room_test/gs13_berry_native_infection_and_cure/Run()
	var/mob/living/carbon/human/subject = allocate(/mob/living/carbon/human)
	subject.gs13_preferences["blueberry_inflation"] = TRUE
	var/datum/disease/advance/gs13_berry/seed = allocate(/datum/disease/advance/gs13_berry)
	TEST_ASSERT(subject.ForceContractDisease(seed), "Native virology can infect an organic host with Berrification")
	var/datum/disease/advance/infection = subject.viruses[1]
	var/datum/symptom/gs13_berry/symptom = locate() in infection.symptoms
	TEST_ASSERT_NOTNULL(symptom, "The native disease copy retains the symptom")
	infection.stage_act()
	TEST_ASSERT(subject.reagents.has_reagent("blueberry_juice"), "The ordinary disease processing path seeds juice")
	var/datum/component/gs13_berry_sound/controller = subject.GetComponent(/datum/component/gs13_berry_sound)
	var/datum/looping_sound/gs13_blueberry/sound_loop = controller.inflation_loop
	subject.reagents.del_reagent("blueberry_juice")
	TEST_ASSERT(QDELETED(infection), "Completely draining juice cures the active disease immediately")
	TEST_ASSERT_NOT(infection in subject.viruses, "The cured disease leaves the native infection list")
	TEST_ASSERT(QDELETED(sound_loop), "Cure deletes the owned sound loop")
	TEST_ASSERT(QDELETED(controller), "Cure deletes the unused sound controller")
	TEST_ASSERT_NULL(subject.color, "Draining also restores ordinary body appearance")

/datum/game_test/room_test/gs13_berry_sound_lifecycle/Run()
	var/mob/living/carbon/human/subject = allocate(/mob/living/carbon/human)
	subject.gs13_preferences["blueberry_inflation"] = TRUE
	subject.reagents.add_reagent("blueberry_juice", 40)
	var/datum/first = allocate(/datum)
	var/datum/second = allocate(/datum)
	var/datum/component/gs13_berry_sound/controller = subject.LoadComponent(/datum/component/gs13_berry_sound)
	controller.add_source(first)
	controller.add_source(second)
	controller.add_source(first)
	TEST_ASSERT_EQUAL(length(controller.sources), 2, "Multiple infections share exactly one source entry apiece")
	var/datum/looping_sound/gs13_blueberry/sound_loop = controller.inflation_loop
	subject.death()
	TEST_ASSERT(sound_loop.muted, "Death immediately stops the body's loop")
	subject.update_revive()
	TEST_ASSERT_NOT(sound_loop.muted, "Revival restarts a retained infection's loop")
	qdel(first)
	TEST_ASSERT_NOT(QDELETED(controller), "Removing one infection preserves another source's loop")
	TEST_ASSERT_NOT(sound_loop.muted, "The remaining infection keeps the sound active")
	qdel(second)
	TEST_ASSERT(QDELETED(controller) && QDELETED(sound_loop), "Deleting the final source releases sound state")
	controller = subject.LoadComponent(/datum/component/gs13_berry_sound)
	controller.add_source(allocate(/datum))
	sound_loop = controller.inflation_loop
	qdel(subject)
	TEST_ASSERT(QDELETED(controller) && QDELETED(sound_loop), "Body deletion releases the loop and controller")

/datum/game_test/room_test/gs13_blueberry_crop_harvest/Run()
	var/mob/living/carbon/human/gardener = allocate(/mob/living/carbon/human, get_step(get_turf(bottom_left), EAST))
	var/obj/item/seeds/berry/base_seed = allocate(/obj/item/seeds/berry)
	TEST_ASSERT(/obj/item/seeds/berry/blueberry in base_seed.mutatelist, "Normal berry mutation supplies blueberry seeds")
	TEST_ASSERT(/obj/item/seeds/berry/glow in base_seed.mutatelist && /obj/item/seeds/berry/poison in base_seed.mutatelist, "Existing native berry mutations remain available")
	var/obj/item/seeds/berry/blueberry/seed = allocate(/obj/item/seeds/berry/blueberry)
	TEST_ASSERT_EQUAL(seed.potency, 1, "The starting crop retains the source's low potency")
	TEST_ASSERT(seed.icon_state in icon_states(seed.icon), "The seed packet uses original source artwork")
	for(var/stage in 1 to seed.growthstages)
		TEST_ASSERT("[seed.icon_grow][stage]" in icon_states(seed.growing_icon), "Every native growth stage has valid source artwork")
	TEST_ASSERT(seed.icon_harvest in icon_states(seed.growing_icon), "The crop has source harvest artwork")
	seed.set_potency(40)
	var/obj/machinery/hydroponics/tray = allocate(/obj/machinery/hydroponics, get_turf(bottom_left))
	gardener.put_in_active_hand(seed)
	tray.item_interaction(gardener, seed, list())
	TEST_ASSERT_EQUAL(tray.myseed, seed, "Native planting accepts the mutation")
	tray.harvest = TRUE
	tray.attack_hand(gardener)
	var/obj/item/food/grown/berries/blueberry/fruit = locate() in get_turf(gardener)
	TEST_ASSERT_NOTNULL(fruit, "Native harvesting produces blueberries")
	TEST_ASSERT_EQUAL(fruit.reagents.get_reagent_amount("blueberry_juice"), 4, "Potency controls the source chemical yield")
	TEST_ASSERT(fruit.icon_state in icon_states(fruit.icon), "The harvested fruit has original source artwork")
	TEST_ASSERT(seedify(fruit, 2), "The native extractor accepts cultivated blueberries")
	var/count = 0
	for(var/obj/item/seeds/berry/blueberry/recovered in get_turf(gardener))
		count++
		TEST_ASSERT_EQUAL(recovered.potency, 40, "Extracted seeds preserve the cultivated genetics")
	TEST_ASSERT_EQUAL(count, 2, "Extraction returns the requested seed count")

/datum/game_test/room_test/gs13_blueberry_crop_processing/Run()
	var/mob/living/carbon/human/gardener = allocate(/mob/living/carbon/human)
	var/obj/machinery/reagentgrinder/grinder = allocate(/obj/machinery/reagentgrinder, get_turf(gardener))
	var/obj/item/seeds/berry/blueberry/seed = allocate(/obj/item/seeds/berry/blueberry)
	seed.set_potency(40)
	var/obj/item/food/grown/berries/blueberry/fruit = allocate(/obj/item/food/grown/berries/blueberry, get_turf(gardener), seed)
	gardener.put_in_active_hand(fruit)
	grinder.item_interaction(gardener, fruit, list())
	grinder.grind()
	TEST_ASSERT(QDELETED(fruit), "Native grinding consumes the fruit")
	TEST_ASSERT_EQUAL(grinder.beaker.reagents.get_reagent_amount("blueberry_juice"), 4, "Grinding extracts the original transformation chemical")
	grinder.beaker.reagents.clear_reagents()
	fruit = allocate(/obj/item/food/grown/berries/blueberry, get_turf(gardener), seed)
	gardener.put_in_active_hand(fruit)
	grinder.item_interaction(gardener, fruit, list())
	grinder.juice()
	TEST_ASSERT(QDELETED(fruit), "Native juicing consumes the fruit")
	TEST_ASSERT(grinder.beaker.reagents.has_reagent("berryjuice"), "The source's ordinary berry-juice processing product remains available")

/datum/game_test/room_test/gs13_blueberry_collection/Run()
	var/mob/living/carbon/human/user = allocate(/mob/living/carbon/human, get_turf(bottom_left))
	var/mob/living/carbon/human/subject = allocate(/mob/living/carbon/human, get_step(get_turf(bottom_left), EAST))
	subject.gs13_preferences["blueberry_inflation"] = TRUE
	subject.reagents.add_reagent("blueberry_juice", 30)
	subject.reagents.add_reagent("salglu_solution", 5)
	var/obj/item/reagent_containers/glass/beaker/beaker = allocate(/obj/item/reagent_containers/glass/beaker)
	user.put_in_active_hand(beaker)
	beaker.reagents.add_reagent("water", 45)
	TEST_ASSERT_EQUAL(beaker.collect_gs13_juice_dose(subject, user), 5, "A collected dose is limited by actual free capacity")
	TEST_ASSERT_EQUAL(subject.reagents.get_reagent_amount("blueberry_juice"), 25, "Collection removes exactly the transferred dose")
	TEST_ASSERT_EQUAL(subject.reagents.get_reagent_amount("salglu_solution"), 5, "Collection leaves unrelated medicine in the body")
	TEST_ASSERT_EQUAL(beaker.collect_gs13_juice_dose(subject, user), 0, "A full container cannot drain more juice")
	beaker.reagents.clear_reagents()
	beaker.add_lid()
	TEST_ASSERT_EQUAL(beaker.collect_gs13_juice_dose(subject, user), 0, "A closed lid prevents collection")
	beaker.remove_lid()
	subject.forceMove(locate(bottom_left.x + 4, bottom_left.y, bottom_left.z))
	TEST_ASSERT_EQUAL(beaker.collect_gs13_juice_dose(subject, user), 0, "A moved target cannot be drained remotely")
	subject.forceMove(get_step(get_turf(user), EAST))
	user.drop_item_to_ground(beaker)
	TEST_ASSERT_EQUAL(beaker.collect_gs13_juice_dose(subject, user), 0, "Dropping the container prevents continued collection")

/datum/game_test/room_test/gs13_blueberry_collection_attack_chain/Run()
	var/datum/test_puppeteer/player = new(src)
	var/datum/test_puppeteer/target = player.spawn_puppet_nearby()
	var/mob/living/carbon/human/subject = target.puppet
	subject.gs13_preferences["blueberry_inflation"] = TRUE
	subject.reagents.add_reagent("blueberry_juice", 10)
	var/obj/item/reagent_containers/glass/beaker/beaker = player.spawn_obj_in_hand(/obj/item/reagent_containers/glass/beaker)
	player.puppet.a_intent = INTENT_GRAB
	player.click_on(target)
	TEST_ASSERT_EQUAL(beaker.reagents.get_reagent_amount("blueberry_juice"), 10, "Grab-intent clicking runs timed collection through the native attack chain")
	TEST_ASSERT_NOT(subject.reagents.has_reagent("blueberry_juice"), "The last collection drains the target completely")
	TEST_ASSERT_NULL(subject.color, "The attack-chain treatment also restores the target's color")
	TEST_ASSERT_LAST_CHATLOG(player, "You collect 10 units of juice")

/datum/game_test/room_test/gs13_permaberry_production/Run()
	var/mob/living/carbon/human/subject = allocate(/mob/living/carbon/human)
	subject.gs13_preferences["blueberry_inflation"] = TRUE
	var/datum/quirk/gs13_permaberry/quirk = new
	quirk.apply_quirk_effects(subject)
	STOP_PROCESSING(SSobj, quirk)
	for(var/i in 1 to 5)
		quirk.process(20)
	TEST_ASSERT(subject.reagents.get_reagent_amount("blueberry_juice") >= 0.1, "Fractional source production survives the native minimum dose boundary")
	TEST_ASSERT_EQUAL(quirk.production_seconds, 10, "Native deciseconds convert to the source's production seconds")
	quirk.production_seconds = 20000
	var/before = subject.reagents.get_reagent_amount("blueberry_juice")
	quirk.produce_juice(10)
	TEST_ASSERT(abs(subject.reagents.get_reagent_amount("blueberry_juice") - before - 5) < 0.001, "The accelerated source rate caps at half a unit per second")
	subject.gs13_preferences["blueberry_inflation"] = FALSE
	TEST_ASSERT_EQUAL(quirk.produce_juice(10), 0, "The quirk does not bypass blueberry opt-out")
	qdel(quirk)
	TEST_ASSERT_NOT(quirk in SSobj.processing, "Removing the quirk stops its actual native processing subsystem")

/datum/game_test/room_test/gs13_permaberry_acquisition/Run()
	var/mob/living/carbon/human/subject = allocate(/mob/living/carbon/human)
	subject.gs13_preferences["blueberry_inflation"] = TRUE
	subject.reagents.maximum_volume = 1500
	subject.reagents.add_reagent("blueberry_juice", 1000)
	var/datum/reagent/blueberry_juice/juice = subject.reagents.has_reagent("blueberry_juice")
	juice.on_mob_life(subject)
	var/datum/quirk/gs13_permaberry/quirk = locate() in subject.quirks
	TEST_ASSERT_NOTNULL(quirk, "The source's 999-unit dose acquires Permaberry")
	juice.on_mob_life(subject)
	var/count = 0
	for(var/datum/quirk/gs13_permaberry/existing in subject.quirks)
		count++
	TEST_ASSERT_EQUAL(count, 1, "Repeated large-dose ticks do not duplicate the acquired quirk")
	qdel(quirk)
