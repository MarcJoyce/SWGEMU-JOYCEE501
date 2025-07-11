/*
				Copyright <SWGEmu>
		See file COPYING for copying conditions. */

#include "server/zone/objects/player/PlayerObject.h"

#include "server/zone/managers/object/ObjectManager.h"
#include "server/zone/managers/player/PlayerManager.h"
#include "server/zone/managers/skill/SkillManager.h"
#include "server/zone/managers/planet/PlanetManager.h"
#include "server/zone/managers/mission/MissionManager.h"
#include "server/zone/managers/combat/CombatManager.h"
#include "server/zone/managers/structure/StructureManager.h"
#include "server/zone/managers/vendor/VendorManager.h"
#include "server/zone/managers/frs/FrsManager.h"
#include "server/chat/ChatManager.h"
#include "server/chat/room/ChatRoom.h"
#include "server/chat/PersistentMessage.h"
#include "server/zone/Zone.h"
#include "server/zone/ZoneServer.h"
#include "server/zone/ZoneClientSession.h"
#include "server/zone/packets/player/PlayerObjectMessage3.h"
#include "server/zone/packets/player/PlayerObjectMessage6.h"
#include "server/zone/packets/player/PlayerObjectMessage8.h"
#include "server/zone/packets/player/PlayerObjectMessage9.h"
#include "server/zone/packets/player/PlayerObjectDeltaMessage3.h"
#include "server/zone/packets/player/PlayerObjectDeltaMessage8.h"
#include "server/zone/packets/player/PlayerObjectDeltaMessage9.h"
#include "server/zone/packets/creature/CreatureObjectDeltaMessage6.h"
#include "server/zone/packets/chat/ChatOnGetFriendsList.h"
#include "server/zone/packets/chat/ChatOnGetIgnoreList.h"
#include "server/zone/packets/chat/ChatOnAddFriend.h"
#include "server/zone/packets/chat/ChatOnChangeFriendStatus.h"
#include "server/zone/packets/chat/ChatOnChangeIgnoreStatus.h"
#include "server/zone/packets/chat/ChatFriendsListUpdate.h"
#include "server/zone/packets/scene/ServerTimeMessage.h"
#include "server/zone/packets/zone/CmdSceneReady.h"
#include "server/zone/objects/waypoint/WaypointObject.h"
#include "server/zone/objects/creature/CreatureObject.h"
#include "server/chat/StringIdChatParameter.h"
#include "server/zone/objects/area/ActiveArea.h"
#include "server/zone/objects/player/events/PlayerDisconnectEvent.h"
#include "server/zone/objects/player/events/PlayerRecoveryEvent.h"
#include "server/zone/managers/group/GroupManager.h"
#include "server/zone/objects/creature/variables/Skill.h"
#include "server/zone/objects/player/sui/inputbox/SuiInputBox.h"
#include "server/zone/objects/building/BuildingObject.h"
#include "server/zone/objects/group/GroupObject.h"
#include "server/zone/objects/guild/GuildObject.h"
#include "server/zone/objects/intangible/ControlDevice.h"
#include "server/zone/objects/intangible/ShipControlDevice.h"
#include "server/zone/objects/structure/events/StructureSetOwnerTask.h"
#include "server/zone/packets/player/BadgesResponseMessage.h"
#include "server/zone/managers/weather/WeatherManager.h"
#include "server/zone/objects/player/variables/Ability.h"
#include "server/zone/objects/mission/MissionObjective.h"
#include "server/zone/objects/mission/MissionObject.h"
#include "server/zone/objects/player/FactionStatus.h"
#include "server/zone/managers/faction/FactionManager.h"
#include "templates/intangible/SharedPlayerObjectTemplate.h"
#include "server/zone/objects/player/sessions/TradeSession.h"
#include "server/zone/objects/player/events/StoreSpawnedChildrenTask.h"
#include "server/zone/objects/player/events/RemoveSpouseTask.h"
#include "server/zone/objects/player/events/PvpTefRemovalTask.h"
#include "server/zone/objects/player/events/SpawnHelperDroidTask.h"
#include "server/zone/managers/visibility/VisibilityManager.h"
#include "server/zone/managers/jedi/JediManager.h"
#include "server/zone/objects/player/events/ForceRegenerationEvent.h"
#include "server/login/account/AccountManager.h"
#include "templates/creature/SharedCreatureObjectTemplate.h"
#include "server/zone/objects/player/sessions/survey/SurveySession.h"

#include "server/zone/objects/tangible/deed/eventperk/EventPerkDeed.h"
#include "server/zone/managers/player/QuestInfo.h"
#include "server/zone/objects/player/events/ForceMeditateTask.h"
#include "server/zone/objects/player/sui/callbacks/FieldFactionChangeSuiCallback.h"
#include "server/zone/packets/ui/DestroyClientPathMessage.h"
#include "server/zone/objects/player/sui/messagebox/SuiMessageBox.h"
#include "server/chat/PendingMessageList.h"
#include "server/zone/managers/director/DirectorManager.h"
#include "server/db/ServerDatabase.h"
#include "server/ServerCore.h"
#include "server/zone/managers/gcw/GCWManager.h"
#include "server/zone/objects/ship/ShipObject.h"

#ifdef WITH_SESSION_API
#include "server/login/SessionAPIClient.h"
#endif // WITH_SESSION_API

void PlayerObjectImplementation::initializeTransientMembers() {
	playerLogLevel = ConfigManager::instance()->getPlayerLogLevel();

	IntangibleObjectImplementation::initializeTransientMembers();

	countMaxCov = 4500; // Only report very large lists
	foodFillingMax = 100;
	drinkFillingMax = 100;

	duelList.setNoDuplicateInsertPlan();
	chatRooms.setNoDuplicateInsertPlan();
	ownedChatRooms.setNoDuplicateInsertPlan();
	setLoggingName("PlayerObject");

	initializeAccount();

	sessionStatsMiliSecs = 0;
	sessionStatsLastCredits = -1;
	sessionStatsLastSkillPoints = skillPoints;
	sessionStatsActivityXP = 0;
	sessionStatsActivityMovement = 0;
	sessionStatsTotalMovement = 0;
	sessionStatsTotalCredits = 0;
	sessionStatsIPAddress = "";
	miliSecsSession = 0;

	// Build the transient ability list
	for (int i = 0; i < abilityList.size(); i++) {
		activeAbilities.add(abilityList.get(i));
	}
}

PlayerObject* PlayerObjectImplementation::asPlayerObject() {
	return _this.getReferenceUnsafeStaticCast();
}

PlayerObject* PlayerObject::asPlayerObject() {
	return this;
}

void PlayerObjectImplementation::checkPendingMessages() {
	ObjectManager *objectManager = ObjectManager::instance();
	ManagedReference<PendingMessageList*> messageList = getZoneServer()->getChatManager()->getPendingMessages(parent.getSavedObjectID());

	if (messageList != nullptr) {
		Locker locker(messageList);
		Vector<uint64>& pendingMessages = *messageList->getPendingMessages();

		for (uint64 messageID : pendingMessages) {
			ManagedReference<PersistentMessage*> mail = Core::getObjectBroker()->lookUp(messageID).castTo<PersistentMessage*>();

			if (mail != nullptr && isIgnoring(mail->getSenderName())) {
				objectManager->destroyObjectFromDatabase(mail->getObjectID());
				continue;
			}

			persistentMessages.put(messageID);
		}

		messageList->clearPendingMessages();
	}
}

void PlayerObjectImplementation::initializeAccount() {
	if (accountID == 0) {
		CreatureObject* creature = dynamic_cast<CreatureObject*>(parent.get().get());

		if (creature == nullptr)
			return;

		auto owner = creature->getClient();

		if (owner != nullptr)
			accountID = owner->getAccountID();
	}

	if (account == nullptr)
		account = AccountManager::getAccount(accountID);

	if (account != nullptr && galaxyAccountInfo == nullptr) {
		Locker locker(account);

		galaxyAccountInfo = account->getGalaxyAccountInfo(getZoneServer()->getGalaxyName());

		if (chosenVeteranRewards.size() > 0) {
			//galaxyAccountInfo->updateVetRewardsFromPlayer(chosenVeteranRewards);
			chosenVeteranRewards.removeAll();
		}
	} else {
		error("nullptr Account in initialize transient objects");
	}
}

void PlayerObjectImplementation::loadTemplateData(SharedObjectTemplate* templateData) {
	IntangibleObjectImplementation::loadTemplateData(templateData);

	SharedPlayerObjectTemplate* sply = dynamic_cast<SharedPlayerObjectTemplate*>(templateData);

	adminLevel = 0;

	forcePower = getForcePower();
	forcePowerMax = getForcePowerMax();

	trainerZoneName = getTrainerZoneName();

	foodFilling = 0;
	foodFillingMax = 100;

	drinkFilling = 0;
	drinkFillingMax = 100;

	reactionFines = 0;

	jediState = getJediState();

	languageID = 0;

	experienceList.setNullValue(0);

	permissionGroups = *(sply->getPlayerDefaultGroupPermissions());

	auto zoneServer = ServerCore::getZoneServer();

	if (zoneServer != nullptr) {
		setLoggerCallback([playerObject = asPlayerObject(), manager = WeakReference<PlayerManager*>(zoneServer->getPlayerManager())]
				(Logger::LogLevel level, const char* msg) -> int {
			auto playerManager = manager.get();

			if (playerManager != nullptr) {
				playerManager->writePlayerLog(playerObject, msg, level);
			}

			return Logger::SUCCESS;
		});
	}
}

void PlayerObjectImplementation::notifyLoadFromDatabase() {
	IntangibleObjectImplementation::notifyLoadFromDatabase();

	serverLastMovementStamp.updateToCurrentTime();

	auto parent = getParent().get();

	if (parent != nullptr) {
		Reference<CreatureObject*> player = parent->asCreatureObject();

		if (player != nullptr) {
			parent->executeOrderedTask([player] () {
					Locker lock(player);

					auto ghost = player->getPlayerObject();

					if (ghost != nullptr) {
						auto parent = player->getParent();
						ghost->updateLastValidatedPosition();
					}
			}, "PlayerObjNotifyLoadDb");
		}
	}

	clientLastMovementStamp = 0;
}

void PlayerObjectImplementation::unloadSpawnedChildren(bool petsOnly) {
	ManagedReference<CreatureObject*> player = dynamic_cast<CreatureObject*>(parent.get().get());

	if (player == nullptr)
		return;

	ManagedReference<SceneObject*> datapad = player->getSlottedObject("datapad");

	if (datapad == nullptr)
		return;

	Vector<ManagedReference<ControlDevice*> > devicesToStore;

	for (int i = 0; i < datapad->getContainerObjectsSize(); ++i) {
		ManagedReference<SceneObject*> object = datapad->getContainerObject(i);

		if (object == nullptr || !object->isControlDevice())
			continue;

		ControlDevice* device = cast<ControlDevice*>(object.get());

		if (device == nullptr)
			continue;

		// Do not force store ships when player is not in the space zone
		if (device->isShipControlDevice()) {
			if (petsOnly)
				continue;

			auto zone = player->getZone();

			if (zone != nullptr && !zone->isSpaceZone())
				continue;
		}

		devicesToStore.add(device);
	}

	StoreSpawnedChildrenTask* task = new StoreSpawnedChildrenTask(player, std::move(devicesToStore));

	if (task != nullptr)
		task->execute();
}

void PlayerObjectImplementation::setLastLogoutWorldPosition() {
	auto player = dynamic_cast<CreatureObject*>(parent.get().get());

	if (player == nullptr)
		return;

	lastLogoutWorldPosition = player->getWorldPosition();
}

Vector3 PlayerObjectImplementation::getLastLogoutWorldPosition() const {
	return lastLogoutWorldPosition;
}

void PlayerObjectImplementation::unload() {
	debug("unloading player");

	ManagedReference<CreatureObject*> creature = dynamic_cast<CreatureObject*>(parent.get().get());

	MissionManager* missionManager = creature->getZoneServer()->getMissionManager();
	missionManager->deactivateMissions(creature);

	if (creature->isRidingMount()) {
		creature->executeObjectControllerAction(STRING_HASHCODE("dismount"));
	}

	unloadSpawnedChildren();

	SortedVector<ManagedReference<ActiveArea*>>* activeAreas = creature->getActiveAreas();

	if (activeAreas != nullptr) {
		for (int i = 1; i < activeAreas->size(); i++) {
			ActiveArea* area = activeAreas->get(i);

			if (area == nullptr)
				continue;

			creature->dropActiveArea(area);
		}

		if (creature->isInNoCombatArea()) {
			Locker lock(creature);
			creature->setInNoCombatArea(false);
		}
	}

	if (!creature->isOnboardPobShip()) {
		PlayerManager* playerManager = creature->getZoneServer()->getPlayerManager();
		playerManager->ejectPlayerFromBuilding(creature);
	}

	ManagedReference<SceneObject*> creoParent = creature->getParent().get();

	Zone* zone = creature->getZone();

	if (zone != nullptr) {
		String zoneName = zone->getZoneName();

		// Player is in space and being unloaded
		if (zone->isSpaceZone()) {
			zoneName = launchPoint.getGoundZoneName();

			Vector3 launchLoc = launchPoint.getLocation();

			creature->setPosition(launchLoc.getX(), launchLoc.getZ(), launchLoc.getY());
			creature->incrementMovementCounter();

			updateLastValidatedPosition();

			savedParentID = 0;
		} else {
			if (creoParent != nullptr) {
				savedParentID = creoParent->getObjectID();
			} else {
				savedParentID = 0;
			}
		}

		// Set the saved zone
		savedTerrainName = zoneName;

		// Remove player from world
		creature->destroyObjectFromWorld(true);
	}

	creature->clearCombatState(true);

	creature->setAlternateAppearance("", false);

	creature->stopEntertaining();

	ManagedReference<TradeSession*> tradeContainer = creature->getActiveSession(SessionFacadeType::TRADE).castTo<TradeSession*>();

	if (tradeContainer != nullptr)
		creature->dropActiveSession(SessionFacadeType::TRADE);

	//Remove player from Chat Manager and all rooms.
	ManagedReference<ChatManager*> chatManager = getZoneServer()->getChatManager();

	if (chatManager != nullptr) {
		chatManager->removePlayer(creature->getFirstName().toLowerCase());

		for (int i = 0; i < chatRooms.size(); i++) {
			ManagedReference<ChatRoom*> room = chatManager->getChatRoom(chatRooms.get(i));
			if (room != nullptr) {
				Locker clocker(room, creature);
				room->removePlayer(creature, true);
			}
		}
	}

	CombatManager::instance()->freeDuelList(creature);

	GroupObject* group = creature->getGroup();

	if (group != nullptr)
		GroupManager::instance()->leaveGroup(group, creature);

	/*StringBuffer msg;
	msg << "remaining play ref count: " << asPlayerObject()->getReferenceCount();
	msg << " - remaining creo ref count: " << creature->getReferenceCount();
	info(msg.toString(), true);*/
}

int PlayerObjectImplementation::calculateBhReward() {
	int minReward = 25000; // Minimum reward for a player bounty

	if (getJediState() >= 4) // Minimum if player is knight
		minReward = 50000;

	int skillPoints = getSpentJediSkillPoints();
	int reward = skillPoints * 1000;

	int frsRank = getFrsData()->getRank();

	if (frsRank > 0)
		reward += frsRank * 100000; // +100k per frs rank

	if (reward < minReward)
		reward = minReward;

	return reward * 1000;
}

