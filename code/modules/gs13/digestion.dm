// Explicit oral routing. Native REAGENT_INGEST also describes injected exposure.
/mob/living/proc/get_gs13_ingestion_target()
	return src

/mob/living/carbon/human/get_gs13_ingestion_target()
	if(!dna?.species || !(GS13_ORGAN_STOMACH in dna.species.has_organ))
		return src
	var/obj/item/organ/internal/gs13_stomach/stomach = get_organ_slot(GS13_ORGAN_STOMACH)
	if(!istype(stomach) || QDELETED(stomach) || stomach.owner != src || !stomach.reagents)
		return null
	return stomach

/mob/living/proc/get_gs13_ingestion_free_space()
	var/atom/recipient = get_gs13_ingestion_target()
	return recipient?.reagents ? max(0, recipient.reagents.maximum_volume - recipient.reagents.total_volume) : 0

/// Call only at an actual oral entry point, after feeding/routing permission.
/datum/reagents/proc/gs13_ingest(mob/living/consumer, amount, show_message = TRUE)
	if(QDELETED(src) || !istype(consumer) || QDELETED(consumer) || !isnum(amount) || !GS13_IS_FINITE(amount) || amount <= 0 || total_volume <= 0)
		return 0
	var/atom/recipient = consumer.get_gs13_ingestion_target()
	if(!recipient?.reagents)
		return 0
	amount = min(amount, total_volume, consumer.get_gs13_ingestion_free_space())
	if(amount <= 0)
		return 0
	reaction(consumer, REAGENT_INGEST, amount / total_volume, show_message = show_message)
	if(QDELETED(src) || QDELETED(consumer) || QDELETED(recipient) || consumer.get_gs13_ingestion_target() != recipient)
		return 0
	return trans_to(recipient, min(amount, consumer.get_gs13_ingestion_free_space()))

/proc/gs13_pending_food_nutrition(datum/reagents/holder, efficiency, obj/item/organ/internal/gs13_stomach/transferring)
	var/total = 0
	for(var/datum/reagent/consumable/food in holder?.reagent_list)
		var/depletion_rate = food.metabolization_rate * efficiency
		if(depletion_rate > 0)
			var/volume = food.volume
			if(transferring && transferring.gs13_transfer_id == food.id)
				// Native transfer adds to the blood before removing from the gut.
				// Exclude only the part still temporarily present in both holders.
				var/already_removed = transferring.gs13_transfer_start_volume - volume
				volume -= max(0, transferring.gs13_transfer_volume - already_removed)
			total += food.nutriment_factor * max(0, volume) / depletion_rate
	return total

/// Source stomach drip transfers preserve data and do not apply exposure twice.
/obj/item/organ/internal/gs13_stomach/proc/digest_gs13_reagents(seconds = 2)
	if(gs13_digesting || !owner || QDELETED(owner) || owner.stat == DEAD || owner.get_organ_slot(slot) != src || !owner.reagents || !isnum(seconds) || !GS13_IS_FINITE(seconds) || seconds <= 0)
		return 0
	gs13_digesting = TRUE
	var/transferred = 0
	for(var/datum/reagent/reagent as anything in reagents.reagent_list.Copy())
		if(QDELETED(src) || !owner || QDELETED(owner) || !owner.reagents || owner.get_organ_slot(slot) != src)
			break
		if(QDELETED(reagent) || reagent.metabolization_rate <= 0)
			continue
		var/free = owner.reagents.maximum_volume - owner.reagents.total_volume
		if(free <= 0)
			break
		// Native reagent rates are per two-second body tick; the inherited
		// stomach constant and volume-scaled drip are per second.
		var/minimum_rate = max(reagent.metabolization_rate / 2, 0.25)
		var/amount = min(reagent.volume, (round(gs13_digestive_efficiency * reagent.volume, 0.05) + minimum_rate) * seconds, free)
		var/before = reagents.total_volume
		gs13_transfer_id = reagent.id
		gs13_transfer_volume = amount
		gs13_transfer_start_volume = reagent.volume
		reagents.trans_id_to(owner, reagent.id, amount)
		if(QDELETED(src))
			return transferred
		transferred += max(0, before - reagents.total_volume)
		gs13_transfer_id = null
		gs13_transfer_volume = 0
	gs13_digesting = FALSE
	on_reagent_change()
	return transferred

/obj/item/organ/internal/gs13_stomach/on_reagent_change()
	if(!gs13_digesting && owner && !QDELETED(owner))
		owner.update_gs13_weight_appearance()
		owner.refresh_gs13_bursting()

/// Generic glass gulps retain their native delay and recheck the real context.
/obj/item/reagent_containers/glass/proc/finish_gs13_gulp(mob/living/carbon/subject, mob/living/feeder)
	if(QDELETED(src) || QDELETED(subject) || QDELETED(feeder) || !reagents || !is_open_container() || feeder.get_active_hand() != src || !feeder.Adjacent(subject) || feeder.incapacitated() || subject.is_mouth_covered())
		return 0
	if(ishuman(subject))
		var/mob/living/carbon/human/human_subject = subject
		if(!human_subject.check_has_mouth())
			return 0
	var/mob/living/carbon/consumer = subject.get_gs13_food_recipient()
	return reagents.gs13_ingest(consumer, 5)
