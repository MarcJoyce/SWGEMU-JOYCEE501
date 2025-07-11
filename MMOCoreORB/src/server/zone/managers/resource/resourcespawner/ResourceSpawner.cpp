/*
 				Copyright <SWGEmu>
		See file COPYING for copying conditions. */

#include "ResourceSpawner.h"
#include "server/zone/Zone.h"
#include "server/zone/objects/player/PlayerObject.h"
#include "server/zone/objects/tangible/tool/SurveyTool.h"
#include "server/zone/objects/tangible/tool/recycle/RecycleTool.h"
#include "server/zone/objects/resource/ResourceContainer.h"
#include "templates/params/creature/CreatureAttribute.h"
#include "server/zone/packets/resource/ResourceListForSurveyMessage.h"
#include "server/zone/packets/resource/SurveyMessage.h"
#include "server/zone/objects/waypoint/WaypointObject.h"
#include "templates/params/ObserverEventType.h"
#include "server/zone/packets/scene/PlayClientEffectLocMessage.h"
#include "server/zone/managers/player/PlayerManager.h"
#include "server/zone/objects/player/sui/listbox/SuiListBox.h"
#include "server/zone/objects/player/sessions/survey/SurveySession.h"
#include "server/zone/managers/stringid/StringIdManager.h"

ResourceSpawner::ResourceSpawner(ManagedReference<ZoneServer*> serv,
		ZoneProcessServer* impl) {

	server = serv;
	processor = impl;
	databaseManager = ObjectDatabaseManager::instance();

	resourceTree = nullptr;
	lowerGateOverride = 0;
	resourceMap = nullptr;
	maxSpawnAmount = 0;
	scriptLoading = false;
	shiftDuration = 0;
	spawnThrottling = 0;

	Logger::setLoggingName("ResourceSpawner");

	nameManager = processor->getNameManager();
	objectManager = server->getObjectManager();
	samplingMultiplier = 1; //should be 1 for normal use

	minimumPool = new MinimumPool(this);
	fixedPool = new FixedPool(this);
	randomPool = new RandomPool(this);
	nativePool = new NativePool(this);
	manualPool = new ManualPool(this);
}

ResourceSpawner::~ResourceSpawner() {
	delete resourceTree;
	delete minimumPool;
	delete fixedPool;
	delete randomPool;
	delete nativePool;
	delete manualPool;

	delete resourceMap;

	activeResourceZones.removeAll();
}

void ResourceSpawner::init() {

	resourceTree = new ResourceTree(this);
	resourceMap = new ResourceMap();
}

void ResourceSpawner::initializeMinimumPool(LuaObject includes,
		const String& excludes) {
	minimumPool->initialize(includes, excludes);
}

void ResourceSpawner::initializeFixedPool(LuaObject includes,
		const String& excludes) {
	fixedPool->initialize(includes, excludes);
}

void ResourceSpawner::initializeRandomPool(LuaObject includes,
		const String& excludes, const int size) {
	randomPool->initialize(includes, excludes, size);
}

void ResourceSpawner::initializeNativePool(const String& includes,
		const String& excludes) {
	nativePool->initialize(includes, excludes);
}

void ResourceSpawner::addZone(const String& zoneName) {
	activeResourceZones.add(zoneName);
	nativePool->addZone(zoneName);
}

void ResourceSpawner::removeZone(const String& zoneName) {
	activeResourceZones.removeElement(zoneName);
	nativePool->removeZone(zoneName);
}

void ResourceSpawner::addJtlResource(const String& resourceName) {
	jtlResources.add(resourceName);
}

void ResourceSpawner::setSpawningParameters(bool loadFromScript, const int dur, const int throt,
		const int override, const int spawnquantity) {

	scriptLoading = loadFromScript;
	shiftDuration = dur;
	lowerGateOverride = override;
	maxSpawnAmount = spawnquantity;

	spawnThrottling = throt;

	if (spawnThrottling > 90)
		spawnThrottling = 90;
	if (spawnThrottling < 10)
		spawnThrottling = 10;

	if (lowerGateOverride < 1)
		lowerGateOverride = 1;
	if (lowerGateOverride > 1000)
		lowerGateOverride = 1000;
}

void ResourceSpawner::start() {
	loadResourceSpawns();
	shiftResources();
}

