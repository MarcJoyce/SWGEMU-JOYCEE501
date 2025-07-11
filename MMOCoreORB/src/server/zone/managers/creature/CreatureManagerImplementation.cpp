/*
 * CreatureManagerImplementation.cpp
 *
 *  Created on: 24/02/2010
 *      Author: victor
 */

#include "server/zone/managers/creature/CreatureManager.h"
#include "server/zone/objects/creature/ai/CreatureTemplate.h"
#include "CreatureTemplateManager.h"
#include "SpawnAreaMap.h"
#include "server/zone/ZoneServer.h"
#include "server/zone/Zone.h"
#include "server/chat/ChatManager.h"
#include "server/zone/managers/combat/CombatManager.h"
#include "server/zone/managers/creature/PetManager.h"
#include "server/zone/managers/faction/FactionManager.h"
#include "server/zone/managers/player/PlayerManager.h"
#include "server/zone/managers/loot/LootManager.h"
#include "server/zone/managers/crafting/labratories/DroidMechanics.h"
#include "server/zone/objects/creature/ai/Creature.h"
#include "server/zone/objects/creature/CreatureObject.h"
#include "server/zone/objects/creature/events/MilkCreatureTask.h"
#include "server/zone/objects/creature/events/TameCreatureTask.h"
#include "server/zone/objects/creature/events/SampleDnaTask.h"
#include "server/zone/objects/group/GroupObject.h"
#include "server/zone/objects/player/PlayerObject.h"
#include "server/zone/objects/creature/ai/AiAgent.h"
#include "server/zone/objects/creature/events/DespawnCreatureTask.h"
#include "server/zone/objects/region/SpawnArea.h"
#include "server/zone/managers/resource/ResourceManager.h"
#include "server/zone/packets/chat/ChatSystemMessage.h"
#include "server/zone/objects/tangible/threat/ThreatMap.h"
#include "server/zone/managers/creature/LairObserver.h"
#include "server/zone/managers/creature/DynamicSpawnObserver.h"
#include "server/zone/objects/intangible/PetControlDevice.h"
#include "server/zone/objects/tangible/LairObject.h"
#include "server/zone/objects/building/PoiBuilding.h"
#include "server/zone/objects/intangible/TheaterObject.h"
#include "server/zone/objects/transaction/TransactionLog.h"

Mutex CreatureManagerImplementation::loadMutex;

void CreatureManagerImplementation::setCreatureTemplateManager() {
	creatureTemplateManager = CreatureTemplateManager::instance();
	CreatureState::instance()->loadStateData();
	CreaturePosture::instance()->loadMovementData();
}

void CreatureManagerImplementation::stop() {
	creatureTemplateManager = nullptr;
	dnaManager = nullptr;
}

CreatureObject* CreatureManagerImplementation::spawnCreature(uint32 templateCRC, float x, float z, float y, uint64 parentID) {
	CreatureObject* creature = createCreature(templateCRC);

	if (creature == nullptr) {
		error() << "Failed to spawn creature with templateCRC: " << templateCRC;
		return nullptr;
	}

	Locker lock(creature);

	placeCreature(creature, x, z, y, parentID);

	return creature;
}

SceneObject* CreatureManagerImplementation::spawn(unsigned int lairTemplate, int difficultyLevel, int lairBuildingLevel, float x, float z, float y, float size) {
	LairTemplate* lairTmpl = creatureTemplateManager->getLairTemplate(lairTemplate);

	if (lairTmpl == nullptr)
		return nullptr;

	if (lairTmpl->getBuildingType() == LairTemplate::LAIR)
		return spawnLair(lairTemplate, difficultyLevel, lairBuildingLevel, x, z, y, size);
	else if (lairTmpl->getBuildingType() == LairTemplate::THEATER)
		return spawnTheater(lairTemplate, lairBuildingLevel, x, z, y, size);
	else if (lairTmpl->getBuildingType() == LairTemplate::NONE)
		return spawnDynamicSpawn(lairTemplate, lairBuildingLevel, x, z, y, size);

	return nullptr;
}

SceneObject* CreatureManagerImplementation::spawnLair(unsigned int lairTemplate, int difficultyLevel, int lairBuildingLevel, float x, float z, float y, float size) {
	LairTemplate* lairTmpl = creatureTemplateManager->getLairTemplate(lairTemplate);

	if (lairTmpl == nullptr || lairTmpl->getBuildingType() != LairTemplate::LAIR)
		return nullptr;

 	String buildingToSpawn;

 	const Vector<String>* mobiles = lairTmpl->getWeightedMobiles();

 	if (mobiles->size() == 0)
 		return nullptr;

 	buildingToSpawn = lairTmpl->getBuilding(Math::max(1, (lairBuildingLevel - 1)));

 	if (buildingToSpawn.isEmpty()) {
 		error("error spawning " + buildingToSpawn);
 		return nullptr;
 	}

 	Reference<LairObject*> building = zoneServer->createObject(buildingToSpawn.hashCode(), 0).castTo<LairObject*>();

 	if (building == nullptr) {
 		error() << "Failed to create lair spawn: " << buildingToSpawn;
 		return nullptr;
 	}

 	Locker blocker(building);

	float baseCondition = CreatureManager::CREATURE_LAIR_MIN;

	switch(lairBuildingLevel) {
		case 2: {
			baseCondition = 3000.f;
			break;
		}
		case 3: {
			baseCondition = 6000.f;
			break;
		}
		case 4: {
			baseCondition = 9000.f;
			break;
		}
		case 5: {
			baseCondition = 18000.f;
			break;
		}
		default:
			break;
	}

	uint32 conditionCalc = Math::min((float)CreatureManager::CREATURE_LAIR_MAX, (System::random(baseCondition) + ((baseCondition / 10) * difficultyLevel)));

	building->setMaxCondition(conditionCalc);
	building->setConditionDamage(0, false);

 	building->setFaction(lairTmpl->getFaction());
 	building->setPvpStatusBitmask(ObjectFlag::ATTACKABLE);
 	building->setOptionsBitmask(0, false);

 	building->initializePosition(x, z, y);
 	building->setDespawnOnNoPlayersInRange(true);

 	ManagedReference<LairObserver*> lairObserver = new LairObserver();

	if (lairObserver == nullptr) {
		return nullptr;
	}

 	lairObserver->deploy();
 	lairObserver->setLairTemplate(lairTmpl);
 	lairObserver->setDifficulty(lairBuildingLevel);
 	lairObserver->setObserverType(ObserverType::LAIR);
 	lairObserver->setSize(size);

 	building->registerObserver(ObserverEventType::OBJECTDESTRUCTION, lairObserver);
 	building->registerObserver(ObserverEventType::DAMAGERECEIVED, lairObserver);
 	building->registerObserver(ObserverEventType::AIMESSAGE, lairObserver);
 	building->registerObserver(ObserverEventType::OBJECTREMOVEDFROMZONE, lairObserver);
	building->registerObserver(ObserverEventType::NOPLAYERSINRANGE, lairObserver);
	building->registerObserver(ObserverEventType::CREATUREDESPAWNED, lairObserver);
	building->registerObserver(ObserverEventType::HEALINGRECEIVED, lairObserver);

 	zone->transferObject(building, -1, true);

	lairObserver->checkForNewSpawns(building, nullptr, true);

 	return building;
}

