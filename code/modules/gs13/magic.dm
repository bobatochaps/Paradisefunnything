// GS13 lipomancy adapted to Paradise's native spell actions and magic projectiles.
/datum/spell/touch/fatten_up
	name = "Gain"
	desc = "Charge your hand with calorite energy to increase the weight of someone you touch."
	hand_path = /obj/item/melee/touch_attack/fatten_up
	action_icon = 'modular_gs/icons/obj/spells/spell_items.dmi'
	action_icon_state = "add-hand"
	clothes_req = FALSE
	base_cooldown = 30 SECONDS
	cooldown_min = 0.25 SECONDS

/datum/spell/touch/fatten_up/Destroy()
	QDEL_NULL(attached_hand)
	return ..()

/datum/spell/touch/fatten_up/on_mind_transfer(mob/living/new_character)
	QDEL_NULL(attached_hand)
	return ..()

/datum/spell/touch/fatten_up/on_purchase_upgrade()
	. = ..()
	// Preserve TG's ten-second improvement and its nonzero cooldown floor.
	cooldown_handler.recharge_duration = max(base_cooldown - spell_level * 10 SECONDS, 0.25 SECONDS)

/obj/item/melee/touch_attack/fatten_up
	name = "fattening touch"
	desc = "A hand charged with calorite energy."
	icon = 'modular_gs/icons/obj/spells/spell_items.dmi'
	icon_state = "add-hand"
	// The source's add-hand state has no directional in-hand frames.
	inhand_icon_state = "disintegrate"
	catchphrase = "TUB-O-LARDO!!"
	on_use_sound = 'sound/effects/attackblob.ogg'

/obj/item/melee/touch_attack/fatten_up/after_attack(atom/target, mob/user, proximity_flag, click_parameters)
	if(QDELETED(attached_spell) || !proximity_flag || target == user || !iscarbon(target) || !iscarbon(user) || loc != user || !user.Adjacent(target) || HAS_TRAIT(user, TRAIT_HANDS_BLOCKED))
		return
	. = ..()
	if(QDELETED(src) || blocked_by_antimagic)
		return
	var/mob/living/carbon/victim = target
	if(!(victim.status_flags & GODMODE))
		victim.adjust_fatness(100, FATTENING_TYPE_MAGIC)
	add_attack_logs(user, victim, "used the Gain touch spell")
	user.say(catchphrase)
	playsound(get_turf(user), on_use_sound, 50, TRUE)
	// Pass the actual caster: generic touch cleanup relies on ambient usr.
	attached_spell.perform(list(), user)
	qdel(src)

/obj/item/book/granter/spell/gain
	name = "Book of fattening"
	desc = "A book made out of calorite, holding it alone makes you feel hungry."
	icon = 'modular_gs/icons/obj/spells/spellbooks.dmi'
	icon_state = "add_weight"
	granted_spell = /datum/spell/touch/fatten_up
	spell_name = "Gain"
	remarks = list(
		"Calories are actually energy?",
		"Concentrate energy on my hand...",
		"Sounds like feeding someone a pizza might be more effective...",
		"I feel a bit hungry now.",
	)

/obj/item/book/granter/spell/gain/can_learn(mob/living/user)
	if(!user.mind)
		return FALSE
	for(var/datum/spell/known_spell as anything in user.mind.spell_list)
		if(istype(known_spell, granted_spell))
			to_chat(user, SPAN_NOTICE("You already know [spell_name]."))
			return FALSE
	return TRUE

/obj/item/book/granter/spell/gain/recoil(mob/living/user)
	if(!iscarbon(user))
		return
	var/mob/living/carbon/reader = user
	to_chat(reader, SPAN_WARNING("The book turns to dust in your hands as you feel a little heavier."))
	if(!(reader.status_flags & GODMODE))
		reader.adjust_fatness(100, FATTENING_TYPE_MAGIC)
	qdel(src)

// Preserve the original map/admin-spawn path without importing TG's action API.
/obj/item/book/granter/action/spell/gain
	parent_type = /obj/item/book/granter/spell/gain

/obj/item/gun/magic/wand/food
	name = "Wand of Gluttony"
	desc = "Summons delicious food infused with lipoifier."
	icon = 'modular_gs/icons/obj/magic.dmi'
	icon_state = "food_wand"
	belt_icon = null
	max_charges = 15
	ammo_type = /obj/item/ammo_casing/magic/food

/obj/item/gun/magic/wand/food/overpowered
	name = "Strong wand of Gluttony"
	max_charges = 100
	ammo_type = /obj/item/ammo_casing/magic/food/strong

/obj/item/gun/magic/wand/food/zap_self(mob/living/user)
	if(!charges || !user.can_cast_magic(antimagic_flags))
		return FALSE
	newshot()
	var/obj/projectile/magic/food/bolt = chambered?.BB
	if(!istype(bolt))
		return FALSE
	..()
	chambered.BB = null
	bolt.firer = user
	bolt.on_hit(user)
	qdel(bolt)
	process_chamber()
	update_icon(UPDATE_ICON_STATE)
	return TRUE

/obj/item/ammo_casing/magic/food
	projectile_type = /obj/projectile/magic/food
	harmful = FALSE

/obj/item/ammo_casing/magic/food/strong
	projectile_type = /obj/projectile/magic/food/strong

/obj/projectile/magic/food
	name = "bolt of food"
	pass_flags = PASSGLASS | PASSGRILLE
	var/lipoifier_to_add = 5
	var/list/spawnable_foods = list(
		/obj/item/food/burger/bigbite,
		/obj/item/food/donut,
		/obj/item/food/sliceable/cheesecake,
		/obj/item/food/sliceable/orangecake,
		/obj/item/food/sliceable/birthdaycake,
		/obj/item/food/sliceable/chocolatecake,
		/obj/item/food/hotdog,
		/obj/item/food/sliceable/pizza/margheritapizza,
		/obj/item/food/sliceable/pizza/meatpizza,
	)

/obj/projectile/magic/food/on_hit(atom/target, blocked = 0, hit_zone)
	var/turf/floor = get_turf(target)
	if(!floor || iswallturf(floor))
		return FALSE
	. = ..()
	// Native on_hit returns false for turfs/objects as well as blocked magic.
	if(isliving(target) && (!. || blocked == INFINITY))
		return FALSE
	var/food_type = pick(spawnable_foods)
	var/obj/item/food/spawned_food = new food_type(floor)
	// Native meals can start close to capacity; retain the complete source dose.
	spawned_food.reagents.maximum_volume = max(spawned_food.reagents.maximum_volume, spawned_food.reagents.total_volume + lipoifier_to_add)
	spawned_food.reagents.add_reagent("lipoifier", lipoifier_to_add)
	return TRUE

/obj/projectile/magic/food/strong
	name = "strong bolt of food"
	lipoifier_to_add = 20
