// GS13 adipoelectric machinery adapted to Paradise regional powernets.
#define GS13_GENERATOR_JOULES_PER_FAT 10000
#define GS13_TRANSFORMER_WATTS_PER_FAT 500000

GLOBAL_LIST_EMPTY(adipoelectric_transformer)

/// Common platform, occupant lifecycle, and native construction support.
/obj/machinery/power/gs13_adipoelectric
	name = "adipoelectric platform"
	icon = 'modular_gs/icons/obj/adipoelectric_transformer.dmi'
	icon_state = "state_off"
	density = FALSE
	anchored = FALSE
	interact_offline = TRUE
	var/mob/living/carbon/occupant
	var/board_path
	var/active = FALSE
	var/emp_until = 0
	/// Actual output or consumption during the last processing interval, in watts.
	var/last_power = 0

/obj/machinery/power/gs13_adipoelectric/Initialize(mapload)
	. = ..()
	STOP_PROCESSING(SSmachines, src)
	component_parts = list()
	if(ispath(board_path))
		var/obj/item/circuitboard/board = new board_path(src)
		component_parts += board
		for(var/part_path in board.req_components)
			if(ispath(part_path, /obj/item/stack))
				component_parts += new part_path(src, board.req_components[part_path])
			else
				for(var/i in 1 to board.req_components[part_path])
					component_parts += new part_path(src)
	RefreshParts()
	RegisterSignal(src, COMSIG_MOVABLE_MOVED, PROC_REF(on_machine_moved))
	if(anchored)
		connect_to_network()

/obj/machinery/power/gs13_adipoelectric/Destroy()
	open_machine(TRUE)
	QDEL_LIST_CONTENTS(component_parts)
	UnregisterSignal(src, COMSIG_MOVABLE_MOVED)
	return ..()

/obj/machinery/power/gs13_adipoelectric/proc/can_operate(mob/user)
	return isliving(user) && !QDELETED(user) && !user.incapacitated() && !HAS_TRAIT(user, TRAIT_HANDS_BLOCKED) && user.IsAdvancedToolUser() && (isturf(user.loc) || user == occupant) && user.Adjacent(src)

/obj/machinery/power/gs13_adipoelectric/proc/close_machine(mob/living/carbon/target, mob/user)
	if(!can_operate(user) || occupant || !is_operational() || !anchored || panel_open || !isturf(loc))
		return FALSE
	if(!istype(target) || QDELETED(target) || !isturf(target.loc) || target.loc != loc || target.buckled || target.has_buckled_mobs())
		return FALSE
	occupant = target
	target.forceMove(src)
	RegisterSignal(target, COMSIG_MOVABLE_MOVED, PROC_REF(on_occupant_moved))
	RegisterSignal(target, COMSIG_PARENT_QDELETING, PROC_REF(on_occupant_deleted))
	START_PROCESSING(SSmachines, src)
	on_occupant_changed()
	add_fingerprint(user)
	add_attack_logs(user, target, "Placed in [src]", ATKLOG_ALMOSTALL)
	update_icon()
	return TRUE

/obj/machinery/power/gs13_adipoelectric/proc/can_release()
	return TRUE

/obj/machinery/power/gs13_adipoelectric/proc/open_machine(force = FALSE)
	if(!force && !can_release())
		return FALSE
	var/mob/living/carbon/old_occupant = occupant
	clear_occupant()
	if(!QDELETED(old_occupant) && old_occupant.loc == src)
		old_occupant.forceMove(get_turf(src))
	return TRUE

/obj/machinery/power/gs13_adipoelectric/proc/clear_occupant()
	if(occupant)
		UnregisterSignal(occupant, list(COMSIG_MOVABLE_MOVED, COMSIG_PARENT_QDELETING))
	occupant = null
	active = FALSE
	last_power = 0
	STOP_PROCESSING(SSmachines, src)
	on_occupant_changed()
	update_icon()

/obj/machinery/power/gs13_adipoelectric/proc/on_occupant_changed()
	return

/obj/machinery/power/gs13_adipoelectric/proc/on_occupant_moved(datum/source)
	SIGNAL_HANDLER
	if(occupant?.loc != src)
		clear_occupant()

/obj/machinery/power/gs13_adipoelectric/proc/on_occupant_deleted(datum/source)
	SIGNAL_HANDLER
	clear_occupant()

/obj/machinery/power/gs13_adipoelectric/proc/on_machine_moved(datum/source)
	SIGNAL_HANDLER
	disconnect_from_network()
	if(anchored)
		connect_to_network()
	if(!isturf(loc))
		open_machine(TRUE)

