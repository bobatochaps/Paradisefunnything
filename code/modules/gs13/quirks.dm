// GS13 traits exposed through Paradise's native character quirk system.
/datum/quirk/gs13_strong_legs
	name = "Strong Legs"
	desc = "Your legs are used to carrying heavy loads. GS13 weight slows you down half as much."
	cost = 2
	trait_to_apply = TRAIT_STRONGLEGS
	conflicting_quirks = list(/datum/quirk/gs13_weak_legs)

/datum/quirk/gs13_weak_legs
	name = "Weak Legs"
	desc = "Your legs struggle with heavy loads. The movement penalty from GS13 weight is increased."
	cost = -3
	trait_to_apply = TRAIT_WEAKLEGS
	conflicting_quirks = list(/datum/quirk/gs13_strong_legs)

/datum/quirk/gs13_lipolicide_tolerance
	name = "Lipolicide Tolerance"
	desc = "Your body barely responds to lipolicide's weight-loss effects."
	trait_to_apply = TRAIT_LIPOLICIDE_TOLERANCE

/datum/quirk/gs13_macerinic_tolerance
	name = "Macerinic Tolerance"
	desc = "Macerinic solution removes weight less effectively and cannot increase your weight-loss rate."
	trait_to_apply = TRAIT_MACERINIC_TOLERANCE