void PlayerObjectImplementation::sendBaselinesTo(SceneObject* player) {
	debug() << "sendBaselinesTo(" << player->getObjectID() << ")";

	BaseMessage* play3 = new PlayerObjectMessage3(asPlayerObject());
	player->sendMessage(play3);

	BaseMessage* play6 = new PlayerObjectMessage6(asPlayerObject());
	player->sendMessage(play6);

	if (player == parent.get().get()) {
		BaseMessage* play8 = new PlayerObjectMessage8(this);
		player->sendMessage(play8);

		BaseMessage* play9 = new PlayerObjectMessage9(this);
		player->sendMessage(play9);
	}
}

void PlayerObjectImplementation::notifySceneReady() {
	// info(true) << cast<CreatureObject*>(parent.get().get())->getDisplayedName() << " --- notifySceneReady called";

	teleporting = false;
	onLoadScreen = false;
	forcedTransform = false;

	BaseMessage* msg = new CmdSceneReady();
	sendMessage(msg);

	ManagedReference<CreatureObject*> creature = cast<CreatureObject*>(parent.get().get());

	if (creature == nullptr) {
		return;
	}

	creature->broadcastPvpStatusBitmask();

	creature->sendBuffsTo(creature);

	sendFriendLists();

	if (creature->isDead() && !isCloning()) {
		//If the player is dead, see if they already have a clone box. If so, resend it.
		ManagedReference<SuiBox*> cloneBox = getSuiBoxFromWindowType(SuiWindowType::CLONE_REQUEST);

		if (cloneBox != nullptr) {
			cloneBox->clearOptions();
			sendMessage(cloneBox->generateMessage());
		} else {
			//Otherwise, send them a new one.
			server->getPlayerManager()->sendActivateCloneRequest(creature);
		}
	}

	ZoneServer* zoneServer = getZoneServer();

	if (zoneServer == nullptr || zoneServer->isServerLoading()) {
		return;
	}

	//Join GuildChat
	ManagedReference<ChatManager*> chatManager = zoneServer->getChatManager();
	ManagedReference<GuildObject*> guild = creature->getGuildObject().get();

	if (guild != nullptr) {
		ManagedReference<ChatRoom*> guildChat = guild->getChatRoom();

		if (guildChat != nullptr) {
			guildChat->sendTo(creature);
			chatManager->handleChatEnterRoomById(creature, guildChat->getRoomID(), -1, true);
		}
	}

	//Leave all planet chat rooms (need evidence of planet rooms for space)
	for (int i = 0; i < zoneServer->getZoneCount(); ++i) {
		ManagedReference<Zone*> zone = zoneServer->getZone(i);

		if (zone == nullptr) {
			continue;
		}

		ManagedReference<ChatRoom*> planetRoom = zone->getPlanetChatRoom();

		if (planetRoom == nullptr) {
			continue;
		}

		Locker clocker(planetRoom, creature);
		planetRoom->removePlayer(creature);
		planetRoom->sendDestroyTo(creature);
	}

	//Join current zone's Planet chat room
	ManagedReference<Zone*> zone = creature->getZone();

	if (zone != nullptr) {
		ManagedReference<ChatRoom*> planetChat = zone->getPlanetChatRoom();

		if (planetChat != nullptr) {
			planetChat->sendTo(creature);
			chatManager->handleChatEnterRoomById(creature, planetChat->getRoomID(), -1, true);
		}
	}

	//Re-join chat rooms player was a member of before disconnecting.
	for (int i = chatRooms.size() - 1; i >= 0; i--) {
		ChatRoom* room = chatManager->getChatRoom(chatRooms.get(i));
		if (room != nullptr) {
			int roomType = room->getChatRoomType();
			if (roomType == ChatRoom::PLANET || roomType == ChatRoom::GUILD)
				continue; //Planet and Guild are handled above.

			room->sendTo(creature);
			chatManager->handleChatEnterRoomById(creature, room->getRoomID(), -1);

		} else {
			chatRooms.remove(i);
		}
	}

	// Show Terms of Service window
	checkAndShowTOS();

	if (zone != nullptr && !zone->isSpaceZone()) {
		auto planetManager = zone->getPlanetManager();

		if (planetManager != nullptr) {
			ManagedReference<WeatherManager*> weatherManager = zone->getPlanetManager()->getWeatherManager();

			if (weatherManager != nullptr) {
				creature->setCurrentWind((byte)System::random(200));
				creature->setCurrentWeather(0xFF);
				weatherManager->sendWeatherTo(creature);
			}
		}

		// Create or spawn the helper droid
		createHelperDroid();
	}

	// info(true) << creature->getDisplayedName() << " --- notifySceneReady COMPLETE with Zone Name: " << zone->getZoneName() << " World Pos: " << creature->getWorldPosition().toString();
}

void PlayerObjectImplementation::sendFriendLists() {
	debug() << "sending friendslist message  size " << friendList.size();

	ChatManager* chatManager = server->getChatManager();

	friendList.resetUpdateCounter();
	ignoreList.resetUpdateCounter();

	auto parent = getParent().get();

	ChatOnGetFriendsList* flist = new ChatOnGetFriendsList(asPlayerObject());
	parent->sendMessage(flist);

	ChatOnGetIgnoreList* ilist = new ChatOnGetIgnoreList(asPlayerObject());
	parent->sendMessage(ilist);

	DeltaMessage* delta = new PlayerObjectDeltaMessage9(asPlayerObject());
	friendList.insertToDeltaMessage(delta);
	ignoreList.insertToDeltaMessage(delta);
	delta->close();

	parent->sendMessage(delta);
}

void PlayerObjectImplementation::sendMessage(BasePacket* msg) {
	ManagedReference<SceneObject*> strongParent = getParent().get();
	if (strongParent == nullptr) {
#ifdef LOCKFREE_BCLIENT_BUFFERS
		if (!msg->getReferenceCount())
#endif
		delete msg;
	} else {
		strongParent->sendMessage(msg);
	}
}

bool PlayerObjectImplementation::setPlayerBit(uint32 bit, bool notifyClient) {
	if (!playerBitmask.hasPlayerBit(bit)) {
		playerBitmask.setOneBit(bit);

		if (notifyClient) {
			PlayerObjectDeltaMessage3* delta = new PlayerObjectDeltaMessage3(asPlayerObject());
			delta->updatePlayerBitmasks();
			delta->close();

			broadcastMessage(delta, true);
		}
		return true;
	}
	return false;
}

bool PlayerObjectImplementation::clearPlayerBit(uint32 bit, bool notifyClient) {
	if (playerBitmask.hasPlayerBit(bit)) {
		playerBitmask.clearOneBit(bit);

		if (notifyClient) {
			PlayerObjectDeltaMessage3* delta = new PlayerObjectDeltaMessage3(asPlayerObject());
			delta->updatePlayerBitmasks();
			delta->close();

			broadcastMessage(delta, true);
		}
		return true;
	}
	return false;
}

bool PlayerObjectImplementation::isAnonymous() const {
	return playerBitmask.hasPlayerBit(PlayerBitmasks::ANONYMOUS);
}

bool PlayerObjectImplementation::isAFK() const {
	return playerBitmask.hasPlayerBit(PlayerBitmasks::AFK);
}

bool PlayerObjectImplementation::isRoleplayer() const {
	return playerBitmask.hasPlayerBit(PlayerBitmasks::ROLEPLAYER);
}

bool PlayerObjectImplementation::isNewbieHelper() const {
	return playerBitmask.hasPlayerBit(PlayerBitmasks::NEWBIEHELPER);
}

bool PlayerObjectImplementation::isLFG() const {
	return playerBitmask.hasPlayerBit(PlayerBitmasks::LFG);
}

void PlayerObjectImplementation::sendBadgesResponseTo(CreatureObject* player) {
	BaseMessage* msg = new BadgesResponseMessage(getParent().get(), &badges);
	player->sendMessage(msg);
}

void PlayerObjectImplementation::awardBadge(uint32 badge) {
	PlayerManager* playerManager = getZoneServer()->getPlayerManager();
	playerManager->awardBadge(asPlayerObject(), badge);
}

int PlayerObjectImplementation::addExperience(TransactionLog& trx, const String& xpType, int xp, bool notifyClient) {
	if (xp == 0) {
		trx.discard();
		return 0;
	}

	int valueToAdd = xp;

	Locker locker(asPlayerObject());

	if (xp > 0) {
		sessionStatsActivityXP += xp; // Count all xp as we're looking for activity not caps etc.
		trx.addState("activityXP", xp);
	}

	if (experienceList.contains(xpType)) {
		xp += experienceList.get(xpType);

		if (xp <= 0 && xpType != "jedi_general") {
			removeExperience(trx, xpType, notifyClient);
			return 0;
		// -10 million experience cap for Jedi experience loss
		} else if(xp < -10000000 && xpType == "jedi_general") {
			xp = -10000000;
		}
	}

	int xpCap = -1;

	if (xpTypeCapList.contains(xpType)) {
		if (xpType == "jedi_general" || xpType == "force_rank_xp") {
			xpCap = xpTypeCapList.get(xpType);
		} else {
			xpCap = xpTypeCapList.get(xpType) * 20;
		}
	}
	
	if (xpType.beginsWith("prestige_")) {
		xpCap = INT_MAX;
	} else if (xpCap < 0) {
		xpCap = 2000 * 20;
	}

	if (xp > xpCap) {
		valueToAdd = xpCap - (xp - valueToAdd);
		xp = xpCap;
	}

	if (notifyClient) {
		PlayerObjectDeltaMessage8* dplay8 = new PlayerObjectDeltaMessage8(this);
		dplay8->startUpdate(0);
		experienceList.set(xpType, xp, dplay8, 1);
		dplay8->close();

		sendMessage(dplay8);
	} else {
		experienceList.set(xpType, xp);
	}

	trx.setExperience(xpType, valueToAdd, experienceList.get(xpType));

	return valueToAdd;
}

void PlayerObjectImplementation::removeExperience(TransactionLog& trx, const String& xpType, bool notifyClient) {
	if (!experienceList.contains(xpType))
		return;

	if (notifyClient) {
		PlayerObjectDeltaMessage8* dplay8 = new PlayerObjectDeltaMessage8(this);
		dplay8->startUpdate(0);
		experienceList.drop(xpType, dplay8, 1);
		dplay8->close();

		sendMessage(dplay8);
	} else {
		experienceList.drop(xpType);
	}

	trx.setExperience(xpType, experienceList.get(xpType) * -1, 0);
}

bool PlayerObjectImplementation::hasCappedExperience(const String& xpType) const {
	if (experienceList.contains(xpType) && xpTypeCapList.contains(xpType)) {
		return experienceList.get(xpType) == xpTypeCapList.get(xpType);
	}

	return false;
}

void PlayerObjectImplementation::setWaypoint(WaypointObject* waypoint, bool notifyClient) {
	uint64 waypointID = waypoint->getObjectID();

	if (notifyClient) {
		PlayerObjectDeltaMessage8* msg = new PlayerObjectDeltaMessage8(this);
		msg->startUpdate(1);
		waypointList.set(waypointID, waypoint, msg, 1);
		msg->close();

		sendMessage(msg);
	} else {
		waypointList.set(waypointID, waypoint);
	}
}

void PlayerObjectImplementation::addWaypoint(WaypointObject* waypoint, bool checkName, bool notifyClient) {
	uint64 waypointID = waypoint->getObjectID();

	if (waypointList.contains(waypointID)) {
		updateWaypoint(waypointID);
		return;
	}

	int specialTypeID = waypoint->getSpecialTypeID();
	bool doRemove = false;
	bool destroy = false;

	if (checkName) {
		String name = waypoint->getCustomObjectName().toString();
		waypointID = waypointList.find(name);

		if(waypointID != 0) {
			doRemove = true;
			destroy = true;
		}
	}

	if (!doRemove && specialTypeID != 0) {
		waypointID = waypointList.getWaypointBySpecialType(specialTypeID);

		if(waypointID != 0) {
			doRemove = true;
			destroy = true;
		}
	}

	if(doRemove)
		removeWaypoint(waypointID, notifyClient, destroy);

	setWaypoint(waypoint, notifyClient);
}

void PlayerObjectImplementation::removeWaypoint(uint64 waypointID, bool notifyClient, bool destroy) {
	ManagedReference<WaypointObject*> waypoint = waypointList.get(waypointID);

	if (waypoint == nullptr)
		return;

	if (notifyClient) {
		PlayerObjectDeltaMessage8* msg = new PlayerObjectDeltaMessage8(this);
		msg->startUpdate(1);
		waypointList.drop(waypointID, msg, 1);
		msg->close();

		sendMessage(msg);
	} else {
		waypointList.drop(waypointID);
	}

	ManagedReference<SceneObject*> sceno = currentClientPathWaypoint.get();
	if (sceno != nullptr && sceno->getObjectID() == waypointID) {
		DestroyClientPathMessage *msg = new DestroyClientPathMessage();
		sendMessage(msg);
		currentClientPathWaypoint = nullptr;
	}

	if (destroy && waypoint->isPersistent()) {
		waypoint->destroyObjectFromDatabase(true);
	}
}

void PlayerObjectImplementation::updateWaypoint(uint64 waypointID) {
	ManagedReference<WaypointObject*> waypoint = waypointList.get(waypointID);

	if (waypoint == nullptr)
		return;

	PlayerObjectDeltaMessage8* msg = new PlayerObjectDeltaMessage8(this);
	msg->startUpdate(1);
	waypointList.update(waypointID, msg, 1);
	msg->close();

	sendMessage(msg);

}

void PlayerObjectImplementation::removeWaypointBySpecialType(int specialTypeID, bool notifyClient) {
	uint64 waypointID = waypointList.getWaypointBySpecialType(specialTypeID);

	while (waypointID != 0) {
		removeWaypoint(waypointID, notifyClient);

		waypointID = waypointList.getWaypointBySpecialType(specialTypeID);
	}

}

WaypointObject* PlayerObjectImplementation::getWaypointBySpecialType(int specialTypeID) const {
	uint64 waypointID = waypointList.getWaypointBySpecialType(specialTypeID);
	if (waypointID != 0) {
		return waypointList.get(waypointID);
	}
	return nullptr;
}

WaypointObject* PlayerObjectImplementation::getSurveyWaypoint() const {
	return getWaypointBySpecialType(WaypointObject::SPECIALTYPE_RESOURCE);
}

WaypointObject* PlayerObjectImplementation::addWaypoint(const String& planet, float positionX, float positionY, bool notifyClient) {
	ManagedReference<WaypointObject*> obj = getZoneServer()->createObject(0xc456e788, 1).castTo<WaypointObject*>();
	Locker locker(obj);
	obj->setPlanetCRC(planet.hashCode());
	obj->setPosition(positionX, 0, positionY);
	obj->setActive(true);

	addWaypoint(obj, false, notifyClient);

	return obj;
}

void PlayerObjectImplementation::addAbility(Ability* ability, bool notifyClient) {
	if (ability == nullptr) {
		return;
	}

	const auto abilityName = ability->getAbilityName();

	if (!abilityList.contains(abilityName)) {
		abilityList.add(ability);
	}

	if (activeAbilities.contains(abilityName)) {
		return;
	}

	if (notifyClient) {
		PlayerObjectDeltaMessage9* delta9 = new PlayerObjectDeltaMessage9(asPlayerObject());

		if (delta9 == nullptr) {
			return;
		}

		delta9->startUpdate(0x0);

		activeAbilities.add(ability, delta9, 1);

		delta9->close();

		sendMessage(delta9);
	} else {
		activeAbilities.add(ability);
	}
}

