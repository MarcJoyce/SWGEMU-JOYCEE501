/*
 * ObjectManager.cpp
 *
 *  Created on: 13/11/2009
 *      Author: victor
 */

#include "ObjectManager.h"
#include "objects.h"

#include "server/db/ServerDatabase.h"

#include "server/zone/ZoneProcessServer.h"
#include "templates/manager/TemplateManager.h"
#include "ObjectVersionUpdateManager.h"
#include "server/ServerCore.h"
#include "server/zone/objects/scene/SceneObjectType.h"
#include "DeleteCharactersTask.h"
#include "conf/ConfigManager.h"
#include "engine/orb/db/UpdateModifiedObjectsThread.h"
#include "engine/orb/db/CommitMasterTransactionThread.h"


using namespace engine::db;

//databaseManager->truncateDatabases();

// http://tinyurl.com/2g9mqh

#define SLOW_QUEUES_COUNT 4

const uint32 ObjectManager::serverObjectCrcHashCode = STRING_HASHCODE("SceneObject.serverObjectCRC");
const uint32 ObjectManager::_classNameHashCode = STRING_HASHCODE("_className");

ObjectManager::ObjectManager(bool initializeTemplates) : DOBObjectManager() {
	server = nullptr;

	deleteCharactersTask = new DeleteCharactersTask();

	databaseManager = ObjectDatabaseManager::instance();
	databaseManager->loadDatabases(ServerCore::truncateDatabases());

	registerObjectTypes();

	databaseManager->loadObjectDatabase("clientobjects", true, 0);
	databaseManager->loadObjectDatabase("sceneobjects", true);
	databaseManager->loadObjectDatabase("playerstructures", true);
	databaseManager->loadObjectDatabase("buffs", true);
	databaseManager->loadObjectDatabase("missionobjectives", true);
	databaseManager->loadObjectDatabase("missionobservers", true);
	databaseManager->loadObjectDatabase("cityregions", true);
	databaseManager->loadObjectDatabase("guilds", true);
	databaseManager->loadObjectDatabase("spawnareas", true);
	databaseManager->loadObjectDatabase("spawnobservers", true);
	databaseManager->loadObjectDatabase("aiobservers", true);
	databaseManager->loadObjectDatabase("events", true);
	databaseManager->loadObjectDatabase("questdata", true);
	databaseManager->loadObjectDatabase("surveys", true);
	databaseManager->loadObjectDatabase("accounts", true);
	databaseManager->loadObjectDatabase("pendingmail", true);
	databaseManager->loadObjectDatabase("credits", true);
	databaseManager->loadObjectDatabase("navareas", true, 0xFFFF, false);
	databaseManager->loadObjectDatabase("frsdata", true);
	databaseManager->loadObjectDatabase("frsmanager", true);
	databaseManager->loadObjectDatabase("resourcespawns", true);
	databaseManager->loadObjectDatabase("playerbounties", true);
	databaseManager->loadObjectDatabase("mail", true);
	databaseManager->loadObjectDatabase("chatrooms", true);

	ObjectDatabaseManager::instance()->commitLocalTransaction();

	Core::getTaskManager()->initalizeDatabaseHandles();
	Core::getTaskManager()->initializeCustomQueue("slowQueue", SLOW_QUEUES_COUNT, true);

	loadLastUsedObjectID();

	setLogging(false);
	setGlobalLogging(true);

	if (initializeTemplates) {
		templateManager = TemplateManager::instance();
		templateManager->loadLuaTemplates();
	}
}

ObjectManager::~ObjectManager() {

}

