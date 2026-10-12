// Adapted from GS13's energy guns, ammo casings, and projectiles (AGPL-3.0).
// Paradise cells hold 1,000 units versus GS13's 10,000; costs retain the source ratios.

/obj/projectile/beam/fattening
	name = "fat energy"
	icon = 'modular_gs/icons/obj/weapons/fatoray.dmi'
	icon_state = "ray"
	damage = 0
	eyeblur = 0
	damage_type = STAMINA
	light_color = LIGHT_COLOR_ORANGE
	fat_added = 200

/obj/projectile/beam/fattening/stun
	fat_added = 150
	damage = 30

/obj/projectile/beam/fattening/weak
	fat_added = 100

/obj/projectile/beam/fattening/cannon
	icon_state = "cannon_ray"
	fat_added = 800

/obj/projectile/beam/fattening/cannon/weak
	fat_added = 400

/obj/projectile/beam/alter_ray
	name = "metabolism ray"
	icon_state = "omnilaser"
	hitsound = null
	damage = 0
	eyeblur = 0
	damage_type = STAMINA
	var/ratechange_amount = 0.1

/obj/projectile/beam/alter_ray/on_hit(atom/target, blocked = 0, hit_zone)
	. = ..()
	if(!iscarbon(target) || blocked == INFINITY)
		return
	var/mob/living/carbon/carbon = target
	if((carbon.status_flags & GODMODE) || !carbon.check_weight_prefs(FATTENING_TYPE_WEAPON))
		return
	apply_metabolism_change(carbon, blocked)

/obj/projectile/beam/alter_ray/proc/apply_metabolism_change(mob/living/carbon/target, blocked)
	return

/obj/projectile/beam/alter_ray/gain_rate/apply_metabolism_change(mob/living/carbon/target, blocked)
	target.add_weight_gain_modifier("AL-T-Ray", ARMOUR_EQUATION(ratechange_amount, blocked, 1))

/obj/projectile/beam/alter_ray/gain_rate/decrease
	icon_state = "bluelaser"
	light_color = LIGHT_COLOR_DARKBLUE
	ratechange_amount = -0.1

/obj/projectile/beam/alter_ray/gain_rate/increase
	icon_state = "laser"
	light_color = LIGHT_COLOR_DARKRED

/obj/projectile/beam/alter_ray/loss_rate/apply_metabolism_change(mob/living/carbon/target, blocked)
	target.add_weight_loss_modifier("AL-T-Ray", ARMOUR_EQUATION(ratechange_amount, blocked, 1))

/obj/projectile/beam/alter_ray/loss_rate/decrease
	icon_state = "bluelaser"
	light_color = LIGHT_COLOR_DARKBLUE
	ratechange_amount = -0.1

/obj/projectile/beam/alter_ray/loss_rate/increase
	icon_state = "laser"
	light_color = LIGHT_COLOR_DARKRED

/obj/projectile/beam/alter_ray/lossrate_reverse
	icon_state = "laser"
	ratechange_amount = 0

/obj/projectile/beam/alter_ray/lossrate_reverse/apply_metabolism_change(mob/living/carbon/target, blocked)
	target.flip_loss_rate = !target.flip_loss_rate

/obj/item/ammo_casing/energy/fattening
	name = "fattening weapon lens"
	select_name = "fatten"
	projectile_type = /obj/projectile/beam/fattening
	fire_sound = 'sound/weapons/plasma_cutter.ogg'
	harmful = FALSE

/obj/item/ammo_casing/energy/fattening/weak
	name = "budget fattening weapon lens"
	projectile_type = /obj/projectile/beam/fattening/weak

/obj/item/ammo_casing/energy/fattening/cheap
	name = "efficient fattening weapon lens"
	e_cost = 50

/obj/item/ammo_casing/energy/fattening/stun
	name = "calorite-disabler weapon lens"
	select_name = "disable-fatten"
	projectile_type = /obj/projectile/beam/fattening/stun

/obj/item/ammo_casing/energy/fattening/cannon
	name = "fattening cannon lens"
	projectile_type = /obj/projectile/beam/fattening/cannon
	e_cost = 100

/obj/item/ammo_casing/energy/fattening/cannon/weak
	projectile_type = /obj/projectile/beam/fattening/cannon/weak
	e_cost = 160

/obj/item/ammo_casing/energy/laser/alter_ray
	harmful = FALSE

/obj/item/ammo_casing/energy/laser/alter_ray/gainrate_increase
	projectile_type = /obj/projectile/beam/alter_ray/gain_rate/increase
	select_name = "weight gain increase"

/obj/item/ammo_casing/energy/laser/alter_ray/gainrate_decrease
	projectile_type = /obj/projectile/beam/alter_ray/gain_rate/decrease
	select_name = "weight gain decrease"

/obj/item/ammo_casing/energy/laser/alter_ray/lossrate_increase
	projectile_type = /obj/projectile/beam/alter_ray/loss_rate/increase
	select_name = "weight loss increase"

/obj/item/ammo_casing/energy/laser/alter_ray/lossrate_decrease
	projectile_type = /obj/projectile/beam/alter_ray/loss_rate/decrease
	select_name = "weight loss decrease"

/obj/item/ammo_casing/energy/laser/alter_ray/lossrate_reverse
	projectile_type = /obj/projectile/beam/alter_ray/lossrate_reverse
	select_name = "weight loss reverse"

/obj/item/stock_parts/cell/energy_gun/gs13_upgraded
	maxcharge = 2500

