/*
 * LuaCreatureObject.cpp
 *
 *  Created on: 31/08/2009
 *      Author: victor
 */

#include "LuaCreatureObject.h"
#include "server/zone/objects/creature/CreatureObject.h"
#include "server/zone/objects/creature/ai/DroidObject.h"
#include "server/zone/objects/cell/CellObject.h"
#include "server/zone/objects/player/sessions/ConversationSession.h"
#include "server/zone/ZoneServer.h"
#include "server/zone/objects/group/GroupObject.h"
#include "server/zone/objects/player/sessions/EntertainingSession.h"
#include "server/zone/objects/player/PlayerObject.h"
#include "server/zone/managers/player/PlayerManager.h"
#include "server/zone/managers/skill/SkillManager.h"
#include "server/zone/objects/tangible/threat/ThreatMap.h"
#include "server/zone/objects/transaction/TransactionLog.h"
#include "server/zone/Zone.h"
#include "server/zone/managers/combat/CombatManager.h"
#include "server/zone/objects/player/events/StoreSpawnedChildrenTask.h"
#include "server/zone/objects/mission/MissionObject.h"
#include "server/zone/managers/mission/MissionManager.h"

const char LuaCreatureObject::className[] = "LuaCreatureObject";

Luna<LuaCreatureObject>::RegType LuaCreatureObject::Register[] = {
		{ "_setObject", &LuaCreatureObject::_setObject },
		{ "_getObject", &LuaSceneObject::_getObject },
		{ "sendSystemMessage", &LuaCreatureObject::sendSystemMessage },
		{ "sendSystemMessageWithDI", &LuaCreatureObject::sendSystemMessageWithDI },
		{ "sendSystemMessageWithTO", &LuaCreatureObject::sendSystemMessageWithTO },
		{ "sendGroupMessage", &LuaCreatureObject::sendGroupMessage },
		{ "playMusicMessage", &LuaCreatureObject::playMusicMessage },
		{ "sendNewbieTutorialRequest", &LuaCreatureObject::sendNewbieTutorialRequest },
		{ "hasScreenPlayState", &LuaCreatureObject::hasScreenPlayState },
		{ "setScreenPlayState", &LuaCreatureObject::setScreenPlayState },
		{ "getScreenPlayState", &LuaCreatureObject::getScreenPlayState },
		{ "playEffect", &LuaSceneObject::playEffect },
		{ "sendNewbieTutorialEnableHudElement", &LuaCreatureObject::sendNewbieTutorialEnableHudElement },
		{ "getInCellNumber", &LuaCreatureObject::getInCellNumber },
		{ "getBuildingParentID", &LuaCreatureObject::getBuildingParentID },
		{ "sendOpenHolocronToPageMessage", &LuaCreatureObject::sendOpenHolocronToPageMessage },
		{ "inflictDamage", &LuaCreatureObject::inflictDamage },
		{ "setHAM", &LuaCreatureObject::setHAM },
		{ "setBaseHAM", &LuaCreatureObject::setBaseHAM },
		{ "setMaxHAM", &LuaCreatureObject::setMaxHAM },
		{ "getHAM", &LuaCreatureObject::getHAM },
		{ "getBaseHAM", &LuaCreatureObject::getBaseHAM },
		{ "getMaxHAM", &LuaCreatureObject::getMaxHAM },
		{ "getTargetID", &LuaCreatureObject::getTargetID },
		{ "clearCombatState", &LuaCreatureObject::clearCombatState },
		{ "getParent", &LuaSceneObject::getParent },
		{ "getZoneName", &LuaSceneObject::getZoneName },
		{ "getObjectID", &LuaSceneObject::getObjectID },
		{ "getPositionX", &LuaSceneObject::getPositionX },
		{ "getPositionY", &LuaSceneObject::getPositionY },
		{ "getPositionZ", &LuaSceneObject::getPositionZ },
		{ "getDirectionAngle", &LuaSceneObject::getDirectionAngle },
		{ "getWorldPositionX", &LuaSceneObject::getWorldPositionX },
		{ "getWorldPositionY", &LuaSceneObject::getWorldPositionY },
		{ "getWorldPositionZ", &LuaSceneObject::getWorldPositionZ },
		{ "getParentID", &LuaSceneObject::getParentID },
		{ "isInRangeWithObject", &LuaSceneObject::isInRangeWithObject },
		{ "isInRangeWithObject3d", &LuaSceneObject::isInRangeWithObject3d },
		{ "getDistanceTo", &LuaSceneObject::getDistanceTo },
		{ "getDistanceToPosition", &LuaSceneObject::getDistanceToPosition },
		{ "getDistanceTo3d", &LuaSceneObject::getDistanceTo3d },
		{ "getDistanceToPosition3d", &LuaSceneObject::getDistanceToPosition3d },
		{ "getServerObjectCRC", &LuaSceneObject::getServerObjectCRC },
		{ "isFeigningDeath", &LuaCreatureObject::isFeigningDeath},
		{ "hasState", &LuaCreatureObject::hasState},
		{ "setState", &LuaCreatureObject::setState},
		{ "clearState", &LuaCreatureObject::clearState},
		{ "setLootRights", &LuaCreatureObject::setLootRights},
		{ "getPosture", &LuaCreatureObject::getPosture},
		{ "setPosture", &LuaCreatureObject::setPosture},
		{ "setMoodString", &LuaCreatureObject::setMoodString},
		{ "getMoodString", &LuaCreatureObject::getMoodString},
		{ "hasSkill", &LuaCreatureObject::hasSkill},
		{ "removeSkill", &LuaCreatureObject::removeSkill},
		{ "surrenderSkill", &LuaCreatureObject::surrenderSkill},
		{ "getConversationSession", &LuaCreatureObject::getConversationSession},
		{ "doAnimation", &LuaCreatureObject::doAnimation},
		{ "engageCombat", &LuaCreatureObject::engageCombat},
		{ "getPlayerObject", &LuaCreatureObject::getPlayerObject},
		{ "setCustomObjectName", &LuaSceneObject::setCustomObjectName},
		{ "getFaction", &LuaCreatureObject::getFaction},
		{ "setFaction", &LuaCreatureObject::setFaction},
		{ "isRebel", &LuaCreatureObject::isRebel},
		{ "isImperial", &LuaCreatureObject::isImperial},
		{ "isNeutral", &LuaCreatureObject::isNeutral},
		{ "teleport", &LuaSceneObject::teleport},
		{ "getFirstName", &LuaCreatureObject::getFirstName},
		{ "getLastName", &LuaCreatureObject::getLastName},
		{ "setLastName", &LuaCreatureObject::setLastName},
		{ "isAiAgent", &LuaCreatureObject::isAiAgent},
		{ "setFactionRank", &LuaCreatureObject::setFactionRank},
		{ "getFactionRank", &LuaCreatureObject::getFactionRank},
		{ "getCashCredits", &LuaCreatureObject::getCashCredits},
		{ "getBankCredits", &LuaCreatureObject::getBankCredits },
		{ "subtractCashCredits", &LuaCreatureObject::subtractCashCredits},
		{ "subtractBankCredits", &LuaCreatureObject::subtractBankCredits},
		{ "addCashCredits", &LuaCreatureObject::addCashCredits},
		{ "addBankCredits", &LuaCreatureObject::addBankCredits},
		{ "removeScreenPlayState", &LuaCreatureObject::removeScreenPlayState},
		{ "isGrouped", &LuaCreatureObject::isGrouped},
		{ "isGroupedWith", &LuaCreatureObject::isGroupedWith},
		{ "getGroupSize", &LuaCreatureObject::getGroupSize},
		{ "getGroupMember", &LuaCreatureObject::getGroupMember},
		{ "getOptionsBitmask", &LuaTangibleObject::getOptionsBitmask},
		{ "setOptionsBitmask", &LuaCreatureObject::setOptionsBitmask},
		{ "setOptionBit", &LuaTangibleObject::setOptionBit},
		{ "clearOptionBit", &LuaTangibleObject::clearOptionBit},
		{ "getPvpStatusBitmask", &LuaTangibleObject::getPvpStatusBitmask},
		{ "setPvpStatusBitmask", &LuaTangibleObject::setPvpStatusBitmask},
		{ "setPvpStatusBit", &LuaTangibleObject::setPvpStatusBit},
		{ "isChangingFactionStatus", &LuaTangibleObject::isChangingFactionStatus },
		{ "getFactionStatus", &LuaTangibleObject::getFactionStatus },
		{ "setFutureFactionStatus", &LuaTangibleObject::setFutureFactionStatus },
		{ "addDotState", &LuaCreatureObject::addDotState},
		{ "getSlottedObject", &LuaSceneObject::getSlottedObject},
		{ "checkCooldownRecovery", &LuaCreatureObject::checkCooldownRecovery},
		{ "addCooldown", &LuaCreatureObject::addCooldown},
		{ "isDead", &LuaCreatureObject::isDead},
		{ "isIncapacitated", &LuaCreatureObject::isIncapacitated },
		{ "getLevel", &LuaCreatureObject::getLevel},
		{ "getQueueSize", &LuaCreatureObject::getQueueSize },
		{ "isDancing", &LuaCreatureObject::isDancing},
		{ "isPlayingMusic", &LuaCreatureObject::isPlayingMusic},
		{ "getPerformanceName", &LuaCreatureObject::getPerformanceName},
		{ "getWalkSpeed", &LuaCreatureObject::getWalkSpeed },
		{ "isAttackableBy", &LuaCreatureObject::isAttackableBy },
		{ "getSpecies", &LuaCreatureObject::getSpecies },
		{ "isDroidPet", &LuaCreatureObject::isDroidPet },
		{ "isCombatDroidPet", &LuaCreatureObject::isCombatDroidPet },
		{ "awardExperience", &LuaCreatureObject::awardExperience },
		{ "getOwner", &LuaCreatureObject::getOwner },
		{ "getCurrentSpeed", &LuaCreatureObject::getCurrentSpeed },
		{ "isInvisible", &LuaTangibleObject::isInvisible },
		{ "isInCombat", &LuaCreatureObject::isInCombat },
		{ "healDamage", &LuaCreatureObject::healDamage },
		{ "getGroupID", &LuaCreatureObject::getGroupID },
		{ "enhanceCharacter", &LuaCreatureObject::enhanceCharacter },
		{ "setWounds", &LuaCreatureObject::setWounds },
		{ "setShockWounds", &LuaCreatureObject::setShockWounds },
		{ "getForceSensitiveSkillCount", &LuaCreatureObject::getForceSensitiveSkillCount },
		{ "villageKnightPrereqsMet", &LuaCreatureObject::villageKnightPrereqsMet },
		{ "isOnLeave", &LuaTangibleObject::isOnLeave },
		{ "isOvert", &LuaTangibleObject::isOvert },
		{ "isCovert", &LuaTangibleObject::isCovert },
		{ "setFactionStatus", &LuaTangibleObject::setFactionStatus },
		{ "getDamageDealerList", &LuaCreatureObject::getDamageDealerList },
		{ "getHealingThreatList", &LuaCreatureObject::getHealingThreatList },
		{ "getAllThreatsList", &LuaCreatureObject::getAllThreatsList },
		{ "dropFromThreatMap", &LuaCreatureObject::dropFromThreatMap },
		{ "getSkillMod", &LuaCreatureObject::getSkillMod },
		{ "getGender", &LuaCreatureObject::getGender },
		{ "isRidingMount", &LuaCreatureObject::isRidingMount },
		{ "dismount", &LuaCreatureObject::dismount },
		{ "setAppearance", &LuaCreatureObject::setAppearance },
		{ "getMainDefender", &LuaTangibleObject::getMainDefender },
		{ "getWeaponType", &LuaCreatureObject::getWeaponType },
		{ "attemptPeace", &LuaCreatureObject::attemptPeace },
		{ "forcePeace", &LuaCreatureObject::forcePeace },
		{ "isPilotingShip", &LuaCreatureObject::isPilotingShip },
		{ "storePets", &LuaCreatureObject::storePets },

		// Custom

		{ "buffSingleStat", &LuaCreatureObject::buffSingleStat },
		{ "removeBuffs", &LuaCreatureObject::removeBuffs },
		{ "emptyStomach", &LuaCreatureObject::emptyStomach },
		{ "getActivePetsSize", &LuaCreatureObject::getActivePetsSize },
		{ "getActivePet", &LuaCreatureObject::getActivePet },

		// JTL
		{ "isRebelPilot", &LuaCreatureObject::isRebelPilot },
		{ "isImperialPilot", &LuaCreatureObject::isImperialPilot },
		{ "isNeutralPilot", &LuaCreatureObject::isNeutralPilot },
		{ "hasCertifiedShip", &LuaCreatureObject::hasCertifiedShip },
		{ "abortQuestMission", &LuaCreatureObject::abortQuestMission },
		{ "removeQuestMission", &LuaCreatureObject::removeQuestMission },
		{ "addSpaceMissionObject", &LuaCreatureObject::addSpaceMissionObject },
		{ "removeSpaceMissionObject", &LuaCreatureObject::removeSpaceMissionObject },
		{ 0, 0 }
};

