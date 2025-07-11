/*
 * SurveySessionImplementation.cpp
 *
 *  Created on: May 22, 2012
 *      Author: Kyle
 */

#include "server/zone/objects/player/sessions/survey/SurveySession.h"
#include "server/zone/Zone.h"
#include "server/zone/managers/resource/ResourceManager.h"
#include "server/zone/objects/creature/CreatureObject.h"
#include "server/zone/objects/player/PlayerObject.h"
#include "server/zone/objects/tangible/tool/SurveyTool.h"
#include "server/zone/packets/scene/PlayClientEffectLocMessage.h"
#include "templates/params/creature/CreatureAttribute.h"
#include "server/zone/objects/player/sessions/survey/sui/SurveyGMinigameSuiCallback.h"
#include "server/zone/objects/player/sessions/survey/sui/SurveyCMinigameSuiCallback.h"
#include "server/zone/managers/resource/resourcespawner/SampleTask.h"
#include "server/zone/managers/resource/resourcespawner/SurveyTask.h"
#include "server/zone/managers/resource/resourcespawner/SampleResultsTask.h"

int SurveySessionImplementation::initializeSession(SurveyTool* tool) {
	activeSurveyTool = tool;

	return startSession();
}

int SurveySessionImplementation::startSession() {
	ManagedReference<SurveyTool*> activeSurveyTool = this->activeSurveyTool.get();
	ManagedReference<CreatureObject*> surveyer = this->surveyer.get();

	if (surveyer == nullptr || activeSurveyTool == nullptr) {
		cancelSession();
		return false;
	}

	resourceManager = surveyer->getZoneServer()->getResourceManager();
	if (resourceManager.get() == nullptr) {
		cancelSession();
		return false;
	}

	surveyer->addActiveSession(SessionFacadeType::SURVEY, _this.getReferenceUnsafeStaticCast());

	return true;
}

int SurveySessionImplementation::cancelSession() {
	ManagedReference<CreatureObject*> ref = surveyer.get();

	if (ref != nullptr)
		ref->dropActiveSession(SessionFacadeType::SURVEY);


	return clearSession();
}

int SurveySessionImplementation::clearSession() {

	return 0;
}

void SurveySessionImplementation::startSurvey(const String& resname) {
	ManagedReference<SurveyTool*> activeSurveyTool = this->activeSurveyTool.get();
	ManagedReference<ResourceManager*> resourceManager = this->resourceManager.get();
	ManagedReference<CreatureObject*> surveyer = this->surveyer.get();

	if (activeSurveyTool == nullptr) {
		error("surveyTool is nullptr");
		return;
	}

	if (resourceManager == nullptr) {
		error("ResourceManager is nullptr");
		return;
	}

	if (surveyer == nullptr) {
		error("surveyer is nullptr");
		return;
	}

	if (surveyer->getParent() != nullptr && surveyer->getParent().get()->isCellObject()) {
		surveyer->sendSystemMessage("@error_message:survey_in_structure"); //You cannot perform survey-related actions inside a structure.
		return;
	}

	// if (surveyer->isSwimming()) {
	// 	surveyer->sendSystemMessage("@error_message:survey_swimming");
	// 	return;
	// }

	if (surveyer->isRidingMount()) {
		if (surveyer->isInWater()) {
			surveyer->sendSystemMessage("@error_message:survey_cant");
			return;
		}
	} else {
		if (surveyer->getPosture() != CreaturePosture::UPRIGHT) {
			surveyer->sendSystemMessage("@error_message:survey_standing");
			return;
		}
	}

	//Get actual cost based upon player's Focus
	int mindCost = 100 - (int)(surveyer->getHAM(CreatureAttribute::FOCUS)/15.f);
	mindCost = 0;

	if (surveyer->getHAM(CreatureAttribute::MIND) < mindCost) {
		surveyer->setPosture(CreaturePosture::UPRIGHT, true);
		surveyer->sendSystemMessage("@error_message:survey_mind"); //You are exhausted. You nee to clear your head before you can survey again.
		return;
	}

	ManagedReference<ResourceSpawn*> spawn = resourceManager->getResourceSpawn(resname);
	if (spawn == nullptr) {
		return;
	}

	if (spawn->getSurveyToolType() != activeSurveyTool->getToolType() && !(activeSurveyTool->getToolType() == SurveyTool::INORGANIC && spawn->isType("inorganic"))) {
		StringIdChatParameter message("@survey:wrong_tool"); // %TO resources cannot be located with this tool
		message.setTO(spawn->getFinalClass());
		surveyer->sendSystemMessage(message);
		return;
	}

	PlayClientEffectLoc* effect = new PlayClientEffectLoc(activeSurveyTool->getSurveyAnimation(),
			surveyer->getZone()->getZoneName(),
			surveyer->getPositionX(), surveyer->getPositionZ(),
			surveyer->getPositionY());

	surveyer->broadcastMessage(effect, true);

	resourceManager->sendSurvey(surveyer, resname);
}

