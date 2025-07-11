/*
				Copyright <SWGEmu>
		See file COPYING for copying conditions.*/

#include "server/zone/objects/tangible/component/genetic/GeneticComponent.h"
#include "templates/tangible/SharedWeaponObjectTemplate.h"
#include "server/zone/objects/player/PlayerObject.h"

// #define DEBUG_GENETIC_LAB

void GeneticComponentImplementation::initializeTransientMembers() {
	ComponentImplementation::initializeTransientMembers();
}

void GeneticComponentImplementation::resetResists(CraftingValues* values) {
	if (stunResist > 0 && !isSpecialResist(SharedWeaponObjectTemplate::STUN)) {
		stunResist = 0;
		values->setCurrentValue("dna_comp_armor_stun", 0);
		values->setCurrentPercentage("dna_comp_armor_stun",0);
	}
	if (kinResist > 0  && !isSpecialResist(SharedWeaponObjectTemplate::KINETIC)) {
		kinResist = 0;
		values->setCurrentValue("dna_comp_armor_kinetic", 0);
		values->setCurrentPercentage("dna_comp_armor_kinetic",0);
	}
	/*if (saberResist > 0 && !isSpecialResist(SharedWeaponObjectTemplate::LIGHTSABER)) {
		saberResist = 0;
		values->setCurrentValue("dna_comp_armor_saber", 0);
		values->setCurrentPercentage("dna_comp_armor_saber",0);
	}*/
	if (elecResist > 0 && !isSpecialResist(SharedWeaponObjectTemplate::ELECTRICITY)){
		elecResist = 0;
		values->setCurrentValue("dna_comp_armor_electric", 0);
		values->setCurrentPercentage("dna_comp_armor_electric",0);
	}
	if (acidResist > 0 && !isSpecialResist(SharedWeaponObjectTemplate::ACID)) {
		acidResist = 0;
		values->setCurrentValue("dna_comp_armor_acid", 0);
		values->setCurrentPercentage("dna_comp_armor_acid",0);
	}
	if (coldResist > 0 && !isSpecialResist(SharedWeaponObjectTemplate::COLD)) {
		coldResist = 0;
		values->setCurrentValue("dna_comp_armor_cold", 0);
		values->setCurrentPercentage("dna_comp_armor_cold",0);
	}
	if (heatResist > 0 && !isSpecialResist(SharedWeaponObjectTemplate::HEAT)) {
		heatResist = 0;
		values->setCurrentValue("dna_comp_armor_heat", 0);
		values->setCurrentPercentage("dna_comp_armor_heat",0);
	}
	if (blastResist > 0 && !isSpecialResist(SharedWeaponObjectTemplate::BLAST)) {
		blastResist = 0;
		values->setCurrentValue("dna_comp_armor_blast", 0);
		values->setCurrentPercentage("dna_comp_armor_blast",0);
	}
	if (energyResist > 0 && !isSpecialResist(SharedWeaponObjectTemplate::ENERGY)) {
		energyResist = 0;
		values->setCurrentValue("dna_comp_armor_energy", 0);
		values->setCurrentPercentage("dna_comp_armor_energy",0);
	}
}