LuaCreatureObject::LuaCreatureObject(lua_State *L) : LuaTangibleObject(L) {
#ifdef DYNAMIC_CAST_LUAOBJECTS
	realObject = dynamic_cast<CreatureObject*>(_getRealSceneObject());

	E3_ASSERT(!_getRealSceneObject() || realObject != nullptr);
#else
	realObject = static_cast<CreatureObject*>(lua_touserdata(L, 1));
#endif
}

LuaCreatureObject::~LuaCreatureObject(){
}

int LuaCreatureObject::_setObject(lua_State* L) {
	LuaTangibleObject::_setObject(L);

#ifdef DYNAMIC_CAST_LUAOBJECTS
	auto obj = dynamic_cast<CreatureObject*>(_getRealSceneObject());

	if (obj != realObject)
		realObject = obj;

	E3_ASSERT(!_getRealSceneObject() || realObject != nullptr);
#else
	auto obj = static_cast<CreatureObject*>(lua_touserdata(L, -1));

	if (realObject != obj)
		realObject = obj;
#endif

	return 0;
}

int LuaCreatureObject::getFirstName(lua_State* L) {
	String text = realObject->getFirstName();
	lua_pushstring(L, text.toCharArray());
	return 1;
}

int LuaCreatureObject::getLastName(lua_State* L) {
	String text = realObject->getLastName();
	lua_pushstring(L, text.toCharArray());
	return 1;
}

