#include "server/zone/objects/intangible/PetControlDevice.h"
#include "server/zone/objects/intangible/PetControlObserver.h"
#include "server/zone/objects/intangible/tasks/EnqueuePetCommand.h"
#include "server/zone/managers/creature/PetManager.h"
#include "server/zone/objects/creature/CreatureObject.h"
#include "server/zone/objects/creature/ai/AiAgent.h"
#include "server/zone/objects/creature/ai/Creature.h"
#include "server/zone/objects/creature/ai/DroidObject.h"
#include "server/zone/objects/creature/ai/HelperDroidObject.h"
#include "server/zone/objects/player/PlayerObject.h"
#include "server/zone/objects/player/sui/listbox/SuiListBox.h"
#include "server/zone/objects/player/sui/messagebox/SuiMessageBox.h"
#include "server/zone/objects/player/sui/callbacks/MountGrowthArrestSuiCallback.h"
#include "server/zone/objects/player/sui/callbacks/PetFixSuiCallback.h"
#include "server/zone/ZoneServer.h"
#include "server/zone/Zone.h"
#include "tasks/CallPetTask.h"
#include "server/zone/objects/region/CityRegion.h"
#include "server/zone/objects/player/sessions/TradeSession.h"
#include "server/zone/managers/player/PlayerManager.h"
#include "server/zone/objects/creature/events/DroidSkillModTask.h"
#include "server/zone/objects/creature/events/DroidPowerTask.h"
#include "server/zone/objects/tangible/weapon/WeaponObject.h"
#include "server/zone/objects/building/BuildingObject.h"
#include "server/zone/managers/stringid/StringIdManager.h"
#include "tasks/StorePetTask.h"
#include "server/chat/ChatManager.h"
#include "server/zone/objects/player/FactionStatus.h"
#include "server/zone/managers/frs/FrsManager.h"
#include "server/zone/objects/creature/commands/QueueCommand.h"
#include "server/zone/objects/intangible/tasks/PetControlDeviceStoreTask.h"