void ResourceSpawner::loadResourceSpawns() {

	ObjectDatabase* resourceDatabase =
			ObjectDatabaseManager::instance()->loadObjectDatabase("resourcespawns",
					true);

	ObjectDatabaseManager::instance()->commitLocalTransaction();
	ObjectDatabaseIterator iterator(resourceDatabase, true);

	uint64 objectID = 0;

	while (iterator.getNextKey(objectID)) {

		Reference<ResourceSpawn*> resourceSpawn = Core::getObjectBroker()->lookUp(objectID).castTo<ResourceSpawn*>();
		//ObjectDatabaseManager::instance()->commitLocalTransaction();

		if (resourceSpawn == nullptr) {
			error("Trying to load object as ResourceSpawn that is not a resource spawn");
			continue;
		}

		// Create spawn maps for zones that were disabled when the resource spawned
		if (resourceSpawn->inShift()) {
			auto resourceEntry = resourceTree->getEntry(resourceSpawn->getType());

			if (resourceEntry != nullptr) {
				int minPool = resourceEntry->getMinpool();
				int spawnMapSize = resourceSpawn->getSpawnMapSize();

				if (spawnMapSize < minPool) {
					Vector<String> activeZones;
					activeResourceZones.clone(activeZones);

					for (int i = 0; i < spawnMapSize; i++) {
						activeZones.removeElement(resourceSpawn->getSpawnMapZone(i));
					}

					Locker locker(resourceSpawn);

					resourceSpawn->createSpawnMaps(resourceEntry->isJTL(), minPool - spawnMapSize,
							resourceEntry->getMaxpool() - spawnMapSize, resourceEntry->getZoneRestriction(), activeZones);
				}
			}
		}

		resourceMap->add(resourceSpawn->getName(), resourceSpawn);

		if (!resourceSpawn->inShift()) {
			despawn(resourceSpawn);
			continue;
		}

		if (resourceSpawn->getSpawnPool() != 0) {
			Locker locker(resourceSpawn);

			switch (resourceSpawn->getSpawnPool()) {
			case ResourcePool::MINIMUMPOOL:
				minimumPool->addResource(resourceSpawn, resourceSpawn->getPoolSlot());
				break;
			case ResourcePool::RANDOMPOOL:
				randomPool->addResource(resourceSpawn, resourceSpawn->getPoolSlot());
				break;
			case ResourcePool::FIXEDPOOL:
				fixedPool->addResource(resourceSpawn, resourceSpawn->getPoolSlot());
				break;
			case ResourcePool::NATIVEPOOL:
				nativePool->addResource(resourceSpawn, resourceSpawn->getPoolSlot());
				break;
			case ResourcePool::MANUALPOOL:
				manualPool->addResource(resourceSpawn, resourceSpawn->getPoolSlot());
				break;
			}
		}
	}

	if(resourceMap->size() == 0 && scriptLoading) {

		spawnScriptResources();

	}

	String built = "Resource Map Built with " + String::valueOf(
			resourceMap->size()) + " resources";
	info(built, true);

}

void ResourceSpawner::spawnScriptResources() {

	Lua* lua = new Lua();
	lua->init();

	if (!lua->runFile("scripts/managers/resource_manager_spawns.lua")) {
		error("Invalid script = 'scripts/managers/resource_manager_spawns.lua'");
		delete lua;
		return;
	}

	LuaObject luaObject = lua->getGlobalObject("resources");
	if (!luaObject.isValidTable()) {
		error("Invalid table = 'scripts/managers/resource_manager_spawns.lua'");
		delete lua;
		return;
	}

	for(int i = 1; i <= luaObject.getTableSize(); ++i) {

		LuaObject resource = luaObject.getObjectAt(i);
		if(!resource.isValidTable())
			continue;

		Reference<ResourceSpawn*> newSpawn = dynamic_cast<ResourceSpawn*>
			(objectManager->createObject(0xb2825c5a, 1, "resourcespawns"));

		if (newSpawn == nullptr) {
			error("createResourceSpawn is trying to create a resourcespawn with the wrong type");
			continue;
		}

		Locker locker(newSpawn);

		newSpawn->setType(resource.getStringField("type"));
		newSpawn->setName(resource.getStringField("name"));

		LuaObject classes = resource.getObjectField("classes");

		for (int j = 1; j <= classes.getTableSize(); ++j) {
			LuaObject classesEntry = classes.getObjectAt(j);

			newSpawn->addClass(classesEntry.getStringAt(1));
			newSpawn->addStfClass(classesEntry.getStringAt(2));

			classesEntry.pop();
		}

		resource.pop();

		LuaObject attributes = resource.getObjectField("attributes");

		for (int j = 1; j <= attributes.getTableSize(); ++j) {
			LuaObject attributesEntry = attributes.getObjectAt(j);

			newSpawn->addAttribute(attributesEntry.getStringAt(1), attributesEntry.getIntAt(2));

			attributesEntry.pop();
		}

		resource.pop();

		newSpawn->setDespawned(time(0));

		newSpawn->setZoneRestriction(resource.getStringField("zoneRestriction"));
		newSpawn->setSurveyToolType(resource.getIntField("surveyToolType"));
		newSpawn->setContainerCRC(resource.getIntField("containerCRC"));

		if (newSpawn->isType("energy") || newSpawn->isType("radioactive"))
			newSpawn->setIsEnergy(true);

		resourceMap->add(newSpawn->getName(), newSpawn);

		luaObject.pop();
	}

	delete lua;
}

bool ResourceSpawner::writeAllSpawnsToScript() {

	if(!scriptLoading)
		return false;

	try {

		File* file = new File("scripts/managers/resource_manager_spawns.lua");
		//if(!file->exists()) {
		//	delete file;
		//	return;
		//}

		FileWriter* writer = new FileWriter(file);

		writer->writeLine("resources = {");

		for(int i = 0; i < resourceMap->size(); ++i) {

			ManagedReference<ResourceSpawn*> spawn = resourceMap->get(i);

			writer->writeLine("	{");

			writer->writeLine("		name = \"" + spawn->getName() + "\",");
			writer->writeLine("		type = \"" + spawn->getType() + "\",");

			writer->writeLine("		classes = {");
			for(int i = 0; i < 8; ++i) {
				String spawnClass = spawn->getClass(i);
				if(spawnClass != "") {
					String spawnClass2 = spawn->getStfClass(i);
					writer->writeLine("			{\"" + spawnClass + "\", \"" + spawnClass2 + "\"},");
				}
			}
			writer->writeLine("		},");

			writer->writeLine("		attributes = {");
			for(int i = 0; i < 12; ++i) {
				String attribute = "";
				int value = spawn->getAttributeAndValue(attribute, i);
				if(attribute != "") {
					writer->writeLine("			{\"" + attribute + "\", " + String::valueOf(value) + "},");
				}
			}

			writer->writeLine("		},");

			writer->writeLine("		zoneRestriction = \"" + spawn->getZoneRestriction() + "\",");
			writer->writeLine("		surveyToolType = " + String::valueOf(spawn->getSurveyToolType()) + ",");
			writer->writeLine("		containerCRC = " + String::valueOf(spawn->getContainerCRC()) + ",");

			writer->writeLine("	},");
			writer->writeLine("");
		}

		writer->writeLine("}");

		writer->close();

		delete file;
		delete writer;

		return true;
	} catch (Exception& e) {
		error("Error dumping resources");
		return false;
	}

	return true;
}

