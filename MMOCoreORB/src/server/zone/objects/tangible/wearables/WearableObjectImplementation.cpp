/*
 * WearableObjectImplementation.cpp
 *
 *  Created on: 02/08/2009
 *      Author: victor
 */

#include "server/zone/objects/tangible/wearables/WearableObject.h"
#include "server/zone/objects/creature/CreatureObject.h"
#include "server/zone/objects/manufactureschematic/craftingvalues/CraftingValues.h"
#include "server/zone/objects/manufactureschematic/ManufactureSchematic.h"
#include "server/zone/objects/draftschematic/DraftSchematic.h"
#include "server/zone/objects/tangible/attachment/Attachment.h"
#include "server/zone/managers/skill/SkillModManager.h"
#include "server/zone/objects/tangible/wearables/ModSortingHelper.h"
#include "server/zone/objects/transaction/TransactionLog.h"

void WearableObjectImplementation::initializeTransientMembers() {
	TangibleObjectImplementation::initializeTransientMembers();

	// Wearable has too many attachments on it for the allowed socket count
	while (usedSocketCount > socketCount) {
		wearableSkillMods.removeElementAt(wearableSkillMods.size() - 1);

		usedSocketCount--;
	}
}

void WearableObjectImplementation::fillAttributeList(AttributeListMessage* alm, CreatureObject* object) {
	TangibleObjectImplementation::fillAttributeList(alm, object);

	for(int i = 0; i < wearableSkillMods.size(); ++i) {
		String key = wearableSkillMods.elementAt(i).getKey();
		String statname = "cat_skill_mod_bonus.@stat_n:" + key;
		int value = wearableSkillMods.get(key);

		if (value > 0)
			alm->insertAttribute(statname, value);
	}

	//Anti Decay Kit
	if (hasAntiDecayKit() && !isArmorObject()){
		alm->insertAttribute("@veteran_new:antidecay_examine_title", "@veteran_new:antidecay_examine_text");
	}

}

void WearableObjectImplementation::updateCraftingValues(CraftingValues* values, bool initialUpdate) {
	/*
	 * Values available:	Range:
	 * sockets				0-0(novice artisan) (Don't use)
	 * hitpoints			1000-1000 (Don't Use)
	 */
	if (initialUpdate) {
		if(values->hasExperimentalAttribute("sockets") && values->getCurrentValue("sockets") >= 0)
			generateSockets(values);
	}
}

void WearableObjectImplementation::generateSockets(CraftingValues* craftingValues) {
	if (socketsGenerated) {
		return;
	}

	int skill = 0;
	int luck = 0;

	if (craftingValues != nullptr) {
		ManagedReference<ManufactureSchematic*> manuSchematic = craftingValues->getManufactureSchematic();

		if (manuSchematic != nullptr) {
			ManagedReference<DraftSchematic*> draftSchematic = manuSchematic->getDraftSchematic();
			ManagedReference<CreatureObject*> player = manuSchematic->getCrafter().get();

			if (player != nullptr && draftSchematic != nullptr) {
				String assemblySkill = draftSchematic->getAssemblySkill();

				skill = player->getSkillMod(assemblySkill);

				if (MIN_SOCKET_MOD > skill)
					return;

				luck = System::random(player->getSkillMod("luck") + player->getSkillMod("force_luck"));
			}
		}
	}

	skill -= MIN_SOCKET_MOD;
	int bonusMod = 65 - skill;

	if (bonusMod <= 0) {
		bonusMod = 0;
	} else {
		bonusMod = System::random(bonusMod);
	}

	int skillAdjust = skill + System::random(luck) + bonusMod;
	int maxMod = 65 + System::random(skill);

	float randomSkill = System::random(skillAdjust) * 10;
	float roll = randomSkill / (400.f + maxMod);

	float generatedCount = roll * MAXSOCKETS;

	if (generatedCount > MAXSOCKETS)
		generatedCount = MAXSOCKETS;
	else if (generatedCount > 3 && generatedCount <= 3.75f)
		generatedCount = floor(generatedCount);

	usedSocketCount = 0;
	socketCount = (int)generatedCount;

	socketCount = MAXSOCKETS;

	socketsGenerated = true;

	return;
}

