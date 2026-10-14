// GS13 trap variants using Paradise's existing heretic/wizard trap foundation.
/obj/structure/trap/gs13
	icon = 'modular_gs/icons/obj/structure/traps.dmi'
	icon_state = "trap-fattening"
	density = FALSE
	max_integrity = 40

/obj/structure/trap/gs13/Initialize(mapload)
	. = ..()
	// Newly placed traps are armed even during the first minute of a round.
	last_trigger = world.time - time_between_triggers

/obj/structure/trap/gs13/on_entered(datum/source, atom/movable/victim)
	if(QDELETED(src) || QDELETED(victim) || charges <= 0 || !isturf(loc) || source != loc || victim.loc != loc || istype(victim, /obj/projectile))
		return
	return ..()

/obj/structure/trap/fattening
	parent_type = /obj/structure/trap/gs13
	name = "fattening trap"
	desc = "A trap infused with calorite magic."
	var/fattening_amount = 150

/obj/structure/trap/fattening/trap_effect(mob/living/victim)
	if(!ishuman(victim) || victim.status_flags & GODMODE)
		return
	var/mob/living/carbon/human/subject = victim
	if(subject.adjust_fatness(fattening_amount, FATTENING_TYPE_MAGIC) > 0)
		to_chat(subject, SPAN_WARNING("You feel heavier!"))

/obj/structure/trap/belch
	parent_type = /obj/structure/trap/gs13
	name = "belch trap"
	desc = "A trap that releases stomach air and knocks its victim off balance."
	icon_state = "trap-belching"

/obj/structure/trap/belch/trap_effect(mob/living/victim)
	if(victim.status_flags & GODMODE)
		return
	if(iscarbon(victim))
		var/mob/living/carbon/subject = victim
		// The source uses the chemical switch for this emote, not the magic switch.
		if(subject.check_weight_prefs(FATTENING_TYPE_CHEM))
			to_chat(subject, SPAN_WARNING("You feel the air leave your stomach!"))
			subject.emote("burp")
	// Native knockdown, like the source, is independent of body-weight preferences.
	victim.KnockDown(8 SECONDS)

/datum/spell/aoe/conjure/gs13_traps
	name = "Mixed Weight Traps"
	desc = "Summon fattening and belch traps around you. Their magic will not affect their caster."
	action_icon = 'modular_gs/icons/obj/structure/traps.dmi'
	action_icon_state = "trap-fattening"
	clothes_req = FALSE
	base_cooldown = 25 SECONDS
	cooldown_min = 5 SECONDS
	invocation = "CAVERE INSIDIAS!"
	invocation_type = "shout"
	aoe_range = 3
	summon_type = list(/obj/structure/trap/fattening, /obj/structure/trap/belch)
	summon_lifespan = 5 MINUTES
	summon_amt = 5
	summon_ignore_prev_spawn_points = TRUE
	delay = 0
	var/trap_charges = 1

/datum/spell/aoe/conjure/gs13_traps/cast(list/targets, mob/living/user)
	. = ..()
	for(var/obj/structure/trap/gs13/trap as anything in .)
		trap.charges = trap_charges
		if(user?.mind)
			trap.immune_minds |= user.mind

/datum/spell/aoe/conjure/gs13_traps/fattening
	name = "Fattening Traps!"
	desc = "Summon traps that increase the weight of enemies who step on them."
	summon_type = list(/obj/structure/trap/fattening)

/datum/spell/aoe/conjure/gs13_traps/belch
	name = "Belch Traps!"
	desc = "Summon traps that knock enemies down and make them burp."
	action_icon_state = "trap-belching"
	summon_type = list(/obj/structure/trap/belch)

/obj/item/book/granter/spell/gs13_traps
	name = "Fattening trap tome"
	desc = "A book that teaches you how to summon fattening traps."
	icon = 'modular_gs/icons/obj/spells/spellbooks.dmi'
	icon_state = "add_weight"
	spell_name = "Fattening Traps"
	granted_spell = /datum/spell/aoe/conjure/gs13_traps/fattening
	remarks = list("Calories are actually energy?", "Concentrate energy in the trap...", "I feel a bit hungry now.")

/obj/item/book/granter/spell/gs13_traps/can_learn(mob/living/user)
	return user.mind && !(locate(granted_spell) in user.mind.spell_list)

/obj/item/book/granter/spell/gs13_traps/belch
	name = "Belch trap tome"
	desc = "A book that teaches you how to summon belch traps."
	icon = 'icons/obj/library.dmi'
	icon_state = "booksmoke"
	spell_name = "Belch Traps"
	granted_spell = /datum/spell/aoe/conjure/gs13_traps/belch
	remarks = list()

/obj/item/book/granter/action/spell/traps_fattening
	parent_type = /obj/item/book/granter/spell/gs13_traps

/obj/item/book/granter/action/spell/traps_belch
	parent_type = /obj/item/book/granter/spell/gs13_traps/belch