SceneObject* CreatureManagerImplementation::spawnTheater(unsigned int lairTemplate, int difficulty, float x, float z, float y, float size) {
	LairTemplate* lairTmpl = creatureTemplateManager->getLairTemplate(lairTemplate);

	if (lairTmpl == nullptr || lairTmpl->getBuildingType() != LairTemplate::THEATER)
		return nullptr;

 	const Vector<String>* mobiles = lairTmpl->getWeightedMobiles();

 	if (mobiles->size() == 0)
 		return nullptr;

 	String buildingToSpawn = lairTmpl->getBuilding((uint32)difficulty);

 	if (buildingToSpawn.isEmpty()) {
 		error("error spawning " + buildingToSpawn);
 		return nullptr;
 	}

 	Reference<PoiBuilding*> building = zoneServer->createObject(buildingToSpawn.hashCode(), 0).castTo<PoiBuilding*>();

 	if (building == nullptr) {
 		error("error spawning " + buildingToSpawn);
 		return nullptr;
 	}

 	Locker blocker(building);

 	building->initializePosition(x, z, y);
 	building->setDespawnOnNoPlayersInRange(true);

 	ManagedReference<DynamicSpawnObserver*> theaterObserver = new DynamicSpawnObserver();
 	theaterObserver->deploy();
 	theaterObserver->setLairTemplate(lairTmpl);
 	theaterObserver->setDifficulty(difficulty);
 	theaterObserver->setObserverType(ObserverType::LAIR);
 	theaterObserver->setSize(size);

 	building->registerObserver(ObserverEventType::CREATUREDESPAWNED, theaterObserver);
 	building->registerObserver(ObserverEventType::OBJECTREMOVEDFROMZONE, theaterObserver);


 	zone->transferObject(building, -1, true);

 	theaterObserver->spawnInitialMobiles(building);

 	return building;
}

SceneObject* CreatureManagerImplementation::spawnDynamicSpawn(unsigned int lairTemplate, int difficulty, float x, float z, float y, float size) {
	LairTemplate* lairTmpl = creatureTemplateManager->getLairTemplate(lairTemplate);

	if (lairTmpl == nullptr || lairTmpl->getBuildingType() != LairTemplate::NONE)
		return nullptr;

	const Vector<String>* mobiles = lairTmpl->getWeightedMobiles();

	if (mobiles->size() == 0)
		return nullptr;

	Reference<TheaterObject*> theater = zoneServer->createObject(STRING_HASHCODE("object/intangible/theater/base_theater.iff"), 0).castTo<TheaterObject*>();

	if (theater == nullptr) {
		error("error creating intangible theater");
		return nullptr;
	}

	Locker blocker(theater);

	theater->initializePosition(x, z, y);
	theater->setDespawnOnNoPlayersInRange(true);

	ManagedReference<DynamicSpawnObserver*> dynamicObserver = new DynamicSpawnObserver();
	dynamicObserver->deploy();
	dynamicObserver->setLairTemplate(lairTmpl);
	dynamicObserver->setDifficulty(difficulty);
	dynamicObserver->setObserverType(ObserverType::LAIR);
	dynamicObserver->setSize(size);

	theater->registerObserver(ObserverEventType::CREATUREDESPAWNED, dynamicObserver);
	theater->registerObserver(ObserverEventType::OBJECTREMOVEDFROMZONE, dynamicObserver);

	zone->transferObject(theater, -1, true);

	theater->createChildObjects();
	dynamicObserver->spawnInitialMobiles(theater);

	return theater;
}

CreatureObject* CreatureManagerImplementation::spawnCreatureWithLevel(unsigned int mobileTemplateCRC, int level, float x, float z, float y, uint64 parentID ) {
	CreatureObject* creature = spawnCreature(mobileTemplateCRC, 0, x, z, y, parentID);

	if (creature != nullptr)
		creature->setLevel(level);

	return creature;
}

CreatureObject* CreatureManagerImplementation::spawnCreatureWithAi(uint32 templateCRC, float x, float z, float y, uint64 parentID, bool persistent) {
	CreatureObject* creature = spawnCreature(templateCRC, 0, x, z, y, parentID, persistent);

	if (creature != nullptr && creature->isAiAgent())
		creature->asAiAgent()->setAITemplate();
	else {
		error() << "could not spawn template: " << String::valueOf(templateCRC) << " with AI.";
		creature = nullptr;
	}

	return creature;
}

String CreatureManagerImplementation::getTemplateToSpawn(uint32 templateCRC) {
	String templateToSpawn = "";

	CreatureTemplate* creoTempl = creatureTemplateManager->getTemplate(templateCRC);

	Vector<String> objTemps = creoTempl->getTemplates();

	if (objTemps.size() > 0) {
		uint32 randomTemp = System::random(objTemps.size() - 1);
		templateToSpawn = objTemps.get(randomTemp);
	} else {
		warning() << "could not spawn creature... no object templates in script " << creoTempl->getTemplateName();
	}

	return templateToSpawn;
}

