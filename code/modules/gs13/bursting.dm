// GS13 capacity, confirmation, and bursting through native timers and anatomy.
GLOBAL_LIST_INIT(gs13_berry_growth_sounds, list('modular_gs/sound/voice/gurgle1.ogg', 'modular_gs/sound/voice/gurgle2.ogg', 'modular_gs/sound/voice/gurgle3.ogg'))
GLOBAL_LIST_INIT(gs13_berry_creak_sounds, list('modular_gs/sound/effects/inflation/creaking/Creak1.ogg', 'modular_gs/sound/effects/inflation/creaking/Creak2.ogg', 'modular_gs/sound/effects/inflation/creaking/Creak3.ogg', 'modular_gs/sound/effects/inflation/creaking/Creak4.ogg'))
GLOBAL_LIST_INIT(gs13_fat_slosh_sounds, list('modular_gs/sound/effects/inflation/sloshing/slosh_1.ogg', 'modular_gs/sound/effects/inflation/sloshing/slosh_2.ogg', 'modular_gs/sound/effects/inflation/sloshing/slosh_3.ogg'))

/proc/gs13_burst_modes()
	return list("Disabled" = 0, "Safe" = 1, "Injure" = 2, "Critical" = 3, "Fatal" = 4, "Gib" = 5)

/proc/gs13_burst_numeric_preferences()
	return list("blueberry_max_before_burst", "blueberry_lives", "glutton_fullness_before_burst", "glutton_fatness_before_burst")

/proc/gs13_burst_default_preferences()
	return list("safe_bursting" = TRUE, "see_bursting" = FALSE, "bursting_leave_gibs" = FALSE, "automatic_bursting" = FALSE, "blueberry_max_before_burst" = 0, "blueberry_lives" = 0, "glutton_fullness_before_burst" = 0, "glutton_fatness_before_burst" = 0, "glutton_bursting_type" = "Disabled", "glutton_see_bursting" = FALSE, "glutton_leave_gibs" = FALSE, "glutton_enable_messages" = FALSE, "glutton_enable_sounds" = FALSE)

/proc/gs13_burst_preference_labels()
	return list(
		"blueberry_max_before_burst" = "Blueberry juice capacity before bursting (units; 0 = disabled)",
		"safe_bursting" = "Always survive blueberry bursting",
		"blueberry_lives" = "Safe blueberry burst allowance when survival is disabled (0 = none)",
		"automatic_bursting" = "Automatically accept blueberry bursting",
		"see_bursting" = "Allow seeing blueberry bursting",
		"bursting_leave_gibs" = "Leave remains after fatal blueberry bursting",
		"glutton_fullness_before_burst" = "Fullness above 750 before glutton bursting (0 = disabled)",
		"glutton_fatness_before_burst" = "Apparent BFI before glutton bursting (0 = disabled)",
		"glutton_bursting_type" = "Glutton bursting outcome",
		"glutton_see_bursting" = "Allow seeing glutton bursting",
		"glutton_leave_gibs" = "Leave remains after fatal glutton bursting",
		"glutton_enable_messages" = "Glutton capacity feedback messages",
		"glutton_enable_sounds" = "Glutton capacity feedback sounds",
	)

/proc/gs13_blueberry_capacity_stage(ratio)
	if(!isnum(ratio) || !GS13_IS_FINITE(ratio) || ratio <= 0)
		return 0
	if(ratio <= 0.4)
		return 1
	if(ratio <= 0.7)
		return 2
	if(ratio <= 0.9)
		return 3
	return 4

/proc/gs13_probability_per_second(chance, seconds)
	if(seconds <= 0)
		return FALSE
	return prob(100 * (1 - (1 - clamp(chance, 0, 100) / 100) ** seconds))

