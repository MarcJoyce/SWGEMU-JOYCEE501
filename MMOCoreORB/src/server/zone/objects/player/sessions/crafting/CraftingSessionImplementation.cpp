/*
 * CraftingSessionImplementation.cpp
 *
 *  Created on: Feb 19, 2012
 *      Author: Kyle
 */

#include "server/zone/objects/scene/variables/StringId.h"
#include "server/zone/objects/player/sessions/crafting/CraftingSession.h"
#include "server/zone/managers/player/PlayerManager.h"
#include "server/zone/objects/creature/CreatureObject.h"
#include "server/zone/objects/player/PlayerObject.h"
#include "server/zone/objects/tangible/tool/CraftingTool.h"
#include "server/zone/objects/tangible/weapon/WeaponObject.h"
#include "server/zone/managers/crafting/CraftingManager.h"
#include "server/zone/managers/crafting/ComponentMap.h"
#include "server/zone/objects/manufactureschematic/ingredientslots/ComponentSlot.h"
#include "server/zone/objects/tangible/tool/CraftingStation.h"

#include "server/zone/packets/tangible/TangibleObjectDeltaMessage3.h"
#include "server/zone/packets/player/PlayerObjectDeltaMessage9.h"
#include "server/zone/objects/manufactureschematic/ManufactureSchematic.h"
#include "server/zone/packets/manufactureschematic/ManufactureSchematicObjectDeltaMessage3.h"
#include "server/zone/packets/manufactureschematic/ManufactureSchematicObjectDeltaMessage7.h"

#include "server/zone/objects/player/sessions/crafting/events/CreateObjectTask.h"
#include "server/zone/objects/player/sessions/crafting/events/UpdateToolCountdownTask.h"

#include "templates/customization/AssetCustomizationManagerTemplate.h"
#include "templates/params/RangedIntCustomizationVariable.h"
#include "server/zone/objects/transaction/TransactionLog.h"

// #define DEBUG_CRAFTING_SESSION
// #define DEBUG_EXPERIMENTATION

int CraftingSessionImplementation::initializeSession(CraftingTool* tool, CraftingStation* station) {
	craftingTool = tool;
	craftingStation = station;

	ManagedReference<CreatureObject*> crafter = this->crafter.get();
	ManagedReference<CraftingTool*> craftingTool = this->craftingTool.get();

	crafter->addActiveSession(SessionFacadeType::CRAFTING, _this.getReferenceUnsafeStaticCast());
	craftingTool->addActiveSession(SessionFacadeType::CRAFTING, _this.getReferenceUnsafeStaticCast());

	craftingTool->setCountdownTimer(0, true);

	crafterGhost = crafter->getPlayerObject();

	craftingManager = crafter->getZoneServer()->getCraftingManager();

	experimentationPointsTotal = 0;
	experimentationPointsUsed = 0;

	return startSession();
}

bool CraftingSessionImplementation::validateSession() {
	auto invalidSession = [&]() -> bool {
		Logger::console.info(true) << "Invalid Session!";

		closeCraftingWindow(0, false);
		cancelSession();
		return false;
	};

	auto strongCrafter = crafter.get();

	if (strongCrafter == nullptr) {
		return invalidSession();
	}

	auto strongGhost = crafterGhost.get();

	if (strongGhost == nullptr) {
		StringIdChatParameter param("ui_craft", "err_no_owner"); // Internal server error: no owner for player.
		strongCrafter->sendSystemMessage(param);
		return invalidSession();
	}

	auto strongTool = craftingTool.get();

	if (strongTool == nullptr) {
		StringIdChatParameter param("ui_craft", "err_no_crafting_tool"); // Internal server error: no crafting tool found.
		strongCrafter->sendSystemMessage(param);
		return invalidSession();
	}

	auto strongStation = craftingStation.get();

	if (strongStation != nullptr) {
		auto droidParent = strongStation->getDroidParent().get();

		if (droidParent != nullptr) {
			if (!droidParent->isInRange(strongCrafter, 7.0f)) {
				StringIdChatParameter param("ui", "sui_out_of_range_prose"); // You have gone out of range of %TT, closing interface.
				param.setTT(droidParent->getObjectID());
				strongCrafter->sendSystemMessage(param);
				return invalidSession();
			}
		} else if (!strongStation->isInRange(strongCrafter, 7.0f)) {
			StringIdChatParameter param("ui", "sui_out_of_range_prose"); // You have gone out of range of %TT, closing interface.
			param.setTT(strongStation->getObjectID());
			strongCrafter->sendSystemMessage(param);
			return invalidSession();
		}
	}

	return true;
}

int CraftingSessionImplementation::startSession() {
	if (!validateSession()) {
		return 1;
	}

	// crafter and craftingTool locked already in initializeSession
	ManagedReference<CraftingTool*> craftingTool = this->craftingTool.get();
	ManagedReference<CreatureObject*> crafter = this->crafter.get();
	ManagedReference<PlayerObject*> crafterGhost = this->crafterGhost.get();
	ManagedReference<CraftingStation*> craftingStation = this->craftingStation.get();

	if (crafter == nullptr || craftingTool == nullptr || crafterGhost == nullptr) {
		cancelSession();
		return false;
	}

	/// Get current allowed complexity
	int complexityLevel = craftingTool->getComplexityLevel();

	if (craftingStation != nullptr)
		complexityLevel = craftingStation->getComplexityLevel();

	/// Get filtered schematic list based on tool type and complexity
	currentSchematicList.removeAll();

	currentSchematicList = crafterGhost->filterSchematicList(crafter, craftingTool->getToolTabs(), complexityLevel);

	/// DPlay9 ***********************************
	PlayerObjectDeltaMessage9* dplay9 = new PlayerObjectDeltaMessage9(crafterGhost);
	dplay9->setExperimentationEnabled(craftingStation != nullptr);
	dplay9->setCraftingState(1);

	if (craftingStation != nullptr)
		dplay9->setClosestCraftingStation(craftingStation->getObjectID());
	else
		dplay9->setClosestCraftingStation(0);

	dplay9->setExperimentationPoints(experimentationPointsTotal);
	dplay9->close();
	crafter->sendMessage(dplay9);
	// End dplay9***********************************

	/// Object Controller Message 102 - Schematic List
	ObjectControllerMessage* ocm = new ObjectControllerMessage(crafter->getObjectID(), 0x0B, 0x102);

	ocm->insertLong(craftingTool->getObjectID());

	if (craftingStation != nullptr)
		ocm->insertLong(craftingStation->getObjectID());
	else
		ocm->insertLong(0);

	ocm->insertInt(currentSchematicList.size());
	for (int i = 0; i < currentSchematicList.size(); ++i) {
		DraftSchematic* draftSchematic = currentSchematicList.get(i).get();

		ocm->insertInt(draftSchematic->getClientObjectCRC());
		ocm->insertInt(draftSchematic->getClientObjectCRC());
		ocm->insertInt(draftSchematic->getToolTab()); // this number decides what tab the schematic goes in (ex: 4 = food tab in crafting window)
	}
	crafter->sendMessage(ocm);
	/// ***********************************************

	/// Reset session state
	state = 1;

	if (crafterGhost != nullptr && crafterGhost->getDebug()) {
		crafter->sendSystemMessage("*** Starting new crafting session ***");
	}

	return true;
}

