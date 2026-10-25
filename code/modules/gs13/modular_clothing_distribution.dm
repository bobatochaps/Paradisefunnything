// Native loadout metadata for the source white dual-tone family.
/datum/gear/uniform/suit/gs13_dual_tone
	main_typepath = /datum/gear/uniform/suit/gs13_dual_tone
	subtype_selection_cost = FALSE
	var/gs13_department

/datum/gear/uniform/suit/gs13_dual_tone/New()
	switch(gs13_department)
		if("engineering")
			allowed_roles = GLOB.engineering_positions.Copy()
		if("medical")
			allowed_roles = GLOB.medical_positions.Copy()
		if("science")
			allowed_roles = GLOB.science_positions.Copy()
		if("supply")
			allowed_roles = GLOB.supply_positions.Copy()
		if("security")
			allowed_roles = GLOB.active_security_positions.Copy()
	if(path == /obj/item/clothing/under/gs13_dual_tone)
		gear_tweaks = list(new /datum/gear_tweak/gs13_uniform_color/fabric, new /datum/gear_tweak/gs13_uniform_color/stripes)
	return ..()

/datum/gear/uniform/suit/gs13_dual_tone/white
	display_name = "White dual tone jumpsuit (Modular)"
	path = /obj/item/clothing/under/gs13_dual_tone

/datum/gear/uniform/suit/gs13_dual_tone/white/engineering
	display_name = "Engineering dual tone jumpsuit (Modular)"
	path = /obj/item/clothing/under/gs13_dual_tone/engineering
	gs13_department = "engineering"

/datum/gear/uniform/suit/gs13_dual_tone/white/engineering/chief
	display_name = "Chief Engineers dual tone jumpsuit (Modular)"
	path = /obj/item/clothing/under/gs13_dual_tone/engineering/chief
	gs13_department = null
	allowed_roles = list("Chief Engineer")

/datum/gear/uniform/suit/gs13_dual_tone/white/engineering/atmos
	display_name = "Atmos-tech dual tone jumpsuit (Modular)"
	path = /obj/item/clothing/under/gs13_dual_tone/engineering/atmos

/datum/gear/uniform/suit/gs13_dual_tone/white/engineering/tcomms
	display_name = "Telecomms-tech dual tone jumpsuit (Modular)"
	path = /obj/item/clothing/under/gs13_dual_tone/engineering/tcomms

/datum/gear/uniform/suit/gs13_dual_tone/white/medbay
	display_name = "Medical dual tone jumpsuit (Modular)"
	path = /obj/item/clothing/under/gs13_dual_tone/medbay
	gs13_department = "medical"

/datum/gear/uniform/suit/gs13_dual_tone/white/medbay/chief_medical_officer
	display_name = "CMO's dual tone jumpsuit (Modular)"
	path = /obj/item/clothing/under/gs13_dual_tone/medbay/chief_medical_officer
	gs13_department = null
	allowed_roles = list("Chief Medical Officer")

/datum/gear/uniform/suit/gs13_dual_tone/white/medbay/chemist
	display_name = "Chemist dual tone jumpsuit (Modular)"
	path = /obj/item/clothing/under/gs13_dual_tone/medbay/chemist

/datum/gear/uniform/suit/gs13_dual_tone/white/medbay/geneticist
	display_name = "Geneticist dual tone jumpsuit (Modular)"
	path = /obj/item/clothing/under/gs13_dual_tone/medbay/geneticist

/datum/gear/uniform/suit/gs13_dual_tone/white/medbay/virologist
	display_name = "Virologist dual tone jumpsuit (Modular)"
	path = /obj/item/clothing/under/gs13_dual_tone/medbay/virologist

/datum/gear/uniform/suit/gs13_dual_tone/white/medbay/paramedic
	display_name = "Paramedic dual tone jumpsuit (Modular)"
	path = /obj/item/clothing/under/gs13_dual_tone/medbay/paramedic

/datum/gear/uniform/suit/gs13_dual_tone/white/medbay/psychologist
	display_name = "Psychologist dual tone jumpsuit (Modular)"
	path = /obj/item/clothing/under/gs13_dual_tone/medbay/psychologist

/datum/gear/uniform/suit/gs13_dual_tone/white/science
	display_name = "Scientist dual tone jumpsuit (Modular)"
	path = /obj/item/clothing/under/gs13_dual_tone/science
	gs13_department = "science"

/datum/gear/uniform/suit/gs13_dual_tone/white/science/research_director
	display_name = "Research Director's dual tone jumpsuit (Modular)"
	path = /obj/item/clothing/under/gs13_dual_tone/science/research_director
	gs13_department = null
	allowed_roles = list("Research Director")

/datum/gear/uniform/suit/gs13_dual_tone/white/science/roboticist
	display_name = "Roboticist dual tone jumpsuit (Modular)"
	path = /obj/item/clothing/under/gs13_dual_tone/science/roboticist

/datum/gear/uniform/suit/gs13_dual_tone/white/cargo
	display_name = "Cargo tech's dual tone jumpsuit (Modular)"
	path = /obj/item/clothing/under/gs13_dual_tone/cargo
	gs13_department = "supply"

/datum/gear/uniform/suit/gs13_dual_tone/white/cargo/quartermaster
	display_name = "Quartermaster's dual tone jumpsuit (Modular)"
	path = /obj/item/clothing/under/gs13_dual_tone/cargo/quartermaster
	gs13_department = null
	allowed_roles = list("Quartermaster")