void ObjectManager::registerObjectTypes() {
	debug("registering object types");
	//objectFactory.registerObject<SceneObject>(0);
	objectFactory.registerObject<TangibleObject>(6);
	objectFactory.registerObject<LairObject>(SceneObjectType::LAIR);
	objectFactory.registerObject<StaticObject>(SceneObjectType::FLORA);
	objectFactory.registerObject<SarlaccArea>(SceneObjectType::SARLACCAREA);
	objectFactory.registerObject<FsVillageArea>(SceneObjectType::FSVILLAGEAREA);
	objectFactory.registerObject<ActiveArea>(SceneObjectType::ACTIVEAREA);
	objectFactory.registerObject<BadgeActiveArea>(SceneObjectType::BADGEAREA);
	objectFactory.registerObject<MissionSpawnActiveArea>(SceneObjectType::MISSIONSPAWNAREA);
	objectFactory.registerObject<MissionReconActiveArea>(SceneObjectType::MISSIONRECONAREA);
	objectFactory.registerObject<SpawnArea>(SceneObjectType::SPAWNAREA);
	objectFactory.registerObject<CampSiteActiveArea>(SceneObjectType::CAMPAREA);
	objectFactory.registerObject<Region>(SceneObjectType::REGIONAREA);
	objectFactory.registerObject<NavArea>(SceneObjectType::NAVMESHAREA);
	objectFactory.registerObject<StaticObject>(SceneObjectType::STATICOBJECT);
	objectFactory.registerObject<Creature>(SceneObjectType::CREATURE);
	objectFactory.registerObject<NonPlayerCreatureObject>(SceneObjectType::NPCCREATURE);
	objectFactory.registerObject<NonPlayerCreatureObject>(SceneObjectType::PROBOTCREATURE);
	objectFactory.registerObject<TangibleObject>(SceneObjectType::VENDOR);
	objectFactory.registerObject<CreatureObject>(SceneObjectType::PLAYERCREATURE);
	objectFactory.registerObject<IntangibleObject>(SceneObjectType::INTANGIBLE);
	objectFactory.registerObject<IntangibleObject>(SceneObjectType::DATA2);
	objectFactory.registerObject<TheaterObject>(SceneObjectType::THEATEROBJECT);
	objectFactory.registerObject<TangibleObject>(SceneObjectType::EVENTPERK);
	objectFactory.registerObject<ArmorObject>(SceneObjectType::ARMOR);
	objectFactory.registerObject<ArmorObject>(SceneObjectType::BODYARMOR); //chest plates
	objectFactory.registerObject<ArmorObject>(SceneObjectType::HEADARMOR);
	objectFactory.registerObject<ArmorObject>(SceneObjectType::MISCARMOR); // Some Belts Bando's'
	objectFactory.registerObject<ArmorObject>(SceneObjectType::LEGARMOR);
	objectFactory.registerObject<ArmorObject>(SceneObjectType::ARMARMOR);
	objectFactory.registerObject<ArmorObject>(SceneObjectType::HANDARMOR);
	objectFactory.registerObject<ArmorObject>(SceneObjectType::FOOTARMOR);
	objectFactory.registerObject<ArmorObject>(SceneObjectType::SHIELDGENERATOR);
	objectFactory.registerObject<ToolTangibleObject>(SceneObjectType::TOOL);
	objectFactory.registerObject<RepairTool>(SceneObjectType::REPAIRTOOL);
	objectFactory.registerObject<CraftingTool>(SceneObjectType::CRAFTINGTOOL);
	objectFactory.registerObject<SurveyTool>(SceneObjectType::SURVEYTOOL);
	objectFactory.registerObject<RecycleTool>(SceneObjectType::RECYCLETOOL);
	objectFactory.registerObject<AntiDecayKit>(SceneObjectType::ANTIDECAYKIT);
	objectFactory.registerObject<ComponentAnalysisTool>(SceneObjectType::COMPONENTANALYSISTOOL);
	objectFactory.registerObject<CraftingStation>(SceneObjectType::CRAFTINGSTATION);
	objectFactory.registerObject<SignObject>(SceneObjectType::SIGN);
	objectFactory.registerObject<Instrument>(SceneObjectType::INSTRUMENT);
	objectFactory.registerObject<Food>(SceneObjectType::FOOD);
	objectFactory.registerObject<Drink>(SceneObjectType::DRINK);
	objectFactory.registerObject<Container>(SceneObjectType::CONTAINER);
	objectFactory.registerObject<FireworkObject>(SceneObjectType::FIREWORK);
	objectFactory.registerObject<TangibleObject>(SceneObjectType::ITEM);
	objectFactory.registerObject<TangibleObject>(SceneObjectType::GENERICITEM);
	objectFactory.registerObject<WearableContainerObject>(SceneObjectType::WEARABLECONTAINER);
	objectFactory.registerObject<LootkitObject>(SceneObjectType::LOOTKIT);
	objectFactory.registerObject<TangibleObject>(SceneObjectType::CAMPKIT);
	objectFactory.registerObject<Container>(SceneObjectType::STATICLOOTCONTAINER);
	objectFactory.registerObject<TangibleObject>(SceneObjectType::PLAYERLOOTCRATE);
	objectFactory.registerObject<PlantObject>(SceneObjectType::GROWABLEPLANT);
	objectFactory.registerObject<FsCsObject>(SceneObjectType::FSCSOBJECT);
	objectFactory.registerObject<FsBuffItem>(SceneObjectType::FSBUFFITEM);
	objectFactory.registerObject<DeadEyePrototype>(SceneObjectType::DEADEYEPROTOTYPE);
	objectFactory.registerObject<FurnitureObject>(SceneObjectType::FURNITURE);
	objectFactory.registerObject<LightObject>(SceneObjectType::LIGHTOBJECT);
	objectFactory.registerObject<ContractCrate>(SceneObjectType::CONTRACTCRATE);
	objectFactory.registerObject<SchematicFragment>(SceneObjectType::SCHEMATICFRAGMENT);
	objectFactory.registerObject<SlicingTool>(SceneObjectType::SLICINGTOOL);
	objectFactory.registerObject<SlicingTool>(SceneObjectType::FLOWANALYZER);
	objectFactory.registerObject<SlicingTool>(SceneObjectType::MOLECULARCLAMP);
	objectFactory.registerObject<SlicingTool>(SceneObjectType::WEAPONUPGRADEKIT);
	objectFactory.registerObject<SlicingTool>(SceneObjectType::ARMORUPGRADEKIT);
	objectFactory.registerObject<PrecisionLaserKnife>(SceneObjectType::LASERKNIFE);
	objectFactory.registerObject<CellObject>(SceneObjectType::CELLOBJECT);
	objectFactory.registerObject<PlayerObject>(SceneObjectType::PLAYEROBJECT);
	objectFactory.registerObject<WaypointObject>(SceneObjectType::WAYPOINT);
	objectFactory.registerObject<WearableObject>(SceneObjectType::JEWELRY);
	objectFactory.registerObject<WearableObject>(SceneObjectType::RING);
	objectFactory.registerObject<WearableObject>(SceneObjectType::BRACELET);
	objectFactory.registerObject<WearableObject>(SceneObjectType::NECKLACE);
	objectFactory.registerObject<WearableObject>(SceneObjectType::EARRING);
	objectFactory.registerObject<Attachment>(SceneObjectType::ARMORATTACHMENT);
	objectFactory.registerObject<Attachment>(SceneObjectType::CLOTHINGATTACHMENT);
	objectFactory.registerObject<BuildingObject>(SceneObjectType::BUILDING);
	objectFactory.registerObject<BuildingObject>(SceneObjectType::CAPITOLBUILDING);
	objectFactory.registerObject<HospitalBuildingObject>(SceneObjectType::HOSPITALBUILDING);
	objectFactory.registerObject<TravelBuildingObject>(SceneObjectType::TRAVELBUILDING);
	objectFactory.registerObject<RecreationBuildingObject>(SceneObjectType::RECREATIONBUILDING);
	objectFactory.registerObject<TravelBuildingObject>(SceneObjectType::STARPORTBUILDING);
	objectFactory.registerObject<BuildingObject>(SceneObjectType::FACTIONBUILDING);
	objectFactory.registerObject<BuildingObject>(SceneObjectType::HOTELBUILDING);
	objectFactory.registerObject<BuildingObject>(SceneObjectType::THEATERBUILDING);
	objectFactory.registerObject<BuildingObject>(SceneObjectType::COMBATBUILDING);
	objectFactory.registerObject<BuildingObject>(SceneObjectType::COMMERCEBUILDING);
	objectFactory.registerObject<BuildingObject>(SceneObjectType::UNIVERSITYBUILDING);
	objectFactory.registerObject<BuildingObject>(SceneObjectType::GARAGEBUILDING);
	objectFactory.registerObject<BuildingObject>(SceneObjectType::SALONBUILDING);
	objectFactory.registerObject<PoiBuilding>(SceneObjectType::POIBUILDING);
	objectFactory.registerObject<TutorialBuildingObject>(SceneObjectType::TUTORIALBUILDING);
	objectFactory.registerObject<InstallationObject>(SceneObjectType::INSTALLATION);
	objectFactory.registerObject<GarageInstallation>(SceneObjectType::GARAGEINSTALLATION);
	objectFactory.registerObject<ShuttleInstallation>(SceneObjectType::SHUTTLEINSTALLATION);
	objectFactory.registerObject<HarvesterObject>(SceneObjectType::HARVESTER);
	objectFactory.registerObject<FactoryObject>(SceneObjectType::FACTORY);
	objectFactory.registerObject<GeneratorObject>(SceneObjectType::GENERATOR);
	objectFactory.registerObject<InstallationObject>(SceneObjectType::DESTRUCTIBLE);
	objectFactory.registerObject<TurretObject>(SceneObjectType::TURRET);
	objectFactory.registerObject<InstallationObject>(SceneObjectType::MINEFIELD);
	objectFactory.registerObject<InstallationObject>(SceneObjectType::COVERTSCANNER);
	objectFactory.registerObject<WeaponObject>(SceneObjectType::WEAPON);
	objectFactory.registerObject<WeaponObject>(SceneObjectType::MELEEWEAPON);
	objectFactory.registerObject<WeaponObject>(SceneObjectType::PISTOL);
	objectFactory.registerObject<WeaponObject>(SceneObjectType::RANGEDWEAPON);
	objectFactory.registerObject<WeaponObject>(SceneObjectType::ONEHANDMELEEWEAPON);
	objectFactory.registerObject<WeaponObject>(SceneObjectType::SPECIALHEAVYWEAPON);
	objectFactory.registerObject<WeaponObject>(SceneObjectType::HEAVYWEAPON);
	objectFactory.registerObject<WeaponObject>(SceneObjectType::RIFLE);
	objectFactory.registerObject<WeaponObject>(SceneObjectType::CARBINE);
	objectFactory.registerObject<WeaponObject>(SceneObjectType::POLEARM);
	objectFactory.registerObject<WeaponObject>(SceneObjectType::TWOHANDMELEEWEAPON);
	objectFactory.registerObject<WeaponObject>(SceneObjectType::MINE);
	objectFactory.registerObject<WeaponObject>(SceneObjectType::THROWNWEAPON);
	objectFactory.registerObject<MissionObject>(SceneObjectType::MISSIONOBJECT);
	objectFactory.registerObject<Terminal>(SceneObjectType::TERMINAL);
	objectFactory.registerObject<Terminal>(SceneObjectType::INSURANCE);
	objectFactory.registerObject<Terminal>(SceneObjectType::SHIPPINGTERMINAL);
	objectFactory.registerObject<Terminal>(SceneObjectType::INTERACTIVETERMINAL);
	objectFactory.registerObject<MissionTerminal>(SceneObjectType::MISSIONTERMINAL);
	objectFactory.registerObject<Terminal>(SceneObjectType::SHIPPERMISSIONS);
	objectFactory.registerObject<Terminal>(SceneObjectType::BAZAAR);
	objectFactory.registerObject<Terminal>(SceneObjectType::BANK);
	objectFactory.registerObject<StartingLocationTerminal>(SceneObjectType::NEWBIETUTORIALTERMINAL);
	objectFactory.registerObject<CharacterBuilderTerminal>(SceneObjectType::CHARACTERBUILDERTERMINAL);
	objectFactory.registerObject<Terminal>(SceneObjectType::PLAYERTERMINALSTRUCTURE);
	objectFactory.registerObject<TicketCollector>(SceneObjectType::TICKETCOLLECTOR);
	objectFactory.registerObject<TicketObject>(SceneObjectType::TRAVELTICKET);
	objectFactory.registerObject<TravelTerminal>(SceneObjectType::TRAVELTERMINAL);
	objectFactory.registerObject<GuildTerminal>(SceneObjectType::GUILDTERMINAL);
	objectFactory.registerObject<Jukebox>(SceneObjectType::JUKEBOX);
	objectFactory.registerObject<ShuttleBeacon>(SceneObjectType::SHUTTLEBEACON);
	objectFactory.registerObject<FlagGame>(SceneObjectType::FLAGGAME);
	objectFactory.registerObject<LotteryDroid>(SceneObjectType::LOTTERYDROID);
	objectFactory.registerObject<ScavengerChest>(SceneObjectType::SCAVENGERCHEST);
	objectFactory.registerObject<ScavengerDroid>(SceneObjectType::SCAVENGERDROID);
	objectFactory.registerObject<GamblingTerminal>(SceneObjectType::GAMBLINGTERMINAL);
	objectFactory.registerObject<Terminal>(SceneObjectType::CLONING);
	objectFactory.registerObject<Deed>(SceneObjectType::DEED);
	objectFactory.registerObject<VehicleDeed>(SceneObjectType::VEHICLEDEED);
	objectFactory.registerObject<PetDeed>(SceneObjectType::PETDEED);
	objectFactory.registerObject<DroidDeed>(SceneObjectType::DROIDDEED);
	objectFactory.registerObject<StructureDeed>(SceneObjectType::BUILDINGDEED);
	objectFactory.registerObject<StructureDeed>(SceneObjectType::INSTALLATIONDEED);
	objectFactory.registerObject<ResourceDeed>(SceneObjectType::RESOURCEDEED);
	objectFactory.registerObject<EventPerkDeed>(SceneObjectType::EVENTPERKDEED);
	objectFactory.registerObject<VetHarvesterDeed>(SceneObjectType::VETHARVESTERDEED);
	objectFactory.registerObject<NavicomputerDeed>(SceneObjectType::NAVICOMPUTERDEED);
	objectFactory.registerObject<ShipDeed>(SceneObjectType::SHIPDEED);
	objectFactory.registerObject<GroupObject>(SceneObjectType::GROUPOBJECT);
	objectFactory.registerObject<GuildObject>(SceneObjectType::GUILDOBJECT);
	objectFactory.registerObject<StimPack>(SceneObjectType::STIMPACK);
	objectFactory.registerObject<RangedStimPack>(SceneObjectType::RANGEDSTIMPACK);
	objectFactory.registerObject<EnhancePack>(SceneObjectType::ENHANCEPACK);
	objectFactory.registerObject<CurePack>(SceneObjectType::CUREPACK);
	objectFactory.registerObject<DotPack>(SceneObjectType::DOTPACK);
	objectFactory.registerObject<WoundPack>(SceneObjectType::WOUNDPACK);
	objectFactory.registerObject<StatePack>(SceneObjectType::STATEPACK);
	objectFactory.registerObject<RevivePack>(SceneObjectType::REVIVEPACK);
	objectFactory.registerObject<VitalityPack>(SceneObjectType::PETMEDECINE);
	objectFactory.registerObject<FsPuzzlePack>(SceneObjectType::FSPUZZLEPACK);

	//clothing
	objectFactory.registerObject<ClothingObject>(SceneObjectType::CLOTHING);
	objectFactory.registerObject<ClothingObject>(SceneObjectType::BANDOLIER);
	objectFactory.registerObject<ClothingObject>(SceneObjectType::BELT);
	objectFactory.registerObject<ClothingObject>(SceneObjectType::BODYSUIT);
	objectFactory.registerObject<ClothingObject>(SceneObjectType::CAPE);
	objectFactory.registerObject<ClothingObject>(SceneObjectType::FOOTWEAR);
	objectFactory.registerObject<ClothingObject>(SceneObjectType::HEADWEAR);
	objectFactory.registerObject<ClothingObject>(SceneObjectType::EYEWEAR);
	objectFactory.registerObject<ClothingObject>(SceneObjectType::DRESS);
	objectFactory.registerObject<ClothingObject>(SceneObjectType::HANDWEAR);
	objectFactory.registerObject<ClothingObject>(SceneObjectType::JACKET);
	objectFactory.registerObject<ClothingObject>(SceneObjectType::PANTS);
	objectFactory.registerObject<ClothingObject>(SceneObjectType::ROBE);
	objectFactory.registerObject<ClothingObject>(SceneObjectType::SHIRT);
	objectFactory.registerObject<ClothingObject>(SceneObjectType::VEST);
	objectFactory.registerObject<ClothingObject>(SceneObjectType::WOOKIEEGARB);
	objectFactory.registerObject<ClothingObject>(SceneObjectType::MISCCLOTHING);
	objectFactory.registerObject<ClothingObject>(SceneObjectType::SKIRT);
	//objectFactory.registerObject<ClothingObject>(SceneObjectType::ITHOGARB);
	objectFactory.registerObject<FishingPoleObject>(SceneObjectType::FISHINGPOLE);
	objectFactory.registerObject<FishingBaitObject>(SceneObjectType::FISHINGBAIT);
	objectFactory.registerObject<FishObject>(SceneObjectType::FISH);
	objectFactory.registerObject<TangibleObject>(SceneObjectType::TANGIBLE);
	objectFactory.registerObject<RobeObject>(SceneObjectType::CLOAK);
	objectFactory.registerObject<TangibleObject>(SceneObjectType::TRAP);
	objectFactory.registerObject<TangibleObject>(SceneObjectType::CAMOKIT);
	objectFactory.registerObject<TangibleObject>(SceneObjectType::LIVESAMPLE);
	objectFactory.registerObject<VehicleControlDevice>(SceneObjectType::VEHICLECONTROLDEVICE);
	objectFactory.registerObject<PetControlDevice>(SceneObjectType::PETCONTROLDEVICE);
	objectFactory.registerObject<PetControlDevice>(SceneObjectType::DROIDCONTROLDEVICE);
	objectFactory.registerObject<ShipControlDevice>(SceneObjectType::SHIPCONTROLDEVICE);
	objectFactory.registerObject<VehicleObject>(SceneObjectType::VEHICLE);
	objectFactory.registerObject<VehicleObject>(SceneObjectType::HOVERVEHICLE);
	objectFactory.registerObject<DroidObject>(SceneObjectType::DROIDCREATURE);
	objectFactory.registerObject<HelperDroidObject>(SceneObjectType::HELPERDROIDCREATURE);
	objectFactory.registerObject<ResourceSpawn>(SceneObjectType::RESOURCESPAWN);
	objectFactory.registerObject<ResourceContainer>(SceneObjectType::RESOURCECONTAINER);
	objectFactory.registerObject<ResourceContainer>(SceneObjectType::ENERGYGAS);
	objectFactory.registerObject<ResourceContainer>(SceneObjectType::ENERGYLIQUID);
	objectFactory.registerObject<ResourceContainer>(SceneObjectType::ENERGYRADIOACTIVE);
	objectFactory.registerObject<ResourceContainer>(SceneObjectType::ENERGYSOLID);
	objectFactory.registerObject<ResourceContainer>(SceneObjectType::INORGANICCHEMICAL);
	objectFactory.registerObject<ResourceContainer>(SceneObjectType::INORGANICGAS);
	objectFactory.registerObject<ResourceContainer>(SceneObjectType::INORGANICMINERAL);
	objectFactory.registerObject<ResourceContainer>(SceneObjectType::WATER);
	objectFactory.registerObject<ResourceContainer>(SceneObjectType::ORGANICFOOD);
	objectFactory.registerObject<ResourceContainer>(SceneObjectType::ORGANICHIDE);
	objectFactory.registerObject<ResourceContainer>(SceneObjectType::ORGANICSTRUCTURAL);
	objectFactory.registerObject<CustomIngredient>(SceneObjectType::QUESTRESOURCE);
	objectFactory.registerObject<FsCraftingComponentObject>(SceneObjectType::FSCRAFTINGCOMPONENT);
	objectFactory.registerObject<DraftSchematic>(SceneObjectType::DRAFTSCHEMATIC);
	objectFactory.registerObject<ManufactureSchematic>(SceneObjectType::MANUFACTURINGSCHEMATIC);
	objectFactory.registerObject<Component>(SceneObjectType::COMPONENT);
	objectFactory.registerObject<ArmorComponent>(SceneObjectType::ARMORCOMPONENT);
	objectFactory.registerObject<Component>(SceneObjectType::CHEMISTRYCOMPONENT);
	objectFactory.registerObject<Component>(SceneObjectType::CLOTHINGCOMPONENT);
	objectFactory.registerObject<Component>(SceneObjectType::COMMUNITYCRAFTINGCOMPONENT);
	objectFactory.registerObject<DroidComponent>(SceneObjectType::DROIDCOMPONENT);
	objectFactory.registerObject<Component>(SceneObjectType::ELECTRONICSCOMPONENT);
	objectFactory.registerObject<GeneticComponent>(SceneObjectType::GENETICCOMPONENT);
	objectFactory.registerObject<DnaComponent>(SceneObjectType::DNACOMPONENT);
	objectFactory.registerObject<LightsaberCrystalComponent>(SceneObjectType::LIGHTSABERCRYSTAL);
	objectFactory.registerObject<Component>(SceneObjectType::MELEEWEAPONCOMPONENT);
	objectFactory.registerObject<Component>(SceneObjectType::MUNITIONCOMPONENT);
	objectFactory.registerObject<Component>(SceneObjectType::RANGEDWEAPONCOMPONENT);
	objectFactory.registerObject<Component>(SceneObjectType::STRUCTURECOMPONENT);
	objectFactory.registerObject<Component>(SceneObjectType::TISSUECOMPONENT);
	objectFactory.registerObject<De10BarrelComponent>(SceneObjectType::DE10BARRELCOMPONENT);
	objectFactory.registerObject<PowerupObject>(SceneObjectType::WEAPONPOWERUP);
	objectFactory.registerObject<PowerupObject>(SceneObjectType::MELEEWEAPONPOWERUP);
	objectFactory.registerObject<PowerupObject>(SceneObjectType::RANGEDWEAPONPOWERUP);
	objectFactory.registerObject<PowerupObject>(SceneObjectType::THROWNWEAPONPOWERUP);
	objectFactory.registerObject<PowerupObject>(SceneObjectType::HEAVYWEAPONPOWERUP);
	objectFactory.registerObject<PowerupObject>(SceneObjectType::MINEPOWERUP);
	objectFactory.registerObject<PowerupObject>(SceneObjectType::SPECIALHEAVYWEAPONPOWERUP);

	// JTL Related
	objectFactory.registerObject<ShipComponent>(SceneObjectType::SHIPATTACHMENT);
	objectFactory.registerObject<ShipReactorComponent>(SceneObjectType::SHIPREACTOR);
	objectFactory.registerObject<ShipEngineComponent>(SceneObjectType::SHIPENGINE);
	objectFactory.registerObject<ShipShieldComponent>(SceneObjectType::SHIPSHIELDGENERATOR);
	objectFactory.registerObject<ShipArmorComponent>(SceneObjectType::SHIPARMOR);
	objectFactory.registerObject<ShipWeaponComponent>(SceneObjectType::SHIPWEAPON);
	objectFactory.registerObject<ShipCapacitorComponent>(SceneObjectType::SHIPWEAPONCAPACITOR);
	objectFactory.registerObject<ShipSubComponent>(SceneObjectType::SHIPCAPACITORSUBCOMPONENT);
	objectFactory.registerObject<ShipBoosterComponent>(SceneObjectType::SHIPBOOSTER);
	objectFactory.registerObject<ShipDroidInterfaceComponent>(SceneObjectType::SHIPDROIDINTERFACE);
	objectFactory.registerObject<ShipChassisComponent>(SceneObjectType::SHIPCHASSIS);
	objectFactory.registerObject<ShipMissileComponent>(SceneObjectType::SHIPMISSILE);
	objectFactory.registerObject<ShipCounterMeasureComponent>(SceneObjectType::SHIPCOUNTERMEASURE);
	objectFactory.registerObject<ShipWeaponComponent>(SceneObjectType::SHIPWEAPONLAUNCHER);
	objectFactory.registerObject<ShipWeaponComponent>(SceneObjectType::SHIPCOUNTERMEASURELAUNCHER);
	objectFactory.registerObject<DroidProgrammingChip>(SceneObjectType::DROIDPROGRAMMINGCHIP);
	objectFactory.registerObject<AsteroidObject>(SceneObjectType::ASTEROID);
	objectFactory.registerObject<TangibleObject>(SceneObjectType::PILOTCHAIR);
	objectFactory.registerObject<TangibleObject>(SceneObjectType::OPERATIONSCHAIR);
	objectFactory.registerObject<TangibleObject>(SceneObjectType::TURRETACCESSLADDER);
	objectFactory.registerObject<TangibleObject>(SceneObjectType::SHIPCONTAINER);
	objectFactory.registerObject<FactoryCrate>(SceneObjectType::FACTORYCRATE);
	objectFactory.registerObject<TangibleObject>(SceneObjectType::CRYSTAL);
	objectFactory.registerObject<ShipComponentRepairKit>(SceneObjectType::SHIPCOMPONENTREPAIRITEM);
	objectFactory.registerObject<ShipInteriorComponent>(SceneObjectType::SHIPINTERIORCOMPONENT);
	objectFactory.registerObject<ShipPlasmaConduit>(SceneObjectType::SHIPPLASMACONDUIT);
	objectFactory.registerObject<ShipSubComponent>(SceneObjectType::SHIPREACTORSUBCOMPONENT);
	objectFactory.registerObject<ShipSubComponent>(SceneObjectType::SHIPENGINESUBCOMPONENT);
	objectFactory.registerObject<ShipSubComponent>(SceneObjectType::SHIPSHIELDSUBCOMPONENT);
	objectFactory.registerObject<ShipSubComponent>(SceneObjectType::SHIPARMORSUBCOMPONENT);
	objectFactory.registerObject<ShipSubComponent>(SceneObjectType::SHIPWEAPONSUBCOMPONENT);
	objectFactory.registerObject<ShipSubComponent>(SceneObjectType::SHIPCAPACITORSUBCOMPONENT);
	objectFactory.registerObject<ShipSubComponent>(SceneObjectType::SHIPBOOSTERSUBCOMPONENT);
	objectFactory.registerObject<ShipSubComponent>(SceneObjectType::SHIPDROIDINTERFACESUBCOMPONENT);

	objectFactory.registerObject<SpaceActiveArea>(SceneObjectType::SPACEACTIVEAREA);
	objectFactory.registerObject<NebulaArea>(SceneObjectType::NEBULAAREA);
	objectFactory.registerObject<SpaceRegion>(SceneObjectType::SPACEREGIONAREA);
	objectFactory.registerObject<SpaceSpawnArea>(SceneObjectType::SPACESPAWNAREA);
	objectFactory.registerObject<SpaceSpawner>(SceneObjectType::SPACESPAWNER);
	objectFactory.registerObject<CreditChipObject>(SceneObjectType::CREDITCHIP);

	objectFactory.registerObject<SpaceshipTerminal>(SceneObjectType::SPACETERMINAL);
	objectFactory.registerObject<ShipObject>(SceneObjectType::SHIP);
	objectFactory.registerObject<FighterShipObject>(SceneObjectType::SHIPFIGHTER);
	objectFactory.registerObject<CapitalShipObject>(SceneObjectType::SHIPCAPITAL);
	objectFactory.registerObject<SpaceObject>(SceneObjectType::SPACEOBJECT);
	objectFactory.registerObject<ShipObject>(SceneObjectType::SHIPTRANSPORT);
	objectFactory.registerObject<PobShipObject>(SceneObjectType::SHIPPOB);
	objectFactory.registerObject<MultiPassengerShipObject>(SceneObjectType::SHIPMULTIPASSENGER);
	objectFactory.registerObject<ShipAiAgent>(SceneObjectType::SHIPAGENT);
	objectFactory.registerObject<SpaceStationObject>(SceneObjectType::SPACESTATION);
}