int LuaCreatureObject::setLastName(lua_State* L) {
	int argc = lua_gettop(L) - 1;

	if (argc < 1 || argc > 2) {
		Logger::console.error("incorrect number of arguments for LuaCreatureObject::setLastName");
		return 0;
	}

	String newLastName;
	bool skipVerify;

	if (argc == 1) {
		newLastName = lua_tostring(L, -1);
		skipVerify = false;
	} else {
		newLastName = lua_tostring(L, -2);
		skipVerify = lua_toboolean(L, -1);
	}

	Locker locker(realObject);

	auto errmsg = realObject->setLastName(newLastName, skipVerify);

	lua_pushstring(L, errmsg.toCharArray());

	return 1;
}

int LuaCreatureObject::addDotState(lua_State* L) {
	//addDotState(unsigned long dotType, unsigned int strength, byte type, unsigned int duration, float potency, unsigned int defense)
	uint32 defense = lua_tointeger(L, -1);
	uint32 objectID = lua_tointeger(L, -2);
	float potency = lua_tonumber(L, -3);
	uint32 duration = lua_tointeger(L, -4);
	byte type = lua_tointeger(L, -5);
	uint32 strength = lua_tointeger(L, -6);
	uint64 dotType = lua_tointeger(L, -7);
	CreatureObject* attacker = (CreatureObject*)lua_touserdata(L, -8);

	Locker locker(realObject);

	realObject->addDotState(attacker, dotType, objectID, strength, type, duration, potency, defense);

	return 0;
}

int LuaCreatureObject::isFeigningDeath(lua_State* L) {
	lua_pushnumber(L, realObject->isFeigningDeath());
	return 1;
}

int LuaCreatureObject::hasState(lua_State* L) {
	uint64 state = (uint64) lua_tonumber(L, -1);

	lua_pushnumber(L, realObject->hasState(state));
	return 1;
}

int LuaCreatureObject::setState(lua_State* L) {
	uint64 state = (uint64) lua_tonumber(L, -1);

	Locker locker(realObject);

	realObject->setState(state, true);

	return 0;
}

int LuaCreatureObject::clearState(lua_State* L) {
	uint64 state = (uint64) lua_tonumber(L, -1);

	Locker locker(realObject);

	realObject->clearState(state, true);

	return 0;
}

int LuaCreatureObject::getPosture(lua_State* L) {
	lua_pushnumber(L, realObject->getPosture());

	return 1;
}

int LuaCreatureObject::setPosture(lua_State* L) {
	uint32 posture = (uint32) lua_tonumber(L, -1);

	Locker locker(realObject);

	realObject->setPosture(posture, true);

	return 0;
}

int LuaCreatureObject::setMoodString(lua_State* L) {
	String value = lua_tostring(L, -1);

	Locker locker(realObject);

	realObject->setMoodString(value);

	return 0;
}

int LuaCreatureObject::getMoodString(lua_State* L) {
	String mood = realObject->getMoodString();

	lua_pushstring(L, mood.toCharArray());

	return 1;
}

int LuaCreatureObject::sendOpenHolocronToPageMessage(lua_State* L) {
	String value = lua_tostring(L, -1);

	realObject->sendOpenHolocronToPageMessage(value);

	return 0;
}

int LuaCreatureObject::sendSystemMessage(lua_State* L) {
	if (lua_islightuserdata(L, -1)) {
		StringIdChatParameter* message = (StringIdChatParameter*)lua_touserdata(L, -1);
		realObject->sendSystemMessage(*message);
	} else {
		String value = lua_tostring(L, -1);
		realObject->sendSystemMessage(value);
	}
	return 0;
}

int LuaCreatureObject::sendSystemMessageWithDI(lua_State* L) {
	String text = lua_tostring(L, -2);
	uint32 value = (uint32) lua_tonumber(L, -1);

	StringIdChatParameter param(text);
	param.setDI(value);

	realObject->sendSystemMessage(param);

	return 0;
}

int LuaCreatureObject::sendSystemMessageWithTO(lua_State* L) {
	String text = lua_tostring(L, -2);
	String value = lua_tostring(L, -1);

	StringIdChatParameter param(text);
	param.setTO(value);

	realObject->sendSystemMessage(param);

	return 0;
}

int LuaCreatureObject::sendSystemMessageWithTT(lua_State* L) {
	String text = lua_tostring(L, -2);
	String value = lua_tostring(L, -1);

	StringIdChatParameter param(text);
	param.setTT(value);

	realObject->sendSystemMessage(param);

	return 0;
}

int LuaCreatureObject::sendGroupMessage(lua_State* L) {
	String value = lua_tostring(L, -1);

	if (realObject == nullptr)
		return 0;

	if (!realObject->isGrouped()) {
		realObject->sendSystemMessage(value);
	} else {
		GroupObject* group = realObject->getGroup();

		group->sendSystemMessage(value);
	}

	return 0;
}

int LuaCreatureObject::setHAM(lua_State* L) {
	uint32 type = (uint32) lua_tonumber(L, -2);
	uint32 value = (uint32) lua_tonumber(L, -1);

	Locker locker(realObject);

	realObject->setHAM(type, value);

	return 0;
}

int LuaCreatureObject::setBaseHAM(lua_State* L) {
	uint32 type = (uint32) lua_tonumber(L, -2);
	uint32 value = (uint32) lua_tonumber(L, -1);

	Locker locker(realObject);

	realObject->setBaseHAM(type, value);

	return 0;
}

int LuaCreatureObject::setMaxHAM(lua_State* L) {
	uint32 type = (uint32) lua_tonumber(L, -2);
	uint32 value = (uint32) lua_tonumber(L, -1);

	Locker locker(realObject);

	realObject->setMaxHAM(type, value);

	return 0;
}

int LuaCreatureObject::playMusicMessage(lua_State *L) {
	String value = lua_tostring(L, -1);
	realObject->playMusicMessage(value);

	return 0;
}

