// Palettes, names, sensors, and recolor permissions from the pinned source.
// Protective variants use the matching ordinary native uniform ratings.

/obj/item/clothing/under/gs13_dual_tone/engineering
	name = "Engineering dual tone jumpsuit (Modular)"
	desc = "Dual tone, high visibility orange jumpsuit worn by engineers. It has minor radiation shielding."
	gs13_uniform_colors = list("#ffdd00", "#ff7f00")
	gs13_protection_template = /obj/item/clothing/under/rank/engineering/engineer
	gs13_recolorable = FALSE

/obj/item/clothing/under/gs13_dual_tone/engineering/chief
	name = "Chief Engineers dual tone jumpsuit (Modular)"
	desc = "Dual tone, gray jumpsuit given to those engineers insane enough to achieve the rank of \"Chief Engineer\". It has minor radiation shielding."
	gs13_uniform_colors = list("#dfdfdf", "#ffcc33")
	gs13_protection_template = /obj/item/clothing/under/rank/engineering/chief_engineer

/obj/item/clothing/under/gs13_dual_tone/engineering/atmos
	name = "Atmospherics dual tone jumpsuit (Modular)"
	desc = "Dual tone, high visibility yellow blue jumpsuit worn by Atmospherics Technicians. It has minor fire protective plating."
	gs13_uniform_colors = list("#ffe000", "#00a9ff")

/obj/item/clothing/under/gs13_dual_tone/engineering/tcomms
	name = "Telecomms specialists dual tone jumpsuit (Modular)"
	desc = "Dual tone, high visibility yellow blue jumpsuit worn by the telecomms specialists. Don't mistake with atmos techs!"
	gs13_uniform_colors = list("#ffdd00", "#0048ff")

/obj/item/clothing/under/gs13_dual_tone/medbay
	name = "Doctors dual tone jumpsuit (Modular)"
	desc = "Dual tone, white-blue uniform worn by medical personnel. Provides minor protection against biohazards."
	gs13_uniform_colors = list("#ffffff", "#5a96bb")
	gs13_protection_template = /obj/item/clothing/under/rank/medical/doctor
	gs13_recolorable = FALSE

/obj/item/clothing/under/gs13_dual_tone/medbay/chief_medical_officer
	name = "Chief Medical Officers dual tone jumpsuit (Modular)"
	desc = "Dual tone, white jumpsuit worn by those with the experience to be \"Chief Medical Officer\". Provides minor biohazard shielding."
	gs13_uniform_colors = list("#ffffff", "#3366ff")

/obj/item/clothing/under/gs13_dual_tone/medbay/chemist
	name = "Chemists dual tone jumpsuit (Modular)"
	desc = "Dual tone, white-orange uniform worn by chemists. Provides minor protection against acids."
	gs13_uniform_colors = list("#ffffff", "#ff8800")
	gs13_protection_template = /obj/item/clothing/under/rank/medical/chemist

/obj/item/clothing/under/gs13_dual_tone/medbay/geneticist
	name = "Geneticists dual tone jumpsuit (Modular)"
	desc = "Dual tone, white-blue jumpsuit worn by geneticists. Provides minor biohazard shielding."
	gs13_uniform_colors = list("#ffffff", "#0097ca")

/obj/item/clothing/under/gs13_dual_tone/medbay/virologist
	name = "Virologists dual tone jumpsuit (Modular)"
	desc = "Dual tone, white-green jumpsuit worn by virologists. Provides minor biohazard shielding."
	gs13_uniform_colors = list("#ffffff", "#339900")

/obj/item/clothing/under/gs13_dual_tone/medbay/paramedic
	name = "Paramedics dual tone jumpsuit (Modular)"
	desc = "Dual tone, dark-blue jumpsuit with white stripes worn by paramedics. Provides minor biohazard shielding."
	gs13_uniform_colors = list("#364660", "#ffffff")

/obj/item/clothing/under/gs13_dual_tone/medbay/psychologist
	name = "Psychologists dual tone jumpsuit (Modular)"
	desc = "Dual tone, black jumpsuit with white stripes worn by psychologists."
	gs13_uniform_colors = list("#202020", "#ffffff")
	gs13_protection_template = /obj/item/clothing/under