bool CreatureManagerImplementation::checkSpawnAsBaby(float tamingChance, int babiesSpawned, int chance) {
	if (tamingChance > 0) {
		if (babiesSpawned == 0) {
			if (System::random(chance) < (tamingChance * 100.0f)) {
				return true;
			}
		} else if (System::random(chance * babiesSpawned) < (tamingChance * 100.0f)) {
			return true;
		}
	}

	return false;
}

CreatureObject* CreatureManagerImplementation::spawnCreatureAsBaby(uint32 templateCRC, float x, float z, float y, uint64 parentID) {
	CreatureTemplate* creoTempl = creatureTemplateManager->getTemplate(templateCRC);

	if (creoTempl == nullptr || creoTempl->getTame() <= 0)
		return nullptr;

	CreatureObject* creO = nullptr;

	String templateToSpawn = getTemplateToSpawn(templateCRC);
	uint32 objectCRC = templateToSpawn.hashCode();

	creO = createCreature(objectCRC, false, templateCRC);

	if (creO == nullptr) {
		error("could not spawn template " + templateToSpawn + " as baby.");
		return nullptr;
	}

	Locker lock(creO);

	if (creO->isCreature()) {
		Creature* creature = cast<Creature*>(creO);

		if (creature == nullptr) {
			error("could not spawn template " + templateToSpawn + " as baby with AI.");
			return nullptr;
		}

		creature->loadTemplateDataForBaby(creoTempl);
		creature->setAITemplate();
	}

	placeCreature(creO, x, z, y, parentID);

	return creO;
}

CreatureObject* CreatureManagerImplementation::spawnCreatureAsEventMob(uint32 templateCRC, int level, float x, float z, float y, uint64 parentID) {
	CreatureTemplate* creoTempl = creatureTemplateManager->getTemplate(templateCRC);

	if (creoTempl == nullptr)
		return nullptr;

	CreatureObject* creO = nullptr;

	String templateToSpawn = getTemplateToSpawn(templateCRC);
	uint32 objectCRC = templateToSpawn.hashCode();

	creO = createCreature(objectCRC, false, templateCRC);

	if (creO == nullptr) {
		error("could not spawn template " + templateToSpawn);
		return nullptr;
	}

	Locker locker(creO);

	if (creO->isAiAgent()) {
		AiAgent* agent = creO->asAiAgent();

		if (agent != nullptr) {
			agent->loadTemplateData(creoTempl);

			UnicodeString eventName;

			eventName = agent->getDisplayedName() + " (event)";
			agent->setCustomObjectName(eventName, false);

			if (level > 0 && agent->getLevel() != level) {
				agent->setLevel(level);
			}

			agent->setAITemplate();
		}
	}

	placeCreature(creO, x, z, y, parentID);

	return creO;
}

CreatureObject* CreatureManagerImplementation::spawnCreature(uint32 templateCRC, uint32 objectCRC, float x, float z, float y, uint64 parentID, bool persistent, float direction) {
	CreatureTemplate* creoTempl = creatureTemplateManager->getTemplate(templateCRC);

	if (creoTempl == nullptr)
		return spawnCreature(objectCRC, x, z, y, parentID);

	CreatureObject* creature = nullptr;

	String templateToSpawn;

	if (objectCRC == 0) {
		templateToSpawn = getTemplateToSpawn(templateCRC);
		objectCRC = templateToSpawn.hashCode();
	}

	creature = createCreature(objectCRC, persistent, templateCRC);

	if (creature == nullptr) {
		error("could not spawn template " + templateToSpawn);
		return nullptr;
	}

	Locker lock(creature);

	if (creature->isAiAgent()) {
		AiAgent* agent = creature->asAiAgent();

		if (agent != nullptr)
			agent->loadTemplateData(creoTempl);
	}

	placeCreature(creature, x, z, y, parentID, direction);

	return creature;
}

CreatureObject* CreatureManagerImplementation::createCreature(uint32 templateCRC,  bool persistent, uint32 mobileTemplateCRC) {
	ManagedReference<SceneObject*> object = zoneServer->createObject(templateCRC, persistent);

	if (object == nullptr) {
		error() << "could not spawn creature... wrong template? 0x" << hex << templateCRC;

		return nullptr;
	}

	Locker locker(object);

	if (!object->isCreatureObject()) {
		error() << "server did not create a creature object wrong template? 0x" << hex << templateCRC;

		if (object->isPersistent()) {
			object->destroyObjectFromDatabase(true);
		}

		return nullptr;
	}

	CreatureObject* creature = cast<CreatureObject*>( object.get());

	if (!createCreatureChildrenObjects(creature, templateCRC, creature->isPersistent(), mobileTemplateCRC)) {
		error() << "could not create children objects for creature... 0x" << templateCRC;

		if (object->isPersistent()) {
			object->destroyObjectFromDatabase(true);
		}

		return nullptr;
	}

	return creature;
}

void CreatureManagerImplementation::placeCreature(CreatureObject* creature, float x, float z, float y, uint64 parentID, float direction) {
	if (creature == nullptr)
		return;

	Reference<CellObject*> cellParent = nullptr;

	if (parentID != 0) {
		cellParent = zoneServer->getObject(parentID).castTo<CellObject*>();
	}

	if (creature->isAiAgent()) {
		AiAgent* aio = cast<AiAgent*>(creature);
		aio->setHomeLocation(x, z, y, cellParent, direction);
		aio->setNextStepPosition(x, z, y, cellParent);
	}

	creature->initializePosition(x, z, y);
	creature->setDirection(Quaternion(Vector3(0, 1, 0), direction));

	if (cellParent != nullptr) {
		cellParent->transferObject(creature, -1);
	} else
		zone->transferObject(creature, -1, true);
}

SpawnArea* CreatureManagerImplementation::getSpawnArea(const String& areaname) {
	return spawnAreaMap.get(areaname.hashCode());
}

