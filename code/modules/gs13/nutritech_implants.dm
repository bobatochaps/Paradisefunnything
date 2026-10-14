// GS13 nutritional implants using Paradise's native surgery and organ lifecycle.
/obj/item/organ/internal/cyberimp/chest/nutriment/turbo
	name = "Nutriment pump implant TURBO"
	desc = "An overactive nutriment pump that continues feeding its wearer until they are full."
	hunger_threshold = NUTRITION_LEVEL_FULL
	poison_amount = 10
	send_messages = FALSE
	materials = list(MAT_METAL = 650, MAT_GLASS = 650, MAT_GOLD = 650, MAT_URANIUM = 1000)
	origin_tech = "materials=5;powerstorage=4;biotech=4"

/obj/item/organ/internal/cyberimp/chest/mobility
	name = "Mobility Nanite Core"
	desc = "An implant containing nanites that reinforce leg muscles, preventing slowdown from body fat."
	icon_state = "reviver_implant"
	implant_overlay = null
	slot = "gs13_mobility"
	materials = list(MAT_METAL = 650, MAT_GLASS = 650, MAT_GOLD = 650, MAT_URANIUM = 1000)
	origin_tech = "materials=4;programming=4;biotech=4"

/obj/item/organ/internal/cyberimp/chest/mobility/insert(mob/living/carbon/M, special = FALSE, dont_remove_slot = FALSE)
	. = ..()
	if(owner == M && !QDELETED(M))
		ADD_TRAIT(M, TRAIT_NO_FAT_SLOWDOWN, UID())
		M.handle_weight_gain(0)

/obj/item/organ/internal/cyberimp/chest/mobility/remove(mob/living/carbon/M, special = FALSE)
	var/mob/living/carbon/former_owner = owner
	if(former_owner)
		REMOVE_TRAIT(former_owner, TRAIT_NO_FAT_SLOWDOWN, UID())
	. = ..()
	if(!QDELETED(former_owner))
		former_owner.handle_weight_gain(0)

// Preserve GS13 map/admin spawn paths as aliases of the native internal organs.
/obj/item/organ/cyberimp/chest/nutriment/turbo
	parent_type = /obj/item/organ/internal/cyberimp/chest/nutriment/turbo

/obj/item/organ/cyberimp/chest/mobility
	parent_type = /obj/item/organ/internal/cyberimp/chest/mobility

/datum/design/cyberimp_nutriment_turbo
	name = "Nutriment Pump Implant TURBO"
	id = "ci-nutrimentturbo"
	req_tech = list("materials" = 5, "powerstorage" = 4, "biotech" = 4)
	build_type = PROTOLATHE | MECHFAB
	construction_time = 100
	materials = list(MAT_METAL = 650, MAT_GLASS = 650, MAT_GOLD = 650, MAT_URANIUM = 1000)
	build_path = /obj/item/organ/internal/cyberimp/chest/nutriment/turbo
	category = list("Medical")

/datum/design/cyberimp_fat_mobility
	name = "Mobility Nanite Core"
	id = "ci-fatmobility"
	req_tech = list("materials" = 4, "programming" = 4, "biotech" = 4)
	build_type = PROTOLATHE | MECHFAB
	construction_time = 100
	materials = list(MAT_METAL = 650, MAT_GLASS = 650, MAT_GOLD = 650, MAT_URANIUM = 1000)
	build_path = /obj/item/organ/internal/cyberimp/chest/mobility
	category = list("Medical")
