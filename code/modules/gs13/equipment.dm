/mob/living/carbon/proc/gs13_weight_report()
	calculate_fatness()
	return "[html_encode(name)]: [calculate_weight_in_pounds()] lb ([round(calculate_weight_in_pounds() * LB_TO_KG, 0.1)] kg).<br>Body fat index: [round(fatness, 0.1)] ([get_fatness_level_name(fatness)]).<br>Regular fat: [round(fatness_real, 0.1)]; permanent fat: [round(fatness_perma, 0.1)]; concealed/other: [round(fatness - fatness_real - fatness_perma, 0.1)].<br>Muscle index: [round(muscle, 0.1)].<br>Gain multiplier: [get_weight_gain_rate()]; loss multiplier: [get_weight_loss_rate()]."

/obj/item/portable_weight_scanner
	name = "weight analyzer"
	desc = "A hand-held body scanner capable of distinguishing the composition of someone's body mass."
	icon = 'modular_gs/icons/obj/items/devices.dmi'
	icon_state = "weight-analyzer"
	inhand_icon_state = "healthanalyzer"
	worn_icon_state = "healthanalyzer"
	w_class = WEIGHT_CLASS_SMALL
	slot_flags = ITEM_SLOT_BELT
	flags = CONDUCT | NOBLUDGEON
	materials = list(MAT_METAL = 500, MAT_GLASS = 50)
	origin_tech = "magnets=1;biotech=1"
	new_attack_chain = TRUE

/obj/item/portable_weight_scanner/interact_with_atom(atom/target, mob/living/user, list/modifiers)
	if(!iscarbon(target))
		return ..()
	var/mob/living/carbon/subject = target
	user.visible_message(SPAN_NOTICE("[user] analyzes [subject]'s weight."))
	to_chat(user, chat_box_healthscan(subject.gs13_weight_report()))
	return ITEM_INTERACT_COMPLETE

/obj/structure/scale
	name = "weighing scale"
	desc = "Step onto the platform to measure your weight."
	icon = 'modular_gs/icons/obj/scale.dmi'
	icon_state = "scale"
	anchored = TRUE
	max_integrity = 250

/obj/structure/scale/Initialize(mapload)
	. = ..()
	var/list/connections = list(COMSIG_ATOM_ENTERED = PROC_REF(on_entered))
	AddElement(/datum/element/connect_loc, connections)

/obj/structure/scale/proc/on_entered(datum/source, atom/movable/entered)
	SIGNAL_HANDLER
	if(!iscarbon(entered))
		return
	var/mob/living/carbon/subject = entered
	to_chat(subject, SPAN_NOTICE(subject.gs13_weight_report()))

/obj/structure/scale/attack_hand(mob/user)
	. = ..()
	if(.)
		return
	for(var/mob/living/carbon/subject in loc)
		to_chat(user, SPAN_NOTICE(subject.gs13_weight_report()))

/obj/structure/scale/wrench_act(mob/living/user, obj/item/tool)
	. = TRUE
	if(tool.use_tool(src, user, 2 SECONDS, volume = tool.tool_volume))
		new /obj/item/stack/sheet/metal(get_turf(src), 3)
		qdel(src)

/obj/item/bluespace_belt
	name = "bluespace belt"
	desc = "A belt that uses bluespace to conceal body mass. Activate it in hand to adjust the amount concealed."
	icon = 'modular_gs/icons/obj/clothing/bluespace_belt.dmi'
	worn_icon = 'modular_gs/icons/mob/clothing/bsbelts.dmi'
	icon_state = "bluespace_belt"
	slot_flags = ITEM_SLOT_BELT
	new_attack_chain = TRUE
	var/hidden_percentage = 100
	var/mob/living/carbon/wearer

/obj/item/bluespace_belt/equipped(mob/user, slot, initial = FALSE)
	. = ..()
	if(wearer)
		wearer.hider_remove(src)
		wearer = null
	if(iscarbon(user) && slot == ITEM_SLOT_BELT)
		wearer = user
		wearer.hider_add(src)

/obj/item/bluespace_belt/dropped(mob/user, silent = FALSE)
	if(wearer)
		wearer.hider_remove(src)
		wearer = null
	return ..()

/obj/item/bluespace_belt/Destroy()
	if(wearer)
		wearer.hider_remove(src)
		wearer = null
	return ..()

/obj/item/bluespace_belt/proc/fat_hide(mob/living/carbon/subject)
	return -subject.fatness_real * hidden_percentage / 100

/obj/item/bluespace_belt/activate_self(mob/user)
	if(..())
		return ITEM_INTERACT_COMPLETE
	var/amount = tgui_input_number(user, "Percentage of regular body fat to conceal. Permanent weight cannot be concealed.", "Bluespace belt", hidden_percentage, 100, 0)
	if(isnull(amount) || QDELETED(src) || loc != user)
		return ITEM_INTERACT_COMPLETE
	hidden_percentage = clamp(amount, 0, 100)
	if(wearer)
		wearer.calculate_fatness()
	return ITEM_INTERACT_COMPLETE

/datum/design/portable_weight_scanner
	name = "Weight Analyzer"
	id = "gs13_weight_analyzer"
	build_type = AUTOLATHE
	materials = list(MAT_METAL = 500, MAT_GLASS = 50)
	build_path = /obj/item/portable_weight_scanner
	category = list("initial", "Medical")

/datum/supply_packs/medical/gs13_weighing
	name = "Body Composition Equipment Crate"
	contains = list(/obj/item/portable_weight_scanner, /obj/item/portable_weight_scanner, /obj/structure/scale)
	cost = 250
	containername = "body composition equipment crate"
