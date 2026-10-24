// Berrification, the blueberry mutation, and native juice collection.
/datum/symptom/gs13_berry
	name = "Berrification"
	stealth = -5
	resistance = -4
	stage_speed = 1
	transmissibility = 6
	level = 7
	severity = 4
	activation_prob = 100
	var/next_production = 0
	var/datum/disease/advance/active_disease
	var/mob/living/carbon/host
	var/datum/component/gs13_berry_sound/sound_controller

/datum/symptom/gs13_berry/proc/eligible_host(mob/living/carbon/subject)
	if(!istype(subject) || !subject.gs13_preferences["blueberry_inflation"])
		return FALSE
	if(ishuman(subject))
		var/mob/living/carbon/human/human_subject = subject
		return human_subject.can_metabolize(GLOB.chemical_reagents_list["blueberry_juice"])
	return TRUE

/datum/symptom/gs13_berry/Start(datum/disease/advance/disease)
	. = ..()
	if(!eligible_host(disease.affected_mob))
		return
	End(active_disease)
	active_disease = disease
	host = disease.affected_mob
	RegisterSignal(host, COMSIG_GS13_REAGENTS_CHANGED, PROC_REF(on_dose_changed))
	RegisterSignal(host, COMSIG_PARENT_QDELETING, PROC_REF(on_host_deleted))
	host.reagents.add_reagent("blueberry_juice", max(1, disease.totalStageSpeed()) * 10)
	next_production = world.time + 20 SECONDS
	refresh_sound()

/datum/symptom/gs13_berry/symptom_act(datum/disease/advance/disease, unmitigated)
	if(!eligible_host(disease.affected_mob))
		return
	if(!active_disease)
		Start(disease)
		return
	if(!host.reagents.has_reagent("blueberry_juice"))
		disease.cure(FALSE)
		return
	if(world.time < next_production || unmitigated <= 0)
		return
	next_production = world.time + 20 SECONDS
	host.reagents.add_reagent("blueberry_juice", max(disease.totalStageSpeed(), 0.2) * disease.stage * unmitigated)
	to_chat(host, SPAN_WARNING(disease.stage >= 5 ? "A deep slosh comes from inside you. You taste blueberries." : "You feel oddly full and taste blueberries."))
	refresh_sound()

/datum/symptom/gs13_berry/proc/on_dose_changed(datum/source)
	SIGNAL_HANDLER
	if(!host || QDELETED(host) || QDELETED(active_disease))
		return
	if(!eligible_host(host) || !host.reagents?.has_reagent("blueberry_juice"))
		active_disease.cure(FALSE)
		return
	refresh_sound()

/datum/symptom/gs13_berry/proc/on_host_deleted(datum/source)
	SIGNAL_HANDLER
	End(active_disease)

/datum/symptom/gs13_berry/proc/refresh_sound()
	if(host && !QDELETED(host) && eligible_host(host) && host.reagents?.has_reagent("blueberry_juice"))
		sound_controller = host.LoadComponent(/datum/component/gs13_berry_sound)
		sound_controller.add_source(src)

/datum/symptom/gs13_berry/End(datum/disease/advance/disease)
	. = ..()
	if(host)
		UnregisterSignal(host, list(COMSIG_GS13_REAGENTS_CHANGED, COMSIG_PARENT_QDELETING))
	if(!QDELETED(sound_controller))
		sound_controller.remove_source(src)
	sound_controller = null
	host = null
	active_disease = null

/datum/symptom/gs13_berry/Destroy()
	End(active_disease)
	return ..()

/datum/looping_sound/gs13_blueberry
	mid_sounds = list('modular_gs/sound/effects/inflation/berryloop.ogg')
	mid_length = 8 SECONDS
	volume = 45

// The source has one loop per body. Multiple infections share this controller.
/datum/component/gs13_berry_sound
	dupe_mode = COMPONENT_DUPE_UNIQUE
	var/list/sources = list()
	var/datum/looping_sound/gs13_blueberry/inflation_loop

/datum/component/gs13_berry_sound/Initialize()
	if(!iscarbon(parent))
		return COMPONENT_INCOMPATIBLE
	inflation_loop = new(list(parent))

/datum/component/gs13_berry_sound/RegisterWithParent()
	RegisterSignal(parent, list(COMSIG_MOB_DEATH, COMSIG_LIVING_REVIVE, COMSIG_GS13_REAGENTS_CHANGED), PROC_REF(refresh_sound))

/datum/component/gs13_berry_sound/UnregisterFromParent()
	UnregisterSignal(parent, list(COMSIG_MOB_DEATH, COMSIG_LIVING_REVIVE, COMSIG_GS13_REAGENTS_CHANGED))

