/*
 * BuildingObjectImplementation.cpp
 *
 *  Created on: 23/07/2009
 *      Author: TheAnswer
 */

#include "server/zone/objects/building/BuildingObject.h"
#include "server/zone/Zone.h"
#include "server/zone/ZoneProcessServer.h"
#include "server/zone/ZoneClientSession.h"

#include "templates/building/SharedBuildingObjectTemplate.h"

#include "server/zone/objects/player/sui/messagebox/SuiMessageBox.h"
#include "server/zone/objects/tangible/sign/SignObject.h"
#include "server/zone/packets/tangible/TangibleObjectMessage3.h"
#include "server/zone/packets/tangible/TangibleObjectMessage6.h"
#include "server/zone/packets/cell/UpdateCellPermissionsMessage.h"

#include "server/zone/managers/structure/StructureManager.h"
#include "server/zone/managers/stringid/StringIdManager.h"
#include "server/zone/managers/planet/PlanetManager.h"
#include "server/zone/managers/vendor/VendorManager.h"
#include "server/zone/managers/collision/CollisionManager.h"

#include "server/zone/objects/player/sui/callbacks/StructurePayAccessFeeSuiCallback.h"
#include "server/zone/objects/building/tasks/RevokePaidAccessTask.h"
#include "tasks/EjectObjectEvent.h"
#include "server/zone/managers/gcw/GCWManager.h"

#include "server/zone/objects/installation/InstallationObject.h"
#include "server/zone/managers/creature/CreatureManager.h"
#include "server/zone/objects/creature/ai/AiAgent.h"

#include "server/zone/objects/building/components/GCWBaseContainerComponent.h"
#include "server/zone/objects/building/components/EnclaveContainerComponent.h"
#include "server/zone/objects/building/components/DestructibleBuildingDataComponent.h"
#include "server/zone/objects/transaction/TransactionLog.h"
#include "server/zone/objects/player/FactionStatus.h"

// #define DEBUG_COV

void BuildingObjectImplementation::initializeTransientMembers() {
	cooldownTimerMap = new CooldownTimerMap();

	StructureObjectImplementation::initializeTransientMembers();

	setLoggingName("BuildingObject");
	updatePaidAccessList();
	registeredPlayerIdList.removeAll();
}

void BuildingObjectImplementation::loadTemplateData(SharedObjectTemplate* templateData) {
	StructureObjectImplementation::loadTemplateData(templateData);

	containerVolumeLimit = 0xFFFFFFFF;

	containerType = 2;

	optionsBitmask = 0x00000100;

	SharedBuildingObjectTemplate* buildingData = dynamic_cast<SharedBuildingObjectTemplate*>(templateData);

	if (buildingData == nullptr)
		return;

	totalCellNumber = buildingData->getTotalCellNumber();

	const PortalLayout* portalLayout = templateData->getPortalLayout();

	if (portalLayout != nullptr)
		totalCellNumber = portalLayout->getFloorMeshNumber() - 1; // remove the exterior floor

	publicStructure = buildingData->isPublicStructure();

	factionBaseType = buildingData->getFactionBaseType();
}

void BuildingObjectImplementation::createContainerComponent() {
	TangibleObjectImplementation::createContainerComponent();
}

void BuildingObjectImplementation::notifyInsertToZone(Zone* zone) {
	StructureObjectImplementation::notifyInsertToZone(zone);

	Locker locker(zone);

	for (int i = 0; i < cells.size(); ++i) {
		auto& cell = cells.get(i);

		cell->onBuildingInsertedToZone(asBuildingObject());
	}

#if ENABLE_STRUCTURE_JSON_EXPORT
	if (getOwnerObjectID() != 0)
		info("Exported to " + exportJSON("notifyInsertToZone"), true);
#endif // DEBUG_STRUCTURE_MAINT
}

int BuildingObjectImplementation::getCurrentNumberOfPlayerItems() {
	int items = 0;

	for (int i = 0; i < cells.size(); ++i) {
		auto& cell = cells.get(i);

		items += cell->getCurrentNumberOfPlayerItems();
	}

	return items;
}

void BuildingObjectImplementation::createCellObjects() {
	for (int i = 0; i < totalCellNumber; ++i) {
		auto newCell = getZoneServer()->createObject(0xAD431713, getPersistenceLevel());

		if (newCell == nullptr || !newCell->isCellObject()) {
			error("could not create cell");
			continue;
		}

		Locker clocker(newCell, asBuildingObject());

		if (!transferObject(newCell, -1))
			error("could not add cell");

		addCell(static_cast<CellObject*>(newCell.get()), i + 1);
	}

	updateToDatabase();
}

void BuildingObjectImplementation::sendContainerObjectsTo(SceneObject* player, bool forceLoad) {
	for (int i = 0; i < cells.size(); ++i) {
		auto& cell = cells.get(i);

		cell->sendTo(player, true);
	}
}

void BuildingObjectImplementation::sendTo(SceneObject* player, bool doClose, bool forceLoadContainer) {
	debug("building sendto..");

	if (!isStaticBuilding()) { // send Baselines etc..
		debug("sending building object create");

		TangibleObjectImplementation::sendTo(player, doClose, forceLoadContainer);
	} //else { // just send the objects that are in the building, without the cells because they are static in the client

	auto closeObjects = player->getCloseObjects();

	// for some reason client doesnt like when you send cell creatures while sending cells?
	for (int i = 0; i < cells.size(); ++i) {
		auto& cell = cells.get(i);

		auto perms = cell->getContainerPermissions();

		if (!perms->hasInheritPermissionsFromParent()) {
			CreatureObject* creo = player->asCreatureObject();

			if (creo != nullptr && !cell->checkContainerPermission(creo, ContainerPermissions::WALKIN)) {
				BaseMessage* perm = new UpdateCellPermissionsMessage(cell->getObjectID(), false);
				player->sendMessage(perm);
			}
		}

		if (!cell->isContainerLoaded())
			continue;

		for (int j = 0; j < cell->getContainerObjectsSize(); ++j) {
			auto containerObject = cell->getContainerObject(j);
			if (containerObject == nullptr) {
				continue;
			}

			if (containerObject == player) {
				if (containerObject->getMovementCounter() == 0) {
					containerObject->sendTo(player, true, false);
				}

				continue;
			}

			if ((containerObject->isCreatureObject() && publicStructure) || (closeObjects != nullptr && closeObjects->contains(containerObject.get())))
				containerObject->sendTo(player, true, false);
		}
	}
	//}
}

bool BuildingObjectImplementation::hasTemplateEjectionPoint() {
	SharedBuildingObjectTemplate* buildingTemplate = templateObject.castTo<SharedBuildingObjectTemplate*>();

	if (buildingTemplate == nullptr)
		return false;

	Vector3 ejectionPoint = buildingTemplate->getEjectionPoint();

	if (ejectionPoint.getX() == 0 && ejectionPoint.getY() == 0)
		return false;
	else
		return true;
}

Vector3 BuildingObjectImplementation::getTemplateEjectionPoint() const {
	SharedBuildingObjectTemplate* buildingTemplate = templateObject.castTo<SharedBuildingObjectTemplate*>();

	return buildingTemplate->getEjectionPoint();
}

