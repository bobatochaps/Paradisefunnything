// Native adapters for GS13 helplessness. Equipment, FOV, and waddling follow separately.
/datum/helplessness/immobile/get_trigger_weight(mob/living/carbon/human/subject)
	if(HAS_TRAIT(subject, override_quirk) && HAS_TRAIT(subject, TRAIT_WEAKLEGS))
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