void PlayerObjectImplementation::addAbilities(Vector<Ability*>& abilities, bool notifyClient) {
	if (abilities.size() == 0) {
		return;
	}

	if (notifyClient) {
		auto initialAbility = abilities.get(0);

		if (initialAbility == nullptr) {
			return;
		}

		const auto initAbilityName = initialAbility->getAbilityName();

		PlayerObjectDeltaMessage9* delta9 = new PlayerObjectDeltaMessage9(asPlayerObject());

		if (delta9 == nullptr) {
			return;
		}

		delta9->startUpdate(0x0);

		if (!abilityList.contains(initAbilityName)) {
			abilityList.add(initialAbility);
		}

		activeAbilities.add(initialAbility, delta9, abilities.size());

		for (int i = 1; i < abilities.size(); ++i) {
			auto ability = abilities.get(i);

			if (ability == nullptr) {
				continue;
			}

			const auto abilityName = ability->getAbilityName();

			if (!abilityList.contains(abilityName)) {
				abilityList.add(ability);
			}

			activeAbilities.add(ability, delta9, 0);
		}

		delta9->close();

		sendMessage(delta9);
	} else {
		for (int i = 0; i < abilities.size(); ++i) {
			auto ability = abilities.get(i);

			if (ability == nullptr) {
				continue;
			}

			const auto abilityName = ability->getAbilityName();

			if (!abilityList.contains(abilityName)) {
				abilityList.add(ability);
			}

			if (!activeAbilities.contains(abilityName)) {
				activeAbilities.add(ability);
			}
		}
	}
}

void PlayerObjectImplementation::removeAbility(Ability* ability, bool notifyClient) {
	int abilityIndex = abilityList.find(ability);
	int activeIndex = activeAbilities.find(ability);

	if (abilityIndex != -1) {
		abilityList.remove(abilityIndex);
	}

	if (activeIndex == -1) {
		return;
	}

	if (notifyClient) {
		PlayerObjectDeltaMessage9* delta9 = new PlayerObjectDeltaMessage9(asPlayerObject());

		if (delta9 == nullptr) {
			return;
		}

		delta9->startUpdate(0x0);

		activeAbilities.remove(activeIndex, delta9, 1);

		delta9->close();

		sendMessage(delta9);

	} else {
		activeAbilities.remove(activeIndex);
	}
}

void PlayerObjectImplementation::removeAbilities(Vector<Ability*>& abilities, bool notifyClient) {
	if (abilities.size() == 0) {
		return;
	}

	if (notifyClient) {
		auto initialAbility = abilities.get(0);

		if (initialAbility == nullptr) {
			return;
		}

		PlayerObjectDeltaMessage9* delta9 = new PlayerObjectDeltaMessage9(asPlayerObject());

		if (delta9 == nullptr) {
			return;
		}

		delta9->startUpdate(0x0);

		abilityList.remove(abilityList.find(initialAbility));
		activeAbilities.remove(activeAbilities.find(initialAbility), delta9, abilities.size());

		for (int i = 1; i < abilities.size(); ++i) {
			auto ability = abilities.get(i);

			if (ability == nullptr) {
				continue;
			}

			abilityList.remove(abilityList.find(ability));
			activeAbilities.remove(activeAbilities.find(ability), delta9, 0);
		}

		delta9->close();

		sendMessage(delta9);
	} else {
		for (int i = 0; i < abilities.size(); ++i) {
			auto ability = abilities.get(i);

			if (ability == nullptr) {
				continue;
			}

			abilityList.remove(abilityList.find(ability));
			activeAbilities.remove(activeAbilities.find(ability));
		}
	}
}

void PlayerObjectImplementation::addDroidCommands(Vector<Ability*>& abilities, bool notifyClient) {
	if (abilities.size() == 0) {
		return;
	}

	if (notifyClient) {
		auto initialAbility = abilities.get(0);

		if (initialAbility == nullptr) {
			return;
		}

		PlayerObjectDeltaMessage9* delta9 = new PlayerObjectDeltaMessage9(asPlayerObject());

		if (delta9 == nullptr) {
			return;
		}

		delta9->startUpdate(0x0);

		droidCommandList.add(initialAbility);
		activeAbilities.add(initialAbility, delta9, abilities.size());

		for (int i = 1; i < abilities.size(); ++i) {
			auto ability = abilities.get(i);

			if (ability == nullptr) {
				continue;
			}

			droidCommandList.add(ability);
			activeAbilities.add(ability, delta9, 0);
		}

		delta9->close();

		sendMessage(delta9);
	} else {
		for (int i = 0; i < abilities.size(); ++i) {
			auto ability = abilities.get(i);

			if (ability == nullptr) {
				continue;
			}

			droidCommandList.add(ability);
			activeAbilities.add(ability);
		}
	}
}

void PlayerObjectImplementation::removeDroidCommands() {
	if (droidCommandList.size() == 0) {
		return;
	}

	auto initialAbility = droidCommandList.get(0);

	if (initialAbility == nullptr) {
		return;
	}

	PlayerObjectDeltaMessage9* delta9 = new PlayerObjectDeltaMessage9(asPlayerObject());

	if (delta9 == nullptr) {
		return;
	}

	delta9->startUpdate(0x0);

	activeAbilities.remove(activeAbilities.find(initialAbility), delta9, droidCommandList.size());

	for (int i = 1; i < droidCommandList.size(); i++) {
		auto ability = droidCommandList.get(i);

		if (ability == nullptr) {
			continue;
		}

		activeAbilities.remove(activeAbilities.find(ability), delta9, 0);
	}

	delta9->close();

	sendMessage(delta9);

	// Clear the droid commands
	droidCommandList.removeAll();
}

bool PlayerObjectImplementation::addSchematics(Vector<ManagedReference<DraftSchematic* > >& schematics, bool notifyClient) {
	if (schematics.size() == 0)
		return false;

	Vector<ManagedReference<DraftSchematic* > > schematicsToSend;
	for (int i = 0; i < schematics.size(); ++i) {

		/// If schematic is not already in the schematic list, we want to send it
		/// if not, we don't want to send it to the datapad
		if(!schematicList.contains(schematics.get(i)))
			schematicsToSend.add(schematics.get(i));
	}

	if (schematicsToSend.size() == 0)
		return false;

	if (notifyClient) {
		PlayerObjectDeltaMessage9* msg = new PlayerObjectDeltaMessage9(asPlayerObject());
		msg->startUpdate(4);

		schematicList.add(schematicsToSend.get(0), msg, schematicsToSend.size());

		for (int i = 1; i < schematicsToSend.size(); ++i)
			schematicList.add(schematicsToSend.get(i),  msg, 0);

		msg->close();

		sendMessage(msg);
	} else {

		for (int i = 0; i < schematicsToSend.size(); ++i)
			schematicList.add(schematicsToSend.get(i));

	}

	return true;
}

bool PlayerObjectImplementation::addRewardedSchematic(DraftSchematic* schematic, short type, int quantity, bool notifyClient) {
	Vector<ManagedReference<DraftSchematic*> > schematics;

	schematics.add(schematic);

	CreatureObject* parent = cast<CreatureObject*>(asPlayerObject()->getParent().get().get());

	if (parent == nullptr)
		return false;

	if (type == SchematicList::LOOT && schematicList.contains(schematic)) {
		parent->sendSystemMessage("@loot_schematic:already_have_schematic"); // You already have this schematic.
		return false;
	}

	if (!schematicList.addRewardedSchematic(schematic, type, quantity))
		return true;

	if (addSchematics(schematics, notifyClient)) {
		if (notifyClient) {
			schematic->sendDraftSlotsTo(parent);
			schematic->sendResourceWeightsTo(parent);
		}

		return true;
	}

	return false;
}

/**
 * For use when manually removing a schematic, like if a quest termination removed a schematic
 * from a player, not needed when schematics are automatically removed by usecount decreasing
 */
void PlayerObjectImplementation::removeRewardedSchematic(DraftSchematic* schematic, bool notifyClient) {
	Vector<ManagedReference<DraftSchematic*> > schematics;

	schematics.add(schematic);
	schematicList.removeRewardedSchematic(schematic);

	return removeSchematics(schematics, true);
}

void PlayerObjectImplementation::decreaseSchematicUseCount(DraftSchematic* schematic) {

	if(schematicList.decreaseSchematicUseCount(schematic)) {
		Vector<ManagedReference<DraftSchematic*> > schematics;

		schematics.add(schematic);
		return removeSchematics(schematics, true);
	}
}

void PlayerObjectImplementation::removeSchematics(Vector<ManagedReference<DraftSchematic* > >& schematics, bool notifyClient) {
	if (schematics.size() == 0)
		return;

	if (notifyClient) {
		PlayerObjectDeltaMessage9* msg = new PlayerObjectDeltaMessage9(asPlayerObject());
		msg->startUpdate(4);

		schematicList.removeAll(msg);

		msg->close();

		sendMessage(msg);

	} else {

		schematicList.removeAll();
	}

	/**
	 * Here we are loading the schematics based on the skills that the
	 * player has, we do this incase we change the items
	 * in the schematic group.
	 */
	ZoneServer* zoneServer = server->getZoneServer();
	SkillManager* skillManager = zoneServer->getSkillManager();
	ManagedReference<CreatureObject*> player = getParentRecursively(SceneObjectType::PLAYERCREATURE).castTo<CreatureObject*>();

	if(player == nullptr)
		return;

	const SkillList* playerSkillBoxList = player->getSkillList();

	for(int i = 0; i < playerSkillBoxList->size(); ++i) {
		Skill* skillBox = playerSkillBoxList->get(i);
		skillManager->awardDraftSchematics(skillBox, asPlayerObject(), true);
	}

	schematicList.addRewardedSchematics(asPlayerObject());
}

void PlayerObjectImplementation::doDigest(int fillingReduction) {
	if (!isDigesting())
		return;

	fillingReduction *= 2;
	// Make sure filling isn't over max before we reduce
	if (foodFilling > foodFillingMax)
		foodFilling = foodFillingMax;

	if (drinkFilling > drinkFillingMax)
		drinkFilling = drinkFillingMax;

	if (foodFilling > 0) {
		setFoodFilling(foodFilling - fillingReduction);
		if (foodFilling < 0)
			foodFilling = 0;
	}

	if (drinkFilling > 0) {
		setDrinkFilling(drinkFilling - fillingReduction);
		if (drinkFilling < 0)
			drinkFilling = 0;
	}
}

Vector<ManagedReference<DraftSchematic* > > PlayerObjectImplementation::filterSchematicList(
		CreatureObject* player, Vector<uint32>* enabledTabs, int complexityLevel) {

	Locker _locker(asPlayerObject());

	return schematicList.filterSchematicList(player, enabledTabs, complexityLevel);
}

void PlayerObjectImplementation::addFriend(const String& name, bool notifyClient) {
	String nameLower = name.toLowerCase();

	PlayerManager* playerManager = server->getPlayerManager();

	uint64 objID = playerManager->getObjectID(nameLower);

	ZoneServer* zoneServer = server->getZoneServer();
	ManagedReference<CreatureObject*> playerToAdd;
	playerToAdd = zoneServer->getObject(objID).castTo<CreatureObject*>();

	ManagedReference<SceneObject*> strongParent = getParent().get();
	if (playerToAdd == nullptr || playerToAdd == strongParent) {
		if (notifyClient) {
			StringIdChatParameter param("cmnty", "friend_not_found");
			param.setTT(nameLower);
			if (strongParent != nullptr && strongParent->isCreatureObject())
				(cast<CreatureObject*>(strongParent.get()))->sendSystemMessage(param);
		}

		return;
	}

	PlayerObject* playerToAddGhost = playerToAdd->getPlayerObject();

	if (playerToAddGhost == nullptr)
		return;

	String firstName = "";

	if (strongParent != nullptr && strongParent->isCreatureObject()) {
		firstName = cast<CreatureObject*>(strongParent.get())->getFirstName();
		playerToAddGhost->addReverseFriend(firstName);
	}

	playerToAddGhost->updateToDatabase();

	if (notifyClient && strongParent != nullptr) {
		ChatOnAddFriend* init = new ChatOnAddFriend();
		strongParent->sendMessage(init);

		ChatOnChangeFriendStatus* add = new ChatOnChangeFriendStatus(strongParent->getObjectID(),	nameLower, zoneServer->getGalaxyName(), true);
		strongParent->sendMessage(add);

		// other player is online and is not ignoring this player?
		if (playerToAdd->isOnline() && !playerToAddGhost->isIgnoring(firstName)) {
			ChatFriendsListUpdate* notifyStatus = new ChatFriendsListUpdate(nameLower, zoneServer->getGalaxyName(), true);
			strongParent->sendMessage(notifyStatus);
		}

		friendList.add(nameLower);

		PlayerObjectDeltaMessage9* delta = new PlayerObjectDeltaMessage9(asPlayerObject());
		friendList.insertToDeltaMessage(delta);
		delta->close();

		strongParent->sendMessage(delta);

		StringIdChatParameter param("cmnty", "friend_added");
		param.setTT(nameLower);
		if (strongParent->isCreatureObject())
			(cast<CreatureObject*>(strongParent.get()))->sendSystemMessage(param);

	} else {
		friendList.add(nameLower);
	}
}

void PlayerObjectImplementation::removeFriend(const String& name, bool notifyClient) {
	String nameLower = name.toLowerCase();

	ManagedReference<CreatureObject*> strongParent = getParent().get().castTo<CreatureObject*>();

	if (!friendList.contains(nameLower)) {
		if (notifyClient && strongParent != nullptr) {
			StringIdChatParameter param("cmnty", "friend_not_found");
			param.setTT(nameLower);
			strongParent->sendSystemMessage(param);
		}

		return;
	}

	PlayerManager* playerManager = server->getPlayerManager();
	uint64 objID = playerManager->getObjectID(nameLower);

	ZoneServer* zoneServer = server->getZoneServer();
	ManagedReference<CreatureObject*> playerToRemove;
	playerToRemove = zoneServer->getObject(objID).castTo<CreatureObject*>();

	if (playerToRemove == nullptr) {
		if (notifyClient && strongParent != nullptr) {
			StringIdChatParameter param("cmnty", "friend_not_found");
			param.setTT(nameLower);
			strongParent->sendSystemMessage(param);
		}

	} else {
		PlayerObject* playerToRemoveGhost = playerToRemove->getPlayerObject();

		if (playerToRemoveGhost != nullptr) {
			if (strongParent != nullptr)
				playerToRemoveGhost->removeReverseFriend(strongParent->getFirstName());
			playerToRemoveGhost->updateToDatabase();
		}
	}

	ManagedReference<SceneObject*> parent = getParent().get();

	if (notifyClient && parent != nullptr) {
		ChatOnChangeFriendStatus* add = new ChatOnChangeFriendStatus(parent->getObjectID(),	nameLower, zoneServer->getGalaxyName(), false);
		parent->sendMessage(add);

		friendList.removePlayer(nameLower);

		PlayerObjectDeltaMessage9* delta = new PlayerObjectDeltaMessage9(asPlayerObject());
		friendList.insertToDeltaMessage(delta);
		delta->close();

		parent->sendMessage(delta);

		StringIdChatParameter param("cmnty", "friend_removed");
		param.setTT(nameLower);
		if (strongParent != nullptr)
			strongParent->sendSystemMessage(param);

	} else {
		friendList.removePlayer(nameLower);
	}
}

