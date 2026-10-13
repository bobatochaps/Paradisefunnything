// Adapted from GS13's WG13 port. Original concept/backbone: M16nPregnant.
#define CALORAY_MODE_FATTEN "fatten"
#define CALORAY_MODE_THIN "thin"
// Match the other GS13 guns' conversion from TG to Paradise cell charge.
#define CALORAY_CHARGE_PER_WEIGHT 25

/obj/item/gun/medbeam/caloray
	name = "Caloray"
	desc = "A miniaturised adipoelectric generator and transformer. It converts energy into fat, and vice versa, at range. Use it in hand to change mode; a wrench opens its battery compartment."
	icon = 'modular_gs/icons/obj/weapons/caloray.dmi'
	icon_state = "caloray"
	materials = list(MAT_METAL = 1000, MAT_GLASS = 800, MAT_CALORITE = 1600)
	origin_tech = "powerstorage=3;materials=4;biotech=4"
	var/mode = CALORAY_MODE_FATTEN
	var/beam_color = "#eb6e00"
	var/beam_icon_state = "white_beam_reverse"
	var/opened = FALSE
	var/intensity = 50
	var/power_use = 10
	var/obj/item/stock_parts/cell/cell
	var/cell_type

/obj/item/gun/medbeam/caloray/Initialize(mapload)
	. = ..()
	STOP_PROCESSING(SSobj, src)
	if(cell_type)
		set_cell(new cell_type(src))
	RegisterSignal(src, COMSIG_MOVABLE_MOVED, PROC_REF(on_gun_moved))
	update_icon(UPDATE_OVERLAYS)

/obj/item/gun/medbeam/caloray/Destroy()
	LoseTarget()
	var/obj/item/stock_parts/cell/old_cell = cell
	set_cell(null)
	QDEL_NULL(old_cell)
	return ..()

/obj/item/gun/medbeam/caloray/get_cell()
	return cell

/obj/item/gun/medbeam/caloray/examine(mob/user)
	. = ..()
	. += SPAN_NOTICE("It is set to [mode] at [intensity]% intensity.")
	if(cell)
		. += SPAN_NOTICE("Its power cell is [round(cell.percent(), 0.1)]% charged.")
	else
		. += SPAN_NOTICE("It has no power cell installed.")
	if(opened)
		. += SPAN_NOTICE("Its battery compartment is open. Activate it in hand to remove the cell.")

/obj/item/gun/medbeam/caloray/update_overlays()
	. = ..()
	. += "caloray_[mode]"
	if(!cell || cell.percent() <= 20)
		. += "caloray_empty"
	else if(cell.percent() <= 80)
		. += "caloray_recharge"
	else
		. += "caloray_on"
	. += active ? "caloray_handle_on" : "caloray_handle_off"
	if(active)
		. += "caloray_activated"

/obj/item/gun/medbeam/caloray/proc/set_cell(obj/item/stock_parts/cell/new_cell)
	LoseTarget()
	if(cell)
		UnregisterSignal(cell, list(COMSIG_MOVABLE_MOVED, COMSIG_PARENT_QDELETING))
	cell = new_cell
	if(cell)
		RegisterSignal(cell, list(COMSIG_MOVABLE_MOVED, COMSIG_PARENT_QDELETING), PROC_REF(on_cell_changed))
	update_icon(UPDATE_OVERLAYS)

/obj/item/gun/medbeam/caloray/proc/on_cell_changed(datum/source)
	SIGNAL_HANDLER
	if(QDELETED(cell) || cell.loc != src)
		set_cell(null)

/obj/item/gun/medbeam/caloray/proc/on_gun_moved(datum/source)
	SIGNAL_HANDLER
	LoseTarget()

/obj/item/gun/medbeam/caloray/proc/can_operate(mob/living/user)
	return istype(user) && !QDELETED(user) && !user.incapacitated() && !HAS_TRAIT(user, TRAIT_HANDS_BLOCKED) && user.IsAdvancedToolUser() && (loc == user || isturf(loc)) && user.Adjacent(src)