int CraftingSessionImplementation::cancelSession() {
	ManagedReference<CraftingTool*> craftingTool = this->craftingTool.get();
	ManagedReference<CreatureObject*> crafter = this->crafter.get();
	ManagedReference<PlayerObject*> crafterGhost = this->crafterGhost.get();

	if (craftingTool != nullptr)
		craftingTool->dropActiveSession(SessionFacadeType::CRAFTING);

	if (crafter != nullptr) {
		crafter->dropActiveSession(SessionFacadeType::CRAFTING);
		// DPlay9 *****************************
		PlayerObjectDeltaMessage9* dplay9 = new PlayerObjectDeltaMessage9(crafterGhost);
		dplay9->setCraftingState(0);
		dplay9->close();
		crafter->sendMessage(dplay9);
		// *************************************
	}

	if (crafterGhost != nullptr && crafterGhost->getDebug()) {
		crafter->sendSystemMessage("*** Canceling crafting session ***");
	}

	return clearSession();
}

int CraftingSessionImplementation::cancelSessionCommand() {
	closeCraftingWindow(0, false);
	return cancelSession();
}

int CraftingSessionImplementation::clearSession() {
	auto session = _this.getReferenceUnsafeStaticCast();

	Locker slocker(session);

	ManagedReference<CraftingTool*> craftingTool = this->craftingTool.get();
	ManagedReference<CreatureObject*> crafter = this->crafter.get();
	ManagedReference<PlayerObject*> crafterGhost = this->crafterGhost.get();
	ManagedReference<ManufactureSchematic*> manufactureSchematic = this->manufactureSchematic.get();
	ManagedReference<TangibleObject*> prototype = this->prototype.get();

	if (manufactureSchematic != nullptr) {
		Locker locker(manufactureSchematic);

		if (manufactureSchematic->getParent() == craftingTool) {
			manufactureSchematic->setDraftSchematic(nullptr);
			manufactureSchematic->cleanupIngredientSlots(crafter);
			manufactureSchematic->destroyObjectFromWorld(true);
		}

		this->manufactureSchematic = nullptr;
	}

	if (craftingTool != nullptr) {
		Locker locker2(craftingTool);

		// Remove all items that aren't the prototype
		for (int i = craftingTool->getContainerObjectsSize() - 1; i > 0; --i) {
			auto object = craftingTool->getContainerObject(i);

			if (object == nullptr)
				continue;

			Locker objLock(object, session);

			object->destroyObjectFromWorld(true);
		}

		Reference<SceneObject*> craftingComponents = craftingTool->getSlottedObject("crafted_components");

		craftingTool->dropSlottedObject("crafted_components");

		if (craftingComponents != nullptr) {
			craftingComponents->destroyObjectFromDatabase(true);
		}

		if (prototype != nullptr) {
			Locker locker3(prototype, session);

			if (craftingTool->isReady()) {
				if (prototype->getParent() == craftingTool) {
					prototype->destroyObjectFromWorld(true);
				}

				this->prototype = nullptr;
			}
		}
	}

	if (crafterGhost != nullptr && crafterGhost->getDebug()) {
		crafter->sendSystemMessage("*** Clearing crafting session ***");
	}

	return 0;
}

void CraftingSessionImplementation::closeCraftingWindow(int clientCounter, bool wasCraftSuccess) {
	ManagedReference<CreatureObject*> crafter = this->crafter.get();
	ManagedReference<PlayerObject*> crafterGhost = this->crafterGhost.get();
	ObjectControllerMessage* objMsg = nullptr;

	// These two packets deal with the hopper
	if (wasCraftSuccess) {
		objMsg = new ObjectControllerMessage(crafter->getObjectID(), 0x1B, 0x010C);
		objMsg->insertInt(0x10A);
		objMsg->insertInt(1);
		objMsg->insertByte(clientCounter);

		crafter->sendMessage(objMsg);

		objMsg = new ObjectControllerMessage(crafter->getObjectID(), 0x1B, 0x010C);
		objMsg->insertInt(0x10A);
		objMsg->insertInt(0);
		objMsg->insertByte(clientCounter);

		crafter->sendMessage(objMsg);
	}

	// The actual window close command
	objMsg = new ObjectControllerMessage(crafter->getObjectID(), 0x1B, 0x01C2);
	objMsg->insertByte(clientCounter);

	crafter->sendMessage(objMsg);

	if (crafterGhost != nullptr && crafterGhost->getDebug()) {
		crafter->sendSystemMessage("*** Closing crafting window ***");
	}
}

void CraftingSessionImplementation::sendSlotMessage(int counter, int message) {
	ManagedReference<CreatureObject*> crafter = this->crafter.get();

	// Object Controller ********************************************
	// Send Bad Slot message
	ObjectControllerMessage* objMsg = new ObjectControllerMessage(crafter->getObjectID(), 0x1B, 0x010C);
	objMsg->insertInt(0x107);
	objMsg->insertInt(message);
	objMsg->insertByte(counter);

	crafter->sendMessage(objMsg);
	// End Object Controller ******************************************
}

void CraftingSessionImplementation::selectDraftSchematic(int index) {
	if (!validateSession()) {
		return;
	}

	ManagedReference<CreatureObject*> crafter = this->crafter.get();
	ManagedReference<PlayerObject*> crafterGhost = this->crafterGhost.get();
	ManagedReference<CraftingTool*> craftingTool = this->craftingTool.get();

	if (index >= currentSchematicList.size()) {
		crafter->sendSystemMessage("Invalid Schematic Index");
		closeCraftingWindow(0, false);
		cancelSession();
		return;
	}

	DraftSchematic* draftschematic = currentSchematicList.get(index);

	if (draftschematic == nullptr) {
		crafter->sendSystemMessage("@ui_craft:err_no_draft_schematic");
		closeCraftingWindow(0, false);
		cancelSession();
		return;
	}

	clearSession();

	if (crafterGhost != nullptr && crafterGhost->getDebug()) {
		crafter->sendSystemMessage("Selected DraftSchematic: " + draftschematic->getCustomName());
	}

	state = 2;

	if (craftingTool != nullptr) {
		Locker locker(craftingTool);

		if (createSessionObjects(draftschematic)) {
			if (prototype == nullptr) {
				crafter->sendSystemMessage("@ui_craft:err_no_prototype");
				closeCraftingWindow(0, false);
				cancelSession();
				return;
			}

			// Dplay9 ********************************************************
			// Sets the Crafting state to 2, which is the Resource screen
			PlayerObjectDeltaMessage9* dplay9 = new PlayerObjectDeltaMessage9(crafter->getPlayerObject());
			dplay9->setExperimentationPoints(0xFFFFFFFF);
			dplay9->setCraftingState(2);
			dplay9->close();

			crafter->sendMessage(dplay9);
			// End Dplay9 *****************************************************

		} else {
			crafter->sendSystemMessage("This type of object has not yet been implemented");
		}
	} else {
		crafter->sendSystemMessage("@ui_craft:err_no_crafting_tool");
		closeCraftingWindow(0, false);
		cancelSession();
	}
}

bool CraftingSessionImplementation::createSessionObjects(DraftSchematic* draftSchematic) {
	if (createManufactureSchematic(draftSchematic))
		return createPrototypeObject(draftSchematic);
	else
		return false;
}