void PlayerObjectImplementation::removeAllFriends() {
	ManagedReference<CreatureObject*> strongParent = getParent().get().castTo<CreatureObject*>();

	if (strongParent == nullptr) {
		return;
	}

	String playerName = strongParent->getFirstName();
	PlayerManager* playerManager = server->getPlayerManager();
	ZoneServer* zoneServer = server->getZoneServer();

	while (friendList.size() > 0) {
		String name = friendList.get(0).toLowerCase();
		uint64 objID = playerManager->getObjectID(name);

		ManagedReference<CreatureObject*> playerToRemove = zoneServer->getObject(objID).castTo<CreatureObject*>();

		if (playerToRemove != nullptr) {
			PlayerObject* playerToRemoveGhost = playerToRemove->getPlayerObject();

			if (playerToRemoveGhost != nullptr) {
				playerToRemoveGhost->removeReverseFriend(playerName);
				playerToRemoveGhost->updateToDatabase();
			}
		}

		friendList.removePlayer(name);
	}

	while (friendList.reversePlayerCount() > 0) {
		String name = friendList.getReversePlayer(0).toLowerCase();
		uint64 objID = playerManager->getObjectID(name);

		ManagedReference<CreatureObject*> playerToRemove = zoneServer->getObject(objID).castTo<CreatureObject*>();

		if (playerToRemove != nullptr && playerToRemove->isPlayerCreature()) {
			Core::getTaskManager()->executeTask([=] () {
				Locker locker(playerToRemove);

				PlayerObject* ghost = playerToRemove->getPlayerObject();
				if (ghost != nullptr) {
					ghost->removeFriend(playerName, false);
				}
			}, "RemoveFriendLambda");
		}

		removeReverseFriend(name);
	}
}

void PlayerObjectImplementation::removeAllReverseFriends(const String& oldName) {
	PlayerManager* playerManager = server->getPlayerManager();
	ZoneServer* zoneServer = server->getZoneServer();

	while (friendList.reversePlayerCount() > 0) {
		String name = friendList.getReversePlayer(0).toLowerCase();
		uint64 objID = playerManager->getObjectID(name);

		ManagedReference<CreatureObject*> reverseFriend = zoneServer->getObject(objID).castTo<CreatureObject*>();

		if (reverseFriend != nullptr && reverseFriend->isPlayerCreature()) {
			Core::getTaskManager()->executeTask([=] () {
				Locker locker(reverseFriend);

				PlayerObject* ghost = reverseFriend->getPlayerObject();
				if (ghost != nullptr) {
					ghost->removeFriend(oldName, false);
				}
			}, "RemoveFriendLambda2");
		}

		removeReverseFriend(name);
	}
}

void PlayerObjectImplementation::addIgnore(const String& name, bool notifyClient) {
	String nameLower = name.toLowerCase();
	ManagedReference<SceneObject*> parent = getParent().get();

	if (notifyClient && parent != nullptr) {
		ChatOnChangeIgnoreStatus* add = new ChatOnChangeIgnoreStatus(parent->getObjectID(),	nameLower, server->getZoneServer()->getGalaxyName(), true);
		parent->sendMessage(add);

		ignoreList.add(nameLower);

		PlayerObjectDeltaMessage9* delta = new PlayerObjectDeltaMessage9(asPlayerObject());
		ignoreList.insertToDeltaMessage(delta);
		delta->close();

		parent->sendMessage(delta);

		StringIdChatParameter param("cmnty", "ignore_added");
		param.setTT(nameLower);
		if (parent->isCreatureObject())
			(cast<CreatureObject*>(parent.get()))->sendSystemMessage(param);

	} else {
		ignoreList.add(nameLower);
	}
}


void PlayerObjectImplementation::removeIgnore(const String& name, bool notifyClient) {
	String nameLower = name.toLowerCase();
	ManagedReference<SceneObject*> parent = getParent().get();

	if (!ignoreList.contains(nameLower)) {
		if (notifyClient) {
			StringIdChatParameter param("cmnty", "ignore_not_found");
			param.setTT(nameLower);
			if (parent != nullptr && parent->isCreatureObject())
				(cast<CreatureObject*>(parent.get()))->sendSystemMessage(param);
		}

		return;
	}

	if (notifyClient && parent != nullptr) {
		ChatOnChangeIgnoreStatus* add = new ChatOnChangeIgnoreStatus(parent->getObjectID(),	nameLower, server->getZoneServer()->getGalaxyName(), false);
		parent->sendMessage(add);

		ignoreList.removePlayer(nameLower);

		PlayerObjectDeltaMessage9* delta = new PlayerObjectDeltaMessage9(asPlayerObject());
		ignoreList.insertToDeltaMessage(delta);
		delta->close();

		parent->sendMessage(delta);

		StringIdChatParameter param("cmnty", "ignore_removed");
		param.setTT(nameLower);
		if (parent->isCreatureObject())
			(cast<CreatureObject*>(parent.get()))->sendSystemMessage(param);

	} else {
		ignoreList.removePlayer(nameLower);
	}
}

void PlayerObjectImplementation::setTitle(const String& characterTitle, bool notifyClient) {
	if (title == characterTitle)
		return;

	if(!characterTitle.isEmpty()){
		Skill* targetSkill = SkillManager::instance()->getSkill(characterTitle);

		if(targetSkill == nullptr || !targetSkill->isTitle()) {
			return;
		}
	}

	title = characterTitle;

	if (notifyClient) {
		PlayerObjectDeltaMessage3* dplay3 = new PlayerObjectDeltaMessage3(asPlayerObject());
		dplay3->setCurrentTitle(title);
		dplay3->close();
		broadcastMessage(dplay3, true); //update the zone.
	}
}

void PlayerObjectImplementation::notifyOnline() {
	ManagedReference<SceneObject*> parent = getParent().get();

	if (parent == nullptr) {
		return;
	}

	CreatureObject* playerCreature = parent->asCreatureObject();

	if (playerCreature == nullptr) {
		return;
	}

	miliSecsSession = 0;

	resetSessionStats(true);

#ifdef WITH_SESSION_API
	auto client = playerCreature->getClient();

	// NOTE: Call after resetSessionStats so first session_stats has been saved and can be inspected
	SessionAPIClient::instance()->notifyPlayerOnline(client != nullptr ? client->getIPAddress() : sessionStatsIPAddress,
			getAccountID(), playerCreature->getObjectID());
#endif // WITH_SESSION_API

	ChatManager* chatManager = server->getChatManager();
	ZoneServer* zoneServer = server->getZoneServer();

	String lowerFirstName = playerCreature->getFirstName();
	lowerFirstName = lowerFirstName.toLowerCase();

	for (int i = 0; i < friendList.reversePlayerCount(); ++i) {
		auto otherName = friendList.getReversePlayer(i);
		Reference<CreatureObject*> otherPlayer = chatManager->getPlayer(otherName);

		if (otherPlayer == nullptr) {
			continue;
		}

		auto otherGhost = otherPlayer->getPlayerObject();

		if (otherGhost == nullptr) {
			continue;
		}

		if (otherGhost->isPrivileged() || !isIgnoring(otherName)) {
			ChatFriendsListUpdate* notifyStatus = new ChatFriendsListUpdate(lowerFirstName, zoneServer->getGalaxyName(), true);
			otherPlayer->sendMessage(notifyStatus);
		}
	}

	for (int i = 0; i < friendList.size(); ++i) {
		auto otherName = friendList.get(i);
		Reference<CreatureObject*> otherPlayer = chatManager->getPlayer(otherName);

		if (otherPlayer == nullptr) {
			continue;
		}

		auto otherGhost = otherPlayer->getPlayerObject();

		if (otherGhost == nullptr) {
			continue;
		}

		if (isPrivileged() || !otherGhost->isIgnoring(lowerFirstName)) {
			ChatFriendsListUpdate* notifyStatus = new ChatFriendsListUpdate(otherName, zoneServer->getGalaxyName(), true);
			parent->sendMessage(notifyStatus);
		}
	}

	//Resend all suis.
	for (int i = 0; i < suiBoxes.size(); ++i) {
		ManagedReference<SuiBox*> sui = suiBoxes.get(i);

		parent->sendMessage(sui->generateMessage());
	}

	//Add player to visibility list
	VisibilityManager::instance()->addToVisibilityList(playerCreature);

	//Login to jedi manager
	JediManager::instance()->onPlayerLoggedIn(playerCreature);

	if (getFrsData()->getRank() >= 0) {
		FrsManager* frsManager = zoneServer->getFrsManager();

		if (frsManager != nullptr) {
			frsManager->playerLoggedIn(playerCreature);
		}
	}

	// Screenplay login triggers
	Lua* lua = DirectorManager::instance()->getLuaInstance();
	Reference<LuaFunction*> luaOnPlayerLoggedIn = lua->createFunction("PlayerTriggers", "playerLoggedIn", 0);
	*luaOnPlayerLoggedIn << playerCreature;
	luaOnPlayerLoggedIn->callFunction();

	playerCreature->notifyObservers(ObserverEventType::LOGGEDIN);

	// Set speed if player isn't mounted.
	if (!playerCreature->isRidingMount())
	{
		auto playerTemplate = dynamic_cast<SharedCreatureObjectTemplate*>(playerCreature->getObjectTemplate());

		if (playerTemplate != nullptr) {
			auto speedTempl = playerTemplate->getSpeed();

			playerCreature->setRunSpeed(speedTempl.get(0));
		}
	}

	if (playerCreature->isInGuild()) {
		ManagedReference<GuildObject*> guild = playerCreature->getGuildObject().get();
		uint64 playerId = playerCreature->getObjectID();

		if (guild != nullptr && !guild->hasMember(playerId)) {
			playerCreature->setGuildObject(nullptr);

			CreatureObjectDeltaMessage6* creod6 = new CreatureObjectDeltaMessage6(playerCreature);
			creod6->updateGuildID();
			creod6->close();
			playerCreature->broadcastMessage(creod6, true);

			updateInRangeBuildingPermissions();
		}
	}

	// Checks for DoTs that should have expired during server downtime and removes them
	playerCreature->getDamageOverTimeList()->validateDots(playerCreature);

	if (getForcePowerMax() > 0 && getForcePower() < getForcePowerMax())
		activateForcePowerRegen();

	schedulePvpTefRemovalTask();

	MissionManager* missionManager = zoneServer->getMissionManager();

	if (missionManager != nullptr && playerCreature->hasSkill("force_title_jedi_rank_02")) {
		uint64 id = playerCreature->getObjectID();

		if (!missionManager->hasPlayerBountyTargetInList(id))
			missionManager->addPlayerToBountyList(id, calculateBhReward());
		else {
			missionManager->updatePlayerBountyReward(id, calculateBhReward());
			missionManager->updatePlayerBountyOnlineStatus(id, true);
		}
	}

	playerCreature->schedulePersonalEnemyFlagTasks();

	if (ConfigManager::instance()->isPvpBroadcastChannelEnabled() && playerCreature->getFactionStatus() == FactionStatus::OVERT) {
		addChatRoom(chatManager->getPvpBroadcastRoom()->getRoomID());
	}
}

void PlayerObjectImplementation::notifyOffline() {
	debug("notifyOffline");

	ManagedReference<ChatManager*> chatManager = server->getChatManager();
	if (chatManager == nullptr)
		return;

	ManagedReference<CreatureObject*> playerCreature = cast<CreatureObject*>(parent.get().get());
	if (playerCreature == nullptr)
		return;

	String lowerFirstName = playerCreature->getFirstName();
	lowerFirstName = lowerFirstName.toLowerCase();

	for (int i = 0; i < friendList.reversePlayerCount(); ++i) {
		auto otherName = friendList.getReversePlayer(i);
		Reference<CreatureObject*> otherPlayer = chatManager->getPlayer(friendList.getReversePlayer(i));

		if (otherPlayer == nullptr) {
			continue;
		}

		auto otherGhost = otherPlayer->getPlayerObject();

		if (otherGhost == nullptr) {
			continue;
		}

		if (otherGhost->isPrivileged() || !isIgnoring(otherName)) {
			ChatFriendsListUpdate* notifyStatus = new ChatFriendsListUpdate(lowerFirstName, server->getZoneServer()->getGalaxyName(), false);
			otherPlayer->sendMessage(notifyStatus);
		}
	}

	//Remove player from visibility list
	VisibilityManager::instance()->removeFromVisibilityList(playerCreature);

	playerCreature->notifyObservers(ObserverEventType::LOGGEDOUT);

	//Logout from jedi manager
	JediManager::instance()->onPlayerLoggedOut(playerCreature);

	// Screenplay logout triggers
	Lua* lua = DirectorManager::instance()->getLuaInstance();
	Reference<LuaFunction*> luaOnPlayerLoggedOut = lua->createFunction("PlayerTriggers", "playerLoggedOut", 0);
	*luaOnPlayerLoggedOut << playerCreature;
	luaOnPlayerLoggedOut->callFunction();

	MissionManager* missionManager = getZoneServer()->getMissionManager();

	if (missionManager != nullptr && playerCreature->hasSkill("force_title_jedi_rank_02")) {
		missionManager->updatePlayerBountyOnlineStatus(playerCreature->getObjectID(), false);
	}

	ManagedReference<SurveySession*> session = playerCreature->getActiveSession(SessionFacadeType::SURVEY).castTo<SurveySession*>();

	if (session != nullptr) {
		session->cancelSession();
	}

	logSessionStats(true);

#ifdef WITH_SESSION_API
	auto client = playerCreature->getClient();

	// NOTE: Call after logSessionStats so session_stats has been saved and can be inspected
	SessionAPIClient::instance()->notifyPlayerOffline(client != nullptr ? client->getIPAddress() : sessionStatsIPAddress, getAccountID(),
			playerCreature->getObjectID());
#endif // WITH_SESSION_API
}

void PlayerObjectImplementation::incrementSessionMovement(float moveDelta) {
	if (moveDelta < 1.0f)
		return;

	sessionStatsActivityMovement += (int)moveDelta;
	sessionStatsTotalMovement += (int)moveDelta;
}

void PlayerObjectImplementation::resetSessionStats(bool isSessionStart) {
	Reference<SceneObject*> parent = getParent().get();
	CreatureObject* playerCreature = nullptr;

	if (parent != nullptr)
		playerCreature = parent->asCreatureObject();

	if (playerCreature != nullptr) {
		auto client = playerCreature->getClient();

		if (client != nullptr && (isSessionStart || sessionStatsIPAddress.isEmpty()))
			sessionStatsIPAddress = client->getIPAddress();
	}

	if (isSessionStart) {
		getZoneServer()->getPlayerManager()->updateOnlinePlayers();

		if (sessionStatsLastCredits == -1 && playerCreature != nullptr)
			sessionStatsLastCredits = playerCreature->getCashCredits() + playerCreature->getBankCredits();

		logSessionStats(false);
		sessionStatsTotalMovement = 0;
		sessionStatsTotalCredits = 0;
		return;
	}

	if (playerCreature != nullptr)
		sessionStatsLastCredits = playerCreature->getCashCredits() + playerCreature->getBankCredits();

	sessionStatsActivityXP = 0;
	sessionStatsActivityMovement = 0;
	sessionStatsLastSkillPoints = skillPoints;
	sessionStatsMiliSecs = 0;
}

