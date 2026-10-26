// Source-owned fluid storage/production on optional native anatomy.
/mob/living/carbon/human
	var/gs13_anatomy_dna_key

/mob/living/carbon/human/proc/initialize_gs13_anatomy(list/settings)
	if(!dna)
		return
	dna.gs13_anatomy = gs13_anatomy_blueprint(settings)
	dna.gs13_anatomy_revision++
	rebuild_gs13_fluid_anatomy()

/mob/living/carbon/proc/update_gs13_fluid_sizes()
	return

/mob/living/carbon/human/update_gs13_fluid_sizes()
	var/obj/item/organ/internal/gs13_fluid_organ/breasts/breasts = get_organ_slot(GS13_ORGAN_BREASTS)
	if(istype(breasts) && breasts.owner == src)
		breasts.update_size_from_weight(gs13_weight_stage(fatness))

/// A live maximum edit changes the constraint and birth default without
/// replacing the organ or its base/product/lactation. Excess fluid uses the
/// same bounded proportional removal as any other reservoir reduction.
/mob/living/carbon/human/proc/update_gs13_anatomy_limits(list/settings)
	var/limit = settings?["max_breast_size"]
	if(!isnum(limit) || !GS13_IS_FINITE(limit))
		return
	limit = clamp(limit, 0, 80)
	if(dna?.gs13_anatomy)
		dna.gs13_anatomy["max_breast_size"] = limit
	var/obj/item/organ/internal/gs13_fluid_organ/breasts/breasts = get_organ_slot(GS13_ORGAN_BREASTS)
	if(istype(breasts) && breasts.owner == src)
		breasts.gs13_max_size = limit
		breasts.update_size_from_weight(gs13_weight_stage(fatness))

/// Ordinary appearance refreshes must not regrow removed or modified organs.
/mob/living/carbon/human/proc/sync_gs13_anatomy_from_dna()
	if(dna && gs13_anatomy_dna_key != "[dna.UID()]:[dna.gs13_anatomy_revision]")
		rebuild_gs13_fluid_anatomy()

/mob/living/carbon/human/proc/rebuild_gs13_fluid_anatomy()
	for(var/obj/item/organ/internal/gs13_fluid_organ/organ in internal_organs.Copy())
		qdel(organ)
	if(!dna)
		return
	gs13_anatomy_dna_key = "[dna.UID()]:[dna.gs13_anatomy_revision]"
	var/list/blueprint = dna.gs13_anatomy
	if(!GLOB.configuration.gs13?.fluid_anatomy_enabled || !blueprint?["custom_anatomy"] || !istype(dna.species, /datum/species/human) || HAS_TRAIT(src, TRAIT_SKELETONIZED))
		return
	var/list/types = list("anatomy_breasts" = /obj/item/organ/internal/gs13_fluid_organ/breasts, "anatomy_testicles" = /obj/item/organ/internal/gs13_fluid_organ/testicles, "anatomy_vagina" = /obj/item/organ/internal/gs13_fluid_organ/vagina)
	for(var/key in types)
		if(!blueprint[key])
			continue
		var/obj/item/organ/internal/gs13_fluid_organ/path = types[key]
		var/obj/item/organ/external/part = get_organ(initial(path.parent_organ))
		if(!part || part.is_robotic())
			continue
		var/obj/item/organ/internal/gs13_fluid_organ/organ = new path(null, src)
		organ.configure_from_blueprint(blueprint)

/obj/item/organ/internal/gs13_fluid_organ
	name = "fluid-producing organ"
	desc = "An organ with a fluid reservoir."
	unremovable = TRUE
	max_damage = 100
	actions_types = list(/datum/action/item_action/gs13_collect_fluid)
	var/internal_fluid_datum
	var/internal_fluid_maximum = 10
	var/collecting = FALSE

/obj/item/organ/internal/gs13_fluid_organ/Initialize(mapload, mob/living/carbon/holder)
	. = ..()
	create_reagents(internal_fluid_maximum)
	for(var/datum/action/action as anything in actions)
		action.name = "Collect [name] fluid"