void GeneticComponentImplementation::updateCraftingValues(CraftingValues* values, bool firstUpdate) {
	ComponentImplementation::updateCraftingValues(values, firstUpdate);

#ifdef DEBUG_GENETIC_LAB
	info(true) << "---------- GeneticComponentImplementation::updateCraftingValues ----------";
#endif

	fortitude = values->getCurrentValue("fortitude");
	endurance = values->getCurrentValue("endurance");
	cleverness = values->getCurrentValue("cleverness");
	courage = values->getCurrentValue("courage");
	dexterity = values->getCurrentValue("dexterity");
	dependability = values->getCurrentValue("dependability");
	fierceness = values->getCurrentValue("fierceness");
	intellect = values->getCurrentValue("intellect");
	power = values->getCurrentValue("power");
	hardiness = values->getCurrentValue("hardiness");

	kinResist = values->getCurrentValue("dna_comp_armor_kinetic");
	energyResist = values->getCurrentValue("dna_comp_armor_energy");
	blastResist = values->getCurrentValue("dna_comp_armor_blast");
	heatResist = values->getCurrentValue("dna_comp_armor_heat");
	coldResist = values->getCurrentValue("dna_comp_armor_cold");
	elecResist = values->getCurrentValue("dna_comp_armor_electric");
	acidResist = values->getCurrentValue("dna_comp_armor_acid");
	stunResist = values->getCurrentValue("dna_comp_armor_stun");
	//saberResist = values->getCurrentValue("dna_comp_armor_saber");

#ifdef DEBUG_GENETIC_LAB
	info(true) << "Kinetic = " << kinResist << " Enery = " << energyResist << " Blast = " << blastResist << " Heat = " << heatResist << " Cold = " << coldResist;
	info(true) << " Electricity = " << elecResist << " Acid = " << acidResist << " Stun = " << stunResist;
#endif

	if (values->getMinValue("kineticeffectiveness") > 0)
		setSpecialResist(SharedWeaponObjectTemplate::KINETIC);
	if (values->getMinValue("blasteffectiveness") > 0)
		setSpecialResist(SharedWeaponObjectTemplate::BLAST);
	if (values->getMinValue("energyeffectiveness") > 0)
		setSpecialResist(SharedWeaponObjectTemplate::ENERGY);
	if (values->getMinValue("heateffectiveness") > 0)
		setSpecialResist(SharedWeaponObjectTemplate::HEAT);
	if (values->getMinValue("coldeffectiveness") > 0)
		setSpecialResist(SharedWeaponObjectTemplate::COLD);
	if (values->getMinValue("electricityeffectiveness") > 0)
		setSpecialResist(SharedWeaponObjectTemplate::ELECTRICITY);
	if (values->getMinValue("acideffectiveness") > 0)
		setSpecialResist(SharedWeaponObjectTemplate::ACID);
	if (values->getMinValue("stuneffectiveness") > 0)
		setSpecialResist(SharedWeaponObjectTemplate::STUN);
	/*if (values->getMinValue("lightsabereffectiveness") > 0)
		setSpecialResist(SharedWeaponObjectTemplate::LIGHTSABER);*/

	if (fortitude > 500) {
		armorRating = 1;

	// min - max values
	} else if (fortitude > 1000) {
		fortitude = 1000;
	} else if (fortitude < 0) {
		fortitude = 1;
	}

	if (endurance > 1000) {
		endurance = 1000;
	} else if (endurance < 0) {
		endurance = 1;
	}

	if (cleverness > 1000) {
		cleverness = 1000;
	} else if (cleverness < 0) {
		cleverness = 1;
	}

	if (courage > 1000) {
		courage = 1000;
	} else if (courage < 0) {
		courage = 1;
	}

	if (dependability > 1000) {
		dependability = 1000;
	} else if (dependability < 0) {
		dependability = 1;
	}

	if (dexterity > 1000) {
		dexterity = 1000;
	} else if (dexterity < 0) {
		dexterity = 1;
	}

	if (fierceness > 1000){
		fierceness = 1000;
	} else if (fierceness < 0) {
		fierceness = 1;
	}

	if (hardiness > 1000) {
		hardiness = 1000;
	} else if (hardiness < 0) {
		hardiness = 1;
	}

	if (intellect > 1000){
		intellect = 1000;
	} else if (intellect < 0) {
		intellect = 1;
	}

	if (power > 1000) {
		power = 1000;
	} else if (power < 0) {
		power = 1;
	}

	// max on resists
	if (kinResist > 90)
		kinResist = 90;
	if (energyResist > 90)
		energyResist = 90;
	if (blastResist > 90)
		blastResist = 90;
	if (heatResist > 90)
		heatResist = 90;
	if (coldResist > 90)
		coldResist = 90;
	if (elecResist > 90)
		elecResist = 90;
	if (acidResist > 90)
		acidResist = 90;
	if (stunResist > 90)
		stunResist = 90;
	//if (saberResist > 100)
		//saberResist = 10;

	// Determine other factors
	// HAM, attack speed, min/max damage toHit
	// Health: har,dex
	// Constitution: har,fort
	// Action: dex,int
	// Stamina: dex,endurance
	// Mind: int, har
	// Will: int,cle
	// Focus: int, dep
	// Strength: har,dep
	// Quickness: dex,dep

	health = (hardiness * 15) + (dexterity * 3);
	action = (dexterity * 15) + (intellect * 3);
	mind = (intellect * 15) + (hardiness * 3);

	stamina = (dexterity * 15) + (endurance * 3);
	willPower = (intellect * 15) + (cleverness * 3);
	constitution = (hardiness * 15) + (fortitude * 3);
	focus = (intellect * 15) + (dependability * 3);
	strength = (hardiness * 15) + (dependability * 3);
	quickness = (dexterity * 15) + (dependability * 3);

#ifdef DEBUG_GENETIC_LAB
	info(true) << "Health: " << health << " Action: " << action << " Mind: " << mind;
	info(true) << "Stamina: " << stamina << " Willpower: " << willPower << " Constitution: " << constitution << " Focus: " << focus << " Strength: " << strength << " Quickness: " << quickness;
#endif

	// toHit Calculation
	hit = 0.19 + (cleverness / 1500.0f);

#ifdef DEBUG_GENETIC_LAB
	info(true) << "ToHit: " << hit;
#endif

	speed = 2.5f - (ceil(courage / 10.0f) * 10.0f) / 1000;

#ifdef DEBUG_GENETIC_LAB
	info(true) << "Speed: " << speed;
#endif

	// Calculate damage
	float damage = (power * 0.8f) / 10.0f;

	// Calculate damage variable
	float damageVar = ((power / 10000.0f) * 2.0f);

	maxDam = ceil((damage * (1.0f + damageVar)) + 1.0f) * 10.0f;
	minDam = damage * (1.0f - damageVar) * 10.0f;

	minDam += (5 - (minDam % 5));

#ifdef DEBUG_GENETIC_LAB
	info(true) << "Damage: " << damage << " Damage Variable: " << damageVar;
	info(true) << "Min Damage: " << minDam;
	info(true) << "Max Damage: " << maxDam;

		// DPS calculation
	int dps = ((maxDam + minDam) / 2.0f) / speed;

	info(true) << "DPS: " << dps;

	info(true) << "---------- END GeneticComponentImplementation::updateCraftingValues ----------";
#endif
}