Vector3 BuildingObjectImplementation::getEjectionPoint() {
	Vector3 worldPosition = getWorldPosition();

	if (hasTemplateEjectionPoint()) {
		Vector3 templateEjectionPoint = getTemplateEjectionPoint();
		Vector3 ejectionPoint;

		ejectionPoint.setX(worldPosition.getX() + templateEjectionPoint.getX());
		ejectionPoint.setY(worldPosition.getY() + templateEjectionPoint.getY());
		auto zone = getZone();

		if (zone != nullptr) {
			ejectionPoint.setZ(CollisionManager::getWorldFloorCollision(ejectionPoint.getX(), ejectionPoint.getY(), zone, false));
		} else {
			ejectionPoint.setZ(worldPosition.getZ() + templateEjectionPoint.getZ());
		}

		return ejectionPoint;
	} else {
		SharedObjectTemplate *shot = getObjectTemplate();

		if (shot != nullptr && shot->isSharedBuildingObjectTemplate()) {
			SharedBuildingObjectTemplate *templateData = static_cast<SharedBuildingObjectTemplate*>(shot);
			const PortalLayout* portalLayout = templateData->getPortalLayout();

			if (portalLayout != nullptr) {
				const Vector<Reference<CellProperty*> >& cells = portalLayout->getCellProperties();
				if(cells.size() > 0) {
					const CellProperty* cell = cells.get(0);
					for (int i=0; i<cell->getNumberOfPortals(); i++) {
						const CellPortal* portal = cell->getPortal(0);
						const AABB& box = portalLayout->getPortalBounds(portal->getGeometryIndex());
						const MeshData *geom = portalLayout->getPortalGeometry(portal->getGeometryIndex());

						if (geom == nullptr)
							continue;

						const Vector<MeshTriangle>& tris = *geom->getTriangles();
						const Vector<Vector3>& verts = *geom->getVerts();
						if (tris.size() == 0)
							continue;

						const MeshTriangle& tri = tris.get(0);
						const int* ind = tri.getVerts();
						Vector3 normal;
						Vector3 v[3] = { verts.get(ind[0]), verts.get(ind[1]), verts.get(ind[2]) };
						if (!portal->isWindingCCW()) {
							normal = (v[0] - v[1]).crossProduct(v[0]-v[2]);
						} else {
							normal = (v[0] - v[2]).crossProduct(v[0]-v[1]);
						}
						normal.normalize();

						Vector3 floor = box.center() - Vector3(0, box.extents().getY(), 0);
						floor += normal * templateData->getEjectDistance();

						Matrix4 transform;

						transform.setRotationMatrix(direction.toMatrix3());
						transform.setTranslation(getPositionX(), getPositionZ(), getPositionY());

						// this works, i have no idea why we need it. I give up.
						// Matrix4 transpose
						Matrix4 orig = transform;
						transform[0][1] = orig[1][0];
						transform[0][2] = orig[2][0];
						transform[1][0] = orig[0][1];
						transform[1][2] = orig[2][1];
						transform[2][0] = orig[0][2];
						transform[2][1] = orig[1][2];

						Vector3 flipped = transform * floor;
						return Vector3(flipped[0], flipped[2], CollisionManager::getWorldFloorCollision(flipped[0], flipped[2], flipped[1], getZone(), false));
					}
				}
			}
		}
	}

	if(signObject)
		return signObject->getPosition();

	return worldPosition;
}

void BuildingObjectImplementation::notifyRemoveFromZone() {
	for (int i = 0; i < cells.size(); ++i) {
		auto& cell = cells.get(i);

		//cell->resetCurrentNumerOfPlayerItems();

		while (cell->getContainerObjectsSize() > 0) {
			auto obj = cell->getContainerObject(0);

			Locker objLocker(obj);

			if (obj->isVendor()) {
				VendorManager::instance()->destroyVendor(obj->asTangibleObject());
			} else {
				obj->destroyObjectFromWorld(true);
			}

			objLocker.release();

			Locker contLocker(cell->getContainerLock());

			auto cont = cell->getContainerObjects();

			if (cont->size() > 0) {
				auto test = cell->getContainerObject(0);

				if (test == obj) {
					cont->remove(0);
				}
			}
		}
	}

	for (int i = 0; i < childCreatureObjects.size(); ++i) {
		ManagedReference<CreatureObject*> child = childCreatureObjects.get(i);

		if (child == nullptr)
			continue;

		Locker locker(child);

		AiAgent* ai = child->asAiAgent();

		if (ai != nullptr) {
			ai->setRespawnTimer(0);
		}

		child->destroyObjectFromWorld(true);
	}

	childObjects.removeAll();
	childCreatureObjects.removeAll();

	if (signObject != nullptr) {
		Locker signLocker(signObject);

		signObject->destroyObjectFromWorld(true);
	}

	TangibleObjectImplementation::notifyRemoveFromZone();
}

void BuildingObjectImplementation::sendDestroyTo(SceneObject* player) {
	if (!isStaticBuilding()) {
		debug("sending building object destroy");

		SceneObjectImplementation::sendDestroyTo(player);
	}
}

void BuildingObjectImplementation::sendBaselinesTo(SceneObject* player) {
	//send buios here
	debug("sending building baselines");

	BaseMessage* buio3 = new TangibleObjectMessage3(asBuildingObject());
	player->sendMessage(buio3);

	BaseMessage* buio6 = new TangibleObjectMessage6(asBuildingObject());
	player->sendMessage(buio6);
}

bool BuildingObjectImplementation::isCityBanned(CreatureObject* player) {
	auto thisRegion  = this->getCityRegion().get();

	if (thisRegion != nullptr)
		if (thisRegion->isBanned(player->getObjectID()))
			return true;

	return false;
}

bool BuildingObjectImplementation::isAllowedEntry(CreatureObject* player) {
	if (player == nullptr) {
		return false;
	}

	GCWBaseContainerComponent* conComp = containerComponent.castTo<GCWBaseContainerComponent*>();

	if (conComp != nullptr) {
		if (factionBaseType == GCWManager::STATICFACTIONBASE)
			return true;

		return checkContainerPermission(player,ContainerPermissions::WALKIN);
	}

	EnclaveContainerComponent* encComp = containerComponent.castTo<EnclaveContainerComponent*>();

	if (encComp != nullptr) {
		return encComp->checkContainerPermission(asBuildingObject(), player, ContainerPermissions::WALKIN);
	}

	if (!isClientObject()) {
		PlayerObject* ghost = player->getPlayerObject().get();

		if (ghost != nullptr && ghost->hasPvpTef()) {
			return false;
		}
	}

	if (getOwnerObjectID() == player->getObjectID())
		return true;

	if (isOnBanList(player))
		return false;

	if (isPrivateStructure() && !isOnEntryList(player))
		return false;

	return true;
}

void BuildingObjectImplementation::notifyObjectInsertedToZone(SceneObject* object) {
	debug("BuildingObjectImplementation::notifyInsertToZone");

	auto closeObjectsVector = getCloseObjects();
	Vector<TreeEntry*> closeObjects(closeObjectsVector->size(), 10);
	closeObjectsVector->safeCopyReceiversTo(closeObjects, CloseObjectsVector::CREOTYPE);

	for (int i = 0; i < closeObjects.size(); ++i) {
		SceneObject* obj = static_cast<SceneObject*>(closeObjects.get(i));

		if ((obj->isCreatureObject() && isPublicStructure()) || isStaticBuilding()) {
			if (obj->getRootParent() != _this.getReferenceUnsafe()) {
				if (object->getCloseObjects() != nullptr)
					object->addInRangeObject(obj, false);
				else
					object->notifyInsert(obj);

				if (obj->getCloseObjects() != nullptr)
					obj->addInRangeObject(object, false);
				else
					obj->notifyInsert(object);
			}
		}
	}

	notifyInsert(object);

	if (object->getCloseObjects() != nullptr)
		object->addInRangeObject(asBuildingObject(), false);

	addInRangeObject(object, false);

	Zone* zone = getZone();

	if (zone != nullptr) {
		TangibleObject* tano = object->asTangibleObject();

		if (tano != nullptr) {
			zone->updateActiveAreas(tano);
		}

		object->notifyInsertToZone(zone);
	}

	//this->sendTo(object, true);
}

