/mob/living
	var/gs13_test_oral_exposure = 0

/datum/game_test/room_test/proc/gs13_ingested_reagents(mob/living/subject)
	var/atom/target = subject.get_gs13_ingestion_target()
	return target?.reagents

/datum/reagent/gs13_ingestion_probe
	name = "GS13 ingestion test reagent"
	id = "gs13_ingestion_probe"
	metabolization_rate = 0.2

/datum/reagent/gs13_ingestion_probe/reaction_mob(mob/living/subject, method, volume)
	if(method == REAGENT_INGEST)
		subject.gs13_test_oral_exposure += volume

/datum/game_test/room_test/gs13_digestion_routing_and_data/Run()
	var/mob/living/carbon/human/subject = allocate(/mob/living/carbon/human)
	var/obj/item/organ/internal/gs13_stomach/stomach = subject.get_organ_slot(GS13_ORGAN_STOMACH)
	var/obj/item/reagent_containers/glass/beaker/supply = allocate(/obj/item/reagent_containers/glass/beaker)
	supply.reagents.add_reagent("gs13_ingestion_probe", 20, list("tag" = 42))
	TEST_ASSERT_EQUAL(supply.reagents.gs13_ingest(subject, 10), 10, "Explicit oral transfer accepts the actual dose into the physical stomach")
	TEST_ASSERT_EQUAL(stomach.reagents.get_reagent_amount("gs13_ingestion_probe"), 10, "The swallowed dose starts in its own compartment")
	TEST_ASSERT_NOT(subject.reagents.has_reagent("gs13_ingestion_probe"), "Swallowing does not inject a dose directly into the blood")
	TEST_ASSERT_EQUAL(subject.gs13_test_oral_exposure, 10, "Native oral exposure applies only to the swallowed dose")
	TEST_ASSERT(abs(stomach.digest_gs13_reagents(2) - 1.5) < 0.001, "Native drip uses the source volume factor and minimum rate converted to seconds")
	TEST_ASSERT(abs(subject.reagents.get_reagent_amount("gs13_ingestion_probe") - 1.5) < 0.001, "Only the digested fraction reaches body chemistry")
	var/datum/reagent/received = subject.reagents.has_reagent("gs13_ingestion_probe")
	TEST_ASSERT_EQUAL(received.data["tag"], 42, "Drip transfer preserves source reagent data")
	TEST_ASSERT_EQUAL(subject.gs13_test_oral_exposure, 10, "Absorption does not apply immediate oral exposure twice")

/datum/game_test/room_test/gs13_digestion_dose_exposure/Run()
	var/mob/living/carbon/human/subject = allocate(/mob/living/carbon/human)
	var/obj/item/organ/internal/gs13_stomach/stomach = subject.get_organ_slot(GS13_ORGAN_STOMACH)
	stomach.reagents.maximum_volume = 7
	var/obj/item/reagent_containers/glass/beaker/supply = allocate(/obj/item/reagent_containers/glass/beaker)
	supply.reagents.add_reagent("gs13_ingestion_probe", 20)
	TEST_ASSERT_EQUAL(supply.reagents.gs13_ingest(subject, 50), 7, "Oral intake is bounded by actual stomach capacity")
	TEST_ASSERT_EQUAL(subject.gs13_test_oral_exposure, 7, "Immediate effects use the accepted dose rather than the whole offered solution")
	TEST_ASSERT_EQUAL(supply.reagents.total_volume, 13, "Undelivered supply stays available")
	TEST_ASSERT_EQUAL(supply.reagents.gs13_ingest(subject, 5), 0, "A full stomach refuses further intake")
	TEST_ASSERT_EQUAL(subject.gs13_test_oral_exposure, 7, "Refusal cannot trigger additional oral effects")

