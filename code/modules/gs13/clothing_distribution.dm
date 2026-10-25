// Native acquisition for the reviewed GS13 modular-grey uniform family.
/datum/gear/uniform/suit/gs13
	main_typepath = /datum/gear/uniform/suit/gs13
	subtype_selection_cost = FALSE
	var/gs13_department

/datum/gear/uniform/suit/gs13/New()
	switch(gs13_department)
		if("science")
			allowed_roles = GLOB.science_positions.Copy()
		if("engineering")
			allowed_roles = GLOB.engineering_positions.Copy()
		if("supply")
			allowed_roles = GLOB.supply_positions.Copy()
		if("medical")
			allowed_roles = GLOB.medical_positions.Copy()
		if("security")
			allowed_roles = GLOB.active_security_positions.Copy()
		if("command")
			allowed_roles = GLOB.command_positions.Copy()
	return ..()

/datum/gear/uniform/suit/gs13/science
	display_name = "Modular jumpsuit, science"
	path = /obj/item/clothing/under/color/grey/science
	gs13_department = "science"

/datum/gear/uniform/suit/gs13/engineering
	display_name = "Modular jumpsuit, engineering"
	path = /obj/item/clothing/under/color/grey/engi
	gs13_department = "engineering"

/datum/gear/uniform/suit/gs13/cargo
	display_name = "Modular jumpsuit, cargo"
	path = /obj/item/clothing/under/color/grey/cargo
	gs13_department = "supply"

/datum/gear/uniform/suit/gs13/medical
	display_name = "Modular jumpsuit, medical"
	path = /obj/item/clothing/under/color/grey/medical
	gs13_department = "medical"

/datum/gear/uniform/suit/gs13/security
	display_name = "Modular jumpsuit, security"
	path = /obj/item/clothing/under/color/grey/security
	gs13_department = "security"

/datum/gear/uniform/suit/gs13/security/blue
	display_name = "Modular jumpsuit, blue security"
	path = /obj/item/clothing/under/color/grey/security/blue

/datum/gear/uniform/suit/gs13/command
	display_name = "Modular jumpsuit, command"
	path = /obj/item/clothing/under/color/grey/command
	gs13_department = "command"

/datum/gear/uniform/suit/gs13/service
	display_name = "Modular jumpsuit, service"
	path = /obj/item/clothing/under/color/grey/service

/obj/machinery/economy/vending
	var/list/gs13_uniform_stock

/// Merge before native inventory/refill construction, without changing shared
/// type defaults or replacing any existing product, stock, or price.
/obj/machinery/economy/vending/proc/add_gs13_uniform_stock()
	if(!length(gs13_uniform_stock) && !length(gs13_dual_tone_stock))
		return
	var/list/stock = length(gs13_uniform_stock) ? gs13_uniform_stock.Copy() : list()
	for(var/uniform_path in gs13_dual_tone_stock)
		stock[uniform_path] = max(stock[uniform_path], gs13_dual_tone_stock[uniform_path])
	var/uniform_price = 0
	for(var/native_path in products)
		if(ispath(native_path, /obj/item/clothing/under))
			uniform_price = isnum(prices[native_path]) ? prices[native_path] : 0
			break
	products = products.Copy()
	prices = prices.Copy()
	for(var/uniform_path in stock)
		var/current = products[uniform_path]
		products[uniform_path] = isnum(current) ? max(current, stock[uniform_path]) : stock[uniform_path]
		if(!(uniform_path in prices))
			prices[uniform_path] = uniform_price

/obj/machinery/economy/vending/clothing
	gs13_uniform_stock = list(/obj/item/clothing/under/color/grey = 5)

/obj/machinery/economy/vending/secdrobe
	gs13_uniform_stock = list(/obj/item/clothing/under/color/grey/security = 3)

/obj/machinery/economy/vending/detdrobe
	gs13_uniform_stock = list(/obj/item/clothing/under/color/grey/security = 3)

/obj/machinery/economy/vending/medidrobe
	gs13_uniform_stock = list(/obj/item/clothing/under/color/grey/medical = 3)

/obj/machinery/economy/vending/virodrobe
	gs13_uniform_stock = list(/obj/item/clothing/under/color/grey/medical = 3)

/obj/machinery/economy/vending/chemdrobe
	gs13_uniform_stock = list(/obj/item/clothing/under/color/grey/medical = 3)

/obj/machinery/economy/vending/genedrobe
	gs13_uniform_stock = list(/obj/item/clothing/under/color/grey/medical = 3)

/obj/machinery/economy/vending/scidrobe
	gs13_uniform_stock = list(/obj/item/clothing/under/color/grey/science = 3)

/obj/machinery/economy/vending/robodrobe
	gs13_uniform_stock = list(/obj/item/clothing/under/color/grey/science = 3)

/obj/machinery/economy/vending/engidrobe
	gs13_uniform_stock = list(/obj/item/clothing/under/color/grey/engi = 3)

/obj/machinery/economy/vending/atmosdrobe
	gs13_uniform_stock = list(/obj/item/clothing/under/color/grey/engi = 3)

/obj/machinery/economy/vending/cargodrobe
	gs13_uniform_stock = list(/obj/item/clothing/under/color/grey/cargo = 3)

/obj/machinery/economy/vending/chefdrobe
	gs13_uniform_stock = list(/obj/item/clothing/under/color/grey/service = 3)

/obj/machinery/economy/vending/bardrobe
	gs13_uniform_stock = list(/obj/item/clothing/under/color/grey/service = 3)

/obj/machinery/economy/vending/hydrodrobe
	gs13_uniform_stock = list(/obj/item/clothing/under/color/grey/service = 3)

/obj/machinery/economy/vending/janidrobe
	gs13_uniform_stock = list(/obj/item/clothing/under/color/grey/service = 3)

/obj/machinery/economy/vending/lawdrobe
	gs13_uniform_stock = list(/obj/item/clothing/under/color/grey/service = 3)

/obj/machinery/economy/vending/chapdrobe
	gs13_uniform_stock = list(/obj/item/clothing/under/color/grey/service = 3)