void BuildingObjectImplementation::notifyInsert(TreeEntry* object) {
	auto sceneO = static_cast<SceneObject*>(object);
	uint64 scnoID = sceneO->getObjectID();

#ifdef DEBUG_COV
	info(true) << getObjectName() << " - BuildingObjectImplementation::notifyInsert for Object: " << sceneO->getDisplayedName() << " ID: " << sceneO->getObjectID();

	/*
	if (getObjectID() == 88) { // Theed Cantina
		info("BuildingObjectImplementation::notifyInsert(" + String::valueOf(scnoID) + ")", true);

		auto c = static_cast<CreatureObject*>(sceneO);

		if (c != nullptr)
			c->info("BuildingObjectImplementation::notifyInsert into " + String::valueOf(getObjectID()), true);
	}*/
#endif // DEBUG_COV

	// Prevent players that are mounted from being loaded on their own. When their mount loads it will send the player on its own
	if (sceneO->isPlayerCreature()) {
		auto player = sceneO->asCreatureObject();

		if (player != nullptr && player->isRidingMount()) {
#ifdef DEBUG_COV
			// Theed Medical Center & Theed Cloning Facility
			if (((getObjectID() == 1697358) || (getObjectID() == 1697350) || !isClientObject()) && ((sceneO->isPlayerCreature() || sceneO->isVehicleObject())))
				info(true) << "Blocked the adding of player that is riding mount: " << sceneO->getDisplayedName();
#endif // DEBUG_COV
			return;
		}
	}

#ifdef DEBUG_COV
	// Theed Medical Center & Theed Cloning Facility
	if (((getObjectID() == 1697358) || (getObjectID() == 1697350) || !isClientObject()) && ((sceneO->isPlayerCreature() || sceneO->isVehicleObject())))
		info(true) << "notifyInsert for Object: " << sceneO->getDisplayedName() << " ID: " << sceneO->getObjectID();
#endif // DEBUG_COV

	uint64 sceneObjRootID = 0;
	auto sceneObjRootPar = sceneO->getRootParent();

	if (sceneObjRootPar != nullptr) {
		sceneObjRootID = sceneObjRootPar->getObjectID();
	}

	/* Always notify insertion of objects if the building is:
	*	- Static stucture (NPC Cities) always load their contents
	*	- Objects that are already in the same building, scene Object Root ID is the same as this building
	*/
	bool shouldLoad = isStaticBuilding() || (sceneObjRootID == getObjectID());

	for (int i = 0; i < cells.size(); ++i) {
		auto& cell = cells.get(i);

		if (!cell->isContainerLoaded())
			continue;

		try {
			for (int j = 0; j < cell->getContainerObjectsSize(); ++j) {
				auto child = cell->getContainerObject(j);

				// Don't send child to itself every time a new object is inserted in range
				if (child == nullptr || child->getObjectID() == scnoID)
					continue;

				if (shouldLoad || (child->isCreatureObject() && isPublicStructure())) {
#ifdef DEBUG_COV
					// Theed Medical Center & Theed Cloning Facility
					if (((getObjectID() == 1697358) || (getObjectID() == 1697350) || !isClientObject()) && child->isPlayerCreature() && (sceneO->isPlayerCreature() || sceneO->isVehicleObject()))
						info(true) << child->getDisplayedName() << " - adding to inRangeObjects for Entry Object: " << sceneO->getDisplayedName();
#endif // DEBUG_COV

					if (child->getCloseObjects() != nullptr) {
						child->addInRangeObject(object, false);
					} else {
						child->notifyInsert(object);
					}

					child->sendTo(sceneO, true, false);

					if (sceneO->getCloseObjects() != nullptr) {
						sceneO->addInRangeObject(child, false);
					} else {
						sceneO->notifyInsert(child);
					}

					if (sceneO->getParent() != nullptr) {
						sceneO->sendTo(child, true, false);
					}
				} else if (!sceneO->isCreatureObject() && !child->isCreatureObject()) {
					child->notifyInsert(object);
					object->notifyInsert(child);
				}
			}
		} catch (Exception& e) {
			warning(e.getMessage());
			e.printStackTrace();
		}
	}
}

void BuildingObjectImplementation::notifyDissapear(TreeEntry* object) {
	auto sceneO = static_cast<SceneObject*>(object);
	uint64 scnoID = sceneO->getObjectID();

#ifdef DEBUG_COV
	if (getObjectID() == 88) { // Theed Cantina
		info("BuildingObjectImplementation::notifyDissapear(" + String::valueOf(scnoID) + ")", true);

		auto c = static_cast<CreatureObject*>(object);

		if (c != nullptr)
			c->info("BuildingObjectImplementation::notifyDissapear from " + String::valueOf(getObjectID()), true);
	} else if (getObjectID() == 1082874 && (sceneO->isPlayerCreature() || sceneO->isVehicleObject())) {
		info(true) << "BuildingObjectImplementation::notifyDissapear ----- Mos Eisley cantina removing player or vehicle from nearby objects: " << sceneO->getDisplayedName();
	}
#endif // DEBUG_COV

	// Prevent players that are mounted from being removed on their own. When their mount disappears it will remove its contained & children objects
	if (sceneO->isPlayerCreature()) {
#ifdef DEBUG_COV
		if (sceneO->isPlayerCreature()) {
			info(true) << getObjectName() << " - BuildingObjectImplementation::notifyDissapear for Player: " << sceneO->getDisplayedName() << " ID: " << sceneO->getObjectID();
		}
#endif // DEBUG_COV

		auto player = sceneO->asCreatureObject();

		if (player != nullptr && player->isRidingMount()) {
#ifdef DEBUG_COV
			uint64 structureID = getObjectID();

			// Mos Eisley Cantina, Theed Medical Center, Theed Cloning Facility Tests, and Player Structures
			if ((structureID == 1082874) || (structureID == 1697358) || (structureID == 1697350) || !isClientObject()) {
				info(true) << "Blocked notifyDissapear for player that is riding vehicle or mount: " << sceneO->getDisplayedName();
			}
#endif // DEBUG_COV

			return;
		}
	}

	for (int i = 0; i < cells.size(); ++i) {
		auto& cell = cells.get(i);

		if (!cell->isContainerLoaded()) {
			continue;
		}

		try {
			for (int j = cell->getContainerObjectsSize() - 1; j >= 0 ; j--) {
				auto child = cell->getContainerObject(j);

				// Child should not remove itself
				if (child == nullptr || child->getObjectID() == scnoID) {
					continue;
				}

#ifdef DEBUG_COV
				// Theed Medical Center & Theed Cloning Facility
				if (((getObjectID() == 1082874) || (getObjectID() == 1697358) || (getObjectID() == 1697350)) && child->isPlayerCreature() && (sceneO->isPlayerCreature() || sceneO->isVehicleObject())) {
					info(true) << child->getDisplayedName() << " - removing inRangeObject Object: " << sceneO->getDisplayedName();
				}
#endif // DEBUG_COV

				if (child->getCloseObjects() != nullptr) {
					child->removeInRangeObject(object);
				} else {
					child->notifyDissapear(object);
				}

				if (object->getCloseObjects() != nullptr) {
					object->removeInRangeObject(child);
				} else {
					object->notifyDissapear(child);
				}
			}
		} catch (const Exception& exception) {
			warning() << "Could not remove all container objects in BuildingObject::notifyDissapear -- ID: " << getObjectID() << " -- Object Leaving Range: " << sceneO->getDisplayedName() << " ID: " << sceneO->getObjectID();

			exception.printStackTrace();
		}
	}
}

void BuildingObjectImplementation::notifyPositionUpdate(TreeEntry* entry) {
#if ! COV_BUILDING_QUAD_RANGE
	StructureObjectImplementation::notifyPositionUpdate(entry);
	return;
#else // COV_BUILDING_QUAD_RANGE
#if DEBUG_COV_VERBOSE
	if (getObjectID() == 88) { // Theed Cantina
		info("BuildingObjectImplementation::notifyPositionUpdate(" + String::valueOf(entry->getObjectID()) + ")", true);

		auto c = static_cast<CreatureObject*>(entry);

		if (c != nullptr)
			c->info("BuildingObjectImplementation::notifyPositionUpdate to " + String::valueOf(getObjectID()), true);
	}
#endif // DEBUG_COV_VERBOSE
	auto scno = static_cast<SceneObject*>(entry);

	bool objectInThisBuilding = scno->getRootParent() == asBuildingObject();

	for (int i = 0; i < cells.size(); ++i) {
		auto& cell = cells.get(i);

		if (!cell->isContainerLoaded())
			continue;

		try {
			for (int j = 0; j < cell->getContainerObjectsSize(); ++j) {
				auto child = cell->getContainerObject(j);

				if (child != entry && child != nullptr) {
					if ((objectInThisBuilding || (child->isCreatureObject() && isPublicStructure())) || isStaticBuilding()) {
						if (child->getCloseObjects() != nullptr)
							child->addInRangeObject(entry);
						else
							child->notifyPositionUpdate(entry);

						if (entry->getCloseObjects() != nullptr)
							entry->addInRangeObject(child);
						else
							entry->notifyPositionUpdate(child);
					} else if (!scno->isCreatureObject() && !child->isCreatureObject()) {
						child->notifyPositionUpdate(entry);
						entry->notifyPositionUpdate(child);
					}
				}
			}
		} catch (Exception& e) {
			warning(e.getMessage());
			e.printStackTrace();
		}
	}
#endif // COV_BUILDING_QUAD_RANGE
}

void BuildingObjectImplementation::insert(TreeEntry* entry) {
	//return;
}

void BuildingObjectImplementation::remove(TreeEntry* entry) {
}

void BuildingObjectImplementation::update(TreeEntry* entry) {
}

void BuildingObjectImplementation::inRange(TreeEntry* entry, float range) {
}

