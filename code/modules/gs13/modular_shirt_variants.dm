// Source shirt palettes, sensors, permissions, and native protection templates.

/obj/item/clothing/under/gs13_dual_tone/button_up/chief_engineer
	name = "Chief Engineers button up shirt (Modular)"
	desc = "A gray, button up shirt given to those engineers insane enough to achieve the rank of \"Chief Engineer\". It has minor radiation shielding."
	gs13_uniform_colors = list("#dfdfdf", "#ffcc33", "#fafafa")
	gs13_protection_template = /obj/item/clothing/under/rank/engineering/chief_engineer
	gs13_recolorable = FALSE

/obj/item/clothing/under/gs13_dual_tone/button_up/chief_medical_officer
	name = "Chief Medical Officers button up shirt (Modular)"
	desc = "White button up shirt with a blue belt, worn by those with the experience to be \"Chief Medical Officer\". Provides minor biohazard shielding."
	gs13_uniform_colors = list("#ffffff", "#ffffff", "#3366ff")
	gs13_protection_template = /obj/item/clothing/under/rank/medical/doctor
	gs13_recolorable = FALSE

/obj/item/clothing/under/gs13_dual_tone/button_up/psychologist
	name = "Psychologists button up shirt (Modular)"
	desc = "A fancy white button up shirt with black pants and belt, worn by psychologists."
	gs13_uniform_colors = list("#ffffff", "#202020", "#202060")
	gs13_protection_template = /obj/item/clothing/under
	gs13_recolorable = FALSE

/obj/item/clothing/under/gs13_dual_tone/button_up/science
	name = "Scientists button up shirt (Modular)"
	desc = "White button up shirt with a purple belt, worn by the stations eggheads. Has shielding providing minor protection against explosions."
	gs13_uniform_colors = list("#ffffff", "#ffffff", "#aa24ea")
	gs13_protection_template = /obj/item/clothing/under/rank/rnd/scientist
	gs13_recolorable = FALSE

/obj/item/clothing/under/gs13_dual_tone/button_up/science/research_director
	name = "Research Director button up shirt (Modular)"
	desc = "Deep purple shirt with black pants worn by those with the know-how to achieve the position of \"Research Director\". Has shielding providing minor protection against explosions and acids."
	gs13_uniform_colors = list("#620091", "#313131", "#5d5d5d")
	gs13_protection_template = /obj/item/clothing/under/rank/rnd/rd

/obj/item/clothing/under/gs13_dual_tone/button_up/cargo
	name = "Cargo technicians button up shirt (Modular)"
	desc = "Deep brown button up shirt worn by cargo techs. Comfy and with big pockets!"
	gs13_uniform_colors = list("#925500", "#5d5d5d", "#313131")
	gs13_recolorable = FALSE

/obj/item/clothing/under/gs13_dual_tone/button_up/cargo/quartermaster
	name = "Quartermasters button up shirt (Modular)"
	desc = "Deep brown button up shirt worn by the Quartermaster. It's specially designed to prevent back injuries caused by pushing paper."
	gs13_uniform_colors = list("#925500", "#5d5d5d", "#d39a00")

/obj/item/clothing/under/gs13_dual_tone/button_up/security/head_of_security
	name = "Head of Security's button up shirt (Modular)"
	desc = "Dual tone, dark red tactical shirt decorated for those few with the dedication to achieve the position of Head of Security."
	gs13_uniform_colors = list("#4c0000", "#252525", "#ffc411")
	gs13_protection_template = /obj/item/clothing/under/rank/security/head_of_security
	strip_delay = 60
	sensor_mode = SENSOR_COORDS
	random_sensor = FALSE
	gs13_recolorable = FALSE

/obj/item/clothing/under/gs13_dual_tone/button_up/security/detective
	name = "Detective button up shirt (Modular)"
	desc = "It was a classy, white button up shirt like any other... but I could tell there was something wrong. It's brown belt was barely holding under the strain of their huge belly, indicating that this wasn't a mere bedsheet, but rather, something worn by this stations loose cannon..."
	gs13_uniform_colors = list("#ffffff", "#804800", "#2b2b2b")

/obj/item/clothing/under/gs13_dual_tone/button_up/service/head_of_personnel
	name = "Head of Personnel button up shirt (Modular)"
	desc = "Navy colored shirt with dark pants, worn by the defender of Ian, the \"Head of Personnel\"."
	gs13_uniform_colors = list("#405cb2", "#252525", "#949494")

/obj/item/clothing/under/gs13_dual_tone/button_up/service/bartender
	name = "Bartenders button up shirt (Modular)"
	desc = "White shirt with black pants. Classical bartender look."
	gs13_uniform_colors = list("#ffffff", "#000000", "#2b2b2b")

/obj/item/clothing/under/gs13_dual_tone/button_up/service/chaplain
	name = "Chaplains button up shirt (Modular)"
	desc = "Black shirt with a white belt. Deus Vult."
	gs13_uniform_colors = list("#343434", "#333333", "#ffffff")

