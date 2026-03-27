/*
 * TangibleObjectMenuComponent.cpp
 *
 *  Created on: 26/05/2011
 *      Author: victor
 */

#include "TangibleObjectMenuComponent.h"
#include "server/zone/objects/player/sessions/SlicingSession.h"
#include "server/zone/packets/object/ObjectMenuResponse.h"
#include "server/zone/objects/player/PlayerObject.h"
#include "server/zone/managers/loot/LootManager.h"
#include "server/zone/managers/loot/LootValues.h"
#include "server/zone/managers/loot/LootGroupMap.h"

void TangibleObjectMenuComponent::fillObjectMenuResponse(SceneObject* sceneObject, ObjectMenuResponse* menuResponse, CreatureObject* player) const {
	ObjectMenuComponent::fillObjectMenuResponse(sceneObject, menuResponse, player);

	uint32 gameObjectType = sceneObject->getGameObjectType();

	if (!sceneObject->isTangibleObject())
		return;

	TangibleObject* tano = cast<TangibleObject*>( sceneObject);

	// Figure out what the object is and if its able to be Sliced.
	if(tano->isSliceable() && !tano->isSecurityTerminal()) { // Check to see if the player has the correct skill level

		bool hasSkill = true;
		ManagedReference<SceneObject*> inventory = player->getSlottedObject("inventory");

		if ((gameObjectType == SceneObjectType::PLAYERLOOTCRATE) && !player->hasSkill("combat_smuggler_novice"))
			hasSkill = false;
		else if (sceneObject->isContainerObject())
			hasSkill = false; // Let the container handle our slice menu
		else if (sceneObject->isMissionTerminal() && !player->hasSkill("combat_smuggler_slicing_01"))
			hasSkill = false;
		else if (sceneObject->isWeaponObject() && (!inventory->hasObjectInContainer(sceneObject->getObjectID()) || !player->hasSkill("combat_smuggler_slicing_02")))
			hasSkill = false;
		else if (sceneObject->isArmorObject() && (!inventory->hasObjectInContainer(sceneObject->getObjectID()) || !player->hasSkill("combat_smuggler_slicing_03")))
			hasSkill = false;

		if(hasSkill)
			menuResponse->addRadialMenuItem(69, 3, "@slicing/slicing:slice"); // Slice
	}

	if (player->getPlayerObject() != nullptr && player->getPlayerObject()->isPrivileged()) {
		/// Viewing components used to craft item, for admins
		ManagedReference<SceneObject*> container = tano->getSlottedObject("crafted_components");

		if (container != nullptr && container->getContainerObjectsSize() > 0) {
			SceneObject* satchel = container->getContainerObject(0);

			if (satchel != nullptr && satchel->getContainerObjectsSize() > 0) {
				menuResponse->addRadialMenuItem(79, 3, "@ui_radial:ship_manage_components"); // View Components
			}
		}
	}

	WearableObject* wearable = cast<WearableObject*>(tano);
	if (wearable != nullptr) {
		if (wearable->isWearableObject() || wearable->isArmorObject()) {
			VectorMap<String, int>* mods = wearable->getWearableSkillMods();
			if (mods->size() > 0) {
				int price;
				int value = mods->elementAt(0).getValue();

				if (value > 20) {
					price = mods->size() * (value * 12000);
				} else if (value > 15) {
					price = mods->size() * (value * 11000);
				} else if (value > 10) {
					price = mods->size() * (value * 10000);
				} else if (value > 5 ) {
					price = mods->size() * (value * 9000);
				} else {
					price = mods->size() * (value * 8000);
				}

				bool hasForbiddenMods = false;
				for (int i = 0; i<mods->size(); i++) {
					String key = mods->elementAt(i).getKey().toLowerCase();

					if (key.contains("deity_")) {
						hasForbiddenMods = true;
						break;
					}
				}
				if (!hasForbiddenMods) {
					// menuResponse->addRadialMenuItem(89, 3, "Extract Skill Mods (Destroys Item - " + String::valueOf(price / 1000) + "k Credit Fee)");
					menuResponse->addRadialMenuItem(88, 3, "SEA Removal");
					menuResponse->addRadialMenuItemToRadialID(88, 90, 3, "Use weak SEA removal tool");
					menuResponse->addRadialMenuItemToRadialID(88, 91, 3, "Use moderate SEA removal tool");
					menuResponse->addRadialMenuItemToRadialID(88, 92, 3, "Use strong SEA removal tool");
					menuResponse->addRadialMenuItemToRadialID(88, 93, 3, "Use powerful SEA removal tool");
				}
			}
		}
	}

	ManagedReference<SceneObject*> parent = tano->getParent().get();
	if (parent != nullptr && parent->getGameObjectType() == SceneObjectType::STATICLOOTCONTAINER) {
		menuResponse->addRadialMenuItem(10, 3, "@ui_radial:item_pickup"); //Pick up
	}
}