void PetControlDeviceImplementation::callObject(CreatureObject* player, bool initialCall) {
	if (player == nullptr) {
		return;
	}

	if (!isASubChildOf(player)) {
		return;
	}

	// Player is Dead or currently taming a pet
	if (player->isDead() || player->getPendingTask("tame_pet") != nullptr) {
		player->sendSystemMessage("@pet/pet_menu:cant_call"); // You cannot call this pet right now.
		return;
	}

	// Private Building Check
	auto parent = player->getParent().get();

	if (parent != nullptr && !parent->isMount() && !parent->isVehicleObject()) {
		ManagedReference<SceneObject*> strongRef = player->getRootParent();

		if (strongRef != nullptr && !strongRef->isPobShip()) {
			ManagedReference<BuildingObject*> building = strongRef.castTo<BuildingObject*>();

			if (building == nullptr || building->isPrivateStructure()) {
				player->sendSystemMessage("@pet/pet_menu:private_house"); // You cannot call pets in a private building.
				return;
			}
		}
	}

	auto zoneServer = player->getZoneServer();

	if (zoneServer == nullptr) {
		return;
	}

	// Player is in FRS Enclave Check
	FrsManager* frsManager = zoneServer->getFrsManager();

	if (frsManager == nullptr || (frsManager->isFrsEnabled() && frsManager->isPlayerInEnclave(player))) {
		player->sendSystemMessage("@pet/pet_menu:cant_call"); //  You cannot call this pet right now.
		return;
	}

	ManagedReference<TangibleObject*> controlledObject = this->controlledObject.get();

	if (controlledObject == nullptr || !controlledObject->isAiAgent()) {
		return;
	}

	ManagedReference<AiAgent*> pet = cast<AiAgent*>(controlledObject.get());

	if (pet == nullptr) {
		return;
	}

	ManagedReference<PlayerObject*> ghost = player->getPlayerObject();

	if (ghost == nullptr || ghost->hasActivePet(pet)) {
		return;
	}

	if (pet->getDefaultWeapon() == nullptr) {
		pet->createDefaultWeapon();
		player->sendSystemMessage("This pet does not have a proper default weapon, attempting to create one. Please call your pet again.");

		return;
	}

	// This should never trigger, pet vitality should never drop below 1
	if (vitality <= 0) {
		player->sendSystemMessage("@pet/pet_menu:dead_pet"); // This pet is dead. Select DESTROY from the radial menu to delete this pet control device.
		return;
	}

	if (!pet->checkCooldownRecovery("call_cooldown")) {
		if (petType == PetManager::DROIDPET)
			player->sendSystemMessage("@pet/droid_modules:droid_maint_on_maint_run"); //You cannot call that droid. It is currently on a maintenance run.
		else
			player->sendSystemMessage("@pet/pet_menu:cant_call"); // cant call pet right now
		return;
	}

	bool isBombDroid = false;

	// Bomb Droid bool only can be true on initial call
	if (pet->isDroid()) {
		auto droid = pet.castTo<DroidObject*>();

		if (droid != nullptr && droid->isBombDroid()) {
			isBombDroid = true;
		}
	}

	// No Pet active area check
	if (!isBombDroid) {
		SortedVector<ManagedReference<ActiveArea*> >* areas = player->getActiveAreas();

		for (int i = 0; i < areas->size(); i++) {
			ActiveArea* area = areas->get(i);

			if (area != nullptr && area->isNoPetArea()) {
				player->sendSystemMessage("@pet/pet_menu:cant_call"); // You cannot call this pet right now.
				return;
			}
		}
	}

	// Only Bomb droids can be called while in combat and while feigning death
	if ((((isBombDroid && !initialCall) || !isBombDroid) && (player->isInCombat() || player->isIncapacitated())) || (isBombDroid && initialCall && player->isIncapacitated() && !player->isFeigningDeath())) {
		player->sendSystemMessage("@pet/pet_menu:cant_call"); // You cannot call this pet right now.
		return;
	}

	// Bomb Droids can be called while riding a mount only when direct from deed form
	if (((isBombDroid && !initialCall) || !isBombDroid) && player->isRidingMount()) {
		player->sendSystemMessage("@pet/pet_menu:mounted_call_warning"); // You cannot call a pet while mounted or riding a vehicle.
		return;
	}

	unsigned int petFaction = pet->getFaction();

	if (petFaction != 0) {
		if (player->getFaction() == 0) {
			StringIdChatParameter message("@faction_perk:prose_be_declared"); // You must be declared to a faction to use %TT.
			message.setTT(pet->getDisplayedName());
			player->sendSystemMessage(message);
			return;
		}

		if (ConfigManager::instance()->useCovertOvertSystem()) {
			if (player->getFaction() != petFaction || player->getFactionStatus() != FactionStatus::OVERT) {
				StringIdChatParameter message("@faction_perk:prose_be_declared_faction"); // You must be a declared %TO to use %TT.
				message.setTO(pet->getFactionString());
				message.setTT(pet->getDisplayedName());
				player->sendSystemMessage(message);
				return;
			}
		} else {
			if (player->getFaction() != petFaction || player->getFactionStatus() == FactionStatus::ONLEAVE) {
				StringIdChatParameter message("@faction_perk:prose_be_declared_faction"); // You must be a declared %TO to use %TT.
				message.setTO(pet->getFactionString());
				message.setTT(pet->getDisplayedName());
				player->sendSystemMessage(message);
				return;
			}
		}
	}

	if (player->getPendingTask("call_pet") != nullptr) {
		StringIdChatParameter waitTime("pet/pet_menu", "call_delay_finish_pet"); // Already calling a Pet: Call will be finished in %DI seconds.
		AtomicTime nextExecution;
		Core::getTaskManager()->getNextExecutionTime(player->getPendingTask("call_pet"), nextExecution);
		int timeLeft = (nextExecution.getMiliTime() / 1000) - System::getTime();
		waitTime.setDI(timeLeft);

		player->sendSystemMessage(waitTime);
		return;
	}

	if (!growPet(player))
		return;

	if (petType == PetManager::CREATUREPET && !isValidPet(pet)) {
		ManagedReference<SuiMessageBox*> box = new SuiMessageBox(player,SuiWindowType::PET_FIX_DIALOG);
		box->setCallback(new PetFixSuiCallback(player->getZoneServer(), _this.getReferenceUnsafeStaticCast()));
		box->setPromptText("@bio_engineer:pet_sui_text");
		box->setPromptTitle("@bio_engineer:pet_sui_title");
		box->setOkButton(true,"@bio_engineer:pet_sui_fix_stats");
		box->setCancelButton(true,"@bio_engineer:pet_sui_abort");
		box->setOtherButton(true,"@bio_engineer:pet_sui_fix_level");
		box->setUsingObject(_this.getReferenceUnsafeStaticCast());
		ghost->addSuiBox(box);
		player->sendMessage(box->generateMessage());
		return;
	}

	int currentlySpawned = 0;
	int spawnedLevel = 0;
	int maxPets = 1;
	int maxLevelofPets = 10;
	int level = pet->getLevel();

	if (pet->getCreatureTemplate() == nullptr) {
		player->sendSystemMessage("Invalid creature to spawn!"); // Old npc without a npc template?
		return;
	}

	if (petType == PetManager::CREATUREPET) {
		ManagedReference<Creature*> creaturePet = cast<Creature*>(pet.get());

		if (creaturePet == nullptr)
			return;

		bool ch = player->hasSkill("outdoors_creaturehandler_novice");

		if (ch) {
			maxPets = player->getSkillMod("keep_creature");
			maxLevelofPets = player->getSkillMod("tame_level");
		}

		if (creaturePet->getAdultLevel() > maxLevelofPets) {
			player->sendSystemMessage("@pet/pet_menu:control_exceeded"); // Calling this pet would exceed your Control Level ability.
			return;
		}

		if (creaturePet->isVicious() && (player->getSkillMod("tame_aggro") <= 0 || !ch)) {
			player->sendSystemMessage("@pet/pet_menu:lack_skill"); // You lack the skill to call a pet of this type.
			return;
		}

	} else if (petType == PetManager::FACTIONPET){
		maxPets = 3;
	}

	for (int i = 0; i < ghost->getActivePetsSize(); ++i) {
		ManagedReference<AiAgent*> object = ghost->getActivePet(i);

		String pet_faction = pet->getFactionString().toLowerCase();

		if (object != nullptr) {
			if (object->isCreature() && petType == PetManager::CREATUREPET) {
				const CreatureTemplate* activePetTemplate = object->getCreatureTemplate();

				if (activePetTemplate == nullptr || activePetTemplate->getTemplateName() == "at_st" || activePetTemplate->getTemplateName() == "rebel_droideka")
					continue;

				if (++currentlySpawned >= maxPets) {
					player->sendSystemMessage("@pet/pet_menu:at_max"); // You already have the maximum number of pets of this type that you can call.
					return;
				}

				spawnedLevel += object->getLevel();

				if ((spawnedLevel + level) > maxLevelofPets) {
					player->sendSystemMessage("@pet/pet_menu:control_exceeded"); // Calling this pet would exceed your Control Level ability.
					return;
				}
			} else if (object->isNonPlayerCreatureObject() && petType == PetManager::FACTIONPET) {
				if (++currentlySpawned >= maxPets) {
					player->sendSystemMessage("@pet/pet_menu:at_max"); // You already have the maximum number of pets of this type that you can call.
					return;
				}
			} else if (object->isCreature() && petType == PetManager::FACTIONPET) {
				const CreatureTemplate* activePetTemplate = object->getCreatureTemplate();
				const CreatureTemplate* callingPetTemplate = pet->getCreatureTemplate();

				if (activePetTemplate == nullptr || callingPetTemplate == nullptr || (pet_faction == "imperial" && activePetTemplate->getTemplateName() != "at_st") || (pet_faction == "rebel" &&  activePetTemplate->getTemplateName() != "rebel_droideka"))
					continue;

				if (++currentlySpawned >= maxPets || (activePetTemplate->getTemplateName() == "at_st" && callingPetTemplate->getTemplateName() == "at_st") || (activePetTemplate->getTemplateName() == "rebel_droideka" && callingPetTemplate->getTemplateName() == "rebel_droideka")) {
					player->sendSystemMessage("@pet/pet_menu:at_max"); // You already have the maximum number of pets of this type that you can call.
					return;
				}
			} else if (object->isDroidObject() && petType == PetManager::DROIDPET) {
				if (++currentlySpawned >= maxPets) {
					player->sendSystemMessage("@pet/pet_menu:at_max"); // You already have the maximum number of pets of this type that you can call.
					return;
				}
			}

		}
	}

	ManagedReference<TradeSession*> tradeContainer = player->getActiveSession(SessionFacadeType::TRADE).castTo<TradeSession*>();

	if (tradeContainer != nullptr) {
		server->getZoneServer()->getPlayerManager()->handleAbortTradeMessage(player);
	}

	if (player->getCurrentCamp() == nullptr && player->getCityRegion() == nullptr && !ghost->isPrivileged() && !isBombDroid) {
		Reference<CallPetTask*> callPet = new CallPetTask(_this.getReferenceUnsafeStaticCast(), player, "call_pet");

		StringIdChatParameter message("pet/pet_menu", "call_pet_delay"); // Calling pet in %DI seconds. Combat will terminate pet call.
		message.setDI(2);
		player->sendSystemMessage(message);

		player->addPendingTask("call_pet", callPet, 2 * 1000);

		if (petControlObserver == nullptr) {
			petControlObserver = new PetControlObserver(_this.getReferenceUnsafeStaticCast());
			petControlObserver->deploy();
		}

		player->registerObserver(ObserverEventType::STARTCOMBAT, petControlObserver);
	} else { // Player is in a city or camp or the player is calling a bomb droid from a deed, spawn pet immediately
		// Check cooldown
		if (!player->checkCooldownRecovery("petCallOrStoreCooldown")) {
			player->sendSystemMessage("@pet/pet_menu:cant_call_1sec"); //"You cannot CALL for 1 second."
			return;
		}

		spawnObject(player);

		// Set cooldown
		player->updateCooldownTimer("petCallOrStoreCooldown", 1000); // 1 sec
	}

	EnqueuePetCommand* enqueueCommand = new EnqueuePetCommand(pet, String("petFollow").toLowerCase().hashCode(), String::valueOf(player->getObjectID()), player->getObjectID(), QueueCommand::NORMAL);
	enqueueCommand->schedule(50);
}

