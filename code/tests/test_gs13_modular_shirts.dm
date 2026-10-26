/datum/game_test/room_test/proc/gs13_clothing_panel_pixel(mob/living/carbon/human/subject, state, x, y, direction = SOUTH)
	for(var/mutable_appearance/part as anything in subject.overlays_standing[GS13_WEIGHT_BODY_LAYER])
		if(part.icon_state == state)
			var/icon/panel = icon(part.icon, part.icon_state, direction)
			return panel.GetPixel(x, y)

/datum/game_test/room_test/gs13_modular_shirt_loadout/Run()
	for(var/gear_path in subtypesof(/datum/gear/uniform/suit/gs13_shirt))
		var/datum/gear/gear = GLOB.gear_datums[gear_path]
		TEST_ASSERT_NOTNULL(gear, "Both source shirt families appear in native character setup")
		TEST_ASSERT_EQUAL(gear.cost, 1, "The shirts retain ordinary uniform loadout cost")
		var/list/metadata = list()
		var/list/keys = list()
		var/list/colors = list("#3366cc", "#224466", "#eebb22")
		for(var/datum/gear_tweak/gs13_uniform_color/tweak in gear.gear_tweaks)
			keys |= "[tweak]"
			metadata["[tweak]"] = colors[tweak.channel]
		TEST_ASSERT_EQUAL(length(keys), 3, "All three color channels have distinct persistent native metadata")
		var/obj/item/clothing/under/gs13_dual_tone/button_up/uniform = gear.spawn_item(get_turf(bottom_left), json_decode(json_encode(metadata)))
		LAZYADD(allocated, uniform)
		TEST_ASSERT_EQUAL(length(uniform.gs13_uniform_colors), 3, "Actual native spawning builds the three-channel source family")
		TEST_ASSERT_EQUAL(uniform.gs13_uniform_colors[3], "#eebb22", "Trim metadata survives character JSON and real gear spawning")
		var/icon/item_icon = icon(uniform.icon, uniform.icon_state)
		TEST_ASSERT_EQUAL(copytext(item_icon.GetPixel(12, 21), 1, 8), "#3366cc", "The actual source shirt mask receives primary fabric color")
		TEST_ASSERT_EQUAL(copytext(item_icon.GetPixel(13, 10), 1, 8), "#224466", "The original trouser mask retains its independent secondary color")
		TEST_ASSERT_EQUAL(copytext(item_icon.GetPixel(16, 12), 1, 8), "#eebb22", "The original trim mask receives the third actual color")
		var/list/saved = uniform.serialize()
		var/obj/item/clothing/under/gs13_dual_tone/button_up/restored = json_to_object(json_encode(saved), get_turf(bottom_left))
		LAZYADD(allocated, restored)
		TEST_ASSERT_EQUAL(json_encode(restored.gs13_uniform_colors), json_encode(uniform.gs13_uniform_colors), "Actual native item JSON restoration retains all three colors")
		restored.set_gs13_uniform_color(3, "#112233")
		TEST_ASSERT_EQUAL(uniform.gs13_uniform_colors[3], "#eebb22", "A restored suit cannot mutate the source item's palette")
		TEST_ASSERT_EQUAL(saved["gs13_uniform_colors"][3], "#eebb22", "A later third-channel edit preserves the serialized snapshot")
		TEST_ASSERT_NOT(restored.set_gs13_uniform_color(4, "#ffffff"), "The skin mask is not a user-controlled clothing color channel")