bool CraftingSessionImplementation::createManufactureSchematic(DraftSchematic* draftschematic) {
	ManagedReference<CreatureObject*> crafter = this->crafter.get();
	ManagedReference<PlayerObject*> crafterGhost = this->crafterGhost.get();
	ManagedReference<CraftingTool*> craftingTool = this->craftingTool.get();

	manufactureSchematic = (draftschematic->createManufactureSchematic(craftingTool)).castTo<ManufactureSchematic*>();

	auto schematic = manufactureSchematic.get();

	if (schematic == nullptr) {
		crafter->sendSystemMessage("@ui_craft:err_no_manf_schematic");
		closeCraftingWindow(0, false);
		cancelSession();
		return false;
	}

	TransactionLog trx(crafter, craftingTool, schematic, TrxCode::CRAFTINGSESSION);
	craftingTool->transferObject(schematic, 0x4, true);
	// manufactureSchematic->sendTo(crafter, true);

	if (crafterGhost != nullptr && crafterGhost->getDebug()) {
		crafter->sendSystemMessage("ManufactureSchematic Created");
	}

	return true;
}

bool CraftingSessionImplementation::createPrototypeObject(DraftSchematic* draftschematic) {
	if (!validateSession()) {
		return false;
	}

	ManagedReference<CreatureObject*> crafter = this->crafter.get();
	ManagedReference<PlayerObject*> crafterGhost = this->crafterGhost.get();
	ManagedReference<CraftingTool*> craftingTool = this->craftingTool.get();

	// Remove all items, incase there are any
	int toolSize = craftingTool->getContainerObjectsSize();

	for (int i = toolSize - 1; i >= 0; --i) {
		auto object = craftingTool->getContainerObject(i);

		if (object != nullptr) {
			Locker clock(object, craftingTool);
			object->destroyObjectFromWorld(true);
		}
	}

	if (crafter == nullptr) {
		return false;
	}

	auto zoneServer = crafter->getZoneServer();

	if (zoneServer == nullptr) {
		return false;
	}

	prototype = (zoneServer->createObject(draftschematic->getTanoCRC(), 0)).castTo<TangibleObject*>();

	ManagedReference<TangibleObject*> strongPrototype = prototype.get();

	if (strongPrototype == nullptr) {
		crafter->sendSystemMessage("@ui_craft:err_no_prototype");
		closeCraftingWindow(0, false);
		cancelSession();
		return false;
	}

	Locker locker(strongPrototype);

	strongPrototype->createChildObjects();

	TransactionLog trx(crafter, craftingTool, strongPrototype, TrxCode::CRAFTINGSESSION);
	craftingTool->transferObject(strongPrototype, -1, false);
	strongPrototype->sendTo(crafter, true);

	if (crafterGhost != nullptr && crafterGhost->getDebug()) {
		crafter->sendSystemMessage("Prototype Created");
	}

	return true;
}

void CraftingSessionImplementation::sendIngredientForUIListen() {
	if (!validateSession()) {
		return;
	}

	ManagedReference<CraftingTool*> craftingTool = this->craftingTool.get();
	ManagedReference<CreatureObject*> crafter = this->crafter.get();
	ManagedReference<PlayerObject*> crafterGhost = this->crafterGhost.get();
	ManagedReference<ManufactureSchematic*> manufactureSchematic = this->manufactureSchematic.get();
	ManagedReference<TangibleObject*> prototype = this->prototype.get();

	if (crafter == nullptr || craftingTool == nullptr || manufactureSchematic == nullptr || prototype == nullptr) {
		return;
	}

	uint8 allowFactory = 1;
	if (!manufactureSchematic->allowFactoryRun()) {
		allowFactory = 0;
	}

	// Object Controller w/ Ingredients ***************************
	ObjectControllerMessage* objMsg = new ObjectControllerMessage(crafter->getObjectID(), 0x1B, 0x0103);
	objMsg->insertLong(craftingTool->getObjectID());		 // Crafting Tool Object ID
	objMsg->insertLong(manufactureSchematic->getObjectID()); // Manufacture Schematic Object ID
	objMsg->insertLong(prototype->getObjectID());			 // Crafting Tangible Object ID
	objMsg->insertInt(2);
	objMsg->insertByte(allowFactory); // set to 1 to allow create manufact schematic, 0 to prevent it.

	ManagedReference<DraftSchematic*> draftSchematic = manufactureSchematic->getDraftSchematic();
	int draftSlotCount = draftSchematic->getDraftSlotCount();
	objMsg->insertInt(draftSlotCount);

	// Send all the ingredient data
	for (int i = 0; i < draftSlotCount; i++) {
		DraftSlot* slot = draftSchematic->getDraftSlot(i);

		if (slot != nullptr)
			slot->insertToMessage(objMsg);
	}

	objMsg->insertShort(0);

	crafter->sendMessage(objMsg);

	if (crafterGhost != nullptr && crafterGhost->getDebug()) {
		crafter->sendSystemMessage("Sent UI Listen");
	}
}

void CraftingSessionImplementation::addIngredient(TangibleObject* tano, int slot, int clientCounter) {
	if (!validateSession()) {
		return;
	}

	ManagedReference<CraftingTool*> craftingTool = this->craftingTool.get();
	ManagedReference<CreatureObject*> crafter = this->crafter.get();
	ManagedReference<PlayerObject*> crafterGhost = this->crafterGhost.get();
	ManagedReference<CraftingStation*> craftingStation = this->craftingStation.get();
	ManagedReference<ManufactureSchematic*> manufactureSchematic = this->manufactureSchematic.get();
	ManagedReference<TangibleObject*> prototype = this->prototype.get();

	if (crafter == nullptr || craftingTool == nullptr) {
		sendSlotMessage(clientCounter, IngredientSlot::INVALID);
		return;
	}

	if (manufactureSchematic == nullptr) {
		sendSlotMessage(clientCounter, IngredientSlot::NOSCHEMATIC);
		return;
	}

	if (prototype == nullptr) {
		sendSlotMessage(clientCounter, IngredientSlot::PROTOTYPENOTFOUND);
		return;
	}

	if (tano == nullptr || tano->getObjectID() == craftingTool->getObjectID()) {
		sendSlotMessage(clientCounter, IngredientSlot::INVALIDINGREDIENT);
		return;
	}

	if (tano->isCraftingTool()) {
		auto craftingTool = dynamic_cast<CraftingTool*>(tano);

		if (craftingTool == nullptr || !craftingTool->isReady()) {
			sendSlotMessage(clientCounter, IngredientSlot::INVALIDINGREDIENT);
			return;
		}
	}

	auto inventory = crafter->getInventory();

	if (inventory == nullptr) {
		sendSlotMessage(clientCounter, IngredientSlot::NOINVENTORY);
		return;
	}

	Locker locker(tano);

	if (tano->getRootParent() == nullptr) {
		sendSlotMessage(clientCounter, IngredientSlot::INVALIDINGREDIENT);
		return;
	}

	/// Check if item is on the player, but not in a crafting tool
	/// Or if the item is in a crafting station to prevent some duping
	if (!tano->isASubChildOf(crafter) && (craftingStation == nullptr || !tano->isASubChildOf(craftingStation))) {
		sendSlotMessage(clientCounter, IngredientSlot::INVALIDINGREDIENT);
		return;
	}

	ManagedReference<SceneObject*> objectsParent = tano->getParent().get();

	if (objectsParent == nullptr || !objectsParent->checkContainerPermission(crafter, ContainerPermissions::MOVEOUT)) {
		sendSlotMessage(clientCounter, IngredientSlot::INVALIDINGREDIENT);
		return;
	}

	ManagedReference<SceneObject*> craftingComponentsSatchel = craftingTool->getCraftedComponentsSatchel();

	// Lock the craft and satchel as well
	// Locker crossSatcheLock(craftingComponentsSatchel,crafter);
	// crafter is pre-locked before entering this method, satchel::trasnferObject is thread safe

	Locker mlocker(manufactureSchematic);

	int result = manufactureSchematic->addIngredientToSlot(crafter, craftingComponentsSatchel, tano, slot);

	sendSlotMessage(clientCounter, result);

	if (crafterGhost != nullptr && crafterGhost->getDebug()) {
		crafter->sendSystemMessage("Adding ingredient: " + tano->getDisplayedName());
	}
}