/datum/game_test/room_test/gs13_digestion_blood_capacity/Run()
	var/mob/living/carbon/human/subject = allocate(/mob/living/carbon/human)
	var/obj/item/organ/internal/gs13_stomach/stomach = subject.get_organ_slot(GS13_ORGAN_STOMACH)
	stomach.reagents.add_reagent("gs13_ingestion_probe", 10)
	subject.reagents.add_reagent("water", subject.reagents.maximum_volume)
	TEST_ASSERT_EQUAL(stomach.digest_gs13_reagents(2), 0, "A full blood holder cannot destroy queued stomach contents")
	TEST_ASSERT_EQUAL(stomach.reagents.total_volume, 10, "Backpressure preserves all undigested fluid")
	subject.reagents.remove_reagent("water", 5)
	TEST_ASSERT_EQUAL(stomach.digest_gs13_reagents(100), 5, "Even a long processing request is bounded by free blood volume")
	TEST_ASSERT_EQUAL(stomach.reagents.total_volume, 5, "The remainder stays in the actual organ")

/datum/game_test/room_test/gs13_digestion_missing_and_injection/Run()
	var/mob/living/carbon/human/subject = allocate(/mob/living/carbon/human)
	qdel(subject.get_organ_slot(GS13_ORGAN_STOMACH))
	var/obj/item/reagent_containers/glass/beaker/supply = allocate(/obj/item/reagent_containers/glass/beaker)
	supply.reagents.add_reagent("gs13_ingestion_probe", 10)
	TEST_ASSERT_NULL(subject.get_gs13_ingestion_target(), "A required but surgically absent stomach cannot fall back to injection")
	TEST_ASSERT_EQUAL(supply.reagents.gs13_ingest(subject, 5), 0, "Oral intake refuses a missing digestive organ")
	TEST_ASSERT_EQUAL(subject.gs13_test_oral_exposure, 0, "Rejected intake cannot apply oral effects")
	supply.reagents.trans_to(subject, 3)
	TEST_ASSERT_EQUAL(subject.reagents.get_reagent_amount("gs13_ingestion_probe"), 3, "Existing direct injection transfers remain in the body holder")

/datum/game_test/room_test/gs13_digestion_native_fallback/Run()
	var/mob/living/carbon/human/subject = allocate(/mob/living/carbon/human)
	subject.set_species(/datum/species/machine)
	TEST_ASSERT_EQUAL(subject.get_gs13_ingestion_target(), subject, "A native species without the adapted digestive layout retains its existing route")
	var/obj/item/reagent_containers/glass/beaker/supply = allocate(/obj/item/reagent_containers/glass/beaker)
	supply.reagents.add_reagent("water", 10)
	TEST_ASSERT_EQUAL(supply.reagents.gs13_ingest(subject, 5), 5, "Fallback bodies can still use native oral entry points")
	TEST_ASSERT_EQUAL(subject.reagents.get_reagent_amount("water"), 5, "The adapter does not invent a synthetic stomach")

/datum/game_test/room_test/gs13_digestion_fullness
	var/list/samples = list()

/datum/game_test/room_test/gs13_digestion_fullness/proc/on_blood_changed(mob/living/carbon/source)
	SIGNAL_HANDLER
	samples += source.get_fullness()

/datum/game_test/room_test/gs13_digestion_fullness/Run()
	var/mob/living/carbon/human/subject = allocate(/mob/living/carbon/human)
	var/obj/item/organ/internal/gs13_stomach/stomach = subject.get_organ_slot(GS13_ORGAN_STOMACH)
	subject.nutrition = 100
	subject.metabolism_efficiency = 1
	subject.reagents.add_reagent("nutriment", 4)
	stomach.reagents.add_reagent("nutriment", 10)
	var/before = subject.get_fullness()
	TEST_ASSERT_EQUAL(before, 310, "Fullness counts distinct nutritional potential in both holders")
	RegisterSignal(subject, COMSIG_GS13_REAGENTS_CHANGED, PROC_REF(on_blood_changed))
	stomach.digest_gs13_reagents(2)
	UnregisterSignal(subject, COMSIG_GS13_REAGENTS_CHANGED)
	TEST_ASSERT(abs(subject.get_fullness() - before) < 0.001, "Moving food from stomach to blood cannot invent or discard fullness")
	TEST_ASSERT(length(samples), "The test observes actual native transfer callbacks")
	for(var/sample in samples)
		TEST_ASSERT(abs(sample - before) < 0.001, "Native add-before-remove callbacks cannot temporarily count a dose in both compartments")

