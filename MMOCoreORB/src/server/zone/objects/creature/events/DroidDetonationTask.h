/*
				Copyright <SWGEmu>
		See file COPYING for copying conditions.*/

#ifndef DROIDEFFECTSTASK_H_
#define DROIDEFFECTSTASK_H_

#include "server/zone/objects/building/BuildingObject.h"
#include "server/zone/objects/creature/ai/DroidObject.h"
#include "server/zone/objects/tangible/components/droid/DroidDetonationModuleDataComponent.h"
#include "server/zone/objects/creature/CreatureObject.h"
#include "server/zone/objects/player/PlayerObject.h"
#include "server/zone/managers/collision/CollisionManager.h"
#include "server/zone/managers/combat/CombatManager.h"
#include "server/zone/packets/object/PlayClientEffectObjectMessage.h"
#include "server/zone/packets/scene/PlayClientEffectLocMessage.h"
#include "server/zone/Zone.h"
#include "server/zone/objects/intangible/PetControlDevice.h"

namespace server {
namespace zone {
namespace objects {
namespace creature {
namespace events {

class DroidDetonationTask : public Task, public Logger {
private:
	Reference<DroidDetonationModuleDataComponent*> module;
	ManagedReference<CreatureObject*> player;
	int detonationStep;

public:
	DroidDetonationTask(DroidDetonationModuleDataComponent* module, CreatureObject* player) : Task() {
		this->module = module;
		this->player = player;
		detonationStep = 0;
	}

