// Adapted from GS13 modular_gs/code/modules/mod/modules/modules_fat.dm.
// Source power is scaled to Paradise cell units, as with the other GS13 tools.
#define GS13_CALOVOLTAIC_CHARGE_PER_BFI 2.5

/obj/item/mod/module/hydraulic_movement
	name = "MOD hydraulic movement assistance module"
	desc = "A GATO-designed system of hydraulic pistons that supports excess body weight for easier movement."
	icon = 'modular_gs/icons/obj/clothing/modsuit/mod_modules.dmi'
	icon_state = "hydraulic_mod"
	complexity = 1
	incompatible_modules = list(/obj/item/mod/module/hydraulic_movement)
	// Source: 5 joules/second. Paradise SSobj processes once every two seconds.
	idle_power_cost = 1
	materials = list(MAT_METAL = 5000, MAT_GLASS = 1000)
	var/amount = -2
	var/mob/living/carbon/human/supported_wearer

/obj/item/mod/module/hydraulic_movement/locked
	name = "MOD hydraulic movement assistance module (locked)"
	removable = FALSE

/obj/item/mod/module/hydraulic_movement/Destroy()
	clear_support()
	return ..()

/obj/item/mod/module/hydraulic_movement/on_suit_activation()
	. = ..()
	update_support()

/obj/item/mod/module/hydraulic_movement/on_suit_deactivation(deleting = FALSE)
	clear_support()
	return ..()

/obj/item/mod/module/hydraulic_movement/on_equip()
	. = ..()
	update_support()

/obj/item/mod/module/hydraulic_movement/on_unequip()
	clear_support()
	return ..()

/obj/item/mod/module/hydraulic_movement/on_uninstall(deleting = FALSE)
	clear_support()
	return ..()

/obj/item/mod/module/hydraulic_movement/on_process()
	if(!can_support() || !drain_power(idle_power_cost))
		clear_support()
		return FALSE
	update_support()
	return TRUE

/obj/item/mod/module/hydraulic_movement/proc/can_support()
	return !QDELETED(mod) && mod.active && !QDELETED(mod.wearer) && mod.wearer.back == mod && mod.loc == mod.wearer && mod.check_charge(idle_power_cost)

/obj/item/mod/module/hydraulic_movement/proc/update_support()
	if(!can_support())
		clear_support()
		return
	if(supported_wearer != mod.wearer)
		clear_support()
		supported_wearer = mod.wearer
		RegisterSignal(supported_wearer, COMSIG_PARENT_QDELETING, PROC_REF(on_wearer_deletion))
	supported_wearer.add_fat_delay_modifier(UID(), amount)
	ADD_TRAIT(supported_wearer, TRAIT_NO_HELPLESSNESS, UID())
	supported_wearer.handle_weight_gain(0)

/obj/item/mod/module/hydraulic_movement/proc/clear_support()
	if(!supported_wearer)
		return
	var/mob/living/carbon/human/former_wearer = supported_wearer
	supported_wearer = null
	UnregisterSignal(former_wearer, COMSIG_PARENT_QDELETING)
	former_wearer.remove_fat_delay_modifier(UID())
	REMOVE_TRAIT(former_wearer, TRAIT_NO_HELPLESSNESS, UID())
	if(!QDELETED(former_wearer))
		former_wearer.handle_weight_gain(0)

/obj/item/mod/module/hydraulic_movement/proc/on_wearer_deletion()
	SIGNAL_HANDLER
	clear_support()

/obj/item/mod/module/storage/locked
	name = "MOD storage containment module (locked)"
	removable = FALSE

/obj/item/mod/module/calovoltaic
	name = "MOD calovoltaic generator module"
	desc = "A GATO-designed generator that burns excess body fat to charge the suit's power core."
	icon = 'modular_gs/icons/obj/clothing/modsuit/mod_modules.dmi'
	icon_state = "calovoltaic_mod"
	module_type = MODULE_TOGGLE
	complexity = 1
	incompatible_modules = list(/obj/item/mod/module/calovoltaic)
	materials = list(MAT_METAL = 5000, MAT_GLASS = 5000, MAT_PLASMA = 5000)
	/// Requested ordinary weight loss per second, before the wearer's multiplier.
	var/rate = 10

/obj/item/mod/module/calovoltaic/locked
	name = "MOD calovoltaic generator module (locked)"
	removable = FALSE

// Native MOD processing does not pass a duration; SSobj's interval is two seconds.
/obj/item/mod/module/calovoltaic/on_active_process(seconds_per_tick = 2)
	if(!active || QDELETED(mod) || !mod.active || QDELETED(mod.wearer))
		return
	var/mob/living/carbon/human/wearer = mod.wearer
	if(wearer.back != mod || mod.loc != wearer || wearer.status_flags & GODMODE || wearer.fatness_real <= 0)
		return
	if(!isnum(seconds_per_tick) || !GS13_IS_FINITE(seconds_per_tick) || seconds_per_tick <= 0 || !isnum(rate) || !GS13_IS_FINITE(rate) || rate <= 0)
		return
	var/charge = mod.get_charge()
	var/capacity = mod.get_max_charge()
	var/obj/charge_source = mod.get_charge_source()
	if(QDELETED(charge_source) || !GS13_IS_FINITE(charge) || !GS13_IS_FINITE(capacity) || capacity <= charge)
		return
	var/loss_rate = wearer.get_weight_loss_rate()
	if(!GS13_IS_FINITE(loss_rate))
		return
	var/requested_loss = rate * seconds_per_tick
	if(loss_rate > 0)
		requested_loss = min(requested_loss, (capacity - charge) / (GS13_CALOVOLTAIC_CHARGE_PER_BFI * loss_rate))
	var/burned_fat = -wearer.adjust_fatness(-requested_loss, FATTENING_TYPE_WEIGHT_LOSS)
	// Inverted loss may add weight, as in GS13, but cannot consume or create charge.
	if(burned_fat > 0)
		mod.add_charge(burned_fat * GS13_CALOVOLTAIC_CHARGE_PER_BFI)
		mod.update_charge_alert()

/datum/design/module/hydraulic_movement
	name = "Hydraulic Assistance Module"
	desc = "A GATO-designed module that supports heavier bodies for easier movement."
	id = "mod_hydraulic"
	req_tech = list("engineering" = 3, "materials" = 3)
	materials = list(MAT_METAL = 5000, MAT_GLASS = 1000)
	build_path = /obj/item/mod/module/hydraulic_movement

/datum/design/module/calovoltaic
	name = "Calovoltaic Generator Module"
	desc = "A GATO-designed module that burns ordinary body fat to recharge its suit."
	id = "mod_calovoltaic"
	req_tech = list("engineering" = 3, "powerstorage" = 3, "biotech" = 3)
	materials = list(MAT_METAL = 5000, MAT_GLASS = 5000, MAT_PLASMA = 5000)
	build_path = /obj/item/mod/module/calovoltaic

#undef GS13_CALOVOLTAIC_CHARGE_PER_BFI