/obj/item/clothing/under/gs13_dual_tone/button_up/service/chef
	name = "Chefs button up shirt (Modular)"
	desc = "White shirt used by the chef."
	gs13_uniform_colors = list("#ffffff", "#333333", "#ffffff")

/obj/item/clothing/under/gs13_dual_tone/button_up/service/lawyer
	name = "Lawyers button up shirt (Modular)"
	desc = "White shirt with blue pants. Worn by lawyers."
	gs13_uniform_colors = list("#ffffff", "#0072cf", "#1a1a1a")

/obj/item/clothing/under/gs13_dual_tone/button_up/service/curator
	name = "Curators button up shirt (Modular)"
	desc = "Red shirt, brown pants and grey belt. Worn by curators."
	gs13_uniform_colors = list("#ad2626", "#9b8b63", "#404040")

/obj/item/clothing/under/gs13_dual_tone/button_up/service/barber
	name = "Barbers button up shirt (Modular)"
	desc = "Fancy looking pink shirt."
	gs13_uniform_colors = list("#ff70f0", "#ffffff", "#9a9a9a")

/obj/item/clothing/under/gs13_dual_tone/button_up/command/captain
	name = "Captains button up shirt (Modular)"
	desc = "Deep blue shirt with gold markings. Worn by the most distinguished crew member aboard, the \"Captain\"."
	gs13_uniform_colors = list("#1f50af", "#3f3f3f", "#ffcc00")
	gs13_protection_template = /obj/item/clothing/under/rank/captain
	sensor_mode = SENSOR_COORDS
	random_sensor = FALSE

/obj/item/clothing/under/gs13_dual_tone/button_up/command/blueshield
	name = "Blueshields button up shirt (Modular)"
	desc = "Dark blue shirt with grey pants and belt. Worn by the commands prime bodyguard."
	gs13_uniform_colors = list("#143573", "#3f3f3f", "#4c4c4c")
	strip_delay = 50
	gs13_protection_template = /obj/item/clothing/under/rank/procedure/blueshield
	sensor_mode = SENSOR_COORDS
	random_sensor = FALSE

/obj/item/clothing/under/gs13_dual_tone/button_up/centcom
	name = "CentComs Officer button up shirt (Modular)"
	desc = "Black shirt with a purple belt. Worn by representatives of GATO corporation."
	gs13_uniform_colors = list("#1a1a1a", "#1a1a1a", "#ff00ff")
	gs13_recolorable = FALSE

/obj/item/clothing/under/gs13_dual_tone/button_up/turtleneck/chief_engineer
	name = "Chief Engineers turtleneck shirt (Modular)"
	desc = "A gray, turtleneck shirt given to those engineers insane enough to achieve the rank of \"Chief Engineer\". It has minor radiation shielding."
	gs13_uniform_colors = list("#dfdfdf", "#ffcc33", "#fafafa")
	gs13_protection_template = /obj/item/clothing/under/rank/engineering/chief_engineer
	gs13_recolorable = FALSE

/obj/item/clothing/under/gs13_dual_tone/button_up/turtleneck/chief_medical_officer
	name = "Chief Medical Officers turtleneck shirt (Modular)"
	desc = "White turtleneck shirt with a blue belt, worn by those with the experience to be \"Chief Medical Officer\". Provides minor biohazard shielding."
	gs13_uniform_colors = list("#ffffff", "#ffffff", "#3366ff")
	gs13_protection_template = /obj/item/clothing/under/rank/medical/doctor
	gs13_recolorable = FALSE

/obj/item/clothing/under/gs13_dual_tone/button_up/turtleneck/psychologist
	name = "Psychologists turtleneck shirt (Modular)"
	desc = "A fancy white turtleneck shirt with black pants and belt, worn by psychologists."
	gs13_uniform_colors = list("#ffffff", "#202020", "#202060")
	gs13_protection_template = /obj/item/clothing/under
	gs13_recolorable = FALSE

/obj/item/clothing/under/gs13_dual_tone/button_up/turtleneck/science
	name = "Scientists turtleneck shirt (Modular)"
	desc = "White turtleneck shirt with a purple belt, worn by the stations eggheads. Has shielding providing minor protection against explosions."
	gs13_uniform_colors = list("#ffffff", "#ffffff", "#aa24ea")
	gs13_protection_template = /obj/item/clothing/under/rank/rnd/scientist
	gs13_recolorable = FALSE

/obj/item/clothing/under/gs13_dual_tone/button_up/turtleneck/science/research_director
	name = "Research Director turtleneck shirt (Modular)"
	desc = "Deep purple shirt with black pants worn by those with the know-how to achieve the position of \"Research Director\". Has shielding providing minor protection against explosions and acids."
	gs13_uniform_colors = list("#620091", "#313131", "#5d5d5d")
	gs13_protection_template = /obj/item/clothing/under/rank/rnd/rd

/obj/item/clothing/under/gs13_dual_tone/button_up/turtleneck/cargo
	name = "Cargo technicians turtleneck shirt (Modular)"
	desc = "Deep brown turtleneck shirt worn by cargo techs. Comfy and with big pockets!"
	gs13_uniform_colors = list("#925500", "#5d5d5d", "#313131")
	gs13_recolorable = FALSE

