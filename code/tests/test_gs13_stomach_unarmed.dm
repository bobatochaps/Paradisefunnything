/datum/game_test/room_test/gs13_native_unarmed_stomach_ejection/Run()
	var/mob/living/carbon/human/attacker = allocate(/mob/living/carbon/human)
	var/mob/living/carbon/human/target = allocate(/mob/living/carbon/human, get_turf(attacker))
	target.notransform = TRUE
	target.nutrition = 0
	attacker.dna.species.punchdamagelow = 9
	attacker.dna.species.punchdamagehigh = 9
	attacker.zone_selected = BODY_ZONE_CHEST
	var/obj/item/organ/internal/gs13_stomach/stomach = target.get_organ_slot(GS13_ORGAN_STOMACH)
	var/obj/item/coin/silver/coin = allocate(/obj/item/coin/silver)
	stomach.consume_gs13_item(coin)
	attacker.dna.species.harm(attacker, target, null)
	TEST_ASSERT_EQUAL(coin.loc, get_turf(target), "An actual qualifying native unarmed strike ejects at least one retained item")
	TEST_ASSERT_EQUAL(length(stomach.gs13_stomach_contents), 0, "Forced vomiting releases actual organ tracking")
	TEST_ASSERT_EQUAL(target.nutrition, 0, "Source forced item ejection works independently of ordinary dry heaving without negative nutrition")
	TEST_ASSERT(target.getBruteLoss() >= 9, "The integration preserves the actual native strike and source ejection trauma")

/datum/game_test/room_test/gs13_native_unarmed_stomach_gates/Run()
	var/mob/living/carbon/human/attacker = allocate(/mob/living/carbon/human)
	var/mob/living/carbon/human/target = allocate(/mob/living/carbon/human, get_turf(attacker))
	target.notransform = TRUE
	target.nutrition = 200
	attacker.zone_selected = BODY_ZONE_CHEST
	attacker.dna.species.punchdamagelow = 8
	attacker.dna.species.punchdamagehigh = 8
	var/obj/item/organ/internal/gs13_stomach/stomach = target.get_organ_slot(GS13_ORGAN_STOMACH)
	var/obj/item/coin/silver/coin = allocate(/obj/item/coin/silver)
	stomach.consume_gs13_item(coin)
	attacker.dna.species.harm(attacker, target, null)
	TEST_ASSERT_EQUAL(coin.loc, target, "A real native strike below the source threshold cannot eject contents")
	attacker.dna.species.punchdamagelow = 9
	attacker.dna.species.punchdamagehigh = 9
	var/obj/item/clothing/suit/armor/armor = allocate(/obj/item/clothing/suit/armor)
	armor.body_parts_covered = FULL_BODY
	armor.armor = getArmor(melee = 100)
	target.equip_to_slot_if_possible(armor, ITEM_SLOT_OUTER_SUIT)
	TEST_ASSERT_EQUAL(target.wear_suit, armor, "The fixture uses actual native worn armor")
	attacker.dna.species.harm(attacker, target, null)
	TEST_ASSERT_EQUAL(coin.loc, target, "Actual native armor blocking excludes source forced vomiting")
	target.drop_item_to_ground(armor)
	attacker.dna.species.unarmed.attack_verb = list("kick")
	attacker.dna.species.harm(attacker, target, null)
	TEST_ASSERT_EQUAL(coin.loc, target, "Native unarmed kick variants preserve the source exclusion")
	attacker.dna.species.unarmed.attack_verb = list("punch")
	stomach.remove(target)
	stomach.forceMove(get_turf(target))
	attacker.dna.species.harm(attacker, target, null)
	TEST_ASSERT_EQUAL(coin.loc, stomach, "The former owner's native strikes cannot eject an extracted organ's contents")
	stomach.insert(target)
	target.death()
	attacker.dna.species.harm(attacker, target, null)
	TEST_ASSERT_EQUAL(coin.loc, target, "Native corpse rules still prevent forced vomiting after death")