/datum/game_test/room_test/gs13_digestion_organ_lifecycle/Run()
	var/mob/living/carbon/human/donor = allocate(/mob/living/carbon/human)
	var/mob/living/carbon/human/recipient = allocate(/mob/living/carbon/human)
	var/obj/item/organ/internal/gs13_stomach/stomach = donor.get_organ_slot(GS13_ORGAN_STOMACH)
	stomach.reagents.add_reagent("gs13_ingestion_probe", 10)
	donor.death()
	TEST_ASSERT_EQUAL(stomach.digest_gs13_reagents(2), 0, "A corpse retains its queued meal without metabolizing it")
	donor.update_revive()
	stomach.remove(donor)
	stomach.forceMove(get_turf(donor))
	TEST_ASSERT_EQUAL(stomach.digest_gs13_reagents(2), 0, "An extracted stomach cannot feed its former owner")
	var/obj/item/organ/internal/gs13_stomach/replaced = recipient.get_organ_slot(GS13_ORGAN_STOMACH)
	stomach.insert(recipient)
	replaced.forceMove(get_turf(recipient))
	TEST_ASSERT(stomach.digest_gs13_reagents(2) > 0, "A native transplant resumes absorption into the new owner")
	TEST_ASSERT_NOT(donor.reagents.has_reagent("gs13_ingestion_probe"), "The former owner receives none of the transplanted meal")
	TEST_ASSERT(recipient.reagents.has_reagent("gs13_ingestion_probe"), "The receiving physical body gets the existing meal")
	var/datum/reagents/holder = stomach.reagents
	qdel(stomach)
	TEST_ASSERT(QDELETED(holder), "Deleting the actual organ releases its food holder")

/datum/game_test/room_test/gs13_digestion_inert_and_invalid/Run()
	var/mob/living/carbon/human/subject = allocate(/mob/living/carbon/human)
	var/obj/item/organ/internal/gs13_stomach/stomach = subject.get_organ_slot(GS13_ORGAN_STOMACH)
	stomach.reagents.add_reagent("gs13_ingestion_probe", 10)
	var/datum/reagent/probe = stomach.reagents.has_reagent("gs13_ingestion_probe")
	probe.metabolization_rate = 0
	TEST_ASSERT_EQUAL(stomach.digest_gs13_reagents(2), 0, "Source nonmetabolizing material remains in the stomach")
	TEST_ASSERT_EQUAL(stomach.digest_gs13_reagents(INFINITY), 0, "Invalid processing times cannot drain the holder")
	TEST_ASSERT_EQUAL(stomach.digest_gs13_reagents(-1), 0, "Negative processing time cannot manufacture a dose")
	TEST_ASSERT_EQUAL(stomach.reagents.total_volume, 10, "Invalid or inert processing preserves physical contents")

/datum/game_test/room_test/gs13_digestion_safe_burst_cleanup/Run()
	var/mob/living/carbon/human/subject = gs13_burst_subject(GS13_BURST_GLUTTON)
	var/obj/item/organ/internal/gs13_stomach/stomach = subject.get_organ_slot(GS13_ORGAN_STOMACH)
	stomach.reagents.add_reagent("water", 10)
	subject.reagents.add_reagent("water", 10)
	var/datum/component/gs13_bursting/controller = subject.GetComponent(/datum/component/gs13_bursting)
	var/token = gs13_confirm_glutton(controller)
	controller.finish_preparation(token)
	TEST_ASSERT(controller.complete_burst(token), "The source recovery resolves with actual stomach contents")
	TEST_ASSERT_EQUAL(subject.reagents.total_volume, 0, "Glutton recovery clears blood through ordinary reagent deletion")
	TEST_ASSERT_EQUAL(stomach.reagents.total_volume, 0, "Glutton recovery also clears pending food without leaving a refilling dose")