void WearableObjectImplementation::applyAttachment(CreatureObject* player, Attachment* attachment) {
	if (attachment == nullptr || !isASubChildOf(player)) {
		return;
	}

	if (getRemainingSockets() < 1 || wearableSkillMods.size() > 5) {
		return;
	}

	if (isEquipped()) {
		removeSkillModsFrom(player);
	}

	Locker clocker(attachment, player);

	SortedVector<ModSortingHelper> sortedMods;
	VectorMap<String, int>* skillModifiers = attachment->getSkillMods();

	for (int i = 0; i < skillModifiers->size(); i++) {
		auto key = skillModifiers->elementAt(i).getKey();
		auto value = skillModifiers->elementAt(i).getValue();

		sortedMods.put(ModSortingHelper(key, value));
	}

	// Select the next mod in the SEA, sorted high-to-low. If that skill mod is already on the
	// wearable, with higher or equal value, don't apply and continue. Break once one mod
	// is applied.
	for (int i = 0; i < sortedMods.size(); i++) {
		String modName = sortedMods.elementAt(i).getKey();
		int modValue = sortedMods.elementAt(i).getValue();

		int existingValue = -26;

		if (wearableSkillMods.contains(modName)) {
			existingValue = wearableSkillMods.get(modName);
		}

		if (modValue > existingValue) {
			wearableSkillMods.put(modName, modValue);
			break;
		}
	}

	usedSocketCount++;
	addMagicBit(true);

	TransactionLog trx(player, asSceneObject(), attachment, TrxCode::APPLYATTACHMENT);

	if (trx.isVerbose()) {
		// Force a synchronous export because the object will be deleted before we can export it!
		trx.addRelatedObject(attachment, true);
		trx.setExportRelatedObjects(true);
		trx.exportRelated();
	}

	trx.addState("subjectSkillModMap", sortedMods);
	trx.addState("dstSkillModMap", wearableSkillMods);

	attachment->destroyObjectFromWorld(true);
	attachment->destroyObjectFromDatabase(true);

	if (isEquipped()) {
		applySkillModsTo(player);
	}
}