void CraftingSessionImplementation::removeIngredient(TangibleObject* tano, int slotUpdated, int clientCounter) {
	if (!validateSession()) {
		return;
	}

	ManagedReference<CreatureObject*> crafter = this->crafter.get();
	ManagedReference<PlayerObject*> crafterGhost = this->crafterGhost.get();
	ManagedReference<ManufactureSchematic*> manufactureSchematic = this->manufactureSchematic.get();
	ManagedReference<TangibleObject*> prototype = this->prototype.get();

	if (crafter == nullptr) {
		sendSlotMessage(clientCounter, IngredientSlot::INVALID);
		return;
	}

	if (manufactureSchematic == nullptr) {
		sendSlotMessage(clientCounter, IngredientSlot::NOSCHEMATIC);
		return;
	}

	if (prototype == nullptr) {
		sendSlotMessage(clientCounter, IngredientSlot::PROTOTYPENOTFOUND);
		return;
	}

	if (tano == nullptr) {
		sendSlotMessage(clientCounter, IngredientSlot::INVALIDINGREDIENT);
		return;
	}

	SceneObject* inventory = crafter->getSlottedObject("inventory");
	if (inventory == nullptr) {
		sendSlotMessage(clientCounter, IngredientSlot::NOINVENTORY);
		return;
	}

	Locker locker(tano);
	Locker mlocker(manufactureSchematic);

	int result = manufactureSchematic->removeIngredientFromSlot(crafter, tano, slotUpdated);

	if (result == IngredientSlot::OK) {
		// Object Controller ********************************************
		// Updates the screen with the resource removal
		ObjectControllerMessage* objMsg = new ObjectControllerMessage(crafter->getObjectID(), 0x1B, 0x010C);
		objMsg->insertInt(0x108);
		objMsg->insertInt(0);
		objMsg->insertByte(clientCounter);

		crafter->sendMessage(objMsg);
		// End Object Controller *****************************************
	}

	if (crafterGhost != nullptr && crafterGhost->getDebug()) {
		crafter->sendSystemMessage("Removing ingredient: " + tano->getDisplayedName());
	}
}

void CraftingSessionImplementation::nextCraftingStage(int clientCounter) {
	if (!validateSession()) {
		return;
	}

	// info(true) << "CraftingSessionImplementation::nextCraftingStage -- Client Counter: " << clientCounter << " State: " << state;

	ManagedReference<CraftingTool*> craftingTool = this->craftingTool.get();
	ManagedReference<ManufactureSchematic*> manufactureSchematic = this->manufactureSchematic.get();
	ManagedReference<TangibleObject*> prototype = this->prototype.get();

	if (manufactureSchematic == nullptr) {
		sendSlotMessage(clientCounter, IngredientSlot::NOSCHEMATIC);
		return;
	}

	if (!checkPrototype()) {
		sendSlotMessage(clientCounter, IngredientSlot::PROTOTYPENOTFOUND);
		return;
	}

	// Make sure all the require resources are there, if not, return them to inventory and close tool
	if (!manufactureSchematic->isAssembled() && !manufactureSchematic->isReadyForAssembly()) {
		sendSlotMessage(clientCounter, IngredientSlot::PARTIALASSEMBLE);
		return;
	}

	Locker locker(manufactureSchematic);

	ManagedReference<SceneObject*> craftingComponents = craftingTool->getSlottedObject("crafted_components");

	if (craftingComponents != nullptr) {
		/// Add Components to crafted object
		prototype->transferObject(craftingComponents, 4, false);
		craftingComponents->setSendToClient(false);
	}

	manufactureSchematic->setAssembled();

	if (state == 2) {
		initialAssembly(clientCounter);

	} else if (state == 3) {
		finishAssembly(clientCounter);

	} else if (state == 4) {
		finishStage1(clientCounter);
		finishStage2(clientCounter);
		state = 6;

	} else if (state == 5) {
		finishStage1(clientCounter);

	} else if (state == 6) {
		finishStage2(clientCounter);
	}
}