/obj/machinery/power/gs13_adipoelectric/attack_hand(mob/user)
	if(..() || !can_operate(user))
		return
	if(occupant)
		if(!open_machine())
			to_chat(user, SPAN_WARNING("[src]'s release is jammed by an EMP. It will reset in [round((emp_until - world.time) / 10, 0.1)] seconds."))
		return
	var/mob/living/carbon/target
	if(iscarbon(user) && user.loc == loc)
		target = user
	else
		target = locate(/mob/living/carbon) in loc
	if(!close_machine(target, user))
		to_chat(user, SPAN_NOTICE("Secure [src], close its maintenance hatch, and stand on the platform to use it."))

/obj/machinery/power/gs13_adipoelectric/relaymove(mob/user)
	if(user == occupant && user.stat == CONSCIOUS)
		open_machine()

/obj/machinery/power/gs13_adipoelectric/container_resist(mob/living/user)
	relaymove(user)

/obj/machinery/power/gs13_adipoelectric/wrench_act(mob/living/user, obj/item/tool)
	if(occupant)
		to_chat(user, SPAN_WARNING("Empty [src] first!"))
		return TRUE
	if(!default_unfasten_wrench(user, tool))
		return FALSE
	if(anchored)
		connect_to_network()
	else
		disconnect_from_network()
	return TRUE

/obj/machinery/power/gs13_adipoelectric/screwdriver_act(mob/living/user, obj/item/tool)
	if(occupant)
		return TRUE
	return default_deconstruction_screwdriver(user, "state_open", "state_off", tool)

/obj/machinery/power/gs13_adipoelectric/crowbar_act(mob/living/user, obj/item/tool)
	if(occupant)
		return TRUE
	return default_deconstruction_crowbar(user, tool)

/obj/machinery/power/gs13_adipoelectric/deconstruct(disassembled = TRUE)
	open_machine(TRUE)
	return ..()

/obj/machinery/power/gs13_adipoelectric/process(seconds_per_tick = 2)
	active = FALSE
	last_power = 0
	if(QDELETED(occupant) || occupant.loc != src)
		clear_occupant()
		return PROCESS_KILL
	if(anchored && isturf(loc) && !panel_open && is_operational() && powernet && GS13_IS_FINITE(seconds_per_tick) && seconds_per_tick > 0)
		convert_energy(seconds_per_tick)
	update_icon()

/obj/machinery/power/gs13_adipoelectric/proc/convert_energy(seconds_per_tick)
	return

/obj/machinery/power/gs13_adipoelectric/update_icon_state()
	icon_state = panel_open ? "state_open" : active ? "state_on" : "state_off"

/obj/machinery/power/gs13_adipoelectric/update_overlays()
	. = ..()
	if(occupant)
		var/mutable_appearance/person = new(occupant.appearance)
		person.dir = SOUTH
		person.pixel_y = 10
		person.layer = FLOAT_LAYER
		person.plane = FLOAT_PLANE
		. += person

/obj/machinery/power/adipoelectric_generator
	parent_type = /obj/machinery/power/gs13_adipoelectric
	name = "adipoelectric generator"
	desc = "A calorite generator that converts stored body fat into electrical power. Stand on it and click to enter; move to leave. It must be secured over a cable junction."
	board_path = /obj/item/circuitboard/machine/power/adipoelectric_generator
	var/laser_modifier = 0
	var/max_fat = 0

/obj/machinery/power/adipoelectric_generator/anchored
	anchored = TRUE

/obj/machinery/power/adipoelectric_generator/RefreshParts()
	laser_modifier = 0
	max_fat = 0
	for(var/obj/item/stock_parts/micro_laser/laser in component_parts)
		laser_modifier += laser.rating
	for(var/obj/item/stock_parts/matter_bin/bin in component_parts)
		max_fat += bin.rating * 5

/obj/machinery/power/adipoelectric_generator/convert_energy(seconds_per_tick)
	if(world.time < emp_until || occupant.fatness_real <= 0 || (occupant.status_flags & GODMODE))
		return
	var/burned = max(0, -occupant.adjust_fatness(-max_fat * seconds_per_tick, FATTENING_TYPE_ITEM, TRUE))
	// The powernet accepts watts, while the weight adjustment covers this interval.
	last_power = GS13_GENERATOR_JOULES_PER_FAT * laser_modifier * burned / seconds_per_tick
	if(last_power > 0)
		produce_direct_power(last_power)
		active = TRUE

/obj/machinery/power/adipoelectric_generator/emp_act(severity)
	. = ..()
	if(!(stat & BROKEN))
		emp_until = world.time + 60 SECONDS
		open_machine(TRUE)

/obj/machinery/power/adipoelectric_generator/examine(mob/user)
	. = ..()
	. += SPAN_NOTICE("Capacity: [max_fat] adipose units per second, at [GS13_GENERATOR_JOULES_PER_FAT * laser_modifier] joules per unit. Last output: [round(last_power)] W.")