void SurveySessionImplementation::startSample(const String& resname) {
	ManagedReference<SurveyTool*> activeSurveyTool = this->activeSurveyTool.get();
	ManagedReference<ResourceManager*> resourceManager = this->resourceManager.get();
	ManagedReference<CreatureObject*> surveyer = this->surveyer.get();

	if (activeSurveyTool == nullptr) {
		error("surveyTool is nullptr");
		return;
	}

	if (resourceManager == nullptr) {
		info("ResourceManager is nullptr");
		return;
	}

	if (surveyer == nullptr) {
		info("surveyer is nullptr");
		return;
	}

	Reference<PlayerObject*> ghost = surveyer->getPlayerObject();
	if (ghost == nullptr)
		return;

	if (!resname.isEmpty())
		 lastResourceSampleName = resname;

	ManagedReference<ResourceSpawn* > resourceSpawn = resourceManager->getResourceSpawn(lastResourceSampleName);
	if (resourceSpawn == nullptr) {
		return;
	}

	if (surveyer->isInCombat()) {
		surveyer->sendSystemMessage("@survey:sample_cancel_attack"); //You can't take samples while under attack!
		return;
	}

	if (surveyer->getParent() != nullptr && surveyer->getParent().get()->isCellObject()) {
		surveyer->sendSystemMessage("@error_message:survey_in_structure"); //You cannot perform survey-related actions inside a structure.
		return;
	}

	if (surveyer->isSwimming() || (surveyer->isRidingMount() && surveyer->isInWater())) {
		surveyer->sendSystemMessage("@error_message:survey_swimming");
		return;
	}

	// Force dismount from creature pets
	if (surveyer->isRidingMount()) {
		surveyer->executeObjectControllerAction(STRING_HASHCODE("dismount"));
	}

	// Verify dismount was successful
	if (surveyer->isRidingMount()) {
		surveyer->sendSystemMessage("@error_message:survey_on_mount"); // "You cannot perform that action while mounted on a creature or driving a vehicle."
		return;
	}

	//Get actual cost based upon player's Quickness
	int actionCost = 124 - (int)(surveyer->getHAM(CreatureAttribute::QUICKNESS)/12.5f);

	actionCost = actionCost /= 2;

	if (surveyer->getHAM(CreatureAttribute::ACTION) < actionCost) {
		surveyer->setPosture(CreaturePosture::UPRIGHT, true);
		surveyer->sendSystemMessage("@error_message:sample_mind"); //You are exhausted. You need to clear your head before you can sample again.
		return;
	}

	if (resourceSpawn->getSurveyToolType() != activeSurveyTool->getToolType() && !(activeSurveyTool->getToolType() == SurveyTool::INORGANIC && resourceSpawn->isType("inorganic"))) {
		StringIdChatParameter message("@survey:wrong_tool"); // %TO resources cannot be located with this tool
		message.setTO(resourceSpawn->getFinalClass());
		surveyer->sendSystemMessage(message);
		return;
	}

	if (!lastResourceSampleName.isEmpty() && !activeSurveyTool->canSampleRadioactive()) {

		if (resourceSpawn->isType("radioactive") && !activeSurveyTool->canSampleRadioactive()) {
			activeSurveyTool->sendRadioactiveWarning(surveyer);
			return;
		}
	}

	// Player must be kneeling to sample
	if (!surveyer->isKneeling() ) {
		surveyer->setPosture(CreaturePosture::CROUCHED, true);
	}

	if (surveyer->getPendingTask("sample") != nullptr) {
		return;
	}

	StringIdChatParameter message("survey","start_sampling");
	message.setTO(lastResourceSampleName);
	surveyer->sendSystemMessage(message);

	if (!lastResourceSampleName.isEmpty()) {
		resourceManager->sendSample(surveyer, lastResourceSampleName, activeSurveyTool->getSampleAnimation());
	}

	// if (!doGamble && richSampleLocation.getPosition() == Vector3(0, 0, 0) && System::random(50) == 7) {

	// 	if (ghost->hasSuiBoxWindowType(SuiWindowType::SURVEY_TOOL_CONCENTRATED_MINIGAME)) {
	// 		ghost->removeSuiBoxType(SuiWindowType::SURVEY_TOOL_CONCENTRATED_MINIGAME);
	// 	}

	// 	if (ghost->hasSuiBoxWindowType(SuiWindowType::SURVEY_TOOL_CONCENTRATED_MINIGAME2)) {
	// 		ghost->removeSuiBoxType(SuiWindowType::SURVEY_TOOL_CONCENTRATED_MINIGAME2);
	// 	}

	// 	if (System::random(1) == 1)
	// 		surveyCnodeMinigameSui();
	// 	else
	// 		surveyGnodeMinigameSui();

	// } else {

	// 	if (!lastResourceSampleName.isEmpty())
	// 		resourceManager->sendSample(surveyer, lastResourceSampleName,
	// 				activeSurveyTool->getSampleAnimation());
	// }
}