int LuaCreatureObject::sendNewbieTutorialRequest(lua_State *L) {
	String value = lua_tostring(L, -1);
	realObject->sendNewbieTutorialRequest(value);

	return 0;
}

int LuaCreatureObject::hasScreenPlayState(lua_State *L) {
	String play = lua_tostring(L, -1);
	uint64 stateToCheck = lua_tointeger(L, -2);

	uint64 state = realObject->getScreenPlayState(play);

	bool check = state & stateToCheck;

	lua_pushboolean(L, check);

	return 1;
}

int LuaCreatureObject::getScreenPlayState(lua_State *L) {
	String play = lua_tostring(L, -1);
	uint64 state = realObject->getScreenPlayState(play);

	lua_pushinteger(L, state);

	return 1;
}

int LuaCreatureObject::sendNewbieTutorialEnableHudElement(lua_State* L) {
	String ui = lua_tostring(L, -3);
	int enable = lua_tonumber(L, -2);
	float blinkCount = lua_tonumber(L, -1);

	realObject->sendNewbieTutorialEnableHudElement(ui, enable, blinkCount);

	return 0;
}

int LuaCreatureObject::hasSkill(lua_State* L) {
	String value = lua_tostring(L, -1);

	bool check = realObject->hasSkill(value);

	lua_pushboolean(L, check);

	return 1;
}

int LuaCreatureObject::removeSkill(lua_State* L) {
	String value = lua_tostring(L, -1);

	Locker locker(realObject);

	realObject->removeSkill(value, true);
	return 0;
}

int LuaCreatureObject::surrenderSkill(lua_State* L) {
	String value = lua_tostring(L, -1);

	SkillManager* skillManager = SkillManager::instance();
	skillManager->surrenderSkill(value, realObject, true, true, true);
	return 0;
}

int LuaCreatureObject::getInCellNumber(lua_State* L) {
	SceneObject* parent = realObject->getParent().get().get();

	if (parent == nullptr || !parent->isCellObject())
		lua_pushnumber(L, -1);
	else {
		int cellId = ((CellObject*)parent)->getCellNumber();

		lua_pushnumber(L, cellId);
	}

	return 1; // we return the number of vars pushed to the L stack
}

int LuaCreatureObject::getBuildingParentID(lua_State* L) {
	ManagedReference<SceneObject*> parent = realObject->getParentRecursively(SceneObjectType::BUILDING);

	if (parent == nullptr)
		lua_pushnumber(L, 0);
	else
		lua_pushnumber(L, parent->getObjectID());

	return 1;
}

int LuaCreatureObject::setScreenPlayState(lua_State *L) {
	String play = lua_tostring(L, -1);
	uint64 stateToSet = lua_tointeger(L, -2);

	realObject->setScreenPlayState(play, stateToSet | realObject->getScreenPlayState(play));
	realObject->notifyObservers(ObserverEventType::SCREENPLAYSTATECHANGED, realObject);
	return 0;
}

int LuaCreatureObject::removeScreenPlayState(lua_State* L) {
	String play = lua_tostring(L, -1);
	uint64 stateToClear = lua_tointeger(L, -2);

	if (realObject != nullptr) {
		realObject->setScreenPlayState(play, realObject->getScreenPlayState(play) & (~stateToClear));
		realObject->notifyObservers(ObserverEventType::SCREENPLAYSTATECHANGED, realObject);
	}
	return 0;
}

int LuaCreatureObject::getTargetID(lua_State* L) {
	uint64 targetID = realObject->getTargetID();

	lua_pushinteger(L, targetID);

	return 1;
}

int LuaCreatureObject::clearCombatState(lua_State* L) {
	bool clearDef = lua_tonumber(L, -1);

	Locker locker(realObject);

	realObject->clearCombatState(clearDef);

	return 0;
}

int LuaCreatureObject::getHAM(lua_State* L) {
	int type = lua_tonumber(L, -1);

	int value = realObject->getHAM(type);

	lua_pushnumber(L, value);

	return 1;
}

int LuaCreatureObject::getBaseHAM(lua_State* L) {
	int type = lua_tonumber(L, -1);

	int value = realObject->getBaseHAM(type);

	lua_pushnumber(L, value);

	return 1;
}

int LuaCreatureObject::getMaxHAM(lua_State* L) {
	int type = lua_tonumber(L, -1);

	int value = realObject->getMaxHAM(type);

	lua_pushnumber(L, value);

	return 1;
}

int LuaCreatureObject::inflictDamage(lua_State* L) {
 //int inflictDamage(TangibleObject attacker, int damageType, int damage, boolean destroy, boolean notifyClient = true);
	int destroy = lua_tonumber(L, -1);
	int damage = lua_tonumber(L, -2);
	int damageType = lua_tonumber(L, -3);

	SceneObject* scene = (SceneObject*) lua_touserdata(L, -4);

	TangibleObject* attacker = cast<TangibleObject*>(scene);

	E3_ASSERT(attacker);

	Locker locker(realObject);

	Locker crossLocker(attacker, realObject);

	realObject->inflictDamage(attacker, damageType, damage, destroy);

	return 0;
}

int LuaCreatureObject::getBankCredits(lua_State *L) {
	lua_pushnumber(L, realObject->getBankCredits());

	return 1; // we return the number of vars pushed to the L stack
}

int LuaCreatureObject::getConversationSession(lua_State* L) {
	Reference<ConversationSession*> session = realObject->getActiveSession(SessionFacadeType::CONVERSATION).castTo<ConversationSession*>();

	if (session != nullptr) {
		session->_setUpdated(true);
		lua_pushlightuserdata(L, session);
	} else
		lua_pushnil(L);

	return 1;
}

int LuaCreatureObject::doAnimation(lua_State* L) {
	String animString = lua_tostring(L, -1);

	if (realObject != nullptr)
		realObject->doAnimation(animString);

	return 0;
}

int LuaCreatureObject::engageCombat(lua_State* L) {
	CreatureObject* enemy = (CreatureObject*)lua_touserdata(L, -1);

	Locker locker(realObject);

	if (enemy != nullptr)
		realObject->addDefender(enemy);

	return 0;
}

int LuaCreatureObject::getPlayerObject(lua_State* L) {
	Reference<PlayerObject*> obj = realObject->getPlayerObject();

	if (obj != nullptr) {
		obj->_setUpdated(true);
		lua_pushlightuserdata(L, obj);
	} else
		lua_pushnil(L);

	return 1;
}

int LuaCreatureObject::getFaction(lua_State* L) {
	uint32 faction = realObject->getFaction();

	lua_pushinteger(L, faction);

	return 1;
}

int LuaCreatureObject::isRebel(lua_State* L) {
	lua_pushboolean(L, realObject->isRebel());

	return 1;
}