void ResourceSpawner::shiftResources() {
	randomPool->update();
	fixedPool->update();
	nativePool->update();
	minimumPool->update();
	manualPool->update();

	dumpResources();
}

ResourceSpawn* ResourceSpawner::createRecycledResourceSpawn(const ResourceTreeEntry* entry) const {
	ResourceSpawn* newSpawn = dynamic_cast<ResourceSpawn*> (objectManager->createObject(0xb2825c5a, 1, "resourcespawns"));

	if (newSpawn == nullptr) {
		error("createResourceSpawn is trying to create a resourcespawn with the wrong type");
		return nullptr;
	}

	Locker locker(newSpawn);

	newSpawn->setType(entry->getType());
	newSpawn->setName(entry->getFinalClass());

	for (int i = 0; i < entry->getClassCount(); ++i) {
		String resClass = entry->getClass(i);
		newSpawn->addClass(resClass);

	}

	for (int i = 0; i < entry->getStfClassCount(); ++i) {
		String resClass = entry->getStfClass(i);
		newSpawn->addStfClass(resClass);
	}

	for (int i = 0; i < entry->getAttributeCount(); ++i) {
		auto attrib = entry->getAttribute(i);
		newSpawn->addAttribute(attrib->getName(), 200);
	}

	newSpawn->setZoneRestriction(entry->getZoneRestriction());

	newSpawn->setSurveyToolType(entry->getSurveyToolType());

	newSpawn->setContainerCRC(entry->getContainerCRC());

	if (newSpawn->isType("energy") || newSpawn->isType("radioactive"))
		newSpawn->setIsEnergy(true);

	resourceMap->add(newSpawn->getName(), newSpawn);

	return newSpawn;
}

ResourceSpawn* ResourceSpawner::manualCreateResourceSpawn(CreatureObject* player, const UnicodeString& args) {
	StringTokenizer tokenizer(args.toString());
	tokenizer.setDelimeter(" ");

	if (!tokenizer.hasMoreTokens()) {
		return nullptr;
	}

	String type;
	tokenizer.getStringToken(type);
	VectorMap<String, int> attributes;

	try {
		while(tokenizer.hasMoreTokens()) {
			String token;
			tokenizer.getStringToken(token);

			StringTokenizer izer(token);
			izer.setDelimeter(",");

			String att;
			izer.getStringToken(att);

			if (!izer.hasMoreTokens()) {
				throw Exception();
			}

			int value = izer.getIntToken();

			if (value < 1) {
				value = 1;
			} else if (value > 1000) {
				value = 1000;
			}

			attributes.put(att, value);
		}
	} catch (Exception& e) {
		player->sendSystemMessage("Invalid arguments for /gmCreateSpecificResource: type <attribute,value> ..");
		return nullptr;
	}

	ResourceSpawn* resourceSpawn = createResourceSpawn(type);

	if (resourceSpawn != nullptr) {
		Locker locker(resourceSpawn);

		for (int i = 0; i < attributes.size(); i++) {
			String key = attributes.elementAt(i).getKey();
			if (resourceSpawn->getValueOf(key) > 0) {
				resourceSpawn->addAttribute(key, attributes.get(i));
			}
		}

		manualPool->addResource(resourceSpawn, "any");
	}

	return resourceSpawn;
}

ResourceSpawn* ResourceSpawner::createResourceSpawn(const String& type,
		const Vector<String>& excludes, const String& zonerestriction) {

	if(type.isEmpty())
		return nullptr;

	auto resourceEntry = resourceTree->getEntry(type, excludes,
			zonerestriction);

	if (resourceEntry == nullptr) {
		info("Resource type not found: " + type);
		return nullptr;
	}

	String name = makeResourceName(resourceEntry->getRandomNameClass());

	ResourceSpawn* newSpawn =
			dynamic_cast<ResourceSpawn*> (objectManager->createObject(
					0xb2825c5a, 1, "resourcespawns"));

	if (newSpawn == nullptr) {
		error("createResourceSpawn is trying to create a resourcespawn with the wrong type");
		return nullptr;
	}

	Locker locker(newSpawn);

	String resType = resourceEntry->getType();
	newSpawn->setType(resType);

	newSpawn->setName(name);

	for (int i = 0; i < resourceEntry->getClassCount(); ++i) {
		String resClass = resourceEntry->getClass(i);
		newSpawn->addClass(resClass);

	}

	for (int i = 0; i < resourceEntry->getStfClassCount(); ++i) {
		String resClass = resourceEntry->getStfClass(i);
		newSpawn->addStfClass(resClass);
	}

	for (int i = 0; i < resourceEntry->getAttributeCount(); ++i) {
		auto attrib = resourceEntry->getAttribute(i);
		int randomValue = randomizeValue(attrib->getMinimum(),
				attrib->getMaximum());
		String attribName = attrib->getName();
		int index = attrib->getIndex();
		newSpawn->addAttribute(attribName, randomValue);
	}

	long expires = getRandomExpirationTime(resourceEntry);
	newSpawn->setDespawned(expires);

	newSpawn->setZoneRestriction(resourceEntry->getZoneRestriction());

	newSpawn->setSurveyToolType(resourceEntry->getSurveyToolType());

	newSpawn->setContainerCRC(resourceEntry->getContainerCRC());

	Vector<String> activeZones;
	activeResourceZones.clone(activeZones);

	newSpawn->createSpawnMaps(resourceEntry->isJTL(),
			resourceEntry->getMinpool(), resourceEntry->getMaxpool(),
			resourceEntry->getZoneRestriction(), activeZones);

	if (newSpawn->isType("energy") || newSpawn->isType("radioactive"))
		newSpawn->setIsEnergy(true);

	resourceMap->add(name, newSpawn);

	//resourceEntry->toString();
	//newSpawn->print();
	return newSpawn;
}

