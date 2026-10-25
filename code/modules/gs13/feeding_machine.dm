// The native IV stand only supports blood bags. Keep the source spawn path while
// using an independent controller for general containers and oral feeding.
/obj/machinery/iv_drip/feeding_tube
	parent_type = /obj/machinery
	name = "feeding tube"
	desc = "An automatic nutrient feeder with a removable portable blender. Drag it onto a recipient to connect the tube."
	icon = 'modular_gs/icons/obj/feeding_tube.dmi'
	icon_state = "feeding_tube_injectidle"
	mouse_drag_pointer = MOUSE_ACTIVE_POINTER
	power_state = NO_POWER_USE
	interact_offline = TRUE
	anchored = FALSE
	var/obj/item/portable_blender/our_blender
	var/obj/item/reagent_containers/reagent_container
	var/default_blender_path = /obj/item/portable_blender
	var/mob/living/carbon/connected_target
	var/transfer_rate = 5

/obj/machinery/iv_drip/feeding_tube/Initialize(mapload)
	. = ..()
	STOP_PROCESSING(SSmachines, src)
	RegisterSignal(src, COMSIG_MOVABLE_MOVED, PROC_REF(on_connection_moved))
	if(ispath(default_blender_path))
		new default_blender_path(src)

/obj/machinery/iv_drip/feeding_tube/Destroy()
	var/obj/item/removed = release_container(FALSE)
	QDEL_NULL(removed)
	UnregisterSignal(src, COMSIG_MOVABLE_MOVED)
	return ..()

/obj/machinery/iv_drip/feeding_tube/proc/can_operate(mob/user)
	return isliving(user) && !QDELETED(user) && !user.incapacitated() && !HAS_TRAIT(user, TRAIT_HANDS_BLOCKED) && user.IsAdvancedToolUser() && user.Adjacent(src) && isturf(loc) && is_operational()

/obj/machinery/iv_drip/feeding_tube/proc/insert_blender(obj/item/portable_blender/blender)
	if(!istype(blender) || QDELETED(blender) || blender.loc != src || our_blender || reagent_container || !blender.loaded_reagent_container)
		return FALSE
	our_blender = blender
	reagent_container = blender.loaded_reagent_container
	RegisterSignal(blender, list(COMSIG_MOVABLE_MOVED, COMSIG_PARENT_QDELETING), PROC_REF(on_container_lost))
	RegisterSignal(blender, COMSIG_GS13_BLENDER_CONTAINER_CHANGED, PROC_REF(on_blender_changed))
	update_icon()
	return TRUE

/obj/machinery/iv_drip/feeding_tube/proc/on_blender_changed(datum/source)
	SIGNAL_HANDLER
	if(reagent_container != our_blender.loaded_reagent_container)
		detach_iv()
		reagent_container = our_blender.loaded_reagent_container
	update_icon()
	SStgui.update_uis(src)

/obj/machinery/iv_drip/feeding_tube/proc/on_container_lost(atom/movable/source)
	SIGNAL_HANDLER
	if(QDELETED(source) || source.loc != src)
		release_container(FALSE)

/// Clear references and disconnect before moving or deleting the container.
/obj/machinery/iv_drip/feeding_tube/proc/release_container(move_to_floor = TRUE)
	detach_iv()
	var/obj/item/removed = our_blender ? our_blender : reagent_container
	if(our_blender)
		UnregisterSignal(our_blender, list(COMSIG_MOVABLE_MOVED, COMSIG_PARENT_QDELETING, COMSIG_GS13_BLENDER_CONTAINER_CHANGED))
	else if(reagent_container)
		UnregisterSignal(reagent_container, list(COMSIG_MOVABLE_MOVED, COMSIG_PARENT_QDELETING))
	our_blender = null
	reagent_container = null
	if(move_to_floor && !QDELETED(removed))
		removed.forceMove(get_turf(src))
	update_icon()
	SStgui.update_uis(src)
	return removed

/obj/machinery/iv_drip/feeding_tube/proc/eject_beaker(mob/user)
	if(!can_operate(user))
		return FALSE
	return release_container()