int LuaCreatureObject::isNeutral(lua_State* L) {
	lua_pushboolean(L, realObject->isNeutral());

	return 1;
}

int LuaCreatureObject::isImperial(lua_State* L) {
	lua_pushboolean(L, realObject->isImperial());

	return 1;
}

int LuaCreatureObject::setFaction(lua_State* L) {
	uint32 faction = lua_tointeger(L, -1);

	Locker locker(realObject);

	realObject->setFaction(faction);

	return 0;
}

int LuaCreatureObject::setFactionRank(lua_State* L) {
	int rank = lua_tointeger(L, -1);

	Locker locker(realObject);

	realObject->setFactionRank(rank);

	return 0;
}

int LuaCreatureObject::getFactionRank(lua_State* L) {
	lua_pushinteger(L, realObject->getFactionRank());

	return 1;
}

int LuaCreatureObject::getCashCredits(lua_State* L) {
	lua_pushinteger(L, realObject->getCashCredits());

	return 1;
}

int LuaCreatureObject::subtractCashCredits(lua_State* L) {
	Locker locker(realObject);

	int credits = lua_tointeger(L, -1);
	TransactionLog trx(realObject, TrxCode::LUASCRIPT, credits, true);
	trx.addContextFromLua(L);
	realObject->subtractCashCredits(credits);

	return 0;
}

int LuaCreatureObject::subtractBankCredits(lua_State* L) {
	Locker locker(realObject);

	int credits = lua_tointeger(L, -1);
	TransactionLog trx(realObject, TrxCode::LUASCRIPT, credits, false);
	trx.addContextFromLua(L);
	realObject->subtractBankCredits(credits);

	return 0;
}

int LuaCreatureObject::addCashCredits(lua_State* L) {
	bool notifyClient = lua_toboolean(L, -1);
	int credits = lua_tonumber(L, -2);

	Locker locker(realObject);

	TransactionLog trx(TrxCode::LUASCRIPT, realObject, credits, true);
	trx.addContextFromLua(L);
	realObject->addCashCredits(credits, notifyClient);

	return 0;
}

int LuaCreatureObject::addBankCredits(lua_State* L) {
	bool notifyClient = lua_toboolean(L, -1);
	int credits = lua_tonumber(L, -2);

	Locker locker(realObject);

	TransactionLog trx(TrxCode::LUASCRIPT, realObject, credits, false);
	trx.addContextFromLua(L);
	realObject->addBankCredits(credits, notifyClient);

	return 0;
}

int LuaCreatureObject::isAiAgent(lua_State* L) {
	bool val = realObject->isAiAgent();

	lua_pushboolean(L, val);

	return 1;
}

int LuaCreatureObject::isGrouped(lua_State* L) {
	bool val = realObject->isGrouped();

	lua_pushboolean(L, val);

	return 1;
}

int LuaCreatureObject::isGroupedWith(lua_State* L) {
	CreatureObject* groupMember = (CreatureObject*) lua_touserdata(L, -1);

	if (realObject == nullptr || groupMember == nullptr || !realObject->isGrouped())
		return 0;

	GroupObject* group = realObject->getGroup();

	lua_pushboolean(L, group != nullptr && group->hasMember(groupMember));

	return 1;
}

int LuaCreatureObject::setLootRights(lua_State* L) {
	CreatureObject* player = (CreatureObject*) lua_touserdata(L, -1);

	if (realObject == nullptr)
		return 0;

	uint64 ownerID = 0;

	if (player != nullptr) {
		ownerID = player->getObjectID();
	}

	SceneObject* inventory = realObject->getSlottedObject("inventory");

	if (inventory == nullptr)
		return 0;

	Locker locker(inventory);

	inventory->setContainerOwnerID(ownerID);
	return 1;
}

int LuaCreatureObject::getGroupSize(lua_State* L) {
	Locker locker(realObject);

	GroupObject* group = realObject->getGroup();

	if (group == nullptr) {
		lua_pushnumber(L, 0);
		return 1;
	}

	Locker lock(group, realObject);

	lua_pushnumber(L, group->getGroupSize());

	return 1;
}

int LuaCreatureObject::setOptionsBitmask(lua_State* L) {
	uint32 bitmask = lua_tointeger(L, -1);

	Locker locker(realObject);

	realObject->setOptionsBitmask(bitmask, true);

	return 0;
}

int LuaCreatureObject::getGroupMember(lua_State* L) {
	int i = lua_tonumber(L, -1);

	if (i < 0)
		i = 0;

	Locker locker(realObject);

	GroupObject* group = realObject->getGroup();

	if (group == nullptr) {
		lua_pushnil(L);
		return 1;
	}

	Locker lock(group, realObject);

	if (group->getGroupSize() < i) {
		lua_pushnil(L);
		return 1;
	}

	CreatureObject* creo = group->getGroupMember(i);

	if (creo == nullptr) {
		realObject->info("LuaCreatureObject::getGroupMember GroupMember is nullptr.");
		lua_pushnil(L);
	} else {
		creo->_setUpdated(true);
		lua_pushlightuserdata(L, creo);
	}

	return 1;
}

int LuaCreatureObject::checkCooldownRecovery(lua_State* L) {
	String cooldownName = lua_tostring(L, -1);

	lua_pushboolean(L, realObject->checkCooldownRecovery(cooldownName));

	return 1;
}

int LuaCreatureObject::addCooldown(lua_State* L) {
	String cooldownName = lua_tostring(L, -2);
	int milliseconds = lua_tointeger(L, -1);

	realObject->addCooldown(cooldownName, milliseconds);

	return 0;
}

int LuaCreatureObject::isDead(lua_State* L) {
	bool retVal = realObject->isDead();

	lua_pushboolean(L, retVal);

	return 1;
}

int LuaCreatureObject::isIncapacitated(lua_State* L) {
	lua_pushboolean(L, realObject->isIncapacitated());
	return 1;
}

int LuaCreatureObject::getLevel(lua_State* L) {
	int level = realObject->getLevel();

	lua_pushinteger(L, level);

	return 1;
}

int LuaCreatureObject::getQueueSize(lua_State* L) {
	int size = realObject->getCommandQueueSize();

	lua_pushinteger(L, size);

	return 1;
}

int LuaCreatureObject::isDancing(lua_State* L) {
	bool retVal = realObject->isDancing();

	lua_pushboolean(L, retVal);

	return 1;
}

int LuaCreatureObject::isPlayingMusic(lua_State* L) {
	bool retVal = realObject->isPlayingMusic();

	lua_pushboolean(L,  retVal);

	return 1;
}