/mob/living/carbon/proc/handle_gs13_bursting(seconds = 2)
	var/has_threshold = gs13_preferences["blueberry_max_before_burst"] > 0 || gs13_preferences["glutton_fullness_before_burst"] > 0 || gs13_preferences["glutton_fatness_before_burst"] > 0
	var/datum/component/gs13_bursting/controller = GetComponent(/datum/component/gs13_bursting)
	if(!has_threshold)
		QDEL_NULL(controller)
		return
	if(!controller)
		controller = LoadComponent(/datum/component/gs13_bursting)
	controller.handle_capacity(max(0, seconds))

/mob/living/carbon/proc/refresh_gs13_bursting()
	var/datum/component/gs13_bursting/controller = GetComponent(/datum/component/gs13_bursting)
	controller?.on_changed()

/mob/living/carbon/proc/gs13_blueberry_burst_is_safe()
	return gs13_preferences["safe_bursting"] || times_blueberry_bursted < gs13_preferences["blueberry_lives"]

/mob/living/carbon/proc/get_bursting_pref()
	return 0

/mob/living/carbon/human/get_bursting_pref()
	var/list/modes = gs13_burst_modes()
	return modes[gs13_preferences["glutton_bursting_type"]] || 0

/// Check actual client viewpoints, including remote eyes and larger viewports.
/mob/living/carbon/proc/gs13_burst_viewers_allow(kind)
	var/setting = kind == GS13_BURST_BLUEBERRY ? "see_bursting" : "glutton_see_bursting"
	if(!gs13_preferences[setting])
		return FALSE
	for(var/mob/viewer as anything in GLOB.player_list)
		if(!viewer.client)
			continue
		if(!gs13_burst_viewpoint_allows(viewer, kind))
			return FALSE
	return TRUE

/mob/living/carbon/proc/gs13_burst_viewpoint_allows(mob/viewer, kind)
	if(QDELETED(viewer))
		return TRUE
	var/atom/eye = viewer.client?.eye || viewer
	var/turf/body_turf = get_turf(src)
	var/turf/eye_turf = get_turf(eye)
	var/view_size = viewer.client?.view || world.view
	if(!body_turf || !eye_turf || eye_turf.z != body_turf.z || !(src in view(view_size, eye)))
		return TRUE
	var/list/values
	if(iscarbon(viewer))
		var/mob/living/carbon/carbon_viewer = viewer
		values = carbon_viewer.gs13_preferences
	else
		values = viewer.client?.prefs?.active_character?.gs13_preferences
	var/setting = kind == GS13_BURST_BLUEBERRY ? "see_bursting" : "glutton_see_bursting"
	return !!(values?[setting])

/datum/component/gs13_bursting
	dupe_mode = COMPONENT_DUPE_UNIQUE
	var/blueberry_ratio = 0
	var/blueberry_stage = 0
	var/fullness_ratio = -1
	var/fatness_ratio = -1
	var/list/cooldowns = list()
	var/pending_kind
	var/pending_state
	var/pending_outcome
	var/generation = 0
	var/pending_timer
	var/atom/preparation_location
	var/resolving = FALSE

/datum/component/gs13_bursting/Initialize()
	if(!iscarbon(parent))
		return COMPONENT_INCOMPATIBLE

/datum/component/gs13_bursting/RegisterWithParent()
	RegisterSignal(parent, list(COMSIG_FATNESS_CHANGED, COMSIG_GS13_REAGENTS_CHANGED, COMSIG_AFTER_SPECIES_CHANGE, SIGNAL_ADDTRAIT(TRAIT_NO_BURST)), PROC_REF(on_changed))
	RegisterSignal(parent, list(COMSIG_MOB_DEATH, COMSIG_MOB_LOGOUT), PROC_REF(on_interrupted))
	RegisterSignal(parent, COMSIG_MOVABLE_MOVED, PROC_REF(on_moved))

