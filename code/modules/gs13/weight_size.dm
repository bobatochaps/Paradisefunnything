// Adapted from GS13 xwg.dm and its inherited temporary_size component.
// Native equivalents of source dormitories, maintenance, and the afterlife lounge.
/proc/gs13_size_allowed_areas()
	return list(/area/station/public/dorms, /area/station/maintenance, /area/centcom/living, /area/ghost_bar)

/mob/living/carbon/proc/xwg_resize()
	if(!ishuman(src) || QDELETED(src))
		return FALSE
	// An explicitly applied temporary size takes priority over weight-driven sizing.
	if(!GetComponent(/datum/component/temporary_size) && gs13_preferences["weight_size_scaling"])
		AddComponent(/datum/component/temporary_size/xwg)
	return TRUE

/datum/component/temporary_size
	dupe_type = /datum/component/temporary_size
	var/list/allowed_areas
	var/original_size = RESIZE_DEFAULT_SIZE
	var/target_size = RESIZE_DEFAULT_SIZE
	/// Our own relative multiplier; removal must preserve other native resize effects.
	var/applied_multiplier = RESIZE_DEFAULT_SIZE

/datum/component/temporary_size/Initialize(size_to_apply)
	if(!ishuman(parent))
		return COMPONENT_INCOMPATIBLE
	if(!isnull(size_to_apply) && (!isnum(size_to_apply) || !GS13_IS_FINITE(size_to_apply) || size_to_apply <= 0))
		return COMPONENT_INCOMPATIBLE
	var/mob/living/carbon/human/human_parent = parent
	// Paradise initializes the replacement before deleting the previous component.
	// Release the old multiplier first so neither initialization nor destruction stacks it.
	var/datum/component/temporary_size/previous = human_parent.GetComponent(/datum/component/temporary_size)
	if(previous)
		previous.apply_size(previous.original_size)
	original_size = human_parent.gs13_render_size()
	if(!GS13_IS_FINITE(original_size) || original_size <= 0)
		return COMPONENT_INCOMPATIBLE
	target_size = isnull(size_to_apply) ? original_size : size_to_apply
	allowed_areas = gs13_size_allowed_areas()

/datum/component/temporary_size/RegisterWithParent()
	RegisterSignal(parent, COMSIG_MOVABLE_MOVED, PROC_REF(on_moved))
	RegisterSignal(parent, COMSIG_GS13_BODY_SIZE_CHANGED, PROC_REF(on_body_size_changed))
	refresh_size()

/datum/component/temporary_size/UnregisterFromParent()
	if(parent)
		apply_size(original_size)
		UnregisterSignal(parent, COMSIG_MOVABLE_MOVED)
		UnregisterSignal(parent, COMSIG_GS13_BODY_SIZE_CHANGED)

/datum/component/temporary_size/Destroy(force = FALSE, silent = FALSE)
	UnregisterFromParent()
	return ..()

/datum/component/temporary_size/proc/on_moved(datum/source)
	SIGNAL_HANDLER
	refresh_size()

/datum/component/temporary_size/proc/on_body_size_changed(datum/source, old_size, new_size)
	SIGNAL_HANDLER
	original_size *= new_size / old_size
	refresh_size()

/datum/component/temporary_size/proc/in_allowed_area()
	return !length(allowed_areas) || is_type_in_list(get_area(parent), allowed_areas)

/datum/component/temporary_size/proc/refresh_size()
	apply_size(in_allowed_area() ? target_size : original_size)

/datum/component/temporary_size/proc/apply_size(size_to_apply)
	if(!parent || QDELETED(parent))
		return FALSE
	var/new_multiplier = size_to_apply / original_size
	if(new_multiplier == applied_multiplier)
		return FALSE
	var/mob/living/carbon/human/human_parent = parent
	human_parent.resize *= new_multiplier / applied_multiplier
	applied_multiplier = new_multiplier
	human_parent.update_transform()
	return TRUE

/datum/component/temporary_size/xwg/RegisterWithParent()
	..()
	RegisterSignal(parent, COMSIG_FATNESS_CHANGED, PROC_REF(on_weight_changed))

/datum/component/temporary_size/xwg/UnregisterFromParent()
	if(parent)
		UnregisterSignal(parent, COMSIG_FATNESS_CHANGED)
	return ..()

/datum/component/temporary_size/xwg/proc/on_weight_changed(datum/source)
	SIGNAL_HANDLER
	refresh_size()

/datum/component/temporary_size/xwg/refresh_size()
	var/mob/living/carbon/human/human_parent = parent
	if(!human_parent || QDELETED(human_parent))
		return
	target_size = original_size
	if(human_parent.gs13_preferences["weight_size_scaling"] && human_parent.fatness > FATNESS_LEVEL_BLOB)
		var/max_size = human_parent.gs13_preferences["size_xwg"] ? GS13_RESIZE_MACRO : GS13_RESIZE_BIG
		target_size = max(original_size, min(original_size * sqrt(human_parent.fatness / FATNESS_LEVEL_BLOB), max_size))
	var/area_limit = in_allowed_area() ? GS13_RESIZE_MACRO : GS13_RESIZE_BIG
	// A native/admin resize larger than the cap must never be shrunk by gaining weight.
	apply_size(max(original_size, min(target_size, area_limit)))