int LuaCreatureObject::getPerformanceName(lua_State* L) {
	ManagedReference<Facade*> facade = realObject->getActiveSession(SessionFacadeType::ENTERTAINING);

	if (facade == nullptr) {
		lua_pushnil(L);
		return 1;
	}

	ManagedReference<EntertainingSession*> session = dynamic_cast<EntertainingSession*> (facade.get());

	if (session == nullptr) {
		lua_pushnil(L);
		return 1;
	}

	if (!session->isPlayingMusic() && !session->isDancing())
		lua_pushnil(L);
	else
		lua_pushstring(L, session->getPerformanceName().toCharArray());

	return 1;
}

int LuaCreatureObject::getWalkSpeed(lua_State* L) {
	lua_pushnumber(L, realObject->getWalkSpeed());
	return 1;
}

int LuaCreatureObject::isAttackableBy(lua_State* L) {
	TangibleObject* obj = (TangibleObject*) lua_touserdata(L, -1);

	bool retVal = realObject->isAttackableBy(obj);
	lua_pushboolean(L, retVal);

	return 1;
}

int LuaCreatureObject::getSpecies(lua_State* L) {
	lua_pushinteger(L, realObject->getSpecies());

	return 1;
}

int LuaCreatureObject::isDroidPet(lua_State* L) {
	bool retVal = realObject->isDroidObject() && realObject->isPet();
	lua_pushboolean(L, retVal);

	return 1;
}

int LuaCreatureObject::isCombatDroidPet(lua_State* L) {
	bool retVal = false;
	if (realObject->isDroidObject() && realObject->isPet()) {
		DroidObject* d = cast<DroidObject*>(realObject);
		retVal = d->isCombatDroid();
	}
	lua_pushboolean(L, retVal);
	return 1;
}

int LuaCreatureObject::awardExperience(lua_State* L) {
	String experienceType = lua_tostring(L, -3);
	int experienceAmount = lua_tointeger(L, -2);
	bool sendSysMessage = lua_toboolean(L, -1);

	PlayerManager* playerManager = realObject->getZoneServer()->getPlayerManager();
	playerManager->awardExperience(realObject, experienceType, experienceAmount, sendSysMessage, 1.0f, false);

	return 0;
}

int LuaCreatureObject::getOwner(lua_State* L) {
	CreatureObject* retVal = realObject->getLinkedCreature().get();

	if (retVal == nullptr)
		lua_pushnil(L);
	else
		lua_pushlightuserdata(L, retVal);
	return 1;
}

int LuaCreatureObject::getCurrentSpeed(lua_State* L) {
	float currentSpeed = realObject->getCurrentSpeed();

	lua_pushnumber(L, currentSpeed);

	return 1;
}

int LuaCreatureObject::isInCombat(lua_State* L) {
	bool retVal = realObject->isInCombat();

	lua_pushboolean(L, retVal);

	return 1;
}

int LuaCreatureObject::healDamage(lua_State* L) {
	int damageHealed = lua_tointeger(L, -2);
	int pool = lua_tointeger(L, -1);

	realObject->healDamage(realObject, pool, damageHealed, true, true);

	return 0;
}

int LuaCreatureObject::getGroupID(lua_State* L) {

	lua_pushnumber(L, realObject->getGroupID());

	return 1;
}

int LuaCreatureObject::enhanceCharacter(lua_State* L) {
	PlayerManager* playerManager = realObject->getZoneServer()->getPlayerManager();
	playerManager->enhanceCharacter(realObject);

	return 0;
}

int LuaCreatureObject::setWounds(lua_State* L) {
	int amount = lua_tointeger(L, -1);
	int pool = lua_tointeger(L, -2);

	realObject->setWounds(pool, amount, true);

	return 0;
}

int LuaCreatureObject::setShockWounds(lua_State* L) {
	int amount = lua_tointeger(L, -1);

	realObject->setShockWounds(amount, true);

	return 0;
}

int LuaCreatureObject::getForceSensitiveSkillCount(lua_State* L) {
	bool includeNoviceMasterBoxes = lua_toboolean(L, -1);

	int result = SkillManager::instance()->getForceSensitiveSkillCount(realObject, includeNoviceMasterBoxes);

	lua_pushnumber(L, result);

	return 1;
}

int LuaCreatureObject::villageKnightPrereqsMet(lua_State* L) {
	String skillToDrop = lua_tostring(L, -1);

	bool result = SkillManager::instance()->villageKnightPrereqsMet(realObject, skillToDrop);

	lua_pushboolean(L, result);

	return 1;
}

int LuaCreatureObject::getDamageDealerList(lua_State* L) {
	ThreatMap* threatMap = realObject->getThreatMap();
	ThreatMap copyThreatMap(*threatMap);

	lua_newtable(L);

	int count = 0;
	for (int i = 0; i < copyThreatMap.size(); ++i) {
		ThreatMapEntry* entry = &copyThreatMap.elementAt(i).getValue();

		if (entry->getTotalDamage() > 0) {
			TangibleObject* attacker = copyThreatMap.elementAt(i).getKey();

			if (attacker == nullptr || !attacker->isCreatureObject()) {
				continue;
			}

			CreatureObject* creoAttacker = attacker->asCreatureObject();

			count++;
			lua_pushlightuserdata(L, creoAttacker);
			lua_rawseti(L, -2, count);
		}
	}

	return 1;
}

int LuaCreatureObject::getHealingThreatList(lua_State* L) {
	ThreatMap* threatMap = realObject->getThreatMap();
	ThreatMap copyThreatMap(*threatMap);

	lua_newtable(L);

	int count = 0;

	for (int i = 0; i < copyThreatMap.size(); ++i) {
		ThreatMapEntry* entry = &copyThreatMap.elementAt(i).getValue();

		if (entry == nullptr || entry->getHeal() <= 0)
			continue;

		TangibleObject* entryTano = copyThreatMap.elementAt(i).getKey();

		if (entryTano == nullptr || !entryTano->isCreatureObject()) {
			continue;
		}

		CreatureObject* creoHealer = entryTano->asCreatureObject();

		count++;
		lua_pushlightuserdata(L, creoHealer);
		lua_rawseti(L, -2, count);
	}

	return 1;
}

int LuaCreatureObject::getAllThreatsList(lua_State* L) {
	ThreatMap* threatMap = realObject->getThreatMap();
	ThreatMap copyThreatMap(*threatMap);

	lua_newtable(L);
	int count = 0;

	for (int i = 0; i < copyThreatMap.size(); ++i) {
		TangibleObject* attacker = copyThreatMap.elementAt(i).getKey();

		if (attacker == nullptr || !attacker->isCreatureObject()) {
			continue;
		}

		CreatureObject* creoAttacker = attacker->asCreatureObject();

		count++;
		lua_pushlightuserdata(L, creoAttacker);
		lua_rawseti(L, -2, count);
	}

	return 1;
}

