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

// Source quirk costs are scaled to Paradise's existing -1 to -4 range.
/datum/quirk/gs13_helplessness_immobile
	name = "Very Weak Legs"
	desc = "At 2950 effective BFI you cannot move, or 2100 with Weak Legs. Overrides your immobility threshold preference."
	cost = -4
	trait_to_apply = TRAIT_HELPLESS_IMMOBILITY

/datum/quirk/gs13_helplessness_clumsy
	name = "Sausage Fingers"
	desc = "At 2100 effective BFI you cannot use ordinary weapon triggers. Overrides your clumsy fingers threshold preference."
	cost = -3
	trait_to_apply = TRAIT_HELPLESS_CLUMSY

/datum/quirk/gs13_helplessness_mute
	name = "Many Chins"
	desc = "At 4430 effective BFI you become mute. Overrides your muteness threshold preference."
	cost = -1
	trait_to_apply = TRAIT_HELPLESS_MUTE

/datum/quirk/gs13_helplessness_arms
	name = "Weak Arms"
	desc = "At 4430 effective BFI you cannot use your hands. Overrides your immobile arms threshold preference."
	cost = -3
	trait_to_apply = TRAIT_HELPLESS_IMMOBILE_ARMS

/datum/quirk/gs13_helplessness_clothing
	name = "Tight Clothes"
	desc = "At 2100 effective BFI ordinary suits, gloves, and shoes stop fitting; at 2950 ordinary jumpsuits stop fitting. Overrides both clothing thresholds. MOD parts and adapted modular uniforms still fit."
	cost = -3
	trait_to_apply = TRAIT_HELPLESS_CLOTHING

/datum/quirk/gs13_helplessness_belts
	name = "Wide Waist"
	desc = "At 1480 effective BFI ordinary belts stop fitting. Overrides your belt fit threshold. Bluespace belts still fit."
	cost = -2
	trait_to_apply = TRAIT_HELPLESS_BELTS

/datum/quirk/gs13_helplessness_back
	name = "Rolls-back"
	desc = "At 2950 effective BFI ordinary back equipment stops fitting. Overrides your back fit threshold. MOD controls still fit."
	cost = -3
	trait_to_apply = TRAIT_HELPLESS_BACKPACKS

/datum/quirk/gs13_helplessness_buckling
	name = "Seatbelts Destroyer"
	desc = "At 1480 effective BFI you cannot be buckled onto furniture or vehicles. Overrides your buckling threshold."
	cost = -1
	trait_to_apply = TRAIT_HELPLESS_NO_BUCKLE

/datum/quirk/gs13_helplessness_chairs
	name = "Chair Destroyer"
	desc = "Above 2100 apparent BFI chairs break when you sit on them, including when you gain weight while seated. Overrides your chair breakage threshold."
	cost = -1
	trait_to_apply = TRAIT_HELPLESS_CHAIR_DESTROYER

/datum/quirk/gs13_helplessness_neck
	name = "Thick Neck"
	desc = "At 4430 effective BFI neckwear stops fitting. Overrides your neckwear fit threshold."
	cost = -1
	trait_to_apply = TRAIT_HELPLESS_THICK_NECK