void PlayerObjectImplementation::logSessionStats(bool isSessionEnd) {
	if (isSessionEnd)
		getZoneServer()->getPlayerManager()->updateOnlinePlayers();

	if (isSessionEnd
	&& sessionStatsActivityXP == 0
	&& sessionStatsActivityMovement == 0
	&& sessionStatsLastSkillPoints == skillPoints
	&& sessionStatsMiliSecs <= 2)
		return;

	int64 uptime = -1;
	int galaxyID = 0;
	uint64 objectID = 0;
	int64 currentCredits = sessionStatsLastCredits;

	Reference<SceneObject*> parent = getParent().get();

	if (parent != nullptr) {
		objectID = parent->getObjectID();

		CreatureObject* playerCreature = parent->asCreatureObject();

		if (playerCreature != nullptr) {
			currentCredits = playerCreature->getCashCredits() + playerCreature->getBankCredits();
			galaxyID = playerCreature->getZoneServer()->getGalaxyID();

			auto client = playerCreature->getClient();

			if (client != nullptr)
				sessionStatsIPAddress = client->getIPAddress();

			Time now;
			uptime = playerCreature->getZoneServer()->getStartTimestamp()->miliDifference(now);
		} else {
			error("playerCreature == nullptr in logSessionStats");
		}
	} else {
		error("parent == nullptr in logSessionStats");
	}

	if (sessionStatsLastCredits == -1) {
		sessionStatsLastCredits = currentCredits;
		sessionStatsTotalCredits = 0;
	}

	int skillPointDelta = skillPoints - sessionStatsLastSkillPoints;
	int64 creditsDelta = (int64)currentCredits - (int64)sessionStatsLastCredits;
	sessionStatsTotalCredits += creditsDelta;

	int ipAccountCount = 0;

	if (!sessionStatsIPAddress.isEmpty()) {
		SortedVector<uint32> loggedInAccounts = getZoneServer()->getPlayerManager()->getOnlineZoneClientMap()->getAccountsLoggedIn(sessionStatsIPAddress);
		ipAccountCount = loggedInAccounts.size();
	}

	// Need the session_stats table to log to database
	if (ServerCore::getSchemaVersion() >= 1003) {
		StringBuffer query;

		query << "INSERT INTO `session_stats` ("
			<< "`uptime`, `account_id`, `galaxy_id`, `character_oid`, `ip`, `session_end`"
			<< ", `session_seconds`, `delta_seconds`, `delta_credits`, `delta_skillpoints`"
			<< ", `activity_xp`, `activity_movement`, `current_credits`, `ip_account_count`"
			<< ") VALUES"
			<< " (" << (int)(uptime / 1000.0f)
			<< ", " << getAccountID()
			<< ", " << galaxyID
			<< ", " << objectID
			<< ", '" << sessionStatsIPAddress << "'"
			<< ", " << isSessionEnd
			<< ", " << (int)(miliSecsSession / 1000.0f)
			<< ", " << (int)(sessionStatsMiliSecs / 1000.0f)
			<< ", " << creditsDelta
			<< ", " << skillPointDelta
			<< ", " << sessionStatsActivityXP
			<< ", " << sessionStatsActivityMovement
			<< ", " << currentCredits
			<< ", " << ipAccountCount
			<< ");"
			;

		Core::getTaskManager()->executeTask([=] () {
			try {
				ServerDatabase::instance()->executeStatement(query);
			} catch(DatabaseException& e) {
				error(e.getMessage());
			}
		}, "logSessionStats");
	} else {
		StringBuffer logMsg;

		logMsg << "SessionStats:"
			<< " isSessionEnd: " << isSessionEnd
			<< " sessionSeconds: " << (int)(miliSecsSession / 1000.0f)
			<< " logSeconds: " << (int)(sessionStatsMiliSecs / 1000.0f)
			<< " creditsDelta: " << creditsDelta
			<< " skillPointDelta: " << skillPointDelta
			<< " activityXP: " << sessionStatsActivityXP
			<< " activityMovement: " << sessionStatsActivityMovement
			<< " ip: " << sessionStatsIPAddress
			<< " ipAccountCount: " << ipAccountCount
			<< " currentCredits: " << currentCredits
			;

		info(logMsg.toString(), true);
	}

	resetSessionStats(false);
}

void PlayerObjectImplementation::setLanguageID(byte language, bool notifyClient) {
	if (languageID == language)
		return;

	languageID = language;

	if (notifyClient) {
		PlayerObjectDeltaMessage9* dplay9 = new PlayerObjectDeltaMessage9(asPlayerObject());
		dplay9->setLanguageID(languageID);
		dplay9->close();
		getParent().get()->sendMessage(dplay9);
	}
}

void PlayerObjectImplementation::toggleCharacterBit(uint32 bit) {
	if (playerBitmask.hasPlayerBit(bit)) {
		playerBitmask.clearOneBit(bit);
	} else {
		playerBitmask.setOneBit(bit);
	}

	PlayerObjectDeltaMessage3* delta = new PlayerObjectDeltaMessage3(asPlayerObject());
	delta->updatePlayerBitmasks();
	delta->close();

	broadcastMessage(delta, true);
}

void PlayerObjectImplementation::setFoodFilling(int newValue, bool notifyClient) {
	if (foodFilling == newValue)
		return;

	foodFilling = newValue;

	if (notifyClient) {
		PlayerObjectDeltaMessage9* dplay9 = new PlayerObjectDeltaMessage9(asPlayerObject());
		dplay9->updateFoodFilling(newValue);
		dplay9->close();
		getParent().get()->sendMessage(dplay9);
	}
}

void PlayerObjectImplementation::setDrinkFilling(int newValue, bool notifyClient) {
	if (drinkFilling == newValue)
		return;

	drinkFilling = newValue;

	if (notifyClient) {
		PlayerObjectDeltaMessage9* dplay9 = new PlayerObjectDeltaMessage9(asPlayerObject());
		dplay9->updateDrinkFilling(drinkFilling);
		dplay9->close();
		getParent().get()->sendMessage(dplay9);
	}
}

void PlayerObjectImplementation::increaseFactionStanding(const String& factionName, float amount) {
	if (amount < 0)
		return; //Don't allow negative values to be sent to this method.

	CreatureObject* player = cast<CreatureObject*>(parent.get().get());

	if (player == nullptr)
		return;

	uint32 factionHash = factionName.hashCode();
	uint32 factionCRC = 0;
	bool playerIsFaction = player->getFaction() == factionHash;

	//Get the current amount of faction standing
	float currentAmount = factionStandingList.getFactionStanding(factionName);

	//Ensure that the new amount is not greater than 5000.
	float newAmount = currentAmount + amount;

	if (!factionStandingList.isPvpFaction(factionName))
		newAmount = Math::min(5000.f, newAmount);
	else if (playerIsFaction) {
		if (factionHash == STRING_HASHCODE("rebel"))
			factionCRC = Factions::FACTIONREBEL;
		else if (factionHash == STRING_HASHCODE("imperial"))
			factionCRC = Factions::FACTIONIMPERIAL;

		newAmount = Math::min((float) FactionManager::instance()->getFactionPointsCap(player->getFactionRank()), newAmount);
	} else {
		newAmount = Math::min(1000.f, newAmount);
	}

	factionStandingList.put(factionName, newAmount);

	if (amount != 0) {
		int change = floor(newAmount - currentAmount);

		//Send the proper system message.
		StringIdChatParameter msg("@base_player:prose_award_faction");
		msg.setTO("@faction/faction_names:" + factionName);
		msg.setDI(change);

		if (change == 0)
			msg.setStringId("@base_player:prose_max_faction");

		player->sendSystemMessage(msg);

		PlayerManager* playerManager = server->getPlayerManager();

		// Need to give Cries of Alderaan Faction Bonus only if they are not maxed already
		if (change > 0 && playerIsFaction && (playerManager != nullptr && playerManager->getCoaWinningFaction() == factionCRC)) {
			giveCoaBonus(factionName, amount, newAmount);
		}
	}
}

void PlayerObjectImplementation::giveCoaBonus(const String& factionName, float amount, float currentStanding) {
	CreatureObject* player = cast<CreatureObject*>(parent.get().get());

	if (player == nullptr)
		return;

	int bonus = amount * 0.1f;

	if (bonus < 1) {
		return;
	}

	float newStanding = bonus + currentStanding;

	newStanding = Math::min((float) FactionManager::instance()->getFactionPointsCap(player->getFactionRank()), newStanding);

	if (newStanding > 0) {
		factionStandingList.put(factionName, newStanding);
		int bonusApplied = floor(newStanding - currentStanding);

		StringIdChatParameter coaBonus("@base_player:prose_coa_bonus");

		coaBonus.setDI(bonusApplied);
		coaBonus.setTO("@faction/faction_names:" + factionName);
		player->sendSystemMessage(coaBonus);
	}
}

uint32 PlayerObjectImplementation::getNewSuiBoxID(uint32 type) {
	return (++suiBoxNextID << 16) + (uint16)type;
}

void PlayerObjectImplementation::removeSuiBox(unsigned int boxID, bool closeWindowToClient) {
	if (closeWindowToClient == true) {
		SuiBox* sui = suiBoxes.get(boxID);

		if (sui != nullptr) {
			sendMessage(sui->generateCloseMessage());
		}
	}

	suiBoxes.drop(boxID);
}

void PlayerObjectImplementation::removeSuiBoxType(unsigned int windowType) {
	SuiBox* sui = nullptr;

	while ((sui = getSuiBoxFromWindowType(windowType)) != nullptr) {
		removeSuiBox(sui->getBoxID(), true);
	}
}

void PlayerObjectImplementation::decreaseFactionStanding(const String& factionName, float amount) {
	if (amount < 0)
		return; //Don't allow negative values to be sent to this method.

	//Get the current amount of faction standing
	float currentAmount = factionStandingList.get(factionName);

	CreatureObject* player = cast<CreatureObject*>( parent.get().get());
	if (player == nullptr)
		return;

	//Ensure that the new amount is not less than -5000.
	float newAmount = Math::max(-5000.f, currentAmount - amount);

	if (factionStandingList.isPvpFaction(factionName)) {
		if (player->getFaction() == factionName.hashCode())
			newAmount = Math::min((float) FactionManager::instance()->getFactionPointsCap(player->getFactionRank()), newAmount);
		else
			newAmount = Math::min(1000.f, newAmount);
	}

	factionStandingList.put(factionName, newAmount);

	if (amount != 0) {
		int change = floor(currentAmount - newAmount);

		//Send the proper system message.
		StringIdChatParameter msg("@base_player:prose_lose_faction");
		msg.setTO("@faction/faction_names:" + factionName);
		msg.setDI(change);

		if (change == 0)
			msg.setStringId("@base_player:prose_min_faction");

		player->sendSystemMessage(msg);
	}
}

void PlayerObjectImplementation::setFactionStanding(const String& factionName, float newAmount) {
	CreatureObject* player = cast<CreatureObject*>( parent.get().get());

	if (player == nullptr)
		return;

	newAmount = Math::max(-5000.f, newAmount);

	if (factionStandingList.isPvpFaction(factionName)) {
		if (player->getFaction() == factionName.hashCode())
			newAmount = Math::min((float) FactionManager::instance()->getFactionPointsCap(player->getFactionRank()), newAmount);
		else
			newAmount = Math::min(1000.f, newAmount);
	}

	factionStandingList.put(factionName, newAmount);
}

float PlayerObjectImplementation::getFactionStanding(const String& factionName) const {
	return factionStandingList.getFactionStanding(factionName);
}

void PlayerObjectImplementation::addIncapacitationTime() {
	Time currentTime;
	uint32 now = currentTime.getTime();

	for (int i = incapacitationTimes.size() - 1; i >= 0; i--) {
		uint32 incapTime = incapacitationTimes.get(i);

		if ((now - incapTime) >= 600) {
			incapacitationTimes.removeElementAt(i);
		}
	}

	incapacitationTimes.add(now);
}

void PlayerObjectImplementation::logout(bool doLock) {
	Locker _locker(parent.get());

	try {
		if (disconnectEvent == nullptr) {
			Reference<CreatureObject*> creature = dynamic_cast<CreatureObject*>(parent.get().get());

			if (creature == nullptr)
				return;

			int isInSafeArea = creature->getSkillMod("private_safe_logout") || ConfigManager::instance()->getBool("Core3.PlayerObject.AlwaysSafeLogout", false);

			info("creating disconnect event: isInSafeArea=" + String::valueOf(isInSafeArea), true);

			disconnectEvent = new PlayerDisconnectEvent(asPlayerObject(), isInSafeArea);

			if (isLoggingOut()) {
				disconnectEvent->schedule(10);
			} else {
				disconnectEvent->schedule(1000);
				setLoggingOut();
			}
		}
	} catch (Exception& e) {
		error("unreported exception caught in PlayerCreatureImplementation::logout(boolean doLock)");
	}

}


void PlayerObjectImplementation::doRecovery(int latency) {
	if (getZoneServer()->isServerLoading()) {
		activateRecovery();

		return;
	}

	CreatureObject* creature = dynamic_cast<CreatureObject*>(parent.get().get());

	if (creature == nullptr)
		return;

	if (!isTeleporting()) {
		creature->removeOutOfRangeObjects();
	}

	ZoneServer* zoneServer = creature->getZoneServer();

	if (zoneServer == nullptr) {
		return;
	}

	if (isLinkDead()) {
		if (logoutTimeStamp.isPast()) {
			info("unloading link dead player");

			unload();

			setOffline();

			auto session = creature->getClient();
			if (session != nullptr)
				session->closeConnection(false, true);

			return;
		} else {
			debug("keeping link dead player in game");
		}
	}

	creature->activateHAMRegeneration(latency);
	creature->activateStateRecovery();

	CooldownTimerMap* cooldownTimerMap = creature->getCooldownTimerMap();

	if (cooldownTimerMap->isPast("digestEvent")) {
		Time currentTime;

		int timeDelta = currentTime.getMiliTime() - lastDigestion.getMiliTime();
		int fillingReduction = timeDelta / 18000;

		doDigest(fillingReduction);

		lastDigestion.updateToCurrentTime();
		cooldownTimerMap->updateToCurrentAndAddMili("digestEvent", 18000);
	}

	if (isOnline()) {
		if (creature->isInCombat() && creature->getTargetID() != 0 && !creature->isPeaced() && !creature->hasBuff(STRING_HASHCODE("private_feign_buff")) && !creature->hasAttackDelay() && !creature->hasPostureChangeDelay() &&
		creature->isNextActionPast() && creature->getCommandQueueSize() == 0 && !creature->isDead() && !creature->isIncapacitated() && cooldownTimerMap->isPast("autoAttackDelay")) {

			ManagedReference<SceneObject*> targetObject = zoneServer->getObject(creature->getTargetID());

			if (targetObject != nullptr) {
				WeaponObject* weapon = creature->getWeapon();

				if (weapon != nullptr) {
					if (targetObject->isInRange(creature, Math::max(10, weapon->getMaxRange()) + targetObject->getTemplateRadius() + creature->getTemplateRadius())) {
						creature->executeObjectControllerAction(STRING_HASHCODE("attack"), creature->getTargetID(), "");
					}

					float weaponSpeed = CombatManager::instance()->calculateWeaponAttackSpeed(creature, weapon, 1.f);
					float delay = weaponSpeed * 1000;

					Locker lock(creature);

					// as long as the target is still valid, we still want to continue to queue auto attacks
					cooldownTimerMap->updateToCurrentAndAddMili("autoAttackDelay", (uint64)delay);
				}
			} else {
				creature->setTargetID(0);
			}
		}

		auto zoneServer = getZoneServer();

		if (zoneServer != nullptr && !zoneServer->isServerLoading()) {
			auto zone = creature->getZone();

			if (zone != nullptr) {
				if (cooldownTimerMap->isPast("weatherEvent")) {
					auto planetManager = zone->getPlanetManager();

					if (planetManager != nullptr) {
						ManagedReference<WeatherManager*> weatherManager = planetManager->getWeatherManager();

						if (weatherManager != nullptr) {
							weatherManager->sendWeatherTo(creature);
						}

						cooldownTimerMap->updateToCurrentAndAddMili("weatherEvent", 3000);
					}
				}

				if (cooldownTimerMap->isPast("planetTimeEvent")) {
					ServerTimeMessage* stm = new ServerTimeMessage(creature->getZone());

					if (stm != nullptr) {
						sendMessage(stm);
					}

					cooldownTimerMap->updateToCurrentAndAddMili("planetTimeEvent", 60000);
				}
			}
		}

		miliSecsPlayed += latency;
		miliSecsSession += latency;
		sessionStatsMiliSecs += latency;

		if (sessionStatsMiliSecs >= ConfigManager::instance()->getSessionStatsSeconds() * 1000ull)
			logSessionStats(false);
	}

	activateRecovery();
}