ResourceSpawn* ResourceSpawner::createResourceSpawn(const String& type,
		const String& zonerestriction) {
	Vector<String> excludes;

	return createResourceSpawn(type, excludes, zonerestriction);
}

ResourceSpawn* ResourceSpawner::createResourceSpawn(
		const Vector<String>& includes, const Vector<String>& excludes,
		const String& zonerestriction) {

	String type = includes.get(System::random(includes.size() - 1));

	return createResourceSpawn(type, excludes, zonerestriction);
}

void ResourceSpawner::despawn(ResourceSpawn* spawn) {
	Locker locker(spawn);

	for(int i = 0; i < spawn->getSpawnMapSize(); ++i) {
		String zone = spawn->getSpawnMapZone(i);
		resourceMap->remove(spawn, zone);
	}

	spawn->setSpawnPool(ResourcePool::NOPOOL, "");
}

String ResourceSpawner::makeResourceName(const String& randomNameClass) {
	String randname;

	while (true) {
		randname = nameManager->generateResourceName(randomNameClass);

		if (!resourceMap->contains(randname.toLowerCase()) && resourceTree->getEntry(randname) == nullptr)
			break;
	}

	return randname;
}

int ResourceSpawner::randomizeValue(int min, int max) {
	if (min == 0 && max == 0)
		return 0;

	if (min > lowerGateOverride)
		min = lowerGateOverride;

	int randomStat = System::random(max - min) + min;

	if (spawnThrottling < 90) {
		int breakpoint = ((spawnThrottling * (max - min)) / 100) + min;
		bool aboveBreakpoint = System::random(9) == 7;

		if ((aboveBreakpoint && randomStat < breakpoint) || (!aboveBreakpoint && randomStat > breakpoint)) {
			if (aboveBreakpoint) {
				while (randomStat < breakpoint)
					randomStat = System::random(max - min) + min;
			} else {
				while (randomStat > breakpoint)
					randomStat = System::random(max - min) + min;
			}
		}
	}

	randomStat = 1000;

	return randomStat;
}

long ResourceSpawner::getRandomExpirationTime(const ResourceTreeEntry* resourceEntry) {
	if (resourceEntry->isOrganic())
		return getRandomUnixTimestamp(365, 365);

	else if (resourceEntry->isJTL())
		return getRandomUnixTimestamp(365, 365);

	else
		return getRandomUnixTimestamp(365, 365);
}

long ResourceSpawner::getRandomUnixTimestamp(int min, int max) const {
	return time(0) + (System::random((max * shiftDuration) - (min
			* shiftDuration)) + min * shiftDuration);

}

const Vector<String>& ResourceSpawner::getActiveResourceZones() const {
	return activeResourceZones;
}

const Vector<String>& ResourceSpawner::getJtlResources() const {
	return jtlResources;
}

bool ResourceSpawner::isRecycledResource(const ResourceSpawn* resource) const {
	auto entry = resourceTree->getEntry(resource->getType());

	if (entry == nullptr)
		return false;

	return entry->isRecycled();
}

ResourceSpawn* ResourceSpawner::getRecycledVersion(const ResourceSpawn* resource) const {
	auto startingEntry = resourceTree->getEntry(resource->getType());

	if (startingEntry == nullptr)
		return nullptr;

	int recycleType = startingEntry->getRecycleToolType();

	const ResourceTreeEntry* recycledEntry = nullptr;
	ManagedReference<ResourceSpawn*> recycledVersion = nullptr;

	switch(recycleType) {
	case RecycleTool::NOTYPE:
		return nullptr;
		break;
	case RecycleTool::CHEMICALS:
		recycledEntry = resourceTree->getEntry("chemical_compound");
		break;
	case RecycleTool::WATER:
		recycledEntry = resourceTree->getEntry("water_solution");
		break;
	case RecycleTool::RADIOACTIVE:
		recycledEntry = resourceTree->getEntry("combined_radioactive_isotpopes");
		break;
	case RecycleTool::SOLIDFUEL:
		recycledEntry = resourceTree->getEntry("degraded_fuel_petrochem_solid");
		break;
	case RecycleTool::HIDE:
		recycledEntry = resourceTree->getEntry("synthesized_hides");
		break;
	case RecycleTool::MEAT:
		recycledEntry = resourceTree->getEntry("processed_meat");
		break;
	case RecycleTool::BONE:
		recycledEntry = resourceTree->getEntry("ground_bones");
		break;
	case RecycleTool::HORN:
		recycledEntry = resourceTree->getEntry("bone_horn_ground");
		break;
	case RecycleTool::SEAFOOD:
		recycledEntry = resourceTree->getEntry("processed_seafood");
		break;
	case RecycleTool::MILK:
		recycledEntry = resourceTree->getEntry("milk_homogenized");
		break;
	case RecycleTool::CEREAL:
		recycledEntry = resourceTree->getEntry("processed_cereal");
		break;
	case RecycleTool::FRUIT:
		recycledEntry = resourceTree->getEntry("mixed_fruits");
		break;
	case RecycleTool::VEGETABLE:
		recycledEntry = resourceTree->getEntry("mixed_vegetables");
		break;
	case RecycleTool::WOOD:
		recycledEntry = resourceTree->getEntry("processed_wood");
		break;
	case RecycleTool::FERROUS:
		if (resource->isUnknownType())
			recycledEntry = resourceTree->getEntry("smelted_metal_ferrous_unknown");
		else if (resource->isType("iron"))
			recycledEntry = resourceTree->getEntry("iron_smelted");
		else if (resource->isType("steel"))
			recycledEntry = resourceTree->getEntry("steel_smelted");
		break;
	case RecycleTool::NONFERROUS:
		if (resource->isUnknownType())
			recycledEntry = resourceTree->getEntry("smelted_metal_nonferrous_unknown");
		else if (resource->isType("aluminum"))
			recycledEntry = resourceTree->getEntry("aluminum_smelted");
		else if (resource->isType("copper"))
			recycledEntry = resourceTree->getEntry("copper_smelted");
		break;
	case RecycleTool::IGNEOUS:
		recycledEntry = resourceTree->getEntry("ore_extrusive_low_grade");
		break;
	case RecycleTool::SEDIMENTARY:
		recycledEntry = resourceTree->getEntry("ore_carbonate_low_grade");
		break;
	case RecycleTool::GEMSTONE:
		recycledEntry = resourceTree->getEntry("gemstone_mixed_low_quality");
		break;
	}

	if (recycledEntry == nullptr)
		return nullptr;

	if (resourceMap->containsType(recycledEntry->getFinalClass())) {
		recycledVersion = resourceMap->get(recycledEntry->getFinalClass().toLowerCase());
	} else {
		recycledVersion = createRecycledResourceSpawn(recycledEntry);
	}

	return recycledVersion;
}

