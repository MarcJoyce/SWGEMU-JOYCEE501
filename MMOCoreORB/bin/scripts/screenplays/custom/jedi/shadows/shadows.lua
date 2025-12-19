local ObjectManager = require("managers.object.object_manager")
local Logger = require("utils.logger")

ShadowsScreenPlay = ScreenPlay:new {}

registerScreenPlay("ShadowsScreenPlay", true)

function ShadowsScreenPlay:start()
  if (isZoneEnabled("yavin4")) then
    self:spawnShadowsTwo()
  end
end

function ShadowsScreenPlay:playerLoggedIn(pPlayer)
  ShadowsIntroTheatre:finish(pPlayer)

  if (not CreatureObject(pPlayer):hasScreenPlayState(2, "shadows_one") and CreatureObject(pPlayer):hasScreenPlayState(1, "shadows_one")) then
    ShadowsIntroTheater:start(pPlayer)
  end

  if (not CreatureObject(pPlayer):hasScreenPlayState(2, "shadows_three") and CreatureObject(pPlayer):hasScreenPlayState(1, "shadows_three")) then
    ShadowsMeetUpTheater:start(pPlayer)
  end

end

function ShadowsScreenPlay:spawnShadowsTwo()
  local spawnedSceneObject = LuaSceneObject(nil)
  local spawnedPointer = spawnSceneObject("yavin4", "object/tangible/container/drum/tatt_drum_1.iff", -335, 11.4, 1044, 0, 257);

  if (spawnedPointer ~= nil) then
    spawnedSceneObject:_setObject(spawnedPointer)
    SceneObject(spawnedPointer):setContainerInheritPermissionsFromParent(false)
	  SceneObject(spawnedPointer):setContainerDefaultDenyPermission(MOVEIN)
	  SceneObject(spawnedPointer):setContainerDefaultAllowPermission(OPEN + MOVEOUT)
    createObserver(OPENCONTAINER, "ShadowsGuardDetailScreenPlay", "boxLootedShadowsGuardDetail", spawnedPointer)
  end
  
  local pMobile = spawnMobile("yavin4", "shadows_exile", 300, -335, 11, 1041, 188, 0)
  AiAgent(pMobile):addObjectFlag(AI_STATIC)
  
  pMobile = spawnMobile("yavin4", "shadows_exile", 300, -337, 11, 1047, 279, 0)
  AiAgent(pMobile):addObjectFlag(AI_STATIC)

  spawnMobile("yavin4", "shadows_guard", 300, -340, 11, 1045, 0, 0)
  spawnMobile("yavin4", "shadows_guard", 300, -340, 11, 1045, 0, 0)
  spawnMobile("yavin4", "shadows_guard", 300, -340, 11, 1045, 0, 0)
end

function ShadowsScreenPlay:spawnSceneObjects()

end

function ShadowsScreenPlay:spawnMobiles()

end

function ShadowsScreenPlay:endShadowsIntroTheatre(pPlayer) 
  local pActiveArea = spawnActiveArea(CreatureObject(pPlayer):getZoneName(), "object/active_area.iff", SceneObject(pPlayer):getWorldPositionX(), 0, SceneObject(pPlayer):getWorldPositionY(), 150, 0)

  if (pActiveArea ~= nil) then
    createObserver(EXITEDAREA, "ShadowsIntroTheatre", "handleExitedMissionAreaEvent", pActiveArea)
  end
end

function ShadowsScreenPlay:startShadowsGuardDetail(pPlayer)
  local pGhost = CreatureObject(pPlayer):getPlayerObject()
  local playerID = SceneObject(pPlayer):getObjectID()
  local waypointID = PlayerObject(pGhost):addWaypoint("yavin4", "Guard Detail", "", -335, 11.4, 1044, WAYPOINT_YELLOW, true, true, 0)
  setQuestStatus(playerID .. ":shadowsGuardDetailWaypointID", waypointID)
end