void PlayerObjectImplementation::activateRecovery() {
	if (recoveryEvent == nullptr) {
		recoveryEvent = new PlayerRecoveryEvent(asPlayerObject());
	}

	if (!recoveryEvent->isScheduled()) {
		recoveryEvent->schedule(1000);
	}
}

void PlayerObjectImplementation::activateForcePowerRegen() {
	ManagedReference<CreatureObject*> creature = dynamic_cast<CreatureObject*>(parent.get().get());

	if (creature == nullptr)
		return;

	float regen = (float)creature->getSkillMod("jedi_force_power_regen");

	if(regen == 0.0f)
		return;

	if (forceRegenerationEvent == nullptr) {
		forceRegenerationEvent = new ForceRegenerationEvent(asPlayerObject());
	}

	if (!forceRegenerationEvent->isScheduled()) {
		int forceControlMod = 0, forceManipulationMod = 0;

		if (creature->hasSkill("force_rank_light_novice")) {
			forceControlMod = creature->getSkillMod("force_control_light");
			forceManipulationMod = creature->getSkillMod("force_manipulation_light");
		} else if (creature->hasSkill("force_rank_dark_novice")) {
			forceControlMod = creature->getSkillMod("force_power_dark");
			forceManipulationMod = creature->getSkillMod("force_manipulation_dark");
		}

		regen += (forceControlMod + forceManipulationMod) / 10.f;

		int regenMultiplier = creature->getSkillMod("private_force_regen_multiplier");
		int regenDivisor = creature->getSkillMod("private_force_regen_divisor");

		if (regenMultiplier != 0)
			regen *= regenMultiplier;

		if (regenDivisor != 0)
			regen /= regenDivisor;

		float timer = regen / 5.f;

		float scheduledTime = 10 / timer;
		uint64 miliTime = static_cast<uint64>(scheduledTime * 1000.f);
		forceRegenerationEvent->schedule(miliTime);
	}
}

void PlayerObjectImplementation::setLinkDead(bool isSafeLogout) {
	CreatureObject* creature = dynamic_cast<CreatureObject*>(parent.get().get());

	if (creature == nullptr)
		return;

	onlineStatus = LINKDEAD;

	TransactionLog trx(TrxCode::PLAYERLINKDEAD, getParentRecursively(SceneObjectType::PLAYERCREATURE));
	trx.addState("isSafeLogout", isSafeLogout);

	logoutTimeStamp.updateToCurrentTime();

	if(!isSafeLogout) {
		info("went link dead");
		logoutTimeStamp.addMiliTime(ConfigManager::instance()->getInt("Core3.PlayerObject.LinkDeadDelay", 3 * 60) * 1000); // 3 minutes if unsafe
	}

	setPlayerBit(PlayerBitmasks::LD, true);

	activateRecovery();

	notifyOffline();

	creature->clearQueueActions(false);
}

void PlayerObjectImplementation::setOnline() {
	onlineStatus = ONLINE;

	TransactionLog trx(TrxCode::PLAYERONLINE, getParentRecursively(SceneObjectType::PLAYERCREATURE));

	clearPlayerBit(PlayerBitmasks::LD, true);

	PlayerObjectDeltaMessage3* dplay3 = new PlayerObjectDeltaMessage3(asPlayerObject());
	dplay3->setBirthDate();
	dplay3->setTotalPlayTime();
	dplay3->close();
	broadcastMessage(dplay3, true);

	doRecovery(1000);

	activateMissions();
}

void PlayerObjectImplementation::setOffline() {
	onlineStatus = OFFLINE;

	TransactionLog trx(TrxCode::PLAYEROFFLINE, getParentRecursively(SceneObjectType::PLAYERCREATURE));
}

void PlayerObjectImplementation::setLoggingOut() {
	onlineStatus = LOGGINGOUT;

	TransactionLog trx(TrxCode::PLAYERLOGGINGOUT, getParentRecursively(SceneObjectType::PLAYERCREATURE));
}

void PlayerObjectImplementation::reload(ZoneClientSession* client) {
	if (disconnectEvent != nullptr) {
		disconnectEvent->cancel();
		disconnectEvent = nullptr;
	}

	CreatureObject* creature = dynamic_cast<CreatureObject*>(parent.get().get());

	if (creature == nullptr)
		return;

	setOnline();

	creature->setMovementCounter(0);

	if (creature->isRidingMount() && creature->getParent() == nullptr) {
		creature->clearState(CreatureState::RIDINGMOUNT);
	}

	creature->getZone()->transferObject(creature, -1, true);
}

void PlayerObjectImplementation::disconnect(bool closeClient, bool doLock) {
	Locker locker(parent.get());

	CreatureObject* creature = dynamic_cast<CreatureObject*>(parent.get().get());

	if (creature == nullptr)
		return;

	setLastLogoutWorldPosition();

	if (!isOnline()) {
		auto owner = creature->getClient();

		if (closeClient && owner != nullptr)
			owner->closeConnection(false, true);

		creature->setClient(nullptr);

		return;
	}

	if (!isLinkDead()) {
		info("link dead");

		setLinkDead();
	} else {
		info ("disconnecting player");

		unload();
		setOffline();
	}

	if (disconnectEvent != nullptr)
		disconnectEvent = nullptr;

	auto owner = creature->getClient();

	if (closeClient && owner != nullptr)
		owner->closeConnection(false, true);

	creature->setClient(nullptr);
}

void PlayerObjectImplementation::clearDisconnectEvent() {
	disconnectEvent = nullptr;
}

void PlayerObjectImplementation::maximizeExperience() {
	auto player = getParentRecursively(SceneObjectType::PLAYERCREATURE).castTo<CreatureObject*>();

	if (player == nullptr)
		return;

	VectorMap<String, int>* xpCapList = getXpTypeCapList();

	for (int i = 0; i < xpCapList->size(); ++i) {
		TransactionLog trx(TrxCode::EXPERIENCE, player);
		addExperience(trx, xpCapList->elementAt(i).getKey(), xpCapList->elementAt(i).getValue(), true);
	}
}

int PlayerObjectImplementation::getForcePowerRegen() {

	ManagedReference<CreatureObject*> creature = dynamic_cast<CreatureObject*>(parent.get().get());

	if (creature == nullptr) {
		return 0;
	}

	return creature->getSkillMod("jedi_force_power_regen");
}
void PlayerObjectImplementation::activateMissions() {
	ManagedReference<CreatureObject*> creature = dynamic_cast<CreatureObject*>(parent.get().get());

	if (creature == nullptr) {
		return;
	}

	SceneObject* datapad = creature->getSlottedObject("datapad");

	if (datapad == nullptr) {
		return;
	}

	int datapadSize = datapad->getContainerObjectsSize();

	for (int i = datapadSize - 1; i >= 0; --i) {
		if (datapad->getContainerObject(i)->isMissionObject()) {
			Reference<MissionObject*> mission = datapad->getContainerObject(i).castTo<MissionObject*>();

			if (mission != nullptr) {
				//Check if it is target or destination NPC
				MissionObjective* objective = mission->getMissionObjective();
				if (objective != nullptr) {
					Locker locker(objective);
					objective->activate();
				}
			}
		}
	}
}

void PlayerObjectImplementation::setForcePowerMax(int newValue, bool notifyClient) {
	if (newValue == getForcePowerMax())
		return;

	forcePowerMax = newValue;

	if (forcePower > forcePowerMax)
		setForcePower(forcePowerMax, true);

	if (forcePower < forcePowerMax) {
		activateForcePowerRegen();
	}

	if (notifyClient == true){
		// Update the force power bar max.
		PlayerObjectDeltaMessage8* dplay8 = new PlayerObjectDeltaMessage8(this);
		dplay8->updateForcePowerMax();
		dplay8->close();

		sendMessage(dplay8);
	}
}

void PlayerObjectImplementation::setForcePower(int fp, bool notifyClient) {
	if (fp == getForcePower())
		return;

	// Set forcepower back to 0 incase player goes below
	if (fp < 0)
		fp = 0;

	// Set force back to max incase player goes over
	if (fp > getForcePowerMax())
		fp = getForcePowerMax();

	// Activate regeneration.
	if (fp < getForcePowerMax()) {
		activateForcePowerRegen();
	}

	forcePower = fp;

	if (notifyClient == true){
		// Update the force power bar.
		PlayerObjectDeltaMessage8* dplay8 = new PlayerObjectDeltaMessage8(this);
		dplay8->updateForcePower();
		dplay8->close();

		sendMessage(dplay8);
	}

}

void PlayerObjectImplementation::doForceRegen() {
	CreatureObject* creature = dynamic_cast<CreatureObject*>(parent.get().get());

	if (creature == nullptr || creature->isIncapacitated() || creature->isDead())
		return;

	const static uint32 tick = 5;

	uint32 modifier = 1;

	if (creature->isMeditating()) {
		Reference<ForceMeditateTask*> medTask = creature->getPendingTask("forcemeditate").castTo<ForceMeditateTask*>();

		if (medTask != nullptr)
			modifier = 5;
	}

	uint32 forceTick = tick * modifier;

	if (forceTick > getForcePowerMax() - getForcePower()){   // If the player's Force Power is going to regen again and it's close to max,
		setForcePower(getForcePowerMax());             // Set it to max, so it doesn't go over max.
	} else {
		setForcePower(getForcePower() + forceTick); // Otherwise regen normally.
	}
}

void PlayerObjectImplementation::clearScreenPlayData(const String& screenPlay) {
	for (int i = screenPlayData.size() - 1; i >= 0; --i) {
		if (screenPlayData.elementAt(i).getKey().contains(screenPlay + "_"))
			screenPlayData.drop(screenPlayData.elementAt(i).getKey());
	}
}

Time PlayerObjectImplementation::getLastVisibilityUpdateTimestamp() const {
	return lastVisibilityUpdateTimestamp;
}

Time PlayerObjectImplementation::getLastBhPvpCombatActionTimestamp() const {
	return lastBhPvpCombatActionTimestamp;
}

Time PlayerObjectImplementation::getLastGcwPvpCombatActionTimestamp() const {
	return lastGcwPvpCombatActionTimestamp;
}

Time PlayerObjectImplementation::getLastGcwCrackdownCombatActionTimestamp() const {
	return lastCrackdownGcwCombatActionTimestamp;
}

Time PlayerObjectImplementation::getLastPvpAreaCombatActionTimestamp() const {
	return lastPvpAreaCombatActionTimestamp;
}

void PlayerObjectImplementation::updateLastCombatActionTimestamp(bool updateGcwCrackdownAction, bool updateGcwAction, bool updateBhAction) {
	ManagedReference<CreatureObject*> parent = getParent().get().castTo<CreatureObject*>();

	if (parent == nullptr)
		return;

	bool alreadyHasTef = hasTef();

	if (updateGcwCrackdownAction) {
		lastCrackdownGcwCombatActionTimestamp.updateToCurrentTime();
		lastCrackdownGcwCombatActionTimestamp.addMiliTime(FactionManager::TEFTIMER);
	}

	if (updateBhAction) {
		bool alreadyHasBhTef = hasBhTef();
		lastBhPvpCombatActionTimestamp.updateToCurrentTime();
		lastBhPvpCombatActionTimestamp.addMiliTime(FactionManager::TEFTIMER);

		if (!alreadyHasBhTef)
			parent->notifyObservers(ObserverEventType::BHTEFCHANGED);
	}

	if (updateGcwAction) {
		lastGcwPvpCombatActionTimestamp.updateToCurrentTime();
		lastGcwPvpCombatActionTimestamp.addMiliTime(FactionManager::TEFTIMER);
	}

	schedulePvpTefRemovalTask();

	if (!alreadyHasTef && (updateGcwCrackdownAction || updateGcwAction || updateBhAction)) {
		updateInRangeBuildingPermissions();
		parent->setPvpStatusBit(ObjectFlag::TEF);
	}
}

void PlayerObjectImplementation::updateLastBhPvpCombatActionTimestamp() {
	updateLastCombatActionTimestamp(false, false, true);
}

void PlayerObjectImplementation::updateLastGcwPvpCombatActionTimestamp() {
	updateLastCombatActionTimestamp(false, true, false);
}

void PlayerObjectImplementation::updateLastPvpAreaCombatActionTimestamp() {
	ManagedReference<CreatureObject*> parent = getParent().get().castTo<CreatureObject*>();

	if (parent == nullptr)
		return;

	lastPvpAreaCombatActionTimestamp.updateToCurrentTime();
	lastPvpAreaCombatActionTimestamp.addMiliTime(FactionManager::TEFTIMER);

	if (!(parent->getPvpStatusBitmask() & ObjectFlag::TEF)) {
		updateInRangeBuildingPermissions();
		parent->setPvpStatusBit(ObjectFlag::TEF);
	}

	schedulePvpTefRemovalTask();
}

bool PlayerObjectImplementation::hasTef() const {
	return hasCrackdownTef() || hasPvpTef();
}

bool PlayerObjectImplementation::hasPvpTef() const {
	return !lastGcwPvpCombatActionTimestamp.isPast() || hasBhTef() || !lastPvpAreaCombatActionTimestamp.isPast();
}

bool PlayerObjectImplementation::hasGcwTef() const {
	return !lastGcwPvpCombatActionTimestamp.isPast();
}

bool PlayerObjectImplementation::hasBhTef() const {
	return !lastBhPvpCombatActionTimestamp.isPast();
}

void PlayerObjectImplementation::setCrackdownTefTowards(unsigned int factionCrc, bool scheduleTefRemovalTask) {
	crackdownFactionTefCrc = factionCrc;
	if (scheduleTefRemovalTask) {
		updateLastCombatActionTimestamp(true, false, false);
	}
}

bool PlayerObjectImplementation::hasCrackdownTefTowards(unsigned int factionCrc) const {
	return !lastCrackdownGcwCombatActionTimestamp.isPast() && factionCrc != 0 && crackdownFactionTefCrc == factionCrc;
}