int ResourceSpawner::sendResourceRecycleType(const ResourceSpawn* resource) const {
	auto entry = resourceTree->getBaseNode()->find(resource->getType(), nullptr);
	return entry->getRecycleToolType();
}

void ResourceSpawner::sendResourceListForSurvey(CreatureObject* player,
		const int toolType, const String& surveyType) const {

	Zone* zone = player->getZone();

	if (zone == nullptr)
		return;

	ZoneResourceMap* zoneMap = resourceMap->getZoneResourceList(zone->getZoneName());
	if (zoneMap == nullptr) {
		player->sendSystemMessage("The tool fails to locate any resources");
		return;
	}

	ResourceListForSurveyMessage* message = new ResourceListForSurveyMessage();
	VectorMap<uint64, ManagedReference<ResourceSpawn*> > matchingResources;
	matchingResources.setAllowDuplicateInsertPlan();

	for (int i = 0; i < zoneMap->size(); ++i) {
		auto resourceSpawn = zoneMap->get(i);

		if (!resourceSpawn->inShift())
			continue;

		if (resourceSpawn->getSurveyToolType() == toolType || (toolType == SurveyTool::INORGANIC && resourceSpawn->isType("inorganic"))) {
			matchingResources.put(resourceSpawn->getDespawned(), resourceSpawn);
		}
	}

	for (int i = matchingResources.size() - 1; i >= 0; --i) {
		auto resourceSpawn = matchingResources.elementAt(i).getValue();
		message->addResource(resourceSpawn->getName(), resourceSpawn->getType(), resourceSpawn->_getObjectID());
	}

	message->finish(surveyType, player->getObjectID());

	player->sendMessage(message);
}

void ResourceSpawner::sendSurvey(CreatureObject* player, const String& resname) const {

	/*if (player->getHAM(CreatureAttribute::MIND) < 100) {
		player->setPosture(CreaturePosture::UPRIGHT, true);
		player->sendSystemMessage("@error_message:survey_mind"); //You are exhausted. You nee to clear your head before you can survey again.
		return;
	}*/

	//Adjust cost based upon player's focus
	int mindCost = 100 - (int)(player->getHAM(CreatureAttribute::FOCUS)/15.f);
	mindCost = 0;

	player->inflictDamage(player, CreatureAttribute::MIND, mindCost, false, true);

	ManagedReference<SurveySession*> session = player->getActiveSession(SessionFacadeType::SURVEY).castTo<SurveySession*>();
	if(session == nullptr) {
		return;
	}

	ManagedReference<SurveyTool*> surveyTool = session->getActiveSurveyTool().get();

	if (surveyTool == nullptr || !resourceMap->contains(resname.toLowerCase()) || player->getZone() == nullptr)
		return;

	String zoneName = player->getZone()->getZoneName();
	ManagedReference<PlayerObject*> ghost = player->getPlayerObject();

	SurveyMessage* surveyMessage = new SurveyMessage();

	int toolRange = surveyTool->getRange(player);
	int points = surveyTool->getPoints();

	if (toolRange > 1024 || toolRange < 0)
		toolRange = 320;

	if (points <= 0 || points > 6)
		points =  3;

	float spacer = float(toolRange) / float(points - 1);

	float posX = player->getPositionX() - (((points - 1) / 2.0f) * spacer);
	float posY = player->getPositionY() + (((points - 1) / 2.0f) * spacer);

	float maxDensity = -1;
	float maxX = 0, maxY = 0;

	for (int i = 0; i < points; i++) {
		for (int j = 0; j < points; j++) {

			float density = resourceMap->getDensityAt(resname, zoneName, posX, posY);

			if (density > maxDensity) {
				maxDensity = density;
				maxX = posX;
				maxY = posY;
			}

			surveyMessage->add(posX, posY, density);

			posX += spacer;
		}

		posY -= spacer;
		posX -= (points * spacer);
	}

	ManagedReference<WaypointObject*> waypoint = nullptr;

	if (maxDensity >= 0.1f) {

		// Get previous survey waypoint
		waypoint = ghost->getSurveyWaypoint();

		// Create new waypoint
		if (waypoint == nullptr)
			waypoint = ( server->createObject(0xc456e788, 1)).castTo<WaypointObject*>();

		Locker locker(waypoint);

		// Update new waypoint
		waypoint->setCustomObjectName(UnicodeString("Resource Survey"), false);
		waypoint->setPlanetCRC(player->getZone()->getZoneCRC());
		waypoint->setPosition(maxX, 0, maxY);
		waypoint->setColor(WaypointObject::COLOR_BLUE);
		waypoint->setSpecialTypeID(WaypointObject::SPECIALTYPE_RESOURCE);
		waypoint->setActive(true);
	}

	// Send survey start message
	StringIdChatParameter message("survey", "start_survey");
	message.setTO(resname);
	player->sendSystemMessage(message);

	ManagedReference<ResourceSpawn*> resourceSpawn = resourceMap->get(resname.toLowerCase());

	session->rescheduleSurvey(surveyMessage, waypoint, maxDensity, resourceSpawn);
}