int PetControlDeviceImplementation::handleObjectMenuSelect(CreatureObject* player, byte selectedID) {
	//Logger::info("selected call");

	Reference<TangibleObject*> strongRef = controlledObject.get();

	if (strongRef == nullptr)
		return 1;

	AiAgent* pet = cast<AiAgent*>(strongRef.get());

	Reference<PlayerObject*> ghost = player->getPlayerObject();

	if (selectedID == 44) {
		if (pet == nullptr) {
			error("null controlled object in pet control device");
			return 1;
		} else {
			Reference<AiAgent*> petReference = pet;
			Reference<CreatureObject*> playerReference = player;
			Reference<PetControlDevice*> thisReference = _this.getReferenceUnsafeStaticCast();

			Core::getTaskManager()->executeTask([thisReference, petReference, playerReference] () {
				Locker locker(playerReference);

				Locker crossLocker(petReference, playerReference);

				Locker controlLocker(thisReference);

				thisReference->callObject(playerReference);
			}, "ControlDeviceCallLambda");
		}
	} else if (selectedID == 59) {
		if (pet == nullptr) {
			error("null controlled object in pet control device");
			return 1;
		} else {
			if (status == 1 && !ghost->hasActivePet(pet)) {
				Reference<AiAgent*> petReference = pet;
				Reference<CreatureObject*> playerReference = player;
				Reference<PetControlDevice*> thisReference = _this.getReferenceUnsafeStaticCast();

				Core::getTaskManager()->executeTask([thisReference, petReference, playerReference] () {
					Locker locker(playerReference);

					Locker crossLocker(petReference, playerReference);

					Locker controlLocker(thisReference);

					thisReference->callObject(playerReference);
				}, "ControlDeviceCallLambda2");
			} else {
				PetControlDeviceStoreTask* storeTask = new PetControlDeviceStoreTask(_this.getReferenceUnsafeStaticCast(), player, false);

				if (storeTask != nullptr)
					storeTask->execute();
			}
		}
	}

	return 0;
}

void PetControlDeviceImplementation::spawnObject(CreatureObject* player) {
	ZoneServer* zoneServer = getZoneServer();

	ManagedReference<TangibleObject*> controlledObject = this->controlledObject.get();

	if (controlledObject == nullptr)
		return;

	assert(controlledObject->isLockedByCurrentThread());

	if (!isASubChildOf(player))
		return;

	ManagedReference<TradeSession*> tradeContainer = player->getActiveSession(SessionFacadeType::TRADE).castTo<TradeSession*>();

	if (tradeContainer != nullptr) {
		server->getZoneServer()->getPlayerManager()->handleAbortTradeMessage(player);
	}

	controlledObject->initializePosition(player->getPositionX() + System::random(5) - 2, player->getPositionZ(), player->getPositionY() + System::random(5) - 2);
	ManagedReference<CreatureObject*> creature = nullptr;

	if (controlledObject->isCreatureObject()) {
		creature = cast<CreatureObject*>(controlledObject.get());

		creature->setCreatureLink(player);
		creature->setControlDevice(_this.getReferenceUnsafeStaticCast());
		creature->setFaction(player->getFaction());
		creature->setObjectMenuComponent("PetMenuComponent");

		if (creature->getHueValue() >= 0)
			creature->setHue(creature->getHueValue());

		uint32 playerPvpStatusBitmask = player->getPvpStatusBitmask();

		if (playerPvpStatusBitmask & ObjectFlag::PLAYER) {
			playerPvpStatusBitmask &= ~ObjectFlag::PLAYER;

			creature->setPvpStatusBitmask(playerPvpStatusBitmask);
		} else {
			creature->setPvpStatusBitmask(playerPvpStatusBitmask);
		}

		if (trainedAsMount && (creature->getOptionsBitmask() ^ 0x1000)) {
			creature->setOptionBit(0x1000);
		}
	}

	Zone* zone = player->getZone();

	if (zone == nullptr)
		return;

	ManagedReference<CellObject*> parent = player->getParent().get().castTo<CellObject*>();

	if (parent != nullptr)
		parent->transferObject(controlledObject, -1, true);
	else
		zone->transferObject(controlledObject, -1, true);

	updateStatus(1);

	if (petControlObserver != nullptr)
		player->dropObserver(ObserverEventType::STARTCOMBAT, petControlObserver);

	AiAgent* pet = cast<AiAgent*>(creature.get());

	if (pet == nullptr)
		return;

	ManagedReference<PlayerObject*> ghost = player->getPlayerObject();
	ghost->addToActivePets(pet);

	bool isDroid = false;
	if (pet->isDroidObject()) {
		DroidObject* droid = cast<DroidObject*>(pet);
		isDroid = true;
		if( droid == nullptr )
			return;

		// Sanity check that there aren't outstanding power/skill mod tasks
		droid->removePendingTask( "droid_power" );
		droid->removePendingTask( "droid_skill_mod" );
		droid->initDroidModules();
		droid->onCall();
		droid->loadSkillMods(player);
		// Submit new power task
		Reference<Task*> droidPowerTask = new DroidPowerTask( droid );
		droid->addPendingTask("droid_power", droidPowerTask, 120000); // 2 min
		// Submit new skill mod task
		Reference<Task*> droidSkillModTask = new DroidSkillModTask( droid, player );
		droid->addPendingTask("droid_skill_mod", droidSkillModTask, 3000); // 3 sec
	}

	if (pet->isHelperDroidObject()) {
		HelperDroidObject* helperDroid = cast<HelperDroidObject*>(pet);

		if (helperDroid == nullptr )
			return;

		helperDroid->onCall();
	}

	// This will clear the points set by the BT and any stored points on the PCD
	pet->clearPatrolPoints();
	clearPatrolPoints();

	pet->setHomeLocation(player->getPositionX(), player->getPositionZ(), player->getPositionY(), player->getParent().get().castTo<CellObject*>());
	pet->setNextPosition(player->getPositionX(), player->getPositionZ(), player->getPositionY(), player->getParent().get().castTo<CellObject*>());

	pet->setFollowObject(player);

	if (petType == PetManager::CREATUREPET) {
		pet->setCreatureBitmask(ObjectFlag::PET);
	}
	if (petType == PetManager::DROIDPET || petType == PetManager::HELPERDROIDPET) {
		pet->setCreatureBitmask(ObjectFlag::DROID_PET);
	}
	if (petType == PetManager::FACTIONPET) {
		pet->setCreatureBitmask(ObjectFlag::FACTION_PET);
		/** dont know if npc faction pets trained via converse instead of radial
		if (pet->isNonPlayerCreatureObject() && pet->getDiet() != ObjectFlag::NONE) // show converse to npcs that eat food i.e. not atst
			pet->setOptionBit(OptionBitmask::CONVERSE,true);
		**/
	}

	pet->setAITemplate();
	pet->activateRecovery();
	// Not training any commands
	trainingCommand = 0;

	pet->faceObject(player, true);

	setLastCommander(player);
	setLastCommandTarget(nullptr);
	setLastCommand(PetManager::FOLLOW);
}

void PetControlDeviceImplementation::cancelSpawnObject(CreatureObject* player) {
	Reference<Task*> petTask = player->getPendingTask("call_pet");

	if(petTask != nullptr) {
		petTask->cancel();
		player->removePendingTask("call_pet");
	}

	if (petControlObserver != nullptr)
		player->dropObserver(ObserverEventType::STARTCOMBAT, petControlObserver);
}