void ObjectManager::updateObjectVersion() {
	if (ObjectVersionUpdateManager::instance()->run() == 0) {
		ObjectDatabaseManager::instance()->commitLocalTransaction();

		ObjectDatabaseManager::instance()->checkpoint();
	}
}

void ObjectManager::loadLastUsedObjectID() {
	info("loading last used object id");

	uint64 storedID = databaseManager->getLastUsedObjectID();

	if (!ServerCore::truncateDatabases() && storedID != 0) {
		nextObjectID = storedID + 1;

		info() << "done loading stored id as last used object id 0x" << hex << uppercase << nextObjectID;
		return;
	}

	info("loading bruteforce last used id..");

	uint64 maxObjectID = 0;
	uint64 objectID;

	uint64 nullify = 0x0000FFFF;
	nullify = (nullify << 32) + 0xFFFFFFFF;

	for (int i = 0; i < databaseManager->getTotalDatabaseCount(); ++i) {
		LocalDatabase* database = databaseManager->getDatabase(i);

		if (!database->isObjectDatabase())
			continue;

		ObjectDatabase* db = cast<ObjectDatabase*>(database);

		String dbName =	db->getDatabaseName();

		ObjectDatabaseIterator iterator(db);

		while (iterator.getNextKey(objectID)) {
			objectID = objectID & nullify;

			if (objectID > maxObjectID)
				maxObjectID = objectID;
		}
	}

	if (nextObjectID < maxObjectID + 1)
		nextObjectID = maxObjectID + 1;

	info() << "done loading last used object id 0x" << hex << uppercase << nextObjectID;
}

