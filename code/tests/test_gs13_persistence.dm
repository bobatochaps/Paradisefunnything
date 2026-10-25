/datum/game_test/room_test/gs13_clone_policy_snapshot/Run()
	var/mob/living/carbon/human/subject = gs13_fluid_subject()
	var/datum/mind/patient_mind = allocate(/datum/mind)
	patient_mind.transfer_to(subject)
	subject.gs13_character_slot = 3
	subject.gs13_preferences["master_wg_pref"] = TRUE
	subject.gs13_preferences["weight_gain_chems"] = FALSE
	subject.gs13_preferences["weight_gain_rate"] = 1.25
	subject.gs13_preferences["weight_belly_shape"] = "Round"
	subject.gs13_preferences["body_size"] = 2
	subject.set_gs13_body_size(1.5)
	var/obj/machinery/clonescanner/scanner = allocate(/obj/machinery/clonescanner)
	var/datum/cloning_data/scan = scanner.scan(subject)
	subject.gs13_preferences["fluid_production"] = FALSE
	subject.gs13_preferences["weight_belly_shape"] = "Classic"
	var/obj/machinery/clonepod/pod = allocate(/obj/machinery/clonepod)
	pod.patient_data = scan
	pod.desired_data = scan
	pod.create_clone()
	var/mob/living/carbon/human/clone = pod.clone
	allocated += clone
	TEST_ASSERT_EQUAL(clone.gs13_character_slot, 3, "A native clone retains its scan-time character slot for live preference editing")
	TEST_ASSERT(clone.gs13_preferences["fluid_production"], "Cloning restores the scanned production permission without a connected client")
	TEST_ASSERT_EQUAL(clone.gs13_preferences["weight_belly_shape"], "Round", "Cloning uses the independent scan-time body policy")
	TEST_ASSERT_EQUAL(clone.weight_gain_rate, 1.25, "Native weight consumers receive the restored rate")
	TEST_ASSERT_EQUAL(clone.starting_size, 1.5, "Restoring policy does not apply next-spawn size over the actual DNA size")
	TEST_ASSERT_NOT(clone.check_weight_prefs(FATTENING_TYPE_CHEM), "A scan-time chemical opt-out remains effective")
	var/obj/item/organ/internal/gs13_fluid_organ/breasts/breasts = clone.get_organ_slot(GS13_ORGAN_BREASTS)
	TEST_ASSERT(breasts.produce_fluid(5) > 0, "The cloned policy can actually authorize its native fluid organ")
	clone.gs13_preferences["weight_belly_shape"] = "Smooth"
	TEST_ASSERT_EQUAL(scan.gs13_preferences["weight_belly_shape"], "Round", "Live clone edits cannot rewrite the saved scan")
	TEST_ASSERT_EQUAL(subject.gs13_preferences["weight_belly_shape"], "Classic", "The clone cannot alias its source body's policy")

