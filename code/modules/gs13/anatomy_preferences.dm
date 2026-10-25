// Native saved anatomy defaults; active chemical changes belong to the organs.
/proc/gs13_anatomy_default_preferences()
	return list("custom_anatomy" = FALSE, "anatomy_breasts" = FALSE, "anatomy_testicles" = FALSE, "anatomy_vagina" = FALSE, "breasts_size" = 1, "max_breast_size" = 80, "breasts_type" = "Pair", "balls_size" = 2, "breasts_lactation" = FALSE, "breast_produce" = "breast milk", "fluid_production" = FALSE)

/proc/gs13_anatomy_preference_labels()
	return list("custom_anatomy" = "Enable optional fluid organs on next spawn", "anatomy_breasts" = "Breast fluid organ on next spawn", "anatomy_testicles" = "Testicles on next spawn", "anatomy_vagina" = "Vagina on next spawn", "breasts_size" = "Base breast size on next spawn (0.5 to 80)", "max_breast_size" = "Maximum breast size (live; 0 to 80)", "breasts_type" = "Breast arrangement on next spawn", "balls_size" = "Testicle size on next spawn (0.5 to 80)", "breasts_lactation" = "Lactation on next spawn", "breast_produce" = "Breast fluid on next spawn", "fluid_production" = "Allow fluid production and collection (live)")

/proc/gs13_anatomy_numeric_preferences()
	return list("breasts_size", "balls_size", "max_breast_size")

/proc/gs13_breast_products()
	return list("breast milk" = /datum/reagent/consumable/breast_milk, "nutriment" = /datum/reagent/consumable/nutriment, "water" = /datum/reagent/water, "honey" = /datum/reagent/consumable/alien_honey, "strawberry milk" = /datum/reagent/consumable/pinkmilk, "chocolate milk" = /datum/reagent/consumable/drink/milk/chocolate_milk, "weak lipoifier" = /datum/reagent/consumable/lipoifier/weak, "blueberry juice" = /datum/reagent/blueberry_juice, "cream" = /datum/reagent/consumable/drink/milk/cream, "starshine neutron" = /datum/reagent/consumable/starshine/blue)

/// DNA contains creation defaults, never a transplanted organ's active state.
/proc/gs13_anatomy_blueprint(saved)
	var/list/clean = gs13_sanitize_preferences(saved)
	var/list/blueprint = list()
	for(var/key in gs13_anatomy_default_preferences())
		if(key != "fluid_production")
			blueprint[key] = clean[key]
	return blueprint
