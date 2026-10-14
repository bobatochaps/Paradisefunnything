// Adapted from GS13 modular_gs/code/modules/mod/mod_exoskeleton.dm.
/obj/item/mod/construction/plating/exoskeleton
	icon = 'modular_gs/icons/obj/clothing/modsuit/mod_construction.dmi'
	theme = /datum/mod_theme/exoskeleton

/obj/item/mod/construction/plating/exoskeleton/Initialize(mapload)
	. = ..()
	// The source sheet uses a different prefix from its theme name.
	icon_state = "GS13_exo-plating"

/obj/item/mod/armor/exoskeleton
	armor = list(MELEE = 5, BULLET = 5, LASER = 5, ENERGY = 5, BOMB = 0, RAD = 0, FIRE = 5, ACID = 5)

/datum/mod_theme/exoskeleton
	name = "exoskeleton"
	desc = "A GATO-branded mobility exoskeleton."
	extended_desc = "A lightweight support frame designed to assist movement and power itself by burning excess body fat. Its open construction offers little protection and is not suitable for space."
	default_skin = "exoskeleton"
	complexity_max = 5
	armor_type_1 = /obj/item/mod/armor/exoskeleton
	resistance_flags = FIRE_PROOF
	max_heat_protection_temperature = 1
	// Paradise uses zero, rather than TG's -1, to disable cold protection.
	min_cold_protection_temperature = 0
	siemens_coefficient = 1
	slowdown_inactive = 0
	slowdown_active = 0
	inbuilt_modules = list(/obj/item/mod/module/hydraulic_movement, /obj/item/mod/module/calovoltaic, /obj/item/mod/module/storage)
	allowed_suit_storage = list(/obj/item/flashlight, /obj/item/tank/internals)
	skins = list(
		"exoskeleton" = list(
			MOD_ICON_OVERRIDE = 'modular_gs/icons/obj/clothing/modsuit/mod_clothing.dmi',
			MOD_WORN_ICON_OVERRIDE = 'modular_gs/icons/mob/clothing/modsuit/mod_clothing.dmi',
			HELMET_FLAGS = list(UNSEALED_LAYER = NECK_LAYER),
			CHESTPLATE_FLAGS = list(),
			GAUNTLETS_FLAGS = list(),
			BOOTS_FLAGS = list(),
		),
		"invisible" = list(
			MOD_ICON_OVERRIDE = 'modular_gs/icons/obj/clothing/modsuit/mod_clothing.dmi',
			MOD_WORN_ICON_OVERRIDE = 'icons/effects/effects.dmi',
			HELMET_FLAGS = list(UNSEALED_LAYER = NECK_LAYER),
			CHESTPLATE_FLAGS = list(),
			GAUNTLETS_FLAGS = list(),
			BOOTS_FLAGS = list(),
		),
	)

/datum/mod_theme/exoskeleton/on_apply_skin(obj/item/mod/control/control)
	var/list/all_parts = control.mod_parts + control
	for(var/obj/item/part as anything in all_parts)
		// Source supplies a shared humanoid sheet, not Paradise's species variants.
		part.sprite_sheets = list()
		part.worn_icon_state = control.skin == "invisible" ? "nothing" : null
	for(var/obj/item/clothing/part as anything in control.mod_parts)
		part.icon_monitor = null
		part.permeability_coefficient = 1
	control.chestplate.gs13_shows_weight_body = TRUE
	control.chestplate.hide_tail_by_species = list()

/datum/mod_theme/exoskeleton/locked
	inbuilt_modules = list(/obj/item/mod/module/hydraulic_movement/locked, /obj/item/mod/module/calovoltaic/locked, /obj/item/mod/module/storage/locked)

/obj/item/mod/control/pre_equipped/exoskeleton
	desc = "A pre-built GATO mobility exoskeleton that supports heavy bodies and assists weight loss."
	theme = /datum/mod_theme/exoskeleton
	applied_cell = /obj/item/stock_parts/cell/high
	materials = list(MAT_METAL = 20000, MAT_GLASS = 10000, MAT_PLASMA = 5000)

/obj/item/mod/control/pre_equipped/exoskeleton/locked
	name = "MOD control unit (locked)"
	desc = "A pre-built GATO mobility exoskeleton with fixed support, generator, and storage modules."
	theme = /datum/mod_theme/exoskeleton/locked

/obj/item/mod/control/pre_equipped/exoskeleton/wrench_act(mob/living/user, obj/item/wrench)
	if(seconds_electrified && get_charge() && shock(user))
		return TRUE
	if(open)
		to_chat(user, SPAN_WARNING("The exoskeleton's power core cannot be removed."))
		playsound(src, 'sound/machines/scanbuzz.ogg', 25, TRUE, SILENCED_SOUND_EXTRARANGE)
		return TRUE
	return FALSE

/datum/design/mod_shell/exoskeleton
	name = "MOD Exoskeleton"
	desc = "A pre-built GATO assistance exoskeleton with hydraulic support, calovoltaic generation, and storage."
	id = "mod_exoskeleton"
	req_tech = list("engineering" = 3, "materials" = 3, "powerstorage" = 3, "biotech" = 3)
	materials = list(MAT_METAL = 20000, MAT_GLASS = 10000, MAT_PLASMA = 5000)
	build_path = /obj/item/mod/control/pre_equipped/exoskeleton
	construction_time = 10 SECONDS