/obj/item/gun/energy/fatoray
	name = "Fatoray"
	desc = "An energy gun that fattens up anyone it hits."
	icon = 'modular_gs/icons/obj/weapons/fatoray.dmi'
	lefthand_file = 'modular_gs/icons/mob/inhands/guns_lefthand.dmi'
	righthand_file = 'modular_gs/icons/mob/inhands/guns_righthand.dmi'
	icon_state = "fatoray"
	inhand_icon_state = "fatoray"
	ammo_type = list(/obj/item/ammo_casing/energy/fattening)
	can_be_lensed = FALSE
	can_fit_in_turrets = FALSE

/obj/item/gun/energy/fatoray/update_overlays()
	. = list()
	var/obj/item/ammo_casing/energy/shot = ammo_type[select]
	var/list/states = icon_states(icon)
	if(cell.charge < shot.e_cost)
		var/empty_state = "[icon_state]_empty"
		if(empty_state in states)
			. += empty_state
	else
		var/charge_state = "[icon_state]_charge[CEILING(3 * cell.charge / cell.maxcharge, 1)]"
		if(charge_state in states)
			. += charge_state

/obj/item/gun/energy/fatoray/weak
	name = "Basic Fatoray"
	desc = "An early-model Fatoray with a weaker beam."
	icon_state = "fatoray_weak"
	ammo_type = list(/obj/item/ammo_casing/energy/fattening/weak)

/obj/item/gun/energy/fatoray/weak/cyborg
	name = "mounted Basic Fatoray"
	can_charge = FALSE

/obj/item/gun/energy/fatoray/weak/cyborg/newshot()
	..()
	robocharge()

/obj/item/gun/energy/fatoray/weak/cyborg/emp_act()
	return

/obj/item/gun/energy/fatoray/cannon
	name = "Fatoray Cannon"
	desc = "A heavy Fatoray with a much stronger beam."
	icon_state = "fatoray_cannon"
	recoil = 3
	slowdown = 1
	weapon_weight = WEAPON_HEAVY
	ammo_type = list(/obj/item/ammo_casing/energy/fattening/cannon)

/obj/item/gun/energy/fatoray/cannon/weak
	name = "Basic Fatoray Cannon"
	icon_state = "fatoray_cannon_weak"
	ammo_type = list(/obj/item/ammo_casing/energy/fattening/cannon/weak)

/obj/item/gun/energy/fatoray/stunning
	name = "\improper GATO EG-1 Salamander"
	desc = "An advanced energy gun that both disables and fattens its target."
	icon_state = "immobilizer"
	ammo_type = list(/obj/item/ammo_casing/energy/fattening/stun)

/obj/item/gun/energy/fatoray/stunning/antag
	name = "Syndicate upgraded EG-1 Salamander"
	desc = "A CyberSun-modified Salamander with a larger power cell."
	cell_type = /obj/item/stock_parts/cell/energy_gun/gs13_upgraded

/obj/item/gun/energy/gun/fattening
	name = "\improper GATO EG-2 Matador"
	desc = "A hybrid energy gun with two settings: fatten and disable."
	icon = 'modular_gs/icons/obj/weapons/fatoray.dmi'
	lefthand_file = 'modular_gs/icons/mob/inhands/guns_lefthand.dmi'
	righthand_file = 'modular_gs/icons/mob/inhands/guns_righthand.dmi'
	ammo_type = list(/obj/item/ammo_casing/energy/fattening/cheap, /obj/item/ammo_casing/energy/disabler)
	shaded_charge = FALSE
	can_flashlight = FALSE
	can_be_lensed = FALSE
	can_fit_in_turrets = FALSE

/obj/item/gun/energy/gun/fattening/examine_more(mob/user)
	..()
	return list()

/obj/item/gun/energy/gun/fattening/antag
	name = "Syndicate upgraded EG-2 Matador"
	desc = "A CyberSun-modified Matador with a larger power cell."
	cell_type = /obj/item/stock_parts/cell/energy_gun/gs13_upgraded

/obj/item/gun/energy/laser/alter_ray
	name = "alter-ray"
	desc = "A self-charging energy weapon capable of altering metabolism."
	icon = 'modular_gs/icons/obj/weapons/alter_ray.dmi'
	icon_state = "alter_ray"
	w_class = WEIGHT_CLASS_NORMAL
	selfcharge = TRUE
	charge_delay = 5
	ammo_x_offset = 2
	ammo_type = list(/obj/item/ammo_casing/energy/laser/alter_ray/gainrate_increase)
	can_be_lensed = FALSE
	can_fit_in_turrets = FALSE

/obj/item/gun/energy/laser/alter_ray/examine_more(mob/user)
	..()
	return list()

/obj/item/gun/energy/laser/alter_ray/gainrate
	name = "AL-T-Ray: Metabolism"
	desc = "A self-charging energy weapon that raises or lowers weight gain and loss multipliers by 0.1 per unarmored hit."
	ammo_type = list(
		/obj/item/ammo_casing/energy/laser/alter_ray/gainrate_decrease,
		/obj/item/ammo_casing/energy/laser/alter_ray/gainrate_increase,
		/obj/item/ammo_casing/energy/laser/alter_ray/lossrate_decrease,
		/obj/item/ammo_casing/energy/laser/alter_ray/lossrate_increase)

/obj/item/gun/energy/laser/alter_ray/noloss
	name = "AL-T-Ray: Reverser"
	desc = "A self-charging energy weapon that reverses weight loss. A second hit restores the target's previous metabolism."
	ammo_type = list(/obj/item/ammo_casing/energy/laser/alter_ray/lossrate_reverse)
