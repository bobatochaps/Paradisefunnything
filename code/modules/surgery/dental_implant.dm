/datum/surgery/dental_implant
	name = "dental implant"
	steps = list(/datum/surgery_step/generic/drill, /datum/surgery_step/insert_pill)
	possible_locs = list(BODY_ZONE_PRECISE_MOUTH)

/datum/surgery/dental_implant/can_start(mob/user, mob/living/carbon/target)
	if(ishuman(target))
		var/mob/living/carbon/human/H = target
		if(!H.check_has_mouth())
			return FALSE
		return TRUE

/datum/surgery_step/insert_pill
	name = "insert pill"
	allowed_tools = list(/obj/item/reagent_containers/pill = 100)
	time = 1.6 SECONDS

/datum/surgery_step/insert_pill/begin_step(mob/living/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery)
	user.visible_message(
		"[user] begins to wedge \the [tool] in [target]'s [parse_zone(target_zone)].",
		SPAN_NOTICE("You begin to wedge [tool] in [target]'s [parse_zone(target_zone)]..."),
		chat_message_type = MESSAGE_TYPE_COMBAT
	)
	return ..()

/datum/surgery_step/insert_pill/end_step(mob/living/user, mob/living/carbon/target, target_zone, obj/item/reagent_containers/pill/tool, datum/surgery/surgery)
	if(!istype(tool))
		return SURGERY_STEP_INCOMPLETE

	var/dental_implants = 0
	for(var/obj/item/reagent_containers/pill in target.contents) // Can't give them more than 4 dental implants.
		dental_implants++
	if(dental_implants >= 4)
		user.visible_message("[user] pulls \the [tool] back out of [target]'s [parse_zone(target_zone)]!", SPAN_NOTICE("You pull \the [tool] back out of [target]'s [parse_zone(target_zone)], there wans't enough room..."), chat_message_type = MESSAGE_TYPE_COMBAT)
		return SURGERY_STEP_INCOMPLETE

	user.drop_item()
	tool.forceMove(target)

	var/datum/action/item_action/hands_free/activate_pill/P = new(tool)
	P.name = "Activate Pill ([tool.name])"
	P.Grant(target)

	user.visible_message("[user] wedges \the [tool] into [target]'s [parse_zone(target_zone)]!", SPAN_NOTICE("You wedge [tool] into [target]'s [parse_zone(target_zone)]."), chat_message_type = MESSAGE_TYPE_COMBAT)
	return SURGERY_STEP_CONTINUE

/datum/action/item_action/hands_free/activate_pill
	name = "Activate Pill"

/datum/action/item_action/hands_free/activate_pill/New(obj/item/Target)
	button_icon = Target.icon
	button_icon_state = Target.icon_state
	return ..()

/datum/action/item_action/hands_free/activate_pill/Trigger(left_click = TRUE)
	if(!..(left_click, FALSE))
		return FALSE
	var/mob/living/carbon/consumer = owner
	var/obj/item/reagent_containers/pill/pill = target
	if(!istype(consumer) || !istype(pill) || QDELETED(pill) || pill.loc != consumer || !pill.reagents)
		return FALSE
	if(ishuman(consumer))
		var/mob/living/carbon/human/human_consumer = consumer
		if(!human_consumer.check_has_mouth())
			return FALSE
	if(consumer.get_gs13_ingestion_free_space() < pill.reagents.total_volume)
		to_chat(owner, SPAN_WARNING("There is not enough room to swallow the implanted pill."))
		return FALSE
	to_chat(owner, SPAN_CAUTION("You grit your teeth and burst the implanted [target]!"))
	add_attack_logs(owner, owner, "Swallowed implanted [target]")
	if(pill.reagents.total_volume && !pill.reagents.gs13_ingest(consumer, pill.reagents.total_volume))
		return FALSE
	if(pill.reagents.total_volume > 0)
		return FALSE
	Remove(owner)
	qdel(target)
	return TRUE

