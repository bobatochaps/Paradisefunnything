// Feeding tubes use Paradise's cyborg hypospray, injection checks, and radial UI.
/obj/item/reagent_containers/borghypo/medical/feeding_tube
	parent_type = /obj/item/reagent_containers/borghypo
	name = "cyborg feeding tube"
	desc = "A cyborg-mounted nutrient synthesizer and injector. Activate it to choose a reagent."
	icon = 'modular_gs/icons/obj/feeding_tube.dmi'
	icon_state = "borg_tube"
	volume = 25
	amount_per_transfer_from_this = 5
	possible_transfer_amounts = list(2, 5)
	reagent_selected = "cream"
	reagent_ids = list("cream", "milk", "nutriment")
	reagent_ids_emagged = list()
	charge_cost = 75 // Source 0.075 standard cells, scaled to Paradise's 1,000-unit cell.
	refill_delay = 5 // SSobj processes every two seconds: refill on its sixth call.
	var/upgraded = FALSE
	// Blueberry juice and Starshine Neutron require their remaining transformation systems.
	var/list/expanded_reagent_ids = list("alien_honey", "pinkmilk", "chocolate_milk", "weak_lipoifier")

/obj/item/reagent_containers/borghypo/medical/feeding_tube/refill_hypo(mob/living/silicon/robot/user, quick = FALSE)
	if(quick)
		return ..()
	charge_tick = 0
	if(!istype(user) || !user.cell)
		return
	for(var/reagent_id in reagent_ids)
		var/missing = volume - reagent_ids[reagent_id]
		if(missing <= 0)
			continue
		if(!user.cell.use(charge_cost))
			return
		reagent_ids[reagent_id] += min(missing, 5)

/obj/item/reagent_containers/borghypo/medical/feeding_tube/get_radial_contents()
	var/list/choices = list()
	for(var/reagent_id in reagent_ids)
		var/datum/reagent/reagent = GLOB.chemical_reagents_list[reagent_id]
		var/image/choice = image(icon = icon, icon_state = "borg_tube")
		choice.color = reagent.color
		choices[reagent_id] = choice
	return choices

/obj/item/reagent_containers/borghypo/medical/feeding_tube/proc/upgrade_hypo()
	if(upgraded)
		return FALSE
	upgraded = TRUE
	for(var/reagent_id in expanded_reagent_ids)
		reagent_ids[reagent_id] = volume
	return TRUE

/obj/item/reagent_containers/borghypo/medical/feeding_tube/proc/remove_hypo_upgrade()
	if(!upgraded || !length(expanded_reagent_ids))
		return FALSE
	reagent_ids -= expanded_reagent_ids
	if(!(reagent_selected in reagent_ids))
		reagent_selected = initial(reagent_selected)
	upgraded = FALSE
	return TRUE

/obj/item/reagent_containers/borghypo/medical/feeding_tube/hacked
	name = "hacked cyborg feeding tube"
	desc = "A modified nutrient synthesizer and injector with additional weight-altering chemicals."
	reagent_ids = list("cream", "milk", "nutriment", "alien_honey", "pinkmilk", "chocolate_milk", "weak_lipoifier", "lipoifier", "micro_calorite", "fermi_fat")
	expanded_reagent_ids = list()
	upgraded = TRUE

/obj/item/borg/upgrade/feeding_tube
	name = "cyborg feeding tube module"
	desc = "Adds a nutrient synthesizer and injector to the cyborg's selected module."
	icon_state = "cyborg_upgrade3"
	require_module = TRUE
	items_to_add = list(/obj/item/reagent_containers/borghypo/medical/feeding_tube)
	materials = list(MAT_METAL = 800, MAT_GLASS = 600)
	origin_tech = "biotech=2;programming=2"

/obj/item/borg/upgrade/feeding_tube/pre_install_checks(mob/user, mob/living/silicon/robot/robot)
	if(!robot.module)
		to_chat(user, SPAN_WARNING("The cyborg must select a module before installing [src]."))
		return FALSE
	return ..()