void ObjectManager::loadStaticObjects() {
	Locker _locker(this);

	info("loading static objects...", true);

	ObjectDatabase* staticDatabase = databaseManager->loadObjectDatabase("clientobjects", true, 0);

	ObjectDatabaseIterator iterator(staticDatabase);

	uint32 serverObjectCRC;
	uint64 objectID;

	ObjectInputStream objectData(2000);

	while (iterator.getNextKeyAndValue(objectID, &objectData)) {
		Reference<SceneObject*> object = getObject(objectID).castMoveTo<SceneObject*>();

		if (object != nullptr)
			continue;

		if (!Serializable::getVariable<uint32>(serverObjectCrcHashCode, &serverObjectCRC, &objectData)) {
			error("unknown scene object in static database");
			continue;
		}

		if (object == nullptr) {
			object = createObject(serverObjectCRC, 0, "clientobjects", objectID);

			if (object == nullptr) {
				error("could not load object from static database");

				continue;
			}

			_locker.release();

			String logName = object->getLoggingName();

			deSerializeObject(object, &objectData);

			object->setLoggingName(logName);

			objectData.reset();
		}
	}
}

int ObjectManager::updatePersistentObject(DistributedObject* object) {
	object->_setUpdated(true);

	return 0;
}

SceneObject* ObjectManager::loadObjectFromTemplate(uint32 objectCRC) {
	Locker _locker(this);

	SceneObject* object = nullptr;

	try {
		SharedObjectTemplate* templateData = templateManager->getTemplate(objectCRC);

		if (templateData == nullptr) {
			error() << "Failed to create object with unknown CRC: 0x" << hex << (int)objectCRC;

			return nullptr;
		}

		uint32 gameObjectType = templateData->getGameObjectType();

		object = objectFactory.createObject(gameObjectType);

		if (object == nullptr) {
			error() << "creating object unknown gameObjectType " << gameObjectType;

			return nullptr;
		}

		databaseManager->addTemporaryObject(object);

		object->setServerObjectCRC(objectCRC);
		object->initializeContainerObjectsMap();
		object->loadTemplateData(templateData);

	} catch (const Exception& e) {
		error("exception caught in SceneObject* ObjectManager::loadObjectFromTemplate(uint32 objectCRC)");
		error(e.getMessage());

		e.printStackTrace();
	} catch (...) {
		error("unreported exception caught in SceneObject* ObjectManager::loadObjectFromTemplate(uint32 objectCRC)");

		throw;
	}

	return object;
}

