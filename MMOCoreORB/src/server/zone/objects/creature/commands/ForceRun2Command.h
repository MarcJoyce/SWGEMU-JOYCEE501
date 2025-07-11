/*
				Copyright <SWGEmu>
		See file COPYING for copying conditions. */

#ifndef FORCERUN2COMMAND_H_
#define FORCERUN2COMMAND_H_

#include "server/zone/objects/creature/buffs/PrivateBuff.h"
#include "server/zone/objects/creature/buffs/PrivateSkillMultiplierBuff.h"
#include "JediQueueCommand.h"

class ForceRun2Command : public JediQueueCommand {
public:
	ForceRun2Command(const String& name, ZoneProcessServer* server) : JediQueueCommand(name, server) {
		// BuffCRC's, first one is used.
		buffCRC = BuffCRC::JEDI_FORCE_RUN_2;

		// If these are active they will block buff use
		blockingCRCs.add(BuffCRC::JEDI_FORCE_RUN_1);
		blockingCRCs.add(BuffCRC::JEDI_FORCE_RUN_3);

		skillMods.put("force_run", 2);
		skillMods.put("slope_move", 66);
	}

	int doQueueCommand(CreatureObject* creature, const uint64& target, const UnicodeString& arguments) const {
		int res = creature->hasBuff(buffCRC) ? NOSTACKJEDIBUFF : doJediSelfBuffCommand(creature);

		if (res == NOSTACKJEDIBUFF) {
			creature->sendSystemMessage("You feel the force leaving your body and return to your normal speed.");
			creature->removeBuff(BuffCRC::JEDI_FORCE_RUN_2);

			ManagedReference<PrivateSkillMultiplierBuff *> regenDebuff = new PrivateSkillMultiplierBuff(creature, STRING_HASHCODE("private_force_regen_debuff"), 60*3, BuffType::JEDI);
			Locker regenLocker(regenDebuff);
			regenDebuff->setSkillModifier("private_force_regen_divisor", 4);
			regenDebuff->setSkillModifier("private_force_regen_multiplier", 3);

			// Add buffs to creature
			creature->addBuff(regenDebuff);

			creature->sendSystemMessage("You feel groggy, your ability to regenerate force power has been diminished for 3 minutes.");

			return SUCCESS;
		}

		if (res != SUCCESS) {
			return res;
		}

		// need to apply the damage reduction in a separate buff so that the multiplication and division applies right
		Buff* buff = creature->getBuff(BuffCRC::JEDI_FORCE_RUN_2);
		if (buff == nullptr)
			return GENERALERROR;

		ManagedReference<PrivateSkillMultiplierBuff*> multBuff = new PrivateSkillMultiplierBuff(creature, name.hashCode(), duration, BuffType::JEDI);

		Locker locker(multBuff);

		multBuff->setSkillModifier("private_damage_divisor", 10);
		multBuff->setSkillModifier("private_damage_multiplier", 8);

		multBuff->setSkillModifier("private_damage_susceptibility_divisor", 10);
		multBuff->setSkillModifier("private_damage_susceptibility_multiplier", 12);

		creature->addBuff(multBuff);

		locker.release();

		Locker blocker(buff);

		buff->addSecondaryBuffCRC(multBuff->getBuffCRC());

		if (creature->hasBuff(STRING_HASHCODE("burstrun")) || creature->hasBuff(STRING_HASHCODE("retreat"))) {
			creature->removeBuff(STRING_HASHCODE("burstrun"));
			creature->removeBuff(STRING_HASHCODE("retreat"));
		}

		return SUCCESS;
	}

};

#endif //FORCERUN2COMMAND_H_