/obj/machinery/iv_drip/feeding_tube/item_interaction(mob/living/user, obj/item/used, list/modifiers)
	if(!can_operate(user) || used.loc != user || (user.get_active_hand() != used && user.get_inactive_hand() != used))
		return ITEM_INTERACT_COMPLETE
	if(istype(used, /obj/item/food) && our_blender)
		our_blender.insert_food(used, user, TRUE)
		return ITEM_INTERACT_COMPLETE
	if(istype(used, /obj/item/portable_blender))
		var/obj/item/portable_blender/blender = used
		if(!our_blender && !reagent_container && blender.loaded_reagent_container && user.transfer_item_to(blender, src))
			insert_blender(blender)
		return ITEM_INTERACT_COMPLETE
	if(istype(used, /obj/item/reagent_containers))
		var/obj/item/reagent_containers/container = used
		if(!our_blender && !reagent_container && (container.container_type & OPENCONTAINER) && user.transfer_item_to(container, src))
			reagent_container = container
			RegisterSignal(container, list(COMSIG_MOVABLE_MOVED, COMSIG_PARENT_QDELETING), PROC_REF(on_container_lost))
			update_icon()
		return ITEM_INTERACT_COMPLETE
	return ..()

/obj/machinery/iv_drip/feeding_tube/proc/get_reagents()
	if(QDELETED(reagent_container) || reagent_container.loc != (our_blender ? our_blender : src))
		return null
	return reagent_container.reagents

/obj/machinery/iv_drip/feeding_tube/proc/can_feed(mob/living/carbon/target)
	if(!istype(target) || QDELETED(target) || !isturf(target.loc) || !isturf(loc) || !Adjacent(target) || !target.reagents || target.is_mouth_covered())
		return FALSE
	var/mob/living/carbon/consumer = target.get_gs13_food_recipient()
	if(!consumer?.get_gs13_ingestion_target())
		return FALSE
	if(ishuman(target))
		var/mob/living/carbon/human/human = target
		return human.check_has_mouth()
	return TRUE

/obj/machinery/iv_drip/feeding_tube/MouseDrop(mob/living/target)
	drag_drop_onto(target, usr)

/obj/machinery/iv_drip/feeding_tube/proc/drag_drop_onto(mob/living/target, mob/user)
	return attach_iv(target, user)

/obj/machinery/iv_drip/feeding_tube/proc/attach_iv(mob/living/carbon/target, mob/user)
	if(!can_operate(user) || !user.Adjacent(target) || !can_feed(target) || !get_reagents())
		return FALSE
	detach_iv()
	connected_target = target
	RegisterSignal(target, COMSIG_MOVABLE_MOVED, PROC_REF(on_connection_moved))
	RegisterSignal(target, COMSIG_PARENT_QDELETING, PROC_REF(on_target_deleted))
	var/atom/movable/screen/alert/tube_connected/alert = target.throw_alert("gs13_tube_[UID()]", /atom/movable/screen/alert/tube_connected)
	if(alert)
		alert.tube = src
	START_PROCESSING(SSmachines, src)
	visible_message(SPAN_NOTICE("[user] connects [target] to [src]."))
	var/datum/reagents/supply = get_reagents()
	add_attack_logs(user, target, "Connected to [src] containing [supply.log_list()]", supply.harmless_helper() ? ATKLOG_ALMOSTALL : null)
	update_icon()
	return TRUE

/obj/machinery/iv_drip/feeding_tube/proc/detach_iv()
	var/mob/living/carbon/old_target = connected_target
	connected_target = null
	STOP_PROCESSING(SSmachines, src)
	if(old_target)
		UnregisterSignal(old_target, list(COMSIG_MOVABLE_MOVED, COMSIG_PARENT_QDELETING))
		old_target.clear_alert("gs13_tube_[UID()]")
	update_icon()
	SStgui.update_uis(src)

/obj/machinery/iv_drip/feeding_tube/proc/on_connection_moved(datum/source)
	SIGNAL_HANDLER
	if(connected_target && !can_feed(connected_target))
		detach_iv()

/obj/machinery/iv_drip/feeding_tube/proc/on_target_deleted(datum/source)
	SIGNAL_HANDLER
	detach_iv()

/// Oral effects can change the connection before the native fluid transfer.
/obj/machinery/iv_drip/feeding_tube/proc/can_complete_gs13_feed(mob/living/carbon/physical_target, mob/living/carbon/consumer)
	return !QDELETED(src) && connected_target == physical_target && can_feed(physical_target) && physical_target.get_gs13_food_recipient() == consumer

