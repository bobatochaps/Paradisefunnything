// Source payloads adapted to Paradise reagent IDs, smoke, and projectile armor.
/obj/item/grenade/chem_grenade/gs13
	stage = 2 // Native READY is local to chem_grenade.dm.
	var/list/first_payload
	var/list/second_payload

/obj/item/grenade/chem_grenade/gs13/Initialize(mapload)
	. = ..()
	for(var/list/payload in list(first_payload, second_payload))
		if(!length(payload))
			continue
		var/obj/item/reagent_containers/glass/beaker/beaker = new(src)
		for(var/reagent_id in payload)
			beaker.reagents.add_reagent(reagent_id, payload[reagent_id])
		beakers += beaker

/obj/item/grenade/chem_grenade/lipoifier
	parent_type = /obj/item/grenade/chem_grenade/gs13
	payload_name = "lipoifier"
	desc = "A smoke grenade containing lipoifier."
	first_payload = list("lipoifier" = 30, "potassium" = 20)
	second_payload = list("phosphorus" = 20, "sugar" = 20)

/obj/item/grenade/chem_grenade/galbanic
	parent_type = /obj/item/grenade/chem_grenade/gs13
	payload_name = "galbanic"
	desc = "A smoke grenade containing galbanic compound."
	first_payload = list("fermi_fat" = 30, "potassium" = 20)
	second_payload = list("phosphorus" = 20, "sugar" = 20)

/obj/item/grenade/chem_grenade/fatmix
	parent_type = /obj/item/grenade/chem_grenade/gs13
	payload_name = "Fattonator"
	desc = "A smoke grenade containing a mixture of lipoifier, galbanic compound, and micro calorite."
	first_payload = list("lipoifier" = 10, "fermi_fat" = 25, "potassium" = 15)
	second_payload = list("phosphorus" = 15, "micro_calorite" = 20, "sugar" = 15)

/obj/item/reagent_containers/glass/beaker/lipoifier
	name = "lipoifier beaker"
	list_reagents = list("lipoifier" = 50)

/obj/item/reagent_containers/glass/beaker/galbanic
	name = "galbanic compound beaker"
	list_reagents = list("fermi_fat" = 50)

/obj/item/reagent_containers/glass/beaker/micro_calorite
	name = "micro calorite beaker"
	list_reagents = list("micro_calorite" = 50)

/obj/item/reagent_containers/glass/beaker/macerinic
	name = "macerinic solution beaker"
	list_reagents = list("fermi_slim" = 50)

/obj/item/reagent_containers/glass/beaker/fizulphite
	name = "fizulphite beaker"
	list_reagents = list("fizulphite" = 50)

/obj/item/reagent_containers/glass/beaker/extilphite
	name = "extilphite beaker"
	list_reagents = list("extilphite" = 50)

/obj/item/pen/calorite
	name = "calorite pen"
	desc = "A novelty pen with a calorite tip, celebrating Nutri-Tech's success."
	icon = 'modular_gs/icons/obj/caloritepen.dmi'
	icon_state = "caloritepen"
	var/poisoning_per_stab = 0.05
	var/fat_per_stab = 0
	var/permafat_per_stab = 0

/obj/item/pen/calorite/attack(mob/living/target, mob/living/user, params)
	. = ..()
	if(. || !iscarbon(target) || (target.status_flags & GODMODE))
		return
	var/mob/living/carbon/subject = target
	if(!subject.check_weight_prefs(FATTENING_TYPE_ITEM))
		return
	subject.adjust_calorite_poisoning(poisoning_per_stab)
	subject.adjust_fatness(fat_per_stab, FATTENING_TYPE_ITEM)
	subject.adjust_perma(permafat_per_stab, FATTENING_TYPE_ITEM)

/obj/item/pen/calorite/syndicate
	name = "nefarious calorite pen"
	desc = "A Syndicate-branded pen with a galbanic-infused calorite tip."
	poisoning_per_stab = 0.5
	fat_per_stab = 5
	permafat_per_stab = 20

/obj/item/gun/energy/kinetic_accelerator/crossbow/feeder
	name = "feeder's mini energy crossbow"
	desc = "A modified mini energy crossbow that delivers lipoifier instead of toxin damage."
	icon = 'modular_gs/icons/upstream/obj/weapons/guns/energy.dmi'
	icon_state = "crossbow_halloween"
	empty_state = "crossbow_halloween_empty"
	ammo_type = list(/obj/item/ammo_casing/energy/bolt/fattening)
	can_fit_in_turrets = FALSE
	can_be_lensed = FALSE

/obj/item/ammo_casing/energy/bolt/fattening
	projectile_type = /obj/projectile/energy/bolt/fattening

/obj/projectile/energy/bolt/fattening
	damage = 0

/obj/projectile/energy/bolt/fattening/on_hit(atom/target, blocked = 0, hit_zone)
	. = ..()
	if(!iscarbon(target) || blocked == INFINITY)
		return
	var/mob/living/carbon/subject = target
	if((subject.status_flags & GODMODE) || !subject.check_weight_prefs(FATTENING_TYPE_WEAPON))
		return
	subject.reagents.add_reagent("lipoifier", ARMOUR_EQUATION(2, blocked, 1))