void ResourceSpawner::sendSample(CreatureObject* player, const String& resname,
		const String& sampleAnimation) const {

	// Determine if survey tool is valid, and that resource actually exists
	ManagedReference<SurveySession*> session = player->getActiveSession(SessionFacadeType::SURVEY).castTo<SurveySession*>();
	if(session == nullptr) {
		return;
	}

	ManagedReference<SurveyTool*> surveyTool = session->getActiveSurveyTool().get();

	if (surveyTool == nullptr || !resourceMap->contains(resname.toLowerCase()) || player->getZone() == nullptr)
		return;

	ManagedReference<PlayerObject*> ghost = player->getPlayerObject();

	//Adjust cost based upon player's quickness
	int actionCost = 124 - (int)(player->getHAM(CreatureAttribute::QUICKNESS)/12.5f);
	actionCost /= 2;

	player->inflictDamage(player, CreatureAttribute::ACTION, actionCost, false, true);

	PlayClientEffectLoc* effect = new PlayClientEffectLoc(sampleAnimation,
			player->getZone()->getZoneName(), player->getPositionX(),
			player->getPositionZ(), player->getPositionY());

	player->broadcastMessage(effect, true);

	// Obtain position information
	String zoneName = player->getZone()->getZoneName();
	float posX = player->getPositionX();
	float posY = player->getPositionY();

	// Get resource Density ay players position
	float density = resourceMap->getDensityAt(resname, zoneName, posX, posY);

	session->rescheduleSampleResults(this, density, resname);
	session->rescheduleSample();
}

void ResourceSpawner::sendSampleResults(TransactionLog& trx, CreatureObject* player, const float density, const String& resname) const {

	ManagedReference<SurveySession*> session = player->getActiveSession(SessionFacadeType::SURVEY).castTo<SurveySession*>();

	if(session == nullptr) {
		trx.abort() << "Missing active survey session";
		return;
	}

	ManagedReference<SurveyTool*> surveyTool = session->getActiveSurveyTool().get();
	PlayerObject* ghost = player->getPlayerObject();

	if (surveyTool == nullptr) {
		trx.abort() << "Missing survey tool.";
		return;
	}

	Zone* zne = player->getZone();

	if (zne == nullptr) {
		trx.abort() << "Player zone nullptr";
		return;
	}

	String zoneName = zne->getZoneName();

	// If density is too low, we can't obtain a sample
	// if (density < .10f) {
	// 	StringIdChatParameter message("survey", "efficiency_too_low");
	// 	message.setTO(resname);
	// 	player->sendSystemMessage(message);
	// 	player->setPosture(CreaturePosture::UPRIGHT, true);
	// 	trx.abort() << message.toString();
	// 	return;
	// }

	// Lower skill levels mean you can't sample lower concetrations
	int surveySkill = player->getSkillMod("surveying");

	// if ((density * 100) < (32 - ((surveySkill / 20) * 6)) || density < .10) {
	// 	StringIdChatParameter message("survey", "density_below_threshold");
	// 	message.setTO(resname);
	// 	player->sendSystemMessage(message);
	// 	player->setPosture(CreaturePosture::UPRIGHT, true);
	// 	trx.abort() << message.toString();
	// 	return;
	// }

	Coordinate* richSampleLocation = session->getRichSampleLocation();

	float sampleRate = (surveySkill * density) + System::random(100) + player->getSkillMod("private_spec_samplerate");

	// Was the sample successful or not
	if (!session->tryGamble() && richSampleLocation == nullptr && sampleRate < 40) {
		StringIdChatParameter message("survey", "sample_failed");
		message.setTO(resname);
		player->sendSystemMessage(message);
		trx.abort() << message.toString();
		return;
	}

	int maxUnitsExtracted = (int) (density * (25 + System::random(3)));

	float cityMultiplier = 1.f + player->getSkillMod("private_spec_samplesize") / 100.f;

	int unitsExtracted = maxUnitsExtracted * (float(surveySkill) / 100.0f) * samplingMultiplier * cityMultiplier;
	int xpcap = 40;

	unitsExtracted *= 5;

	// if (session->tryGamble()) {
	// 	if (System::random(2) == 1) {
	// 		player->sendSystemMessage("@survey:gamble_success");
	// 		unitsExtracted *= 5;
	// 	} else {
	// 		player->sendSystemMessage("@survey:gamble_fail");
	// 	}
	// 	session->clearGamble();
	// 	xpcap = 50;
	// }

	if (richSampleLocation != nullptr && richSampleLocation->getPosition() != Vector3(0, 0, 0)) {
		if (player->getDistanceTo(richSampleLocation) < 10) {
			player->sendSystemMessage("@survey:node_recovery");
			unitsExtracted *= 5;

		} else {
			player->sendSystemMessage("@survey:node_not_close");
		}

		session->clearRichSampleLocation();
		xpcap = 50;
	}

	if (unitsExtracted < 2) {
		// Send message to player about trace amounts
		StringIdChatParameter message("survey", "trace_amount");
		message.setTO(resname);
		message.setDI(unitsExtracted);
		player->sendSystemMessage(message);
		trx.abort() << message.toString();
		return;
	}

	// Send message to player about unit extraction
	StringIdChatParameter message("survey", "sample_located");
	message.setTO(resname);
	message.setDI(unitsExtracted);
	player->sendSystemMessage(message);

	// We need the spawn object to track extraction
	ManagedReference<ResourceSpawn*> resourceSpawn = resourceMap->get(resname.toLowerCase());

	Locker clocker(resourceSpawn, player);

	resourceSpawn->extractResource(zoneName, unitsExtracted);

	int xp = (int) (((float) unitsExtracted / (float) maxUnitsExtracted)
			* xpcap);
	ManagedReference<PlayerManager*> playerManager = server->getPlayerManager();

	if (playerManager != nullptr)
		playerManager->awardExperience(player, "resource_harvesting_inorganic", xp, true);

	addResourceToPlayerInventory(trx, player, resourceSpawn, unitsExtracted);

	player->notifyObservers(ObserverEventType::SAMPLE, resourceSpawn, density * 100);
	player->notifyObservers(ObserverEventType::SAMPLETAKEN, resourceSpawn, unitsExtracted);

	if (resourceSpawn->isType("radioactive")) {
		int wound = int((sampleRate / 30) - System::random(7));

		if (wound > 0) {
			player->addWounds(CreatureAttribute::HEALTH, wound, true);
			player->addWounds(CreatureAttribute::ACTION, wound, true);
			player->addWounds(CreatureAttribute::MIND, wound, true);
		}
	}
}

