
/*
				Copyright <SWGEmu>
		See file COPYING for copying conditions. */

#ifndef FORCERUN3COMMAND_H_
#define FORCERUN3COMMAND_H_

#include "server/zone/objects/creature/buffs/PrivateBuff.h"
#include "server/zone/objects/creature/buffs/PrivateSkillMultiplierBuff.h"
#include "JediQueueCommand.h"

class ForceRun3Command : public JediQueueCommand {
public:
	ForceRun3Command(const String& name, ZoneProcessServer* server) : JediQueueCommand(name, server) {
		// BuffCRC's, first one is used.
		buffCRC = BuffCRC::JEDI_FORCE_RUN_3;

		// If these are active they will block buff use
		blockingCRCs.add(BuffCRC::JEDI_FORCE_RUN_1);
		blockingCRCs.add(BuffCRC::JEDI_FORCE_RUN_2);

		skillMods.put("force_run", 3);
		skillMods.put("slope_move", 99);
	}

	int doQueueCommand(CreatureObject* creature, const uint64& target, const UnicodeString& arguments) const {
		int res = creature->hasBuff(buffCRC) ? NOSTACKJEDIBUFF : doJediSelfBuffCommand(creature);

		if (res == NOSTACKJEDIBUFF) {
			if (res == NOSTACKJEDIBUFF) {
				creature->sendSystemMessage("You feel the force leaving your body and return to your normal speed.");
				creature->removeBuff(BuffCRC::JEDI_FORCE_RUN_3);

				ManagedReference<PrivateSkillMultiplierBuff *> regenDebuff = new PrivateSkillMultiplierBuff(creature, STRING_HASHCODE("private_force_regen_debuff"), 60*3, BuffType::JEDI);
				Locker regenLocker(regenDebuff);
				regenDebuff->setSkillModifier("private_force_regen_divisor", 4);
				regenDebuff->setSkillModifier("private_force_regen_multiplier", 3);

				// Add buffs to creature
				creature->addBuff(regenDebuff);

				creature->sendSystemMessage("You feel groggy, your ability to regenerate force power has been diminished for 3 minutes.");

				return SUCCESS;
			}
		}

		if (res != SUCCESS) {
			return res;
		}

		// need to apply the damage reduction in a separate buff so that the multiplication and division applies right
		Buff* buff = creature->getBuff(BuffCRC::JEDI_FORCE_RUN_3);
		if (buff == nullptr)
			return GENERALERROR;

		ManagedReference<PrivateSkillMultiplierBuff*> multBuff = new PrivateSkillMultiplierBuff(creature, name.hashCode(), duration, BuffType::JEDI);

		Locker locker(multBuff);

		multBuff->setSkillModifier("private_damage_divisor", 10);
		multBuff->setSkillModifier("private_damage_multiplier", 7);

		multBuff->setSkillModifier("private_damage_susceptibility_divisor", 10);
		multBuff->setSkillModifier("private_damage_susceptibility_multiplier", 13);

		creature->addBuff(multBuff);

		locker.release();

		Locker blocker(buff);

		buff->addSecondaryBuffCRC(multBuff->getBuffCRC());

		// SPECIAL - For Force Run.
		if (creature->hasBuff(STRING_HASHCODE("burstrun")) || creature->hasBuff(STRING_HASHCODE("retreat"))) {
			creature->removeBuff(STRING_HASHCODE("burstrun"));
			creature->removeBuff(STRING_HASHCODE("retreat"));
		}

		return SUCCESS;
	}

};

#endif //FORCERUN3COMMAND_H_