	void run() {
		if (module == nullptr || player == nullptr) {
			return;
		}

		ManagedReference<DroidObject*> droid = module->getDroidObject();

		if (droid == nullptr) {
			return;
		}

		Locker locker(droid);
		Locker crossLocker(player, droid);

		auto zone = droid->getLocalZone();

		// Check if droid is spawned
		if (zone == nullptr) {
			ManagedReference<SceneObject*> parent = droid->getParent().get();

			if (parent == nullptr || !parent->isCellObject()) { // Not indoors either
				droid->removePendingTask("droid_detonation");
				return;
			}
		}

		if (droid->isDead() || droid->isIncapacitated()) {
			module->stopCountDown();
			droid->showFlyText("pet/droid_modules", "detonation_disabled", 204, 0, 0);
			module->deactivate();
			droid->removePendingTask("droid_detonation");
			return;
		}

		// if droid gets incapped while started it will disable but be able to be restarted
		switch (detonationStep) {
			case 0: {
				// 3
				droid->showFlyText("pet/droid_modules", "countdown_3", 204, 0, 0);
				detonationStep = 1;
				reschedule(1000);
				break;
			}
			case 1: {
				// 2
				droid->showFlyText("pet/droid_modules", "countdown_2", 204, 0, 0);
				detonationStep = 2;
				reschedule(1000);
				break;
			}
			case 2: {
				// 1
				droid->showFlyText("pet/droid_modules", "countdown_1", 204, 0, 0);
				detonationStep = 3;
				reschedule(1000);
				break;
			}
			case 3: {
				// Detonate Droid
				bool shouldGcwCrackdownTef = false, shouldGcwTef = false, shouldBhTef = false;

				// find all valid targets in 17 m range and hit them with the damage
				CloseObjectsVector* vec = (CloseObjectsVector*)droid->getCloseObjects();
				SortedVector<ManagedReference<TreeEntry*>> closeObjects;

				if (vec != nullptr) {
					closeObjects.removeAll(vec->size(), 10);
					vec->safeCopyTo(closeObjects);
				} else {
#ifdef COV_DEBUG
					droid->info("Null closeobjects vector in DroudDetonationTask::run", true);
#endif
					zone->getInRangeObjects(droid->getWorldPositionX(), droid->getWorldPositionZ(), droid->getWorldPositionY(), 40, &closeObjects, true);
				}

				PlayClientEffectLoc* explodeLoc = new PlayClientEffectLoc("clienteffect/combat_explosion_lair_large.cef", zone->getZoneName(), droid->getPositionX(), droid->getPositionZ(), droid->getPositionY());
				droid->broadcastMessage(explodeLoc, false);

				crossLocker.release();

				for (int i = 0; i < closeObjects.size(); ++i) {
					ManagedReference<SceneObject*> object = cast<SceneObject*>(closeObjects.get(i).get());

					if (!object->isCreatureObject() || object == droid) {
						continue;
					}

					CreatureObject* creo = object->asCreatureObject();

					if (creo == nullptr || creo->isDead() || !creo->isAttackableBy(droid) || !droid->isInRange(object, 17)) {
						continue;
					}

					if (creo->isIncapacitated() && !creo->isFeigningDeath()) {
						continue;
					}

					uint64 tarParentID = object->getParentID();

					if (player->isPlayerCreature() && tarParentID != 0 && player->getParentID() != tarParentID) {
						Reference<CellObject*> targetCell = object->getParent().get().castTo<CellObject*>();

						if (targetCell != nullptr) {
							ManagedReference<SceneObject*> parentSceneObject = targetCell->getParent().get();

							if (parentSceneObject != nullptr) {
								BuildingObject* building = parentSceneObject->asBuildingObject();

								if (building != nullptr && !building->isAllowedEntry(player)) {
									continue;
								}
							}

							const ContainerPermissions* perms = targetCell->getContainerPermissions();

							// This portion of the check is specific for locked dungeons doors since they do not inherit perms from parent
							if (!perms->hasInheritPermissionsFromParent() && (player->getRootParent() == object->getRootParent())) {
								if (!targetCell->checkContainerPermission(player, ContainerPermissions::WALKIN)) {
									continue;
								}
							}
						}
					}

					try {
						Locker defenderLocker(creo, droid);

						// apply the damage to the target and send themessage
						if (CollisionManager::checkLineOfSight(object, droid)) {
							// apply the damage
							float amount = CombatManager::instance()->doObjectDetonation(droid, creo, module->calculateDamage(droid));

							if (amount > 0) {
								if (creo->isPlayerCreature()) {
									StringIdChatParameter stringId;
									stringId.setStringId("@pet/droid_modules:hit_by_detonation");
									stringId.setDI((int)amount);
									creo->sendSystemMessage(stringId);
								}

								StringIdChatParameter tomaster;
								tomaster.setStringId("@pet/droid_modules:hit_by_detonation_master");
								tomaster.setTT(object->getObjectID());
								tomaster.setDI((int)amount);
								player->sendSystemMessage(tomaster);

								CombatManager::instance()->checkForTefs(player, creo, &shouldGcwCrackdownTef, &shouldGcwTef, &shouldBhTef);
							}
						}
					} catch (Exception& e) {
						error(e.getMessage());
					} catch (...) {
						throw;
					}
				}

				droid->removePendingTask("droid_detonation");

				Locker clocker(player, droid);

				// nuke the droid from the world
				ManagedReference<PetControlDevice*> petControlDevice = droid->getControlDevice().get().castTo<PetControlDevice*>();
				if (petControlDevice != nullptr) {
					Locker deviceLocker(petControlDevice);

					petControlDevice->storeObject(player, true);

					petControlDevice->destroyObjectFromWorld(true);
					petControlDevice->destroyObjectFromDatabase(true);
				}

				// Update PvP TEF Duration
				if (shouldGcwCrackdownTef || shouldGcwTef || shouldBhTef) {
					PlayerObject* ghost = player->getPlayerObject();

					if (ghost != nullptr) {
						ghost->updateLastCombatActionTimestamp(shouldGcwCrackdownTef, shouldGcwTef, shouldBhTef);
					}
				}

				break;
			}
		}
	}
};

} // namespace events
} // namespace creature
} // namespace objects
} // namespace zone
} // namespace server

using namespace server::zone::objects::creature::events;

#endif /*DROIDEFFECTSTASK_H_*/