/*ManagedObject* ObjectManager::cloneManagedObject(ManagedObject* object, bool makeTransient) {
	ObjectOutputStream objectData(500);

	object->writeObject(&objectData);
	objectData.reset();

	ObjectInputStream objectInput;
	objectData.copy(&objectInput, 0);
	objectInput.reset();

	DistributedObjectClassHelper* helper = object->_getClassHelper();
	String className = helper->getClassName();

	ManagedObject* clonedObject = nullptr;

	ObjectDatabase* database = getTable(object->getObjectID());
	String databaseName;

	if (database != nullptr) {
		database->getDatabaseName(databaseName);
	}

	if (makeTransient || !object->isPersistent()) {
		clonedObject = createObject(className, 0, databaseName);
		clonedObject->setPersistent(0);
	} else if (object->isPersistent()) {
		clonedObject = createObject(className, object->getPersistenceLevel(), databaseName);
	}

	Locker locker(clonedObject);

	clonedObject->readObject(&objectInput);
}*/

SceneObject* ObjectManager::cloneObject(SceneObject* object, bool makeTransient) {
	ObjectOutputStream objectData(500);

	(cast<ManagedObject*>(object))->writeObject(&objectData);
	objectData.reset();

	ObjectInputStream objectInput;
	objectData.copy(&objectInput, 0);
	objectInput.reset();

	uint32 serverCRC = object->getServerObjectCRC();

	SceneObject* clonedObject = nullptr;

	ObjectDatabase* database = getTable(object->getObjectID());
	String databaseName;
	uint64 oid;

	if (database != nullptr) {
		database->getDatabaseName(databaseName);

		oid = getNextObjectID(databaseName);
	} else
		oid = getNextFreeObjectID();


	clonedObject = instantiateSceneObject(serverCRC, oid, false);

	if (makeTransient || !object->isPersistent()) {
		//clonedObject = createObject(serverCRC, 0, databaseName);
		clonedObject->setPersistent(0);
	} else if (object->isPersistent()) {
		//clonedObject = createObject(serverCRC, object->getPersistenceLevel(), databaseName);
		clonedObject->setPersistent(object->getPersistenceLevel());
	}

	Locker locker(clonedObject);

	clonedObject->readObject(&objectInput);
	clonedObject->createComponents();
	clonedObject->setParent(nullptr);

	VectorMap<String, ManagedReference<SceneObject*> > slottedObjects;
	clonedObject->getSlottedObjects(slottedObjects);

	SortedVector<SceneObject*> inserted;
	inserted.setNoDuplicateInsertPlan();

	for (int i = slottedObjects.size() - 1; i >= 0; i--) {
		Reference<SceneObject*> obj = slottedObjects.elementAt(i).getValue();

		clonedObject->removeSlottedObject(i);

		if (inserted.put(obj) != -1) {
			Reference<SceneObject*> clonedChild = cloneObject(obj, makeTransient);

			clonedObject->transferObject(clonedChild, 4, false);
		}
	}

	VectorMap<uint64, ManagedReference<SceneObject*> > objects;
	clonedObject->getContainerObjects(objects);

	for (int i = objects.size() - 1; i >= 0; i--) {
		Reference<SceneObject*> obj = objects.elementAt(i).getValue();

		clonedObject->removeFromContainerObjects(i);

		Reference<SceneObject*> clonedChild = cloneObject(obj, makeTransient);

		clonedObject->transferObject(clonedChild, -1, false);
	}

	clonedObject->onCloneObject(object);

	if (clonedObject->isPersistent())
		updatePersistentObject(clonedObject);

	return clonedObject;
}

