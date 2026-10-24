// Native, source-owned body changes for GS13's volume-driven transformations.
// Effects belong to the physical body. They do not rewrite DNA or stored weight.
/proc/gs13_volume_to_fatness(amount)
	if(!isnum(amount) || !GS13_IS_FINITE(amount) || amount <= 0)
		return 0
	// Bound before squaring so a malformed value cannot overflow the body model.
	amount = min(amount, sqrt(SHORT_REAL_LIMIT / 0.124))
	return 0.124 * amount * amount

/mob/living/carbon/proc/set_gs13_body_change(source, apparent_fatness, tint = null)
	if((!istext(source) && !istype(source, /datum)) || !source || QDELETED(src))
		return FALSE
	if(istype(source, /datum))
		var/datum/datum_source = source
		if(QDELETED(datum_source))
			return FALSE
	if(!isnum(apparent_fatness) || !GS13_IS_FINITE(apparent_fatness) || apparent_fatness < 0 || (!isnull(tint) && !istext(tint)))
		return FALSE
	if(!apparent_fatness && !tint)
		return remove_gs13_body_change(source)
	var/datum/component/gs13_transformation/controller = LoadComponent(/datum/component/gs13_transformation)
	return controller.set_source(source, min(apparent_fatness, SHORT_REAL_LIMIT), tint)

/mob/living/carbon/proc/remove_gs13_body_change(source)
	var/datum/component/gs13_transformation/controller = GetComponent(/datum/component/gs13_transformation)
	return controller?.remove_source(source)

/mob/living/carbon/proc/gs13_body_effects_enabled()
	if(gs13_weight_enabled())
		return TRUE
	var/datum/component/gs13_transformation/controller = GetComponent(/datum/component/gs13_transformation)
	return controller?.body_fatness > 0

// Paradise calls this after additions, merges, removals, and transfers, including
// on corpses. Recompute immediately rather than retaining a stale dose for a tick.
/mob/living/carbon/on_reagent_change()
	. = ..()
	sync_gs13_transformations()

/mob/living/carbon/proc/sync_gs13_transformations()
	if(QDELETED(src) || gs13_syncing_transformations)
		return
	gs13_syncing_transformations = TRUE
	for(var/datum/reagent/reagent as anything in reagents?.reagent_list.Copy())
		if(!QDELETED(reagent))
			reagent.update_gs13_transformation(src)
	gs13_syncing_transformations = FALSE

/datum/reagent/proc/update_gs13_transformation(mob/living/carbon/subject)
	return

/mob/living/carbon/proc/can_gs13_transform_with(datum/reagent/reagent)
	if(QDELETED(reagent) || reagent.holder != reagents)
		return FALSE
	if(ishuman(src))
		var/mob/living/carbon/human/human_subject = src
		return human_subject.dna?.species && human_subject.can_metabolize(reagent)
	return TRUE

/datum/component/gs13_transformation
	dupe_mode = COMPONENT_DUPE_UNIQUE
	var/list/sources = list()
	var/body_fatness = 0
	var/body_stage = 0
	var/applied_tint

/datum/component/gs13_transformation/Initialize()
	if(!iscarbon(parent))
		return COMPONENT_INCOMPATIBLE

/datum/component/gs13_transformation/RegisterWithParent()
	var/mob/living/carbon/subject = parent
	subject.fat_hiders |= src

/datum/component/gs13_transformation/UnregisterFromParent()
	var/mob/living/carbon/subject = parent
	if(subject)
		subject.fat_hiders -= src
		if(applied_tint)
			subject.remove_atom_colour(GS13_TRANSFORMATION_COLOUR_PRIORITY, applied_tint)
		if(!QDELETED(subject))
			subject.calculate_fatness()

/datum/component/gs13_transformation/Destroy(force = FALSE, silent = FALSE)
	for(var/source in sources)
		if(istype(source, /datum))
			UnregisterSignal(source, COMSIG_PARENT_QDELETING)
	sources.Cut()
	UnregisterFromParent()
	return ..()

/datum/component/gs13_transformation/proc/set_source(source, apparent_fatness, tint)
	if(!(source in sources) && istype(source, /datum))
		RegisterSignal(source, COMSIG_PARENT_QDELETING, PROC_REF(on_source_deleted))
	sources[source] = list("fatness" = apparent_fatness, "tint" = tint)
	refresh()
	return TRUE

/datum/component/gs13_transformation/proc/remove_source(source)
	if(!(source in sources))
		return FALSE
	if(istype(source, /datum))
		UnregisterSignal(source, COMSIG_PARENT_QDELETING)
	sources -= source
	if(!length(sources))
		qdel(src)
	else
		refresh()
	return TRUE

/datum/component/gs13_transformation/proc/on_source_deleted(datum/source)
	SIGNAL_HANDLER
	remove_source(source)

/datum/component/gs13_transformation/proc/fat_hide()
	return body_fatness

/datum/component/gs13_transformation/proc/refresh()
	var/mob/living/carbon/subject = parent
	if(QDELETED(subject))
		return
	var/new_fatness = 0
	var/new_tint
	for(var/source in sources)
		var/list/effect = sources[source]
		new_fatness = min(SHORT_REAL_LIMIT, new_fatness + effect["fatness"])
		if(effect["tint"])
			new_tint = effect["tint"]
	body_fatness = new_fatness
	body_stage = gs13_weight_stage(body_fatness)
	if(new_tint != applied_tint)
		if(applied_tint)
			subject.remove_atom_colour(GS13_TRANSFORMATION_COLOUR_PRIORITY, applied_tint)
		applied_tint = new_tint
		if(applied_tint)
			subject.add_atom_colour(applied_tint, GS13_TRANSFORMATION_COLOUR_PRIORITY)
	subject.calculate_fatness()