void PetControlDeviceImplementation::storeObject(CreatureObject* player, bool force) {
	ManagedReference<TangibleObject*> controlledObject = this->controlledObject.get();

	if (controlledObject == nullptr || !controlledObject->isAiAgent())
		return;

	ManagedReference<AiAgent*> pet = cast<AiAgent*>(controlledObject.get());

	if (pet == nullptr)
		return;

	if (!force) {
		// Fail if pet or player are in combat or if the pet is dead, unless forced
		if (pet->isInCombat() || player->isInCombat() || player->isDead())
			return;

		// Check cooldown for call or store
		if (!player->checkCooldownRecovery("petCallOrStoreCooldown")) {
			player->sendSystemMessage("@pet/pet_menu:cant_store_1sec"); //"You cannot STORE for 1 second."
			return;
		}
	}

	// Cross lock the player to the pet for discmount
	Locker playerLock(player, _this.getReferenceUnsafeStaticCast());

	// Handle dismounting the player
	if (player->isRidingMount() && player->getParentID() == pet->getObjectID()) {
		// Fail the store is the player is mounted and they still have a mount_dismount cooldown
		if (!force && !player->checkCooldownRecovery("mount_dismount"))
			return;

		player->executeObjectControllerAction(STRING_HASHCODE("dismount"));

		if (player->isRidingMount())
			return;
	}

	// Set 1 second cooldown on the player
	player->updateCooldownTimer("petCallOrStoreCooldown", 1000);

	// Release the lock on the player
	playerLock.release();

	// Clear training commands
	setTrainingCommand(0);

	// clear friends list
	friends.removeAll();

	// Call for admin check to force quick store
	auto ghost = player->getPlayerObject();

	Reference<StorePetTask*> task = new StorePetTask(player, pet);

	if (task == nullptr)
		return;

	// Store non-faction pets immediately.  Store faction pets after 60sec delay.
	if (getPetType() != PetManager::FACTIONPET || force || (ghost != nullptr && ghost->isPrivileged())) {
		task->execute();
	} else if (pet->getPendingTask("store_pet") == nullptr) {
		// Cross lock the pet to add the task
		Locker playerLock(pet, _this.getReferenceUnsafeStaticCast());

		player->sendSystemMessage( "Storing pet in 60 seconds");

		pet->addPendingTask("store_pet", task, 60 * 1000);
	} else {
		AtomicTime nextExecution;

		Core::getTaskManager()->getNextExecutionTime(pet->getPendingTask("store_pet"), nextExecution);

		int timeLeft = (nextExecution.getMiliTime() / 1000) - System::getTime();

		player->sendSystemMessage( "Pet will store in " + String::valueOf(timeLeft) + " seconds." );
	}
}

bool PetControlDeviceImplementation::growPet(CreatureObject* player, bool force, bool adult) {
	if (petType != PetManager::CREATUREPET)
		return true;

	if (growthStage <= 0 || growthStage >= 10)
		return true;

	ManagedReference<TangibleObject*> controlledObject = this->controlledObject.get();

	if (controlledObject == nullptr || !controlledObject->isCreature())
		return true;
	ManagedReference<Creature*> pet = cast<Creature*>(controlledObject.get());

	Reference<const CreatureTemplate*> creatureTemplate = pet->getCreatureTemplate();

	if (creatureTemplate == nullptr)
		return true;

	PetManager* petManager = pet->getZoneServer()->getPetManager();
	if (petManager == nullptr)
		return true;

	Time currentTime;
	uint32 timeDelta = currentTime.getTime() - lastGrowth.getTime();
	int stagesToGrow = timeDelta / 6;

	if (adult)
		stagesToGrow = 10;

	if (stagesToGrow == 0 && !force)
		return true;

	int newStage = growthStage + stagesToGrow;
	if (newStage > 10)
		newStage = 10;

	float newLevel = ((float)pet->getAdultLevel() / 10.0) * (float)newStage;
	if (newLevel < 1)
		newLevel = 1;

	float newHeight = creatureTemplate->getScale() * (0.46 + ((float)newStage * 0.06));

	short preEligibility = petManager->checkMountEligibility(_this.getReferenceUnsafeStaticCast());
	short postEligibility = petManager->checkMountEligibility(_this.getReferenceUnsafeStaticCast(), newHeight);

	assert(pet->isLockedByCurrentThread());

	if (preEligibility == PetManager::CANBEMOUNTTRAINED && postEligibility == PetManager::TOOLARGE && !force) {
		if (isTrainedAsMount()) {
			arrestGrowth();
			return true;
		}

		PlayerObject* ghost = player->getPlayerObject();

		if (ghost == nullptr){
			return true;
		}

		ManagedReference<SuiListBox*> box = new SuiListBox(player, SuiWindowType::MOUNT_GROWTH_ARREST);
		box->setPromptTitle("@pet/pet_menu:mount_growth_title"); // Pet Growth Arrest
		box->setPromptText("@pet/pet_menu:mount_growth_prompt"); // Your pet could be trained as a mount, but is about to grow too large to serve as one. If you ever plan on training this pet as a mount you must arrest it's growth now. Stop pet's growth?
		box->setUsingObject(_this.getReferenceUnsafeStaticCast());
		box->setCancelButton(true, "@cancel");
		box->setOkButton(true, "@yes");
		box->setOtherButton(true, "@no");
		box->setCallback(new MountGrowthArrestSuiCallback(player->getZoneServer(), _this.getReferenceUnsafeStaticCast()));

		ghost->addSuiBox(box);
		player->sendMessage(box->generateMessage());
		return false;
	}

	if (adult)
		pet->setHeight(newHeight, true);
	else
		pet->setHeight(newHeight, false);

	pet->setPetLevel(newLevel);

	growthStage = newStage;
	lastGrowth.updateToCurrentTime();

	setVitality(getVitality());

	return true;
}

void PetControlDeviceImplementation::arrestGrowth() {
	if (petType != PetManager::CREATUREPET)
		return;

	if (growthStage <= 0 || growthStage >= 10)
		return;

	ManagedReference<TangibleObject*> controlledObject = this->controlledObject.get();

	if (controlledObject == nullptr || !controlledObject->isCreature())
		return;

	ManagedReference<Creature*> pet = cast<Creature*>(controlledObject.get());

	Reference<const CreatureTemplate*> creatureTemplate = pet->getCreatureTemplate();

	if (creatureTemplate == nullptr)
		return;

	PetManager* petManager = pet->getZoneServer()->getPetManager();
	if (petManager == nullptr)
		return;

	int newStage = growthStage;

	for (int i = (growthStage + 1); i < 11; i++) {
		float newHeight = creatureTemplate->getScale() * (0.46 + ((float)i * 0.06));

		short mountEligibility = petManager->checkMountEligibility(_this.getReferenceUnsafeStaticCast(), newHeight);

		if (mountEligibility == PetManager::TOOLARGE)
			break;
		else if (mountEligibility == PetManager::CANBEMOUNTTRAINED)
			newStage = i;
	}

	if (newStage > growthStage) {
		float newLevel = ((float)pet->getAdultLevel() / 10.0) * (float)newStage;
		if (newLevel < 1)
			newLevel = 1;

		float newHeight = creatureTemplate->getScale() * (0.46 + ((float)newStage * 0.06));

		pet->setHeight(newHeight, false);
		pet->setPetLevel(newLevel);
	}

	setVitality(getVitality());

	growthStage = 10;
	lastGrowth.updateToCurrentTime();
}

