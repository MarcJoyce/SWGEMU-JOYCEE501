/*
 * CreatureTemplate.h
 *
 *  Created on: Oct 9, 2010
 *      Author: dannuic
 */

#ifndef CREATURETEMPLATE_H_
#define CREATURETEMPLATE_H_

#include "engine/engine.h"
#include "server/zone/objects/creature/ai/variables/CreatureAttackMap.h"
#include "templates/params/creature/ObjectFlag.h"
#include "templates/tangible/SharedWeaponObjectTemplate.h"
#include "server/zone/managers/loot/lootgroup/LootGroupCollection.h"

namespace server {
namespace zone {
namespace objects {
namespace creature {
namespace ai {

class CreatureTemplate : public Object {
protected:
	String templateName;
	String customName;

	unsigned int armor;

	float kinetic;
	float energy;
	float electricity;
	float stun;
	float blast;
	float heat;
	float cold;
	float acid;
	float lightSaber;

	float tamingChance;
	unsigned int ferocity;

	String meatType;
	String boneType;
	String hideType;
	String milkType;

	int milk;
	int hideAmount;
	int boneAmount;
	int meatAmount;

	String objectName;

	uint32 planetMapCategory;
	String mapCategoryName;

	uint32 planetMapSubCategory;
	String mapSubCategoryName;

	int randomNameType;
	bool randomNameTag;
	String socialGroup;
	String faction;
	int mobType;
	String healerType;

	bool tauntable;

	int level;

	float chanceHit;
	int damageMin;
	int damageMax;
	float specialDamageMult;
	int range;
	float attackSpeed;

	float scale;

	int baseXp;
	int baseHAM;
	int baseHAMmax;

	int aggroRadius;
	unsigned int pvpBitmask;
	unsigned int creatureBitmask;
	unsigned int diet;
	int lightsaberColor;

	Vector<int> hues;

	Vector<String> templates;

	LootGroupCollection lootgroups;

	String primaryWeapon;
	String secondaryWeapon;
	String thrownWeapon;

	CreatureAttackMap* primaryAttacks;
	CreatureAttackMap* secondaryAttacks;

	uint32 conversationTemplate;
	uint32 optionsBitmask;
	uint64 customAiMap;

	String patrolPathTemplate;

	String outfit;

	String aiTemplate;
	String defaultWeapon;
	String defaultAttack;

	String controlDeviceTemplate;
	String containerComponentTemplate;

	String reactionStf;
	String personalityStf;

public:
	CreatureTemplate();

	virtual ~CreatureTemplate();

	void readObject(LuaObject* templateData);

	inline float getKinetic() const {
		if (isSpecialProtection(SharedWeaponObjectTemplate::KINETIC))
			return Math::min(kinetic - 100, 90.0f);
		else
			return Math::min(kinetic, 90.0f);
	}

	inline float getEnergy() const {
		if (isSpecialProtection(SharedWeaponObjectTemplate::ENERGY))
			return Math::min(energy - 100, 90.0f);
		else
			return Math::min(energy, 90.0f);
	}

	inline float getElectricity() const {
		if (isSpecialProtection(SharedWeaponObjectTemplate::ELECTRICITY))
			return Math::min(electricity - 100, 90.0f);
		else
			return Math::min(electricity, 90.0f);
	}

	inline float getStun() const {
		if (isSpecialProtection(SharedWeaponObjectTemplate::STUN))
			return Math::min(stun - 100, 90.0f);
		else
			return Math::min(stun, 90.0f);
	}

	inline float getBlast() const {
		if (isSpecialProtection(SharedWeaponObjectTemplate::BLAST))
			return Math::min(blast - 100, 90.0f);
		else
			return Math::min(blast, 90.0f);
	}

	inline float getHeat() const {
		if (isSpecialProtection(SharedWeaponObjectTemplate::HEAT))
			return Math::min(heat - 100, 90.0f);
		else
			return Math::min(heat, 90.0f);
	}

	inline float getCold() const {
		if (isSpecialProtection(SharedWeaponObjectTemplate::COLD))
			return Math::min(cold - 100, 90.0f);
		else
			return Math::min(cold, 90.0f);
	}

	inline float getAcid() const {
		if (isSpecialProtection(SharedWeaponObjectTemplate::ACID))
			return Math::min(acid - 100, 90.0f);
		else
			return Math::min(acid, 90.0f);
	}

	inline float getLightSaber() const {
		if (isSpecialProtection(SharedWeaponObjectTemplate::LIGHTSABER))
			return Math::min(lightSaber - 100, 90.0f);
		else
			return Math::min(lightSaber, 90.0f);
	}

	inline bool isStalker() const {
		return creatureBitmask & ObjectFlag::STALKER;
	}

	inline bool isBaby() const {
		return creatureBitmask & ObjectFlag::BABY;
	}

	inline bool isKiller() const {
		return creatureBitmask & ObjectFlag::KILLER;
	}

	inline bool isHealer() const {
		return creatureBitmask & ObjectFlag::HEALER;
	}

	inline bool isPack() const {
		return creatureBitmask & ObjectFlag::PACK;
	}

	inline bool isHerd() const {
		return creatureBitmask & ObjectFlag::HERD;
	}

	inline float getTame() const {
		return tamingChance;
	}

	inline const String& getMeatType() const {
		return meatType;
	}

	inline const String& getBoneType() const {
		return boneType;
	}

	inline const String& getHideType() const {
		return hideType;
	}

	inline const String& getMilkType() const {
		return milkType;
	}

	inline const String& getCustomName() const {
		return customName;
	}

