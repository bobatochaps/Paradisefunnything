// GS13 Starshine drinks, using native chemistry, lighting, vending, and cargo.
/datum/reagent/consumable/starshine
	name = "Starshine Nova"
	id = "starshine"
	description = "A popular strawberry-flavored soft drink that makes its drinker shine."
	color = "#FFB6B6"
	taste_description = "liquid stars"
	process_flags = ORGANIC | SYNTHETIC
	nutriment_factor = 5 * REAGENTS_METABOLISM
	drink_icon_file = 'modular_gs/icons/obj/starshine.dmi'
	drink_icon = "starshine_r"
	drink_name = "starshine nova"
	drink_desc = "The only drink that makes you shine!"
	var/obj/effect/gs13_starshine_light/light_holder
	var/mob/living/carbon/bound_body

/datum/reagent/consumable/starshine/update_gs13_transformation(mob/living/carbon/subject)
	if(bound_body != subject)
		unbind_body()
		bound_body = subject
		RegisterSignal(bound_body, list(COMSIG_MOB_DEATH, COMSIG_LIVING_REVIVE, COMSIG_AFTER_SPECIES_CHANGE), PROC_REF(on_body_changed))
	if(subject.stat == DEAD || !subject.can_gs13_transform_with(src))
		QDEL_NULL(light_holder)
		return
	if(QDELETED(light_holder))
		light_holder = new(subject)
	else if(light_holder.loc != subject)
		light_holder.forceMove(subject)
	// The native body holder normally caps volume at 1000. Bound admin doses too.
	light_holder.set_light(min(10, 3 + volume * 0.007), min(3.7, 0.7 + volume * 0.003), color)

/datum/reagent/consumable/starshine/proc/on_body_changed()
	SIGNAL_HANDLER
	if(!QDELETED(src) && !QDELETED(bound_body))
		update_gs13_transformation(bound_body)

/datum/reagent/consumable/starshine/proc/unbind_body()
	if(bound_body)
		UnregisterSignal(bound_body, list(COMSIG_MOB_DEATH, COMSIG_LIVING_REVIVE, COMSIG_AFTER_SPECIES_CHANGE))
	bound_body = null
	QDEL_NULL(light_holder)

/datum/reagent/consumable/starshine/Destroy()
	unbind_body()
	return ..()

/obj/effect/gs13_starshine_light
	name = "Starshine glow"
	invisibility = INVISIBILITY_ABSTRACT
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT

/datum/reagent/consumable/starshine/yellow
	name = "Starshine Yellow Dwarf"
	id = "starshine_yellow"
	description = "The popular Starshine soft drink, now lemon-flavored."
	color = "#FFFDAA"
	drink_icon = "starshine_y"
	drink_name = "starshine yellow dwarf"

/datum/reagent/consumable/starshine/orange
	name = "Starshine Orange Giant"
	id = "starshine_orange"
	description = "Expand your taste buds with this orange-flavored Starshine."
	color = "#FFDAB3"
	drink_icon = "starshine_o"
	drink_name = "starshine orange giant"

/datum/reagent/consumable/starshine/blue
	name = "Starshine Neutron"
	id = "starshine_blue"
	description = "A new horizon of Starshine flavor with neutron."
	color = "#6EFFFF"
	drink_icon = "starshine_b"
	drink_name = "starshine neutron"
	drink_desc = "The only drink that makes you shine! Do not consume more than one bottle of Starshine Neutron a day."
	overdose_threshold = 100
	allowed_overdose_process = TRUE
	addiction_threshold = 15
	addiction_chance = 100
	minor_addiction = TRUE

/datum/reagent/consumable/starshine/blue/update_gs13_transformation(mob/living/carbon/subject)
	..()
	if(subject.can_gs13_transform_with(src) && subject.check_weight_prefs(FATTENING_TYPE_CHEM))
		subject.set_gs13_body_change(src, gs13_volume_to_fatness(volume))
	else
		subject.remove_gs13_body_change(src)

/datum/reagent/consumable/starshine/blue/overdose_start(mob/living/subject)
	to_chat(subject, SPAN_WARNING("You have had too much Starshine Neutron."))
	// The source's persistent fluid-organ changes require its anatomy adapters.

/datum/reagent/consumable/starshine/blue/addiction_act_stage2(mob/living/subject)
	to_chat(subject, SPAN_NOTICE("You feel dim and miss Starshine Neutron."))
	return STATUS_UPDATE_NONE

/datum/reagent/consumable/starshine/blue/addiction_act_stage3(mob/living/subject)
	to_chat(subject, SPAN_NOTICE("You miss shining and crave Starshine Neutron."))
	return STATUS_UPDATE_NONE