void CraftingSessionImplementation::initialAssembly(int clientCounter) {
#ifdef DEBUG_CRAFTING_SESSION
	info(true) << "========== CraftingSessionImplementation::initialAssembly ===========";
	info(true) << "Client Counter: " << clientCounter;
#endif

	ManagedReference<CraftingTool*> craftingTool = this->craftingTool.get();
	ManagedReference<CreatureObject*> crafter = this->crafter.get();
	ManagedReference<PlayerObject*> crafterGhost = this->crafterGhost.get();
	ManagedReference<CraftingStation*> craftingStation = this->craftingStation.get();
	ManagedReference<ManufactureSchematic*> manufactureSchematic = this->manufactureSchematic.get();
	ManagedReference<TangibleObject*> prototype = this->prototype.get();
	ManagedReference<CraftingManager*> craftingManager = this->craftingManager.get();
	// Get the appropriate number of Experimentation points from Skill
	ManagedReference<DraftSchematic*> draftSchematic = manufactureSchematic->getDraftSchematic();

	// Set crafter
	manufactureSchematic->setCrafter(crafter);

	String expskill = draftSchematic->getExperimentationSkill();
	experimentationPointsTotal = int(crafter->getSkillMod(expskill) / 10);
	experimentationPointsUsed = 0;

	// Calculate exp failure for red bars
	int experimentalFailureRate = craftingManager->calculateExperimentationFailureRate(crafter, manufactureSchematic, 0);

	// Get the level of customization
	String custskill = draftSchematic->getCustomizationSkill();
	int custpoints = int(crafter->getSkillMod(custskill));

	// Determine the outcome of the craft, Amazing through Critical
	assemblyResult = craftingManager->calculateAssemblySuccess(crafter, draftSchematic, craftingTool->getEffectiveness());

	if (assemblyResult != CraftingManager::AMAZINGSUCCESS && craftingTool->getForceCriticalAssembly() > 0) {
		assemblyResult = CraftingManager::AMAZINGSUCCESS;
		craftingTool->setForceCriticalAssembly(craftingTool->getForceCriticalAssembly() - 1);
	}

	Locker locker(prototype);

	// Set initial crafting percentages
	craftingManager->setInitialCraftingValues(prototype, manufactureSchematic, assemblyResult);
	// prototype->setInitialCraftingValues(manufactureSchematic, assemblyResult);

	Reference<CraftingValues*> craftingValues = manufactureSchematic->getCraftingValues();
	craftingValues->setManufactureSchematic(manufactureSchematic);
	craftingValues->setPlayer(crafter);

	if (prototype->isWeaponObject()) {
		unsigned int type = prototype->getClientGameObjectType();

		if (type == SceneObjectType::PISTOL || type == SceneObjectType::CARBINE || type == SceneObjectType::RIFLE) {
			uint32 tanoCRC = prototype->getClientObjectCRC();

			for (int i = 0; i < manufactureSchematic->getSlotCount(); ++i) {
				ComponentSlot* compSlot = cast<ComponentSlot*>(manufactureSchematic->getSlot(i));

				if (compSlot == nullptr) {
					continue;
				}

				ManagedReference<TangibleObject*> compTano = compSlot->getPrototype();

				if (compTano == nullptr) {
					continue;
				}

				const String& slotName = compSlot->getSlotName();

				if (slotName.isEmpty()) {
					continue;
				}

				const auto& ids = ComponentMap::instance()->getVisibleCRC(tanoCRC, slotName.hashCode());

				if (ids.size() == 0) {
					continue;
				}

				uint32 compCrc = compTano->getClientObjectCRC();

				for (int ii = 0; ii < ids.size(); ++ii) {
					uint32 key = ids.elementAt(ii).getKey();
					uint32 val = ids.elementAt(ii).getValue();

					if (key == 0 || val == 0) {
						continue;
					}

					if (slotName == "stock" || compCrc == key) {
						prototype->addVisibleComponent(val, false);
						break;
					}
				}
			}
		}
	}

	if (prototype->getVisibleComponents() != nullptr && prototype->getVisibleComponents()->size() > 0) {
		prototype->sendDestroyTo(crafter);
		prototype->sendTo(crafter, true);
	}

	// Flag to get the experimenting window
	if (craftingStation != nullptr && (craftingValues->getTotalVisibleAttributeGroups() > 0 || manufactureSchematic->allowFactoryRun()))
		// Assemble with Experimenting
		state = 3;
	else
		// Assemble without Experimenting
		state = 4;

	// info(true) << "State = " << state << " Total Experimentation Points = " << experimentationPointsTotal;

	// Start DPLAY9 ***********************************************************
	// Updates the stage of crafting, sets the number of experimentation points
	PlayerObjectDeltaMessage9* dplay9 = new PlayerObjectDeltaMessage9(crafter->getPlayerObject());
	dplay9->setCraftingState(state); // 3 If Experimenting is active, 4 if already experimented/ No experimenting
	dplay9->setExperimentationPoints(experimentationPointsTotal);
	dplay9->close();

	crafter->sendMessage(dplay9);
	// End DPLAY9 *************************************************************

	// Set Crafter name and generate serial number
	String name = crafter->getFirstName();
	prototype->setCraftersName(name);
	prototype->setCraftersID(crafter->getObjectID());

	String serial = craftingManager->generateSerial();
	prototype->setSerialNumber(serial);

	// Update the prototype with new values
	prototype->updateCraftingValues(craftingValues, true);

	addSkillMods();

	addWeaponDots();

	// Set default customization
	SharedTangibleObjectTemplate* templateData = cast<SharedTangibleObjectTemplate*>(prototype->getObjectTemplate());

	if (templateData == nullptr) {
		error("No template for: " + String::valueOf(prototype->getServerObjectCRC()));
		return;
	}

	VectorMap<String, Reference<CustomizationVariable*> > colorVariables;
	AssetCustomizationManagerTemplate::instance()->getCustomizationVariables(templateData->getAppearanceFilename().hashCode(), colorVariables, true);

	for (int i = 0; i < colorVariables.size(); ++i) {
		String varKey = colorVariables.elementAt(i).getKey();

		if (prototype->isDroidDeedObject() && varKey == "/private/index_color_0")
			continue;

		const Reference<RangedIntCustomizationVariable*> var = cast<RangedIntCustomizationVariable*>(colorVariables.get(i).get());

		if (var != nullptr) {
			prototype->setCustomizationVariable(varKey, var->getDefaultValue());

			variables.put(varKey, var.get());
		}
	}

	prototype->setComplexity(manufactureSchematic->getComplexity());

	// Start DMSCO3 ***********************************************************
	// Sends the updated values to the crafting screen
	ManufactureSchematicObjectDeltaMessage3* dMsco3 = new ManufactureSchematicObjectDeltaMessage3(manufactureSchematic);
	dMsco3->updateCraftingValues(manufactureSchematic);
	dMsco3->updateComplexity(manufactureSchematic->getComplexity());

	dMsco3->close();

	crafter->sendMessage(dMsco3);
	// End DMSCO3 *************************************************************

	// Start DMSCO7 ***********************************************************
	// Sends the experimental properties and experimental percentages
	ManufactureSchematicObjectDeltaMessage7* dMsco7 = new ManufactureSchematicObjectDeltaMessage7(manufactureSchematic);

	dMsco7->updateForAssembly(manufactureSchematic, experimentalFailureRate);

	if (custpoints > 0)
		dMsco7->updateCustomizationOptions(&variables, custpoints);

	dMsco7->close();

	crafter->sendMessage(dMsco7);
	// End DMSCO7 *************************************************************

	// Start DTANO3 ***********************************************************
	// Updates the Complexity and the condition
	TangibleObjectDeltaMessage3* dtano3 = new TangibleObjectDeltaMessage3(prototype);
	dtano3->updateComplexity();
	dtano3->updateMaxCondition();
	dtano3->close();

	crafter->sendMessage(dtano3);
	// End DTANO3 *************************************************************

	// Start Object Controller *******************************************
	// Send the results
	ObjectControllerMessage* objMsg = new ObjectControllerMessage(crafter->getObjectID(), 0x1B, 0x01BE);
	objMsg->insertInt(0x109);

	objMsg->insertInt(assemblyResult); // Assembly Results

	objMsg->insertByte(clientCounter);

	crafter->sendMessage(objMsg);
	// End Object Controller ******************************************

	crafter->notifyObservers(ObserverEventType::CRAFTINGASSEMBLY, crafter, 0);

	// Remove all resources - Not recovering them
	if (assemblyResult == CraftingManager::CRITICALFAILURE) {
		createPrototypeObject(draftSchematic);

		state = 2;

		// re-setup the slots and ingredients
		manufactureSchematic->synchronizedUIListen(crafter, 0);

		// Start Dplay9 **************************************
		// Reset crafting state
		PlayerObjectDeltaMessage9* dplay9 = new PlayerObjectDeltaMessage9(crafter->getPlayerObject());
		dplay9->setExperimentationPoints(0xFFFFFFFF);
		dplay9->setCraftingState(state);

		dplay9->close();

		crafter->sendMessage(dplay9);
		// End DPLAY9 ****************************************

	} else {
		crafterGhost->decreaseSchematicUseCount(draftSchematic);
	}

	if (crafterGhost != nullptr && crafterGhost->getDebug()) {
		crafter->sendSystemMessage(craftingValues->toString());
	}

#ifdef DEBUG_CRAFTING_SESSION
	info(true) << "========== END CraftingSessionImplementation::initialAssembly ===========";
#endif
}

void CraftingSessionImplementation::finishAssembly(int clientCounter) {
	ManagedReference<CreatureObject*> crafter = this->crafter.get();

	// Start Dplay9 **************************************
	// Move crafting to State 4
	PlayerObjectDeltaMessage9* dplay9 = new PlayerObjectDeltaMessage9(crafter->getPlayerObject());
	dplay9->setCraftingState(4);
	state = 4;
	dplay9->close();

	crafter->sendMessage(dplay9);
	// End DPLAY9

	// Start Object Controller **************************************
	ObjectControllerMessage* objMsg = new ObjectControllerMessage(crafter->getObjectID(), 0x1B, 0x01BE);
	objMsg->insertInt(0x109);
	objMsg->insertInt(4);

	objMsg->insertByte(clientCounter);

	crafter->sendMessage(objMsg);
	// End Object Controller **************************************
}