void ObjectManager::persistObject(ManagedObject* object, int persistenceLevel, const String& database) {
	Locker _locker(this);

	if (object->isPersistent()) {
		//error("object is already persistent");
		return;
	}

	if (database.length() > 0) {
		uint64 objectID = object->_getObjectID();

		uint16 tableID = (uint16)(objectID >> 48);

		uint16 newDatabaseTableID = databaseManager->getDatabaseID(database);

		if (tableID != newDatabaseTableID) {
			uint64 newObjectID = getNextObjectID(database);

			object->_setObjectID(newObjectID);

			object->deploy();
		}
	} else {
		throw Exception("no database specified in ObjectManager::persistObject");
	}

	object->setPersistent(persistenceLevel);

	updatePersistentObject(object);
}

void ObjectManager::persistSceneObjectsRecursively(SceneObject* object, int persistenceLevel) {
	persistObject(object, persistenceLevel, "sceneobjects");

	SortedVector<ManagedReference<SceneObject* > >* childObjects = object->getChildObjects();

	for (int i = 0; i < childObjects->size(); i++) {
		SceneObject* childObject = childObjects->get(i).get();

		if (childObject != nullptr)
			persistSceneObjectsRecursively(childObject, persistenceLevel);
	}

	VectorMap<String, ManagedReference<SceneObject* > >* slottedObjects = object->getSlottedObjects();

	for (int i = 0; i < slottedObjects->size(); i++) {
		SceneObject* slottedObject = slottedObjects->get(i).get();

		if (slottedObject != nullptr)
			persistSceneObjectsRecursively(slottedObject, persistenceLevel);
	}

	const VectorMap<unsigned long long, ManagedReference<SceneObject* > >* containerObjects = object->getContainerObjects();

	for (int i = 0; i < containerObjects->size(); i++) {
		SceneObject* containerObject = containerObjects->get(i).get();

		if (containerObject != nullptr)
			persistSceneObjectsRecursively(containerObject, persistenceLevel);
	}
}