int LuaCreatureObject::dropFromThreatMap(lua_State* L) {
	TangibleObject* attackerTano = (TangibleObject*)lua_touserdata(L, -1);

	if (attackerTano == nullptr)
		return 0;

	Locker lock(realObject);

	ThreatMap* threatMap = realObject->getThreatMap();

	if (threatMap == nullptr)
		return 0;

	for (int i = 0; i < threatMap->size(); i++) {
		TangibleObject* threatTano = threatMap->elementAt(i).getKey();

		if (threatTano == nullptr)
			continue;

		if (threatTano == attackerTano) {
			threatMap->remove(i);
			return 0;
		}
	}

	return 0;
}

int LuaCreatureObject::getSkillMod(lua_State* L) {
	String skillMod = lua_tostring(L, -1);

	int result = realObject->getSkillMod(skillMod);

	lua_pushnumber(L, result);

	return 1;
}

int LuaCreatureObject::getGender(lua_State* L) {

	lua_pushnumber(L, realObject->getGender());

	return 1;
}

int LuaCreatureObject::isRidingMount(lua_State* L) {
	bool isMounted = realObject->isRidingMount();

	lua_pushboolean(L, isMounted);

	return 1;
}

int LuaCreatureObject::dismount(lua_State* L) {
	realObject->dismount();
	return 0;
}

int LuaCreatureObject::setAppearance(lua_State* L){
	String appearanceString = lua_tostring(L, -1);

	Locker pLocker(realObject);

	// Reset Template - Pass empty string
	if (appearanceString == "") {
		Zone* zone = realObject->getZone();

		realObject->setAlternateAppearance(appearanceString , true);

		if (zone != nullptr) {
			realObject->switchZone(zone->getZoneName(), realObject->getPositionX(), realObject->getPositionZ(), realObject->getPositionY(), realObject->getParentID());
		}
		return 0;
	}

	String templateName = "";

	if (appearanceString.indexOf(".iff") == -1 || appearanceString.indexOf("object/mobile/shared_") == -1) {
		return 0;
	} else if (appearanceString != "") {
		TemplateManager* templateManager = TemplateManager::instance();
		String templateTest = appearanceString.replaceFirst("shared_", "");

		if (templateManager != nullptr) {
			SharedObjectTemplate* templateData = templateManager->getTemplate(templateTest.hashCode());

			if (templateData == nullptr) {
				realObject->sendSystemMessage("Unable to find template.");
				return 0;
			}
			templateName = appearanceString;

			realObject->setAlternateAppearance(templateName, true);
		}
	}

	return 0;
}

int LuaCreatureObject::getWeaponType(lua_State* L) {
	Locker lock(realObject);

	WeaponObject* weapon = realObject->getWeapon();
	uint32 weaponType;

	if (weapon == nullptr) {
		weaponType = SharedWeaponObjectTemplate::UNARMEDWEAPON;
	} else {
		weaponType = weapon->getWeaponBitmask();
	}

	lua_pushinteger(L, weaponType);
	return 1;
}

int LuaCreatureObject::attemptPeace(lua_State* L) {
	Locker lock(realObject);

	CombatManager::instance()->attemptPeace(realObject);

	return 0;
}

int LuaCreatureObject::forcePeace(lua_State* L) {
	Locker lock(realObject);

	CombatManager::instance()->forcePeace(realObject);

	return 0;
}

int LuaCreatureObject::isPilotingShip(lua_State* L) {
	bool isPiloting = realObject->isPilotingShip();

	lua_pushboolean(L, isPiloting);

	return 1;
}

int LuaCreatureObject::storePets(lua_State* L) {
	Locker lock(realObject);

	ManagedReference<SceneObject*> datapad = realObject->getDatapad();

	if (datapad == nullptr) {
		return 0;
	}

	Vector<ManagedReference<ControlDevice*> > devicesToStore;

	for (int i = 0; i < datapad->getContainerObjectsSize(); ++i) {
		ManagedReference<SceneObject*> object = datapad->getContainerObject(i);

		if (object == nullptr || !object->isPetControlDevice()) {
			continue;
		}

		ControlDevice* device = cast<ControlDevice*>(object.get());

		if (device == nullptr) {
			continue;
		}

		devicesToStore.add(device);
	}

	StoreSpawnedChildrenTask* task = new StoreSpawnedChildrenTask(realObject, std::move(devicesToStore));

	if (task != nullptr) {
		task->execute();
	}

	return 0;
}

int LuaCreatureObject::isRebelPilot(lua_State* L) {
	Locker lock(realObject);

	bool check = realObject->hasSkill("pilot_rebel_navy_novice");

	lua_pushboolean(L, check);

	return 1;
}

int LuaCreatureObject::isImperialPilot(lua_State* L) {
	Locker lock(realObject);

	bool check = realObject->hasSkill("pilot_imperial_navy_novice");

	lua_pushboolean(L, check);

	return 1;
}

int LuaCreatureObject::isNeutralPilot(lua_State* L) {
	Locker lock(realObject);

	bool check = realObject->hasSkill("pilot_neutral_novice");

	lua_pushboolean(L, check);

	return 1;
}

int LuaCreatureObject::hasCertifiedShip(lua_State* L) {
	bool skipYacht = lua_toboolean(L, -1);

	auto datapad = realObject->getDatapad();
	bool hasShip = false;

	if (datapad != nullptr) {
		for (int i = 0; i < datapad->getContainerObjectsSize(); i++) {
			ManagedReference<SceneObject*> object = datapad->getContainerObject(i);

			if (object == nullptr || !object->isShipControlDevice()) {
				continue;
			}

			if (skipYacht && object->getServerObjectCRC() == STRING_HASHCODE("object/intangible/ship/sorosuub_space_yacht_pcd.iff")) {
				continue;
			}

			auto shipDevice = object.castTo<ShipControlDevice*>();

			if (shipDevice == nullptr) {
				continue;
			}

			auto controlledObject = shipDevice->getControlledObject();

			if (controlledObject == nullptr) {
				continue;
			}

			auto ship = controlledObject->asShipObject();

			if (ship == nullptr || !ship->canBePilotedBy(realObject)) {
				continue;
			}

			hasShip = true;
			break;
		}
	}

	lua_pushboolean(L, hasShip);

	return 1;
}

int LuaCreatureObject::abortQuestMission(lua_State* L) {
	int numberOfArguments = lua_gettop(L) - 1;

	if (numberOfArguments != 1) {
		realObject->error() << "Improper number of arguments in LuaCreatureObject::abortQuestMission.";
		return 0;
	}

	uint32 questCRC = lua_tonumber(L, -1);

	if (questCRC == 0) {
		return 0;
	}

	auto datapad = realObject->getDatapad();

	if (datapad == nullptr) {
		return 0;
	}

	auto zoneServer = realObject->getZoneServer();

	if (zoneServer == nullptr) {
		return 0;
	}

	auto missionManager = zoneServer->getMissionManager();

	if (missionManager == nullptr) {
		return 0;
	}

	for (int i = 0; i < datapad->getContainerObjectsSize(); i++) {
		auto object = datapad->getContainerObject(i);

		if (object == nullptr || !object->isMissionObject()) {
			continue;
		}

		auto mission = object.castTo<MissionObject*>();

		if (mission == nullptr || (mission->getQuestCRC() != questCRC)) {
			continue;
		}

		missionManager->handleMissionAbort(mission, realObject);

		return 0;
	}

	return 0;
}

