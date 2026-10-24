// Native adapters for GS13 helplessness. Directional FOV remains separate.
/datum/helplessness/immobile/get_trigger_weight(mob/living/carbon/human/subject, removing_trait)
	if(removing_trait != override_quirk && removing_trait != TRAIT_WEAKLEGS && HAS_TRAIT(subject, override_quirk) && HAS_TRAIT(subject, TRAIT_WEAKLEGS))
		return FATNESS_LEVEL_BARELYMOBILE
	return ..()

/datum/helplessness/nearsighted/apply_helplessness(mob/living/carbon/human/subject)
	. = ..()
	if(.)
		subject.update_nearsighted_effects()

/datum/helplessness/nearsighted/disable_helplessness(mob/living/carbon/human/subject)
	. = ..()
	if(. && !QDELETED(subject))
		subject.update_nearsighted_effects()

/datum/helplessness/hidden_face/apply_helplessness(mob/living/carbon/human/subject)
	. = ..()
	if(.)
		subject.name = subject.get_visible_name()

/datum/helplessness/hidden_face/disable_helplessness(mob/living/carbon/human/subject)
	. = ..()
	if(. && !QDELETED(subject))
		subject.name = subject.get_visible_name()

/datum/helplessness/immobile
	helplessness_trait = TRAIT_IMMOBILIZED
	default_trigger_weight = FATNESS_LEVEL_IMMOBILE
	override_quirk = TRAIT_HELPLESS_IMMOBILITY
	preference = "no_movement"
	gain_message = "You have become too fat to move anymore."
	lose_message = "You have become thin enough to regain some of your mobility."

/datum/helplessness/clumsy
	helplessness_trait = TRAIT_CHUNKYFINGERS
	default_trigger_weight = FATNESS_LEVEL_BARELYMOBILE
	override_quirk = TRAIT_HELPLESS_CLUMSY
	preference = "clumsy"
	gain_message = "Your newfound weight has made it hard to manipulate objects."
	lose_message = "You feel like you have lost enough weight to recover your dexterity."

/datum/helplessness/nearsighted
	helplessness_trait = TRAIT_NEARSIGHT
	default_trigger_weight = FATNESS_LEVEL_BLOB
	override_quirk = TRAIT_HELPLESS_NEARSIGHTED
	preference = "nearsighted"
	gain_message = "Your fat makes it difficult to see the world around you."
	lose_message = "You are thin enough to see your environment better."

/datum/helplessness/hidden_face
	helplessness_trait = TRAIT_GS13_HIDDEN_FACE
	default_trigger_weight = FATNESS_LEVEL_BLOB
	override_quirk = TRAIT_HELPLESS_BIG_CHEEKS
	preference = "hidden_face"
	gain_message = "You have gotten so fat that your face is now unrecognizable."
	lose_message = "You have lost enough weight to allow people to recognize your face."

/datum/helplessness/mute
	helplessness_trait = TRAIT_MUTE
	default_trigger_weight = FATNESS_LEVEL_BLOB
	override_quirk = TRAIT_HELPLESS_MUTE
	preference = "mute"
	gain_message = "Your fat makes it impossible for you to speak."
	lose_message = "You are thin enough now to be able to speak again."

/datum/helplessness/immobile_arms
	helplessness_trait = TRAIT_HANDS_BLOCKED
	default_trigger_weight = FATNESS_LEVEL_BLOB
	override_quirk = TRAIT_HELPLESS_IMMOBILE_ARMS
	preference = "immobile_arms"
	gain_message = "Your arms are now engulfed in fat, making it impossible to move your arms."
	lose_message = "You are able to move your arms again."

/datum/helplessness/lisp
	helplessness_trait = TRAIT_GS13_LISP
	default_trigger_weight = FATNESS_LEVEL_BARELYMOBILE
	override_quirk = TRAIT_HELPLESS_LISP
	preference = "lisp"
	gain_message = "Your face feelth too big to pronouce thome letterth."
	lose_message = "Your face has shrunk enough to talk normally again."

/datum/helplessness/jumpsuit_bursting
	helplessness_trait = TRAIT_NO_JUMPSUIT
	default_trigger_weight = FATNESS_LEVEL_IMMOBILE
	override_quirk = TRAIT_HELPLESS_CLOTHING
	preference = "clothing_jumpsuit"
	gain_message = "You feel too fat to wear ordinary jumpsuits."
	lose_message = "You feel thin enough to put on ordinary jumpsuits now."

/datum/helplessness/misc_clothing_bursting
	helplessness_trait = TRAIT_NO_MISC
	default_trigger_weight = FATNESS_LEVEL_BARELYMOBILE
	override_quirk = TRAIT_HELPLESS_CLOTHING
	preference = "clothing_misc"
	gain_message = "You feel too fat to wear ordinary suits, shoes, and gloves."
	lose_message = "You feel thin enough to put on suits, shoes, and gloves now."

/datum/helplessness/belt_bursting
	helplessness_trait = TRAIT_NO_BELT
	default_trigger_weight = FATNESS_LEVEL_EXTREMELY_OBESE
	override_quirk = TRAIT_HELPLESS_BELTS
	preference = "belts"
	gain_message = "You feel too fat to wear ordinary belts."
	lose_message = "You feel thin enough to wear belts now."

/datum/helplessness/back_clothing
	helplessness_trait = TRAIT_NO_BACKPACK
	default_trigger_weight = FATNESS_LEVEL_IMMOBILE
	override_quirk = TRAIT_HELPLESS_BACKPACKS
	preference = "clothing_back"
	gain_message = "Your weight makes it difficult to carry equipment on your back."
	lose_message = "You feel thin enough to carry equipment on your back now."

/datum/helplessness/no_neck
	helplessness_trait = TRAIT_NO_NECK
	default_trigger_weight = FATNESS_LEVEL_BLOB
	override_quirk = TRAIT_HELPLESS_THICK_NECK
	preference = "no_neck"
	gain_message = "You feel a tightness around your neck."
	lose_message = "You no longer feel a tightness around your neck."

/datum/helplessness/no_buckle
	helplessness_trait = TRAIT_NO_BUCKLE
	default_trigger_weight = FATNESS_LEVEL_EXTREMELY_OBESE
	override_quirk = TRAIT_HELPLESS_NO_BUCKLE
	preference = "no_buckle"
	gain_message = "You feel like you have gotten too big to buckle onto anything."
	lose_message = "You feel thin enough to buckle onto things again."

/datum/helplessness/waddle
	helplessness_trait = TRAIT_WADDLE
	default_trigger_weight = FATNESS_LEVEL_BARELYMOBILE
	override_quirk = TRAIT_HELPLESS_WADDLING
	preference = "waddle"
	gain_message = "Your legs are too thick to walk straight."
	lose_message = "Your legs are thin enough to walk normally again."

/datum/helplessness/waddle/apply_helplessness(mob/living/carbon/human/subject)
	. = ..()
	if(.)
		subject.AddElement(/datum/element/waddling/gs13)

/datum/helplessness/waddle/disable_helplessness(mob/living/carbon/human/subject)
	. = ..()
	if(.)
		subject.RemoveElement(/datum/element/waddling/gs13)

// A distinct identity preserves an independently installed native waddle.
/datum/element/waddling/gs13