void CraftingSessionImplementation::experiment(int rowsAttempted, const String& expAttempt, int clientCounter) {
	// Player and session are pre-locked coming in

	// Checks to ensure all the variables are no null or ends the session
	if (!validateSession()) {
		return;
	}

#ifdef DEBUG_EXPERIMENTATION
	info(true) << "\n\nCraftingSessionImplementation::experiment - Total Experimental Points: " << experimentationPointsTotal << " Total Points Used: " << experimentationPointsUsed;
	info(true) << "Rows Attempted: " << rowsAttempted << " Experimental Group: " << expAttempt << " Client Counter: " << clientCounter;
#endif // DEBUG_EXPERIMENTATION

	ManagedReference<CraftingTool*> craftingTool = this->craftingTool.get();
	ManagedReference<CreatureObject*> crafter = this->crafter.get();
	ManagedReference<PlayerObject*> crafterGhost = this->crafterGhost.get();
	ManagedReference<ManufactureSchematic*> manufactureSchematic = this->manufactureSchematic.get();
	ManagedReference<TangibleObject*> prototype = this->prototype.get();
	ManagedReference<CraftingManager*> craftingManager = this->craftingManager.get();

	if (manufactureSchematic == nullptr) {
		sendSlotMessage(0, IngredientSlot::NOSCHEMATIC);
		return;
	}

	if (!checkPrototype()) {
		sendSlotMessage(0, IngredientSlot::PROTOTYPENOTFOUND);
		return;
	}

	// Lock the manufacturing schematic
	Locker schematicClock(manufactureSchematic, crafter);

	StringTokenizer tokenizer(expAttempt);

	int rowEffected, pointsAttempted, failure;
	int lowestExpSuccess = 0;

	Reference<CraftingValues*> craftingValues = manufactureSchematic->getCraftingValues();
	craftingValues->clear();

	int numberOfRows = craftingValues->getTotalVisibleAttributeGroups();

	if (rowsAttempted > numberOfRows || rowsAttempted < 1) {
		error() << "Crafter attempted to experiment on an invalid number of rows - Crafter: " << crafter->getDisplayedName() << " ID: " << crafter->getObjectID() << " Rows Attempted: " << rowsAttempted;

		cancelSession();
		return;
	}

	// Lock the prototype
	Locker prototypeClock(prototype, crafter);

	// Loop through all the lines of experimentation
	for (int i = 0; i < rowsAttempted; ++i) {
		rowEffected = tokenizer.getIntToken();
		pointsAttempted = tokenizer.getIntToken();

		// Get the amount of points experimentation points the player has remaining
		int totalRemainingPoints = (experimentationPointsTotal - experimentationPointsUsed);

#ifdef DEBUG_EXPERIMENTATION
		info(true) << "Points attempted for Row #" << i << " Points to use: " << pointsAttempted << " Current Remaining Experimentation Points: " << totalRemainingPoints;
#endif // DEBUG_EXPERIMENTATION

		// Player is out of points, break the loop or experimentation was attempted twice in succession
		if (totalRemainingPoints <= 0 || pointsAttempted > totalRemainingPoints) {
			error() << "Crafter Attempted to use too many Experimentation Points - Crafter: " << crafter->getDisplayedName() << " ID: " << crafter->getObjectID() <<
				" Prototype: " << prototype->getDisplayedName() << " ID: " << prototype->getObjectID();
			break;
		}

		// Check for odd values for points attempted or the row. Also make sure the row affected is within range of possible number of rows
		if (pointsAttempted < 1 || rowEffected < 0 || rowEffected > (numberOfRows - 1)) {
			error() << "Invalid points or row value during experimentation - Crafter: " << crafter->getDisplayedName() << " ID: " << crafter->getObjectID() <<
				" Prototype: " << prototype->getDisplayedName() << " ID: " << prototype->getObjectID();

			cancelSession();
			return;
		}

		experimentationPointsUsed += pointsAttempted;

		// Each line gets it's own rolls
		// Calcualte a new failure rate for each line of experimentation
		failure = craftingManager->calculateExperimentationFailureRate(crafter, manufactureSchematic, pointsAttempted);

		if (experimentationPointsUsed <= experimentationPointsTotal) {
			// Set the experimentation result ie:  Amazing Success
			experimentationResult = craftingManager->calculateExperimentationSuccess(crafter, manufactureSchematic->getDraftSchematic(), failure);

			if (experimentationResult != CraftingManager::AMAZINGSUCCESS && craftingTool->getForceCriticalExperiment() > 0) {
				// We are going to mutute the tool, lock it
				Locker toolLock(craftingTool, crafter);

				experimentationResult = CraftingManager::AMAZINGSUCCESS;
				craftingTool->setForceCriticalExperiment(craftingTool->getForceCriticalExperiment() - 1);
			}
		} else {
			// If this code is reached, they have likely tried to hack to
			// get more experimenting points, so lets just give them a failure
			experimentationResult = CraftingManager::CRITICALFAILURE;
			// we jsut cancel it so they cant overflow it
			cancelSession();
			return;
		}

		// Make sure to store the lowest roll to display (Effect the multiline rolls)
		if (lowestExpSuccess < experimentationResult) {
			lowestExpSuccess = experimentationResult;
		}

		manufactureSchematic->increaseComplexity();
		prototype->setComplexity(manufactureSchematic->getComplexity());

		// Do the experimenting - sets new percentages
		craftingManager->experimentRow(manufactureSchematic, craftingValues, rowEffected, pointsAttempted, failure, experimentationResult);

#ifdef DEBUG_EXPERIMENTATION
		info(true) << "Successful Experimentation for Row #" << i << " Using " << pointsAttempted << " points. NEW Remaining Experimentation Points: " << (experimentationPointsTotal - experimentationPointsUsed);
#endif // DEBUG_EXPERIMENTATION
	}

	manufactureSchematic->setExperimentingCounter(manufactureSchematic->getExperimentingCounter() + rowsAttempted);

	// Use percentages to recalculate the values
	craftingValues->recalculateValues(false);

	// Update the Tano with new values
	prototype->updateCraftingValues(manufactureSchematic->getCraftingValues(), false);

	// Release the lock on the prototype
	prototypeClock.release();

	// Sets the result for display
	experimentationResult = lowestExpSuccess;

	/*

		Send Packets for experimentation updates

	*/

	// Player Object Delta Message 9
	PlayerObjectDeltaMessage9* dplay9 = new PlayerObjectDeltaMessage9(crafter->getPlayerObject());
	dplay9->setExperimentationPoints(experimentationPointsTotal - experimentationPointsUsed);
	dplay9->close();

	crafter->sendMessage(dplay9);

	// Manufacturing Schematic Delta Message 3
	ManufactureSchematicObjectDeltaMessage3* dMsco3 = new ManufactureSchematicObjectDeltaMessage3(manufactureSchematic);
	dMsco3->updateComplexity(manufactureSchematic->getComplexity());
	dMsco3->updateCraftingValues(manufactureSchematic);
	dMsco3->close();

	crafter->sendMessage(dMsco3);

	// Manufacturing Schematic Delta Message 7
	ManufactureSchematicObjectDeltaMessage7* dMsco7 = new ManufactureSchematicObjectDeltaMessage7(manufactureSchematic);
	dMsco7->update9(manufactureSchematic, false);
	dMsco7->close();

	crafter->sendMessage(dMsco7);

	// Tangible Object Delta Message 3
	TangibleObjectDeltaMessage3* dtano3 = new TangibleObjectDeltaMessage3(prototype);
	dtano3->updateComplexity();
	dtano3->close();

	crafter->sendMessage(dtano3);

	// Object Controller Message
	ObjectControllerMessage* objMsg = new ObjectControllerMessage(crafter->getObjectID(), 0x1B, 0x0113);
	objMsg->insertInt(0x105);

	objMsg->insertInt(experimentationResult); // Experimentation Result
	objMsg->insertByte(clientCounter);

	crafter->sendMessage(objMsg);

	/*

		END Packets for experimentation updates

	*/

	// Notify experimentation oberservers
	crafter->notifyObservers(ObserverEventType::CRAFTINGEXPERIMENTATION, crafter, 0);

	if (crafterGhost != nullptr && crafterGhost->getDebug()) {
		crafter->sendSystemMessage(craftingValues->toString());
	}

#ifdef DEBUG_EXPERIMENTATION
	info(true) << "END Experimentation Session\n\n";
#endif // DEBUG_EXPERIMENTATION
}