String GeneticComponentImplementation::convertSpecialAttack(String &attackName) {
	if (attackName == "defaultattack" || attackName == "")
		return "@combat_effects:none";
	else if (attackName == "creatureareaattack")
		return "@combat_effects:unknown_attack";
	else
		return "@combat_effects:" + attackName;
}

String GeneticComponentImplementation::resistValue(float input){
	if (input < 0) {
		return "Vulnerable";
	} else {
		StringBuffer displayvalue;
		displayvalue << Math::getPrecision(input, 0);
		return displayvalue.toString();
	}
}

void GeneticComponentImplementation::fillAttributeList(AttributeListMessage* alm, CreatureObject* creature) {
	bool godMode = false;

	if (creature != nullptr && creature->isPlayerCreature()) {
		auto ghost = creature->getPlayerObject();

		if (ghost != nullptr && ghost->isPrivileged())
			godMode = true;
	}

	alm->insertAttribute("volume", 1);
	alm->insertAttribute("crafter", craftersName);
	alm->insertAttribute("serial_number", objectSerial);

	switch (quality){
		case 1:
			alm->insertAttribute("dna_comp_quality","@obj_attr_n:dna_comp_very_high");
			break;
		case 2:
			alm->insertAttribute("dna_comp_quality","@obj_attr_n:dna_comp_high");
			break;
		case 3:
			alm->insertAttribute("dna_comp_quality","@obj_attr_n:dna_comp_above_average");
			break;
		case 4:
			alm->insertAttribute("dna_comp_quality","@obj_attr_n:dna_comp_average");
			break;
		case 5:
			alm->insertAttribute("dna_comp_quality","@obj_attr_n:dna_comp_below_average");
			break;
		case 6:
			alm->insertAttribute("dna_comp_quality","@obj_attr_n:dna_comp_low");
			break;
		case 7:
			alm->insertAttribute("dna_comp_quality","@obj_attr_n:dna_comp_very_low");
			break;
		default:
			alm->insertAttribute("dna_comp_quality","Unknown");
			break;
	}

	alm->insertAttribute("dna_comp_hardiness",(int)hardiness);
	alm->insertAttribute("dna_comp_fortitude",(int)fortitude);
	alm->insertAttribute("dna_comp_dexterity",(int)dexterity);
	alm->insertAttribute("dna_comp_endurance",(int)endurance);
	alm->insertAttribute("dna_comp_intellect",(int)intellect);
	alm->insertAttribute("dna_comp_cleverness",(int)cleverness);
	alm->insertAttribute("dna_comp_dependability",(int)dependability);
	alm->insertAttribute("dna_comp_courage",(int)courage);
	alm->insertAttribute("dna_comp_fierceness",(int)fierceness);
	alm->insertAttribute("dna_comp_power",(int)power);

	if (armorRating == 0)
		alm->insertAttribute("dna_comp_armor_rating","@obj_attr_n:armor_pierce_none");
	else if (armorRating == 1)
		alm->insertAttribute("dna_comp_armor_rating","@obj_attr_n:armor_pierce_light");
	else if (armorRating == 2)
		alm->insertAttribute("dna_comp_armor_rating","@obj_attr_n:armor_pierce_medium");
	else if (armorRating == 3)
		alm->insertAttribute("dna_comp_armor_rating","@obj_attr_n:armor_pierce_heavy");

	// Add resists
	alm->insertAttribute("dna_comp_armor_kinetic",resistValue(kinResist));
	alm->insertAttribute("dna_comp_armor_energy",resistValue(energyResist));
	alm->insertAttribute("dna_comp_armor_blast",resistValue(blastResist));
	alm->insertAttribute("dna_comp_armor_heat",resistValue(heatResist));
	alm->insertAttribute("dna_comp_armor_cold",resistValue(coldResist));
	alm->insertAttribute("dna_comp_armor_electric",resistValue(elecResist));
	alm->insertAttribute("dna_comp_armor_acid",resistValue(acidResist));
	alm->insertAttribute("dna_comp_armor_stun",resistValue(stunResist));
	//alm->insertAttribute("dna_comp_armor_saber",resistValue(saberResist));

	if (godMode) {
		alm->insertAttribute("dna_comp_armor_kinetic", kinResist);
		alm->insertAttribute("dna_comp_armor_energy", energyResist);
		alm->insertAttribute("dna_comp_armor_blast", blastResist);
		alm->insertAttribute("dna_comp_armor_heat", heatResist);
		alm->insertAttribute("dna_comp_armor_cold", coldResist);
		alm->insertAttribute("dna_comp_armor_electric", elecResist);
		alm->insertAttribute("dna_comp_armor_acid", acidResist);
		alm->insertAttribute("dna_comp_armor_stun", stunResist);
		// alm->insertAttribute("dna_comp_armor_saber", saberResist);
	}

	alm->insertAttribute("spec_atk_1",convertSpecialAttack(special1));
	alm->insertAttribute("spec_atk_2",convertSpecialAttack(special2));

	alm->insertAttribute("dna_comp_ranged_attack", ranged ? "Yes" : "No");
}

bool GeneticComponentImplementation::isSpecialResist(unsigned int type) {
	return specialResists & type;
}

void GeneticComponentImplementation::setSpecialResist(unsigned int type) {
	if (!(specialResists & type))
		specialResists |= type;
}

float GeneticComponentImplementation::getEffectiveArmor() {
	float effectiveCalc = (kinResist + energyResist + blastResist + heatResist + coldResist + elecResist + acidResist + stunResist) * 2.0f;

#ifdef DEBUG_GENETIC_LAB
	info(true) << "--- GeneticComponentImplementation::getEffectiveArmor -- Returning: " << effectiveCalc;
#endif

	return effectiveCalc;
}
