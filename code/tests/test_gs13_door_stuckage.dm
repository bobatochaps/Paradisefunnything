/datum/game_test/room_test/gs13_door_stuckage_preferences/Run()
	var/list/loaded = gs13_sanitize_preferences(json_encode(list("stuckage" = 100.5, "stuckage_custom" = 500)))
	TEST_ASSERT_EQUAL(loaded["stuckage"], 100.5, "Door thresholds preserve fractional apparent BFI")
	TEST_ASSERT_EQUAL(loaded["stuckage_custom"], 100, "A saved custom chance is limited to 100 percent")
	loaded = gs13_sanitize_preferences(list("stuckage" = -1, "stuckage_custom" = -5))
	TEST_ASSERT_EQUAL(loaded["stuckage"], 0, "Negative doorway thresholds are disabled")
	TEST_ASSERT_EQUAL(loaded["stuckage_custom"], 0, "Negative chances restore the source default")
	var/mob/living/carbon/human/subject = allocate(/mob/living/carbon/human)
	subject.gs13_preferences["stuckage"] = 100
	subject.adjust_fatness(100, FATTENING_TYPE_ALMIGHTY, TRUE)
	TEST_ASSERT_EQUAL(subject.gs13_door_stuck_chance(), 0, "The source uses a strict threshold")
	subject.adjust_fatness(1, FATTENING_TYPE_ALMIGHTY, TRUE)
	TEST_ASSERT_EQUAL(subject.gs13_door_stuck_chance(), 40, "The ordinary source block chance is 40 percent")
	subject.adjust_fatness(100, FATTENING_TYPE_ALMIGHTY, TRUE)
	TEST_ASSERT_EQUAL(subject.gs13_door_stuck_chance(), 66, "More than twice the threshold raises the source chance to 66 percent")
	subject.gs13_preferences["stuckage_custom"] = 12.5
	TEST_ASSERT_EQUAL(subject.gs13_door_stuck_chance(), 12.5, "A nonzero custom chance replaces both source stages")
	var/datum/quirk/gs13_helplessness_stuckage/quirk = new
	quirk.apply_quirk_effects(subject)
	TEST_ASSERT_EQUAL(subject.gs13_door_stuck_chance(), 0, "Heavy Load uses the source threshold rather than the saved threshold")
	subject.adjust_fatness(FATNESS_LEVEL_EXTREMELY_OBESE, FATTENING_TYPE_ALMIGHTY, TRUE)
	TEST_ASSERT_EQUAL(subject.gs13_door_stuck_chance(), 40, "Heavy Load also restores the source chance")
	qdel(quirk)
	TEST_ASSERT_EQUAL(subject.gs13_door_stuck_chance(), 12.5, "Removing Heavy Load restores the saved custom chance")

/datum/game_test/room_test/gs13_door_stuckage_movement/Run()
	var/turf/origin = get_turf(bottom_left)
	var/turf/destination = get_step(origin, EAST)
	var/obj/machinery/door/airlock/door = allocate(/obj/machinery/door/airlock, origin)
	door.density = FALSE
	door.set_opacity(FALSE)
	var/mob/living/carbon/human/subject = allocate(/mob/living/carbon/human, origin)
	subject.gs13_preferences["stuckage"] = 100
	subject.gs13_preferences["stuckage_custom"] = 100
	subject.adjust_fatness(101, FATTENING_TYPE_ALMIGHTY, TRUE)
	var/before = door.obj_integrity
	TEST_ASSERT_NOT(subject.Move(destination, EAST), "An actual doorway exit is blocked at 100 percent chance")
	TEST_ASSERT_EQUAL(subject.loc, origin, "The blocked mob remains on the doorway turf")
	TEST_ASSERT_EQUAL(door.obj_integrity, before - 1, "A blocked attempt applies one point of native structural damage")
	var/mob/living/carbon/human/bystander = allocate(/mob/living/carbon/human, origin)
	TEST_ASSERT(bystander.Move(destination, EAST), "An opted-out bystander can leave the same doorway")
	TEST_ASSERT_EQUAL(door.obj_integrity, before - 1, "The bystander's exit cannot damage the door")
	subject.gs13_preferences["stuckage"] = 0
	TEST_ASSERT(subject.Move(destination, EAST), "Disabling the threshold releases the mob on its next attempt")
	TEST_ASSERT_EQUAL(door.obj_integrity, before - 1, "A released attempt applies no extra damage")

