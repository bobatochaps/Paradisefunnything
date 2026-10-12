// Three guns per crate. Prices preserve the source ratios to a standard energy gun
// crate while using Paradise's currency (two standard energy guns cost 500 credits).
/datum/supply_packs/security/armory/gs13_salamander
	name = "Salamander Energy Guns Crate"
	contains = list(/obj/item/gun/energy/fatoray/stunning, /obj/item/gun/energy/fatoray/stunning, /obj/item/gun/energy/fatoray/stunning)
	cost = 750
	containername = "Salamander energy guns crate"

/datum/supply_packs/security/armory/gs13_matador
	name = "Matador Energy Guns Crate"
	contains = list(/obj/item/gun/energy/gun/fattening, /obj/item/gun/energy/gun/fattening, /obj/item/gun/energy/gun/fattening)
	cost = 625
	containername = "Matador energy guns crate"

/datum/uplink_item/adipowarfare
	category = "Adipo-Warfare"
	surplus = 5

/datum/uplink_item/adipowarfare/fatoray
	name = "Fatoray Pistol"
	desc = "An energy pistol with a calorite lens that adds weight on impact."
	item = /obj/item/gun/energy/fatoray
	reference = "GSFAT"
	cost = 2

/datum/uplink_item/adipowarfare/fatoray_cannon
	name = "Fatoray Cannon"
	desc = "A heavy Fatoray with a stronger beam and ten shots per full charge."
	item = /obj/item/gun/energy/fatoray/cannon
	reference = "GSCAN"
	cost = 4

/datum/uplink_item/adipowarfare/fat_whip
	name = "Calorite Whip"
	desc = "A calorite whip that adds weight and disarms its target on a close-range strike."
	item = /obj/item/melee/chainofcommand/fattening
	reference = "GSCWH"
	cost = 2

/datum/uplink_item/adipowarfare/permafat_whip
	name = "Galbanic Whip"
	desc = "A galbanic-infused whip that adds permanent weight and disarms its target on a close-range strike."
	item = /obj/item/melee/chainofcommand/fattening/permanent
	reference = "GSGWH"
	cost = 4

/datum/uplink_item/adipowarfare/alter_ray_reverser
	name = "AL-T-Ray: Reverser"
	desc = "A self-charging energy gun that reverses weight loss. A second hit reverses the effect."
	item = /obj/item/gun/energy/laser/alter_ray/noloss
	reference = "GSREV"
	cost = 1
	can_discount = FALSE

/datum/uplink_item/adipowarfare/alter_ray_metabolism
	name = "AL-T-Ray: Metabolism"
	desc = "A self-charging energy gun that raises or lowers weight gain and loss multipliers."
	item = /obj/item/gun/energy/laser/alter_ray/gainrate
	reference = "GSMET"
	cost = 1
	can_discount = FALSE

/datum/uplink_item/adipowarfare/salamander
	name = "Syndicate upgraded EG-1 Salamander"
	desc = "A Salamander that combines stamina damage and weight gain, fitted with a larger power cell."
	item = /obj/item/gun/energy/fatoray/stunning/antag
	reference = "GSSAL"
	cost = 5

/datum/uplink_item/adipowarfare/matador
	name = "Syndicate upgraded EG-2 Matador"
	desc = "A Matador with separate fattening and disabler modes, fitted with a larger power cell."
	item = /obj/item/gun/energy/gun/fattening/antag
	reference = "GSMAT"
	cost = 5

/obj/item/borg/upgrade/fatoray
	name = "cyborg Fatoray module"
	desc = "Adds a mounted Basic Fatoray to a cyborg's selected module. The gun recharges from the cyborg's cell."
	icon_state = "cyborg_upgrade3"
	require_module = TRUE
	items_to_add = list(/obj/item/gun/energy/fatoray/weak/cyborg)
	materials = list(MAT_METAL = 800, MAT_GLASS = 600, MAT_CALORITE = 1000)
	origin_tech = "combat=4;materials=4;biotech=4"

/obj/item/borg/upgrade/fatoray/pre_install_checks(mob/user, mob/living/silicon/robot/robot)
	if(!robot.module)
		to_chat(user, SPAN_WARNING("The cyborg must select a module before installing [src]."))
		return FALSE
	return ..()

/datum/design/borg_upgrade_fatoray
	name = "Cyborg Upgrade (Basic Fatoray)"
	id = "borg_upgrade_fatoray"
	build_type = MECHFAB
	build_path = /obj/item/borg/upgrade/fatoray
	req_tech = list("combat" = 4, "materials" = 4, "biotech" = 4)
	materials = list(MAT_METAL = 800, MAT_GLASS = 600, MAT_CALORITE = 1000)
	construction_time = 12 SECONDS
	category = list("Cyborg Upgrades")