/datum/component/gs13_berry_sound/proc/add_source(datum/source)
	if(!(source in sources))
		sources |= source
		RegisterSignal(source, COMSIG_PARENT_QDELETING, PROC_REF(on_source_deleted))
	refresh_sound()

/datum/component/gs13_berry_sound/proc/remove_source(datum/source)
	UnregisterSignal(source, COMSIG_PARENT_QDELETING)
	sources -= source
	if(!length(sources))
		qdel(src)

/datum/component/gs13_berry_sound/proc/on_source_deleted(datum/source)
	SIGNAL_HANDLER
	remove_source(source)

/datum/component/gs13_berry_sound/proc/refresh_sound()
	SIGNAL_HANDLER
	var/mob/living/carbon/subject = parent
	if(!QDELETED(subject) && subject.stat != DEAD && subject.gs13_preferences["blueberry_inflation"] && subject.reagents?.has_reagent("blueberry_juice") && length(sources))
		inflation_loop.start()
	else
		inflation_loop.stop()

/datum/component/gs13_berry_sound/Destroy(force = FALSE, silent = FALSE)
	for(var/datum/source as anything in sources)
		UnregisterSignal(source, COMSIG_PARENT_QDELETING)
	sources.Cut()
	UnregisterFromParent()
	QDEL_NULL(inflation_loop)
	return ..()

/datum/disease/advance/gs13_berry/New(datum/disease/advance/to_copy, _event = FALSE, copy_stage = FALSE)
	if(!to_copy)
		name = "Berrification"
		symptoms = list(new /datum/symptom/gs13_berry)
	return ..()

/obj/item/seeds/berry/blueberry
	name = "pack of blueberry seeds"
	desc = "These seeds grow into blueberry bushes."
	species = "blueberry"
	plantname = "Blueberry Bush"
	product = /obj/item/food/grown/berries/blueberry
	mutatelist = list()
	reagents_add = list("blueberry_juice" = 0.1)
	potency = 1
	yield = 1
	production = 10
	rarity = 30
	icon = 'modular_gs/icons/obj/hydroponics/seeds.dmi'
	icon_state = "seed-blueberry"
	growing_icon = 'modular_gs/icons/obj/hydroponics/growing.dmi'
	icon_grow = "berry-grow"
	icon_dead = "berry-dead"
	icon_harvest = "blueberry-harvest"

/obj/item/food/grown/berries/blueberry
	seed = /obj/item/seeds/berry/blueberry
	name = "bunch of blueberries"
	desc = "Taste so good, you might turn blue!"
	icon = 'modular_gs/icons/obj/hydroponics/harvest.dmi'
	icon_state = "blueberrypile"
	filling_color = "#5d00c7"
	tastes = list("blueberry" = 1)
	distill_reagent = null
	wine_power = 0.5

// Source secondary-click collection maps to Paradise's grab intent. Every dose
// rechecks the held container, its lid/capacity, the target, and adjacency.
/obj/item/reagent_containers/glass/proc/can_collect_gs13_juice(mob/living/carbon/human/target, mob/living/user)
	return !QDELETED(target) && !QDELETED(user) && !QDELETED(src) && user.get_active_hand() == src && user.Adjacent(target) && !user.incapacitated() && is_open_container() && reagents && reagents.total_volume < reagents.maximum_volume && target.reagents?.has_reagent("blueberry_juice") && amount_per_transfer_from_this > 0

/obj/item/reagent_containers/glass/proc/collect_gs13_juice_dose(mob/living/carbon/human/target, mob/living/user)
	if(!can_collect_gs13_juice(target, user))
		return 0
	var/amount = min(10, amount_per_transfer_from_this, target.reagents.get_reagent_amount("blueberry_juice"), reagents.maximum_volume - reagents.total_volume)
	var/moved = target.reagents.trans_id_to(src, "blueberry_juice", amount)
	if(moved && length(target.viruses))
		AddComponent(/datum/component/viral_contamination, target.viruses)
	return moved

/obj/item/reagent_containers/glass/proc/collect_gs13_juice(mob/living/carbon/human/target, mob/living/user)
	while(can_collect_gs13_juice(target, user) && do_after(user, 1 SECONDS, target = target))
		var/moved = collect_gs13_juice_dose(target, user)
		if(!moved)
			break
		to_chat(user, SPAN_NOTICE("You collect [moved] units of juice from [target]."))
		if(target != user)
			to_chat(target, SPAN_NOTICE("[user] collects some of your blueberry juice."))