int LuaCreatureObject::removeQuestMission(lua_State* L) {
	int numberOfArguments = lua_gettop(L) - 1;

	if (numberOfArguments != 1) {
		realObject->error() << "Improper number of arguments in LuaCreatureObject::removeQuestMission.";
		return 0;
	}

	uint32 questCRC = lua_tonumber(L, -1);

	if (questCRC == 0) {
		return 0;
	}

	auto datapad = realObject->getDatapad();

	if (datapad == nullptr) {
		return 0;
	}

	auto zoneServer = realObject->getZoneServer();

	if (zoneServer == nullptr) {
		return 0;
	}

	auto missionManager = zoneServer->getMissionManager();

	if (missionManager == nullptr) {
		return 0;
	}

	Locker lock(realObject);

	for (int i = 0; i < datapad->getContainerObjectsSize(); i++) {
		auto object = datapad->getContainerObject(i);

		if (object == nullptr || !object->isMissionObject()) {
			continue;
		}

		auto mission = object.castTo<MissionObject*>();

		if (mission == nullptr || (mission->getQuestCRC() != questCRC)) {
			continue;
		}

		missionManager->removeMission(mission, realObject);

		return 0;
	}

	return 0;
}

int LuaCreatureObject::addSpaceMissionObject(lua_State* L) {
	int numberOfArguments = lua_gettop(L) - 1;

	if (numberOfArguments != 2) {
		realObject->error() << "Improper number of arguments in LuaCreatureObject::addSpaceMissionObject.";
		return 0;
	}

	bool notifyClient = lua_toboolean(L, -1);
	uint64 missionObjectID = lua_tointeger(L, -2);

	if (missionObjectID == 0) {
		return 0;
	}

	Locker lock(realObject);

	realObject->addSpaceMissionObject(realObject->getObjectID(), missionObjectID, notifyClient, true);

	return 0;
}

int LuaCreatureObject::removeSpaceMissionObject(lua_State* L) {
	int numberOfArguments = lua_gettop(L) - 1;

	if (numberOfArguments != 2) {
		realObject->error() << "Improper number of arguments in LuaCreatureObject::removeSpaceMissionObject.";
		return 0;
	}

	bool notifyClient = lua_toboolean(L, -1);
	uint64 missionObjectID = lua_tointeger(L, -2);

	if (missionObjectID == 0) {
		return 0;
	}

	Locker lock(realObject);

	realObject->removeSpaceMissionObject(realObject->getObjectID(), missionObjectID, notifyClient, true);

	return 0;
}

int LuaCreatureObject::buffSingleStat(lua_State* L) {
	String stat = lua_tostring(L, -3);
	int buffPower = lua_tointeger(L, -2);
	int buffDuration = lua_tointeger(L, -1);
	
	PlayerManager* playerManager = realObject->getZoneServer()->getPlayerManager();
	
	bool appliedBuff = true; // Because doEnhanceCharacter() is a bool function...
	
	if (stat == "health"){
		appliedBuff = playerManager->doEnhanceCharacter(0x98321369, realObject, buffPower, buffDuration, BuffType::MEDICAL, 0); // medical_enhance_health
	} else if (stat == "strength") {
		appliedBuff = playerManager->doEnhanceCharacter(0x815D85C5, realObject, buffPower, buffDuration, BuffType::MEDICAL, 1); // medical_enhance_strength
	} else if (stat == "constitution") {
		appliedBuff = playerManager->doEnhanceCharacter(0x7F86D2C6, realObject, buffPower, buffDuration, BuffType::MEDICAL, 2); // medical_enhance_constitution
	} else if (stat == "action") {
		appliedBuff = playerManager->doEnhanceCharacter(0x4BF616E2, realObject, buffPower, buffDuration, BuffType::MEDICAL, 3); // medical_enhance_action
	} else if (stat == "quickness") {
		appliedBuff = playerManager->doEnhanceCharacter(0x71B5C842, realObject, buffPower, buffDuration, BuffType::MEDICAL, 4); // medical_enhance_quickness
	} else if (stat == "stamina") {
		appliedBuff = playerManager->doEnhanceCharacter(0xED0040D9, realObject, buffPower, buffDuration, BuffType::MEDICAL, 5); // medical_enhance_stamina
	} else if (stat == "mind") {
		appliedBuff = playerManager->doEnhanceCharacter(0x11C1772E, realObject, buffPower, buffDuration, BuffType::PERFORMANCE, 6); // performance_enhance_dance_mind
	} else if (stat == "focus") {
		appliedBuff = playerManager->doEnhanceCharacter(0x2E77F586, realObject, buffPower, buffDuration, BuffType::PERFORMANCE, 7); // performance_enhance_music_focus
	} else if (stat == "willpower") {
		appliedBuff = playerManager->doEnhanceCharacter(0x3EC6FCB6, realObject, buffPower, buffDuration, BuffType::PERFORMANCE, 8); // performance_enhance_music_willpower
	} else {
		appliedBuff = false;
	}
	
	return 0;
}

int LuaCreatureObject::removeBuffs(lua_State* L) {
	Reference<PlayerObject*> player = realObject->getPlayerObject();
	
	realObject->clearBuffs(true, true);
	
	return 0;
}

int LuaCreatureObject::emptyStomach(lua_State* L) {
	
	if (!realObject->isPlayerCreature())
		return 0;
	
	Reference<PlayerObject*> player = realObject->getPlayerObject();
	
	player->setFoodFilling(0);
	player->setDrinkFilling(0);
	
	return 0;
}

// Return the number of pets a player has out
int LuaCreatureObject::getActivePetsSize(lua_State* L) {
	ManagedReference<PlayerObject*> player = realObject->getPlayerObject();
	
	lua_pushinteger(L, player->getActivePetsSize());
	
	return 1;	
}

// Return a pointer to the specified pet
// local pBob = CreatureObject(pPlayer):getActivePet(0)
int LuaCreatureObject::getActivePet(lua_State* L) {
	int petNumber = lua_tointeger(L, -1);
	
	petNumber = Math::max(0, petNumber);

	Logger::console.info("petNumber: " + String::valueOf(petNumber), true);
	
	ManagedReference<PlayerObject*> player = realObject->getPlayerObject();
	ManagedReference<CreatureObject*> pet = player->getActivePet(petNumber);
	
	if (pet != nullptr) {
		String petName = pet->getFirstName();
		Logger::console.info("Pet Name: " + petName, true);
	}
		
	lua_pushlightuserdata(L, pet);

	return 1;	
}