bool ResourceSpawner::addResourceToPlayerInventory(TransactionLog& trx, CreatureObject* player, ResourceSpawn* resourceSpawn, int unitsExtracted) const {
	// Add resource to inventory
	ManagedReference<SceneObject*> inventory = player->getSlottedObject("inventory");
	Locker locker(inventory);
	// Check inventory for resource and add if existing
	for (int i = 0; i < inventory->getContainerObjectsSize(); ++i) {
		ManagedReference<SceneObject*> object =
				inventory->getContainerObject(i);

		if (object->isResourceContainer()) {
			ManagedReference<ResourceContainer*> resource =
					cast<ResourceContainer*>( object.get());

			if (resource->getSpawnName() == resourceSpawn->getName() &&
					resource->getQuantity() < ResourceContainer::MAXSIZE) {
				if  ((resource->getQuantity() + unitsExtracted) <= ResourceContainer::MAXSIZE ){
					trx.addRelatedObject(resource);
					trx.addState("resourceType", resourceSpawn->getType());
					trx.addState("resourceID", resourceSpawn->getObjectID());
					trx.addState("resourceName", resourceSpawn->getName());
					trx.addState("resourceQuantity", unitsExtracted);

					int newStackSize = resource->getQuantity() + unitsExtracted;
					resource->setQuantity(newStackSize);
					return true;
				}else{
					unitsExtracted = unitsExtracted - (ResourceContainer::MAXSIZE - resource->getQuantity());
					resource->setQuantity(ResourceContainer::MAXSIZE);
				}
			}
		}
	}
	if (unitsExtracted > 0 && inventory->isContainerFullRecursive()) {
		StringIdChatParameter err("survey", "no_inv_space");
		player->sendSystemMessage(err);
		if (!player->isIncapacitated() && !player->isDead()){
			player->setPosture(CreaturePosture::UPRIGHT, true);
		}
		trx.abort() << "No inventory space";
		return false;
	}
	// Create New resource container if one isn't found in inventory
	Reference<ResourceContainer*> harvestedResource = resourceSpawn->createResource(unitsExtracted);

	trx.addRelatedObject(harvestedResource);

	if (inventory->transferObject(harvestedResource, -1, false)) {
		trx.addState("resourceType", resourceSpawn->getType());
		trx.addState("resourceID", resourceSpawn->getObjectID());
		trx.addState("resourceName", resourceSpawn->getName());
		trx.addState("resourceQuantity", unitsExtracted);

		inventory->broadcastObject(harvestedResource, true);
	} else {
		Locker resLocker(harvestedResource);

		harvestedResource->destroyObjectFromDatabase(true);
		trx.abort() << "transferObject failed in " << __FUNCTION__ << " near line " << __LINE__;
		return false;
	}

	return true;
}

Reference<ResourceContainer*> ResourceSpawner::harvestResource(CreatureObject* player,
		const String& type, const int quantity) {

	String zoneName = player->getZone()->getZoneName();

	ZoneResourceMap* zoneMap = resourceMap->getZoneResourceList(zoneName);
	if (zoneMap == nullptr) {
		player->sendSystemMessage("Failed to locate any resources");
		return nullptr;
	}

	ManagedReference<ResourceSpawn*> resourceSpawn;

	for (int i = 0; i < zoneMap->size(); ++i) {
		resourceSpawn = zoneMap->get(i);

		if (resourceSpawn != nullptr && resourceSpawn->getType() == type) {
			Locker locker(resourceSpawn);

			resourceSpawn->extractResource(player->getZone()->getZoneName(), quantity);
			return resourceSpawn->createResource(quantity);
		}

	}
	player->sendSystemMessage("Failed to locate any suitable resources");
	return nullptr;
}