/obj/item/clothing/under/gs13_dual_tone/science
	name = "Scientists dual tone jumpsuit (Modular)"
	desc = "Dual tone, white-purple labcoat worn by the stations eggheads. Has shielding providing minor protection against explosions."
	gs13_uniform_colors = list("#ffffff", "#aa24ea")
	gs13_protection_template = /obj/item/clothing/under/rank/rnd/scientist
	gs13_recolorable = FALSE

/obj/item/clothing/under/gs13_dual_tone/science/research_director
	name = "Research Director dual tone jumpsuit (Modular)"
	desc = "Dual tone labcoat worn by those with the know-how to achieve the position of \"Research Director\". Has shielding providing minor protection against explosions and acids."
	gs13_uniform_colors = list("#aa24ea", "#ffffff")
	gs13_protection_template = /obj/item/clothing/under/rank/rnd/rd

/obj/item/clothing/under/gs13_dual_tone/science/roboticist
	name = "Roboticists dual tone jumpsuit (Modular)"
	desc = "Dual tone, black suit worn by roboticists."
	gs13_uniform_colors = list("#363636", "#8b2400")

/obj/item/clothing/under/gs13_dual_tone/cargo
	name = "Cargo technicians dual tone jumpsuit (Modular)"
	desc = "Dual tone, yellow-gray jumpsuit worn by cargo techs. Comfy and with big pockets!"
	gs13_uniform_colors = list("#7a4400", "#303030")
	gs13_recolorable = FALSE

/obj/item/clothing/under/gs13_dual_tone/cargo/quartermaster
	name = "Quartermasters dual tone jumpsuit (Modular)"
	desc = "Dual tone, yellow-gray jumpsuit by the Quartermaster. It's specially designed to prevent back injuries caused by pushing paper."
	gs13_uniform_colors = list("#bb9042", "#c0c0c0")

/obj/item/clothing/under/gs13_dual_tone/cargo/miner
	name = "Shaft miners dual tone jumpsuit (Modular)"
	desc = "Dual tone, greenish-purple jumpsuit worn by miners. Provides good fire protection."
	gs13_uniform_colors = list("#717261", "#8a5ae1")
	gs13_protection_template = /obj/item/clothing/under/rank/cargo/miner/lavaland

/obj/item/clothing/under/gs13_dual_tone/cargo/bitrunner
	name = "Bitrunners dual tone jumpsuit (Modular)"
	desc = "Dual tone, black brown jumpsuit worn by the laziest person in the cargo department. With how long you sit in that pod, it's obvious why the outfit needs to be stretchy..."
	gs13_uniform_colors = list("#242424", "#432100")

/obj/item/clothing/under/gs13_dual_tone/security
	name = "Security officer's dual tone jumpsuit (Modular)"
	desc = "Dual tone, dark blue tactical jumpsuit worn by security officers. Comes with plating meant for pretection against melee attacks."
	gs13_uniform_colors = list("#00386e", "#222222")
	strip_delay = 50
	sensor_mode = SENSOR_COORDS
	random_sensor = FALSE
	gs13_protection_template = /obj/item/clothing/under/rank/security/officer
	gs13_recolorable = FALSE

/obj/item/clothing/under/gs13_dual_tone/security/red
	name = "Red Security officer's dual tone jumpsuit (Modular)"
	desc = "Dual tone, red tactical jumpsuit reminding you of the good old days. Comes with plating meant for pretection against melee attacks."
	gs13_uniform_colors = list("#c12d30", "#545350")

/obj/item/clothing/under/gs13_dual_tone/security/medic
	name = "Security medic dual tone jumpsuit (Modular)"
	desc = "Dual tone, deep red and white jumpsuit worn by the security medic."
	gs13_uniform_colors = list("#910000", "#c7c7c7")