/datum/component/gs13_bursting/UnregisterFromParent()
	UnregisterSignal(parent, list(COMSIG_FATNESS_CHANGED, COMSIG_GS13_REAGENTS_CHANGED, COMSIG_AFTER_SPECIES_CHANGE, SIGNAL_ADDTRAIT(TRAIT_NO_BURST), COMSIG_MOB_DEATH, COMSIG_MOB_LOGOUT, COMSIG_MOVABLE_MOVED))
	if(ishuman(parent) && !QDELETED(parent))
		var/mob/living/carbon/human/subject = parent
		subject.bursting_capacity_fullness = -1
		subject.bursting_capacity_fatness = -1
		subject.bursting_capacity_percentage = -1

/datum/component/gs13_bursting/Destroy(force = FALSE, silent = FALSE)
	cancel_pending(0)
	UnregisterFromParent()
	return ..()

/datum/component/gs13_bursting/proc/calculate_capacity()
	var/mob/living/carbon/subject = parent
	blueberry_ratio = 0
	if(subject.gs13_preferences["blueberry_inflation"] && subject.gs13_preferences["blueberry_max_before_burst"] > 0)
		var/datum/reagent/blueberry_juice/juice = subject.reagents?.has_reagent("blueberry_juice")
		if(juice && subject.can_gs13_transform_with(juice))
			// Tiny, finite saved thresholds must not overflow capacity arithmetic.
			blueberry_ratio = juice.volume / max(1e-20, subject.gs13_preferences["blueberry_max_before_burst"])
	blueberry_stage = gs13_blueberry_capacity_stage(blueberry_ratio)
	fullness_ratio = -1
	fatness_ratio = -1
	if(ishuman(subject))
		var/fullness_threshold = subject.gs13_preferences["glutton_fullness_before_burst"]
		var/fatness_threshold = subject.gs13_preferences["glutton_fatness_before_burst"]
		if(fullness_threshold > 0)
			fullness_ratio = max(subject.get_fullness() - FULLNESS_LEVEL_BLOATED, 0) / max(1e-20, fullness_threshold)
		if(fatness_threshold > 0)
			fatness_ratio = max(subject.fatness - fatness_threshold * 0.6, 0) / max(1e-20, fatness_threshold * 0.4)
		var/mob/living/carbon/human/human_subject = subject
		human_subject.bursting_capacity_fullness = fullness_ratio
		human_subject.bursting_capacity_fatness = fatness_ratio
		human_subject.bursting_capacity_percentage = max(fullness_ratio, fatness_ratio)

/datum/component/gs13_bursting/proc/can_burst(kind, check_viewers = TRUE)
	var/mob/living/carbon/subject = parent
	if(QDELETED(subject) || subject.stat == DEAD || !get_turf(subject) || HAS_TRAIT(subject, TRAIT_NO_BURST) || (subject.status_flags & GODMODE))
		return FALSE
	calculate_capacity()
	if(kind == GS13_BURST_BLUEBERRY)
		if(blueberry_ratio <= 1 || !subject.gs13_preferences["see_bursting"])
			return FALSE
	else if(kind == GS13_BURST_GLUTTON)
		if(!ishuman(subject) || max(fullness_ratio, fatness_ratio) < 1 || !subject.get_bursting_pref() || !subject.gs13_preferences["glutton_see_bursting"])
			return FALSE
	else
		return FALSE
	return !check_viewers || subject.gs13_burst_viewers_allow(kind)

/datum/component/gs13_bursting/proc/on_changed()
	SIGNAL_HANDLER
	if(resolving || QDELETED(parent))
		return
	calculate_capacity()
	if(pending_kind && (!can_burst(pending_kind) || !outcome_matches()))
		cancel_pending()

/datum/component/gs13_bursting/proc/current_outcome(kind)
	var/mob/living/carbon/subject = parent
	return kind == GS13_BURST_BLUEBERRY ? (subject.gs13_blueberry_burst_is_safe() ? 1 : 4) : subject.get_bursting_pref()

/datum/component/gs13_bursting/proc/outcome_matches()
	return isnull(pending_outcome) || pending_outcome == current_outcome(pending_kind)