/datum/game_test/room_test/gs13_door_stuckage_concealment/Run()
	var/turf/origin = get_turf(bottom_left)
	var/turf/destination = get_step(origin, EAST)
	var/obj/structure/mineral_door/door = allocate(/obj/structure/mineral_door, origin)
	door.density = FALSE
	door.state_open = TRUE
	door.set_opacity(FALSE)
	var/mob/living/carbon/human/subject = allocate(/mob/living/carbon/human, origin)
	subject.gs13_preferences["stuckage"] = 100
	subject.gs13_preferences["stuckage_custom"] = 100
	subject.gs13_preferences["muscle_gain"] = TRUE
	subject.adjust_fatness(100, FATTENING_TYPE_ALMIGHTY, TRUE)
	TEST_ASSERT(subject.Move(destination, EAST), "The exact threshold does not catch a mob")
	subject.forceMove(origin)
	subject.adjust_fatness(1, FATTENING_TYPE_ALMIGHTY, TRUE)
	subject.adjust_muscle(1000, TRUE)
	ADD_TRAIT(subject, TRAIT_NO_HELPLESSNESS, "independent")
	TEST_ASSERT_NOT(subject.Move(destination, EAST), "As in GS13, doorway squeezing uses apparent fat independently of muscle and framework immunity")
	var/obj/item/clothing/under/color/grey/uniform = allocate(/obj/item/clothing/under/color/grey)
	var/obj/item/bluespace_belt/belt = allocate(/obj/item/bluespace_belt)
	subject.equip_to_slot_if_possible(uniform, ITEM_SLOT_JUMPSUIT)
	subject.equip_to_slot_if_possible(belt, ITEM_SLOT_BELT)
	TEST_ASSERT(subject.Move(destination, EAST), "Native concealment permits passage")
	subject.forceMove(origin)
	subject.drop_item_to_ground(belt)
	TEST_ASSERT_NOT(subject.Move(destination, EAST), "Removing concealment restores doorway squeezing immediately")

/datum/game_test/room_test/gs13_door_stuckage_location_cleanup/Run()
	var/turf/origin = get_turf(bottom_left)
	var/turf/moved_turf = get_step(origin, NORTH)
	var/obj/structure/mineral_door/door = allocate(/obj/structure/mineral_door, origin)
	door.density = FALSE
	door.state_open = TRUE
	var/datum/component/gs13_door_stuckage/controller = door.GetComponent(/datum/component/gs13_door_stuckage)
	TEST_ASSERT_NOTNULL(controller, "Native mineral-door initialization installs the listener")
	TEST_ASSERT_EQUAL(door.AddComponent(/datum/component/gs13_door_stuckage), controller, "Duplicate installation reuses the existing component")
	var/mob/living/carbon/human/subject = allocate(/mob/living/carbon/human, origin)
	subject.gs13_preferences["stuckage"] = 100
	subject.gs13_preferences["stuckage_custom"] = 100
	subject.adjust_fatness(101, FATTENING_TYPE_ALMIGHTY, TRUE)
	door.forceMove(moved_turf)
	TEST_ASSERT(subject.Move(get_step(origin, EAST), EAST), "Moving a door removes the old turf listener")
	subject.forceMove(moved_turf)
	TEST_ASSERT_NOT(subject.Move(get_step(moved_turf, EAST), EAST), "The moved door listens on its new turf")
	var/obj/structure/closet/container = allocate(/obj/structure/closet, moved_turf)
	door.forceMove(container)
	TEST_ASSERT_NULL(controller.listening_turf, "A contained door cannot listen through its container")
	TEST_ASSERT(subject.Move(get_step(moved_turf, EAST), EAST), "Putting a door in a container releases its former turf")
	door.forceMove(moved_turf)
	subject.forceMove(moved_turf)
	TEST_ASSERT_NOT(subject.Move(get_step(moved_turf, EAST), EAST), "Returning the door to a turf reinstalls its listener")
	qdel(controller)
	TEST_ASSERT(subject.Move(get_step(moved_turf, EAST), EAST), "Component deletion removes the listener")
	controller = door.AddComponent(/datum/component/gs13_door_stuckage)
	qdel(door)
	TEST_ASSERT(QDELETED(controller), "Door deletion also deletes its component")
	TEST_ASSERT_NULL(controller.listening_turf, "Door deletion releases the retained turf reference")