void WearableObjectImplementation::applySkillModsTo(CreatureObject* creature) const {
	if (creature == nullptr) {
		return;
	}

	for (int i = 0; i < wearableSkillMods.size(); ++i) {
		String name = wearableSkillMods.elementAt(i).getKey();
		int value = wearableSkillMods.get(name);

		if (name.toLowerCase() == "deity_han_solo") {
			int variableOne = 10;
			int variableTwo = 4;
			// Increased Ranged Accuracy
			creature->addSkillMod(SkillModManager::SKILLBOX, "private_ranged_accuracy_bonus", variableOne * value);
			
			// Increase Dodge
			creature->addSkillMod(SkillModManager::SKILLBOX, "dodge", variableOne * value);
			// Increase CounterAttack
			creature->addSkillMod(SkillModManager::SKILLBOX, "counterattack", variableOne * value);
			// Increase Block
			creature->addSkillMod(SkillModManager::SKILLBOX, "block", variableOne * value);
		} else if (name.toLowerCase() == "deity_chewbacca") {
			int variableOne = 100;
			
			// Increase All HAM stats
			for (int j = 0; j <= 8; j++) {
				creature->addMaxHAM(j, variableOne * value);
			}
		} else if (name.toLowerCase() == "deity_darth_vader") {
			int variableOne = 2;
			int variableTwo = -4;

			// Increase Damage Done
			creature->addSkillMod(SkillModManager::SKILLBOX, "private_item_damage_multiplier", 100 + (variableOne * value));
			creature->addSkillMod(SkillModManager::SKILLBOX, "private_item_damage_divisor", 100);
			// Decrease all defenses
			creature->addSkillMod(SkillModManager::SKILLBOX, "posture_change_down_defense", variableTwo * value);
			creature->addSkillMod(SkillModManager::SKILLBOX, "posture_change_up_defense", variableTwo * value);
			creature->addSkillMod(SkillModManager::SKILLBOX, "blind_defense", variableTwo * value);
			creature->addSkillMod(SkillModManager::SKILLBOX, "dizzy_defense", variableTwo * value);
			creature->addSkillMod(SkillModManager::SKILLBOX, "stun_defense", variableTwo * value);
			creature->addSkillMod(SkillModManager::SKILLBOX, "knockdown_defense", variableTwo * value);
			creature->addSkillMod(SkillModManager::SKILLBOX, "intimidate_defense", variableTwo * value);
			creature->addSkillMod(SkillModManager::SKILLBOX, "ranged_defense", variableTwo * value);
			creature->addSkillMod(SkillModManager::SKILLBOX, "melee_defense", variableTwo * value);
			creature->addSkillMod(SkillModManager::SKILLBOX, "combat_bleeding_defense", variableTwo * value);
		} else if (name.toLowerCase() == "deity_obi_wan") {
			int variableOne = -2;
			int variableTwo = 4;

			// Decrease Damage Done
			creature->addSkillMod(SkillModManager::SKILLBOX, "private_item_damage_multiplier", 100);
			creature->addSkillMod(SkillModManager::SKILLBOX, "private_item_damage_divisor", 100 + (variableOne * value));
			// Increase all defenses
			creature->addSkillMod(SkillModManager::SKILLBOX, "posture_change_down_defense", variableTwo * value);
			creature->addSkillMod(SkillModManager::SKILLBOX, "posture_change_up_defense", variableTwo * value);
			creature->addSkillMod(SkillModManager::SKILLBOX, "blind_defense", variableTwo * value);
			creature->addSkillMod(SkillModManager::SKILLBOX, "dizzy_defense", variableTwo * value);
			creature->addSkillMod(SkillModManager::SKILLBOX, "stun_defense", variableTwo * value);
			creature->addSkillMod(SkillModManager::SKILLBOX, "knockdown_defense", variableTwo * value);
			creature->addSkillMod(SkillModManager::SKILLBOX, "intimidate_defense", variableTwo * value);
			creature->addSkillMod(SkillModManager::SKILLBOX, "ranged_defense", variableTwo * value);
			creature->addSkillMod(SkillModManager::SKILLBOX, "melee_defense", variableTwo * value);
			creature->addSkillMod(SkillModManager::SKILLBOX, "combat_bleeding_defense", variableTwo * value);
		} else if (name.toLowerCase() == "deity_techno_union") {
			int variableOne = 1;

			// Increase Assembly and Experimentation
			creature->addSkillMod(SkillModManager::SKILLBOX, "deity_techno_union", variableOne * value);
		} else if (name.toLowerCase() == "deity_whills") {
			int variableOne = 1;
			creature->addSkillMod(SkillModManager::SKILLBOX, "deity_whills", variableOne * value);
		} else if (name.toLowerCase() == "deity_oola") {
			int variableOne = 1;
			int variableTwo = 5;
			
			// Increase Entertainer mods
			creature->addSkillMod(SkillModManager::SKILLBOX, "healing_dance_mind", variableOne * value);
			creature->addSkillMod(SkillModManager::SKILLBOX, "healing_music_mind", variableOne * value);
			// Increase Entertrainer Healing mods
			creature->addSkillMod(SkillModManager::SKILLBOX, "healing_dance_shock", variableTwo * value);
			creature->addSkillMod(SkillModManager::SKILLBOX, "healing_dance_wound", variableTwo * value);
			creature->addSkillMod(SkillModManager::SKILLBOX, "healing_music_shock", variableTwo * value);
			creature->addSkillMod(SkillModManager::SKILLBOX, "healing_music_wound", variableTwo * value);
		} else if (!SkillModManager::instance()->isWearableModDisabled(name)) {
			creature->addSkillMod(SkillModManager::WEARABLE, name, value, true);
			creature->updateSpeedAndAccelerationMods();
		}
	}

	SkillModManager::instance()->verifyWearableSkillMods(creature);
}

