/datum/game_test/room_test/gs13_uniform_loadout_registry/Run()
	var/mob/living/carbon/human/subject = allocate(/mob/living/carbon/human)
	subject.gs13_preferences = gs13_default_preferences()
	subject.gs13_preferences["master_wg_pref"] = TRUE
	subject.fatness_real = FATNESS_LEVEL_OBESE
	subject.calculate_fatness()
	var/choices = 0
	for(var/gear_path in subtypesof(/datum/gear/uniform/suit/gs13))
		var/datum/gear/uniform/suit/gs13/gear = GLOB.gear_datums[gear_path]
		TEST_ASSERT_NOTNULL(gear, "Every implemented source department uniform is registered by native character setup")
		var/list/category = GLOB.gear_tgui_info[gear.sort_category]
		var/list/listing = category["[gear_path]"]
		TEST_ASSERT_NOTNULL(listing, "The actual native loadout interface receives each choice")
		TEST_ASSERT_EQUAL(gear.slot, ITEM_SLOT_JUMPSUIT, "Native spawning assigns the correct equipment slot")
		TEST_ASSERT_EQUAL(gear.cost, 1, "The source family uses ordinary native uniform loadout cost")
		var/obj/item/clothing/under/uniform = gear.spawn_item(get_turf(subject), list())
		allocated += uniform
		TEST_ASSERT_NOTNULL(uniform.gs13_modular_icon, "Actual native loadout spawning supplies the implemented adaptive uniform")
		TEST_ASSERT(subject.equip_to_slot_if_possible(uniform, ITEM_SLOT_JUMPSUIT), "The loadout product equips through native inventory")
		TEST_ASSERT("belly_soft_4" in gs13_weight_panel_states(subject), "The normally acquired uniform reaches the real body renderer")
		subject.drop_item_to_ground(uniform)
		if(gear.gs13_department)
			TEST_ASSERT_NOT("Assistant" in gear.allowed_roles, "Departmental choices cannot grant uniform spawning to an unrelated job")
		else
			TEST_ASSERT_NULL(gear.allowed_roles, "The source service variant remains unrestricted")
		choices++
	TEST_ASSERT_EQUAL(choices, 8, "All eight implemented source department variants have native loadout choices")
	var/datum/gear/base_grey = GLOB.gear_datums[/datum/gear/uniform/suit/jumpsuitgrey]
	TEST_ASSERT_EQUAL(base_grey.path, /obj/item/clothing/under/color/grey, "The existing saved native grey-uniform choice remains its acquisition path")
	var/datum/gear/security_blue = GLOB.gear_datums[/datum/gear/uniform/suit/gs13/security/blue]
	TEST_ASSERT("Security Officer" in security_blue.allowed_roles, "The blue security variant inherits the department restriction")
	TEST_ASSERT_NOT("Station Engineer" in security_blue.allowed_roles, "The blue variant cannot bypass that inherited restriction")
	var/datum/gear/command = GLOB.gear_datums[/datum/gear/uniform/suit/gs13/command]
	TEST_ASSERT("Captain" in command.allowed_roles, "Command retains its source head-role acquisition")
	TEST_ASSERT_NOT("Medical Doctor" in command.allowed_roles, "Ordinary department membership cannot grant a command uniform")

/datum/game_test/room_test/gs13_uniform_wardrobe_catalogs/Run()
	var/list/vendors = list(/obj/machinery/economy/vending/clothing, /obj/machinery/economy/vending/secdrobe, /obj/machinery/economy/vending/detdrobe, /obj/machinery/economy/vending/medidrobe, /obj/machinery/economy/vending/virodrobe, /obj/machinery/economy/vending/chemdrobe, /obj/machinery/economy/vending/genedrobe, /obj/machinery/economy/vending/scidrobe, /obj/machinery/economy/vending/robodrobe, /obj/machinery/economy/vending/engidrobe, /obj/machinery/economy/vending/atmosdrobe, /obj/machinery/economy/vending/cargodrobe, /obj/machinery/economy/vending/chefdrobe, /obj/machinery/economy/vending/bardrobe, /obj/machinery/economy/vending/hydrodrobe, /obj/machinery/economy/vending/janidrobe, /obj/machinery/economy/vending/lawdrobe, /obj/machinery/economy/vending/chapdrobe)
	for(var/vendor_path in vendors)
		var/obj/machinery/economy/vending/prototype = vendor_path
		var/list/original = initial(prototype.products)
		var/obj/machinery/economy/vending/vendor = allocate(vendor_path)
		for(var/native_path in original)
			TEST_ASSERT_EQUAL(vendor.products[native_path], original[native_path], "Adding GS13 stock preserves the native wardrobe catalog")
		for(var/uniform_path in vendor.gs13_uniform_stock)
			var/datum/data/vending_product/from_path/found
			for(var/datum/data/vending_product/from_path/record as anything in vendor.product_records)
				if(record.product_path == uniform_path)
					found = record
			TEST_ASSERT_NOTNULL(found, "Every supported source wardrobe builds a real native product record")
			TEST_ASSERT_EQUAL(found.amount, vendor.gs13_uniform_stock[uniform_path], "Native initialization/refills preserve the source three/five-item stock")
			TEST_ASSERT(found.price > 0, "The native economy charges for normally paid uniform stock")
		TEST_ASSERT_EQUAL(length(initial(prototype.products)), length(original), "Constructing a vendor cannot mutate its shared type catalog")

/datum/game_test/room_test/gs13_uniform_vending_and_restock/Run()
	var/obj/machinery/economy/vending/secdrobe/vendor = allocate(/obj/machinery/economy/vending/secdrobe)
	var/obj/machinery/economy/vending/secdrobe/other = allocate(/obj/machinery/economy/vending/secdrobe)
	var/datum/data/vending_product/from_path/uniform_record
	for(var/datum/data/vending_product/from_path/record as anything in vendor.product_records)
		if(record.product_path == /obj/item/clothing/under/color/grey/security)
			uniform_record = record
	TEST_ASSERT_NOTNULL(uniform_record, "The actual SecDrobe stocks the source modular security suit")
	var/obj/item/clothing/under/uniform = uniform_record.vend(get_turf(vendor))
	allocated += uniform
	TEST_ASSERT(istype(uniform, /obj/item/clothing/under/color/grey/security), "Native vending creates the intended adaptive uniform")
	TEST_ASSERT_EQUAL(uniform_record.amount, 2, "A real vend consumes exactly one source-stocked suit")
	var/obj/item/vending_refill/secdrobe/refill = allocate(/obj/item/vending_refill/secdrobe)
	TEST_ASSERT_EQUAL(vendor.restock(refill), 1, "An ordinary native SecDrobe refill restores the missing modular suit")
	TEST_ASSERT_EQUAL(uniform_record.amount, 3, "Restocking returns to the source stock cap")
	for(var/datum/data/vending_product/from_path/record as anything in other.product_records)
		if(record.product_path == /obj/item/clothing/under/color/grey/security)
			TEST_ASSERT_EQUAL(record.amount, 3, "Separate wardrobes never share mutable stock records")
	vendor.update_canister()
	var/obj/item/vending_refill/secdrobe/recovered = locate() in vendor.component_parts
	TEST_ASSERT_EQUAL(recovered.products[/obj/item/clothing/under/color/grey/security], 3, "Native deconstruction retains the actual remaining modular stock")