Reference<DistributedObjectStub*> ObjectManager::loadPersistentObject(uint64 objectID) {
	Reference<DistributedObjectStub*> object = nullptr;

	uint16 tableID = (uint16)(objectID >> 48);

	debug() << "trying to get database with table id 0x" << hex << tableID << " with obejct id 0x" << hex << objectID;

	LocalDatabase* db = databaseManager->getDatabase(tableID);

	if (db == nullptr || !db->isObjectDatabase())
		return nullptr;

	ObjectDatabase* database = cast<ObjectDatabase*>( db);

	// only for debugging proposes
	ObjectInputStream objectData(500);

	if (database->getData(objectID, &objectData, berkeley::LockMode::READ_UNCOMMITED, false, true)) {
		return nullptr;
	}

	uint32 serverObjectCRC = 0;
	String className;

	Locker _locker(this);

	DistributedObject* dobject = getObject(objectID);

	if (dobject != nullptr) {
		//error("different object already in database");
		return cast<DistributedObjectStub*>(dobject);
	}

	try {
		if (Serializable::getVariable<uint32>(serverObjectCrcHashCode, &serverObjectCRC, &objectData)) {
			object = instantiateSceneObject(serverObjectCRC, objectID, true);

			if (object == nullptr) {
				error("could not load object from database");
				return nullptr;
			}

			_locker.release();

			SceneObject* scene = object.castTo<SceneObject*>();

			String loggingName = scene->getLoggingName();
			uint32 templateObjectType = scene->getGameObjectType();

			deSerializeObject(scene, &objectData);

			scene->setGameObjectType(templateObjectType); // we dont want this to be the old one

			scene->setLoggingName(loggingName);

			scene->debug("loaded from db");
		} else if (Serializable::getVariable<String>(_classNameHashCode, &className, &objectData)) {
			object = createObject(className, false, "", objectID, false);

			if (object == nullptr) {
				error("could not load object from database");
				return nullptr;
			}

			_locker.release();

			deSerializeObject(object.castTo<ManagedObject*>(), &objectData);
		} else {
			error("could not load object from database, unknown template crc or class name");
		}
	} catch (...) {
		error("could not load object from database");

		throw;
	}

	return object;
}


void ObjectManager::deSerializeObject(ManagedObject* object, ObjectInputStream* data) {
	Locker _locker(object);

	try {
		object->readObject(data);

	//	uint32 lastSaveCRC = managedObject->getLastCRCSave();

		uint32 currentCRC = BaseProtocol::generateCRC(data);

		object->setLastCRCSave(currentCRC);

		object->notifyLoadFromDatabase();

	} catch (Exception& e) {
		error(e.getMessage());
		e.printStackTrace();

		SceneObject* sceno = cast<SceneObject*>(object);

		if (sceno) {
			String dbName;
			uint16 tableID = (uint16)(sceno->getObjectID() >> 48);
			ObjectDatabaseManager::instance()->getDatabaseName(tableID, dbName);

			error() << "could not deserialize scene object of type: " << sceno->getGameObjectType() << " from DB: " << dbName;
		} else {
			error("could not deserialize managed object from DB");
		}
	} catch (...) {
		error("could not deserialize object from DB");

		throw;
	}
}

SceneObject* ObjectManager::instantiateSceneObject(uint32 objectCRC, uint64 oid, bool createComponents) {
	SceneObject* object = nullptr;

	Locker _locker(this);

	object = loadObjectFromTemplate(objectCRC);

	if (object == nullptr)
		return nullptr;

	object->setZoneProcessServer(server);

	object->_setObjectID(oid);

	if (createComponents)
		object->createComponents();

	String logName = object->getLoggingName();

	StringBuffer newLogName;
	newLogName << logName << " 0x" << hex << uppercase << oid;

	object->setLoggingName(newLogName.toString());

	object->deploy(newLogName.toString());

	debug() << "deployed.." << newLogName;

	return object;
}

SceneObject* ObjectManager::createObject(uint32 objectCRC, int persistenceLevel, const String& database, uint64 oid, bool initializeTransientMembers) {
	SceneObject* object = nullptr;

	loadTable(database, oid);

	if (oid == 0) {
		oid = getNextObjectID(database);
	}

	object = instantiateSceneObject(objectCRC, oid, true);

	if (object == nullptr) {
		error() << "could not create object CRC = 0x" << hex << objectCRC << " template:" << templateManager->getTemplateFile(objectCRC);
		return nullptr;
	}

	object->setPersistent(persistenceLevel);

	if (initializeTransientMembers)
		object->initializeTransientMembers();

	if (persistenceLevel > 0) {
		updatePersistentObject(object);
	}

	return object;
}