	inline float getMilk() const {
		return milk;
	}

	inline float getHideMax() const {
		return hideAmount;
	}

	inline float getBoneMax() const {
		return boneAmount;
	}

	inline float getMeatMax() const {
		return meatAmount;
	}

	inline unsigned int getFerocity() const {
		return ferocity;
	}

	inline unsigned int getArmor() const {
		return armor;
	}

	inline const String& getObjectName() const {
		return objectName;
	}

	inline uint32 getPlanetMapCategory() const {
		return planetMapCategory;
	}

	inline String getPlanetMapCategoryName() const {
		return mapCategoryName;
	}

	inline uint32 getPlanetMapSubCategory() const {
		return planetMapSubCategory;
	}

	inline String getPlanetMapSubCategoryName() const {
		return mapSubCategoryName;
	}

	inline int getRandomNameType() const {
		return randomNameType;
	}

	inline int getMobType() const {
		return mobType;
	}

	inline bool getRandomNameTag() const {
		return randomNameTag;
	}

	inline const String& getSocialGroup() const {
		return socialGroup;
	}

	inline uint32 getConversationTemplate() const {
		return conversationTemplate;
	}

	inline uint32 getOptionsBitmask() const {
		return optionsBitmask;
	}

	inline uint64 getCustomAiMap() {
		return customAiMap;
	}

	inline const String& getFaction() const {
		return faction;
	}

	inline int getLevel() const {
		return level;
	}

	inline float getChanceHit() const {
		return chanceHit;
	}

	inline float getScale() const {
		return scale;
	}

	inline int getDamageMin() const {
		return damageMin;
	}

	inline int getDamageMax() const {
		return damageMax;
	}

	inline float getAttackSpeed() const {
		return attackSpeed;
	}

	inline float getSpecialDamageMult() const {
		return specialDamageMult;
	}

	inline int getRange() const {
		return range;
	}

	inline int getBaseXp() const {
		return baseXp;
	}

	inline int getBaseHAM() const {
		return baseHAM;
	}

	inline int getBaseHAMmax() const {
		return baseHAMmax;
	}

	inline int getRandomHue() const {
		int randHue = System::random(hues.size() - 1);
		return hues.get(randHue);
	}

	inline int getHueCount() const {
		return hues.size();
	}

	inline int getTotalHues() const {
		return hues.size();
	}

	inline int getAggroRadius() const {
		return aggroRadius;
	}

	inline uint32 getPvpBitmask() const {
		return pvpBitmask;
	}

	inline uint32 getCreatureBitmask() const {
		return creatureBitmask;
	}

	inline uint32 getDiet() const {
		return diet;
	}

	inline bool isTauntable() const {
		return tauntable;
	}

	inline int getLightsaberColor() const {
		return lightsaberColor;
	}

	inline const Vector<String>& getTemplates() const {
		return templates;
	}

	inline const LootGroupCollection* getLootGroups() const {
		return &lootgroups;
	}

	inline const String& getPrimaryWeapon() const {
		return primaryWeapon;
	}

	inline const String& getSecondaryWeapon() const {
		return secondaryWeapon;
	}

	inline const String& getThrownWeapon() const {
		return thrownWeapon;
	}

	inline const CreatureAttackMap* getPrimaryAttacks() const {
		return primaryAttacks;
	}

	inline const CreatureAttackMap* getSecondaryAttacks() const {
		return secondaryAttacks;
	}

	inline const String& getPatrolPathTemplate() const {
		return patrolPathTemplate;
	}

	void setTemplateName(const String& t) {
		templateName = t;
	}

	inline const String& getTemplateName() const {
		return templateName;
	}

	inline String& getTemplateName() {
		return templateName;
	}

	inline bool hasPatrolPathTemplate() const {
		return !patrolPathTemplate.isEmpty();
	}

	inline const String& getOutfit() const {
		return outfit;
	}

	inline const String& getAiTemplate() const {
		return aiTemplate;
	}

	inline const String& getDefaultWeapon() const {
		return defaultWeapon;
	}

	inline const String& getDefaultAttack() const {
		return defaultAttack;
	}

	inline const String& getControlDeviceTemplate() const {
		return controlDeviceTemplate;
	}

	inline const String& getContainerComponentTemplate() const {
		return containerComponentTemplate;
	}

	inline const String& getReactionStf() const {
		return reactionStf;
	}

	inline const String& getPersonalityStf() const {
		return personalityStf;
	}

	inline const String& getHealerType() const {
		return healerType;
	}

	inline bool isSpecialProtection(int resistType) const {
		switch (resistType) {
		case SharedWeaponObjectTemplate::KINETIC:
			return kinetic > 100;
			break;
		case SharedWeaponObjectTemplate::ENERGY:
			return energy > 100;
			break;
		case SharedWeaponObjectTemplate::ELECTRICITY:
			return electricity > 100;
			break;
		case SharedWeaponObjectTemplate::STUN:
			return stun > 100;
			break;
		case SharedWeaponObjectTemplate::BLAST:
			return blast > 100;
			break;
		case SharedWeaponObjectTemplate::HEAT:
			return heat > 100;
			break;
		case SharedWeaponObjectTemplate::COLD:
			return cold > 100;
			break;
		case SharedWeaponObjectTemplate::ACID:
			return acid > 100;
			break;
		case SharedWeaponObjectTemplate::LIGHTSABER:
			return lightSaber > 100;
			break;
		}

		return false;
	}
};

}
}
}
}
}

using namespace server::zone::objects::creature::ai;

#endif /* CREATURETEMPLATE_H_ */