/datum/component/gs13_bursting/proc/on_interrupted()
	SIGNAL_HANDLER
	cancel_pending()

/datum/component/gs13_bursting/proc/on_moved()
	SIGNAL_HANDLER
	var/mob/living/carbon/subject = parent
	if(pending_state == "preparing" && subject.loc != preparation_location)
		cancel_pending()

/datum/component/gs13_bursting/proc/cancel_pending(retry_delay = 30 SECONDS)
	var/mob/living/carbon/subject = parent
	if(pending_kind)
		cooldowns[pending_kind] = world.time + retry_delay
	generation++
	if(pending_timer)
		deltimer(pending_timer)
	pending_timer = null
	pending_kind = null
	pending_state = null
	pending_outcome = null
	preparation_location = null
	if(subject && !QDELETED(subject))
		subject.remove_status_effect(/datum/status_effect/incapacitating/stun/gs13_burst)
		if(subject.gs13_burst_swell)
			subject.gs13_burst_swell = FALSE
			subject.update_transform()

/datum/component/gs13_bursting/proc/handle_capacity(seconds)
	if(QDELETED(src) || QDELETED(parent))
		return
	var/mob/living/carbon/subject = parent
	on_changed()
	if(subject.stat == DEAD)
		return
	if(blueberry_stage > 0)
		var/leak_chance = blueberry_stage == 4 ? 35 : (blueberry_stage == 3 ? 5 : (blueberry_stage == 2 ? 0.5 : 0))
		if(gs13_probability_per_second(leak_chance, seconds))
			subject.spill_gs13_blueberry_juice(0, TRUE)
		if(blueberry_stage == 4 && gs13_probability_per_second(5, seconds))
			subject.spill_gs13_blueberry_juice(min(subject.reagents.get_reagent_amount("blueberry_juice") * 0.02, 100))
		var/message_chance = blueberry_stage == 4 ? 15 : (blueberry_stage == 3 ? 10 : (blueberry_stage == 2 ? 1 : 0.5))
		if(gs13_probability_per_second(message_chance, seconds))
			var/berry_message = blueberry_stage >= 3 ? "Your body creaks under the pressure of the juice." : "You feel blueberry juice slosh inside you."
			to_chat(subject, SPAN_WARNING(berry_message))
			playsound(subject, pick(blueberry_stage >= 3 ? GLOB.gs13_berry_creak_sounds : GLOB.gs13_berry_growth_sounds), 45, TRUE)
	var/glutton_ratio = max(fullness_ratio, fatness_ratio)
	if(glutton_ratio > 0 && gs13_probability_per_second(clamp(5 + 15 * glutton_ratio, 5, 20) / 2, seconds))
		if(subject.gs13_preferences["glutton_enable_messages"])
			var/glutton_message = fullness_ratio >= fatness_ratio ? "Your stomach rumbles with fullness." : "Your body feels heavy and tight."
			to_chat(subject, SPAN_WARNING(glutton_message))
		if(subject.gs13_preferences["glutton_enable_sounds"])
			if(fullness_ratio > fatness_ratio * 0.3)
				playsound(subject, pick(GLOB.gs13_berry_growth_sounds), 45, TRUE)
			if(fatness_ratio > fullness_ratio * 0.3)
				playsound(subject, pick(GLOB.gs13_fat_slosh_sounds), 45, TRUE)
	// Offline bodies retain their chemical state; initiation waits for a player.
	if(pending_kind || !subject.client)
		return
	if(world.time >= cooldowns[GS13_BURST_BLUEBERRY] && can_burst(GS13_BURST_BLUEBERRY) && gs13_probability_per_second(blueberry_ratio * 15, seconds))
		request_burst(GS13_BURST_BLUEBERRY)
	else if(world.time >= cooldowns[GS13_BURST_GLUTTON] && can_burst(GS13_BURST_GLUTTON))
		request_burst(GS13_BURST_GLUTTON)