void PetControlDeviceImplementation::destroyObjectFromDatabase(bool destroyContainedObjects) {
	ManagedReference<TangibleObject*> controlledObject = this->controlledObject.get();

	if (controlledObject != nullptr) {
		Locker locker(controlledObject);

		ManagedReference<CreatureObject*> object = controlledObject->getSlottedObject("rider").castTo<CreatureObject*>();

		if (object != nullptr) {
			Locker clocker(object, controlledObject);

			object->executeObjectControllerAction(STRING_HASHCODE("dismount"));

			object = controlledObject->getSlottedObject("rider").castTo<CreatureObject*>();

			if (object != nullptr) {
				controlledObject->removeObject(object, nullptr, true);

				Zone* zone = getZone();

				if (zone != nullptr)
					zone->transferObject(object, -1, true);
			}
		}

		controlledObject->destroyObjectFromDatabase(true);
	}

	IntangibleObjectImplementation::destroyObjectFromDatabase(destroyContainedObjects);
}

void PetControlDeviceImplementation::destroyObjectFromWorld(bool sendSelfDestroy) {
	if (petType == PetManager::CREATUREPET) {
		ManagedReference<CreatureObject*> player = getParentRecursively(SceneObjectType::PLAYERCREATURE).castTo<CreatureObject*>();

		if (player != nullptr) {
			player->sendSystemMessage("@pet/pet_menu:pet_released"); // You release your pet back into the wild
		}
	}

	IntangibleObjectImplementation::destroyObjectFromWorld(sendSelfDestroy);
}

int PetControlDeviceImplementation::canBeDestroyed(CreatureObject* player) {
	ManagedReference<AiAgent*> controlledObject = cast<AiAgent*>(this->controlledObject.get().get());

	if (controlledObject != nullptr) {
		ManagedReference<PlayerObject*> ghost = player->getPlayerObject();
		if (ghost->hasActivePet(controlledObject))
			return 1;
	}

	return IntangibleObjectImplementation::canBeDestroyed(player);
}

bool PetControlDeviceImplementation::canBeTradedTo(CreatureObject* player, CreatureObject* receiver, int numberInTrade) {
	ManagedReference<SceneObject*> datapad = receiver->getSlottedObject("datapad");

	if (datapad == nullptr)
		return false;

	if (petType == PetManager::FACTIONPET) {
		player->sendSystemMessage("@pet/pet_menu:bad_type"); // You cannot trade a pet of that type. Transfer failed.
		return false;
	} else if (petType == PetManager::DROIDPET) {
		ManagedReference<PlayerManager*> playerManager = player->getZoneServer()->getPlayerManager();

		int droidsInDatapad = numberInTrade;
		int maxStoredDroids = playerManager->getBaseStoredDroids();

		for (int i = 0; i < datapad->getContainerObjectsSize(); i++) {
			Reference<SceneObject*> obj =  datapad->getContainerObject(i).castTo<SceneObject*>();

			if (obj != nullptr && obj->isPetControlDevice() ){
				Reference<PetControlDevice*> petDevice = cast<PetControlDevice*>(obj.get());
				if( petDevice != nullptr && petDevice->getPetType() == PetManager::DROIDPET){
					droidsInDatapad++;
				}
			}
		}

		if( droidsInDatapad >= maxStoredDroids){
			player->sendSystemMessage("That person has too many droids in their datapad");
			return false;
		}

		return true;

	} else if (petType == PetManager::CREATUREPET) {
		ManagedReference<TangibleObject*> controlledObject = this->controlledObject.get();

		if (controlledObject == nullptr || !controlledObject->isCreature())
			return false;

		ManagedReference<Creature*> pet = cast<Creature*>(controlledObject.get());

		ManagedReference<PlayerManager*> playerManager = player->getZoneServer()->getPlayerManager();

		int numberStored = numberInTrade;
		int maxStoredPets = playerManager->getBaseStoredCreaturePets();
		int maxLevelofPets = 10;
		int level = pet->getAdultLevel();
		bool ch = receiver->hasSkill("outdoors_creaturehandler_novice");

		if (ch) {
			maxStoredPets += receiver->getSkillMod("stored_pets");
			maxLevelofPets = receiver->getSkillMod("tame_level");
		}

		if (level > maxLevelofPets) {
			player->sendSystemMessage("@pet/pet_menu:no_chance"); // That person has no chance of controlling this creature. Transfer failed.
			receiver->sendSystemMessage("@pet/pet_menu:cannot_control"); // You have no chance of controlling that creature.
			return false;
		}

		if (pet->isVicious() && (receiver->getSkillMod("tame_aggro") <= 0 || !ch)) {
			player->sendSystemMessage("@pet/pet_menu:no_chance"); // That person has no chance of controlling this creature. Transfer failed.
			receiver->sendSystemMessage("@pet/pet_menu:cannot_control"); // You have no chance of controlling that creature.
			return false;
		}

		if (numberStored >= maxStoredPets) {
			player->sendSystemMessage("@pet/pet_menu:targ_too_many_stored"); // That person has too many stored pets. Transfer failed.
			receiver->sendSystemMessage("@pet/pet_menu:sys_too_many_stored"); // There are too many pets stored in this container. Release some of them to make room for more.
			return false;
		}

		for (int i = 0; i < datapad->getContainerObjectsSize(); ++i) {
			ManagedReference<SceneObject*> object = datapad->getContainerObject(i);

			if (object != nullptr && object->isPetControlDevice()) {
				PetControlDevice* device = cast<PetControlDevice*>( object.get());

				if (device->getPetType() == PetManager::CREATUREPET) {
					if (++numberStored >= maxStoredPets) {
						player->sendSystemMessage("@pet/pet_menu:targ_too_many_stored"); // That person has too many stored pets. Transfer failed.
						receiver->sendSystemMessage("@pet/pet_menu:sys_too_many_stored"); // There are too many pets stored in this container. Release some of them to make room for more.
						return false;
					}

				}
			}
		}

		return true;
	}

	return false;
}