/datum/gear/uniform/suit/gs13_dual_tone/white/cargo/miner
	display_name = "Shaft miner's dual tone jumpsuit (Modular)"
	path = /obj/item/clothing/under/gs13_dual_tone/cargo/miner

/datum/gear/uniform/suit/gs13_dual_tone/white/cargo/bitrunner
	display_name = "Bitrunner's dual tone jumpsuit (Modular)"
	path = /obj/item/clothing/under/gs13_dual_tone/cargo/bitrunner

/datum/gear/uniform/suit/gs13_dual_tone/white/security
	display_name = "Security dual tone jumpsuit (Modular)"
	path = /obj/item/clothing/under/gs13_dual_tone/security
	gs13_department = "security"

/datum/gear/uniform/suit/gs13_dual_tone/white/security/red
	display_name = "Security red dual tone jumpsuit (Modular)"
	path = /obj/item/clothing/under/gs13_dual_tone/security/red

/datum/gear/uniform/suit/gs13_dual_tone/white/security/medic
	display_name = "Security medic's dual tone jumpsuit (Modular)"
	path = /obj/item/clothing/under/gs13_dual_tone/security/medic

/datum/gear/uniform/suit/gs13_dual_tone/white/security/head_of_security
	display_name = "HoS's dual tone jumpsuit (Modular)"
	path = /obj/item/clothing/under/gs13_dual_tone/security/head_of_security
	gs13_department = null
	allowed_roles = list("Head of Security")

/datum/gear/uniform/suit/gs13_dual_tone/white/security/warden
	display_name = "Warden's dual tone jumpsuit (Modular)"
	path = /obj/item/clothing/under/gs13_dual_tone/security/warden
	gs13_department = null
	allowed_roles = list("Warden")

/datum/gear/uniform/suit/gs13_dual_tone/white/security/detective
	display_name = "Detective's dual tone jumpsuit (Modular)"
	path = /obj/item/clothing/under/gs13_dual_tone/security/detective


/obj/machinery/economy/vending
	var/list/gs13_dual_tone_stock

/obj/machinery/economy/vending/clothing
	gs13_dual_tone_stock = list(/obj/item/clothing/under/gs13_dual_tone = 5)

/obj/machinery/economy/vending/secdrobe
	gs13_dual_tone_stock = list(/obj/item/clothing/under/gs13_dual_tone/security = 3)

/obj/machinery/economy/vending/medidrobe
	gs13_dual_tone_stock = list(/obj/item/clothing/under/gs13_dual_tone/medbay = 3, /obj/item/clothing/under/gs13_dual_tone/medbay/paramedic = 3, /obj/item/clothing/under/gs13_dual_tone/medbay/psychologist = 3)

/obj/machinery/economy/vending/engidrobe
	gs13_dual_tone_stock = list(/obj/item/clothing/under/gs13_dual_tone/engineering = 3, /obj/item/clothing/under/gs13_dual_tone/engineering/tcomms = 3)

/obj/machinery/economy/vending/atmosdrobe
	gs13_dual_tone_stock = list(/obj/item/clothing/under/gs13_dual_tone/engineering/atmos = 3)

/obj/machinery/economy/vending/cargodrobe
	gs13_dual_tone_stock = list(/obj/item/clothing/under/gs13_dual_tone/cargo = 3, /obj/item/clothing/under/gs13_dual_tone/cargo/bitrunner = 3, /obj/item/clothing/under/gs13_dual_tone/cargo/miner = 3)

/obj/machinery/economy/vending/robodrobe
	gs13_dual_tone_stock = list(/obj/item/clothing/under/gs13_dual_tone/science/roboticist = 3)

/obj/machinery/economy/vending/scidrobe
	gs13_dual_tone_stock = list(/obj/item/clothing/under/gs13_dual_tone/science = 3)

/obj/machinery/economy/vending/hydrodrobe
	gs13_dual_tone_stock = list(/obj/item/clothing/under/gs13_dual_tone/service/hydroponics = 3)

/obj/machinery/economy/vending/bardrobe
	gs13_dual_tone_stock = list(/obj/item/clothing/under/gs13_dual_tone/service/bartender = 3)

/obj/machinery/economy/vending/chefdrobe
	gs13_dual_tone_stock = list(/obj/item/clothing/under/gs13_dual_tone/service/chef = 3)

/obj/machinery/economy/vending/janidrobe
	gs13_dual_tone_stock = list(/obj/item/clothing/under/gs13_dual_tone/service/janitor = 3)

/obj/machinery/economy/vending/lawdrobe
	gs13_dual_tone_stock = list(/obj/item/clothing/under/gs13_dual_tone/service/lawyer = 3, /obj/item/clothing/under/gs13_dual_tone/medbay/psychologist = 3)

/obj/machinery/economy/vending/chapdrobe
	gs13_dual_tone_stock = list(/obj/item/clothing/under/gs13_dual_tone/service/chaplain = 3)

/obj/machinery/economy/vending/chemdrobe
	gs13_dual_tone_stock = list(/obj/item/clothing/under/gs13_dual_tone/medbay/chemist = 3)

/obj/machinery/economy/vending/genedrobe
	gs13_dual_tone_stock = list(/obj/item/clothing/under/gs13_dual_tone/medbay/geneticist = 3)

/obj/machinery/economy/vending/virodrobe
	gs13_dual_tone_stock = list(/obj/item/clothing/under/gs13_dual_tone/medbay/virologist = 3)

/obj/machinery/economy/vending/detdrobe
	gs13_dual_tone_stock = list(/obj/item/clothing/under/gs13_dual_tone/security/detective = 3)