void SurveySessionImplementation::surveyCnodeMinigameSui() {
	ManagedReference<CreatureObject*> surveyer = this->surveyer.get();

	//int surveyMod = surveyer->getSkillMod("surveying");

	ManagedReference<SuiListBox*> suiConcMinigameBox = new SuiListBox(
			surveyer, SuiWindowType::SURVEY_TOOL_CONCENTRATED_MINIGAME, 0);

	suiConcMinigameBox->setPromptTitle("@survey:cnode_t");
	suiConcMinigameBox->setPromptText("@survey:cnode_d");

	suiConcMinigameBox->addMenuItem("@survey:cnode_1", 0);
	suiConcMinigameBox->addMenuItem("@survey:cnode_2", 1);

	suiConcMinigameBox->setCancelButton(true, "Cancel");

	suiConcMinigameBox->setCallback(new SurveyCMinigameSuiCallback(surveyer->getZoneServer()));
	surveyer->getPlayerObject()->addSuiBox(suiConcMinigameBox);
	surveyer->sendMessage(suiConcMinigameBox->generateMessage());
}

void SurveySessionImplementation::surveyCnodeMinigame(int value) {
	ManagedReference<CreatureObject*> surveyer = this->surveyer.get();

	if (surveyer == nullptr)
		return;

	Reference<PlayerObject*> ghost = surveyer->getPlayerObject();
	if (ghost == nullptr)
		return;

	if (value == 0) {
		// Add sampletask
		rescheduleSample();

		return;
	}

	richSampleLocation = Coordinate(surveyer->getPositionX(), surveyer->getPositionZ(), surveyer->getPositionY());
	richSampleLocation.randomizePosition(100.f, 50.f);

	// Get previous survey waypoint
	ManagedReference<WaypointObject*> waypoint = ghost->getSurveyWaypoint();

	// Create new waypoint
	if (waypoint == nullptr)
		waypoint = ( surveyer->getZoneServer()->createObject(0xc456e788, 1)).castTo<WaypointObject*>();

	Locker locker(waypoint);

	// Update new waypoint
	waypoint->setCustomObjectName(UnicodeString("Resource Survey"), false);
	waypoint->setPlanetCRC(surveyer->getZone()->getZoneCRC());
	waypoint->setPosition(richSampleLocation.getPositionX(), 0, richSampleLocation.getPositionY());
	waypoint->setColor(WaypointObject::COLOR_BLUE);
	waypoint->setSpecialTypeID(WaypointObject::SPECIALTYPE_RESOURCE);
	waypoint->setActive(true);

	ghost->addWaypoint(waypoint, true, true);

	surveyer->sendSystemMessage("@survey:node_waypoint");

	// Player must be kneeling to sample
	if (!surveyer->isStanding() )
		surveyer->setPosture(CreaturePosture::UPRIGHT, true);
}

