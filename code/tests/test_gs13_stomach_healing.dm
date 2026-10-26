/datum/game_test/room_test/gs13_stomach_healing_rate/Run()
	var/mob/living/carbon/human/subject = allocate(/mob/living/carbon/human)
	var/obj/item/organ/internal/gs13_stomach/stomach = subject.get_organ_slot(GS13_ORGAN_STOMACH)
	stomach.receive_damage(30, TRUE)
	subject.satiety = 0
	TEST_ASSERT(abs(stomach.heal_gs13_tissue(2) - 0.1) < 0.001, "Native two-second processing applies the exact pinned source baseline repair rate")
	TEST_ASSERT(abs(stomach.damage - 29.9) < 0.001, "Source repair changes the actual physical organ damage")
	subject.satiety = GS13_MAX_SATIETY
	TEST_ASSERT(abs(stomach.heal_gs13_tissue(2) - 0.5) < 0.001, "Native maximum satiety supplies the source fivefold total repair")
	subject.satiety = -GS13_MAX_SATIETY
	TEST_ASSERT(abs(stomach.heal_gs13_tissue(2) - 0.1) < 0.001, "Negative satiety cannot turn baseline repair into damage")
	subject.satiety = GS13_MAX_SATIETY * 2
	TEST_ASSERT(abs(stomach.heal_gs13_tissue(2) - 0.5) < 0.001, "Quality overshoot is bounded to the source full-satiety bonus")
	var/before = stomach.damage
	for(var/bad_time in list(0, -1, INFINITY))
		TEST_ASSERT_EQUAL(stomach.heal_gs13_tissue(bad_time), 0, "Invalid processing durations cannot alter organ tissue")
	TEST_ASSERT_EQUAL(stomach.damage, before, "Invalid timing preserves actual injury")
	stomach.max_damage = 200
	subject.satiety = 0
	TEST_ASSERT(abs(stomach.heal_gs13_tissue(2) - 0.2) < 0.001, "The inherited rate scales with actual maximum organ health")

/datum/game_test/room_test/gs13_stomach_healing_lifecycle/Run()
	var/mob/living/carbon/human/donor = allocate(/mob/living/carbon/human)
	var/mob/living/carbon/human/recipient = allocate(/mob/living/carbon/human)
	var/obj/item/organ/internal/gs13_stomach/stomach = donor.get_organ_slot(GS13_ORGAN_STOMACH)
	donor.satiety = 0
	stomach.receive_damage(30, TRUE)
	stomach.on_life()
	TEST_ASSERT(abs(stomach.damage - 29.9) < 0.001, "The actual native organ life callback performs baseline tissue recovery")
	donor.death()
	var/before = stomach.damage
	stomach.on_life()
	TEST_ASSERT_EQUAL(stomach.damage, before, "A corpse cannot passively repair the retained stomach")
	stomach.remove(donor)
	stomach.forceMove(get_turf(donor))
	TEST_ASSERT_EQUAL(stomach.heal_gs13_tissue(2), 0, "An extracted organ cannot borrow its former owner's recovery")
	var/obj/item/organ/internal/gs13_stomach/replaced = recipient.get_organ_slot(GS13_ORGAN_STOMACH)
	stomach.insert(recipient)
	replaced.forceMove(get_turf(recipient))
	recipient.satiety = GS13_MAX_SATIETY
	TEST_ASSERT(abs(stomach.heal_gs13_tissue(2) - 0.5) < 0.001, "A real native transplant uses its new owner's food quality")
	TEST_ASSERT_EQUAL(stomach.owner, recipient, "Recovery never changes the native organ's physical ownership")
	qdel(stomach)
	TEST_ASSERT_NULL(recipient.get_organ_slot(GS13_ORGAN_STOMACH), "Native deletion still releases the stomach's actual slot")

/datum/game_test/room_test/gs13_stomach_healing_failures/Run()
	var/mob/living/carbon/human/subject = allocate(/mob/living/carbon/human)
	var/obj/item/organ/internal/gs13_stomach/stomach = subject.get_organ_slot(GS13_ORGAN_STOMACH)
	subject.satiety = GS13_MAX_SATIETY
	stomach.receive_damage(0.1, TRUE)
	stomach.heal_gs13_tissue(2)
	TEST_ASSERT_EQUAL(stomach.damage, 0, "Recovery clamps at healthy tissue without negative injury")
	stomach.receive_damage(stomach.max_damage, TRUE)
	TEST_ASSERT(stomach.status & ORGAN_DEAD, "The fixture exercises actual native organ destruction")
	TEST_ASSERT_EQUAL(stomach.heal_gs13_tissue(2), 0, "Source passive healing cannot revive necrotic tissue")
	TEST_ASSERT_EQUAL(stomach.damage, stomach.max_damage, "A destroyed stomach still requires actual native treatment or replacement")
	stomach.rejuvenate()
	stomach.receive_damage(10, TRUE)
	TEST_ASSERT(stomach.heal_gs13_tissue(2) > 0, "Actual native rejuvenation restores normal organic recovery")
	stomach.robotize()
	var/before = stomach.damage
	TEST_ASSERT_EQUAL(stomach.heal_gs13_tissue(2), 0, "A native robotic organ cannot repair itself through organic tissue healing")
	TEST_ASSERT_EQUAL(stomach.damage, before, "Synthetic injury remains available to native repair systems")
