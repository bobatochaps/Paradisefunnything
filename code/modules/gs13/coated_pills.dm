// Pinned inherited pill coating, expressed in native seconds and oral routing.
/proc/gs13_sanitize_pill_coating(value)
	if(!isnum(value) || !GS13_IS_FINITE(value))
		return GS13_DEFAULT_PILL_COATING
	return clamp(value, 0, GS13_MAX_PILL_COATING)

/obj/item/reagent_containers/pill/Destroy()
	if(gs13_coating_timer)
		deltimer(gs13_coating_timer)
		gs13_coating_timer = null
	return ..()

/obj/item/reagent_containers/pill/examine(mob/user)
	. = ..()
	var/duration = gs13_sanitize_pill_coating(gs13_layers_remaining)
	. += SPAN_NOTICE(duration > 0 ? "Its coating lasts approximately [duration] seconds of stomach digestion." : "Its coating has dissolved.")

/obj/item/reagent_containers/pill/serialize()
	var/list/data = ..()
	data["gs13_layers_remaining"] = gs13_sanitize_pill_coating(gs13_layers_remaining)
	return data

/obj/item/reagent_containers/pill/deserialize(list/data)
	. = ..()
	set_gs13_coating(data["gs13_layers_remaining"])

/// Recovered/recoated medicine cannot retain a timer for its old thin shell.
/obj/item/reagent_containers/pill/proc/set_gs13_coating(value)
	if(gs13_coating_timer)
		deltimer(gs13_coating_timer)
		gs13_coating_timer = null
	gs13_layers_remaining = gs13_sanitize_pill_coating(value)

/obj/item/reagent_containers/pill/item_interaction(mob/living/user, obj/item/used, list/modifiers)
	. = ..()
	if(.)
		return
	var/obj/item/reagent_containers/container
	if(istype(used, /obj/item/reagent_containers/dropper))
		container = used
	else if(istype(used, /obj/item/reagent_containers/glass) || istype(used, /obj/item/reagent_containers/drinks))
		container = used
		if(!container.is_open_container())
			return ITEM_INTERACT_COMPLETE
	if(!container?.reagents)
		return
	var/current = gs13_sanitize_pill_coating(gs13_layers_remaining)
	var/sugar = container.reagents.get_reagent_amount("sugar")
	if(sugar > 0)
		var/amount = FLOOR(min(container.amount_per_transfer_from_this, sugar, GS13_MAX_PILL_COATING - current), 1)
		if(amount > 0)
			container.reagents.remove_reagent("sugar", amount)
			set_gs13_coating(current + amount)
			to_chat(user, SPAN_NOTICE("You thicken [src]'s coating with sugar."))
		return ITEM_INTERACT_COMPLETE
	var/water = container.reagents.get_reagent_amount("water")
	if(water <= 0)
		return
	var/amount = FLOOR(min(container.amount_per_transfer_from_this, water, current), 1)
	if(amount > 0)
		container.reagents.remove_reagent("water", amount)
		set_gs13_coating(current - amount)
		to_chat(user, SPAN_NOTICE("You dissolve some of [src]'s coating with water."))
	return ITEM_INTERACT_COMPLETE

/obj/item/reagent_containers/pill/proc/valid_gs13_digestion(obj/item/organ/internal/gs13_stomach/stomach, mob/living/carbon/holder)
	return !QDELETED(src) && !QDELETED(stomach) && !QDELETED(holder) && stomach && holder && holder.stat != DEAD && stomach.owner == holder && holder.get_organ_slot(GS13_ORGAN_STOMACH) == stomach && loc == holder && (src in stomach.gs13_stomach_contents)

/obj/item/reagent_containers/pill/proc/on_gs13_stomach_digestion(datum/source, obj/item/organ/internal/gs13_stomach/stomach, mob/living/carbon/holder, seconds)
	SIGNAL_HANDLER
	if(gs13_coating_timer || !valid_gs13_digestion(stomach, holder) || !isnum(seconds) || !GS13_IS_FINITE(seconds) || seconds <= 0)
		return
	gs13_layers_remaining = max(0, gs13_sanitize_pill_coating(gs13_layers_remaining) - seconds)
	if(gs13_layers_remaining <= 0)
		release_gs13_pill(stomach, holder)
	else if(gs13_layers_remaining < seconds)
		// Preserve a fractional final tick without holding the old body alive.
		gs13_coating_timer = addtimer(CALLBACK(src, PROC_REF(finish_gs13_coating), stomach.UID(), holder.UID()), gs13_layers_remaining SECONDS, TIMER_STOPPABLE)

/obj/item/reagent_containers/pill/proc/finish_gs13_coating(stomach_uid, holder_uid)
	gs13_coating_timer = null
	var/obj/item/organ/internal/gs13_stomach/stomach = locateUID(stomach_uid)
	var/mob/living/carbon/holder = locateUID(holder_uid)
	if(!valid_gs13_digestion(stomach, holder))
		return
	gs13_layers_remaining = 0
	release_gs13_pill(stomach, holder)

/// Backpressure preserves an unaccepted dose in the actual recovered pill.
/// Oral reactions occur only for material actually accepted by the live gut.
/obj/item/reagent_containers/pill/proc/release_gs13_pill(obj/item/organ/internal/gs13_stomach/stomach, mob/living/carbon/holder)
	if(!valid_gs13_digestion(stomach, holder) || !reagents)
		return 0
	if(!reagents.total_volume)
		qdel(src)
		return 0
	var/amount = min(reagents.total_volume, holder.get_gs13_ingestion_free_space())
	if(amount <= 0)
		return 0
	add_attack_logs(holder, holder, "Digested coated [src]. Reagents: [reagents.log_list()]", reagents.harmless_helper() ? ATKLOG_ALMOSTALL : null)
	var/transferred = reagents.gs13_ingest(holder, amount, FALSE, CALLBACK(src, PROC_REF(valid_gs13_digestion), stomach, holder))
	if(!QDELETED(src) && reagents.total_volume <= 0)
		qdel(src)
	return transferred

/obj/item/reagent_containers/pill/try_gs13_accidental_swallow(mob/living/carbon/consumer)
	return apply(consumer, consumer)

// Native ChemMaster pill production keeps its own independent coating choice.
/datum/chemical_production_mode/pills
	var/gs13_coating_duration = GS13_DEFAULT_PILL_COATING

/datum/chemical_production_mode/pills/configure_item(data, datum/reagents/reagents, obj/item/reagent_containers/pill/pill)
	. = ..()
	pill.set_gs13_coating(clamp(gs13_sanitize_pill_coating(gs13_coating_duration), 0, GS13_MAX_PRINTABLE_PILL_COATING))

/obj/machinery/chem_master/proc/set_gs13_pill_coating(value)
	if(istext(value))
		value = text2num(value)
	if(!isnum(value) || !GS13_IS_FINITE(value))
		return FALSE
	var/datum/chemical_production_mode/pills/mode = production_modes["pills"]
	if(!istype(mode))
		return FALSE
	mode.gs13_coating_duration = clamp(value, 0, GS13_MAX_PRINTABLE_PILL_COATING)
	return TRUE