bool CreatureManagerImplementation::createCreatureChildrenObjects(CreatureObject* creature, uint32 templateCRC, bool persistent, uint32 mobileTemplateCRC) {
	if (creature->hasSlotDescriptor("default_weapon")) {
		uint32 defaultWeaponCRC = 0;

		if (mobileTemplateCRC != 0) {
			CreatureTemplate* creoTempl = creatureTemplateManager->getTemplate(mobileTemplateCRC);

			if (creoTempl != nullptr && creoTempl->getDefaultWeapon() != "") {
				defaultWeaponCRC = String(creoTempl->getDefaultWeapon()).hashCode();
			}
		}

		if (defaultWeaponCRC == 0) {
			if (creature->isNonPlayerCreatureObject()) {
				defaultWeaponCRC = STRING_HASHCODE("object/weapon/melee/unarmed/unarmed_default.iff");
			} else {
				defaultWeaponCRC = STRING_HASHCODE("object/weapon/creature/creature_default_weapon.iff");
			}
		}

		ManagedReference<SceneObject*> defaultWeapon = zoneServer->createObject(defaultWeaponCRC, persistent);

		if (defaultWeapon == nullptr) {
			error("could not create creature default weapon");
			return false;
		}

		Locker clocker(defaultWeapon, creature);

		creature->transferObject(defaultWeapon, 4);

		if (creature->isAiAgent()) {
			WeaponObject* weap = defaultWeapon.castTo<WeaponObject*>();
			AiAgent* agent = creature->asAiAgent();

			if (weap != nullptr && agent != nullptr) {
				StringBuffer weapName;
				weapName << "AI_DEFAULT-" << agent->getObjectID();
				weap->setCustomObjectName(weapName.toString(), false);

				agent->setDefaultWeapon(weap);
				agent->setCurrentWeapon(weap);
			}
		}
	}

	if (creature->hasSlotDescriptor("inventory")) {
		Reference<SceneObject*> creatureInventory = zoneServer->createObject(STRING_HASHCODE("object/tangible/inventory/creature_inventory.iff"), persistent);

		if (creatureInventory == nullptr) {
			error("could not create creature inventory");

			return false;
		}

		Locker clocker(creatureInventory, creature);

		creatureInventory->setContainerDefaultDenyPermission(ContainerPermissions::MOVECONTAINER);
		creatureInventory->setContainerDenyPermission("owner", ContainerPermissions::MOVECONTAINER);
		creatureInventory->setContainerInheritPermissionsFromParent(false);

		creature->transferObject(creatureInventory, 4);
	}

	return true;
}

void CreatureManagerImplementation::unloadSpawnAreas() {
	spawnAreaMap.unloadMap();
}

int CreatureManagerImplementation::notifyDestruction(TangibleObject* destructor, AiAgent* destructedObject, int condition, bool isCombatAction) {
	if (destructedObject->isDead())
		return 1;

	// Agent weapons must be destroyed and nullified. This prevents them being looted and ensures agent is cleaned up by GC
	if (!destructedObject->isPet()) {
		destructedObject->destroyAllWeapons();
	}

	destructedObject->cancelBehaviorEvent();
	destructedObject->cancelRecoveryEvent();
	destructedObject->wipeBlackboard();

	destructedObject->clearRunningChain();
	destructedObject->clearQueueActions(false);

	destructedObject->clearOptionBit(OptionBitmask::INTERESTING);
	destructedObject->clearOptionBit(OptionBitmask::JTLINTERESTING);

	destructedObject->updateTimeOfDeath();
	destructedObject->setPosture(CreaturePosture::DEAD, !isCombatAction, !isCombatAction);

	ManagedReference<PlayerManager*> playerManager = zoneServer->getPlayerManager();

	// lets copy the damage map before we remove it all
	ThreatMap* threatMap = destructedObject->getThreatMap();
	ThreatMap copyThreatMap(*threatMap);

	threatMap->removeObservers();

	auto destructorObjectID = destructor->getObjectID();

	// lets unlock destructor so we dont get into complicated deadlocks
	if (destructedObject != destructor)
		destructor->unlock();

	bool shouldRescheduleCorpseDestruction = false;

	try {
		SortedVector<ManagedReference<Observer* > > observers = destructedObject->getObservers(ObserverEventType::QUESTKILL);

		if (observers.size() > 0) {
			for (int i = 0; i < copyThreatMap.size(); ++i) {
				TangibleObject* attacker = copyThreatMap.elementAt(i).getKey();

				if (attacker == nullptr || !attacker->isPlayerCreature())
					continue;

				CreatureObject* attackerCreo = attacker->asCreatureObject();

				if (attackerCreo == nullptr)
					continue;

				attackerCreo->notifyObservers(ObserverEventType::QUESTKILL, destructedObject);
			}
		}

		ManagedReference<CreatureObject*> player = copyThreatMap.getHighestDamageGroupLeader();

		uint64 ownerID = 0;

		if (player != nullptr) {

			if (player->isGrouped()) {
				ownerID = player->getGroupID();
			} else {
				ownerID = player->getObjectID();
			}

			if (player->isPlayerCreature()) {
				if (!destructedObject->isEventMob()) {
					if (player->isGrouped()) {
						ManagedReference<GroupObject*> group = player->getGroup();

						if (group != nullptr) {
							for (int i = 0; i < group->getGroupSize(); i++) {
								ManagedReference<CreatureObject*> groupMember = group->getGroupMember(i);

								if (groupMember->isPlayerCreature()) {
									Locker locker(groupMember, destructedObject);
									groupMember->notifyObservers(ObserverEventType::KILLEDCREATURE, destructedObject);
								}
							}
						}
					} else {
						Locker locker(player, destructedObject);
						player->notifyObservers(ObserverEventType::KILLEDCREATURE, destructedObject);
					}
				}

				FactionManager* factionManager = FactionManager::instance();

				if (!destructedObject->getFactionString().isEmpty() && !destructedObject->isEventMob()) {
					int level = destructedObject->getLevel();

					if(!player->isGrouped())
						factionManager->awardFactionStanding(player, destructedObject->getFactionString(), level);
					else
						factionManager->awardFactionStanding(copyThreatMap.getHighestDamagePlayer(), destructedObject->getFactionString(), level);
				}
			}

		}

		if (playerManager != nullptr)
			playerManager->disseminateExperience(destructedObject, &copyThreatMap);

		SceneObject* creatureInventory = destructedObject->getSlottedObject("inventory");

		// Remove any buffs or debuffs from the agent
		destructedObject->clearBuffs(false, true);

		if (creatureInventory != nullptr && player != nullptr && player->isPlayerCreature()) {
			LootManager* lootManager = zoneServer->getLootManager();

			if (destructedObject->isNonPlayerCreatureObject() && !destructedObject->isEventMob()) {
				destructedObject->clearCashCredits();
				int credits = lootManager->calculateLootCredits(destructedObject->getLevel());
				TransactionLog trx(TrxCode::NPCLOOT, destructedObject, credits, true);
				trx.addState("destructor", destructorObjectID);
				destructedObject->addCashCredits(credits);
			}

			Locker invLocker(creatureInventory, destructedObject);

			TransactionLog trx(TrxCode::NPCLOOT, destructedObject);
			creatureInventory->setContainerOwnerID(ownerID);

			if (lootManager->createLoot(trx, creatureInventory, destructedObject)) {
				trx.commit(true);
			} else if (trx.isEnabled() && !trx.isAborted()) {
				trx.abort() << "createLoot failed for ai object for unknown reason.";
			}
		}

		// Check to see if we can expedite the despawn of this corpse
		// We can expedite the despawn when corpse has no loot, no credits, player cannot harvest, and no group members in range can harvest
		shouldRescheduleCorpseDestruction = playerManager->shouldRescheduleCorpseDestruction(player, destructedObject);
	} catch (...) {
		destructedObject->scheduleDespawn(10, true);

		// now we can safely lock destructor again
		if (destructedObject != destructor)
			destructor->wlock(destructedObject);

		throw;
	}

	if (shouldRescheduleCorpseDestruction) {
		// Corpse has nothing of value, schedule despawn for 10s
		destructedObject->scheduleDespawn(10, true);
	} else {
		// Corpse has loot or can be harvested, schedule despawn for 300s
		destructedObject->scheduleDespawn(300);
	}

	// now we can safely lock destructor again
	if (destructedObject != destructor) {
		destructor->wlock(destructedObject);

		ThreatMap* destructorThreatMap = destructor->getThreatMap();

		if (destructorThreatMap != nullptr) {
			uint64 destructedID = destructedObject->getObjectID();

			for (int i = 0; i < destructorThreatMap->size(); i++) {
				TangibleObject* threatTano = destructorThreatMap->elementAt(i).getKey();

				if (threatTano == nullptr || threatTano->getObjectID() != destructedID)
					continue;

				destructorThreatMap->remove(i);
			}
		}

		if (destructor->hasDefender(destructedObject)) {
			destructor->removeDefender(destructedObject);
		}

		// Finally if the destructor has no more defenders, clear their combat state
		if (!destructor->hasDefenders()) {
			destructor->clearCombatState(false);
		}
	}

	destructedObject->removeDefenders();
	destructedObject->clearCombatState(false);

	return 1;
}