/obj/machinery/iv_drip/feeding_tube/process(seconds_per_tick = 2)
	var/datum/reagents/supply = get_reagents()
	if(!can_feed(connected_target) || !supply || !is_operational())
		detach_iv()
		return PROCESS_KILL
	if(!transfer_rate || !GS13_IS_FINITE(seconds_per_tick) || seconds_per_tick <= 0)
		return
	var/mob/living/carbon/consumer = connected_target.get_gs13_food_recipient()
	var/amount = min(transfer_rate * seconds_per_tick, supply.total_volume, consumer.get_gs13_ingestion_free_space())
	if(amount <= 0)
		return
	// This machine feeds orally. Ordinary IVs continue to use the blood holder.
	if(supply.gs13_ingest(consumer, amount, show_message = FALSE, validate = CALLBACK(src, PROC_REF(can_complete_gs13_feed), connected_target, consumer)))
		if(consumer != connected_target && prob(10))
			consumer.gs13_receiving_feedback()
	update_icon()

/obj/machinery/iv_drip/feeding_tube/proc/set_transfer_rate(new_rate)
	if(!isnum(new_rate) || !GS13_IS_FINITE(new_rate))
		return FALSE
	transfer_rate = round(clamp(new_rate, 0, 5), 0.01)
	update_icon()
	return TRUE

/obj/machinery/iv_drip/feeding_tube/AltClick(mob/user)
	if(can_operate(user))
		set_transfer_rate(transfer_rate ? 0 : 5)

/obj/machinery/iv_drip/feeding_tube/update_icon_state()
	icon_state = connected_target && transfer_rate ? "feeding_tube_injecting" : "feeding_tube_injectidle"

/obj/machinery/iv_drip/feeding_tube/update_overlays()
	. = ..()
	if(!reagent_container)
		return
	. += connected_target && transfer_rate ? "beakeractive" : "beakeridle"
	var/datum/reagents/supply = get_reagents()
	if(supply?.total_volume)
		var/percent = supply.total_volume / supply.maximum_volume * 100
		var/level = percent >= 80 ? 100 : percent >= 75 ? 80 : percent >= 50 ? 75 : percent >= 25 ? 50 : percent >= 10 ? 25 : 10
		var/mutable_appearance/filling = mutable_appearance(icon, "reagent[level]")
		filling.color = mix_color_from_reagents(supply.reagent_list)
		. += filling

/obj/machinery/iv_drip/feeding_tube/attack_hand(mob/user)
	if(..())
		return
	ui_interact(user)

/obj/machinery/iv_drip/feeding_tube/ui_state(mob/user)
	return GLOB.default_state

/obj/machinery/iv_drip/feeding_tube/ui_interact(mob/user, datum/tgui/ui = null)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "GS13FeedingTube", name)
		ui.open()

/obj/machinery/iv_drip/feeding_tube/ui_data(mob/user)
	var/datum/reagents/supply = get_reagents()
	return list("container" = reagent_container?.name, "hasContainer" = !!(our_blender || reagent_container), "volume" = supply ? supply.total_volume : 0, "capacity" = supply ? supply.maximum_volume : 0, "target" = connected_target?.name, "rate" = transfer_rate)

/obj/machinery/iv_drip/feeding_tube/ui_act(action, params, datum/tgui/ui)
	if(..() || !can_operate(ui.user))
		return
	switch(action)
		if("rate")
			return set_transfer_rate(isnum(params["rate"]) ? params["rate"] : text2num(params["rate"]))
		if("pause")
			return set_transfer_rate(transfer_rate ? 0 : 5)
		if("detach")
			detach_iv()
			return TRUE
		if("eject")
			return !!eject_beaker(ui.user)

/obj/machinery/iv_drip/feeding_tube/deconstruct(disassembled = TRUE)
	if(!(flags & NODECONSTRUCT))
		release_container()
		new /obj/item/stack/sheet/metal(get_turf(src))
	qdel(src)

/atom/movable/screen/alert/tube_connected
	name = "Feeding Tube Connected"
	desc = "A feeding tube is connected to you. Click to disconnect it."
	icon = 'modular_gs/icons/obj/feeding_tube.dmi'
	icon_state = "borg_tube"
	var/obj/machinery/iv_drip/feeding_tube/tube

/atom/movable/screen/alert/tube_connected/Click(location, control, params)
	if(..() && !QDELETED(tube) && tube.connected_target == owner && tube.can_operate(owner))
		tube.detach_iv()

/atom/movable/screen/alert/tube_connected/Destroy()
	tube = null
	return ..()

/datum/supply_packs/organic/feeding_tube
	name = "Feeding Tube Crate"
	contains = list(/obj/machinery/iv_drip/feeding_tube)
	cost = 350
	containername = "feeding tube crate"
	containertype = /obj/structure/closet/crate
