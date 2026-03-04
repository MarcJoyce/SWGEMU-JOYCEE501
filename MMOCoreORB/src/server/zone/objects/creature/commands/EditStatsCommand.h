/*
				Copyright <SWGEmu>
		See file COPYING for copying conditions.*/

#ifndef EDITSTATSCOMMAND_H_
#define EDITSTATSCOMMAND_H_

#include "server/zone/managers/player/PlayerManager.h"
#include "server/zone/objects/scene/SceneObject.h"
#include "server/zone/managers/skill/SkillManager.h"

class EditStatsCommand : public QueueCommand {
public:

	EditStatsCommand(const String& name, ZoneProcessServer* server)
		: QueueCommand(name, server) {

	}

	int doQueueCommand(CreatureObject* creature, const uint64& target, const UnicodeString& arguments) const {

		ManagedReference<SceneObject*> object = server->getZoneServer()->getObject(target);
		PlayerManager* playerManager = server->getZoneServer()->getPlayerManager();

		if (object != nullptr) {
			if (!object->isCreatureObject()) {
				TangibleObject* tangibleObject = dynamic_cast<TangibleObject*>(object.get());

				if (tangibleObject != nullptr) {
					object = creature;
				} else {
					creature->sendSystemMessage("@healing_response:healing_response_77"); // Target must be a player or a creature pet in order to apply enhancements.
					return GENERALERROR;
				}
			}
		} else {
			object = creature;
		}

		CreatureObject* patient = object->asCreatureObject();

		if (!checkStateMask(creature)) {
			return INVALIDSTATE;
		}

		if (!checkInvalidLocomotions(creature)){
			return INVALIDLOCOMOTION;
		}

		StringTokenizer args(arguments.toString());
		
		try {
			String commandType;
			args.getStringToken(commandType);

			if (commandType.beginsWith("buff")) {
				String modifier;
				args.getStringToken(modifier);

				if (modifier == "reset") {
					patient->clearBuffs(true, false);
					return SUCCESS;
				}

				int medicalBuff;
				medicalBuff = args.getIntToken();

				int medicalDuration = 7200; // 2 hours in seconds
				if (args.hasMoreTokens()) {
					int parsedDuration = args.getIntToken();
					if (parsedDuration > 0) {
						medicalDuration = parsedDuration * 60 * 60;
					} else {
						creature->sendSystemMessage("Invalid duration; using default duration (7200s).");
					}
				}
				
				if (modifier == "health") {
					playerManager->doEnhanceCharacter(0x98321369, patient, medicalBuff, medicalDuration, BuffType::MEDICAL, 0); // medical_enhance_health
				} else if (modifier == "strength") {
					playerManager->doEnhanceCharacter(0x815D85C5, patient, medicalBuff, medicalDuration, BuffType::MEDICAL, 1); // medical_enhance_strength
				} else if (modifier == "constitution") {
					playerManager->doEnhanceCharacter(0x7F86D2C6, patient, medicalBuff, medicalDuration, BuffType::MEDICAL, 2); // medical_enhance_constitution
				} else if (modifier == "action") {
					playerManager->doEnhanceCharacter(0x4BF616E2, patient, medicalBuff, medicalDuration, BuffType::MEDICAL, 3); // medical_enhance_action
				} else if (modifier == "stamina") {
					playerManager->doEnhanceCharacter(0xED0040D9, patient, medicalBuff, medicalDuration, BuffType::MEDICAL, 5); // medical_enhance_stamina
				} else if (modifier == "quickness") {
					playerManager->doEnhanceCharacter(0x71B5C842, patient, medicalBuff, medicalDuration, BuffType::MEDICAL, 4); // medical_enhance_quickness
				} else if (modifier == "mind") {
					playerManager->doEnhanceCharacter(0x11C1772E, patient, medicalBuff, medicalDuration, BuffType::PERFORMANCE, 6); // performance_enhance_dance_mind
				} else if (modifier == "focus") {
					playerManager->doEnhanceCharacter(0x2E77F586, patient, medicalBuff, medicalDuration, BuffType::PERFORMANCE, 7); // performance_enhance_music_focus
				} else if (modifier == "willpower") {
					playerManager->doEnhanceCharacter(0x3EC6FCB6, patient, medicalBuff, medicalDuration, BuffType::PERFORMANCE, 8); // performance_enhance_music_willpower
				} else if (modifier == "all") {
					playerManager->doEnhanceCharacter(0x98321369, patient, medicalBuff, medicalDuration, BuffType::MEDICAL, 0); // medical_enhance_health
					playerManager->doEnhanceCharacter(0x815D85C5, patient, medicalBuff, medicalDuration, BuffType::MEDICAL, 1); // medical_enhance_strength
					playerManager->doEnhanceCharacter(0x7F86D2C6, patient, medicalBuff, medicalDuration, BuffType::MEDICAL, 2); // medical_enhance_constitution
					playerManager->doEnhanceCharacter(0x4BF616E2, patient, medicalBuff, medicalDuration, BuffType::MEDICAL, 3); // medical_enhance_action
					playerManager->doEnhanceCharacter(0xED0040D9, patient, medicalBuff, medicalDuration, BuffType::MEDICAL, 5); // medical_enhance_stamina
					playerManager->doEnhanceCharacter(0x71B5C842, patient, medicalBuff, medicalDuration, BuffType::MEDICAL, 4); // medical_enhance_quickness
					playerManager->doEnhanceCharacter(0x11C1772E, patient, medicalBuff, medicalDuration, BuffType::PERFORMANCE, 6); // performance_enhance_dance_mind
					playerManager->doEnhanceCharacter(0x2E77F586, patient, medicalBuff, medicalDuration, BuffType::PERFORMANCE, 7); // performance_enhance_music_focus
					playerManager->doEnhanceCharacter(0x3EC6FCB6, patient, medicalBuff, medicalDuration, BuffType::PERFORMANCE, 8); // performance_enhance_music_willpower
				}
			} else if (commandType.beginsWith("skill")) {
				String state;
				args.getStringToken(state);

				if (state.beginsWith("temp")) {

				String skillMod;
				args.getStringToken(skillMod);

				int amount;
				amount = args.getIntToken();
				int currentSkillModValue = patient->getSkillMod(skillMod);
				int skillModDelta = amount - currentSkillModValue;

				patient->addSkillMod(SkillModManager::BUFF, skillMod, skillModDelta, true);
				return SUCCESS;
				} else if (state.beginsWith("perm")) {
					String skillMod;
					args.getStringToken(skillMod);

					int amount;
					amount = args.getIntToken();

					int currentSkillModValue = patient->getSkillMod(skillMod);
					int skillModDelta = amount - currentSkillModValue;

					patient->addSkillMod(SkillModManager::SKILLBOX, skillMod, skillModDelta, true);
					return SUCCESS;
				}
			}
			else if (commandType.beginsWith("vis")) {
				int vis;
				vis = args.getIntToken();

				Reference<PlayerObject*> ghost = patient->getSlottedObject("ghost").castTo<PlayerObject*>();

				ghost->setVisibility(vis);
				return SUCCESS;
			}
			else if (commandType.beginsWith("surrenderAllSkills")) {
				SkillManager::instance()->surrenderAllSkills(patient, true, true, true);
				patient->sendSystemMessage("All skills unlearned.");
				return SUCCESS;
			}
			else if (commandType.beginsWith("experience")) {
				String type;
				args.getStringToken(type);

				int amount;
				amount = args.getIntToken();

				playerManager->awardExperience(patient, type, amount, true);
			}
			
			return SUCCESS;
		} catch (Exception& e) {
			creature->sendSystemMessage("Syntax: /editStats buff health, action... / all amount duration(hours)");
			creature->sendSystemMessage("Syntax: /editStats skill temp/perm skill_modifier amount");
			creature->sendSystemMessage("Syntax: /editStats vis amount");
		}

		return SUCCESS;
	}

};

#endif //EDITSTATSCOMMAND_H_