void BuildingObjectImplementation::addCell(CellObject* cell, uint32 cellNumber) {
	cells.put(cellNumber, cell);
#ifdef DEBUG_CELL_ORDER
	int n = cells.size();
	// Before 3373 it was assumed that cells came in order from snapshots but it turned out there was a CellId in the snapshot
	if(n != cellNumber) {
		StringBuffer buf;

		buf << "WARNING: oid:" << cell->getObjectID() << " [poid: " << getObjectID() << " " << getObjectNameStringIdName() << " " << getWorldPosition().toString() << "] Cell# " << cellNumber << " may have been " << n << " prior to 3373.";

		info(buf.toString(), true);
	}
#endif

	Locker clocker(cell, asBuildingObject());

	cell->setCellNumber(cellNumber);
}

CellObject* BuildingObjectImplementation::getCell(const String& cellName) {
	SharedBuildingObjectTemplate* buildingTemplate = templateObject.castTo<SharedBuildingObjectTemplate*>();

	if (buildingTemplate == nullptr)
		return nullptr;

	const PortalLayout* portalLayout = buildingTemplate->getPortalLayout();

	if (portalLayout == nullptr)
		return nullptr;

	int index = portalLayout->getCellID(cellName);

	if (index == -1 || index == 0)
		return nullptr;

	return getCell(index);
}

void BuildingObjectImplementation::destroyObjectFromDatabase(
		bool destroyContainedObjects) {

	float x = getPositionX();
	float y = getPositionY();
	float z = 0;

	if (zone != nullptr)
		z = zone->getHeight(x, y);

	for (int i = 0; i < cells.size(); ++i) {
		auto& cell = cells.get(i);

		for (int j = cell->getContainerObjectsSize() - 1; j >= 0 ; --j) {
			auto child = cell->getContainerObject(j);

			if (child->isPlayerCreature()) {
				child->teleport(x, z, y);

				if (cell->hasObjectInContainer(child->getObjectID())) {
					cell->removeObject(child, nullptr, true);
				}
			}
		}
	}

	StructureObjectImplementation::destroyObjectFromDatabase(
			destroyContainedObjects);

	if (!destroyContainedObjects)
		return;

	ManagedReference<SceneObject*> deed = getZoneServer()->getObject(
			deedObjectID);

	if (deed != nullptr)
		deed->destroyObjectFromDatabase(true);

	if (signObject != nullptr)
		signObject->destroyObjectFromDatabase(true);

	//Remove all child creature objects from world
	for (int i = 0; i < childCreatureObjects.size(); ++i) {
		ManagedReference<CreatureObject*> child = childCreatureObjects.get(i);

		if (child == nullptr)
			continue;

		Locker locker(child);
		auto ai = child->asAiAgent();

		if (ai != nullptr) {
			ai->setRespawnTimer(0);
		}

		child->destroyObjectFromWorld(true);
	}

	//Loop through the cells and delete all objects from the database.
}

void BuildingObjectImplementation::broadcastCellPermissions() {
	CloseObjectsVector* closeObjectsVector = (CloseObjectsVector*) getCloseObjects();

	SortedVector<TreeEntry*> closeObjects;
	closeObjectsVector->safeCopyReceiversTo(closeObjects, CloseObjectsVector::CREOTYPE);

	for (int i = 0; i < closeObjects.size(); ++i) {
		auto obj = static_cast<SceneObject*>(closeObjects.get(i));

		if (obj->isPlayerCreature())
			updateCellPermissionsTo(static_cast<CreatureObject*>(obj));
		else if (obj->isVehicleObject() || obj->isMount()) {
			auto rider = obj->getSlottedObject("rider");

			if (rider != nullptr && rider->isPlayerCreature()) {
				updateCellPermissionsTo(static_cast<CreatureObject*>(rider.get()));
			}
		}
	}
}

void BuildingObjectImplementation::broadcastCellPermissions(uint64 objectid) {
	auto obj = getZoneServer()->getObject(objectid);

	if (obj == nullptr || !obj->isCellObject() || obj->getParent() != asBuildingObject())
		return;

	CellObject* cell = static_cast<CellObject*>(obj.get());

	CloseObjectsVector* closeObjectsVector = getCloseObjects();

	SortedVector<TreeEntry*> closeObjects;
	closeObjectsVector->safeCopyReceiversTo(closeObjects, CloseObjectsVector::CREOTYPE);

	for (int i = 0; i < closeObjects.size(); ++i) {
		ManagedReference<SceneObject*> obj = static_cast<SceneObject*>( closeObjects.get(i));

		if (obj->isPlayerCreature()) {
			CreatureObject* creo = static_cast<CreatureObject*>(obj.get());
			cell->sendPermissionsTo(creo, isAllowedEntry(creo));
		} else if (obj->isVehicleObject() || obj->isMount()) {
			SceneObject* rider = obj->getSlottedObject("rider");

			if (rider != nullptr && rider->isPlayerCreature()) {
				CreatureObject* creo = static_cast<CreatureObject*>(rider);
				cell->sendPermissionsTo(creo, isAllowedEntry(creo));
			}
		}
	}
}

void BuildingObjectImplementation::updateCellPermissionsTo(CreatureObject* creature) {
	bool allowEntry = isAllowedEntry(creature);

	//If they are inside, and aren't allowed to be, then kick them out!
	if (!allowEntry && creature->getRootParent() == asBuildingObject()) {
		ejectObject(creature);
	}

	for (int i = 0; i < cells.size(); ++i) {
		auto& cell = cells.get(i);

		if (cell == nullptr)
			continue;

		cell->sendPermissionsTo(creature, allowEntry);
	}
}

void BuildingObjectImplementation::ejectObject(CreatureObject* creature) {
	PlayerObject* ghost = creature->getPlayerObject();

	if (ghost != nullptr && ghost->hasGodMode())
		return;

	Vector3 ejectionPoint = getEjectionPoint();

	float x = ejectionPoint.getX();
	float y = ejectionPoint.getY();
	float z = ejectionPoint.getZ();

	Reference<Task*> task = new EjectObjectEvent(creature, x, z, y);
	task->execute();
}

void BuildingObjectImplementation::onEnter(CreatureObject* player) {
	if (player == nullptr || !player->isPlayerCreature())
		return;

	// info(true) << "BuildingObjectImplementation::onEnter -- Building ID: " << getObjectID() << " Player: " << player->getDisplayedName();

	if (getZone() == nullptr)
		return;

	addTemplateSkillMods(player);

	Locker accessLock(&paidAccessListMutex);

	// Player GCW Bases, check for player entry permissions
	if (isGCWBase() && factionBaseType != GCWManager::STATICFACTIONBASE) {
		if (!checkContainerPermission(player, ContainerPermissions::WALKIN)) {
			ejectObject(player);
			return;
		}
	}

	// Jedi Enclaves, ensure player has proper permissions to enter
	EnclaveContainerComponent* encComp = containerComponent.castTo<EnclaveContainerComponent*>();

	if (encComp != nullptr && !encComp->checkContainerPermission(asBuildingObject(), player, ContainerPermissions::WALKIN)) {
		ejectObject(player);
		return;
	}

	// Handle buildings with access fees
	if (accessFee > 0 && !isOnEntryList(player)) {
		//thread safety issues!
		if (paidAccessList.contains(player->getObjectID())) {
			uint32 expireTime = paidAccessList.get(player->getObjectID());

			if(expireTime <= time(nullptr)) {
				paidAccessList.drop(player->getObjectID());

				promptPayAccessFee(player);

				ejectObject(player);

				return;
			}
		} else {
			promptPayAccessFee(player);

			ejectObject(player);

			return;
		}
	}

	// Trigger building entry observer
	notifyObservers(ObserverEventType::ENTEREDBUILDING, player, 0);

	// Handle player & civic structures below
	if (isClientObject()) {
		return;
	}

	if (isCondemned()) {
		// Handle condemned message
		uint64 ownerOid = getOwnerObjectID();

		if (ownerOid == player->getObjectID()) {
			StructureManager::instance()->promptPayUncondemnMaintenance(player, asBuildingObject());
		} else {
			//Other player than the owner trying to enter the building.
			StringIdChatParameter message("@player_structure:structure_condemned_not_owner");
			player->sendSystemMessage(message);
		}

		ejectObject(player);
		return;
	// Player is not allowed to enter the building
	} else if (!isAllowedEntry(player)) {
		ejectObject(player);
		return;
	// Player is city banned from the city that this building belongs to
	} else if (isCivicStructure() && isCityBanned(player)) {
		ejectObject(player);
		player->sendSystemMessage("@city/city:youre_city_banned"); // you are banned from this city and may not use any of its public services and structures

		return;
	}

	// Player has entered the structure. Load objects in the structure for the player
	Reference<CreatureObject*> playerRef = player;

	for (int i = 0; i < cells.size(); ++i) {
		auto& cell = cells.get(i);

		if (cell == nullptr)
			continue;

		Core::getTaskManager()->scheduleTask([playerRef, cell] () {
			if (playerRef == nullptr || cell == nullptr)
				return;

			uint64 playerID = playerRef->getObjectID();

			// cell->info(true) << "Loading Cell ID: " << cell->getObjectID() << " for player " << playerRef->getDisplayedName();

			for (int j = 0; j < cell->getContainerObjectsSize(); ++j) {
				auto child = cell->getContainerObject(j);

				if (child == nullptr || child->getObjectID() == playerID)
					continue;

				if (child->getCloseObjects() != nullptr)
					child->addInRangeObject(playerRef, false);
				else
					child->notifyInsert(playerRef);

				child->sendTo(playerRef, true, false);

				if (playerRef->getCloseObjects() != nullptr)
					playerRef->addInRangeObject(child, false);
				else
					playerRef->notifyInsert(child);

				if (playerRef->getParent() != nullptr)
					playerRef->sendTo(child, true, false);
			}
		}, "LoadBuildingLambda", i * 200);
	}
}