/obj/item/gun/medbeam/caloray/attack_self__legacy__attackchain(mob/living/user)
	if(!can_operate(user) || loc != user)
		return
	LoseTarget()
	if(opened)
		if(!cell)
			to_chat(user, SPAN_WARNING("There is no cell installed."))
			return
		var/obj/item/stock_parts/cell/old_cell = cell
		set_cell(null)
		old_cell.update_icon(UPDATE_OVERLAYS)
		old_cell.forceMove(get_turf(user))
		user.put_in_hands(old_cell)
		to_chat(user, SPAN_NOTICE("You remove [old_cell] from [src]."))
		return
	if(mode == CALORAY_MODE_FATTEN)
		mode = CALORAY_MODE_THIN
		beam_color = "#3b0ce7"
		beam_icon_state = "white_beam"
	else
		mode = CALORAY_MODE_FATTEN
		beam_color = "#eb6e00"
		beam_icon_state = "white_beam_reverse"
	playsound(src, 'sound/weapons/empty.ogg', 60, TRUE)
	to_chat(user, SPAN_NOTICE("You set [src] to [mode]."))
	update_icon(UPDATE_OVERLAYS)

/obj/item/gun/medbeam/caloray/wrench_act(mob/living/user, obj/item/tool)
	if(!can_operate(user))
		return TRUE
	opened = !opened
	LoseTarget()
	tool.play_tool_sound(src)
	to_chat(user, SPAN_NOTICE("You [opened ? "open" : "close"] [src]'s battery compartment."))
	return TRUE

/obj/item/gun/medbeam/caloray/attackby__legacy__attackchain(obj/item/used, mob/living/user, params)
	if(!istype(used, /obj/item/stock_parts/cell))
		return ..()
	if(!can_operate(user) || !opened || cell || used.loc != user || (user.get_active_hand() != used && user.get_inactive_hand() != used))
		return
	if(user.transfer_item_to(used, src))
		set_cell(used)
		to_chat(user, SPAN_NOTICE("You insert [used] into [src]."))

/obj/item/gun/medbeam/caloray/can_shoot()
	if(opened || QDELETED(cell) || cell.loc != src || intensity <= 0)
		return FALSE
	return mode == CALORAY_MODE_FATTEN ? cell.charge > 0 : cell.charge < cell.maxcharge

/// Native medbeams permit cyborgs and mech mounts as well as handheld use.
/obj/item/gun/medbeam/caloray/proc/valid_holder()
	if(mounted)
		return istype(loc, /obj/mecha) && isturf(loc.loc)
	var/mob/living/user = loc
	return (ishuman(user) || isrobot(user)) && !user.incapacitated() && !HAS_TRAIT(user, TRAIT_HANDS_BLOCKED) && (user.get_active_hand() == src || user.get_inactive_hand() == src)

/obj/item/gun/medbeam/caloray/process_fire(atom/target, mob/living/user, message = TRUE, params, zone_override, bonus_spread = 0)
	LoseTarget()
	if(!iscarbon(target) || !can_shoot() || !valid_holder())
		return FALSE
	if(!mounted && (user != loc || !can_trigger_gun(user)))
		return FALSE
	var/mob/living/carbon/carbon = target
	if((carbon.status_flags & GODMODE) || !isturf(carbon.loc) || !carbon.check_weight_prefs(FATTENING_TYPE_ITEM) || get_dist(loc, target) > max_range || loc.z != target.z)
		return FALSE
	if(isliving(user))
		add_fingerprint(user)
	current_target = carbon
	active = TRUE
	var/datum/beam/current_beam = loc.Beam(carbon, beam_icon_state, 'modular_gs/icons/effects/beam.dmi', time = 10 MINUTES, maxdistance = max_range, beam_type = /obj/effect/ebeam/caloray, beam_color = beam_color)
	beam_UID = current_beam.UID()
	RegisterSignal(current_beam, COMSIG_PARENT_QDELETING, PROC_REF(on_beam_lost))
	RegisterSignal(carbon, COMSIG_PARENT_QDELETING, PROC_REF(on_beam_lost))
	if(!los_check(loc, carbon))
		LoseTarget()
		return FALSE
	START_PROCESSING(SSobj, src)
	update_icon(UPDATE_OVERLAYS)
	SSblackbox.record_feedback("tally", "gun_fired", 1, type)
	return TRUE