void CreatureManagerImplementation::droidHarvest(Creature* creature, CreatureObject* droid, int selectedID, int harvestBonus) {
	// droid and creature are locked coming in.
	ManagedReference<CreatureObject*> owner = droid->getLinkedCreature().get();

	if (owner == nullptr) {
		return;
	}

	Locker pLock(owner, droid);

	Zone* zone = creature->getZone();
	Zone* droidZone = droid->getZone();

	if (zone == nullptr || !creature->isCreature() || droidZone == nullptr) {
		return;
	}

	// this will perform a range check on the corpse to the droid
	if (!creature->canDroidHarvestMe(owner, droid)) {
		owner->sendSystemMessage("@pet/droid_modules:cannot_access_corpse");
		return;
	}

	ManagedReference<ResourceManager*> resourceManager = zone->getZoneServer()->getResourceManager();
	String restype = "";
	float quantity = 0;

	if (selectedID == 234) {
		restype = creature->getMeatType();
		quantity = creature->getMeatMax();
	} else if (selectedID == 235) {
		restype = creature->getHideType();
		quantity = creature->getHideMax();
	} else if (selectedID == 236) {
		restype = creature->getBoneType();
		quantity = creature->getBoneMax();
	}
	if(quantity == 0 || restype.isEmpty()) {
		owner->sendSystemMessage("Tried to harvest something this creature didn't have, please report this error");
		return;
	}
	int ownerSkill = owner->getSkillMod("creature_harvesting");
	int quantityExtracted = int(quantity * float(ownerSkill / 100.0f));
	// add in droid bonus
	quantityExtracted = Math::max(quantityExtracted, 3);
	ManagedReference<ResourceSpawn*> resourceSpawn = resourceManager->getCurrentSpawn(restype, droidZone->getZoneName());

	if (resourceSpawn == nullptr) {
		owner->sendSystemMessage("Error: Server cannot locate a current spawn of " + restype);
		return;
	}

	float density = resourceSpawn->getDensityAt(droidZone->getZoneName(), droid->getPositionX(), droid->getPositionY());

	String creatureHealth = "";

	if (density > 0.75f) {
		quantityExtracted = int(quantityExtracted * 1.25f);
		creatureHealth = "creature_quality_fat";
	} else if (density > 0.50f) {
		quantityExtracted = int(quantityExtracted * 1.00f);
		creatureHealth = "creature_quality_medium";
	} else if (density > 0.25f) {
		quantityExtracted = int(quantityExtracted * 0.75f);
		creatureHealth = "creature_quality_scrawny";
	} else {
		quantityExtracted = int(quantityExtracted * 0.50f);
		creatureHealth = "creature_quality_skinny";
	}

	float modifier = 1;
	int baseAmount = quantityExtracted;
	if (owner->isGrouped()) {
		modifier = owner->getGroup()->getGroupHarvestModifier(owner);

		quantityExtracted = (int)(quantityExtracted * modifier);
	}

	if (creature->getParent().get() != nullptr)
		quantityExtracted = 1;

	int droidBonus = DroidMechanics::determineDroidSkillBonus(ownerSkill,harvestBonus,quantityExtracted);

	quantityExtracted += droidBonus;
	// add to droid inventory if there is space available, otherwise to player
	DroidObject* pet = cast<DroidObject*>(droid);

	if (pet == nullptr) {
		error("Incoming droid harvest call didnt include a droid!");
		return;
	}

	TransactionLog trx(TrxCode::HARVESTED, owner, resourceSpawn);

	if (pet->hasStorage()) {
		bool didit = resourceManager->harvestResourceToPlayer(trx, droid, resourceSpawn, quantityExtracted * 5);
		if (!didit) {
			trx.addState("droidOverflow", true);
			resourceManager->harvestResourceToPlayer(trx, owner, resourceSpawn, quantityExtracted * 5);
		}
	} else {
		resourceManager->harvestResourceToPlayer(trx, owner, resourceSpawn, quantityExtracted * 5);
	}

	trx.commit();

	/// Send System Messages
	StringIdChatParameter harvestMessage("skl_use", creatureHealth);

	harvestMessage.setDI(quantityExtracted);
	harvestMessage.setTU(resourceSpawn->getFinalClass());

	owner->sendSystemMessage(harvestMessage);

	/// Send bonus message
	if (modifier == 1.2f)
		owner->sendSystemMessage("@skl_use:group_harvest_bonus");
	else if (modifier == 1.3f)
		owner->sendSystemMessage("@skl_use:group_harvest_bonus_ranger");
	else if (modifier == 1.4f)
		owner->sendSystemMessage("@skl_use:group_harvest_bonus_masterranger");

	/// Send group spam
	if (owner->isGrouped()) {
		StringIdChatParameter bonusMessage("group", "notify_harvest_corpse");

		bonusMessage.setTU(droid->getDisplayedName());
		bonusMessage.setDI(quantityExtracted);
		bonusMessage.setTO(resourceSpawn->getFinalClass());
		bonusMessage.setTT(creature->getObjectNameStringIdFile(), creature->getObjectNameStringIdName());

		ChatSystemMessage* sysMessage = new ChatSystemMessage(bonusMessage);
		// owner->getGroup()->broadcastMessage(owner, sysMessage, false);
	}

	ManagedReference<PlayerManager*> playerManager = zoneServer->getPlayerManager();

	int xp = creature->getLevel() * 5 + 19;

	if(playerManager != nullptr)
		playerManager->awardExperience(owner, "scout", xp, true);

	creature->addAlreadyHarvested(owner);

	if (!creature->hasLoot() && creature->getBankCredits() < 1 && creature->getCashCredits() < 1 && !playerManager->canGroupMemberHarvestCorpse(owner, creature)) {
		Reference<DespawnCreatureTask*> despawn = creature->getPendingTask("despawn").castTo<DespawnCreatureTask*>();

		if (despawn != nullptr) {
			despawn->cancel();

			despawn->reschedule(1000);
		}
	}
}