bool PlayerObjectImplementation::hasCrackdownTef() const {
	return !lastCrackdownGcwCombatActionTimestamp.isPast() && crackdownFactionTefCrc != 0;
}

void PlayerObjectImplementation::schedulePvpTefRemovalTask(bool removeCrackdownGcwTefNow, bool removeGcwTefNow, bool removeBhTefNow) {
	ManagedReference<CreatureObject*> parent = getParent().get().castTo<CreatureObject*>();

	if (parent == nullptr) {
		return;
	}

	if (pvpTefTask == nullptr) {
		pvpTefTask = new PvpTefRemovalTask(parent);
	}

	if (removeCrackdownGcwTefNow || removeGcwTefNow || removeBhTefNow) {
		if (removeCrackdownGcwTefNow) {
			crackdownFactionTefCrc = 0;
			lastCrackdownGcwCombatActionTimestamp.updateToCurrentTime();
		}

		if (removeGcwTefNow) {
			lastGcwPvpCombatActionTimestamp.updateToCurrentTime();
			lastPvpAreaCombatActionTimestamp.updateToCurrentTime();
		}

		if (removeBhTefNow) {
			lastBhPvpCombatActionTimestamp.updateToCurrentTime();
			parent->notifyObservers(ObserverEventType::BHTEFCHANGED);
		}

		if (pvpTefTask->isScheduled()) {
			pvpTefTask->cancel();
		}
	}

	if (!pvpTefTask->isScheduled()) {
		if (hasTef()) {
			auto gcwCrackdownTefMs = getLastGcwCrackdownCombatActionTimestamp().miliDifference();
			auto gcwTefMs = getLastGcwPvpCombatActionTimestamp().miliDifference();
			auto bhTefMs = getLastBhPvpCombatActionTimestamp().miliDifference();
			auto pvpAreaMs = getLastPvpAreaCombatActionTimestamp().miliDifference();

			auto scheduleTime = gcwTefMs < bhTefMs ? gcwTefMs : bhTefMs;
			scheduleTime = gcwCrackdownTefMs < scheduleTime ? gcwCrackdownTefMs : scheduleTime;
			scheduleTime = pvpAreaMs < scheduleTime ? pvpAreaMs : scheduleTime;

			pvpTefTask->schedule(llabs(scheduleTime));
		} else {
			pvpTefTask->execute();
		}
	}
}

void PlayerObjectImplementation::schedulePvpTefRemovalTask(bool removeNow) {
	schedulePvpTefRemovalTask(removeNow, removeNow, removeNow);
}

Vector3 PlayerObjectImplementation::getJediTrainerCoordinates() const {
	return trainerCoordinates;
}

void PlayerObjectImplementation::setTrainerCoordinates(const Vector3& trainer) {
	trainerCoordinates = trainer;
}

void PlayerObjectImplementation::addPermissionGroup(const String& group, bool updatePermissions) {
	permissionGroups.put(group);

	if (updatePermissions)
		updateInRangeBuildingPermissions();
}

void PlayerObjectImplementation::removePermissionGroup(const String& group, bool updatePermissions) {
	permissionGroups.drop(group);

	if (updatePermissions)
		updateInRangeBuildingPermissions();
}

void PlayerObjectImplementation::updateInRangeBuildingPermissions() {
	ManagedReference<CreatureObject*> parent = getParent().get().castTo<CreatureObject*>();

	if (parent == nullptr)
		return;

	Zone* zone = parent->getZone();

	if (zone == nullptr)
		return;

	CloseObjectsVector* vec = (CloseObjectsVector*) parent->getCloseObjects();

	SortedVector<TreeEntry*> closeObjects;
	vec->safeCopyReceiversTo(closeObjects, CloseObjectsVector::STRUCTURETYPE);

	for (int i = 0; i < closeObjects.size(); ++i) {
		BuildingObject* building = cast<BuildingObject*>(closeObjects.get(i));

		if (building != nullptr) {
			building->updateCellPermissionsTo(parent);
		}
	}
}

bool PlayerObjectImplementation::hasPermissionGroup(const String& group) const {
	return permissionGroups.contains(group);
}

void PlayerObjectImplementation::destroyObjectFromDatabase(bool destroyContainedObjects) {
	IntangibleObjectImplementation::destroyObjectFromDatabase(destroyContainedObjects);

	removeAllFriends();

	deleteAllPersistentMessages();

	deleteAllWaypoints();

	for (int i = 0; i < currentEventPerks.size(); ++i) {
		uint64 oid = currentEventPerks.get(i);

		ManagedReference<EventPerkDeed*> perk = getZoneServer()->getObject(oid).castTo<EventPerkDeed*>();

		if (perk != nullptr) {
			perk->activateRemoveEvent(true);
		}
	}

	for (int i = 0; i < ownedVendors.size(); ++i) {
		uint64 oid = ownedVendors.get(i);

		ManagedReference<TangibleObject*> vendor = getZoneServer()->getObject(oid).castTo<TangibleObject*>();

		if (vendor != nullptr) {
			VendorManager::instance()->destroyVendor(vendor);
		}
	}

	for (int i = 0; i < ownedStructures.size(); ++i) {
		uint64 oid = ownedStructures.get(i);

		ManagedReference<StructureObject*> structure = getZoneServer()->getObject(oid).castTo<StructureObject*>();

		if (structure != nullptr) {
			Zone* zone = structure->getZone();

			if (zone != nullptr) {
				if (structure->isCivicStructure()) {
					StructureSetOwnerTask* task = new StructureSetOwnerTask(structure, 0);
					task->execute();

					if (structure->isCityHall()) {
						ManagedReference<CityRegion*> city = structure->getCityRegion().get();

						if (city != nullptr) {
							Core::getTaskManager()->executeTask([=] () {
								Locker locker(city);

								city->setMayorID(0);
							}, "SetMayorIDLambda");
						}
					}

					continue;
				} else if (structure->isGCWBase()) {
					Reference<BuildingObject*> baseRef = structure->asBuildingObject();
					Reference<Zone*> zoneRef = zone;

					Core::getTaskManager()->executeTask([baseRef, zoneRef] () {
						if (baseRef == nullptr || zoneRef == nullptr)
							return;

						GCWManager* gcwMan = zoneRef->getGCWManager();

						if (gcwMan != nullptr)
							gcwMan->scheduleBaseDestruction(baseRef, nullptr, true);
					}, "DestroyBaseLambda");

					continue;
				}

				StructureManager::instance()->destroyStructure(structure);
			} else {
				structure->destroyObjectFromDatabase(true);
			}
		}
	}

	if (isMarried()) {
		PlayerManager* playerManager = server->getPlayerManager();
		ManagedReference<CreatureObject*> spouse = playerManager->getPlayer(spouseName);

		if (spouse != nullptr) {
			PlayerObject* spouseGhost = spouse->getPlayerObject();

			if (spouseGhost != nullptr) {
				RemoveSpouseTask* task = new RemoveSpouseTask(spouse);
				task->execute();
			}
		}
	}
}

void PlayerObjectImplementation::deleteAllPersistentMessages() {
	for (int i = persistentMessages.size() - 1; i >= 0; --i) {
		uint64 messageObjectID = persistentMessages.get(i);

		Reference<PersistentMessage*> mail = Core::getObjectBroker()->lookUp(messageObjectID).castTo<PersistentMessage*>();

		if (mail != nullptr) {
			ObjectManager::instance()->destroyObjectFromDatabase(messageObjectID);
		}

		dropPersistentMessage(messageObjectID);
	}
}

void PlayerObjectImplementation::deleteAllWaypoints() {
	for (int i = 0; i < waypointList.size(); ++i) {
		WaypointObject* waypoint = waypointList.getValueAt(i);

		if (waypoint != nullptr && waypoint->isPersistent()) {
			waypoint->destroyObjectFromDatabase(true);
		}
	}
}

int PlayerObjectImplementation::getLotsRemaining() {
	if (account == nullptr) {
		return 0;
	}

	Reference<CharacterList*> characters = account->getCharacterList();
	ZoneServer* zoneServer = server->getZoneServer();

	if (characters == nullptr || zoneServer == nullptr) {
		return 0;
	}

	int lotsRemaining = maximumLots * characters->size();

	for (int i = 0; i < characters->size(); ++i) {
		CharacterListEntry& entry = characters->get(i);
		uint64 oid = entry.getObjectID();

		ManagedReference<CreatureObject*> obj = zoneServer->getObject(oid).castTo<CreatureObject*>();

		if (obj != nullptr) {
			ManagedReference<PlayerObject*> ghost = obj->getPlayerObject();

			if (ghost != nullptr) {
				int ownedStructureCount = ghost->getTotalOwnedStructureCount();

				for (int j = 0; j < ownedStructureCount; ++j) {
					auto oid = ghost->getOwnedStructure(j);
					ManagedReference<StructureObject*> structure = getZoneServer()->getObject(oid).castTo<StructureObject*>();


					if (structure != nullptr) {
						lotsRemaining -= structure->getLotSize();
					}
				}
			}
		}
	}

	return lotsRemaining;
}

int PlayerObjectImplementation::getOwnedChatRoomCount() {
	ManagedReference<ChatManager*> chatManager = getZoneServer()->getChatManager();
	if (chatManager == nullptr)
		return 0;

	int roomCount = 0;

	for (int i = ownedChatRooms.size() - 1; i >= 0; i--) {
		ManagedReference<ChatRoom*> room = chatManager->getChatRoom(ownedChatRooms.get(i));
		if (room != nullptr)
			roomCount++;
		else
			ownedChatRooms.remove(i);
	}

	return roomCount;

}

void PlayerObjectImplementation::activateJournalQuest(unsigned int questCrc, bool notifyClient) {
	PlayerQuestData questData = getQuestData(questCrc);

	if (questData.getOwnerId() != 0) {
		return;
	}

	CreatureObject* creature = cast<CreatureObject*>(getParent().get().get());

	if (creature == nullptr) {
		return;
	}

	questData.setOwnerId(getObjectID());
	questData.setActiveStepBitmask(0);
	questData.setCompletedStepBitmask(0);
	questData.setCompletedFlag(0);

	setPlayerQuestData(questCrc, questData);

	activateJournalQuestTask(questCrc, 0, notifyClient);
}

void PlayerObjectImplementation::completeJournalQuest(unsigned int questCrc, bool notifyClient) {
	PlayerQuestData questData = getQuestData(questCrc);

	if (questData.getOwnerId() == 0) {
		return;
	}

	CreatureObject* creature = cast<CreatureObject*>(getParent().get().get());

	if (creature == nullptr) {
		return;
	}

	questData.setCompletedFlag(1);
	setPlayerQuestData(questCrc, questData);

	if (notifyClient)
		creature->sendSystemMessage("@quest/quests:quest_journal_updated");
}

void PlayerObjectImplementation::clearJournalQuest(unsigned int questCrc, bool notifyClient) {
	PlayerQuestData questData = getQuestData(questCrc);

	if (questData.getOwnerId() == 0) {
		return;
	}

	CreatureObject* creature = cast<CreatureObject*>(getParent().get().get());

	if (creature == nullptr) {
		return;
	}

	clearPlayerQuestData(questCrc);

	if (notifyClient)
		creature->sendSystemMessage("@quest/quests:quest_journal_updated");
}

void PlayerObjectImplementation::activateJournalQuestTask(unsigned int questCrc, int taskNum, bool notifyClient) {
	if (taskNum > 15) {
		return;
	}

	PlayerQuestData questData = getQuestData(questCrc);

	if (questData.getOwnerId() == 0) {
		return;
	}

	if (questData.getActiveStepBitmask() & (1 << taskNum)) {
		return;
	}

	CreatureObject* creature = cast<CreatureObject*>(getParent().get().get());

	if (creature == nullptr) {
		return;
	}

	uint16 activeStepBit = questData.getActiveStepBitmask();
	uint16 completedStepBit = questData.getCompletedStepBitmask();

	questData.setActiveStepBitmask(activeStepBit | (1 << taskNum));
	questData.setCompletedStepBitmask(completedStepBit & ~(1 << taskNum));

	// creature->info(true) << "activateJournalQuestTask -- Quest: " << questCrc << " Active Step Bitmask: " << activeStepBit << " Complete Step Bit: " << completedStepBit;

	setPlayerQuestData(questCrc, questData);

	if (notifyClient) {
		creature->sendSystemMessage("@quest/quests:quest_journal_updated");
	}
}

void PlayerObjectImplementation::completeJournalQuestTask(unsigned int questCrc, int taskNum, bool notifyClient) {
	if (taskNum > 15) {
		return;
	}

	PlayerQuestData questData = getQuestData(questCrc);

	if (questData.getOwnerId() == 0) {
		return;
	}

	if ((questData.getActiveStepBitmask() & (1 << taskNum)) == 0) {
		return;
	}

	CreatureObject* creature = cast<CreatureObject*>(getParent().get().get());

	if (creature == nullptr) {
		return;
	}

	uint16 activeStepBit = questData.getActiveStepBitmask();
	uint16 completedStepBit = questData.getCompletedStepBitmask();

	questData.setActiveStepBitmask(activeStepBit & ~(1 << taskNum));
	questData.setCompletedStepBitmask(completedStepBit | (1 << taskNum));

	// creature->info(true) << "completeJournalQuestTask -- Quest: " << questCrc << " Active Step Bitmask: " << activeStepBit << " Complete Step Bit: " << completedStepBit;

	setPlayerQuestData(questCrc, questData);

	if (notifyClient) {
		creature->sendSystemMessage("@quest/quests:task_complete");
	}
}

void PlayerObjectImplementation::clearJournalQuestTask(unsigned int questCrc, int taskNum, bool notifyClient) {
	if (taskNum > 15) {
		return;
	}

	PlayerQuestData questData = getQuestData(questCrc);

	if (questData.getOwnerId() == 0) {
		return;
	}

	CreatureObject* creature = cast<CreatureObject*>(getParent().get().get());

	if (creature == nullptr) {
		return;
	}

	questData.setActiveStepBitmask(questData.getActiveStepBitmask() & ~(1 << taskNum));
	questData.setCompletedStepBitmask(questData.getCompletedStepBitmask() & ~(1 << taskNum));

	setPlayerQuestData(questCrc, questData);

	if (notifyClient) {
		creature->sendSystemMessage("@quest/quests:quest_journal_updated");
	}
}

bool PlayerObjectImplementation::isJournalQuestActive(unsigned int questCrc) {
	PlayerQuestData questData = getQuestData(questCrc);

	if (questData.getCompletedFlag()) {
		return false;
	}

	return questData.getOwnerId() ? true : false;
}

bool PlayerObjectImplementation::isJournalQuestComplete(unsigned int questCrc) {
	PlayerQuestData questData = getQuestData(questCrc);
	return questData.getCompletedFlag() ? true : false;
}

bool PlayerObjectImplementation::isJournalQuestTaskActive(unsigned int questCrc, int taskNum) {
	if (taskNum > 15)
		return false;

	PlayerQuestData questData = getQuestData(questCrc);
	if (questData.getActiveStepBitmask() & (1 << taskNum))
		return true;

	return false;
}

bool PlayerObjectImplementation::isJournalQuestTaskComplete(unsigned int questCrc, int taskNum) {
	if (taskNum > 15)
		return false;

	PlayerQuestData questData = getQuestData(questCrc);
	if (questData.getCompletedStepBitmask() & (1 << taskNum))
		return true;

	return false;
}