void PetControlDeviceImplementation::fillAttributeList(AttributeListMessage* alm, CreatureObject* object) {
	SceneObjectImplementation::fillAttributeList(alm, object);

	if (petType == PetManager::FLIGHTCOMPUTER) {
		auto flightComputerDatapad = getDatapad();

 		if (flightComputerDatapad == nullptr) {
 			return;
 		}

 		int containerSize = flightComputerDatapad->getContainerObjectsSize();
 		int currentDataSize = 0;
 		Vector<String> storedCommands;

 		for (int i = 0; i < containerSize; i++) {
 			auto commandModule = flightComputerDatapad->getContainerObject(i).castTo<IntangibleObject*>();

 			if (commandModule == nullptr) {
 				continue;
 			}

 			currentDataSize += commandModule->getDataSize();
 			storedCommands.add(commandModule->getItemIdentifier());
 		}

 		// Used Memory
 		alm->insertAttribute("droid_program_expended_memory", currentDataSize);

 		// Loaded Droid Programs
 		int totalPrograms = storedCommands.size();

 		if (totalPrograms > 0) {
 			alm->insertAttribute("droid_program_loaded", "");

 			for (int i = 0; i < totalPrograms; i++) {
 				String programName = storedCommands.get(i);
 
 				alm->insertAttribute("droid_program", "@space/droid_commands:" + programName);
 			}
 		}

 		// Pilot's Required Cert
 		//alm->insertAttribute("data_module_cert_needed", getStorageRating());
	}

	if (petType == PetManager::DROIDPET) {
		alm->insertAttribute("creature_vitality", String::valueOf(vitality) + "/" + String::valueOf(maxVitality));

		ManagedReference<DroidObject*> droid = this->controlledObject.get().castTo<DroidObject*>();

		if (droid != nullptr) {
			alm->insertAttribute("challenge_level", droid->getLevel());
			alm->insertAttribute("creature_health", droid->getBaseHAM(0));
			alm->insertAttribute("creature_action", droid->getBaseHAM(3));
			alm->insertAttribute("creature_mind", droid->getBaseHAM(6));

			droid->fillAttributeList(alm, object);
		}
	} else {
		ManagedReference<AiAgent*> pet = cast<AiAgent*>(this->controlledObject.get().get());

		if (pet != nullptr) {
			int petLevel = pet->getLevel();

			if (pet->isCreature()) {
				auto petCreature = cast<Creature*>(pet.get());
				int adultLevel = 0;

				if (petCreature != nullptr) {
					adultLevel = petCreature->getAdultLevel();
				}

				StringBuffer levelMsg;

				levelMsg << petLevel << " (" << adultLevel << ")";

				alm->insertAttribute("challenge_level", levelMsg.toString());
			} else {
				alm->insertAttribute("challenge_level", petLevel);
			}

			if (petType == PetManager::CREATUREPET)
				alm->insertAttribute("creature_vitality", String::valueOf(vitality) + "/" + String::valueOf(maxVitality));

			alm->insertAttribute("creature_health", pet->getBaseHAM(0));
			alm->insertAttribute("creature_action", pet->getBaseHAM(3));
			alm->insertAttribute("creature_mind", pet->getBaseHAM(6));

			int armor = pet->getArmor();
			if (armor == 0)
				alm->insertAttribute("armor_rating", "None");
			else if (armor == 1)
				alm->insertAttribute("armor_rating", "Light");
			else if (armor == 2)
				alm->insertAttribute("armor_rating", "Medium");
			else if (armor == 3)
				alm->insertAttribute("armor_rating", "Heavy");

			if (pet->getKinetic() < 0)
				alm->insertAttribute("dna_comp_armor_kinetic", "Vulnerable");
			else
				alm->insertAttribute("dna_comp_armor_kinetic", pet->getKinetic());

			if (pet->getEnergy() < 0)
				alm->insertAttribute("dna_comp_armor_energy", "Vulnerable");
			else
				alm->insertAttribute("dna_comp_armor_energy", pet->getEnergy());

			if (pet->getBlast() < 0)
				alm->insertAttribute("dna_comp_armor_blast", "Vulnerable");
			else
				alm->insertAttribute("dna_comp_armor_blast", pet->getBlast());

			if (pet->getHeat() < 0)
				alm->insertAttribute("dna_comp_armor_heat", "Vulnerable");
			else
				alm->insertAttribute("dna_comp_armor_heat", pet->getHeat());

			if (pet->getCold() < 0)
				alm->insertAttribute("dna_comp_armor_cold", "Vulnerable");
			else
				alm->insertAttribute("dna_comp_armor_cold", pet->getCold());

			if (pet->getElectricity() < 0)
				alm->insertAttribute("dna_comp_armor_electric", "Vulnerable");
			else
				alm->insertAttribute("dna_comp_armor_electric", pet->getElectricity());

			if (pet->getAcid() < 0)
				alm->insertAttribute("dna_comp_armor_acid", "Vulnerable");
			else
				alm->insertAttribute("dna_comp_armor_acid", pet->getAcid());

			if (pet->getStun() < 0)
				alm->insertAttribute("dna_comp_armor_stun", "Vulnerable");
			else
				alm->insertAttribute("dna_comp_armor_stun", pet->getStun());

			if (pet->getLightSaber() < 0)
				alm->insertAttribute("dna_comp_armor_saber", "Vulnerable");
			else
				alm->insertAttribute("dna_comp_armor_saber", pet->getLightSaber());

			ManagedReference<WeaponObject*> weapon = pet->getWeapon();

			if (weapon != nullptr){
				StringBuffer displayValue;
				displayValue << Math::getPrecision(weapon->getAttackSpeed(), 2);
				alm->insertAttribute("creature_attack", displayValue);
			}

			StringBuffer displayValue;
			displayValue << Math::getPrecision(pet->getChanceHit(), 2);
			alm->insertAttribute("creature_tohit", displayValue);

			alm->insertAttribute("creature_damage", String::valueOf(pet->getDamageMin()) + " - " + String::valueOf(pet->getDamageMax()));

			if (petType == PetManager::CREATUREPET) {
				const CreatureAttackMap* attMap = pet->getPrimaryAttackMap();

				if (attMap != nullptr && attMap->size() > 0) {
					String cmd = attMap->getCommand(0);
					if (cmd.isEmpty()) {
						alm->insertAttribute("spec_atk_1", " ---");
					} else {
						String str = StringIdManager::instance()->getStringId(("@combat_effects:" + cmd).hashCode()).toString();
						alm->insertAttribute("spec_atk_1", str);
					}
				} else {
					alm->insertAttribute("spec_atk_1", " ---");
				}

				if (attMap != nullptr && attMap->size() > 1) {
					String cmd = attMap->getCommand(1);
					if (cmd.isEmpty()) {
						alm->insertAttribute("spec_atk_1", " ---");
					} else {
						String str = StringIdManager::instance()->getStringId(("@combat_effects:" + cmd).hashCode()).toString();
						alm->insertAttribute("spec_atk_2", str);
					}
				} else {
					alm->insertAttribute("spec_atk_2", " ---");
				}

				if (pet->hasRangedWeapon())
					alm->insertAttribute("dna_comp_ranged_attack", "Yes");
				else
					alm->insertAttribute("dna_comp_ranged_attack", "No");
			}

			if (pet->getDefaultWeapon() == nullptr) {
				StringBuffer msg;
				msg << "Your pet " << pet->getDisplayedName() << ", needs to be called in order to fix a missing weapon.";
				object->sendSystemMessage(msg.toString());
			}
		}
	}

	// Trained Commands
	if ( trainedCommands.size() > 0) {
		alm->insertAttribute("pet_command", "" );
	}

	if( trainedCommands.contains(PetManager::STAY) ){
		alm->insertAttribute("pet_command_1", trainedCommands.get(PetManager::STAY) );
	}

	if( trainedCommands.contains(PetManager::FOLLOW) ){
		alm->insertAttribute("pet_command_0", trainedCommands.get(PetManager::FOLLOW) );
	}

	if( trainedCommands.contains(PetManager::STORE) ){
		alm->insertAttribute("pet_command_11", trainedCommands.get(PetManager::STORE) );
	}

	if( trainedCommands.contains(PetManager::ATTACK) ){
		alm->insertAttribute("pet_command_4", trainedCommands.get(PetManager::ATTACK) );
	}

	if( trainedCommands.contains(PetManager::GUARD) ){
		alm->insertAttribute("pet_command_2", trainedCommands.get(PetManager::GUARD) );
	}

	if( trainedCommands.contains(PetManager::FRIEND) ){
		alm->insertAttribute("pet_command_3", trainedCommands.get(PetManager::FRIEND) );
	}

	if( trainedCommands.contains(PetManager::FOLLOWOTHER) ){
		alm->insertAttribute("pet_command_17", trainedCommands.get(PetManager::FOLLOWOTHER) );
	}

	if( trainedCommands.contains(PetManager::TRICK1) ){
		alm->insertAttribute("pet_command_12", trainedCommands.get(PetManager::TRICK1) );
	}

	if( trainedCommands.contains(PetManager::TRICK2) ){
		alm->insertAttribute("pet_command_13", trainedCommands.get(PetManager::TRICK2) );
	}

	if( trainedCommands.contains(PetManager::PATROL) ){
		alm->insertAttribute("pet_command_5", trainedCommands.get(PetManager::PATROL) );
	}

	if( trainedCommands.contains(PetManager::GETPATROLPOINT) ){
		alm->insertAttribute("pet_command_6", trainedCommands.get(PetManager::GETPATROLPOINT) );
	}

	if( trainedCommands.contains(PetManager::CLEARPATROLPOINTS) ){
		alm->insertAttribute("pet_command_7", trainedCommands.get(PetManager::CLEARPATROLPOINTS) );
	}

	if( trainedCommands.contains(PetManager::FORMATION1) ){
		alm->insertAttribute("pet_command_8", trainedCommands.get(PetManager::FORMATION1) );
	}

	if( trainedCommands.contains(PetManager::FORMATION2) ){
		alm->insertAttribute("pet_command_9", trainedCommands.get(PetManager::FORMATION2) );
	}

	if( trainedCommands.contains(PetManager::SPECIAL_ATTACK1) ){
		alm->insertAttribute("pet_command_18", trainedCommands.get(PetManager::SPECIAL_ATTACK1) );
	}

	if( trainedCommands.contains(PetManager::SPECIAL_ATTACK2) ){
		alm->insertAttribute("pet_command_19", trainedCommands.get(PetManager::SPECIAL_ATTACK2) );
	}

	if( trainedCommands.contains(PetManager::RANGED_ATTACK) ){
		alm->insertAttribute("pet_command_20", trainedCommands.get(PetManager::RANGED_ATTACK) );
	}

	if( trainedCommands.contains(PetManager::GROUP) ){
		alm->insertAttribute("pet_command_16", trainedCommands.get(PetManager::GROUP) );
	}

	if( trainedCommands.contains(PetManager::RECHARGEOTHER) ){
		alm->insertAttribute("@pet/pet_menu:menu_recharge_other", trainedCommands.get(PetManager::RECHARGEOTHER) );
	}

	if( trainedCommands.contains(PetManager::TRANSFER) ){
		alm->insertAttribute("pet_command_10", trainedCommands.get(PetManager::TRANSFER) );
	}

	if( trainedCommands.contains(PetManager::REPAIR) ){
		alm->insertAttribute("pet_command_13", trainedCommands.get(PetManager::REPAIR) ); // Droid Repair really was listed as Trick 2
	}
	if( trainedCommands.contains(PetManager::THROWTRAP) ){
		alm->insertAttribute("pet_command_22", trainedCommands.get(PetManager::THROWTRAP) );
	}
	if( trainedCommands.contains(PetManager::HARVEST) ){
		alm->insertAttribute("pet_command_21", trainedCommands.get(PetManager::HARVEST) );
	}
}