void SurveySessionImplementation::surveyGnodeMinigameSui() {
	ManagedReference<CreatureObject*> surveyer = this->surveyer.get();

	//int surveyMod = surveyer->getSkillMod("surveying");

	ManagedReference<SuiListBox*> suiConcMinigameBox = new SuiListBox(surveyer, SuiWindowType::SURVEY_TOOL_CONCENTRATED_MINIGAME2, 0);

	suiConcMinigameBox->setPromptTitle("@survey:gnode_t");
	suiConcMinigameBox->setPromptText("@survey:gnode_d");

	suiConcMinigameBox->addMenuItem("@survey:gnode_1", 0);
	suiConcMinigameBox->addMenuItem("@survey:gnode_2", 1);

	suiConcMinigameBox->setCancelButton(true, "Cancel");

	suiConcMinigameBox->setCallback(new SurveyGMinigameSuiCallback(surveyer->getZoneServer()));
	surveyer->getPlayerObject()->addSuiBox(suiConcMinigameBox);
	surveyer->sendMessage(suiConcMinigameBox->generateMessage());
}

void SurveySessionImplementation::surveyGnodeMinigame(int value) {
	ManagedReference<CreatureObject*> surveyer = this->surveyer.get();

	if (surveyer == nullptr)
		return;

	if (value == 1) {

		if (surveyer->getHAM(CreatureAttribute::ACTION) < 300) {
			surveyer->sendSystemMessage("@survey:gamble_no_action");
			return;
		}

		surveyer->inflictDamage(surveyer, CreatureAttribute::ACTION, 300, false, true);
		doGamble = true;
	}

	rescheduleSample();
}

void SurveySessionImplementation::rescheduleSurvey(SurveyMessage* surveyMessage, WaypointObject* waypoint, float maxDensity, ResourceSpawn* resourceSpawn) {
	ManagedReference<CreatureObject*> surveyer = this->surveyer.get();

	if (surveyer == nullptr)
		return;

	surveyTask = new SurveyTask(surveyer, surveyMessage, waypoint, maxDensity * 100, resourceSpawn);
	surveyer->addPendingTask("survey", surveyTask, 3000);
}

void SurveySessionImplementation::rescheduleSample() {
	ManagedReference<CreatureObject*> surveyer = this->surveyer.get();

	if (surveyer == nullptr)
		return;

	// Add sampletask
	if (sampleTask == nullptr)
		sampleTask = new SampleTask(surveyer, activeSurveyTool.get());

	if (surveyer->getPendingTask("sample") == nullptr)
		surveyer->addPendingTask("sample", sampleTask, 25000);
}

void SurveySessionImplementation::rescheduleSampleResults(const ResourceSpawner* resourceSpawner, float density, const String& resname) {
	ManagedReference<CreatureObject*> surveyer = this->surveyer.get();

	if (surveyer == nullptr)
		return;

	// Add sampleresultstask
	if (surveyer->getPendingTask("sampleresults") == nullptr) {
		sampleResultsTask = new SampleResultsTask(surveyer, resourceSpawner, density, resname);
		surveyer->addPendingTask("sampleresults", sampleResultsTask, 3000);
	}
}

