// Native adapter for GS13's threshold-driven helplessness framework.
// Shared rules contain metadata; each body owns its effects and saved preferences.
/proc/gs13_helplessness_rules()
	var/static/list/rules
	if(!rules)
		rules = list()
		for(var/rule_type in subtypesof(/datum/helplessness))
			var/datum/helplessness/rule = new rule_type
			rules[rule.preference] = rule
	return rules

/datum/helplessness
	var/helplessness_trait
	var/default_trigger_weight = 0
	var/override_quirk
	var/preference
	var/gain_message
	var/lose_message

/datum/helplessness/proc/get_trigger_weight(mob/living/carbon/human/subject, removing_trait)
	if(removing_trait != override_quirk && HAS_TRAIT(subject, override_quirk))
		return default_trigger_weight
	return subject.gs13_preferences[preference]

/datum/helplessness/proc/handle_helplessness(mob/living/carbon/human/subject, removing_trait)
	if(subject.stat == DEAD || (removing_trait != TRAIT_NO_HELPLESSNESS && HAS_TRAIT(subject, TRAIT_NO_HELPLESSNESS)))
		return disable_helplessness(subject)
	var/threshold = get_trigger_weight(subject, removing_trait)
	var/effective_weight = subject.calculate_effective_fatness()
	var/forced_weight = GLOB.configuration.gs13?.forced_helplessness[preference]
	if(forced_weight > 0 && effective_weight >= forced_weight && !is_type_in_list(get_area(subject), gs13_size_allowed_areas()))
		return apply_helplessness(subject, threshold > 0 ? min(threshold, forced_weight) : forced_weight, effective_weight)
	if(threshold <= 0 || effective_weight < threshold)
		return disable_helplessness(subject)
	return apply_helplessness(subject, threshold, effective_weight)

/datum/helplessness/proc/apply_helplessness(mob/living/carbon/human/subject, threshold = 0, effective_weight = 0)
	if(HAS_TRAIT_FROM(subject, helplessness_trait, HELPLESSNESS_TRAIT))
		return FALSE
	ADD_TRAIT(subject, helplessness_trait, HELPLESSNESS_TRAIT)
	to_chat(subject, SPAN_WARNING(gain_message))
	return TRUE

/datum/helplessness/proc/disable_helplessness(mob/living/carbon/human/subject)
	if(!HAS_TRAIT_FROM(subject, helplessness_trait, HELPLESSNESS_TRAIT))
		return FALSE
	REMOVE_TRAIT(subject, helplessness_trait, HELPLESSNESS_TRAIT)
	if(!QDELETED(subject))
		to_chat(subject, SPAN_NOTICE(lose_message))
	return TRUE

/mob/living/carbon/proc/handle_gs13_helplessness()
	if(!ishuman(src) || QDELETED(src))
		return
	var/datum/component/gs13_helplessness/controller = LoadComponent(/datum/component/gs13_helplessness)
	controller.refresh()

/datum/component/gs13_helplessness
	dupe_mode = COMPONENT_DUPE_UNIQUE
	var/refreshing = FALSE
	var/refresh_pending = FALSE
	var/area/last_area
	var/list/watched_signals

/datum/component/gs13_helplessness/Initialize()
	if(!ishuman(parent))
		return COMPONENT_INCOMPATIBLE

/datum/component/gs13_helplessness/RegisterWithParent()
	watched_signals = list(COMSIG_MOB_DEATH, COMSIG_LIVING_REVIVE, COMSIG_MOB_LOGIN, SIGNAL_ADDTRAIT(TRAIT_NO_HELPLESSNESS), SIGNAL_ADDTRAIT(TRAIT_WEAKLEGS), SIGNAL_ADDTRAIT(TRAIT_HELPLESS_CHAIR_DESTROYER))
	var/list/removal_signals = list(SIGNAL_REMOVETRAIT(TRAIT_NO_HELPLESSNESS), SIGNAL_REMOVETRAIT(TRAIT_WEAKLEGS), SIGNAL_REMOVETRAIT(TRAIT_HELPLESS_CHAIR_DESTROYER))
	var/list/rules = gs13_helplessness_rules()
	for(var/key in rules)
		var/datum/helplessness/rule = rules[key]
		watched_signals |= SIGNAL_ADDTRAIT(rule.override_quirk)
		removal_signals |= SIGNAL_REMOVETRAIT(rule.override_quirk)
	RegisterSignal(parent, watched_signals, PROC_REF(on_changed))
	RegisterSignal(parent, removal_signals, PROC_REF(on_trait_removed))
	watched_signals |= removal_signals
	RegisterSignal(parent, COMSIG_MOVABLE_MOVED, PROC_REF(on_moved))