int TangibleObjectMenuComponent::handleObjectMenuSelect(SceneObject* sceneObject, CreatureObject* player, byte selectedID) const {
	auto zoneServer = player->getZoneServer();
	auto lootManager = zoneServer->getLootManager();

	if (!sceneObject->isTangibleObject())
		return 0;

	TangibleObject* tano = cast<TangibleObject*>( sceneObject);


	if (selectedID == 69 && player->hasSkill("combat_smuggler_novice") ) { // Slice [PlayerLootCrate]
		if (player->containsActiveSession(SessionFacadeType::SLICING)) {
			player->sendSystemMessage("@slicing/slicing:already_slicing");
			return 0;
		}

		//Create Session
		ManagedReference<SlicingSession*> session = new SlicingSession(player);
		session->initalizeSlicingMenu(player, tano);

		return 0;
	} else if (selectedID == 79) { // See components (admin)
		if(player->getPlayerObject() != nullptr && player->getPlayerObject()->isPrivileged()) {

			SceneObject* container = tano->getSlottedObject("crafted_components");
			if(container != nullptr) {

				if(container->getContainerObjectsSize() > 0) {

					SceneObject* satchel = container->getContainerObject(0);

					if(satchel != nullptr) {

						satchel->sendWithoutContainerObjectsTo(player);
						satchel->openContainerTo(player);

					} else {
						player->sendSystemMessage("There is no satchel this container");
					}
				} else {
					player->sendSystemMessage("There are no items in this container");
				}
			} else {
				player->sendSystemMessage("There is no component container in this object");
			}
		}

		return 0;
	// } else if (selectedID == 89) {
	// 	WearableObject* wearable = cast<WearableObject*>(tano);
	// 	ManagedReference<SceneObject*> sea = nullptr;

	// 	ManagedReference<SceneObject*> inventory = player->getSlottedObject("inventory");

	// 	if (wearable != nullptr && inventory != nullptr) {
	// 		if (wearable->isWearableObject() || wearable->isArmorObject()) {
	// 			if (wearable->isEquipped()) {
	// 				player->sendSystemMessage("You must unequip the item before extracting skill mods.");
	// 				return 0;
	// 			}

	// 			VectorMap<String, int>* mods = wearable->getWearableSkillMods();
	// 			if (mods->size() > 0) {
	// 				int price;
	// 				int value = mods->elementAt(0).getValue();

	// 				if (value > 20) {
	// 					price = mods->size() * (value * 12000);
	// 				} else if (value > 15) {
	// 					price = mods->size() * (value * 11000);
	// 				} else if (value > 10) {
	// 					price = mods->size() * (value * 10000);
	// 				} else {
	// 					price = mods->size() * (value * 9000);
	// 				}
	// 				// int price = 50000 * mods->size();
	// 				if (player->getCashCredits() < price) {
	// 					player->sendSystemMessage("You do not have enough credits to extract the skill mods.");
	// 					return 0;
	// 				}
	// 				int i,j;
	// 				auto lootGroupMap = lootManager->getLootMap();
	// 				Reference<const LootItemTemplate*> itemTemplate = nullptr;
	// 				String objectTemplate = "";
	// 				objectTemplate = sceneObject->getObjectTemplate()->getFullTemplateString();

	// 				if (wearable->isArmorObject() || 
	// 					 objectTemplate == "object/tangible/wearables/armor/padded/armor_padded_s01_belt.iff"  || 
	// 					 objectTemplate == "object/tangible/wearables/armor/zam/armor_zam_wesell_belt.iff"){
	// 						itemTemplate = lootGroupMap->getLootItemTemplate("attachment_armor");
	// 				} else{
	// 					itemTemplate = lootGroupMap->getLootItemTemplate("attachment_clothing");
	// 				}

	// 				if (lootGroupMap == nullptr) {
	// 					error("Invalid loot template");
	// 					return 0;
	// 				}

	// 				for (i = 0; i < mods->size(); i++) {
	// 					String modKey = mods->elementAt(i).getKey();

	// 					sea = lootManager->createLootAttachment(itemTemplate, modKey, mods->elementAt(i).getValue()); 

	// 					if (sea != nullptr){
	// 						Attachment* attachment = cast<Attachment*>(sea.get());
							
	// 						if (attachment != nullptr){
	// 							Locker objLocker(attachment);
	// 							if (inventory->transferObject(sea, -1, true, true)) {
	// 								inventory->broadcastObject(sea, true);
	// 							} else {
	// 								sea->destroyObjectFromDatabase(true);
	// 								error("Unable to place Skill Attachment in player's inventory!");
	// 								return false;
	// 							}
								
	// 						}
								
	// 					}
	// 				}

	// 				wearable->destroyObjectFromWorld(true);
	// 				wearable->destroyObjectFromDatabase(true);
	// 				player->subtractCashCredits(price);

	// 				player->sendSystemMessage("Skill mods extracted successfully. " + String::valueOf(price) + " credits have been deducted.");
	// 			}
	// 		}
	// 	}
	// return 0;
	} else if (selectedID == 90 or selectedID == 91 or selectedID == 92 or selectedID == 93) {
		WearableObject* wearable = cast<WearableObject*>(tano);
		ManagedReference<SceneObject*> sea = nullptr;

		ManagedReference<SceneObject*> inventory = player->getSlottedObject("inventory");

		if (wearable == nullptr || inventory == nullptr) {
			player->sendSystemMessage("An error occurred while trying to remove the SEA. Please contact an administrator.");
			return 0;
		}

		if (wearable->isEquipped()) {
			player->sendSystemMessage("You must unequip the item before extracting skill mods.");
			return 0;
		}

		bool isArmorObject = wearable->isArmorObject();

		int seaRemovalLevel = selectedID - 89;
		int seaRemovalChance = seaRemovalLevel * 15;

		String seaToolName = "";

		switch(selectedID) {
			case 89:
				if (isArmorObject) {
					seaToolName = "a weak armor SEA removal tool";
				} else {
					seaToolName = "a weak clothing SEA removal tool";
				}
				break;
			case 90:
				if (isArmorObject) {
					seaToolName = "a moderate armor SEA removal tool";
				} else {
					seaToolName = "a moderate clothing SEA removal tool";
				}
				break;
			case 91:
				if (isArmorObject) {
					seaToolName = "a strong armor SEA removal tool";
				} else {
					seaToolName = "a strong clothing SEA removal tool";
				}
				break;
			case 92:
				if (isArmorObject) {
					seaToolName = "a powerful armor SEA removal tool";
				} else {
					seaToolName = "a powerful clothing SEA removal tool";
				}
				break;
			default:
				if (isArmorObject) {
					seaToolName = "a weak armor SEA removal tool";
				} else {
					seaToolName = "a weak clothing SEA removal tool";
				}
				break;
		}
		
		Reference<SceneObject*> seaTool = nullptr;

		for (int i = 0; i < inventory->getContainerObjectsSize(); i++) {
			Reference<SceneObject*> sco = inventory->getContainerObject(i);

			if (sco == nullptr) {
				continue;
			}

			if (sco->getCustomObjectName().toString() == seaToolName) {
				seaTool = sco;
			}
		}

		if (seaTool == nullptr) {
			player->sendSystemMessage("You do not have the required SEA tool, speak to Kreezo in Mos Espa");
			return 0;
		}

		VectorMap<String, int>* mods = wearable->getWearableSkillMods();

		// String blankDiskRequired = "a Blank Clothing Enhancement Disk";

		// if (isArmorObject) {
		// 	blankDiskRequired = "a Blank Armor Enhancement Disk";
		// }

		// int numberOfDisks = inventory->getNumberOfContainerObjectByCustomName(blankDiskRequired, true);

		// if (numberOfDisks < mods->size()) {
		// 	player->sendSystemMessage("You do not have the required number of enhancement disks for this item.")
		// 	return 0;
		// }

		auto lootGroupMap = lootManager->getLootMap();
		Reference<const LootItemTemplate*> itemTemplate = nullptr;
		String objectTemplate = "";
		objectTemplate = sceneObject->getObjectTemplate()->getFullTemplateString();

		if (isArmorObject || objectTemplate == "object/tangible/wearables/armor/padded/armor_padded_s01_belt.iff"  || objectTemplate == "object/tangible/wearables/armor/zam/armor_zam_wesell_belt.iff") {
			itemTemplate = lootGroupMap->getLootItemTemplate("attachment_armor");
		} else {
			itemTemplate = lootGroupMap->getLootItemTemplate("attachment_clothing");
		}

		if (lootGroupMap == nullptr) {
			error("Invalid loot template");
			return 0;
		}

		for (int i = 0; i < mods->size(); i++) {
			if (System::random(100) < seaRemovalChance) {
				String key = mods->elementAt(i).getKey();
				
				sea = lootManager->createLootAttachment(itemTemplate, key, mods->elementAt(i).getValue());
				
				if (sea != nullptr) {
					Attachment* attachment = cast<Attachment*>(sea.get());
					
					if (attachment != nullptr) {
						Locker objLocker(attachment);
						if (inventory->transferObject(sea, -1, true, true)) {
							inventory->broadcastObject(sea, true);
							player->sendSystemMessage("The skill mod: " + mods->elementAt(i).getKey() + " was successfully extracted.");
						} else {
							sea->destroyObjectFromDatabase(true);
							error("Unable to place Skill Attachment in player's inventory!");
						return 0;
						}
					}
				}
			
				// Reference<SceneObject*> disk = inventory->getContainerObjectByCustomName(blankDiskRequired, true);
			
				// disk->destroyObjectFromWorld(true);
				// disk->destroyObjectFromDatabase(true);
			} else {
				player->sendSystemMessage("The skill mod: " + mods->elementAt(i).getKey() + " could not be extracted and has been lost.");
			}
		}
		
		// Destroy the SEA Tool
		seaTool->destroyObjectFromWorld(true);
		seaTool->destroyObjectFromDatabase(true);

		// Destroy the wearable
		wearable->destroyObjectFromWorld(true);
		wearable->destroyObjectFromDatabase(true);
		return 0;
	} else {
		return ObjectMenuComponent::handleObjectMenuSelect(sceneObject, player, selectedID);
	}
}