/obj/item/clothing/under/gs13_dual_tone/button_up/turtleneck/cargo/quartermaster
	name = "Quartermasters turtleneck shirt (Modular)"
	desc = "Deep brown turtleneck shirt worn by the Quartermaster. It's specially designed to prevent back injuries caused by pushing paper."
	gs13_uniform_colors = list("#925500", "#5d5d5d", "#d39a00")

/obj/item/clothing/under/gs13_dual_tone/button_up/turtleneck/security/head_of_security
	name = "Head of Security's turtleneck shirt (Modular)"
	desc = "Dual tone, dark red tactical shirt decorated for those few with the dedication to achieve the position of Head of Security."
	gs13_uniform_colors = list("#4c0000", "#252525", "#ffc411")
	gs13_protection_template = /obj/item/clothing/under/rank/security/head_of_security
	strip_delay = 60
	sensor_mode = SENSOR_COORDS
	random_sensor = FALSE
	gs13_recolorable = FALSE

/obj/item/clothing/under/gs13_dual_tone/button_up/turtleneck/security/detective
	name = "Detective turtleneck shirt (Modular)"
	desc = "It was a classy, white turtleneck shirt like any other... but I could tell there was something wrong. It's brown belt was barely holding under the strain of their huge belly, indicating that this wasn't a mere bedsheet, but rather, something worn by this stations loose cannon..."
	gs13_uniform_colors = list("#ffffff", "#804800", "#2b2b2b")

/obj/item/clothing/under/gs13_dual_tone/button_up/turtleneck/service/head_of_personnel
	name = "Head of Personnel turtleneck shirt (Modular)"
	desc = "Navy colored shirt with dark pants, worn by the defender of Ian, the \"Head of Personnel\"."
	gs13_uniform_colors = list("#405cb2", "#252525", "#949494")

/obj/item/clothing/under/gs13_dual_tone/button_up/turtleneck/service/bartender
	name = "Bartenders turtleneck shirt (Modular)"
	desc = "White shirt with black pants. Classical bartender look."
	gs13_uniform_colors = list("#ffffff", "#000000", "#2b2b2b")

/obj/item/clothing/under/gs13_dual_tone/button_up/turtleneck/service/chaplain
	name = "Chaplains turtleneck shirt (Modular)"
	desc = "Black shirt with a white belt. Deus Vult."
	gs13_uniform_colors = list("#343434", "#333333", "#ffffff")

/obj/item/clothing/under/gs13_dual_tone/button_up/turtleneck/service/chef
	name = "Chefs turtleneck shirt (Modular)"
	desc = "White shirt used by the chef."
	gs13_uniform_colors = list("#ffffff", "#333333", "#ffffff")

/obj/item/clothing/under/gs13_dual_tone/button_up/turtleneck/service/lawyer
	name = "Lawyers turtleneck shirt (Modular)"
	desc = "White shirt with blue pants. Worn by lawyers."
	gs13_uniform_colors = list("#ffffff", "#0072cf", "#1a1a1a")

/obj/item/clothing/under/gs13_dual_tone/button_up/turtleneck/service/curator
	name = "Curators turtleneck shirt (Modular)"
	desc = "Red shirt, brown pants and grey belt. Worn by curators."
	gs13_uniform_colors = list("#ad2626", "#9b8b63", "#404040")

/obj/item/clothing/under/gs13_dual_tone/button_up/turtleneck/service/barber
	name = "Barbers turtleneck shirt (Modular)"
	desc = "Fancy looking pink shirt."
	gs13_uniform_colors = list("#ff70f0", "#ffffff", "#9a9a9a")

/obj/item/clothing/under/gs13_dual_tone/button_up/turtleneck/command/captain
	name = "Captains turtleneck shirt (Modular)"
	desc = "Deep blue shirt with gold markings. Worn by the most distinguished crew member aboard, the \"Captain\"."
	gs13_uniform_colors = list("#1f50af", "#3f3f3f", "#ffcc00")
	gs13_protection_template = /obj/item/clothing/under/rank/captain
	sensor_mode = SENSOR_COORDS
	random_sensor = FALSE

/obj/item/clothing/under/gs13_dual_tone/button_up/turtleneck/command/blueshield
	name = "Blueshields turtleneck shirt (Modular)"
	desc = "Dark blue shirt with grey pants and belt. Worn by the commands prime bodyguard."
	gs13_uniform_colors = list("#143573", "#3f3f3f", "#4c4c4c")
	strip_delay = 50
	gs13_protection_template = /obj/item/clothing/under/rank/procedure/blueshield
	sensor_mode = SENSOR_COORDS
	random_sensor = FALSE

/obj/item/clothing/under/gs13_dual_tone/button_up/turtleneck/centcom
	name = "CentComs Officer turtleneck shirt (Modular)"
	desc = "Black shirt with a purple belt. Worn by representatives of GATO corporation."
	gs13_uniform_colors = list("#1a1a1a", "#1a1a1a", "#ff00ff")
	gs13_recolorable = FALSE