/obj/item/clothing/under/gs13_dual_tone/security/head_of_security
	name = "Head of Security's dual tone jumpsuit (Modular)"
	desc = "Dual tone, dark blue tactical jumpsuit decorated for those few with the dedication to achieve the position of Head of Security."
	gs13_uniform_colors = list("#002243", "#ffdd00")
	gs13_protection_template = /obj/item/clothing/under/rank/security/head_of_security
	strip_delay = 60

/obj/item/clothing/under/gs13_dual_tone/security/warden
	name = "Wardens dual tone jumpsuit (Modular)"
	desc = "Dual tone, red tactical jumpsuit worn by the warden."
	gs13_uniform_colors = list("#002243", "#d0d0d0")

/obj/item/clothing/under/gs13_dual_tone/security/detective
	name = "Detective dual tone jumpsuit (Modular)"
	desc = "It was a dual tone, white jumpsuit like any other... but I could tell there was something wrong. It's brown stripe was stretched across their huge belly, indicating that this wasn't a mere bedsheet, but rather, something worn by this stations loose cannon..."
	gs13_uniform_colors = list("#ffffff", "#ab731c")

/obj/item/clothing/under/gs13_dual_tone/security/engineering
	name = "Engineering guard dual tone jumpsuit (Modular)"
	desc = "Dual tone, high-vis orange-white jumpsuit worn by the poor seccie assigned to the engineering department."
	gs13_uniform_colors = list("#ff7f00", "#dddddd")

/obj/item/clothing/under/gs13_dual_tone/security/medbay
	name = "Orderly dual tone jumpsuit (Modular)"
	desc = "Dual tone, white-light blue jumpsuit worn by the one person in medbay that takes the hippocratic oath as a suggestion."
	gs13_uniform_colors = list("#ffffff", "#77cdff")

/obj/item/clothing/under/gs13_dual_tone/security/science
	name = "science guard dual tone jumpsuit (Modular)"
	desc = "Dual tone, purple white jumpsuit worn by the scientists guard."
	gs13_uniform_colors = list("#dddddd", "#390039")

/obj/item/clothing/under/gs13_dual_tone/security/cargo
	name = "Customs agent dual tone jumpsuit (Modular)"
	desc = "Dual tone, brown black jumpsuit worn by the cargo guard."
	gs13_uniform_colors = list("#b7793d", "#202020")

/obj/item/clothing/under/gs13_dual_tone/security/service
	name = "Bouncers dual tone jumpsuit (Modular)"
	desc = "Dual tone, black blue jumpsuit worn by the person upholding the order at parties."
	gs13_uniform_colors = list("#171717", "#4c99ff")

/obj/item/clothing/under/gs13_dual_tone/service
	name = "Service dual tone jumpsuit (Modular)"
	desc = "You shouldn't be seeing this!"
	gs13_recolorable = FALSE

/obj/item/clothing/under/gs13_dual_tone/service/head_of_personnel
	name = "Head of Personnel dual tone jumpsuit (Modular)"
	desc = "Dual tone, navy colored jumpsuit with red stripes, worn by the defender of Ian, the \"Head of Personnel\"."
	gs13_uniform_colors = list("#006086", "#b00000")

/obj/item/clothing/under/gs13_dual_tone/service/bartender
	name = "Bartenders dual tone jumpsuit (Modular)"
	desc = "Dual tone, white jumpsuit with black stripes. Classical bartender look."
	gs13_uniform_colors = list("#ffffff", "#313131")

/obj/item/clothing/under/gs13_dual_tone/service/chaplain
	name = "Chaplains dual tone jumpsuit (Modular)"
	desc = "Dual tone, black jumpsuit with golden stripes. Deus Vult."
	gs13_uniform_colors = list("#363636", "#ffdd00")

/obj/item/clothing/under/gs13_dual_tone/service/chef
	name = "Chefs dual tone jumpsuit (Modular)"
	desc = "Dual tone, but pretty much just white, jumpsuit used by the chef."
	gs13_uniform_colors = list("#ffffff", "#c0c0c0")

/obj/item/clothing/under/gs13_dual_tone/service/hydroponics
	name = "Botanists dual tone jumpsuit (Modular)"
	desc = "Dual tone, green jumpsuit with blue stripes. Provides minor protection against plant-related hazards."
	gs13_uniform_colors = list("#6ad427", "#3164ff")