/datum/game_test/room_test/gs13_modular_shirt_cutout_colors/Run()
	for(var/uniform_path in list(/obj/item/clothing/under/gs13_dual_tone/button_up, /obj/item/clothing/under/gs13_dual_tone/button_up/turtleneck))
		var/mob/living/carbon/human/subject = allocate(/mob/living/carbon/human)
		subject.gs13_preferences = gs13_sanitize_preferences(list("master_wg_pref" = TRUE, "weight_belly_base" = 5, "weight_belly_custom_color" = TRUE, "weight_belly_color" = "#ff0000"))
		subject.fatness_real = FATNESS_LEVEL_OBESE
		subject.calculate_fatness()
		var/obj/item/clothing/under/gs13_dual_tone/button_up/uniform = allocate(uniform_path)
		subject.equip_to_slot_if_possible(uniform, ITEM_SLOT_JUMPSUIT)
		var/is_turtleneck = istype(uniform, /obj/item/clothing/under/gs13_dual_tone/button_up/turtleneck)
		var/x = is_turtleneck ? 5 : 16
		var/y = is_turtleneck ? 16 : 5
		var/skin = gs13_clothing_panel_pixel(subject, "belly_soft_9_SOUTH-4", x, y)
		TEST_ASSERT_NOTNULL(skin, "The source cutout supplies real visible native skin pixels")
		TEST_ASSERT(color2R(skin) > 0 && color2G(skin) == 0 && color2B(skin) == 0, "The source cutout follows the actual belly override instead of garment fabric")
		subject.gs13_preferences["weight_belly_color"] = "#00ff00"
		subject.update_gs13_weight_appearance(TRUE)
		skin = gs13_clothing_panel_pixel(subject, "belly_soft_9_SOUTH-4", x, y)
		TEST_ASSERT(color2G(skin) > 0 && color2R(skin) == 0 && color2B(skin) == 0, "A live part-color edit invalidates skin masks independently of unchanged clothing colors")
		subject.gs13_preferences["weight_belly_custom_color"] = FALSE
		ADD_TRAIT(subject, TRAIT_HULK, "gs13-shirt-test")
		subject.update_gs13_weight_appearance(TRUE)
		skin = gs13_clothing_panel_pixel(subject, "belly_soft_9_SOUTH-4", x, y)
		TEST_ASSERT(color2G(skin) > color2R(skin) && color2R(skin) > 0, "Disabling override follows current native Hulk skin rather than stale body or garment color")
		REMOVE_TRAIT(subject, TRAIT_HULK, "gs13-shirt-test")
		var/obj/item/organ/external/chest = subject.get_organ(BODY_ZONE_CHEST)
		chest.status |= ORGAN_ROBOT
		subject.update_gs13_weight_appearance(TRUE)
		TEST_ASSERT_NOT("belly_soft_9_SOUTH-4" in gs13_weight_panel_states(subject), "An organic cutout cannot paint flesh over a prosthetic chest")

/datum/game_test/room_test/gs13_modular_shirt_appearance/Run()
	for(var/uniform_path in list(/obj/item/clothing/under/gs13_dual_tone/button_up, /obj/item/clothing/under/gs13_dual_tone/button_up/turtleneck))
		var/mob/living/carbon/human/subject = gs13_fluid_subject()
		subject.gs13_preferences["master_wg_pref"] = TRUE
		subject.gs13_preferences["anatomy_body_sprites"] = TRUE
		subject.fatness_real = FATNESS_LEVEL_OBESE
		subject.calculate_fatness()
		var/obj/item/clothing/under/gs13_dual_tone/button_up/uniform = allocate(uniform_path)
		uniform.set_gs13_uniform_color(1, "#3366cc")
		uniform.set_gs13_uniform_color(2, "#224466")
		uniform.set_gs13_uniform_color(3, "#eebb22")
		subject.equip_to_slot_if_possible(uniform, ITEM_SLOT_JUMPSUIT)
		var/is_turtleneck = istype(uniform, /obj/item/clothing/under/gs13_dual_tone/button_up/turtleneck)
		var/label = is_turtleneck ? "turtleneck" : "button_up"
		var/list/states = gs13_weight_panel_states(subject)
		TEST_ASSERT("belly_soft_4-1" in states, "The actual weighted body receives the matching source shirt layer")
		TEST_ASSERT("butt_4-2" in states, "Source trouser masks use the hip size and their own palette channel")
		var/breast_state = is_turtleneck ? "breasts-6-1" : "breasts_6-1"
		TEST_ASSERT(breast_state in states, "The native adapter resolves the original family's actual breast state names")
		gs13_render_weight_preview(subject, "shirt_[label]_4")
		subject.gs13_preferences["weight_belly_base"] = 5
		subject.gs13_preferences["weight_belly_custom_color"] = TRUE
		subject.gs13_preferences["weight_belly_color"] = "#aa6633"
		subject.update_gs13_shape_dna(subject.gs13_preferences)
		subject.update_gs13_weight_appearance(TRUE)
		gs13_render_weight_preview(subject, "shirt_[label]_cutout_9")
		for(var/mutable_appearance/part as anything in subject.overlays_standing[GS13_WEIGHT_BODY_LAYER])
			TEST_ASSERT(icon_exists(part.icon, part.icon_state), "Every native selected clothing/skin mask exists in its actual icon")
		TEST_ASSERT_NOT(uniform.roll_undersuit(subject), "These original source sheets safely refuse absent rolled artwork")
		subject.drop_item_to_ground(uniform)
		TEST_ASSERT_NOT(breast_state in gs13_weight_panel_states(subject), "Native removal clears every source shirt mask")
		TEST_ASSERT("m_breasts_pair_gs_smooth_6_FRONT" in gs13_weight_panel_states(subject), "Removal exposes the same existing anatomy")
		var/list/saved_palette = uniform.gs13_uniform_colors.Copy()
		subject.equip_to_slot_if_possible(uniform, ITEM_SLOT_JUMPSUIT)
		subject.death()
		subject.revive()
		TEST_ASSERT_EQUAL(json_encode(uniform.gs13_uniform_colors), json_encode(saved_palette), "Native death/revival preserve the actual suit's palette")
		subject.set_species(/datum/species/skrell)
		TEST_ASSERT_NULL(subject.overlays_standing[GS13_WEIGHT_BODY_LAYER], "Unsupported body shapes clear the owned modular layers")