void CreatureManagerImplementation::harvest(Creature* creature, CreatureObject* player, int selectedID) {
	Zone* zone = creature->getZone();

	if (zone == nullptr || !creature->isCreature())
		return;

	if (!creature->canHarvestMe(player))
		return;

	if (!player->isInRange(creature, 7))
		return;

	ManagedReference<ResourceManager*> resourceManager = zone->getZoneServer()->getResourceManager();

	String restype = "";
	float quantity = 0;

	if (selectedID == 112) {
		int type = System::random(2);

		if (quantity == 0 || type == 0) {
			if(creature->getHideMax() > 0) {
				restype = creature->getHideType();
				quantity = creature->getHideMax();
			}
		}

		if (quantity == 0 || type == 1) {
			if(creature->getMeatMax() > 0) {
				restype = creature->getMeatType();
				quantity = creature->getMeatMax();
			}
		}

		if (quantity == 0 || type == 2) {
			if(creature->getBoneMax() > 0) {
				restype = creature->getBoneType();
				quantity = creature->getBoneMax();
			}
		}
	}

	if (selectedID == 234) {
		restype = creature->getMeatType();
		quantity = creature->getMeatMax();
	} else if (selectedID == 235) {
		restype = creature->getHideType();
		quantity = creature->getHideMax();
	} else if (selectedID == 236) {
		restype = creature->getBoneType();
		quantity = creature->getBoneMax();
	}

	if(quantity == 0 || restype.isEmpty()) {
		player->sendSystemMessage("Tried to harvest something this creature didn't have, please report this error");
		return;
	}
	int quantityExtracted = int(quantity * float(player->getSkillMod("creature_harvesting") / 100.0f));
	quantityExtracted = Math::max(quantityExtracted, 3);

	ManagedReference<ResourceSpawn*> resourceSpawn = resourceManager->getCurrentSpawn(restype, player->getZone()->getZoneName());

	if (resourceSpawn == nullptr) {
		player->sendSystemMessage("Error: Server cannot locate a current spawn of " + restype);
		return;
	}

	float density = resourceSpawn->getDensityAt(player->getZone()->getZoneName(), player->getPositionX(), player->getPositionY());

	String creatureHealth = "";

	if (density > 0.75f) {
		quantityExtracted = int(quantityExtracted * 1.25f);
		creatureHealth = "creature_quality_fat";
	} else if (density > 0.50f) {
		quantityExtracted = int(quantityExtracted * 1.00f);
		creatureHealth = "creature_quality_medium";
	} else if (density > 0.25f) {
		quantityExtracted = int(quantityExtracted * 0.75f);
		creatureHealth = "creature_quality_scrawny";
	} else {
		quantityExtracted = int(quantityExtracted * 0.50f);
		creatureHealth = "creature_quality_skinny";
	}

	float modifier = 1;
	int baseAmount = quantityExtracted;

	if (player->isGrouped()) {
		modifier = player->getGroup()->getGroupHarvestModifier(player);

		quantityExtracted = (int)(quantityExtracted * modifier);
	}

	if (creature->getParent().get() != nullptr)
		quantityExtracted = 1;

	TransactionLog trx(TrxCode::HARVESTED, player, resourceSpawn);
	resourceManager->harvestResourceToPlayer(trx, player, resourceSpawn, quantityExtracted * 5);
	trx.commit();

	/// Send System Messages
	StringIdChatParameter harvestMessage("skl_use", creatureHealth);

	harvestMessage.setDI(quantityExtracted);
	harvestMessage.setTU(resourceSpawn->getFinalClass());

	player->sendSystemMessage(harvestMessage);

	/// Send bonus message
	if (modifier == 1.2f)
		player->sendSystemMessage("@skl_use:group_harvest_bonus");
	else if (modifier == 1.3f)
		player->sendSystemMessage("@skl_use:group_harvest_bonus_ranger");
	else if (modifier == 1.4f)
		player->sendSystemMessage("@skl_use:group_harvest_bonus_masterranger");

	/// Send group spam
	if (player->isGrouped()) {
		StringIdChatParameter bonusMessage("group", "notify_harvest_corpse");

		bonusMessage.setTU(player->getFirstName());
		bonusMessage.setDI(quantityExtracted);
		bonusMessage.setTO(resourceSpawn->getFinalClass());
		bonusMessage.setTT(creature->getObjectNameStringIdFile(), creature->getObjectNameStringIdName());

		ChatSystemMessage* sysMessage = new ChatSystemMessage(bonusMessage);
		// player->getGroup()->broadcastMessage(player, sysMessage, false);
	}

	ManagedReference<PlayerManager*> playerManager = zoneServer->getPlayerManager();

	int xp = creature->getLevel() * 5 + 19;

	if(playerManager != nullptr)
		playerManager->awardExperience(player, "scout", xp, true);

	creature->addAlreadyHarvested(player);

	player->notifyObservers(ObserverEventType::HARVESTEDCREATURE, resourceSpawn, quantityExtracted);

	if (!creature->hasLoot() && creature->getBankCredits() < 1 && creature->getCashCredits() < 1 && !playerManager->canGroupMemberHarvestCorpse(player, creature)) {
		Reference<DespawnCreatureTask*> despawn = creature->getPendingTask("despawn").castTo<DespawnCreatureTask*>();

		if (despawn != nullptr) {
			despawn->cancel();

			despawn->reschedule(1000);
		}
	}
}