/obj/item/clothing/under/gs13_dual_tone/service/janitor
	name = "Janitors dual tone jumpsuit (Modular)"
	desc = "Dual tone, grey jumpsuit with purple stripes. Used by the station's cleankeeper, it has minor protection from biohazards."
	gs13_uniform_colors = list("#c0c0c0", "#a747c0")
	gs13_protection_template = /obj/item/clothing/under/rank/civilian/janitor

/obj/item/clothing/under/gs13_dual_tone/service/lawyer
	name = "Lawyers dual tone jumpsuit (Modular)"
	desc = "Dual tone, black jumpsuit with blue stripes. Worn by lawyers."
	gs13_uniform_colors = list("#303030", "#ffffff")

/obj/item/clothing/under/gs13_dual_tone/service/curator
	name = "Curators dual tone jumpsuit (Modular)"
	desc = "Dual tone, red jumpsuit with white stripes. Worn by curators."
	gs13_uniform_colors = list("#911719", "#ffffff")

/obj/item/clothing/under/gs13_dual_tone/service/barber
	name = "Barbers dual tone jumpsuit (Modular)"
	desc = "Fancy looking, dual tone pink and white jumpsuit."
	gs13_uniform_colors = list("#ff99d1", "#eeeeee")

/obj/item/clothing/under/gs13_dual_tone/command
	name = "Command dual tone jumpsuit (Modular)"
	desc = "You shouldn't be seeing this!"
	gs13_recolorable = FALSE

/obj/item/clothing/under/gs13_dual_tone/command/captain
	name = "Captains dual tone jumpsuit (Modular)"
	desc = "Dual tone, deep blue jumpsuit with gold markings. Worn by the most distinguished crew member aboard, the \"Captain\"."
	gs13_uniform_colors = list("#004b8f", "#e1c709")
	gs13_protection_template = /obj/item/clothing/under/rank/captain
	sensor_mode = SENSOR_COORDS
	random_sensor = FALSE

/obj/item/clothing/under/gs13_dual_tone/command/blueshield
	name = "Blueshields dual tone jumpsuit (Modular)"
	desc = "Dual tone, dark blue jumpsuit with white markings. Worn by the commands prime bodyguard."
	gs13_uniform_colors = list("#002243", "#eeeeee")
	strip_delay = 50
	gs13_protection_template = /obj/item/clothing/under/rank/procedure/blueshield
	sensor_mode = SENSOR_COORDS
	random_sensor = FALSE

/obj/item/clothing/under/gs13_dual_tone/prisonner
	name = "Prisoners dual tone jumpsuit (Modular)"
	desc = "Dual tone, orange jumpsuit with black markings. Worn by the scum of the station."
	gs13_uniform_colors = list("#ff7f00", "#202020")
	has_sensor = 2 // Native locked controls
	sensor_mode = SENSOR_COORDS
	random_sensor = FALSE
	gs13_recolorable = FALSE

/obj/item/clothing/under/gs13_dual_tone/centcom
	name = "CentComs Officer dual tone jumpsuit (Modular)"
	desc = "Dual tone, black jumpsuit with deep purple stripes. Worn by representatives of GATO corporation."
	gs13_uniform_colors = list("#1a1a20", "#ee2cb4")
	gs13_recolorable = FALSE

/obj/item/clothing/under/gs13_dual_tone/centcom/civilian
	name = "GATO flavored dual tone jumpsuit (Modular)"
	desc = "Dual tone, black jumpsuit with deep purple stripes. Worn by people obsessed with the kitty meow meow corporation."
	gs13_uniform_colors = list("#1a1a20", "#ee2cb4")
	gs13_recolorable = FALSE

/obj/item/clothing/under/gs13_dual_tone/syndicate
	name = "Syndicate dual tone jumpsuit (Modular)"
	desc = "Dual tone, black jumpsuit with red stripes, worn by the enemies of GATO"
	gs13_uniform_colors = list("#202020", "#dd0000")
	gs13_recolorable = FALSE
