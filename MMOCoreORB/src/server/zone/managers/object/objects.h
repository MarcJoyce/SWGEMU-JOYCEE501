/*
 * objects.h
 *
 *  Created on: Sep 19, 2010
 *      Author: oru
 */

#ifndef OBJECTS_H_
#define OBJECTS_H_

#include "server/zone/objects/creature/CreatureObject.h"
#include "server/zone/objects/creature/ai/NonPlayerCreatureObject.h"
#include "server/zone/objects/creature/ai/Creature.h"
#include "server/zone/objects/creature/VehicleObject.h"
#include "server/zone/objects/creature/ai/DroidObject.h"
#include "server/zone/objects/creature/ai/HelperDroidObject.h"
#include "server/zone/objects/intangible/IntangibleObject.h"
#include "server/zone/objects/intangible/VehicleControlDevice.h"
#include "server/zone/objects/intangible/PetControlDevice.h"
#include "server/zone/objects/intangible/ShipControlDevice.h"
#include "server/zone/objects/intangible/TheaterObject.h"
#include "server/zone/objects/ship/ShipObject.h"
#include "server/zone/objects/ship/FighterShipObject.h"
#include "server/zone/objects/ship/ai/SpaceStationObject.h"
#include "server/zone/objects/ship/ai/CapitalShipObject.h"
#include "server/zone/objects/ship/PobShipObject.h"
#include "server/zone/objects/ship/MultiPassengerShipObject.h"
#include "server/zone/objects/ship/ai/ShipAiAgent.h"
#include "server/zone/objects/ship/components/ShipComponent.h"
#include "server/zone/objects/ship/components/ShipArmorComponent.h"
#include "server/zone/objects/ship/components/ShipBoosterComponent.h"
#include "server/zone/objects/ship/components/ShipCapacitorComponent.h"
#include "server/zone/objects/ship/components/ShipChassisComponent.h"
#include "server/zone/objects/ship/components/ShipDroidInterfaceComponent.h"
#include "server/zone/objects/ship/components/ShipEngineComponent.h"
#include "server/zone/objects/ship/components/ShipReactorComponent.h"
#include "server/zone/objects/ship/components/ShipShieldComponent.h"
#include "server/zone/objects/ship/components/ShipWeaponComponent.h"
#include "server/zone/objects/tangible/ship/crafted/repair/ShipComponentRepairKit.h"
#include "server/zone/objects/tangible/ship/interiorComponents/ShipInteriorComponent.h"
#include "server/zone/objects/tangible/ship/interiorComponents/ShipPlasmaConduit.h"
#include "server/zone/objects/ship/components/ShipMissileComponent.h"
#include "server/zone/objects/ship/components/ShipCounterMeasureComponent.h"
#include "server/zone/objects/ship/components/ShipSubComponent.h"
#include "server/zone/objects/tangible/Container.h"
#include "server/zone/objects/tangible/TangibleObject.h"
#include "server/zone/objects/tangible/LairObject.h"
#include "server/zone/objects/tangible/Instrument.h"
#include "server/zone/objects/tangible/consumable/Food.h"
#include "server/zone/objects/tangible/consumable/Drink.h"
#include "server/zone/objects/creature/CreatureObject.h"
#include "server/zone/objects/player/PlayerObject.h"
#include "server/zone/objects/cell/CellObject.h"
#include "server/zone/objects/staticobject/AsteroidObject.h"
#include "server/zone/objects/staticobject/SpaceObject.h"
#include "server/zone/objects/staticobject/StaticObject.h"
#include "server/zone/objects/group/GroupObject.h"
#include "server/zone/objects/guild/GuildObject.h"
#include "server/zone/objects/tangible/weapon/WeaponObject.h"
#include "server/zone/objects/tangible/tool/CraftingTool.h"
#include "server/zone/objects/tangible/tool/CraftingStation.h"
#include "server/zone/objects/tangible/tool/ToolTangibleObject.h"
#include "server/zone/objects/tangible/tool/recycle/RecycleTool.h"
#include "server/zone/objects/tangible/tool/antidecay/AntiDecayKit.h"
#include "server/zone/objects/tangible/tool/componentanalysis/ComponentAnalysisTool.h"
#include "server/zone/objects/tangible/tool/repair/RepairTool.h"
#include "server/zone/objects/tangible/tool/SurveyTool.h"
#include "server/zone/objects/tangible/tool/smuggler/SlicingTool.h"
#include "server/zone/objects/tangible/tool/smuggler/PrecisionLaserKnife.h"
#include "server/zone/objects/tangible/attachment/Attachment.h"
#include "server/zone/objects/building/BuildingObject.h"
#include "server/zone/objects/building/PoiBuilding.h"
#include "server/zone/objects/building/TutorialBuildingObject.h"
#include "server/zone/objects/tangible/powerup/PowerupObject.h"
#include "server/zone/objects/building/hospital/HospitalBuildingObject.h"
#include "server/zone/objects/building/recreation/RecreationBuildingObject.h"
#include "server/zone/objects/building/travel/TravelBuildingObject.h"
#include "server/zone/objects/manufactureschematic/ManufactureSchematic.h"
#include "server/zone/objects/installation/InstallationObject.h"
#include "server/zone/objects/installation/TurretObject.h"
#include "server/zone/objects/installation/factory/FactoryObject.h"
#include "server/zone/objects/factorycrate/FactoryCrate.h"
#include "server/zone/objects/installation/shuttle/ShuttleInstallation.h"
#include "server/zone/objects/installation/garage/GarageInstallation.h"
#include "server/zone/objects/installation/generator/GeneratorObject.h"
#include "server/zone/objects/installation/harvester/HarvesterObject.h"
#include "server/zone/objects/tangible/eventperk/FlagGame.h"
#include "server/zone/objects/tangible/eventperk/Jukebox.h"
#include "server/zone/objects/tangible/eventperk/LotteryDroid.h"
#include "server/zone/objects/tangible/eventperk/ScavengerChest.h"
#include "server/zone/objects/tangible/eventperk/ScavengerDroid.h"
#include "server/zone/objects/tangible/eventperk/ShuttleBeacon.h"
#include "server/zone/objects/tangible/component/Component.h"
#include "server/zone/objects/tangible/component/armor/ArmorComponent.h"
#include "server/zone/objects/tangible/component/genetic/GeneticComponent.h"
#include "server/zone/objects/tangible/component/dna/DnaComponent.h"
#include "server/zone/objects/tangible/component/droid/DroidComponent.h"
#include "server/zone/objects/tangible/component/lightsaber/LightsaberCrystalComponent.h"
#include "server/zone/objects/tangible/component/weapon/De10BarrelComponent.h"
#include "server/zone/objects/tangible/deed/Deed.h"
#include "server/zone/objects/tangible/deed/vehicle/VehicleDeed.h"
#include "server/zone/objects/tangible/deed/pet/PetDeed.h"
#include "server/zone/objects/tangible/deed/droid/DroidDeed.h"
#include "server/zone/objects/tangible/deed/ship/ShipDeed.h"
#include "server/zone/objects/tangible/deed/navicomputer/NavicomputerDeed.h"
#include "server/zone/objects/tangible/deed/structure/StructureDeed.h"
#include "server/zone/objects/tangible/deed/resource/ResourceDeed.h"
#include "server/zone/objects/tangible/deed/eventperk/EventPerkDeed.h"
#include "server/zone/objects/tangible/deed/vetharvester/VetHarvesterDeed.h"
#include "server/zone/objects/tangible/wearables/ArmorObject.h"
#include "server/zone/objects/tangible/wearables/PsgArmorObject.h"
#include "server/zone/objects/tangible/wearables/ClothingObject.h"
#include "server/zone/objects/tangible/wearables/RobeObject.h"
#include "server/zone/objects/tangible/wearables/WearableContainerObject.h"
#include "server/zone/objects/tangible/terminal/Terminal.h"
#include "server/zone/objects/tangible/terminal/characterbuilder/CharacterBuilderTerminal.h"
#include "server/zone/objects/tangible/terminal/startinglocation/StartingLocationTerminal.h"
#include "server/zone/objects/tangible/terminal/ticketcollector/TicketCollector.h"
#include "server/zone/objects/tangible/terminal/travel/TravelTerminal.h"
#include "server/zone/objects/tangible/terminal/guild/GuildTerminal.h"
#include "server/zone/objects/tangible/terminal/spaceship/SpaceshipTerminal.h"
#include "server/zone/objects/tangible/ticket/TicketObject.h"
#include "server/zone/objects/tangible/pharmaceutical/StimPack.h"
#include "server/zone/objects/tangible/pharmaceutical/RangedStimPack.h"
#include "server/zone/objects/tangible/pharmaceutical/EnhancePack.h"
#include "server/zone/objects/tangible/pharmaceutical/CurePack.h"
#include "server/zone/objects/tangible/pharmaceutical/RevivePack.h"
#include "server/zone/objects/tangible/pharmaceutical/StatePack.h"
#include "server/zone/objects/tangible/pharmaceutical/DotPack.h"
#include "server/zone/objects/tangible/pharmaceutical/VitalityPack.h"
#include "server/zone/objects/tangible/pharmaceutical/WoundPack.h"
#include "server/zone/objects/tangible/misc/FsPuzzlePack.h"
#include "server/zone/objects/tangible/misc/PlantObject.h"
#include "server/zone/objects/tangible/terminal/mission/MissionTerminal.h"
#include "server/zone/objects/tangible/sign/SignObject.h"
#include "server/zone/objects/mission/MissionObject.h"
#include "server/zone/objects/waypoint/WaypointObject.h"
#include "server/zone/objects/tangible/fishing/FishingPoleObject.h"
#include "server/zone/objects/tangible/fishing/FishObject.h"
#include "server/zone/objects/tangible/fishing/FishingBaitObject.h"
#include "server/zone/objects/tangible/firework/FireworkObject.h"
#include "server/zone/objects/tangible/loot/LootkitObject.h"
#include "server/zone/objects/tangible/terminal/gambling/GamblingTerminal.h"
#include "server/zone/objects/resource/ResourceSpawn.h"
#include "server/zone/objects/resource/ResourceContainer.h"
#include "server/zone/objects/tangible/misc/CustomIngredient.h"
#include "server/zone/objects/tangible/misc/FsBuffItem.h"
#include "server/zone/objects/tangible/misc/FsCraftingComponentObject.h"
#include "server/zone/objects/tangible/misc/FsCsObject.h"
#include "server/zone/objects/pathfinding/NavArea.h"
#include "server/zone/objects/area/ActiveArea.h"
#include "server/zone/objects/area/CampSiteActiveArea.h"
#include "server/zone/objects/area/SarlaccArea.h"
#include "server/zone/objects/area/FsVillageArea.h"
#include "server/zone/objects/area/BadgeActiveArea.h"
#include "server/zone/objects/region/Region.h"
#include "server/zone/objects/area/MissionSpawnActiveArea.h"
#include "server/zone/objects/area/MissionReconActiveArea.h"
#include "server/zone/objects/region/SpawnArea.h"
#include "server/zone/objects/area/space/SpaceActiveArea.h"
#include "server/zone/objects/area/space/NebulaArea.h"
#include "server/zone/objects/region/space/SpaceRegion.h"
#include "server/zone/objects/region/space/SpaceSpawnArea.h"
#include "server/zone/objects/tangible/misc/ContractCrate.h"
#include "server/zone/objects/tangible/misc/SchematicFragment.h"
#include "server/zone/objects/tangible/misc/DeadEyePrototype.h"
#include "server/zone/objects/tangible/misc/FurnitureObject.h"
#include "server/zone/objects/tangible/misc/LightObject.h"
#include "server/zone/objects/tangible/space/content_infrastructure/SpaceSpawner.h"
#include "server/zone/objects/tangible/item/CreditChipObject.h"
#include "server/zone/objects/tangible/misc/DroidProgrammingChip.h"

#endif /* OBJECTS_H_ */
