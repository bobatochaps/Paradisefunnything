// GS13 melee weapons adapted to Paradise's native attack chains.
/obj/item/melee/baton/loaded/fattening
	name = "fattening stunbaton"
	desc = "A stun baton that adds weight when used on harm intent. Its stun circuit works like a standard baton."
	force = 20
	damtype = FAT

/obj/item/melee/baton/loaded/fattening/stunsword
	name = "fattening stunsword"
	desc = "A heavy calorite stunsword. Harm intent applies its weight effect; the powered stun circuit uses standard baton controls."
	icon = 'modular_gs/icons/upstream/obj/weapons/baton.dmi'
	icon_state = "stunsword"
	base_icon = "stunsword"
	inhand_icon_state = "stunsword"
	lefthand_file = 'modular_gs/icons/upstream/mob/inhands/64x64_lefthand.dmi'
	righthand_file = 'modular_gs/icons/upstream/mob/inhands/64x64_righthand.dmi'
	inhand_x_dimension = 64
	inhand_y_dimension = 64
	w_class = WEIGHT_CLASS_HUGE
	force = 45
	throwforce = 10
	sharp = TRUE
	cell = /obj/item/stock_parts/cell/bluespace
	hitsound = 'sound/weapons/slash.ogg'
	attack_verb = list("slashed", "sliced", "cut")

/obj/item/melee/baton/loaded/fattening/stunsword/update_icon_state()
	. = ..()
	inhand_icon_state = turned_on ? "stunsword_active" : "stunsword"

/obj/item/melee/classic_baton/fattening
	name = "fattening police baton"
	desc = "A calorite-lined police baton. Harm intent applies its weight effect; other intents retain the standard knockdown."
	force = 20
	damtype = FAT

/obj/item/melee/chainofcommand/fattening
	name = "Calorite Whip"
	desc = "The whip glistens orange between its threads. A successful close-range strike also disarms its target."
	icon = 'modular_gs/icons/obj/weapons/fat_weapons.dmi'
	icon_state = "calorite_whip"
	inhand_icon_state = "chain"
	damtype = FAT
	force = 25
	throwforce = 0
	new_attack_chain = TRUE

/obj/item/melee/chainofcommand/fattening/after_attack(atom/target, mob/user, proximity_flag, click_parameters)
	. = ..()
	if(!proximity_flag || !ishuman(target) || QDELETED(target))
		return
	var/mob/living/carbon/human/subject = target
	if(subject.status_flags & GODMODE)
		return
	var/dropped_left = subject.drop_l_hand()
	var/dropped_right = subject.drop_r_hand()
	if(dropped_left || dropped_right)
		subject.visible_message(SPAN_DANGER("[user] disarms [subject]!"), SPAN_USERDANGER("[user] disarms you!"))

/obj/item/melee/chainofcommand/fattening/permanent
	name = "Galbanic Whip"
	desc = "The whip's threads glisten red with a galbanic infusion. A successful close-range strike also disarms its target."
	icon_state = "galbanic_whip"
	damtype = PERMA_FAT

/obj/item/gavelhammer/fattening
	name = "Calorite Hammer"
	desc = "A calorite hammer with an insulated handle."
	icon = 'modular_gs/icons/obj/weapons/fat_weapons.dmi'
	icon_state = "calorite_hammer"
	inhand_icon_state = "gavelhammer"
	damtype = FAT
	throwforce = 25
	force = 30

/obj/item/gavelhammer/fattening/permanent
	name = "Galbanic Hammer"
	desc = "A galbanic-infused hammer that causes lasting weight gain."
	icon_state = "galbanic_hammer"
	damtype = PERMA_FAT
