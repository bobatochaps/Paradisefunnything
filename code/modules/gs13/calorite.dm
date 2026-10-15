// GS13 calorite adapted to Paradise ore, material, research, and chemistry systems.
/datum/material/calorite
	name = "Calorite"
	id = MAT_CALORITE
	sheet_type = /obj/item/stack/sheet/mineral/calorite
	ore_type = /obj/item/stack/ore/calorite

/datum/ore/calorite
	drop_type = /obj/item/stack/ore/calorite
	spread_chance = 5
	scan_icon = 'modular_gs/icons/effects/ore_visuals.dmi'
	scan_icon_state = "rock_Calorite"
	scan_pixel_offset = 0

/turf/simulated/mineral/calorite
	preset_ore_type = /datum/ore/calorite

/turf/simulated/mineral/volcanic/calorite
	preset_ore_type = /datum/ore/calorite

/obj/item/stack/ore/calorite
	name = "calorite ore"
	singular_name = "calorite ore chunk"
	icon = 'modular_gs/icons/obj/mining.dmi'
	icon_state = "calorite_ore"
	inhand_icon_state = "gold_ore"
	points = 40
	materials = list(MAT_CALORITE = MINERAL_MATERIAL_AMOUNT)
	refined_type = /obj/item/stack/sheet/mineral/calorite
	merge_type = /obj/item/stack/ore/calorite

/obj/item/stack/sheet/mineral/calorite
	name = "calorite"
	desc = "A soft orange metal whose touch affects body mass. Wear gloves when handling it."
	icon = 'modular_gs/icons/obj/stack_objects.dmi'
	icon_state = "sheet-calorite"
	inhand_icon_state = "sheet-gold"
	singular_name = "calorite sheet"
	sheettype = "calorite"
	materials = list(MAT_CALORITE = MINERAL_MATERIAL_AMOUNT)
	merge_type = /obj/item/stack/sheet/mineral/calorite
	origin_tech = "materials=4;biotech=3"
	point_value = 40
	damtype = FAT
	wall_allowed = TRUE

/obj/item/stack/sheet/mineral/calorite/Initialize(mapload, new_amount, merge)
	. = ..()
	AddComponent(/datum/component/fattening, 2, FATTENING_TYPE_ITEM)
	recipes = GLOB.calorite_recipes

/obj/item/stack/sheet/mineral/calorite/five
	amount = 5

/obj/item/stack/sheet/mineral/calorite/ten
	amount = 10

/obj/item/stack/sheet/mineral/calorite/fifty
	amount = 50

/datum/design/calorite
	name = "Calorite"
	id = "calorite"
	build_type = AUTOLATHE
	materials = list(MAT_CALORITE = MINERAL_MATERIAL_AMOUNT)
	build_path = /obj/item/stack/sheet/mineral/calorite
	category = list("initial", "Construction")
	maxstack = MAX_STACK_SIZE

/// Apply after native armor checks; permanent-disabled targets receive ordinary weight.
/mob/living/carbon/proc/apply_gs13_weight_damage(amount, damage_type, armor = 0)
	if((status_flags & GODMODE) || !isnum(amount) || !GS13_IS_FINITE(amount) || amount <= 0 || armor == INFINITY)
		return FALSE
	var/effective_damage = ARMOUR_EQUATION(amount, armor, 1)
	if(!GS13_IS_FINITE(effective_damage) || effective_damage <= 0)
		return FALSE
	if(!check_weight_prefs(FATTENING_TYPE_WEAPON))
		adjustStaminaLoss(effective_damage)
	else if(damage_type == PERMA_FAT && check_weight_prefs(FATTENING_TYPE_WEAPON, TRUE))
		adjust_perma(effective_damage * PERMA_FAT_DAMAGE_TO_FATNESS, FATTENING_TYPE_WEAPON)
	else
		adjust_fatness(effective_damage * FAT_DAMAGE_TO_FATNESS, FATTENING_TYPE_WEAPON)
	return TRUE

/mob/living/carbon/proc/adjust_calorite_poisoning(amount)
	if(!gs13_weight_enabled() || !gs13_preferences["severe_fatness_penalty"] || !isnum(amount) || !GS13_IS_FINITE(amount))
		return FALSE
	var/before = micro_calorite_poisoning
	micro_calorite_poisoning = clamp(micro_calorite_poisoning + amount, 0, 100)
	return micro_calorite_poisoning != before

/mob/living/carbon/proc/handle_calorite_poisoning(seconds = 2)
	micro_calorite_poisoning = clamp(micro_calorite_poisoning, 0, 100)
	if(!gs13_weight_enabled() || !gs13_preferences["severe_fatness_penalty"] || micro_calorite_poisoning < 0.1)
		remove_weight_gain_modifier("calorite_poisoning")
		remove_weight_loss_modifier("calorite_poisoning")
		return
	var/severity = micro_calorite_poisoning / 100
	set_weight_gain_modifier("calorite_poisoning", severity)
	set_weight_loss_modifier("calorite_poisoning", -severity)
	if(severity > 0.8)
		gs13_movement_delay += 0.6
	if(seconds <= 0 || stat == DEAD)
		return
	adjust_calorite_poisoning(-0.0001 * seconds)
	adjust_hunger(severity * seconds)
	if(severity > 0.9)
		adjust_fatness(3 * (severity - 0.9) * seconds, FATTENING_TYPE_MAGIC)
	if(severity > 0.97)
		adjust_perma(seconds, FATTENING_TYPE_MAGIC, TRUE)