/datum/game_test/room_test/gs13_door_stuckage_border_and_closed/Run()
	var/turf/origin = get_turf(bottom_left)
	var/obj/machinery/door/window/door = allocate(/obj/machinery/door/window, origin)
	door.setDir(NORTH)
	door.density = FALSE
	var/mob/living/carbon/human/subject = allocate(/mob/living/carbon/human, origin)
	subject.gs13_preferences["stuckage"] = 100
	subject.gs13_preferences["stuckage_custom"] = 100
	subject.adjust_fatness(101, FATTENING_TYPE_ALMIGHTY, TRUE)
	var/before = door.obj_integrity
	TEST_ASSERT(subject.Move(get_step(origin, EAST), EAST), "Walking alongside a border door does not cross its frame")
	TEST_ASSERT_EQUAL(door.obj_integrity, before, "Walking alongside a border door causes no structural damage")
	subject.forceMove(origin)
	TEST_ASSERT_NOT(subject.Move(get_step(origin, NORTH), NORTH), "Crossing the open border door's actual edge can catch the mob")
	door.density = TRUE
	before = door.obj_integrity
	var/datum/component/gs13_door_stuckage/controller = door.GetComponent(/datum/component/gs13_door_stuckage)
	TEST_ASSERT_NOT(controller.on_attempt_exit(origin, subject, NORTH), "A closed door leaves blocking to native access and collision handling")
	TEST_ASSERT_EQUAL(door.obj_integrity, before, "A closed-door collision is not treated as a squeezing attempt")

/datum/game_test/room_test/gs13_door_stuckage_destruction/Run()
	var/turf/origin = get_turf(bottom_left)
	var/obj/structure/mineral_door/door = allocate(/obj/structure/mineral_door, origin)
	door.density = FALSE
	door.state_open = TRUE
	var/mob/living/carbon/human/subject = allocate(/mob/living/carbon/human, origin)
	subject.gs13_preferences["stuckage"] = 100
	subject.gs13_preferences["stuckage_custom"] = 100
	subject.adjust_fatness(101, FATTENING_TYPE_ALMIGHTY, TRUE)
	door.resistance_flags |= INDESTRUCTIBLE
	var/before = door.obj_integrity
	TEST_ASSERT_NOT(subject.Move(get_step(origin, EAST), EAST), "An indestructible frame can still catch a mob")
	TEST_ASSERT_EQUAL(door.obj_integrity, before, "Squeezing respects native indestructibility")
	door.resistance_flags &= ~INDESTRUCTIBLE
	door.obj_integrity = 1
	TEST_ASSERT_NOT(subject.Move(get_step(origin, EAST), EAST), "The final blocked attempt can destroy a weakened frame")
	TEST_ASSERT(QDELETED(door), "Native damage destroys the weakened door")
	TEST_ASSERT(subject.Move(get_step(origin, EAST), EAST), "A destroyed door cannot leave a permanent exit blocker")
