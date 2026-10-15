// GS13 crops use Paradise's seed genetics, harvests, and string reagent IDs.
/obj/item/seeds/lipoplant
	name = "pack of adipolipus"
	desc = "These seeds grow into a foreign plant."
	species = "adipolipus"
	plantname = "Adipolipus"
	product = /obj/item/food/grown/lipofruit
	lifespan = 30
	potency = 20
	maturation = 8
	production = 5
	yield = 1
	reagents_add = list("lipoifier" = 0.2)
	icon = 'modular_gs/icons/obj/hydroponics/seeds.dmi'
	icon_state = "seed-lipo"
	growing_icon = 'modular_gs/icons/obj/hydroponics/growing.dmi'
	icon_grow = "lipo-grow"
	icon_dead = "lipo-dead"
	icon_harvest = "lipo-harvest"

/obj/item/food/grown/lipofruit
	seed = /obj/item/seeds/lipoplant
	name = "lipofruit"
	desc = "A foreign fruit with a hard shell and a rich, oily interior."
	icon = 'modular_gs/icons/obj/hydroponics/harvest.dmi'
	icon_state = "lipo_nut"
	resistance_flags = ACID_PROOF
	w_class = WEIGHT_CLASS_SMALL
	distill_reagent = "creme_de_coconut"

/datum/plant_gene/trait/glow/orange
	name = "Orange Bioluminescence"
	glow_color = "#ff9166"

/obj/item/seeds/cannabis/munchies
	name = "pack of munchies weed seeds"
	desc = "These seeds grow into munchies weed."
	species = "munchycannabis"
	plantname = "Munchies Weed"
	product = /obj/item/food/grown/cannabis/munchies
	genes = list(/datum/plant_gene/trait/repeated_harvest, /datum/plant_gene/trait/glow/orange)
	mutatelist = list()
	reagents_add = list("space_drugs" = 0.05, "munchies" = 0.1)
	rarity = 69
	icon = 'modular_gs/icons/obj/hydroponics/seeds.dmi'
	icon_state = "seed-munchies"
	growing_icon = 'modular_gs/icons/obj/hydroponics/growing.dmi'
	icon_grow = "munchycannabis-grow"
	icon_dead = "munchycannabis-dead"
	icon_harvest = "munchycannabis-harvest"

/obj/item/food/grown/cannabis/munchies
	seed = /obj/item/seeds/cannabis/munchies
	name = "munchies cannabis leaf"
	desc = "You feel hungry just looking at it."
	icon = 'modular_gs/icons/obj/hydroponics/harvest.dmi'
	icon_state = "munchycannabis"
	wine_power = 0.9

/datum/reagent/munchies
	name = "Appetite Stimulant"
	id = "munchies"
	description = "A chemical compound that makes one mindlessly ravenous."
	color = "#60A584"
	metabolization_rate = REAGENTS_METABOLISM / 4

/datum/reagent/munchies/on_mob_life(mob/living/subject)
	if(iscarbon(subject))
		var/mob/living/carbon/carbon = subject
		if(carbon.check_weight_prefs(FATTENING_TYPE_CHEM))
			carbon.adjust_hunger(15)
			if(prob(10))
				to_chat(carbon, SPAN_WARNING(pick("You feel a little ravenous...", "You could really go for a snack right now...", "The taste of food seems really enticing right now...", "Your belly groans, demanding food...")))
	return ..()

// Lipofruit's inherited source fermentation product is absent from Paradise.
/datum/reagent/consumable/ethanol/creme_de_coconut
	name = "Creme de Coconut"
	id = "creme_de_coconut"
	description = "A coconut liqueur for smooth, creamy, tropical drinks."
	color = "#F7F0D0"
	alcohol_perc = 0.2
	taste_description = "a sweet milky flavor with notes of toasted sugar"

/obj/item/seeds/watermelon/milkmelon
	name = "milkmelon seed pack"
	desc = "These seeds grow into milkmelon plants."
	species = "milkmelon"
	plantname = "Milk Melon Vines"
	product = /obj/item/food/grown/milkmelon
	mutatelist = list()
	reagents_add = list("milk" = 0.2)
	rarity = 20
	icon = 'modular_gs/icons/obj/hydroponics/seeds.dmi'
	icon_state = "seed-milkmelon"
	growing_icon = 'modular_gs/icons/obj/hydroponics/growing.dmi'
	icon_grow = "milkmelon-grow"
	icon_dead = "milkmelon-dead"
	icon_harvest = "milkmelon-harvest"

/obj/item/food/grown/milkmelon
	seed = /obj/item/seeds/watermelon/milkmelon
	name = "milkmelon"
	desc = "Those are some BIG honkers. A real set of badonkers."
	icon = 'modular_gs/icons/obj/hydroponics/harvest.dmi'
	icon_state = "milkmelon"
	inhand_icon_state = "watermelon"
	wine_power = 0
	wine_flavor = "milkmelon"
	bitesize_mod = 2
	w_class = WEIGHT_CLASS_NORMAL
	dried_type = null
	slices_num = 5
	slice_path = /obj/item/food/milkmelonslice
	clear_slice_reagents = TRUE

/obj/item/food/milkmelonslice
	parent_type = /obj/item/food/sliced
	name = "milkmelon slice"
	desc = "A slice of milky goodness."
	icon = 'modular_gs/icons/obj/hydroponics/harvest.dmi'
	icon_state = "milkmelon_slice"
	list_reagents = list("milk" = 2)
	tastes = list("milkmelon" = 1)
	w_class = WEIGHT_CLASS_SMALL