// A real native catalog without GS13 merging provides the independent control.
/obj/machinery/economy/vending/clothing/gs13_catalog_control/add_gs13_uniform_stock()
	return

/datum/game_test/room_test/gs13_modular_shirt_acquisition/Run()
	var/obj/machinery/economy/vending/clothing/gs13_catalog_control/control = allocate(/obj/machinery/economy/vending/clothing/gs13_catalog_control)
	var/obj/machinery/economy/vending/clothing/vendor = allocate(/obj/machinery/economy/vending/clothing)
	TEST_ASSERT(length(control.product_records) > 0, "The independent native catalog is actually populated")
	for(var/datum/data/vending_product/from_path/baseline as anything in control.product_records)
		var/datum/data/vending_product/from_path/found
		for(var/datum/data/vending_product/from_path/record as anything in vendor.product_records)
			if(record.product_path == baseline.product_path)
				found = record
		TEST_ASSERT_NOTNULL(found, "Adding clothing families preserves every real native ClothesMate product")
		TEST_ASSERT_EQUAL(found.amount, baseline.amount, "Source acquisition cannot alter existing ordinary native stock")
		TEST_ASSERT_EQUAL(found.price, baseline.price, "Source acquisition cannot change existing ordinary native prices")
	var/datum/data/vending_product/from_path/product
	for(var/datum/data/vending_product/from_path/record as anything in vendor.product_records)
		if(record.product_path == /obj/item/clothing/under/gs13_dual_tone/button_up/turtleneck)
			product = record
	TEST_ASSERT_NOTNULL(product, "The source turtleneck has a normal native vending path")
	var/obj/item/clothing/under/gs13_dual_tone/button_up/turtleneck/suit = product.vend(get_turf(bottom_left))
	LAZYADD(allocated, suit)
	TEST_ASSERT(istype(suit), "Actual native vending supplies the new source shirt family")
	TEST_ASSERT_EQUAL(length(suit.gs13_uniform_colors), 3, "Vending builds all three source palette channels")
	TEST_ASSERT_EQUAL(product.amount, 4, "Vending decrements the source five-item stock")
	var/obj/item/vending_refill/refill = allocate(vendor.refill_canister)
	TEST_ASSERT_EQUAL(vendor.restock(refill), 1, "An ordinary native refill restores the additional shirt")
	TEST_ASSERT_EQUAL(product.amount, 5, "Refill retains the source stock cap")
	var/list/department_vendors = list(/obj/machinery/economy/vending/medidrobe, /obj/machinery/economy/vending/cargodrobe, /obj/machinery/economy/vending/scidrobe, /obj/machinery/economy/vending/bardrobe, /obj/machinery/economy/vending/chefdrobe, /obj/machinery/economy/vending/lawdrobe, /obj/machinery/economy/vending/chapdrobe, /obj/machinery/economy/vending/detdrobe)
	for(var/vendor_path in department_vendors)
		var/obj/machinery/economy/vending/department = allocate(vendor_path)
		var/shirts = 0
		for(var/datum/data/vending_product/from_path/record as anything in department.product_records)
			if(ispath(record.product_path, /obj/item/clothing/under/gs13_dual_tone/button_up))
				TEST_ASSERT_EQUAL(record.amount, 3, "The source department wardrobe stocks three of each mapped shirt")
				TEST_ASSERT(record.price > 0, "The native economy charges ordinary uniform prices")
				shirts++
		TEST_ASSERT(shirts >= 2, "Every mapped department acquires both source shirt families")