/datum/component/gs13_bursting/proc/request_burst(kind)
	var/mob/living/carbon/subject = parent
	if(pending_kind || world.time < cooldowns[kind] || !can_burst(kind))
		return FALSE
	pending_kind = kind
	pending_state = "prompt"
	pending_outcome = current_outcome(kind)
	var/token = ++generation
	if(kind == GS13_BURST_BLUEBERRY && subject.gs13_preferences["automatic_bursting"])
		return begin_preparation(kind, token)
	INVOKE_ASYNC(src, PROC_REF(prompt_burst), kind, token)
	return TRUE

/datum/component/gs13_bursting/proc/prompt_burst(kind, token)
	var/mob/living/carbon/subject = parent
	if(!subject.client)
		cancel_pending(kind == GS13_BURST_BLUEBERRY ? 5 MINUTES : 3 MINUTES)
		return
	var/fatal = kind == GS13_BURST_BLUEBERRY ? !subject.gs13_blueberry_burst_is_safe() : subject.get_bursting_pref() >= 4
	var/outcome_notice = "Your current setting allows survival."
	if(fatal)
		outcome_notice = "Your current setting will remove this body from the round."
	else if(kind == GS13_BURST_GLUTTON && subject.get_bursting_pref() >= 2)
		outcome_notice = "Your current setting causes [subject.get_bursting_pref() == 3 ? "critical" : "physical"] injuries and may be fatal if you are already hurt."
	var/choice = tgui_alert(subject, "You have exceeded your capacity. Burst now or delay? [outcome_notice]", "Ready to burst", list("Delay", "Burst now"))
	if(token != generation || QDELETED(src))
		return
	if(choice != "Burst now")
		cancel_pending(kind == GS13_BURST_BLUEBERRY ? 5 MINUTES : 3 MINUTES)
		return
	if(fatal || kind == GS13_BURST_GLUTTON)
		choice = tgui_alert(subject, "Confirm bursting with your current outcome setting.", "Confirm bursting", list("Delay", "Burst now"))
		if(token != generation || QDELETED(src))
			return
		if(choice != "Burst now")
			cancel_pending(kind == GS13_BURST_BLUEBERRY ? 5 MINUTES : 3 MINUTES)
			return
	begin_preparation(kind, token)

/// Entry after a confirmed dialog, or an explicitly enabled automatic setting.
/datum/component/gs13_bursting/proc/begin_preparation(kind, token)
	var/mob/living/carbon/subject = parent
	if(token != generation || pending_kind != kind || !can_burst(kind) || !outcome_matches())
		cancel_pending()
		return FALSE
	pending_state = "preparing"
	pending_outcome = current_outcome(kind)
	preparation_location = subject.loc
	pending_timer = addtimer(CALLBACK(src, PROC_REF(finish_preparation), token), kind == GS13_BURST_BLUEBERRY ? 7 SECONDS : 5 SECONDS, TIMER_STOPPABLE)
	playsound(subject, kind == GS13_BURST_BLUEBERRY ? 'modular_gs/sound/effects/inflation/pop/inflation_wet_crescendo.ogg' : 'modular_gs/sound/effects/inflation/pop/bursting_crescendo.ogg', 45, TRUE)
	return TRUE

/datum/component/gs13_bursting/proc/finish_preparation(token)
	var/mob/living/carbon/subject = parent
	if(token != generation || pending_state != "preparing")
		return FALSE
	pending_timer = null
	if(subject.stat != CONSCIOUS || subject.loc != preparation_location || !can_burst(pending_kind) || !outcome_matches())
		cancel_pending()
		return FALSE
	if(pending_kind == GS13_BURST_BLUEBERRY)
		return complete_burst(token)
	pending_state = "swelling"
	subject.gs13_burst_swell = TRUE
	subject.update_transform()
	subject.apply_status_effect(/datum/status_effect/incapacitating/stun/gs13_burst, 6 SECONDS)
	SEND_SIGNAL(subject, COMSIG_LIVING_BURSTING_TRANSFORM_SIGNAL)
	pending_timer = addtimer(CALLBACK(src, PROC_REF(complete_burst), token), 6 SECONDS, TIMER_STOPPABLE)
	return TRUE