/datum/reagent/consumable/starshine/blue/addiction_act_stage4(mob/living/subject)
	to_chat(subject, SPAN_NOTICE("You want to glow brightly again."))
	return STATUS_UPDATE_NONE

/datum/reagent/consumable/starshine/blue/addiction_act_stage5(mob/living/subject)
	return addiction_act_stage4(subject)

/datum/chemical_reaction/gs13_starshine
	name = "Starshine Nova"
	id = "gs13_starshine"
	result = "starshine"
	required_reagents = list("berryjuice" = 1, "sodawater" = 1, "sugar" = 1)
	result_amount = 3

/datum/chemical_reaction/gs13_starshine_yellow
	name = "Starshine Yellow Dwarf"
	id = "gs13_starshine_yellow"
	result = "starshine_yellow"
	required_reagents = list("lemonjuice" = 1, "sodawater" = 1, "sugar" = 1)
	result_amount = 3

/datum/chemical_reaction/gs13_starshine_orange
	name = "Starshine Orange Giant"
	id = "gs13_starshine_orange"
	result = "starshine_orange"
	required_reagents = list("orangejuice" = 1, "sodawater" = 1, "sugar" = 1)
	result_amount = 3

/datum/chemical_reaction/gs13_starshine_blue
	name = "Starshine Neutron"
	id = "gs13_starshine_blue"
	result = "starshine_blue"
	required_reagents = list("bluespace_dust" = 1, "sodawater" = 1, "sugar" = 1)
	result_amount = 3

/obj/item/reagent_containers/drinks/starshine
	name = "Starshine Nova"
	desc = "The only drink that makes you shine!"
	icon = 'modular_gs/icons/obj/starshine.dmi'
	icon_state = "starshine_r"
	inhand_icon_state = "drinking_glass"
	lefthand_file = 'icons/goonstation/mob/inhands/items_lefthand.dmi'
	righthand_file = 'icons/goonstation/mob/inhands/items_righthand.dmi'
	list_reagents = list("starshine" = 50)
	volume = 50

/obj/item/reagent_containers/drinks/starshine/on_reagent_change()
	icon_state = reagents.total_volume ? initial(icon_state) : "[initial(icon_state)]-empty"

/obj/item/reagent_containers/drinks/starshine/yellow
	name = "Starshine Yellow Dwarf"
	icon_state = "starshine_y"
	list_reagents = list("starshine_yellow" = 50)

/obj/item/reagent_containers/drinks/starshine/orange
	name = "Starshine Orange Giant"
	icon_state = "starshine_o"
	list_reagents = list("starshine_orange" = 50)

/obj/item/reagent_containers/drinks/starshine/blue
	name = "Starshine Neutron"
	desc = "The only drink that makes you shine! Do not consume more than one bottle of Starshine Neutron a day."
	icon_state = "starshine_b"
	list_reagents = list("starshine_blue" = 50)

/obj/machinery/economy/vending/starshine
	name = "Starshine Vending Machine"
	desc = "Starshine's cola machine, for drinks that will make you glow!"
	icon = 'modular_gs/icons/obj/vending.dmi'
	icon_state = "starshine"
	category = VENDOR_TYPE_DRINK
	slogan_list = list("Shine like a star, with Starshine!")
	ads_list = list("Shine on, little star!")
	products = list(/obj/item/reagent_containers/drinks/starshine = 30, /obj/item/reagent_containers/drinks/starshine/yellow = 30, /obj/item/reagent_containers/drinks/starshine/orange = 30, /obj/item/reagent_containers/drinks/starshine/blue = 10)
	prices = list(/obj/item/reagent_containers/drinks/starshine = 60, /obj/item/reagent_containers/drinks/starshine/yellow = 60, /obj/item/reagent_containers/drinks/starshine/orange = 60, /obj/item/reagent_containers/drinks/starshine/blue = 120)
	refill_canister = /obj/item/vending_refill/starshine

/obj/machinery/economy/vending/starshine/update_overlays()
	. = ..()
	if(panel_open && !get_vending_overlay_state(icon_panel || icon_state, "panel"))
		. += mutable_appearance('icons/obj/vending.dmi', "thin_vendor_panel")

/obj/item/vending_refill/starshine
	machine_name = "Starshine Vendor"
	icon = 'modular_gs/icons/obj/vending_restock.dmi'
	icon_state = "refill_starshine"

/datum/supply_packs/vending/starshine
	name = "Starshine Vendor Supply Crate"
	cost = 100
	contains = list(/obj/item/vending_refill/starshine)
	containername = "starshine vendor supply crate"