void BuildingObjectImplementation::onExit(CreatureObject* player, uint64 parentid) {
	if (player == nullptr)
		return;

	if (getZone() == nullptr)
		return;

	removeTemplateSkillMods(player);

	unregisterProfessional(player);

	notifyObservers(ObserverEventType::EXITEDBUILDING, player, parentid);
}

uint32 BuildingObjectImplementation::getMaximumNumberOfPlayerItems() {
	if (isCivicStructure() )
		return 2500;

	SharedStructureObjectTemplate* ssot = dynamic_cast<SharedStructureObjectTemplate*> (templateObject.get());

	if (ssot == nullptr)
		return 0;
	//This sets the item limit for City Halls and Cloning Centers to 250 like they were during live, instead of 400 like they are now from the line below.

	uint8 lots = ssot->getLotSize();

	//Buildings that don't cost lots have MAXPLAYERITEMS storage space.
	if (lots == 0)
		return MAXPLAYERITEMS;

	auto maxItems = MAXPLAYERITEMS;

	return Math::min(maxItems, lots * 200);
}

int BuildingObjectImplementation::notifyObjectInsertedToChild(SceneObject* object, SceneObject* child, SceneObject* oldParent) {
	Zone* zone = getZone();

	Locker* _locker = nullptr;

	if (zone != nullptr)
		_locker = new Locker(zone);

	try {
		if (object->getCloseObjects() != nullptr)
			object->addInRangeObject(object, false);

		if (child->isCellObject()) {
			bool runInRange = true;

			if ((oldParent == nullptr || !oldParent->isCellObject()) || oldParent == child) {

				if (oldParent == nullptr || (oldParent != nullptr && dynamic_cast<Zone*>(oldParent) == nullptr && !oldParent->isCellObject())) {
					notifyObjectInsertedToZone(object);
					runInRange = false;
				}

				if (!object->isPlayerCreature()) {
					broadcastDestroy(object, true);
					broadcastObject(object, false);
				}
			}

			if (runInRange) {
				CellObject* cell = static_cast<CellObject*>(child);

				if (cell != nullptr) {
					for (int j = 0; j < cell->getContainerObjectsSize(); ++j) {
						ManagedReference<SceneObject*> cobj = cell->getContainerObject(j);

						if (cobj != object) {
							if (cobj->getCloseObjects() != nullptr) {
								if (!cobj->getCloseObjects()->contains(object)) {
									cobj->addInRangeObject(object, false);
									object->sendTo(cobj, true, false);
								}
							} else
								cobj->notifyInsert(object);

							if (object->getCloseObjects() != nullptr) {
								if (!object->getCloseObjects()->contains(cobj.get())) {
									object->addInRangeObject(cobj.get(), false);
									cobj->sendTo(object, true, false);//sendTo because notifyInsert doesnt send objects with parent
								} else {
									if (object->getClient() != nullptr && cobj->isCreatureObject()) {
										object->sendMessage(cobj->link(cell->getObjectID(), -1));
									}
								}
							} else {
								object->notifyInsert(cobj.get());
							}

						}
					}
				}
			}
		}

	} catch (Exception& e) {
		error(e.getMessage());
		e.printStackTrace();
	}

	if (zone != nullptr) {
		delete _locker;

		TangibleObject* tano = object->asTangibleObject();

		if (tano != nullptr) {
			zone->updateActiveAreas(tano);
		}
	}

	return 0;
}

int BuildingObjectImplementation::notifyObjectRemovedFromChild(SceneObject* object, SceneObject* child) {
	remove(object);

	return 0;
}

void BuildingObjectImplementation::destroyAllPlayerItems() {
	for (int i = 0; i < cells.size(); ++i) {
		auto& cell = cells.get(i);

		cell->destroyAllPlayerItems();
	}
}

void BuildingObjectImplementation::updateSignName(bool notifyClient)  {
	//TODO: Fix sign object to handle string id's.
	String condemned = "@player_structure:fix_condemned_title";
	UnicodeString signNameToSet = StringIdManager::instance()->getStringId(condemned.hashCode());

	if (!isCondemned()) {
		signNameToSet = signName;
	}

	if (signObject != nullptr) {
		signObject->setCustomObjectName(signNameToSet, notifyClient);
	}
}

bool BuildingObjectImplementation::isInPlayerCity() {
	ManagedReference<CityRegion*> city = this->getCityRegion().get();

	if (city != nullptr) {
		return (!city->isClientRegion());
	}

	return false;
}

bool BuildingObjectImplementation::canPlayerRegisterWithin() {
	const PlanetMapCategory* pmc = getPlanetMapCategory();

	if (pmc == nullptr)
		return false;

	String categoryName = pmc->getName();

	if (categoryName == "medicalcenter" || categoryName == "hotel" || categoryName == "cantina" || categoryName == "theater" || categoryName == "guild_theater" || categoryName == "tavern")
		return true;

	if (categoryName == "imperial" || categoryName == "rebel") {
		SharedBuildingObjectTemplate* buildingTemplate = cast<SharedBuildingObjectTemplate*>(getObjectTemplate());

		if (buildingTemplate == nullptr) {
			return false;
		}

		if (buildingTemplate->getSkillMod("private_medical_rating") > 0 || buildingTemplate->getSkillMod("private_med_battle_fatigue") > 0) {
			return true;
		}
	}

	return false;
}

void BuildingObjectImplementation::registerProfessional(CreatureObject* player) {
	if(!player->isPlayerCreature() || getZone() == nullptr)
		return;

	if(!registeredPlayerIdList.contains(player->getObjectID())) {

		// Check for improper faction situations ...
		if (player->isNeutral() && (!this->isNeutral())) {
			// "Neutrals may only register at neutral (non-aligned) locations."
			player->sendSystemMessage("@faction/faction_hq/faction_hq_response:no_neutrals");
			return;
		}

		if ((player->isImperial() && this->isRebel()) || (player->isRebel() && this->isImperial())) {
			// "You may not register at a location that is factionally opposed."
			player->sendSystemMessage("@faction/faction_hq/faction_hq_response:no_opposition");
			return;
		}

		if (getZone()->isObjectRegisteredWithPlanetaryMap(asBuildingObject())) {

			// Update the planetary map icon if needed
			if (registeredPlayerIdList.size() == 0) {
				getZone()->updatePlanetaryMapIcon(asBuildingObject(), 2);
			}

			registeredPlayerIdList.put(player->getObjectID());

			// "You successfully register with this location."
			player->sendSystemMessage("@faction/faction_hq/faction_hq_response:success");
		} else {
			// "You cannot register at a location that is not registered with the planetary map."
			player->sendSystemMessage("@faction/faction_hq/faction_hq_response:cannot_register");
		}

	}
	else {
		// "But you are already registered at this location."
		player->sendSystemMessage("@faction/faction_hq/faction_hq_response:already_registered");
	}
}