/datum/reagent/micro_calorite
	name = "Micro Calorite"
	id = "micro_calorite"
	description = "Tiny particles of calorite that alter metabolism and increase hunger. Prolonged exposure can accumulate in the body."
	color = "#EB6E00"
	taste_description = "sugar"
	metabolization_rate = 0.02 // GS13's 0.01 per second, on Paradise's two-second cycle.
	overdose_threshold = 100
	allowed_overdose_process = TRUE
	process_flags = ORGANIC | SYNTHETIC

/datum/reagent/micro_calorite/proc/update_weight_modifiers(mob/living/subject)
	if(!iscarbon(subject))
		return FALSE
	var/mob/living/carbon/carbon = subject
	if(!carbon.check_weight_prefs(FATTENING_TYPE_CHEM))
		carbon.remove_weight_gain_modifier("micro_calorite")
		carbon.remove_weight_loss_modifier("micro_calorite")
		return FALSE
	var/multiplier = overdosed ? 0.6 : 0.3
	carbon.set_weight_gain_modifier("micro_calorite", multiplier)
	carbon.set_weight_loss_modifier("micro_calorite", -multiplier)
	return TRUE

/datum/reagent/micro_calorite/on_mob_add(mob/living/subject)
	..()
	update_weight_modifiers(subject)

/datum/reagent/micro_calorite/on_mob_life(mob/living/subject)
	if(update_weight_modifiers(subject))
		var/mob/living/carbon/carbon = subject
		carbon.adjust_hunger(10)
		carbon.adjust_calorite_poisoning(20 / 3600)
	return ..()

/datum/reagent/micro_calorite/on_mob_delete(mob/living/subject)
	..()
	if(iscarbon(subject))
		var/mob/living/carbon/carbon = subject
		carbon.remove_weight_gain_modifier("micro_calorite")
		carbon.remove_weight_loss_modifier("micro_calorite")

/datum/reagent/micro_calorite/overdose_start(mob/living/subject)
	update_weight_modifiers(subject)

/datum/reagent/micro_calorite/overdose_end(mob/living/subject)
	update_weight_modifiers(subject)

/datum/reagent/micro_calorite/overdose_process(mob/living/subject, severity)
	if(iscarbon(subject))
		var/mob/living/carbon/carbon = subject
		carbon.adjust_fatness(2, FATTENING_TYPE_CHEM)
	return list(0, STATUS_UPDATE_NONE)

/obj/projectile/beam/fattening/on_hit(atom/target, blocked = 0, hit_zone)
	. = ..()
	if(!iscarbon(target) || blocked == INFINITY)
		return
	var/mob/living/carbon/carbon = target
	if((carbon.status_flags & GODMODE) || !carbon.check_weight_prefs(FATTENING_TYPE_WEAPON, TRUE) || carbon.micro_calorite_poisoning < 1)
		return
	var/absorbed_energy = ARMOUR_EQUATION(fat_added, blocked, 1)
	if(carbon.adjust_calorite_poisoning(-0.01 * absorbed_energy))
		carbon.adjust_perma(absorbed_energy, FATTENING_TYPE_WEAPON, TRUE)

// Paradise technology levels replace the TG techweb unlock prerequisites.
/datum/design/fatoray_weak
	name = "Basic Fatoray"
	id = "fatoray_weak"
	req_tech = list("combat" = 4, "materials" = 4, "biotech" = 4)
	build_type = PROTOLATHE
	materials = list(MAT_METAL = 800, MAT_GLASS = 600, MAT_CALORITE = 1000)
	build_path = /obj/item/gun/energy/fatoray/weak
	category = list("Weapons")

/datum/design/fatoray_cannon_weak
	name = "Basic Cannonshot Fatoray"
	id = "fatoray_cannon_weak"
	req_tech = list("combat" = 5, "materials" = 4, "biotech" = 4)
	build_type = PROTOLATHE
	materials = list(MAT_METAL = 1000, MAT_GLASS = 800, MAT_CALORITE = 2000)
	build_path = /obj/item/gun/energy/fatoray/cannon/weak
	category = list("Weapons")

/datum/design/alter_ray_metabolism
	name = "AL-T-Ray: Metabolism"
	id = "alter_ray_metabolism"
	req_tech = list("combat" = 4, "materials" = 5, "biotech" = 5)
	build_type = PROTOLATHE
	materials = list(MAT_METAL = 1000, MAT_GLASS = 800, MAT_CALORITE = 2600)
	build_path = /obj/item/gun/energy/laser/alter_ray/gainrate
	category = list("Weapons")

/datum/design/alter_ray_reverser
	name = "AL-T-Ray: Reverser"
	id = "alter_ray_reverser"
	req_tech = list("combat" = 4, "materials" = 5, "biotech" = 5)
	build_type = PROTOLATHE
	materials = list(MAT_METAL = 1000, MAT_GLASS = 800, MAT_CALORITE = 2600)
	build_path = /obj/item/gun/energy/laser/alter_ray/noloss
	category = list("Weapons")