/obj/machinery/power/adipoelectric_transformer
	parent_type = /obj/machinery/power/gs13_adipoelectric
	name = "adipoelectric transformer"
	desc = "A calorite transformer that stores surplus electrical power as body fat. Stand on it and click to enter; move to leave. It must be secured over a cable junction."
	board_path = /obj/item/circuitboard/machine/adipoelectric_transformer
	var/recharge_speed = 0
	/// Requested adipose units per second, before the occupant's preference multiplier.
	var/lastprocessed = 0
	var/emp_multiplier = 5

/obj/machinery/power/adipoelectric_transformer/anchored
	anchored = TRUE

/obj/machinery/power/adipoelectric_transformer/RefreshParts()
	recharge_speed = 0
	for(var/obj/item/stock_parts/capacitor/capacitor in component_parts)
		recharge_speed += capacitor.rating

/obj/machinery/power/adipoelectric_transformer/on_occupant_changed()
	if(occupant)
		GLOB.adipoelectric_transformer |= src
	else
		GLOB.adipoelectric_transformer -= src
	lastprocessed = 0

/obj/machinery/power/adipoelectric_transformer/convert_energy(seconds_per_tick)
	lastprocessed = 0
	var/available = get_surplus()
	if(available <= 0)
		return
	if(available > GS13_TRANSFORMER_WATTS_PER_FAT)
		lastprocessed = 1 + (available - GS13_TRANSFORMER_WATTS_PER_FAT) / (GS13_TRANSFORMER_WATTS_PER_FAT * 10)
	else
		lastprocessed = available / GS13_TRANSFORMER_WATTS_PER_FAT
	last_power = available
	// Consume the complete surplus, including the first 500 kW above the threshold.
	consume_direct_power(last_power)
	lastprocessed *= recharge_speed
	if(world.time < emp_until)
		lastprocessed *= emp_multiplier
	if(!(occupant.status_flags & GODMODE))
		occupant.adjust_fatness(lastprocessed * seconds_per_tick, FATTENING_TYPE_ITEM)
	active = TRUE

/obj/machinery/power/adipoelectric_transformer/can_release()
	return world.time >= emp_until

/obj/machinery/power/adipoelectric_transformer/emp_act(severity)
	. = ..()
	if(!(stat & BROKEN) && occupant)
		emp_until = world.time + 60 SECONDS
		visible_message(SPAN_WARNING("[src] crackles as its release locks and its conversion coils overload!"))
		update_icon()

/obj/machinery/power/adipoelectric_transformer/update_icon_state()
	. = ..()
	if(active && world.time < emp_until)
		icon_state = "state_overdrive"

/obj/machinery/power/adipoelectric_transformer/update_overlays()
	. = ..()
	if(active)
		. += world.time < emp_until ? "particles_overdrive" : "particles_on"

/obj/machinery/power/adipoelectric_transformer/examine(mob/user)
	. = ..()
	. += SPAN_NOTICE("Last power draw: [round(last_power)] W. Last requested conversion: [round(lastprocessed, 0.1)] adipose units per second.")

/obj/item/circuitboard/machine/power/adipoelectric_generator
	board_name = "Adipoelectric Generator"
	build_path = /obj/machinery/power/adipoelectric_generator
	req_components = list(/obj/item/stock_parts/micro_laser = 5, /obj/item/stock_parts/matter_bin = 1, /obj/item/stack/cable_coil = 2)
	origin_tech = "powerstorage=3;engineering=3;biotech=3"

/obj/item/circuitboard/machine/adipoelectric_transformer
	board_name = "Adipoelectric Transformer"
	build_path = /obj/machinery/power/adipoelectric_transformer
	req_components = list(/obj/item/stock_parts/capacitor = 5, /obj/item/stack/sheet/glass = 1, /obj/item/stack/sheet/mineral/calorite = 1)
	origin_tech = "powerstorage=3;engineering=3;biotech=3"

/datum/design/adipoelectric_generator
	name = "Machine Board (Adipoelectric Generator)"
	id = "adipoelectric_generator"
	build_type = IMPRINTER
	build_path = /obj/item/circuitboard/machine/power/adipoelectric_generator
	req_tech = list("powerstorage" = 3, "engineering" = 3, "biotech" = 3)
	materials = list(MAT_GLASS = 1000)
	category = list("Engineering Machinery")

/datum/design/adipoelectric_transformer
	name = "Machine Board (Adipoelectric Transformer)"
	id = "adipoelectric_transformer"
	build_type = IMPRINTER
	build_path = /obj/item/circuitboard/machine/adipoelectric_transformer
	req_tech = list("powerstorage" = 3, "engineering" = 3, "biotech" = 3)
	materials = list(MAT_GLASS = 1000)
	category = list("Engineering Machinery")

#undef GS13_GENERATOR_JOULES_PER_FAT
#undef GS13_TRANSFORMER_WATTS_PER_FAT