void PlayerObjectImplementation::setJediState(int state, bool notifyClient) {
	if (jediState == state)
		return;

	jediState = state;

	if (!notifyClient)
		return;

	PlayerObjectDeltaMessage9* delta = new PlayerObjectDeltaMessage9(asPlayerObject());
	delta->setJediState(state);
	delta->close();

	sendMessage(delta);
}

int PlayerObjectImplementation::getSpentJediSkillPoints() {
	if (jediState < 2)
		return 0;

	ManagedReference<CreatureObject*> player = getParentRecursively(SceneObjectType::PLAYERCREATURE).castTo<CreatureObject*>();

	if(player == nullptr)
		return 0;

	int jediSkillPoints = 0;

	const SkillList* skillList = player->getSkillList();

	for(int i = 0; i < skillList->size(); ++i) {
		const Skill* jediSkill = skillList->get(i);

		if (jediSkill->getSkillName().indexOf("force_discipline") != -1)
			jediSkillPoints += jediSkill->getSkillPointsRequired();
	}

	return jediSkillPoints;
}

bool PlayerObjectImplementation::canActivateQuest(int questID) {
	ManagedReference<CreatureObject*> creature = dynamic_cast<CreatureObject*>(parent.get().get());

	if (creature == nullptr)
		return false;

	PlayerManager* playerManager = creature->getZoneServer()->getPlayerManager();

	if (playerManager == nullptr)
		return false;

	// Invalid quest id
	if (questID < 0 || questID > playerManager->getTotalPlayerQuests())
		return false;

	// Quest is active or already completed
	if (hasActiveQuestBitSet(questID) || hasCompletedQuestsBitSet(questID))
		return false;

	String parentQuest = playerManager->getPlayerQuestParent(questID);

	// Quest has a parent quest that has not been completed
	if (parentQuest != "") {
		int parentQuestID = playerManager->getPlayerQuestID(parentQuest);

		if (parentQuestID < 0 || !hasCompletedQuestsBitSet(parentQuestID))
			return false;
	}

	return true;
}

void PlayerObjectImplementation::activateQuest(int questID) {
	if (!canActivateQuest(questID)) {
		return;
	}

	CreatureObject* creature = cast<CreatureObject*>(getParent().get().get());

	if (creature == nullptr) {
		return;
	}

	PlayerManager* playerManager = creature->getZoneServer()->getPlayerManager();

	if (playerManager == nullptr) {
		return;
	}

	Reference<QuestInfo*> questInfo = playerManager->getQuestInfo(questID);

	if (questInfo == nullptr) {
		return;
	}

	setActiveQuestsBit(questID, 1);

	if (questInfo->shouldSendSystemMessage())
		creature->sendSystemMessage("@quest/quests:quest_journal_updated");
}

void PlayerObjectImplementation::setActiveQuestsBit(int bitIndex, byte value, bool notifyClient) {
	activeQuests.setBit(bitIndex, value);

	if (!notifyClient)
		return;

	PlayerObjectDeltaMessage8* delta = new PlayerObjectDeltaMessage8(this);
	delta->startUpdate(0x05);
	activeQuests.insertToMessage(delta);
	delta->close();

	sendMessage(delta);
}

void PlayerObjectImplementation::completeQuest(int questID) {
	if (!hasActiveQuestBitSet(questID))
		return;

	CreatureObject* creature = cast<CreatureObject*>(getParent().get().get());

	if (creature == nullptr)
		return;

	PlayerManager* playerManager = creature->getZoneServer()->getPlayerManager();

	if (playerManager == nullptr)
		return;

	Reference<QuestInfo*> questInfo = playerManager->getQuestInfo(questID);

	if (questInfo == nullptr)
		return;

	clearActiveQuestsBit(questID);
	setCompletedQuestsBit(questID, 1);

	if (questInfo->shouldSendSystemMessage())
		creature->sendSystemMessage("@quest/quests:task_complete");
}

void PlayerObjectImplementation::setCompletedQuestsBit(int bitIndex, byte value, bool notifyClient) {
	completedQuests.setBit(bitIndex, value);

	if (!notifyClient) {
		return;
	}

	PlayerObjectDeltaMessage8* delta = new PlayerObjectDeltaMessage8(this);

	delta->startUpdate(0x04);
	completedQuests.insertToMessage(delta);
	delta->close();

	sendMessage(delta);
}

void PlayerObjectImplementation::setPlayerQuestData(uint32 questCrc, PlayerQuestData& data, bool notifyClient) {
	if (notifyClient) {
		PlayerObjectDeltaMessage8* dplay8 = new PlayerObjectDeltaMessage8(this);

		dplay8->startUpdate(0x06);
		playerQuestsData.set(questCrc, data, dplay8, 1);
		dplay8->close();

		sendMessage(dplay8);
	} else {
		playerQuestsData.set(questCrc, data);
	}
}

void PlayerObjectImplementation::clearPlayerQuestData(uint32 questCrc, bool notifyClient) {
	//This works but client has to log out and back in to see the journal update
	if (notifyClient) {
		PlayerObjectDeltaMessage8* dplay8 = new PlayerObjectDeltaMessage8(this);

		dplay8->startUpdate(0x06);
		playerQuestsData.drop(questCrc, dplay8, 1);
		dplay8->close();

		sendMessage(dplay8);
	} else {
		playerQuestsData.drop(questCrc);
	}
}

PlayerQuestData PlayerObjectImplementation::getQuestData(uint32 questCrc) const {
	return playerQuestsData.get(questCrc);
}

int PlayerObjectImplementation::getVendorCount() {
	// Cleanup vendor list before returning the count
	for (int i = ownedVendors.size() - 1; i >= 0; --i) {
		ManagedReference<SceneObject*> vendor = server->getZoneServer()->getObject(ownedVendors.get(i)).get();

		if (vendor == nullptr) {
			ownedVendors.remove(i);
			continue;
		}

		if (vendor->getParent().get() == nullptr)
			vendor->destroyObjectFromDatabase(true);
	}

	return ownedVendors.size();
}

int PlayerObjectImplementation::getCharacterAgeInDays() {
	ManagedReference<CreatureObject*> creature = dynamic_cast<CreatureObject*>(parent.get().get());

	PlayerManager* playerManager = creature->getZoneServer()->getPlayerManager();

	if (account == nullptr) {
		return 0;
	}

	Reference<CharacterList*> list = account->getCharacterList();
	if (list == nullptr) {
		return 0;
	}

	Time currentTime;
	Time age;

	for (int i = 0; i < list->size(); i++) {
		CharacterListEntry entry = list->get(i);
		if (entry.getObjectID() == creature->getObjectID() && entry.getGalaxyID() == creature->getZoneServer()->getGalaxyID()) {
			age = entry.getCreationDate();
			break;
		}
	}

	uint32 timeDelta = currentTime.getTime() - age.getTime();

	int days = timeDelta / 60 / 60 / 24;

	return days;
}

int PlayerObjectImplementation::getBirthDate() {
	if (birthDate > 0)
		return birthDate;

	ManagedReference<CreatureObject*> creature = dynamic_cast<CreatureObject*>(parent.get().get());

	PlayerManager* playerManager = creature->getZoneServer()->getPlayerManager();

	if (account == nullptr) {
		return 0;
	}

	Reference<CharacterList*> list = account->getCharacterList();

	if (list == nullptr) {
		return 0;
	}

	Time currentTime;
	Time age;

	for (int i = 0; i < list->size(); i++) {
		CharacterListEntry entry = list->get(i);
		if (entry.getObjectID() == creature->getObjectID() && entry.getGalaxyID() == creature->getZoneServer()->getGalaxyID()) {
			age = entry.getCreationDate();
			break;
		}
	}

	uint32 timeDelta = currentTime.getTime() - age.getTime();
	setBirthDate(timeDelta);

	return birthDate;
}

bool PlayerObjectImplementation::hasEventPerk(const String& templatePath) const {
	ZoneServer* zoneServer = server->getZoneServer();
	ManagedReference<SceneObject*> eventPerk = nullptr;

	for (int i = 0; i < currentEventPerks.size(); i++) {
		uint64 perkID = currentEventPerks.get(i);
		eventPerk = zoneServer->getObject(perkID);

		if (eventPerk != nullptr && eventPerk->getObjectTemplate()->getFullTemplateString().indexOf(templatePath) != -1)
			return true;
	}

	return false;
}

void PlayerObjectImplementation::doFieldFactionChange(int newStatus) {
	Reference<CreatureObject*> parent = getParent().get().castTo<CreatureObject*>();

	if (parent == nullptr)
		return;

	int curStatus = parent->getFactionStatus();

	if (curStatus == FactionStatus::OVERT || curStatus == newStatus)
		return;

	if (parent->getFutureFactionStatus() != -1)
		return;

	if (hasSuiBoxWindowType(SuiWindowType::FIELD_FACTION_CHANGE))
		closeSuiWindowType(SuiWindowType::FIELD_FACTION_CHANGE);

	ManagedReference<SuiInputBox*> inputbox = new SuiInputBox(parent, SuiWindowType::FIELD_FACTION_CHANGE);
	inputbox->setCallback(new FieldFactionChangeSuiCallback(server->getZoneServer(), newStatus));
	inputbox->setPromptTitle("@gcw:gcw_status_change"); // GCW STATUS CHANGE CONFIRMATION
	inputbox->setUsingObject(asPlayerObject());
	inputbox->setCancelButton(true, "@cancel");

	if (newStatus == FactionStatus::COVERT) {
		inputbox->setPromptText("@gcw:gcw_status_change_covert"); // You are changing your GCW Status to 'Combatant'. This transition will take 30 seconds. It will allow you to attack and be attacked by enemy NPC's. Type YES in this box to confirm the change.
	} else if (newStatus == FactionStatus::OVERT) {
		inputbox->setPromptText("@gcw:gcw_status_change_overt"); // You are changing your GCW Status to 'Special Forces'. This transition will take 5 minutes. It will allow you to attack and be attacked by hostile players and NPC's.Type YES in this box to confirm the change.
	}

	addSuiBox(inputbox);
	parent->sendMessage(inputbox->generateMessage());
}

bool PlayerObjectImplementation::isIgnoring(const String& name) const {
	String nameLower = name.toLowerCase();
	return !nameLower.isEmpty() && ignoreList.contains(nameLower);
}

void PlayerObjectImplementation::checkAndShowTOS() {
	if (getAcceptedTOSVersion() >= ConfigManager::instance()->getTermsOfServiceVersion())
		return;

	const String& tosText = ConfigManager::instance()->getTermsOfService();
	if (tosText.length() == 0)
		return;

	CreatureObject* creature = dynamic_cast<CreatureObject*>(parent.get().get());
	if (creature == nullptr)
		return;

	ManagedReference<SuiMessageBox*> box = new SuiMessageBox(creature, SuiWindowType::NONE);
	box->setPromptTitle("Terms Of Service");
	box->setPromptText(tosText);
	box->setForceCloseDisabled();
	box->setCancelButton(true, "@cancel");
	box->setCallback(new LambdaSuiCallback([](server::zone::objects::creature::CreatureObject* player, SuiBox* suiBox, uint32 eventIndex, Vector<UnicodeString>* args) -> void {
		ManagedReference<PlayerObject*> ghost = player->getPlayerObject();
		if (ghost == nullptr)
			return;

		if (eventIndex == 0)
			ghost->setAcceptedTOSVersion(ConfigManager::instance()->getTermsOfServiceVersion());
		else
			ghost->checkAndShowTOS();
	}, getZoneServer(), "TosCallback"));

	addSuiBox(box);
	creature->sendMessage(box->generateMessage());
}

void PlayerObjectImplementation::recalculateForcePower() {
	ManagedReference<SceneObject*> parent = getParent().get();

	if (parent == nullptr) {
		return;
	}

	CreatureObject* player = parent->asCreatureObject();

	if (player == nullptr) {
		return;
	}

	int maxForce = player->getSkillMod("jedi_force_power_max");

	int forcePowerMod = 0, forceControlMod = 0;

	if (player->hasSkill("force_rank_light_novice")) {
		forcePowerMod = player->getSkillMod("force_power_light");
		forceControlMod = player->getSkillMod("force_control_light");
	} else if (player->hasSkill("force_rank_dark_novice")) {
		forcePowerMod = player->getSkillMod("force_power_dark");
		forceControlMod = player->getSkillMod("force_control_dark");
	}

	maxForce += (forcePowerMod + forceControlMod) * 10;

	setForcePowerMax(maxForce, true);
}

bool PlayerObjectImplementation::isInPvpArea(bool checkTimer) {
	ManagedReference<CreatureObject*> creature = dynamic_cast<CreatureObject*>(parent.get().get());

	if (creature == nullptr || creature->isInvisible()) {
		return false;
	}

	if (checkTimer && !lastPvpAreaCombatActionTimestamp.isPast())
		return true;

	SortedVector<ManagedReference<ActiveArea* > > areas = *creature->getActiveAreas();

	for (int i = 0; i < areas.size(); ++i) {
		ManagedReference<ActiveArea*>& area = areas.get(i);

		if (area != nullptr && area->isPvpArea()) {
			return true;
		}
	}

	return false;
}

String PlayerObjectImplementation::getMiliSecsTimeString(uint64 miliSecs, bool verbose) const {
	uint64 ss = miliSecs / 1000;

	int dd = ss / 86400;
	ss = ss - (dd * 86400);

	int hh = ss / 3600;
	ss = ss - (hh * 3600);

	int mm = ss / 60;
	ss = ss - (mm * 60);

	StringBuffer buf;

	if (verbose) {
		if (dd > 0)
			buf << " " << dd << (dd == 1 ? " day," : " days,");

		if (dd > 0 || hh > 0)
			buf << " " << hh << (hh == 1 ? " hour," : " hours,");

		if (dd > 0 || hh > 0 || mm > 0)
			buf << " " << mm << (mm == 1 ? " minute," : " minutes,");

		buf << " " << ss << (ss == 1 ? " second" : " seconds");
	} else {
		if (dd > 0)
			buf << " " << dd << "d";

		if (dd > 0 || hh > 0)
			buf << " " << hh << "h";

		if (dd > 0 || hh > 0 || mm > 0)
			buf << " " << mm << "m";

		buf << " " << ss << "s";
	}

	return buf.toString();
}

String PlayerObjectImplementation::getPlayedTimeString(bool verbose) const {
	StringBuffer buf;

	if (verbose) {
		buf << "You have played this character a total of";
		buf << getMiliSecsTimeString(miliSecsPlayed, true);
		buf << ", and ";
		buf << getMiliSecsTimeString(miliSecsSession, true);
		buf << " this session.";
	} else {
		buf << "played:";
		buf << getMiliSecsTimeString(miliSecsPlayed, false);
		buf << ", session:";
		buf << getMiliSecsTimeString(miliSecsSession, false);
	}

	return buf.toString();
}

void PlayerObjectImplementation::createHelperDroid() {
	// Only spawn droid if character is less than 1 days old
	if (getCharacterAgeInDays() >= 1 || isPrivileged())
		return;

	CreatureObject* player = dynamic_cast<CreatureObject*>(parent.get().get());

	if (player == nullptr)
		return;

	Zone* zone = player->getZone();

	if (zone == nullptr || zone->getZoneName() == "tutorial")
		return;

	Reference<Task*> createDroid = new SpawnHelperDroidTask(player);
	createDroid->schedule(5000);
}