void BuildingObjectImplementation::unregisterProfessional(CreatureObject* player) {
	if(!player->isPlayerCreature() || getZone() == nullptr)
		return;

	if (registeredPlayerIdList.drop(player->getObjectID())) {
		if (registeredPlayerIdList.size() == 0) {
			if (getZone()->isObjectRegisteredWithPlanetaryMap(asBuildingObject())) {
				// Last Entertainer/Doctor out, set icon from star to a moon.
				getZone()->updatePlanetaryMapIcon(asBuildingObject(), 1);
			}
		}

		player->sendSystemMessage("You have been unregistered from your previously registered location.");
	}
}

void BuildingObjectImplementation::promptPayAccessFee(CreatureObject* player) {
	if(!player->isPlayerCreature())
		return;

	PlayerObject* ghost = player->getPlayerObject();

	if (ghost == nullptr)
		return;

	if (ghost->hasSuiBoxWindowType(SuiWindowType::STRUCTURE_CONSENT_PAY_ACCESS_FEE))
		return;

	ManagedReference<SuiMessageBox*> box = new SuiMessageBox(player, SuiWindowType::STRUCTURE_CONSENT_PAY_ACCESS_FEE);
	box->setPromptTitle("@player_structure:access_fee_t");
	box->setPromptText("You must pay a fee of " + String::valueOf(accessFee) + " credits to enter this building");
	box->setUsingObject(asBuildingObject());
	box->setForceCloseDistance(30.f);
	box->setCallback(new StructurePayAccessFeeSuiCallback(server->getZoneServer()));

	ghost->addSuiBox(box);
	player->sendMessage(box->generateMessage());
}

void BuildingObjectImplementation::payAccessFee(CreatureObject* player) {
	Locker accessLock(&paidAccessListMutex);

	if (paidAccessList.contains(player->getObjectID())) {
		uint32 expireTime = paidAccessList.get(player->getObjectID());

		if(expireTime > time(0)) {
			return;
		}
	}

	if (player->getCashCredits() < accessFee) {
		player->sendSystemMessage("@player/player_utility:not_enough_money");
		return;
	}

	ManagedReference<CreatureObject*> owner = getOwnerCreatureObject();

	TransactionLog trx(player, owner, TrxCode::ACCESSFEE, accessFee, true);
	trx.setAutoCommit(false);

	player->subtractCashCredits(accessFee);

	if (owner != nullptr) {
		Locker clocker(owner, player);
		owner->addBankCredits(accessFee, true);
	} else {
		error("Unable to pay access fee credits to owner");
		trx.errorMessage() << "Unable to pay access fee to owner";
	}

	trx.commit();

	if (paidAccessList.contains(player->getObjectID()))
		paidAccessList.drop(player->getObjectID());

	paidAccessList.put(player->getObjectID(), time(0) + (accessDuration * 60));

	accessLock.release();

	if (owner != nullptr && owner->isPlayerCreature()) {
		Locker clocker(owner, player);

		PlayerObject* ghost = owner->getPlayerObject();

		if (ghost != nullptr) {
			TransactionLog trxExperience(TrxCode::EXPERIENCE, owner);
			trxExperience.groupWith(trx);
			ghost->addExperience(trxExperience, "merchant", 50, true);
		}
	}

	updatePaidAccessList();

	player->sendSystemMessage("@player/player_utility:access_granted");
}

void BuildingObjectImplementation::setAccessFee(int fee, int duration) {
	Locker accessLock(&paidAccessListMutex);

	accessFee = fee;
	accessDuration = duration;
	lastAccessFeeChange = time(0);
}

bool BuildingObjectImplementation::canChangeAccessFee() {
	// 10 Minutes between changes
	return lastAccessFeeChange + 600  < time(0);
}

int BuildingObjectImplementation::getAccessFeeDelay() {
	int secondsLeft = lastAccessFeeChange + 600  - time(0);
	return (secondsLeft / 60) + 1;
}

void BuildingObjectImplementation::updatePaidAccessList() {
	Vector<uint64> ejectList;
	uint32 nextExpirationTime = 0;

	Locker accessLock(&paidAccessListMutex);

	for (int i = 0; i < paidAccessList.size(); ++i) {
		uint32 expirationTime = paidAccessList.elementAt(i).getValue();
		if (expirationTime <= time(0)) {
			ejectList.add(paidAccessList.elementAt(i).getKey());
		}

		if (nextExpirationTime == 0 || nextExpirationTime > expirationTime)
			nextExpirationTime = expirationTime;
	}

	for (int i = 0; i < ejectList.size(); ++i) {
		paidAccessList.drop(ejectList.get(i));
		ManagedReference<CreatureObject*> creature = server->getZoneServer()->getObject(ejectList.get(i)).castTo<CreatureObject*>();
		if (creature != nullptr && creature->getRootParent() == asBuildingObject()) {
			creature->sendSystemMessage("@player_structure:turnstile_expire"); // You have been ejected because your access expired
			ejectObject(creature);
		}
	}

	Reference<Task*> pendingTask = getPendingTask("revokepaidstructureaccess");

	if (paidAccessList.isEmpty()) {
		if(pendingTask != nullptr && pendingTask->isScheduled()) {
			pendingTask->cancel();
		}
		removePendingTask("revokepaidstructureaccess");
		return;
	}

	int timeToSchedule = (nextExpirationTime - time(0)) * 1000;

	if (pendingTask == nullptr) {
		pendingTask = new RevokePaidAccessTask(asBuildingObject());
		addPendingTask("revokepaidstructureaccess", pendingTask, timeToSchedule);
	} else {
		pendingTask->reschedule(timeToSchedule);
	}
}