/datum/component/gs13_bursting/proc/complete_burst(token)
	var/mob/living/carbon/subject = parent
	if(token != generation || !(pending_state in list("preparing", "swelling")) || !can_burst(pending_kind) || !outcome_matches())
		if(token == generation)
			cancel_pending()
		return FALSE
	var/kind = pending_kind
	var/mode = subject.get_bursting_pref()
	var/was_safe = subject.gs13_blueberry_burst_is_safe()
	var/injure_limbs = fatness_ratio > 1
	var/injure_stomach = fullness_ratio > 1
	resolving = TRUE
	cancel_pending(kind == GS13_BURST_BLUEBERRY ? 5 MINUTES : 3 MINUTES)
	if(kind == GS13_BURST_BLUEBERRY)
		var/volume = subject.reagents.get_reagent_amount("blueberry_juice")
		var/list/viruses = list()
		for(var/datum/disease/virus as anything in subject.viruses)
			viruses += virus.Copy()
		var/spilled = subject.spill_gs13_blueberry_juice(volume)
		if(spilled < volume - 0.01)
			QDEL_LIST_CONTENTS(viruses)
			resolving = FALSE
			return FALSE
		var/splash_range = min(7, 2 + round(volume / 500))
		for(var/mob/living/carbon/receiver in view(splash_range, subject))
			if(receiver == subject || !receiver.can_breathe_gas())
				continue
			for(var/datum/disease/virus as anything in viruses)
				receiver.ForceContractDisease(virus, FALSE)
		QDEL_LIST_CONTENTS(viruses)
		new /obj/effect/particle_effect/chem_smoke(get_turf(subject), "#0004ff")
		playsound(subject, 'modular_gs/sound/effects/inflation/pop/burst_wet.ogg', 68, TRUE)
		if(was_safe)
			subject.times_blueberry_bursted++
		else
			subject.remove_gs13_burst_body(subject.gs13_preferences["bursting_leave_gibs"])
	else
		subject.reagents.clear_reagents()
		subject.nutrition = min(subject.nutrition, NUTRITION_LEVEL_FULL)
		subject.fullness_adjustment = 0
		var/threshold = subject.gs13_preferences["glutton_fatness_before_burst"]
		if(threshold > 0)
			var/target_weight = max(0, threshold * 0.6 - 150)
			subject.adjust_fatness(-max(0, subject.fatness - target_weight), FATTENING_TYPE_ALMIGHTY, TRUE)
			subject.adjust_perma(-max(0, subject.fatness - target_weight), FATTENING_TYPE_ALMIGHTY, TRUE)
		playsound(subject, 'modular_gs/sound/effects/inflation/pop/burst_thump.ogg', 45, TRUE)
		new /obj/effect/particle_effect/chem_smoke(get_turf(subject), "#eecccc")
		if(mode >= 4)
			if(mode == 5)
				subject.gib()
			else
				subject.remove_gs13_burst_body(subject.gs13_preferences["glutton_leave_gibs"])
		else
			if(mode >= 2)
				var/mob/living/carbon/human/human_subject = subject
				human_subject.apply_damage(mode == 2 ? 40 : 110, BRUTE, BODY_ZONE_CHEST)
				if(injure_stomach)
					var/obj/item/organ/internal/stomach = human_subject.get_organ_slot(GS13_ORGAN_STOMACH)
					stomach?.receive_damage(mode == 2 ? 30 : 100)
				if(injure_limbs)
					for(var/zone in list(BODY_ZONE_L_ARM, BODY_ZONE_R_ARM, BODY_ZONE_L_LEG, BODY_ZONE_R_LEG))
						human_subject.apply_damage(mode == 2 ? 5 : 10, BRUTE, zone)
			subject.Paralyse(5 SECONDS, TRUE)
	if(!QDELETED(subject))
		SEND_SIGNAL(subject, COMSIG_LIVING_BURSTING_BURST)
		calculate_capacity()
	resolving = FALSE
	return TRUE