/datum/component/gs13_helplessness/UnregisterFromParent()
	if(!parent)
		return
	UnregisterSignal(parent, watched_signals)
	UnregisterSignal(parent, COMSIG_MOVABLE_MOVED)
	var/list/rules = gs13_helplessness_rules()
	for(var/key in rules)
		var/datum/helplessness/rule = rules[key]
		rule.disable_helplessness(parent)
	last_area = null

/datum/component/gs13_helplessness/Destroy(force = FALSE, silent = FALSE)
	UnregisterFromParent()
	return ..()

/datum/component/gs13_helplessness/proc/on_changed(datum/source)
	SIGNAL_HANDLER
	refresh()

/datum/component/gs13_helplessness/proc/on_trait_removed(datum/source, removing_trait)
	SIGNAL_HANDLER
	// REMOVE_TRAIT signals before deleting the final source. Evaluate that trait
	// as absent without changing the native trait list inside its removal loop.
	// Bulk removal signals after deletion, and may omit the trait argument.
	refresh(removing_trait)

/datum/component/gs13_helplessness/proc/on_moved(datum/source)
	SIGNAL_HANDLER
	if(get_area(parent) != last_area)
		refresh()

/datum/component/gs13_helplessness/proc/refresh(removing_trait)
	if(!parent || QDELETED(parent))
		return
	if(refreshing)
		refresh_pending = TRUE
		return
	refreshing = TRUE
	last_area = get_area(parent)
	var/list/rules = gs13_helplessness_rules()
	var/mob/living/carbon/human/subject = parent
	do
		refresh_pending = FALSE
		for(var/key in rules)
			var/datum/helplessness/rule = rules[key]
			rule.handle_helplessness(subject, removing_trait)
		// Removing concealment can change weight again during an equipment drop.
		// Finish that recalculation before returning, without recursively entering.
		subject.gs13_shed_incompatible_clothing()
		subject.gs13_check_chair(removing_trait)
	while(refresh_pending && !QDELETED(subject))
	refreshing = FALSE

/// Server thresholds default off; omitted override keys preserve loaded values.
/datum/configuration_section/gs13_configuration
	var/list/forced_helplessness = list()
	/// Optional anatomy still requires explicit per-character presence choices.
	var/fluid_anatomy_enabled = TRUE

/datum/configuration_section/gs13_configuration/load_data(list/data)
	if("fluid_anatomy_enabled" in data)
		fluid_anatomy_enabled = data["fluid_anatomy_enabled"] == TRUE
	var/list/thresholds = data["forced_helplessness"]
	if(!islist(thresholds))
		return
	for(var/key in gs13_helplessness_rules())
		var/value = thresholds[key]
		if(isnum(value) && GS13_IS_FINITE(value))
			forced_helplessness[key] = clamp(value, 0, SHORT_REAL_LIMIT)

/proc/gs13_helplessness_labels()
	return list(
		"no_movement" = "Immobility threshold (BFI; 0 = disabled)",
		"clumsy" = "Clumsy fingers threshold (BFI; 0 = disabled)",
		"nearsighted" = "Nearsightedness threshold (BFI; 0 = disabled)",
		"low_fov" = "Restricted field of view threshold (BFI; 0 = disabled)",
		"hidden_face" = "Unrecognizable face threshold (BFI; 0 = disabled)",
		"mute" = "Muteness threshold (BFI; 0 = disabled)",
		"immobile_arms" = "Immobile arms threshold (BFI; 0 = disabled)",
		"lisp" = "Lisp threshold (BFI; 0 = disabled)",
		"clothing_jumpsuit" = "Jumpsuit fit threshold (BFI; 0 = disabled)",
		"clothing_misc" = "Suit, glove, and shoe fit threshold (BFI; 0 = disabled)",
		"belts" = "Belt fit threshold (BFI; 0 = disabled)",
		"clothing_back" = "Back equipment fit threshold (BFI; 0 = disabled)",
		"no_neck" = "Neckwear fit threshold (BFI; 0 = disabled)",
		"no_buckle" = "Unable to buckle threshold (BFI; 0 = disabled)",
		"waddle" = "Waddling threshold (BFI; 0 = disabled)",
		"chair_breakage" = "Chair breakage threshold (apparent BFI; 0 = disabled)",
		"stuckage" = "Doorway squeezing threshold (apparent BFI; 0 = disabled)",
		"stuckage_custom" = "Doorway block chance (percent; 0 = source default)",
	)

/proc/gs13_numeric_preference(setting)
	return (setting in list("body_size", "starting_fatness", "weight_gain_rate", "weight_loss_rate", "max_weight")) || (setting in gs13_helplessness_labels()) || (setting in gs13_burst_numeric_preferences()) || (setting in gs13_anatomy_numeric_preferences()) || (setting in gs13_shape_default_preferences())