void PetControlDeviceImplementation::setDefaultCommands() {
	trainedCommands.put(PetManager::STAY, "stay");
	trainedCommands.put(PetManager::FOLLOW, "follow");
	trainedCommands.put(PetManager::STORE, "store");

	ManagedReference<DroidObject*> droid = this->controlledObject.get().castTo<DroidObject*>();

	if (droid != nullptr) {
		if (droid->isCombatDroid()) {
			trainedCommands.put(PetManager::ATTACK, "attack");
			trainedCommands.put(PetManager::GUARD, "guard");
		}

		if (droid->isBombDroid()) {
			trainedCommands.put(PetManager::FOLLOWOTHER, "chase");
		} else {
			trainedCommands.put(PetManager::FOLLOWOTHER, "followother");
		}
	} else {
		trainedCommands.put(PetManager::ATTACK, "attack");
		trainedCommands.put(PetManager::GUARD, "guard");
		trainedCommands.put(PetManager::FOLLOWOTHER, "followother");
	}

	trainedCommands.put(PetManager::FRIEND, "friend");
	trainedCommands.put(PetManager::PATROL, "patrol");
	trainedCommands.put(PetManager::GETPATROLPOINT, "getpatrolpoint");
	trainedCommands.put(PetManager::CLEARPATROLPOINTS, "clearpatrolpoints");
	trainedCommands.put(PetManager::FORMATION1, "formation1");
	trainedCommands.put(PetManager::FORMATION2, "formation2");

	if (droid != nullptr) {
		int species = droid->getSpecies();

		if (droid->isCombatDroid() && (species == DroidObject::PROBOT || species == DroidObject::DZ70))
			trainedCommands.put(PetManager::RANGED_ATTACK, "ranged attack");
	} else {
		trainedCommands.put(PetManager::RANGED_ATTACK, "ranged attack");
	}

	trainedCommands.put(PetManager::GROUP, "group");
}

void PetControlDeviceImplementation::setTrainingCommand(unsigned int commandID) {

	// we set to 0 to flag completion so skip all this then.
	if (commandID == 0) {
		trainingCommand = 0;
		return;
	}

	ManagedReference<TangibleObject*> controlledObject = this->controlledObject.get();
	if (controlledObject == nullptr || !controlledObject->isAiAgent())
		return;

	AiAgent* pet = cast<AiAgent*>(controlledObject.get());
	if (pet == nullptr)
		return;

	ManagedReference<CreatureObject*> owner = pet->getLinkedCreature().get();
	if (owner == nullptr || !owner->isPlayerCreature())
		return;

	if (petType == PetManager::DROIDPET) {
		ManagedReference<DroidObject*> droid = this->controlledObject.get().castTo<DroidObject*>();
		if (droid == nullptr)
			return;

		// Check power on droids
		if (!droid->hasPower()) {
			droid->showFlyText("npc_reaction/flytext","low_power", 204, 0, 0);  // "*Low Power*"
			return;
		}

		if (((commandID == PetManager::ATTACK || commandID == PetManager::GUARD) && !droid->isCombatDroid()) ||
			(commandID == PetManager::RANGED_ATTACK && (!droid->isCombatDroid() || !droid->hasRangedWeapon())) ||
			(commandID == PetManager::RECHARGEOTHER && !droid->isPowerDroid()) ||
			(commandID == PetManager::TRANSFER) ||
			(commandID == PetManager::SPECIAL_ATTACK1) ||
			(commandID == PetManager::SPECIAL_ATTACK2) ||
			(commandID == PetManager::TRICK1) ||
			(commandID == PetManager::TRICK2)){
			return;
		}
	}
	else if (petType == PetManager::CREATUREPET) {
		if (((commandID == PetManager::ATTACK || commandID == PetManager::FOLLOW || commandID == PetManager::STORE) && !owner->hasSkill("outdoors_creaturehandler_novice") ) ||
			(commandID == PetManager::STAY && !owner->hasSkill("outdoors_creaturehandler_training_01")) ||
			(commandID == PetManager::GUARD && !owner->hasSkill("outdoors_creaturehandler_training_02")) ||
			(commandID == PetManager::FRIEND && !owner->hasSkill("outdoors_creaturehandler_support_03")) ||
			((commandID == PetManager::PATROL || commandID == PetManager::GETPATROLPOINT || commandID == PetManager::CLEARPATROLPOINTS) && !owner->hasSkill("outdoors_creaturehandler_training_03")) ||
			((commandID == PetManager::FORMATION1 || commandID == PetManager::FORMATION2) && !owner->hasSkill("outdoors_creaturehandler_training_04")) ||
			(commandID == PetManager::TRANSFER && !owner->hasSkill("outdoors_creaturehandler_master")) ||
			(commandID == PetManager::TRICK1 && !owner->hasSkill("outdoors_creaturehandler_healing_01")) ||
			(commandID == PetManager::TRICK2 && !owner->hasSkill("outdoors_creaturehandler_healing_03")) ||
			(commandID == PetManager::GROUP && !owner->hasSkill("outdoors_creaturehandler_support_01")) ||
			(commandID == PetManager::SPECIAL_ATTACK1 && (!owner->hasSkill("outdoors_creaturehandler_taming_03") || !pet->hasSpecialAttack(1))) ||
			(commandID == PetManager::SPECIAL_ATTACK2 && (!owner->hasSkill("outdoors_creaturehandler_taming_04") || !pet->hasSpecialAttack(2))) ||
			(commandID == PetManager::RANGED_ATTACK && (!owner->hasSkill("outdoors_creaturehandler_master") || !pet->hasRangedWeapon())) ||
			(commandID == PetManager::FOLLOWOTHER && !owner->hasSkill("outdoors_creaturehandler_support_02")) ||
			(commandID == PetManager::RECHARGEOTHER))
				return;
	}
	else if (petType == PetManager::FACTIONPET) {
		if (commandID == PetManager::RECHARGEOTHER ||
			(commandID == PetManager::TRANSFER) ||
			(commandID == PetManager::SPECIAL_ATTACK1) ||
			(commandID == PetManager::SPECIAL_ATTACK2) ||
			(commandID == PetManager::TRICK1) ||
			(commandID == PetManager::TRICK2))
				return;
	}

	/** Check for converse and if so, get its personalityStf**/
	if (pet->getOptionsBitmask() & OptionBitmask::CONVERSE) {
		String stf = pet->getPersonalityStf();
		StringBuffer message;
		message << stf << ":start_convo_4";
		StringIdChatParameter chat;
		chat.setStringId(message.toString());
		pet->getZoneServer()->getChatManager()->broadcastChatMessage(pet, chat, 0, 0, 0);
	} else {
		pet->showFlyText("npc_reaction/flytext","alert", 204, 0, 0);  // "?"
	}

	trainingCommand = commandID;
}