/// Native out-of-round removal preserves carried equipment and swallowed mobs.
/mob/living/carbon/proc/remove_gs13_burst_body(leave_remains = FALSE)
	death(TRUE)
	ghostize(GHOST_FLAGS_NO_REENTER)
	var/atom/drop = drop_location()
	for(var/obj/item/item in get_all_slots())
		drop_item_to_ground(item, force = TRUE)
	for(var/mob/occupant in contents.Copy())
		LAZYREMOVE(stomach_contents, occupant)
		occupant.forceMove(drop)
	if(leave_remains && ishuman(src))
		var/mob/living/carbon/human/human_subject = src
		if(ismachineperson(src))
			new /obj/effect/decal/cleanable/blood/gibs/robot(drop)
		else
			hgibs(drop, human_subject.dna)
	qdel(src)

/mob/living/carbon/proc/spill_gs13_blueberry_juice(amount, streak = FALSE)
	var/turf/floor = get_turf(src)
	if(!floor || !reagents?.has_reagent("blueberry_juice"))
		return 0
	var/decal_type = streak ? /obj/effect/decal/cleanable/gs13_juice/streak : /obj/effect/decal/cleanable/gs13_juice
	var/obj/effect/decal/cleanable/gs13_juice/puddle
	for(var/obj/effect/decal/cleanable/gs13_juice/existing in floor)
		if(existing.type == decal_type)
			puddle = existing
			break
	if(!puddle)
		puddle = new decal_type(floor)
	if(streak || amount <= 0)
		return 0
	amount = min(amount, reagents.get_reagent_amount("blueberry_juice"))
	var/list/payload = list()
	for(var/datum/disease/virus as anything in viruses)
		payload += virus.Copy()
	var/before = puddle.reagents.get_reagent_amount("blueberry_juice")
	puddle.reagents.add_reagent("blueberry_juice", amount, length(payload) ? list("viruses" = payload) : null, reagents.chem_temp)
	var/moved = puddle.reagents.get_reagent_amount("blueberry_juice") - before
	reagents.remove_reagent("blueberry_juice", moved)
	return moved

/obj/effect/decal/cleanable/gs13_juice
	name = "berry juice"
	desc = "It's blue and smells enticingly sweet."
	icon = 'modular_gs/icons/turf/berry_decal.dmi'
	icon_state = "floor1"
	random_icon_states = list("floor1", "floor2", "floor3", "floor4", "floor5", "floor6", "floor7")
	mergeable_decal = FALSE
	container_type = DRAINABLE

/obj/effect/decal/cleanable/gs13_juice/Initialize(mapload)
	. = ..()
	create_reagents(SHORT_REAL_LIMIT)

/obj/effect/decal/cleanable/gs13_juice/streak
	random_icon_states = list("streak1", "streak2", "streak3", "streak4", "streak5")

/datum/status_effect/incapacitating/stun/gs13_burst
	id = "gs13_burst_stun"

/datum/status_effect/incapacitating/stun/gs13_burst/on_apply()
	. = ..()
	if(.)
		RegisterSignal(owner, COMSIG_LIVING_CLEAR_STUNS, PROC_REF(clear_stun))

/datum/status_effect/incapacitating/stun/gs13_burst/proc/clear_stun()
	SIGNAL_HANDLER
	qdel(src)

/datum/status_effect/incapacitating/stun/gs13_burst/on_remove()
	UnregisterSignal(owner, COMSIG_LIVING_CLEAR_STUNS)
	return ..()