void CraftingSessionImplementation::customization(const String& name, byte templateChoice, int schematicCount, const String& customizationString) {
	if (!validateSession()) {
		return;
	}

	ManagedReference<CraftingTool*> craftingTool = this->craftingTool.get();
	ManagedReference<CreatureObject*> crafter = this->crafter.get();
	ManagedReference<ManufactureSchematic*> manufactureSchematic = this->manufactureSchematic.get();
	ManagedReference<TangibleObject*> prototype = this->prototype.get();

	if (manufactureSchematic == nullptr) {
		sendSlotMessage(0, IngredientSlot::NOSCHEMATIC);
		return;
	}

	if (!checkPrototype()) {
		sendSlotMessage(0, IngredientSlot::PROTOTYPENOTFOUND);
		return;
	}

	// if (NameManager::instance()->isProfane(name)) {
	//	player->sendSystemMessage("Your selected name has been declined because it may contain inappropriate language.  Close the 'customizing' window and try again");
	//	return;
	//}

	Locker locker(craftingTool);
	Locker locker2(manufactureSchematic);
	Locker locker3(prototype);

	StringId protoNameID = *prototype->getObjectName();

	if (templateChoice != 0xFF) {
		Reference<DraftSchematic*> draftSchematic = manufactureSchematic->getDraftSchematic();

		if (draftSchematic != nullptr && draftSchematic->getTemplateListSize() >= (int)templateChoice) {
			String clientTemplate = draftSchematic->getTemplate((int)templateChoice);
			String serverTemplate = clientTemplate.replaceAll("shared_", "");

			SharedObjectTemplate* shot = TemplateManager::instance()->getTemplate(serverTemplate.hashCode());

			if (shot != nullptr) {
				prototype->loadTemplateData(shot);
				prototype->setObjectName(protoNameID, false);
				prototype->updateCraftingValues(manufactureSchematic->getCraftingValues(), false);

				if (!prototype->getSerialNumber().isEmpty()) {
					prototype->setOptionBit(OptionBitmask::HASSERIAL, false);
				}

				prototype->sendDestroyTo(crafter);
				prototype->sendTo(crafter, true);
			}
		}
	}

	String clientName = name;

	while (clientName.contains("\\#")) {
		int index = clientName.indexOf("\\#");
		String sub = "\\" + clientName.subString(index, index + 2);

		clientName = clientName.replaceFirst(sub, "");
	}

	if (clientName.isEmpty()) {
		clientName = prototype->getDisplayedName();
	}

	UnicodeString customName = clientName;

	prototype->setCustomObjectName(customName, false);

	if (schematicCount < 0 || schematicCount > 1000) {
		schematicCount = 1000;
	}

	manufactureSchematic->setManufactureLimit(schematicCount);
	manufactureSchematic->setObjectName(protoNameID, false);
	manufactureSchematic->setCustomObjectName(clientName, false);

	StringTokenizer tokenizer(customizationString);

	while (tokenizer.hasMoreTokens()) {
		byte customizationindex = (byte)tokenizer.getIntToken();

		if (tokenizer.hasMoreTokens()) {
			byte customizationvalue = (byte)tokenizer.getIntToken();

			String customizationname = variables.elementAt(customizationindex).getKey();

			prototype->setCustomizationVariable(customizationname, customizationvalue);
		}
	}

	auto dtano3 = new TangibleObjectDeltaMessage3(prototype);

	dtano3->updateCustomName(customName);
	dtano3->updateOptionsBitmask();
	dtano3->updateCustomizationString();
	dtano3->close();

	crafter->sendMessage(dtano3);

	auto dMsco3 = new ManufactureSchematicObjectDeltaMessage3(manufactureSchematic);

	dMsco3->updateName(clientName);
	dMsco3->updateCondition(schematicCount);
	dMsco3->close();

	crafter->sendMessage(dMsco3);

	auto objMsg = new ObjectControllerMessage(crafter->getObjectID(), 0x1B, 0x010C);

	objMsg->insertInt(0x15A);
	objMsg->insertInt(0);
	objMsg->insertByte(0);

	crafter->sendMessage(objMsg);

	state = 5;
}

void CraftingSessionImplementation::finishStage1(int clientCounter) {
	ManagedReference<CreatureObject*> crafter = this->crafter.get();

	PlayerObjectDeltaMessage9* dplay9 = new PlayerObjectDeltaMessage9(crafter->getPlayerObject());
	dplay9->setCraftingState(state);
	dplay9->close();

	crafter->sendMessage(dplay9);

	// Object Controller
	ObjectControllerMessage* objMsg = new ObjectControllerMessage(crafter->getObjectID(), 0x1B, 0x01BE);
	objMsg->insertInt(0x109);
	objMsg->insertInt(4);
	objMsg->insertByte(clientCounter);

	crafter->sendMessage(objMsg);

	state = 6;
}

void CraftingSessionImplementation::finishStage2(int clientCounter) {
	ManagedReference<CreatureObject*> crafter = this->crafter.get();

	PlayerObjectDeltaMessage9* dplay9 = new PlayerObjectDeltaMessage9(crafter->getPlayerObject());
	dplay9->insertShort(5);
	dplay9->insertInt(0xFFFFFFFF);
	dplay9->setCraftingState(state);

	dplay9->close();
	crafter->sendMessage(dplay9);

	// Object Controller
	ObjectControllerMessage* objMsg = new ObjectControllerMessage(crafter->getObjectID(), 0x1B, 0x010C);
	objMsg->insertInt(0x10A);
	objMsg->insertInt(1);
	objMsg->insertByte(clientCounter);
	crafter->sendMessage(objMsg);
}

