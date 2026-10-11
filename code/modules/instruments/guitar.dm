/datum/instrument/guitar
	name = "Generic guitar-like instrument"
	category = "Guitar"
	abstract_type = /datum/instrument/guitar

/datum/instrument/guitar/steel_crisis
	name = "Crisis Steel String Guitar"
	id = "csteelgt"
	real_samples = list("36"='sound/instruments/synthesis_samples/guitar/crisis_steel/c2.ogg',
				"48"='sound/instruments/synthesis_samples/guitar/crisis_steel/c3.ogg',
				"60"='sound/instruments/synthesis_samples/guitar/crisis_steel/c4.ogg',
				"72"='sound/instruments/synthesis_samples/guitar/crisis_steel/c5.ogg')

/datum/instrument/guitar/nylon_crisis
	name = "Crisis Nylon String Guitar"
	id = "cnylongt"
	real_samples = list("36"='sound/instruments/synthesis_samples/guitar/crisis_nylon/c2.ogg',
				"48"='sound/instruments/synthesis_samples/guitar/crisis_nylon/c3.ogg',
				"60"='sound/instruments/synthesis_samples/guitar/crisis_nylon/c4.ogg',
				"72"='sound/instruments/synthesis_samples/guitar/crisis_nylon/c5.ogg')

/datum/instrument/guitar/clean_crisis
	name = "Crisis Clean Guitar"
	id = "ccleangt"
	real_samples = list("36"='sound/instruments/synthesis_samples/guitar/crisis_clean/C2.ogg',
				"48"='sound/instruments/synthesis_samples/guitar/crisis_clean/C3.ogg',
				"60"='sound/instruments/synthesis_samples/guitar/crisis_clean/C4.ogg',
				"72"='sound/instruments/synthesis_samples/guitar/crisis_clean/C5.ogg')

/datum/instrument/guitar/muted_crisis
	name = "Crisis Muted Guitar"
	id = "cmutedgt"
	real_samples = list("36"='sound/instruments/synthesis_samples/guitar/crisis_muted/C2.ogg',
				"48"='sound/instruments/synthesis_samples/guitar/crisis_muted/C3.ogg',
				"60"='sound/instruments/synthesis_samples/guitar/crisis_muted/C4.ogg',
				"72"='sound/instruments/synthesis_samples/guitar/crisis_muted/C5.ogg')

/datum/instrument/guitar/synth_legacy  // A synth version of legacy for efficiency.  Better for crowded scores.
	name = "Synth Legacy Guitar"
	id = "sleggt"
	real_samples = list("36"='sound/instruments/synthesis_samples/guitar/synth_legacy/Cn3.ogg',
				"48"='sound/instruments/synthesis_samples/guitar/synth_legacy/Cn4.ogg',
				"60"='sound/instruments/synthesis_samples/guitar/synth_legacy/Cn5.ogg',
				"72"='sound/instruments/synthesis_samples/guitar/synth_legacy/Cn6.ogg')

/datum/instrument/guitar/pgm_clean
	name = "Pigments Clean Guitar"
	id = "piclgt"
	real_samples = list("36"='sound/instruments/synthesis_samples/guitar/pgm_clean/c3.ogg',
				"48"='sound/instruments/synthesis_samples/guitar/pgm_clean/c4.ogg',
				"60"='sound/instruments/synthesis_samples/guitar/pgm_clean/c5.ogg',
				"72"='sound/instruments/synthesis_samples/guitar/pgm_clean/c6.ogg',
				"84"='sound/instruments/synthesis_samples/guitar/pgm_clean/c7.ogg')