void BuildingObjectImplementation::createChildObjects() {
	if (!isGCWBase()) {
		StructureObjectImplementation::createChildObjects();
		return;
	}

	int controlIndex = 0;

	SharedObjectTemplate* serverTemplate = getObjectTemplate();

	if (serverTemplate == nullptr) {
		return;
	}

	Vector3 position = getPosition();

	ZoneServer* server = getZoneServer();

	if (server == nullptr) {
		return;
	}

	auto thisZone = getZone();

	if (thisZone == nullptr) {
		return;
	}

	GCWManager* gcwMan = thisZone->getGCWManager();

	if (gcwMan == nullptr) {
		return;
	}

	for (int i = 0; i < serverTemplate->getChildObjectsSize();i++) {
		const ChildObject* child = serverTemplate->getChildObject(i);

		if (child == nullptr) {
			continue;
		}

		String templateString = child->getTemplateFile();

		SharedObjectTemplate* thisTemplate = TemplateManager::instance()->getTemplate(templateString.hashCode());

		if (thisTemplate == nullptr) {
			continue;
		}

		int objectType = thisTemplate->getGameObjectType();

		if (objectType == SceneObjectType::NPCCREATURE || objectType == SceneObjectType::CREATURE) {
			continue;
		}

		if (templateString.contains("alarm_") && !gcwMan->shouldSpawnBaseAlarms()) {
			continue;
		// Minefields are not placed when the base is created, they must be donated by players
		} else if (objectType == SceneObjectType::MINEFIELD) {
			gcwMan->addMinefield(asBuildingObject(), nullptr);
			continue;
		}

		bool spawnDefenses = gcwMan->shouldSpawnDefenses();

		// Prevent Scanners from spawning from GCW base templates if covert/overt system is disabled
		if (objectType == SceneObjectType::COVERTSCANNER) {
			if (!ConfigManager::instance()->useCovertOvertSystem()) {
				continue;
			} else if (!spawnDefenses) {
				gcwMan->addScanner(asBuildingObject(), nullptr);
				continue;
			}
		// Child object is a turret but bases should not spawn defenses, add the slot and continue the list
		} else if (thisTemplate->getDataObjectComponent().hashCode() == STRING_HASHCODE("TurretDataComponent") && !spawnDefenses) {
			gcwMan->addTurret(asBuildingObject(), nullptr);
			continue;
		}

		String dbString = "sceneobjects";

		if (objectType == SceneObjectType::DESTRUCTIBLE || objectType == SceneObjectType::STATICOBJECT) {
			dbString = "playerstructures";
		}

		ManagedReference<SceneObject*> obj = server->createObject(templateString.hashCode(), dbString, getPersistenceLevel());

		if (obj == nullptr) {
			continue;
		}

		Locker crossLocker(obj, asBuildingObject());

		if (obj->isCreatureObject()) {
			obj->destroyObjectFromDatabase(true);
			continue;
		}

		Vector3 childPosition = child->getPosition();
		childObjects.put(obj);

		obj->initializePosition(childPosition.getX(), childPosition.getZ(), childPosition.getY());
		obj->setDirection(child->getDirection());
		obj->initializeChildObject(asBuildingObject());

		// Place child Objects inside cells
		if (child->getCellId() > 0) {
			int totalCells = getTotalCellNumber();

			try {
				if (totalCells >= child->getCellId()) {
					CellObject* cellObject = getCell(child->getCellId());

					if (cellObject != nullptr) {
						if (!cellObject->transferObject(obj, child->getContainmentType(), true)) {
							obj->destroyObjectFromDatabase(true);
						} else if (templateString.contains("alarm_")) {
							gcwMan->addBaseAlarm(asBuildingObject(), obj);
						}
					} else {
						obj->destroyObjectFromDatabase(true);
						error("nullptr CELL OBJECT");
					}
				}
			} catch (Exception& e) {
				error("unreported exception caught in void BuildingObjectImplementation::createChildObjects()!");
				e.printStackTrace();
			}
		// Place exterior child objects
		} else {
			float angle = getDirection()->getRadians();
			float x = (Math::cos(angle) * childPosition.getX()) + (childPosition.getY() * Math::sin(angle));
			float y = (Math::cos(angle) * childPosition.getY()) - (childPosition.getX() * Math::sin(angle));
			x += position.getX();
			y += position.getY();

			float z = position.getZ() + childPosition.getZ();
			float degrees = getDirection()->getDegrees();

			Quaternion dir = child->getDirection();

			obj->initializePosition(x, z, y);
			obj->setDirection(dir.rotate(Vector3(0, 1, 0), degrees));

			if (obj->isTurret() || obj->isMinefield()) {
				obj->createChildObjects();
			}

			thisZone->transferObject(obj, -1, true);
		}

		if (obj->isTurretControlTerminal()) {
			DataObjectComponentReference* data  = obj->getDataObjectComponent();
			if (data != nullptr) {
				TurretControlTerminalDataComponent* controlData = cast<TurretControlTerminalDataComponent*>(data->get());
				if (controlData != nullptr) {
					controlData->setTurretIndex(controlIndex);
					controlIndex++;
				}
			}
		}

		ContainerPermissions* permissions = obj->getContainerPermissionsForUpdate();
		permissions->setOwner(getObjectID());
		permissions->setInheritPermissionsFromParent(false);
		permissions->setDefaultDenyPermission(ContainerPermissions::MOVECONTAINER);
		permissions->setDenyPermission("owner", ContainerPermissions::MOVECONTAINER);

		if (obj->isTurret() || obj->isMinefield() || obj->isScanner()) {
			TangibleObject* tano = cast<TangibleObject*>(obj.get());

			if (tano != nullptr) {
				tano->setFaction(getFaction());
				tano->setPvpStatusBitmask(getPvpStatusBitmask() | tano->getPvpStatusBitmask());
			}

			InstallationObject* installation = cast<InstallationObject*>(obj.get());

			if (installation != nullptr) {
				installation->setOwner(getObjectID());
			}

			if (gcwMan != nullptr) {
				if (obj->isTurret())
					gcwMan->addTurret(asBuildingObject(), obj);
				else if (obj->isMinefield())
					gcwMan->addMinefield(asBuildingObject(), obj);
				else if (obj->isScanner())
					gcwMan->addScanner(asBuildingObject(), obj);

			} else {
				info("ERROR: Unable to add faction installation to gCWmanager",true);
			}
		}
	}
}

void BuildingObjectImplementation::spawnChildSceneObject(String& templatePath, float x, float z, float y, unsigned long long cellID, float dw, float dx, float dy, float dz) {
	ZoneServer* zoneServer = getZoneServer();

	if (zoneServer == nullptr)
		return;

	Zone* zone = asBuildingObject()->getZone();

	if (zone == nullptr)
		return;

	ManagedReference<SceneObject*> object = zoneServer->createObject(templatePath.hashCode(), getPersistenceLevel());

	if (object == nullptr || object->isCreatureObject())
		return;

	Locker objLocker(object);

	object->initializePosition(x, z, y);
	object->setDirection(dw, dx, dy, dz);

	Reference<SceneObject*> cell = nullptr;

	if (cellID != 0) {
		cell = zoneServer->getObject(cellID);

		if (cell != nullptr && !cell->isCellObject()) {
			cell = nullptr;
		}
	}

	if (cell != nullptr) {
		cell->transferObject(object, -1);
	} else {
		zone->transferObject(object, -1, true);
	}

	object->createChildObjects();

	childObjects.put(object);
}

void BuildingObjectImplementation::spawnChildCreaturesFromTemplate() {
	SharedBuildingObjectTemplate* buildingTemplate = cast<SharedBuildingObjectTemplate*>(getObjectTemplate());

	if (buildingTemplate == nullptr)
		return;

	CreatureManager* creatureManager = zone->getCreatureManager();
	if (creatureManager == nullptr)
		return;

	for (int i = 0; i < buildingTemplate->getChildCreatureObjectsSize(); i++) {
		ChildCreatureObject* child = buildingTemplate->getChildCreatureObject(i);
		CreatureObject* creature = nullptr;

		if (child != nullptr) {
			Vector3 childPosition = child->getPosition();

			// if it's inside
			if (child->getCellId() > 0) {
				int totalCells = getTotalCellNumber();

				try {
					if (totalCells >= child->getCellId()) {
						ManagedReference<CellObject*> cellObject = getCell(child->getCellId());
						if (cellObject != nullptr) {
							creature = creatureManager->spawnCreatureWithAi(child->getMobile().hashCode(), childPosition.getX(), childPosition.getZ(), childPosition.getY(), cellObject->getObjectID(), false);

							if (creature == nullptr) {
								error () << "Failed to spawn Creature in Cell in spawnChildCreaturesFromTemplate: Template = " << child->getMobile() << " X = " << childPosition.getX() << " Z = " << childPosition.getZ() << " Y = " << childPosition.getY() << " Cell ID: " << cellObject->getObjectID();
							}
						} else {
							error("nullptr CELL OBJECT");
						}
					}

				} catch (Exception& e) {
					error("unreported exception caught in void BuildingObjectImplementation::spawnChildCreaturesFromTemplate()!");
					e.printStackTrace();
				}

			} else { // create the creature outside
				String mobilename = child->getMobile();
				float angle = getDirection()->getRadians();

				float x = (Math::cos(angle) * childPosition.getX()) + (childPosition.getY() * Math::sin(angle));
				float y = (Math::cos(angle) * childPosition.getY()) - (childPosition.getX() * Math::sin(angle));

				x += getPosition().getX();
				y += getPosition().getY();

				float z = getPosition().getZ() + childPosition.getZ();
				float degrees = getDirection()->getDegrees();

				creature = creatureManager->spawnCreatureWithAi(mobilename.hashCode(), x, z, y, 0, false);
			}

			if (creature == nullptr)
				continue;

			Locker clocker(creature, asBuildingObject());

			creature->updateDirection(child->getHeading());

			if (creature->isAiAgent()) {
				AiAgent* ai = cast<AiAgent*>(creature);
				ai->setRespawnTimer(child->getRespawnTimer());

				if (isGCWBase()) {
					if (getPvpStatusBitmask() & ObjectFlag::OVERT) {
						creature->setFactionStatus(FactionStatus::OVERT);
					} else {
						creature->setFactionStatus(FactionStatus::COVERT);
					}
				}
			}

			childCreatureObjects.put(creature);
		}
	}
}

void BuildingObjectImplementation::spawnChildCreature(String& mobile, int respawnTimer, float x, float z, float y, float heading, unsigned long long cellID) {
	CreatureManager* creatureManager = zone->getCreatureManager();

	if (creatureManager == nullptr)
		return;

	CreatureObject* creature = creatureManager->spawnCreatureWithAi(mobile.hashCode(), x, z, y, cellID, false);

	if (creature == nullptr)
		return;

	Locker clocker(creature, asBuildingObject());

	creature->updateDirection(Math::deg2rad(heading));

	if (creature->isAiAgent()) {
		AiAgent* ai = cast<AiAgent*>(creature);
		ai->setRespawnTimer(respawnTimer);
	}

	childCreatureObjects.put(creature);
}