void CraftingSessionImplementation::createPrototype(int clientCounter, bool createItem) {
	ManagedReference<CreatureObject*> crafter = this->crafter.get();
	ManagedReference<ManufactureSchematic*> manufactureSchematic = this->manufactureSchematic.get();

	if (manufactureSchematic == nullptr) {
		sendSlotMessage(clientCounter, IngredientSlot::NOSCHEMATIC);
		return;
	}

	if (!checkPrototype()) {
		sendSlotMessage(clientCounter, IngredientSlot::PROTOTYPENOTFOUND);
		return;
	}

	Locker locker(manufactureSchematic);

	if (manufactureSchematic->isAssembled() && !manufactureSchematic->isCompleted()) {
		closeCraftingWindow(clientCounter, true);

		String xpType = manufactureSchematic->getDraftSchematic()->getXpType();
		int xp = manufactureSchematic->getDraftSchematic()->getXpAmount();

		if (createItem) {
			startCreationTasks(manufactureSchematic->getComplexity() * 0, false);

		} else {
			// This is for practicing
			startCreationTasks(manufactureSchematic->getComplexity() * 0, true);
			xp = round(xp * 1.5f);
		}

		Reference<PlayerManager*> playerManager = crafter->getZoneServer()->getPlayerManager();
		playerManager->awardExperience(crafter, xpType, xp, true);

		manufactureSchematic->setCompleted();

	} else {
		closeCraftingWindow(clientCounter, false);

		sendSlotMessage(clientCounter, IngredientSlot::WEIRDFAILEDMESSAGE);
	}

	cancelSession();
}

void CraftingSessionImplementation::startCreationTasks(int timer, bool practice) {
	ManagedReference<CraftingTool*> craftingTool = this->craftingTool.get();
	ManagedReference<CreatureObject*> crafter = this->crafter.get();

	ManagedReference<ZoneServer*> server = crafter->getZoneServer();

	if (server != nullptr) {
		Locker locker(craftingTool);
		craftingTool->setBusy();

		int timer2 = 1;

		Reference<UpdateToolCountdownTask*> updateToolCountdownTask = nullptr;
		Reference<CreateObjectTask*> createObjectTask = new CreateObjectTask(crafter, craftingTool, practice);

		while (timer > 0) {
			updateToolCountdownTask = new UpdateToolCountdownTask(crafter, craftingTool, timer);
			updateToolCountdownTask->schedule(timer2);
			timer -= 5;
			timer2 += 5000;
		}

		if (timer < 0) {
			timer2 += (timer * 1000);
			timer = 0;
		}

		updateToolCountdownTask = new UpdateToolCountdownTask(crafter, craftingTool, timer);
		updateToolCountdownTask->schedule(timer2);
		createObjectTask->schedule(timer2);
	}
}

void CraftingSessionImplementation::createManufactureSchematic(int clientCounter) {
	if (!validateSession()) {
		return;
	}

	ManagedReference<CreatureObject*> crafter = this->crafter.get();
	ManagedReference<ManufactureSchematic*> manufactureSchematic = this->manufactureSchematic.get();
	ManagedReference<TangibleObject*> prototype = this->prototype.get();

	if (manufactureSchematic == nullptr) {
		sendSlotMessage(0, IngredientSlot::NOSCHEMATIC);
		return;
	}

	if (!checkPrototype()) {
		sendSlotMessage(0, IngredientSlot::PROTOTYPENOTFOUND);
		return;
	}

	if (!manufactureSchematic->allowFactoryRun()) {
		sendSlotMessage(0, IngredientSlot::NOSCHEMATIC);
		return;
	}

	if (manufactureSchematic->isAssembled() && !manufactureSchematic->isCompleted()) {
		// Object Controller
		ObjectControllerMessage* objMsg = new ObjectControllerMessage(crafter->getObjectID(), 0x1B, 0x010C);
		objMsg->insertInt(0x10B);
		objMsg->insertInt(1);
		objMsg->insertByte(clientCounter);

		crafter->sendMessage(objMsg);

		ManagedReference<SceneObject*> datapad = crafter->getSlottedObject("datapad");

		Locker prototypeLocker(prototype);

		prototype->destroyObjectFromWorld(0);

		manufactureSchematic->setPersistent(2);
		prototype->setPersistent(2);

		TransactionLog trx(crafter, datapad, manufactureSchematic, TrxCode::CRAFTINGSESSION);
		datapad->transferObject(manufactureSchematic, -1, true);
		manufactureSchematic->setPrototype(prototype);

	} else {
		closeCraftingWindow(clientCounter, false);

		sendSlotMessage(clientCounter, IngredientSlot::WEIRDFAILEDMESSAGE);
	}

	cancelSession();
}

void CraftingSessionImplementation::addSkillMods() {
	ManagedReference<ManufactureSchematic*> manufactureSchematic = this->manufactureSchematic.get();
	ManagedReference<TangibleObject*> prototype = this->prototype.get();

	ManagedReference<DraftSchematic*> draftSchematic = manufactureSchematic->getDraftSchematic();

	const VectorMap<String, int>* skillMods = draftSchematic->getDraftSchematicTemplate()->getSkillMods();

	for (int i = 0; i < skillMods->size(); i++) {
		const auto& mod = skillMods->elementAt(i);

		if (prototype->isWearableObject()) {
			WearableObject* wearable = prototype.castTo<WearableObject*>();
			VectorMap<String, int>* wearableMods = wearable->getWearableSkillMods();

			if (wearableMods->contains(mod.getKey())) {
				int oldValue = wearableMods->get(mod.getKey());
				int newValue = mod.getValue() + oldValue;

				if (newValue > 25)
					newValue = 25;

				wearableMods->put(mod.getKey(), newValue);
				continue;
			}
		}

		prototype->addSkillMod(SkillModManager::WEARABLE, mod.getKey(), mod.getValue(), false);
	}
}

void CraftingSessionImplementation::addWeaponDots() {
	ManagedReference<TangibleObject*> prototype = this->prototype.get();

	if (!(prototype->isWeaponObject()))
		return;

	ManagedReference<WeaponObject*> weapon = cast<WeaponObject*>(prototype.get());

	ManagedReference<ManufactureSchematic*> manufactureSchematic = this->manufactureSchematic.get();
	ManagedReference<DraftSchematic*> draftSchematic = manufactureSchematic->getDraftSchematic();

	const Vector<VectorMap<String, int>>* weaponDots = draftSchematic->getDraftSchematicTemplate()->getWeaponDots();

	for (int i = 0; i < weaponDots->size(); i++) {
		const auto& dot = weaponDots->elementAt(i);

		for (int j = 0; j < dot.size(); j++) {
			const String& property = dot.elementAt(j).getKey();
			int value = dot.elementAt(j).getValue();

			if (property == "type")
				weapon->addDotType(value);
			else if (property == "attribute")
				weapon->addDotAttribute(value);
			else if (property == "strength")
				weapon->addDotStrength(value);
			else if (property == "duration")
				weapon->addDotDuration(value);
			else if (property == "potency")
				weapon->addDotPotency(value);
			else if (property == "uses")
				weapon->addDotUses(value);
		}
	}
}

bool CraftingSessionImplementation::checkPrototype() {
	ManagedReference<TangibleObject*> prototype = this->prototype.get();

	if (prototype == nullptr)
		return false;

	if (prototype->isSliced() || prototype->hasAntiDecayKit())
		return false;

	if (prototype->isWeaponObject()) {
		WeaponObject* weapon = prototype.castTo<WeaponObject*>();

		if (weapon->hasPowerup())
			return false;
	}

	if (prototype->getContainerObjectsSize() > 0) {
		error() << "checkPrototype(): prototype->getContainerObjectsSize() > 0, prototype: " << *prototype;
		return false;
	}

	return true;
}