void CreatureManagerImplementation::tame(Creature* creature, CreatureObject* player, bool force, bool adult) {
	if (creature == nullptr || player == nullptr) {
		return;
	}

	auto zoneServer = creature->getZoneServer();

	if (zoneServer == nullptr) {
		return;
	}

	auto zone = creature->getZone();

	if (zone == nullptr || !creature->isCreature()) {
		return;
	}

	if (player->getPendingTask("tame_pet") != nullptr) {
		player->sendSystemMessage("You are already taming a pet");
		return;
	}

	if (player->getPendingTask("call_pet") != nullptr) {
		player->sendSystemMessage("You cannot tame a pet while another is being called");
		return;
	}

	if (!creature->canTameMe(player) || !creature->isAttackableBy(player)) {
		player->sendSystemMessage("@pet/pet_menu:sys_cant_tame"); // You can't tame that
		return;
	}

	auto creatureTemplate = creature->getCreatureTemplate();

	if (creatureTemplate == nullptr)
		return;

	int templateLevel = creatureTemplate->getLevel();
	int maxLevelofPets = player->getSkillMod("tame_level");

	if (!player->hasSkill("outdoors_creaturehandler_novice") || (templateLevel > maxLevelofPets)) {
		player->sendSystemMessage("@pet/pet_menu:sys_lack_skill"); // You lack the skill to be able to tame that creature.
		return;
	}

	if ((creature->isVicious() && player->getSkillMod("tame_aggro") < 1) || creature->getChanceToTame(player) <= 0) {
		player->sendSystemMessage("@pet/pet_menu:sys_lack_skill"); // You lack the skill to be able to tame that creature.
		return;
	}

	ManagedReference<SceneObject*> datapad = player->getSlottedObject("datapad");

	if (datapad == nullptr)
		return;

	if (datapad->getContainerObjectsSize() >= datapad->getContainerVolumeLimit()) {
		player->sendSystemMessage("@faction_recruiter:datapad_full"); // Your datapad is full. You must first free some space.
		return;
	}

	ManagedReference<PlayerManager*> playerManager = zoneServer->getPlayerManager();

	int numberStored = 0;
	int maxStoredPets = playerManager->getBaseStoredCreaturePets() + player->getSkillMod("stored_pets");

	for (int i = 0; i < datapad->getContainerObjectsSize(); ++i) {
		ManagedReference<SceneObject*> object = datapad->getContainerObject(i);

		if (object != nullptr && object->isPetControlDevice()) {
			PetControlDevice* device = cast<PetControlDevice*>( object.get());

			if (device->getPetType() == PetManager::CREATUREPET) {
				if (++numberStored >= maxStoredPets) {
					player->sendSystemMessage("@pet/pet_menu:sys_too_many_stored"); // There are too many pets stored in this container. Release some of them to make room for more.
					return;
				}

			}
		}
	}

	ManagedReference<PlayerObject*> ghost = player->getPlayerObject();

	int currentlySpawned = 0;
	int spawnedLevel = 0;
	int level = creature->getLevel();
	int maxPets = player->getSkillMod("keep_creature");

	for (int i = 0; i < ghost->getActivePetsSize(); ++i) {
		ManagedReference<AiAgent*> object = ghost->getActivePet(i);

		if (object != nullptr) {
			ManagedReference<PetControlDevice*> pcd = object->getControlDevice().get().castTo<PetControlDevice*>();

			if (pcd == nullptr || pcd->getPetType() != PetManager::CREATUREPET) {
				continue;
			}

			if (++currentlySpawned >= maxPets) {
				player->sendSystemMessage("@pet/pet_menu:too_many"); // You can't control any more pets. Store one first
				return;
			}

			spawnedLevel += object->getLevel();

			if ((spawnedLevel + level) >= maxLevelofPets) {
				player->sendSystemMessage("Taming this pet would exceed your control level ability.");
				return;
			}
		}
	}

	if (force && !ghost->isPrivileged()) {
		force = false;
	}

	auto chatManager = zoneServer->getChatManager();

	if (chatManager != nullptr) {
		chatManager->broadcastChatMessage(player, "@hireling/hireling:taming_" + String::valueOf(System::random(4) + 1), 0, 0, player->getMoodID(), 0, ghost->getLanguageID());
	}

	Locker clocker(creature);

	int mask = creature->getPvpStatusBitmask();
	creature->setPvpStatusBitmask(0, true);

	creature->clearPatrolPoints();
	creature->addObjectFlag(ObjectFlag::STATIONARY);
	creature->setFollowObject(nullptr);
	creature->setMovementState(AiAgent::OBLIVIOUS);

	// Update AI Behavior Tree
	creature->setAITemplate();

	Reference<TameCreatureTask*> task = new TameCreatureTask(creature, player, mask, force, adult);

	player->addPendingTask("tame_pet", task, 10000);
}