bool BuildingObjectImplementation::hasTemplateChildCreatures() const {
	SharedBuildingObjectTemplate* buildingTemplate = cast<SharedBuildingObjectTemplate*>(getObjectTemplate());

	if (buildingTemplate == nullptr)
		return false;

	return buildingTemplate->getChildCreatureObjectsSize() > 0;
}

void BuildingObjectImplementation::destroyChildObjects() {
	int size = childObjects.size();

	for (int i = 0; i < size; i++) {
		ManagedReference<SceneObject*> child = childObjects.get(0);

		if (child == nullptr)
			continue;

		Locker clocker(child, asBuildingObject());

		childObjects.drop(child);
		child->destroyObjectFromDatabase(true);
		child->destroyObjectFromWorld(true);
	}

	size = childCreatureObjects.size();

	for (int i = 0; i < size; i++) {
		ManagedReference<CreatureObject*> child = childCreatureObjects.get(0);

		if (child == nullptr)
			continue;

		Locker clocker(child, asBuildingObject());

		if (child->isAiAgent()) {
			AiAgent* ai = cast<AiAgent*>(child.get());
			ai->setRespawnTimer(0);
		}

		childCreatureObjects.drop(child);
		child->destroyObjectFromWorld(true);
	}
}

void BuildingObjectImplementation::changeSign(const SignTemplate* signConfig) {
	if (signConfig == nullptr)
		return;

	if (getZone() == nullptr)
		return;

	ZoneServer* zoneServer = getZone()->getZoneServer();

	ManagedReference<SceneObject*> signSceno = zoneServer->createObject(signConfig->getTemplateFile().hashCode(), getPersistenceLevel());
	if (signSceno == nullptr)
		return;

	if (!signSceno->isSignObject()) {
		signSceno->destroyObjectFromDatabase(true);
		return;
	}

	ManagedReference<SignObject*> signObject = signSceno.castTo<SignObject*>();
	if (signObject == nullptr) {
		signSceno->destroyObjectFromDatabase(true);
		return;
	}

	Locker clocker(signObject, asBuildingObject());

	Vector3 signPosition = signConfig->getPosition();
	childObjects.put(signSceno);
	signObject->initializePosition(signPosition.getX(), signPosition.getZ(), signPosition.getY());
	signObject->setDirection(signConfig->getDirection());

	//Create the object outdoors in relation to parent structure.
	Vector3 position = getPosition();

	float angle = direction.getRadians();

	float x = (Math::cos(angle) * signPosition.getX()) + (signPosition.getY() * Math::sin(angle));
	float y = (Math::cos(angle) * signPosition.getY()) - (signPosition.getX() * Math::sin(angle));

	x += position.getX();
	y += position.getY();

	float z = position.getZ() + signPosition.getZ();

	float degrees = direction.getDegrees();

	Quaternion dir = signConfig->getDirection();

	signObject->initializePosition(x, z, y);
	signObject->setDirection(dir.rotate(Vector3(0, 1, 0), degrees));

	getZone()->transferObject(signObject, -1, true);

	// Set sign permissions
	ContainerPermissions* permissions = signSceno->getContainerPermissionsForUpdate();
	permissions->setOwner(getObjectID());
	permissions->setInheritPermissionsFromParent(false);
	permissions->setDefaultDenyPermission(ContainerPermissions::MOVECONTAINER);
	permissions->setDenyPermission("owner", ContainerPermissions::MOVECONTAINER);

	clocker.release();

	// Remove old sign (but save its name)
	UnicodeString signName = "@sign_name:sign";
	SignObject* oldSign = getSignObject();

	if (oldSign != nullptr) {
		signName = oldSign->getCustomObjectName();

		Locker clock(oldSign, asBuildingObject());

		if (childObjects.contains(oldSign)) {
			childObjects.removeElement(oldSign);
		}

		oldSign->destroyObjectFromWorld(true);
		oldSign->destroyObjectFromDatabase(true);
	}

	Locker clocker2(signObject, asBuildingObject());

	// Finish initializing new sign
	signObject->initializeChildObject(asBuildingObject());  // should call BuildingObject::setSignObject

	// Set to old sign name
	setCustomObjectName( signName, true );
}

bool BuildingObjectImplementation::togglePrivacy() {
	// If the building is a cantina then we need to add/remove it from the planet's
	// mission map for performance locations.
	const PlanetMapCategory* planetMapCategory = getPlanetMapCategory();
	if (planetMapCategory != nullptr) {
		String planetMapCategoryName = planetMapCategory->getName();
		if (planetMapCategoryName == "cantina") {
			Zone* zone = getZone();
			if (zone != nullptr) {
				PlanetManager* planetManager = zone->getPlanetManager();
				if (planetManager != nullptr) {
					if (isPublicStructure()) {
						planetManager->removePerformanceLocation(asSceneObject());
					}
					else {
						planetManager->addPerformanceLocation(asSceneObject());
					}
				}
			}
		}
	}

	publicStructure = !publicStructure;
	return isPublicStructure();
}

BuildingObject* BuildingObject::asBuildingObject() {
	return this;
}

BuildingObject* BuildingObjectImplementation::asBuildingObject() {
	return _this.getReferenceUnsafeStaticCast();
}

Vector<Reference<MeshData*> > BuildingObjectImplementation::getTransformedMeshData(const Matrix4* parentTransform) const {
	Vector<Reference<MeshData*> > data;

	Quaternion directionRecast(direction.getW(), direction.getX(), direction.getY(), -direction.getZ());

	Matrix4 transform;
	transform.setRotationMatrix(directionRecast.toMatrix3());
	transform.setTranslation(getPositionX(), getPositionZ(), -getPositionY());

	const auto fullTransform = transform * *parentTransform;

	const PortalLayout *pl = getObjectTemplate()->getPortalLayout();
	if(pl) {
		if(pl->getCellTotalNumber() > 0) {
			const AppearanceTemplate *appr = pl->getAppearanceTemplate(0);
			const FloorMesh *floor = TemplateManager::instance()->getFloorMesh(appr->getFloorMesh());

			if (floor == nullptr) {
				floor = pl->getFloorMesh(0);
			}

			if (floor != nullptr) {
				data.addAll(floor->getTransformedMeshData(fullTransform));
			}

#ifndef RENDER_EXTERNAL_FLOOR_MESHES_ONLY
			data.addAll(appr->getTransformedMeshData(fullTransform));
#endif
			const CellProperty* tmpl = pl->getCellProperty(0);

			for (int i = 0; i < tmpl->getNumberOfPortals(); i++) {
				const CellPortal* portal = tmpl->getPortal(i);
				const MeshData* mesh = pl->getPortalGeometry(portal->getGeometryIndex());

				data.emplace(MeshData::makeCopyNegateZ(mesh, fullTransform));
			}

#ifdef RENDER_EXTERNAL_FLOOR_MESHES_ONLY
			return data;
#endif
		}
	}
	data.addAll(SceneObjectImplementation::getTransformedMeshData(parentTransform));
	return data;
}

const BaseBoundingVolume* BuildingObjectImplementation::getBoundingVolume() {
	const PortalLayout *pl = getObjectTemplate()->getPortalLayout();

	if(pl) {
		if(pl->getCellTotalNumber() > 0) {
			const AppearanceTemplate *appr = pl->getAppearanceTemplate(0);
			return appr->getBoundingVolume();
		}
	} else {
		return SceneObjectImplementation::getBoundingVolume();
	}

	return nullptr;
}

bool BuildingObject::isBuildingObject() {
	return true;
}

bool BuildingObjectImplementation::isBuildingObject() {
	return true;
}

float BuildingObjectImplementation::getOutOfRangeDistance(uint64 specialRangeID) {
#ifdef COV_BUILDING_QUAD_RANGE
	return ZoneServer::CLOSEOBJECTRANGE * 4;
#else // COV_BUILDING_QUAD_RANGE
	return ZoneServer::CLOSEOBJECTRANGE + getBoundingRadius();
#endif // COV_BUILDING_QUAD_RANGE
}

String BuildingObjectImplementation::getCellName(uint64 cellID) const {
	SharedBuildingObjectTemplate* buildingTemplate = templateObject.castTo<SharedBuildingObjectTemplate*>();

	if (buildingTemplate == nullptr)
		return "";

	const PortalLayout* portalLayout = buildingTemplate->getPortalLayout();

	if (portalLayout == nullptr)
		return "";

	const CellProperty* cellProperty = portalLayout->getCellProperty(cellID);

	if (cellProperty == nullptr)
		return "";

	return cellProperty->getName();
}