/obj/item/organ/internal/gs13_fluid_organ/proc/configure_from_blueprint(list/blueprint)
	return

/obj/item/organ/internal/gs13_fluid_organ/proc/fluid_id()
	if(!ispath(internal_fluid_datum, /datum/reagent))
		return null
	var/datum/reagent/fluid = internal_fluid_datum
	return initial(fluid.id)

/obj/item/organ/internal/gs13_fluid_organ/proc/set_fluid_capacity(capacity)
	if(!isnum(capacity) || !GS13_IS_FINITE(capacity))
		return FALSE
	internal_fluid_maximum = clamp(capacity, 0, 3500)
	// Never leave old liquid above a reduced reservoir's actual capacity.
	if(reagents.total_volume > internal_fluid_maximum)
		reagents.remove_all(reagents.total_volume - internal_fluid_maximum)
	reagents.maximum_volume = internal_fluid_maximum
	return TRUE

/obj/item/organ/internal/gs13_fluid_organ/proc/production_allowed()
	return !QDELETED(src) && owner && !QDELETED(owner) && owner.get_organ_slot(slot) == src && owner.stat != DEAD && !(status & ORGAN_DEAD) && GLOB.configuration.gs13?.fluid_anatomy_enabled && owner.gs13_preferences["fluid_production"]

/// Central bounded production API; life processing separately requires a client.
/obj/item/organ/internal/gs13_fluid_organ/proc/produce_fluid(amount)
	if(!production_allowed() || !isnum(amount) || !GS13_IS_FINITE(amount) || amount <= 0 || !fluid_id())
		return 0
	var/before = reagents.total_volume
	reagents.add_reagent(fluid_id(), min(amount, reagents.maximum_volume - before))
	return reagents.total_volume - before

/obj/item/organ/internal/gs13_fluid_organ/examine(mob/user)
	. = ..()
	var/datum/reagent/prototype = GLOB.chemical_reagents_list[fluid_id()]
	if(prototype)
		. += SPAN_NOTICE("Fluid product: [prototype.name]. Reservoir: [round(reagents.total_volume, 0.1)]/[internal_fluid_maximum] units.")

/obj/item/organ/internal/gs13_fluid_organ/proc/can_collect(mob/living/carbon/human/user, obj/item/reagent_containers/container)
	return production_allowed() && user == owner && !user.incapacitated() && !QDELETED(container) && user.get_active_hand() == container && container.is_open_container() && container.reagents && container.reagents.total_volume < container.reagents.maximum_volume && reagents.total_volume > 0

/obj/item/organ/internal/gs13_fluid_organ/proc/collect_dose(mob/living/carbon/human/user, obj/item/reagent_containers/container)
	if(!can_collect(user, container))
		return 0
	var/before = reagents.total_volume
	reagents.trans_to(container, min(10, before, container.reagents.maximum_volume - container.reagents.total_volume))
	return max(0, before - reagents.total_volume)

/obj/item/organ/internal/gs13_fluid_organ/ui_action_click(mob/user, actiontype)
	if(collecting || owner != user)
		return FALSE
	var/obj/item/reagent_containers/container = user.get_active_hand()
	if(!istype(container) || !can_collect(user, container))
		to_chat(user, SPAN_NOTICE("Hold an open container with room for a fluid sample."))
		return FALSE
	collecting = TRUE
	while(can_collect(user, container))
		if(!do_after(user, 1 SECONDS, target = user) || !collect_dose(user, container))
			break
	if(!QDELETED(src))
		collecting = FALSE
	return TRUE

/datum/action/item_action/gs13_collect_fluid
	name = "Collect produced fluid"
	desc = "Collect a sample into an open container in your active hand."
	check_flags = NONE

/obj/item/organ/internal/gs13_fluid_organ/breasts
	name = "breasts"
	icon = 'modular_gs/icons/upstream/fluid_organs/breasts.dmi'
	icon_state = "breasts"
	organ_tag = GS13_ORGAN_BREASTS
	slot = GS13_ORGAN_BREASTS
	parent_organ = BODY_ZONE_CHEST
	internal_fluid_datum = /datum/reagent/consumable/breast_milk
	internal_fluid_maximum = 120
	var/lactates = FALSE
	var/gs13_base_size = 1
	var/gs13_size = 1
	var/gs13_max_size = 80
	var/gs13_arrangement_multiplier = 2
	var/gs13_visual_style = "Smooth"