void CreatureManagerImplementation::milk(Creature* creature, CreatureObject* player) {
	Zone* zone = creature->getZone();

	if (zone == nullptr || !creature->isCreature())
		return;

	if (!creature->canMilkMe(player))
		return;

	if (player->isRidingMount()) {
		player->sendSystemMessage("@skl_use:skl_use"); //You cannot milk while mounted.
		return;
	}

	player->sendSystemMessage("@skl_use:milk_begin"); //You relax the creature and begin to milk it.

	Locker clocker(creature);

	creature->setMilkState(BEINGMILKED);

	creature->clearPatrolPoints();
	creature->addObjectFlag(ObjectFlag::STATIONARY);
	creature->setAITemplate();

	Reference<MilkCreatureTask*> task = new MilkCreatureTask(creature, player);

	task->schedule(10000);
}

void CreatureManagerImplementation::sample(Creature* creature, CreatureObject* player) {
	Zone* zone = creature->getZone();

	if (zone == nullptr || !creature->isCreature() || creature->isNonPlayerCreatureObject()) {
		return;
	}

	if (!creature->canCollectDna(player)){
		player->sendSystemMessage("@bio_engineer:harvest_dna_cant_harvest");
		return;
	}

	if (player->isRidingMount()) {
		player->sendSystemMessage("You cannot sample DNA while mounted");
		return;
	}

	if(player->getPendingTask("sampledna") != nullptr) {
		player->sendSystemMessage("@bio_engineer:harvest_dna_already_harvesting");
		return;
	}
	if (!creature->hasSkillToSampleMe(player)){
		player->sendSystemMessage("@bio_engineer:harvest_dna_skill_too_low");
		return;
	}

	Locker clocker(creature);

	Reference<SampleDnaTask*> task = new SampleDnaTask(creature, player);
	player->addPendingTask("sampledna",task,0);

}

SpawnArea* CreatureManagerImplementation::getWorldSpawnArea() {
	for (int i = 0; i < spawnAreaMap.size(); i++) {
		SpawnArea* area = spawnAreaMap.get(i);

		if (area == nullptr || !area->isWorldSpawnArea()) {
			continue;
		}

		return area;
	}

	return nullptr;
}

bool CreatureManagerImplementation::addWearableItem(CreatureObject* creature, TangibleObject* clothing, bool isVendor) {
	if (creature == nullptr || clothing == nullptr) {
		return false;
	}

	if (!clothing->isWearableObject() && !clothing->isWeaponObject())
		return false;

	ChatManager* chatManager = zoneServer->getChatManager();
	SharedTangibleObjectTemplate* tanoData = dynamic_cast<SharedTangibleObjectTemplate*>(clothing->getObjectTemplate());

	if (tanoData == nullptr || chatManager == nullptr)
		return false;

	const Vector<uint32>* races = tanoData->getPlayerRaces();
	const String race = creature->getObjectTemplate()->getFullTemplateString();

	if (clothing->isWearableObject() && !races->contains(race.hashCode())) {
		int species = creature->getSpecies();
		UnicodeString message;

		// Vendor fail messages
		if (isVendor) {
			if (species == CreatureObject::ITHORIAN) {
				message = "@player_structure:wear_not_ithorian";
			} else {
				message = "@player_structure:wear_no";
			}
		// NPC actor fail messages
		} else {
			if (species == CreatureObject::ITHORIAN) {
				message = "@event_perk_npc_actor:wear_no_ithorian";
			} else if (species == CreatureObject::WOOKIEE) {
				message = "@event_perk_npc_actor:wear_no_wookiee";
			} else {
				message = "@event_perk_npc_actor:wear_no";
			}
		}

		chatManager->broadcastChatMessage(creature, message, clothing->getObjectID(), 0, creature->getMoodID());

		return false;
	}

	ManagedReference<SceneObject*> clothingParent = clothing->getParent().get();

	if (clothingParent == nullptr)
		return false;

	for (int i = 0; i < clothing->getArrangementDescriptorSize(); ++i) {
		const Vector<String>* descriptors = clothing->getArrangementDescriptor(i);

		for (int j = 0; j < descriptors->size(); ++j) {
			ManagedReference<SceneObject*> slot = creature->getSlottedObject(descriptors->get(j));

			if (slot != nullptr) {
				Locker locker(slot);

				slot->destroyObjectFromWorld(true);
				slot->destroyObjectFromDatabase(true);
			}
		}
	}

	creature->transferObject(clothing, 4, false);
	creature->broadcastObject(clothing, true);

	creature->doAnimation("pose_proudly");

	UnicodeString message;

	if (isVendor) {
		if (clothing->isWeaponObject()) {
			message = "@player_structure:wear_yes_weapon";
		} else {
			message = "@player_structure:wear_yes";
		}
	} else {
		if (clothing->isWeaponObject()) {
			message = "@event_perk_npc_actor:wear_yes_weapon";
		} else {
			message = "@event_perk_npc_actor:wear_yes";
		}
	}

	chatManager->broadcastChatMessage(creature, message, clothing->getObjectID(), 0, creature->getMoodID());

	return true;
}