ManagedObject* ObjectManager::createObject(const String& className, int persistenceLevel, const String& database, uint64 oid, bool initializeTransientMembers) {
	ManagedObject* object = nullptr;

	Locker _locker(this);

	DistributedObjectBroker* broker = DistributedObjectBroker::instance();

	object = cast<ManagedObject*>(broker->createObjectStub(className, ""));
	DistributedObjectServant* servant = broker->createObjectServant(className, object);

	loadTable(database, oid);

	if (oid == 0) {
		oid = getNextObjectID(database);
	}

	object->_setObjectID(oid);

	servant->_serializationHelperMethod();

	object->setPersistent(persistenceLevel);

	if (initializeTransientMembers)
		object->initializeTransientMembers();

	object->deploy();

	databaseManager->addTemporaryObject(object);

	if (persistenceLevel > 0) {
		updatePersistentObject(object);
	}

	return object;
}

void ObjectManager::createObjectID(const String& name, DistributedObjectStub* object) {
	Locker _locker(this);

	uint64 objectid = object->_getObjectID();

	if (objectid == 0) {
		objectid = getNextFreeObjectID();
		object->_setObjectID(objectid);
	}

	if (name.isEmpty()) {
		/*if (object->_getName().isEmpty())*/ {
			StringBuffer orbname;
			orbname << "_OrbObject" << objectid;

			object->_setName(orbname.toString());
		}
	} else
		object->_setName(name);
}

uint64 ObjectManager::getNextObjectID(const String& database) {
	uint64 oid = 0;

	if (database.length() > 0) {
		uint16 tableID;

		tableID = databaseManager->getDatabaseID(database);

		oid += tableID;

		oid = oid << 48;
	}

	oid += getNextFreeObjectID();

	return oid;
}

uint64 ObjectManager::getNextFreeObjectID() {
	//assert(DistributedObjectBroker::instance()->isRootBroker());

	return DOBObjectManager::getNextFreeObjectID();
//	its saved every 5min, that should be enough
//	databaseManager->updateLastUsedObjectID(val);

	//return nextObjectID;
}

ObjectDatabase* ObjectManager::loadTable(const String& database, uint64 objectID) {
	ObjectDatabase* table = nullptr;

	if (database.length() > 0) {
		if (objectID != 0) {
			uint16 tableID = (uint16) (objectID >> 48);

			table = databaseManager->loadObjectDatabase(database, true, tableID);
		} else {
			table = databaseManager->loadObjectDatabase(database, true);
		}
	}

	return table;
}

int ObjectManager::destroyObjectFromDatabase(uint64 objectID) {
	Locker _locker(this);

	Reference<DistributedObject*> obj = getObject(objectID);

	if (obj == nullptr)
		obj = loadPersistentObject(objectID);

	if (obj != nullptr) {
		//setLogging(true);
		//info("Marking " + String::valueOf(objectID) + " for deletion deletion", true);
	//	setLogging(false);
		obj->_setMarkedForDeletion(true);

	}

	return 1;
}

void ObjectManager::printInfo() {
	info(true) << "total objects in map " << localObjectDirectory.getSize();
}

String ObjectManager::getInfo() {
	StringBuffer msg;
	msg << "total objects in map " << localObjectDirectory.getSize();
	return msg.toString();
}

void ObjectManager::onUpdateModifiedObjectsToDatabase(int flags) {
	galaxyId = -1;

	if (server != nullptr && server->getZoneServer() != nullptr) {
		galaxyId = server->getZoneServer()->getGalaxyID();

		//characters_dirty chars
		try {
			const static auto query = "SELECT * FROM characters_dirty WHERE galaxy_id = " + String::valueOf(galaxyId);

			charactersSaved = ServerDatabase::instance()->executeQuery(query);
		} catch (const Exception& e) {
			error(e.getMessage());
		}
	}
}

void ObjectManager::onCommitData() {
	if (charactersSaved != nullptr) {
		try {
			StringBuffer query;
			query << "REPLACE INTO characters (character_oid, account_id, galaxy_id, firstname, surname, race, gender, template) VALUES";

			StringBuffer deleteQuery;
			deleteQuery << "DELETE FROM characters_dirty WHERE ";

			bool first = true;

			int count = 0;

			while (charactersSaved->next()) {
				if (!first) {
					query << ",";
					deleteQuery << " OR ";
				}

				query << "(" << charactersSaved->getUnsignedLong(0) << ", " << charactersSaved->getInt(1) << ", "
						<< charactersSaved->getInt(2) << ", " << "\'" << String(charactersSaved->getString(3)).escapeString() << "\', "
						<< "\'" << String(charactersSaved->getString(4)).escapeString() << "\', " << charactersSaved->getInt(5) << ", "
						<< charactersSaved->getInt(6) << ", \'" << String(charactersSaved->getString(7)).escapeString() << "')";

				deleteQuery << "character_oid = " << charactersSaved->getUnsignedLong(0) << " AND galaxy_id = " << galaxyId;

				first = false;
				++count;
			}

			if (count > 0) {
				ServerDatabase::instance()->executeStatement(query.toString());
				ServerDatabase::instance()->executeStatement(deleteQuery.toString());
			}
		} catch (Exception& e) {
			System::out << e.getMessage();
		}
	}

	//Spawn the delete characters task.
	if (deleteCharactersTask != nullptr && !deleteCharactersTask->isScheduled()) {
		deleteCharactersTask->updateDeletedCharacters();
		int mins = ConfigManager::instance()->getPurgeDeletedCharacters();
		deleteCharactersTask->schedule(mins * 60 * 1000);
	}
}

void ObjectManager::cancelDeleteCharactersTask() {
	if (deleteCharactersTask->isScheduled()) {
		deleteCharactersTask->cancel();
	}

	deleteCharactersTask = nullptr;
}

void ObjectManager::stopUpdateModifiedObjectsThreads() {
	for (int i = updateModifiedObjectsThreads.size() - 1; i >= 0; --i) {
		engine::ORB::UpdateModifiedObjectsThread* thread = updateModifiedObjectsThreads.get(i);
		thread->stopWork();
		delete thread;
	}
}

void ObjectManager::shutdown() {
	stopUpdateModifiedObjectsThreads();
	CommitMasterTransactionThread::instance()->shutdown();
	databaseManager->closeDatabases();
	databaseManager->finalizeInstance();
	databaseManager = nullptr;
	server = nullptr;
	charactersSaved = nullptr;
	templateManager = nullptr;
}