/obj/item/organ/internal/gs13_fluid_organ/breasts/configure_from_blueprint(list/blueprint)
	gs13_visual_style = blueprint["breasts_style"] == "Classic" ? "Classic" : "Smooth"
	gs13_base_size = isnum(blueprint["breasts_size"]) && GS13_IS_FINITE(blueprint["breasts_size"]) ? clamp(blueprint["breasts_size"], 0.5, 80) : 1
	gs13_max_size = isnum(blueprint["max_breast_size"]) && GS13_IS_FINITE(blueprint["max_breast_size"]) ? clamp(blueprint["max_breast_size"], 0, 80) : 80
	gs13_arrangement_multiplier = blueprint["breasts_type"] == "Sextuple" ? 3 : (blueprint["breasts_type"] == "Quadruple" ? 2.5 : 2)
	update_size_from_weight(gs13_weight_stage(owner?.fatness))
	var/list/products = gs13_breast_products()
	internal_fluid_datum = products[blueprint["breast_produce"]]
	lactates = blueprint["breasts_lactation"]

/obj/item/organ/internal/gs13_fluid_organ/breasts/proc/update_size_from_weight(weight_stage)
	if(QDELETED(src) || !reagents || !isnum(weight_stage) || !GS13_IS_FINITE(weight_stage))
		return FALSE
	gs13_size = min(gs13_base_size + clamp(weight_stage, 0, 9), gs13_max_size, 80)
	return set_fluid_capacity(gs13_size * gs13_arrangement_multiplier * 60)

/obj/item/organ/internal/gs13_fluid_organ/breasts/on_life()
	if(lactates && owner?.client && production_allowed())
		produce_fluid(reagents.maximum_volume * 0.05 * 2)

/obj/item/organ/internal/gs13_fluid_organ/testicles
	name = "testicles"
	icon = 'modular_gs/icons/upstream/fluid_organs/testicles.dmi'
	icon_state = "testicles"
	organ_tag = GS13_ORGAN_TESTICLES
	slot = GS13_ORGAN_TESTICLES
	parent_organ = BODY_ZONE_PRECISE_GROIN
	internal_fluid_datum = /datum/reagent/consumable/cum

/obj/item/organ/internal/gs13_fluid_organ/testicles/configure_from_blueprint(list/blueprint)
	set_fluid_capacity(blueprint["balls_size"] * 20)
	reagents.add_reagent(fluid_id(), internal_fluid_maximum)

/obj/item/organ/internal/gs13_fluid_organ/vagina
	name = "vagina"
	icon = 'modular_gs/icons/upstream/fluid_organs/vagina.dmi'
	icon_state = "vagina"
	organ_tag = GS13_ORGAN_VAGINA
	slot = GS13_ORGAN_VAGINA
	parent_organ = BODY_ZONE_PRECISE_GROIN
	internal_fluid_datum = /datum/reagent/consumable/femcum

// Ordinary native consumable nutrition remains separate from weight gain.
/datum/reagent/consumable/breast_milk
	name = "Breast milk"
	id = "breast_milk"
	description = "Milk produced by mammary glands."
	color = "#FFFFFF"
	drink_name = "Glass of breast milk"
	drink_desc = "A glass of milk."
	drink_icon = "glass_white"

/datum/reagent/consumable/cum
	name = "Semen"
	id = "cum"
	description = "A reproductive fluid."
	color = "#FFFFFF"
	drink_name = "Glass of seminal fluid"
	drink_desc = "A fluid sample."
	drink_icon = "glass_white"

/datum/reagent/consumable/femcum
	name = "Vaginal fluid"
	id = "femcum"
	description = "A reproductive fluid."
	color = "#FFFFFFB0"
	drink_name = "Glass of vaginal fluid"
	drink_desc = "A fluid sample."
	drink_icon = "glass_white"