void WearableObjectImplementation::removeSkillModsFrom(CreatureObject* creature) {
	if (creature == nullptr) {
		return;
	}

	for (int i = 0; i < wearableSkillMods.size(); ++i) {
		String name = wearableSkillMods.elementAt(i).getKey();
		int value = wearableSkillMods.get(name);

		if (name.toLowerCase() == "deity_han_solo") {
			int variableOne = 10;
			int variableTwo = 4;
			// Increased Ranged Accuracy
			creature->removeSkillMod(SkillModManager::SKILLBOX, "private_ranged_accuracy_bonus", variableOne * value);
			
			// Increase Dodge
			creature->removeSkillMod(SkillModManager::SKILLBOX, "dodge", variableOne * value);
			// Increase CounterAttack
			creature->removeSkillMod(SkillModManager::SKILLBOX, "counterattack", variableOne * value);
			// Increase Block
			creature->removeSkillMod(SkillModManager::SKILLBOX, "block", variableOne * value);
		} else if (name.toLowerCase() == "deity_chewbacca") {
			int variableOne = -100;
			
			// Increase All HAM stats
			for (int j = 0; j <= 8; j++) {
				creature->addMaxHAM(j, variableOne * value);
			}
		} else if (name.toLowerCase() == "deity_darth_vader") {
			int variableOne = 2;
			int variableTwo = -4;

			// Increase Damage Done
			creature->removeSkillMod(SkillModManager::SKILLBOX, "private_item_damage_multiplier", 100 + (variableOne * value));
			creature->removeSkillMod(SkillModManager::SKILLBOX, "private_item_damage_divisor", 100);
			// Decrease all defenses
			creature->removeSkillMod(SkillModManager::SKILLBOX, "posture_change_down_defense", variableTwo * value);
			creature->removeSkillMod(SkillModManager::SKILLBOX, "posture_change_up_defense", variableTwo * value);
			creature->removeSkillMod(SkillModManager::SKILLBOX, "blind_defense", variableTwo * value);
			creature->removeSkillMod(SkillModManager::SKILLBOX, "dizzy_defense", variableTwo * value);
			creature->removeSkillMod(SkillModManager::SKILLBOX, "stun_defense", variableTwo * value);
			creature->removeSkillMod(SkillModManager::SKILLBOX, "knockdown_defense", variableTwo * value);
			creature->removeSkillMod(SkillModManager::SKILLBOX, "intimidate_defense", variableTwo * value);
			creature->removeSkillMod(SkillModManager::SKILLBOX, "ranged_defense", variableTwo * value);
			creature->removeSkillMod(SkillModManager::SKILLBOX, "melee_defense", variableTwo * value);
			creature->removeSkillMod(SkillModManager::SKILLBOX, "combat_bleeding_defense", variableTwo * value);
		} else if (name.toLowerCase() == "deity_obi_wan") {
			int variableOne = -2;
			int variableTwo = 4;

			// Decrease Damage Done
			creature->removeSkillMod(SkillModManager::SKILLBOX, "private_item_damage_multiplier", 100);
			creature->removeSkillMod(SkillModManager::SKILLBOX, "private_item_damage_divisor", 100 + (variableOne * value));
			// Increase all defenses
			creature->removeSkillMod(SkillModManager::SKILLBOX, "posture_change_down_defense", variableTwo * value);
			creature->removeSkillMod(SkillModManager::SKILLBOX, "posture_change_up_defense", variableTwo * value);
			creature->removeSkillMod(SkillModManager::SKILLBOX, "blind_defense", variableTwo * value);
			creature->removeSkillMod(SkillModManager::SKILLBOX, "dizzy_defense", variableTwo * value);
			creature->removeSkillMod(SkillModManager::SKILLBOX, "stun_defense", variableTwo * value);
			creature->removeSkillMod(SkillModManager::SKILLBOX, "knockdown_defense", variableTwo * value);
			creature->removeSkillMod(SkillModManager::SKILLBOX, "intimidate_defense", variableTwo * value);
			creature->removeSkillMod(SkillModManager::SKILLBOX, "ranged_defense", variableTwo * value);
			creature->removeSkillMod(SkillModManager::SKILLBOX, "melee_defense", variableTwo * value);
			creature->removeSkillMod(SkillModManager::SKILLBOX, "combat_bleeding_defense", variableTwo * value);
		} else if (name.toLowerCase() == "deity_techno_union") {
			int variableOne = 1;

			// Increase Assembly and Experimentation
			creature->removeSkillMod(SkillModManager::SKILLBOX, "deity_techno_union", variableOne * value);
		} else if (name.toLowerCase() == "deity_whills") {
			int variableOne = 1;
			creature->removeSkillMod(SkillModManager::SKILLBOX, "deity_whills", variableOne * value);
		} else if (name.toLowerCase() == "deity_oola") {
			int variableOne = 1;
			int variableTwo = 5;
			
			// Increase Entertainer mods
			creature->removeSkillMod(SkillModManager::SKILLBOX, "healing_dance_mind", variableOne * value);
			creature->removeSkillMod(SkillModManager::SKILLBOX, "healing_music_mind", variableOne * value);
			// Increase Entertrainer Healing mods
			creature->removeSkillMod(SkillModManager::SKILLBOX, "healing_dance_shock", variableTwo * value);
			creature->removeSkillMod(SkillModManager::SKILLBOX, "healing_dance_wound", variableTwo * value);
			creature->removeSkillMod(SkillModManager::SKILLBOX, "healing_music_shock", variableTwo * value);
			creature->removeSkillMod(SkillModManager::SKILLBOX, "healing_music_wound", variableTwo * value);
		} else if (!SkillModManager::instance()->isWearableModDisabled(name)) {
			creature->removeSkillMod(SkillModManager::WEARABLE, name, value, true);
			creature->updateSpeedAndAccelerationMods();
		}
	}

	SkillModManager::instance()->verifyWearableSkillMods(creature);
}