/obj/item/gun/medbeam/caloray/proc/on_beam_lost(datum/source)
	SIGNAL_HANDLER
	LoseTarget()

/obj/item/gun/medbeam/caloray/LoseTarget()
	var/datum/beam/current_beam = locateUID(beam_UID)
	if(current_beam)
		UnregisterSignal(current_beam, COMSIG_PARENT_QDELETING)
	// The native parent unconditionally qdels its beam. A beam's QDELETING
	// callback must clear the UID first to avoid re-entering its Destroy().
	if(QDELETED(current_beam))
		beam_UID = null
	if(current_target)
		UnregisterSignal(current_target, COMSIG_PARENT_QDELETING)
	. = ..()
	STOP_PROCESSING(SSobj, src)
	update_icon(UPDATE_OVERLAYS)

/obj/item/gun/medbeam/caloray/process()
	if(!can_shoot() || !valid_holder())
		LoseTarget()
		return
	return ..()

/obj/item/gun/medbeam/caloray/on_beam_tick(mob/living/user, mob/living/carbon/target)
	if(!istype(target) || QDELETED(target) || (target.status_flags & GODMODE) || !target.check_weight_prefs(FATTENING_TYPE_ITEM) || !can_shoot())
		LoseTarget()
		return
	if(mode == CALORAY_MODE_FATTEN)
		var/energy_used = min(cell.charge, power_use * intensity)
		// Paradise use() returns success, not the amount consumed. Infinite cells
		// also succeed without changing charge, so a before/after delta is wrong.
		if(energy_used <= 0 || !cell.use(energy_used))
			LoseTarget()
			return
		target.adjust_fatness(energy_used / CALORAY_CHARGE_PER_WEIGHT, FATTENING_TYPE_ITEM)
	else
		var/burn_request = min(target.fatness_real, intensity)
		var/loss_rate = target.get_weight_loss_rate()
		if(loss_rate > 0)
			burn_request = min(burn_request, (cell.maxcharge - cell.charge) / (CALORAY_CHARGE_PER_WEIGHT * loss_rate))
		if(burn_request <= 0)
			LoseTarget()
			return
		var/actual_burn = -target.adjust_fatness(-burn_request, FATTENING_TYPE_ITEM)
		if(actual_burn > 0)
			cell.give(actual_burn * CALORAY_CHARGE_PER_WEIGHT)
		else
			// Zero/inverted loss rates cannot generate free electricity.
			LoseTarget()
	if(!can_shoot())
		LoseTarget()
	update_icon(UPDATE_OVERLAYS)

// Unlike medical nanites, this beam is safe to cross with another beam.
/obj/item/gun/medbeam/caloray/check_beam_crossing(turf/tile, datum/beam/current_beam)
	return TRUE

/obj/effect/ebeam/caloray
	name = "caloray beam"

/obj/item/gun/medbeam/caloray/empty_cell
	cell_type = /obj/item/stock_parts/cell/high/empty

/obj/item/gun/medbeam/caloray/charged
	cell_type = /obj/item/stock_parts/cell/high

/obj/item/gun/medbeam/caloray/infinite_cell
	name = "infinite capacity caloray"
	cell_type = /obj/item/stock_parts/cell/infinite

/obj/item/gun/medbeam/caloray/bluespace_cell
	name = "bluespace cell caloray"
	cell_type = /obj/item/stock_parts/cell/bluespace

/obj/item/gun/medbeam/caloray/mech
	mounted = TRUE

/datum/design/caloray
	name = "Caloray"
	id = "caloray"
	req_tech = list("powerstorage" = 3, "materials" = 4, "biotech" = 4)
	build_type = PROTOLATHE
	materials = list(MAT_METAL = 1000, MAT_GLASS = 800, MAT_CALORITE = 1600)
	build_path = /obj/item/gun/medbeam/caloray
	category = list("Weapons")

#undef CALORAY_MODE_FATTEN
#undef CALORAY_MODE_THIN
#undef CALORAY_CHARGE_PER_WEIGHT