void PetControlDeviceImplementation::trainAsMount(CreatureObject* player) {
	if (isTrainedAsMount() || !player->hasSkill("outdoors_creaturehandler_support_04"))
		return;

	PetManager* petManager = player->getZoneServer()->getPetManager();
	if (petManager == nullptr)
		return;

	if (petManager->checkMountEligibility(_this.getReferenceUnsafeStaticCast()) != PetManager::CANBEMOUNTTRAINED)
		return;

	ManagedReference<TangibleObject*> controlledObject = this->controlledObject.get();
	if (controlledObject == nullptr || !controlledObject->isAiAgent())
		return;

	AiAgent* pet = cast<AiAgent*>(controlledObject.get());
	if (pet == nullptr)
		return;

	assert(pet->isLockedByCurrentThread());

	trainedAsMount = true;
	pet->setOptionBit(0x1000);
}

void PetControlDeviceImplementation::resetNamingCommands() {
	if (namingCommands.isEmpty())
		return;

	namingCommands.removeAll();
}

void PetControlDeviceImplementation::addPatrolPoint(PatrolPoint& point) {
	patrolPoints.add(point);
}

PatrolPoint PetControlDeviceImplementation::getPatrolPoint(int idx) {
	return patrolPoints.get(idx);
}

bool PetControlDeviceImplementation::isValidPet(AiAgent* pet) {

	return true;
	// PetDeed* deed = pet->getPetDeed();

	// if (deed != nullptr) {
	// 	// time to calculate!
	// 	int calculatedLevel =  deed->calculatePetLevel();

	// 	if (pet->getTemplateLevel() >= (calculatedLevel * 0.85)) {
	// 		return true;
	// 	} else {
	// 		return false;
	// 	}
	// }

	// return true;
}

void PetControlDeviceImplementation::setVitality(int vit) {
	// Pets should not drop below 1 for their vitality
	if (vit < 1)
		vit = 1;

	vitality = vit;

	if (petType != PetManager::CREATUREPET && petType != PetManager::DROIDPET)
		return;

	ManagedReference<CreatureObject*> pet = this->controlledObject.get().castTo<CreatureObject*>();

	if (controlledObject == nullptr)
		return;

	float hamPenaltyModifier = 0;

	if (vitality <= 75 && vitality > 50) {
		hamPenaltyModifier = 0.25f;
	} else if (vitality <= 50 && vitality > 25) {
		hamPenaltyModifier = 0.5f;
	} else if (vitality <= 25) {
		hamPenaltyModifier = 0.75f;
	}

	Reference<PetControlDevice*> petControlDevice = _this.getReferenceUnsafeStaticCast();

	float vitalityMindPenalty = this->vitalityMindPenalty;
	float vitalityActionPenalty = this->vitalityActionPenalty;
	float vitalityHealthPenalty	= this->vitalityHealthPenalty;

	Core::getTaskManager()->executeTask([pet, petControlDevice, hamPenaltyModifier, vitalityMindPenalty, vitalityActionPenalty, vitalityHealthPenalty] () {
		Locker locker(pet);

		Locker clocker(petControlDevice, pet);

		int newVitalityHealthPenalty = pet->getBaseHAM(0) * hamPenaltyModifier;
		int newVitalityActionPenalty = pet->getBaseHAM(3) * hamPenaltyModifier;
		int newVitalityMindPenalty = pet->getBaseHAM(6) * hamPenaltyModifier;

		if (newVitalityHealthPenalty != vitalityHealthPenalty) {
			int change = vitalityHealthPenalty - newVitalityHealthPenalty;
			pet->setMaxHAM(0, pet->getMaxHAM(0) + change, true);
			petControlDevice->setVitalityHealthPenalty(newVitalityHealthPenalty);
		}

		if (newVitalityActionPenalty != vitalityActionPenalty) {
			int change = vitalityActionPenalty - newVitalityActionPenalty;
			pet->setMaxHAM(3, pet->getMaxHAM(3) + change, true);
			petControlDevice->setVitalityActionPenalty(newVitalityActionPenalty);
		}

		if (newVitalityMindPenalty != vitalityMindPenalty) {
			int change = vitalityMindPenalty - newVitalityMindPenalty;
			pet->setMaxHAM(6, pet->getMaxHAM(6) + change, true);
			petControlDevice->setVitalityMindPenalty(newVitalityMindPenalty);
		}
	}, "PetSetVitalityLambda");
}

int PetControlDeviceImplementation::getDataStorageCapacity() {
	SceneObject* datapadObject = getSlottedObject("datapad").castTo<SceneObject*>();
	if (datapadObject == nullptr)
		return 0;
	else
		return datapadObject->getContainerVolumeLimit();
}

String PetControlDeviceImplementation::getRequiredAstromechCert() {
	String requiredSkill = "cert_droid_astromech_";

	auto flightDatapad = getDatapad();

	if (flightDatapad == nullptr) {
		return requiredSkill + "1";
	}

	auto templateData = flightDatapad->getObjectTemplate();

	if (templateData == nullptr) {
		return requiredSkill + "1";
	}

	String entry = templateData->getTemplateFileName();
	return requiredSkill + entry.charAt(entry.length() - 1);
}