/obj/item/borg/upgrade/feeding_tube/hacked
	name = "illegally upgraded cyborg feeding tube module"
	items_to_add = list(/obj/item/reagent_containers/borghypo/medical/feeding_tube/hacked)

/obj/item/borg/upgrade/feeding_tube_upgrade
	name = "cyborg feeding tube expansion"
	desc = "Expands an existing feeding tube with alien honey, strawberry milk, chocolate milk, and weak lipoifier."
	icon_state = "cyborg_upgrade3"
	require_module = TRUE
	materials = list(MAT_METAL = 800, MAT_GLASS = 600, MAT_SILVER = 400, MAT_CALORITE = 200)
	origin_tech = "biotech=4;programming=3;materials=3"
	var/upgraded_tube_uid

/obj/item/borg/upgrade/feeding_tube_upgrade/pre_install_checks(mob/user, mob/living/silicon/robot/robot)
	if(!robot.module)
		return FALSE
	for(var/obj/item/reagent_containers/borghypo/medical/feeding_tube/tube in robot.module.modules)
		if(!tube.upgraded)
			return ..()
	to_chat(user, SPAN_WARNING("The cyborg needs a feeding tube that has not already been expanded."))
	return FALSE

/obj/item/borg/upgrade/feeding_tube_upgrade/do_install(mob/living/silicon/robot/robot)
	for(var/obj/item/reagent_containers/borghypo/medical/feeding_tube/tube in robot.module.modules)
		if(tube.upgrade_hypo())
			upgraded_tube_uid = tube.UID()
			return TRUE
	return FALSE

/obj/item/borg/upgrade/feeding_tube_upgrade/Destroy()
	var/obj/item/reagent_containers/borghypo/medical/feeding_tube/tube = locateUID(upgraded_tube_uid)
	if(istype(tube) && !QDELETED(tube))
		tube.remove_hypo_upgrade()
	return ..()

/datum/design/borg_feeding_tube
	name = "Cyborg Upgrade (Feeding Tube)"
	id = "borg_feeding_tube"
	build_type = MECHFAB
	build_path = /obj/item/borg/upgrade/feeding_tube
	req_tech = list("biotech" = 2, "programming" = 2)
	materials = list(MAT_METAL = 800, MAT_GLASS = 600)
	construction_time = 10 SECONDS
	category = list("Cyborg Upgrades")

/datum/design/borg_feeding_tube_upgrade
	name = "Cyborg Upgrade (Feeding Tube Expansion)"
	id = "borg_feeding_tube_upgrade"
	build_type = MECHFAB
	build_path = /obj/item/borg/upgrade/feeding_tube_upgrade
	req_tech = list("biotech" = 4, "programming" = 3, "materials" = 3)
	materials = list(MAT_METAL = 800, MAT_GLASS = 600, MAT_SILVER = 400, MAT_CALORITE = 200)
	construction_time = 10 SECONDS
	category = list("Cyborg Upgrades")

/datum/uplink_item/adipowarfare/borg_hacked_feeding_tube
	name = "Hacked Cyborg Feeding Tube Upgrade"
	desc = "Installs a cyborg synthesizer with nutrient solutions, lipoifier, galbanic compound, and micro calorite."
	item = /obj/item/borg/upgrade/feeding_tube/hacked
	reference = "GSTUB"
	cost = 1

/datum/reagent/consumable/alien_honey
	name = "Alien Honey"
	id = "alien_honey"
	description = "A sweet nutrient solution that neither heals nor breaks down into sugar."
	color = "#D3A308"
	nutriment_factor = 15 * REAGENTS_METABOLISM
	taste_description = "sweetness"

/datum/reagent/consumable/pinkmilk
	name = "Strawberry Milk"
	id = "pinkmilk"
	description = "Milk flavored with sweet berry syrup."
	color = "#F76AEB"
	taste_description = "sweet strawberry and milk cream"
	nutriment_factor = 1 * REAGENTS_METABOLISM

/datum/chemical_reaction/gs13_pinkmilk
	name = "Strawberry Milk"
	id = "gs13_pinkmilk"
	result = "pinkmilk"
	required_reagents = list("berryjuice" = 1, "milk" = 1, "sugar" = 1)
	result_amount = 2
