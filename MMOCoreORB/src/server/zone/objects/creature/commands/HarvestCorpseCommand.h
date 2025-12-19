#ifndef HARVESTCORPSECOMMAND_H_
#define HARVESTCORPSECOMMAND_H_

#include "server/zone/objects/scene/SceneObject.h"
#include "server/zone/objects/creature/ai/Creature.h"
#include "server/zone/managers/creature/CreatureManager.h"
#include "server/zone/Zone.h"

class HarvestCorpseCommand : public QueueCommand {
public:

    HarvestCorpseCommand(const String& name, ZoneProcessServer* server)
        : QueueCommand(name, server) {

    }

    int doQueueCommand(CreatureObject* creature, const uint64& target, const UnicodeString& arguments) const {

        if (!checkStateMask(creature))
            return INVALIDSTATE;

        if (!checkInvalidLocomotions(creature))
            return INVALIDLOCOMOTION;

        if (!creature->isPlayerCreature())
            return INVALIDTARGET;

        ManagedReference<SceneObject* > object = server->getZoneServer()->getObject(target);

        ManagedReference<CreatureObject*> player = cast<CreatureObject*>(creature);

        StringTokenizer args(arguments.toString());

        if (object == nullptr || !object->isCreatureObject() || player == nullptr)
            return INVALIDTARGET;

        CreatureObject* creo = cast<CreatureObject*>( object.get());

        if (!creo->isCreature())
            return INVALIDTARGET;

        Creature* cr = cast<Creature*>( creo);

        // support "area" / "all" semantics similar to LootCommand.h (32 unit range)
        bool harvestArea = arguments.toString().beginsWith("area");
        bool harvestAll = arguments.toString().beginsWith("all");

        // Read optional resource token. If area/all is used and a token follows
        // (e.g. "area meat") treat the second token as the global token. Otherwise
        // the first token is the token for single-target harvest.
        String harvesttype = "";
        if (args.hasMoreTokens()) {
            String first;
            args.getStringToken(first);
            first = first.toLowerCase();
            if ((harvestArea && first == "area") || (harvestAll && first == "all")) {
                if (args.hasMoreTokens()) {
                    args.getStringToken(harvesttype);
                    harvesttype = harvesttype.toLowerCase();
                }
            } else {
                harvesttype = first;
            }
        }

        // Single-target harvest (existing behavior, unchanged semantics)
        if (!harvestArea) {
            byte type = 0;
            if (harvesttype == "meat" && !cr->getMeatType().isEmpty())
                type = 234;
            else if (harvesttype == "hide" && !cr->getHideType().isEmpty())
                type = 235;
            else if (harvesttype == "bone" && !cr->getBoneType().isEmpty())
                type = 236;
            else {
                if (harvesttype != "") {
                    player->sendSystemMessage("@error_message:no_resource");
                    return GENERALERROR;
                }
                Vector<int> types;
                if (!cr->getMeatType().isEmpty())
                    types.add(234);
                if (!cr->getHideType().isEmpty())
                    types.add(235);
                if (!cr->getBoneType().isEmpty())
                    types.add(236);
                if (types.size() > 0)
                    type = types.get(System::random(types.size() - 1));
            }

            if (type == 0) {
                player->sendSystemMessage("This creature has no resources");
                return GENERALERROR;
            }

            Locker clocker(cr, player);
            if (cr->canHarvestMe(player)) {
                if (!cr->isDead())
                    return GENERALERROR;
                if (cr->getZone() == nullptr)
                    return GENERALERROR;
                if (cr->getDnaState() == CreatureManager::DNADEATH) {
                    player->sendSystemMessage("@skl_use:nothing_to_harvest");
                    return GENERALERROR;
                }
                ManagedReference<CreatureManager*> manager = cr->getZone()->getCreatureManager();
                manager->harvest(cr, player, type);
            }
            return SUCCESS;
        }

        // Area / All harvests
        Zone* zone = creature->getZone();
        if (zone == nullptr)
            return GENERALERROR;

        SortedVector<TreeEntry*> closeObjects;
        CloseObjectsVector* closeObjectsVector = (CloseObjectsVector*)creature->getCloseObjects();
        if (closeObjectsVector == nullptr) {
            zone->getInRangeObjects(creature->getPositionX(), creature->getPositionZ(), creature->getPositionY(), 80, &closeObjects, true);
        } else {
            closeObjectsVector->safeCopyTo(closeObjects);
        }

        for (int i = 0; i < closeObjects.size(); ++i) {
            SceneObject* targetObject = cast<SceneObject*>(closeObjects.get(i));
            if (targetObject == nullptr || !targetObject->isCreatureObject())
                continue;

            CreatureObject* targetCreo = cast<CreatureObject*>(targetObject);
            if (targetCreo == nullptr || !targetCreo->isCreature())
                continue;

            Creature* corpse = cast<Creature*>(targetCreo);

            if (!corpse->isDead())
                continue;

            if (!checkDistance(corpse, creature, 32))
                continue;

            Locker locker(corpse, player);

            if (!corpse->canHarvestMe(player)) {
                locker.release();
                continue;
            }

            if (corpse->getZone() == nullptr) {
                locker.release();
                continue;
            }

            if (corpse->getDnaState() == CreatureManager::DNADEATH) {
                locker.release();
                continue;
            }

            // Determine type for this corpse: use global token (harvesttype) for all
            // if provided; otherwise select a random available resource for each corpse.
            byte corpseType = 0;
            if (harvesttype != "") {
                if (harvesttype == "meat" && !corpse->getMeatType().isEmpty())
                    corpseType = 234;
                else if (harvesttype == "hide" && !corpse->getHideType().isEmpty())
                    corpseType = 235;
                else if (harvesttype == "bone" && !corpse->getBoneType().isEmpty())
                    corpseType = 236;
                else {
                    // global token requested but not present on this corpse -> fallback to random per-corpse
                    Vector<int> types;
                    if (!corpse->getMeatType().isEmpty())
                        types.add(234);
                    if (!corpse->getHideType().isEmpty())
                        types.add(235);
                    if (!corpse->getBoneType().isEmpty())
                        types.add(236);
                    if (types.size() > 0)
                        corpseType = types.get(System::random(types.size() - 1));
                }
            } else {
                Vector<int> types;
                if (!corpse->getMeatType().isEmpty())
                    types.add(234);
                if (!corpse->getHideType().isEmpty())
                    types.add(235);
                if (!corpse->getBoneType().isEmpty())
                    types.add(236);
                if (types.size() > 0)
                    corpseType = types.get(System::random(types.size() - 1));
            }

            if (corpseType == 0) {
                locker.release();
                continue;
            }

            ManagedReference<CreatureManager*> manager = corpse->getZone()->getCreatureManager();
            manager->harvest(corpse, player, corpseType);
            locker.release();
        }

        return SUCCESS;
    }

};

#endif //HARVESTCORPSECOMMAND_H_