/datum/game_test/room_test/gs13_clone_staged_anatomy/Run()
	var/mob/living/carbon/human/subject = gs13_fluid_subject()
	var/datum/mind/patient_mind = allocate(/datum/mind)
	patient_mind.transfer_to(subject)
	var/obj/item/organ/internal/gs13_fluid_organ/breasts/source_breasts = subject.get_organ_slot(GS13_ORGAN_BREASTS)
	source_breasts.internal_fluid_datum = /datum/reagent/consumable/starshine/blue
	source_breasts.lactates = TRUE
	source_breasts.produce_fluid(5)
	var/obj/machinery/clonescanner/scanner = allocate(/obj/machinery/clonescanner)
	var/datum/cloning_data/scan = scanner.scan(subject)
	var/obj/machinery/clonepod/pod = allocate(/obj/machinery/clonepod)
	pod.patient_data = scan
	pod.desired_data = scan
	pod.currently_cloning = TRUE
	pod.clone_progress = 11
	var/mob/living/carbon/human/clone
	var/limb_was_missing = FALSE
	var/list/birth_organs = list()
	for(var/iteration in 1 to 400)
		pod.process()
		if(!clone && pod.clone)
			clone = pod.clone
			allocated += clone
			for(var/slot in list(GS13_ORGAN_BREASTS, GS13_ORGAN_TESTICLES, GS13_ORGAN_VAGINA))
				birth_organs[slot] = clone.get_organ_slot(slot)
		if(clone && !clone.get_organ(BODY_ZONE_L_ARM))
			limb_was_missing = TRUE
		if(!pod.currently_cloning)
			break
	TEST_ASSERT_NOTNULL(clone, "The real native pod creates the cloned patient")
	TEST_ASSERT(limb_was_missing, "The fixture exercises actual staged limb removal and regrowth")
	TEST_ASSERT_NOT(pod.currently_cloning, "The native pod completes and ejects its patient")
	TEST_ASSERT_EQUAL(patient_mind.current, clone, "The actual ejection transfers the patient's mind")
	for(var/slot in list(GS13_ORGAN_BREASTS, GS13_ORGAN_TESTICLES, GS13_ORGAN_VAGINA))
		var/obj/item/organ/internal/gs13_fluid_organ/organ = clone.get_organ_slot(slot)
		TEST_ASSERT_NOTNULL(organ, "The real growth cycle preserves optional organs in the retained torso")
		TEST_ASSERT_EQUAL(organ, birth_organs[slot], "Ejection preserves each existing physical organ rather than rebuilding it")
		TEST_ASSERT_EQUAL(organ.owner, clone, "The organ belongs to the actual cloned body")
	var/obj/item/organ/internal/gs13_fluid_organ/breasts/breasts = clone.get_organ_slot(GS13_ORGAN_BREASTS)
	TEST_ASSERT_EQUAL(breasts.fluid_id(), "breast_milk", "Cloned birth anatomy does not inherit a physical Neutron alteration")
	TEST_ASSERT_NOT(breasts.lactates, "Physical lactation changes are distinct from birth DNA")
	TEST_ASSERT_EQUAL(breasts.reagents.total_volume, 0, "A new clone does not duplicate an old organ's stored dose")
	TEST_ASSERT_EQUAL(source_breasts.fluid_id(), "starshine_blue", "Cloning leaves the source organ's persistent alteration intact")
	qdel(clone.get_organ_slot(GS13_ORGAN_VAGINA))
	clone.UpdateAppearance()
	TEST_ASSERT_NULL(clone.get_organ_slot(GS13_ORGAN_VAGINA), "Later appearance refreshes cannot regrow a removed organ")

/datum/game_test/room_test/gs13_clone_legacy_policy_and_dna/Run()
	var/mob/living/carbon/human/subject = allocate(/mob/living/carbon/human)
	var/datum/mind/patient_mind = allocate(/datum/mind)
	patient_mind.transfer_to(subject)
	var/obj/machinery/clonescanner/scanner = allocate(/obj/machinery/clonescanner)
	var/datum/cloning_data/scan = scanner.scan(subject)
	scan.gs13_preferences = null
	scan.gs13_character_slot = 0
	var/obj/machinery/clonepod/pod = allocate(/obj/machinery/clonepod)
	pod.patient_data = scan
	pod.desired_data = scan
	pod.create_clone()
	var/mob/living/carbon/human/clone = pod.clone
	allocated += clone
	TEST_ASSERT_NOT(clone.gs13_preferences["master_wg_pref"] || clone.gs13_preferences["fluid_production"], "Older scan data retains compatible disabled defaults")
	TEST_ASSERT_EQUAL(clone.gs13_character_slot, 0, "An old scan cannot invent a character-slot association")
	var/mob/living/carbon/human/source_body = gs13_fluid_subject()
	source_body.dna.transfer_identity(clone)
	TEST_ASSERT_NOTNULL(clone.get_organ_slot(GS13_ORGAN_BREASTS), "Native DNA identity transfer still carries birth anatomy")
	TEST_ASSERT_NOT(clone.gs13_preferences["fluid_production"], "Ordinary DNA changes cannot copy another body's live production permission")
	TEST_ASSERT_EQUAL(clone.gs13_character_slot, 0, "DNA does not silently reassociate a physical body with another saved character")