bool ResourceSpawner::harvestResource(TransactionLog& trx, CreatureObject* player, ResourceSpawn* resourceSpawn, int quantity) {
	Locker locker(resourceSpawn);

	resourceSpawn->extractResource(player->getZone()->getZoneName(), quantity);

	return addResourceToPlayerInventory(trx, player, resourceSpawn, quantity);
}

ResourceSpawn* ResourceSpawner::getCurrentSpawn(const String& restype, const String& zoneName) const {
	auto zoneMap = resourceMap->getZoneResourceList(zoneName);

	if (zoneMap == nullptr) {
		return nullptr;
	}

	ManagedReference<ResourceSpawn*> resourceSpawn;

	for (int i = 0; i < zoneMap->size(); ++i) {
		resourceSpawn = zoneMap->get(i);

		if (resourceSpawn != nullptr && resourceSpawn->getType().indexOf(restype) != -1)
			return resourceSpawn;
	}

	return nullptr;
}

ResourceSpawn* ResourceSpawner::getFromRandomPool(const String& type) {
	return randomPool->removeSpawn(type);
}

void ResourceSpawner::addNodeToListBox(SuiListBox* sui, const String& nodeName) const {
	ResourceTreeNode* baseNode = resourceTree->getBaseNode();

	ResourceTreeNode* node = baseNode->findNode(nodeName);

	//If we couldn't find a node
	if (node == nullptr) {

		if (resourceMap->containsType(nodeName)) {
			resourceMap->addToSuiListBox(sui, nodeName);
			return;
		}

		node = baseNode;
	}

	node->addToSuiListBox(sui);
}

void ResourceSpawner::addPlanetsToListBox(SuiListBox* sui) const {
	Reference<StringIdManager* > stringIdManager = StringIdManager::instance();
	for(int i=0;i<activeResourceZones.size();i++) {
		String lname = activeResourceZones.get(i);
		String planetName = stringIdManager->getStringId(String("@planet_n:" + lname).hashCode()).toString();
		sui->addMenuItem(planetName,i);
	}
}

String ResourceSpawner::getPlanetByIndex(int idx) const {
	return activeResourceZones.get(idx);
}

String ResourceSpawner::addParentNodeToListBox(SuiListBox* sui, const String& currentNode) const {
	//currentNode can be the resource name itself, the ResourceTreeEntry (finalClass), or a ResourceTreeNode...
	auto baseNode = resourceTree->getBaseNode();

	//If is resource name
	if (resourceMap->contains(currentNode.toLowerCase())) {
		ManagedReference<ResourceSpawn*> spawn = resourceMap->get(currentNode.toLowerCase());
		auto entry = baseNode->find(spawn->getFinalClass());

		if (entry != nullptr) {
			resourceMap->addToSuiListBox(sui, entry->getFinalClass());
			return entry->getFinalClass();
		}
	}

	//If is finalClass
	auto entry = baseNode->find(currentNode);

	if (entry != nullptr) {
		ResourceTreeNode* node = entry->getMyNode();

		if (node != nullptr) {
			node->addToSuiListBox(sui);
			return node->getName();
		}
	}

	auto node = baseNode->findNode(currentNode);

	if (node == nullptr)
		node = baseNode;

	auto parentNode = node->getParentNode();

	if (parentNode != nullptr)
		node = parentNode;

	node->addToSuiListBox(sui);

	return node->getName();
}

void ResourceSpawner::listResourcesForPlanetOnScreen(CreatureObject* creature, const String& planet) const {
	auto zoneMap = resourceMap->getZoneResourceList(planet);

	if (zoneMap == nullptr) {
		creature->sendSystemMessage("Invalid planet specified");
		return;
	}

	creature->sendSystemMessage("Resource spawns for " + planet);
	ManagedReference<ResourceSpawn*> resourceSpawn;

	for (int i = 0; i < zoneMap->size(); ++i) {
		resourceSpawn = zoneMap->get(i);

		if(resourceSpawn == nullptr)
			continue;

		StringBuffer info;
		int hours = (((resourceSpawn->getDespawned() - System::getTime()) / 60) / 60);
		int minutes = (((resourceSpawn->getDespawned() - System::getTime()) / 60) % 60);

		info << resourceSpawn->getFinalClass() << "   |   " << resourceSpawn->getName()
			 << "   |   " << "Despawns in: " << hours << " hours " << minutes << " minutes.";

		creature->sendSystemMessage(info.toString());
	}
}

String ResourceSpawner::healthCheck() {
	StringBuffer health;
	health << minimumPool->healthCheck() << endl;
	health << fixedPool->healthCheck() << endl;
	health << randomPool->healthCheck() << endl;
	health << nativePool->healthCheck() << endl;
	health << manualPool->healthCheck() << endl;

	return health.toString();
}

void ResourceSpawner::despawnAllResources(const String& planet) const {
	auto zoneMap = resourceMap->getZoneResourceList(planet);

	ManagedReference<ResourceSpawn*> resourceSpawn;

	for (int i = 0; i < zoneMap->size(); ++i) {
		resourceSpawn = zoneMap->get(i);

		if(resourceSpawn == nullptr)
			continue;

		resourceSpawn->setDespawned(time(0) - 1);
	}
}