bool WearableObjectImplementation::isEquipped() {
	ManagedReference<SceneObject*> parent = getParent().get();
	if (parent != nullptr && parent->isPlayerCreature())
		return true;

	return false;
}

String WearableObjectImplementation::repairAttempt(int repairChance) {
	String message = "@error_message:";

	if (repairChance > 100) {
		repairChance = 100;
	}

	if (repairChance < 0) {
		repairChance = 0;
	}

	int reduction = (float)(-0.05f * repairChance + 0.1);

	setMaxCondition(getMaxCondition() * reduction, true);
	setConditionDamage(0, true);
	message += "sys_repair_slight";

	// if(repairChance < 25) {
	// 	message += "sys_repair_failed";
	// 	setMaxCondition(1, true);
	// 	setConditionDamage(0, true);
	// } else if(repairChance < 50) {
	// 	message += "sys_repair_imperfect";
	// 	setMaxCondition(getMaxCondition() * .65f, true);
	// 	setConditionDamage(0, true);
	// } else if(repairChance < 75) {
	// 	setMaxCondition(getMaxCondition() * .80f, true);
	// 	setConditionDamage(0, true);
	// 	message += "sys_repair_slight";
	// } else {
	// 	setMaxCondition(getMaxCondition() * .95f, true);
	// 	setConditionDamage(0, true);
	// 	message += "sys_repair_perfect";
	// }

	return message;
}

