local ObjectManager = require("managers.object.object_manager")
local Logger = require("utils.logger")

ShadowsGuardDetailScreenPlay = ScreenPlay:new {
  numberOfActs = 1,
}

registerScreenPlay("ShadowsGuardDetailScreenPlay", true)

function ShadowsGuardDetailScreenPlay:start()

end

function ShadowsGuardDetailScreenPlay:boxLootedShadowsGuardDetail(pSceneObject, pPlayer)
  if (not CreatureObject(pPlayer):hasScreenPlayState(2, "shadows_two") and CreatureObject(pPlayer):hasScreenPlayState(1, "shadows_two")) then
    CreatureObject(pPlayer):setScreenPlayState(2, "shadows_two")
    CreatureObject(pPlayer):sendSystemMessage("You find an encrypted transmission disk, with instruction to seek out \\#FFFF00\\Konlan Voss \\#FFFFFF\\in \\#FFFF00\\Nashal Cantina")
  end

  local pGhost = CreatureObject(pPlayer):getPlayerObject()
  local playerID = SceneObject(pPlayer):getObjectID()
  local oldWaypointID = tonumber(getQuestStatus(playerID .. ":shadowsGuardDetailWaypointID"))
  if (oldWaypointID ~= 0) then
    PlayerObject(pGhost):removeWaypoint(oldWaypointID, true)
    removeQuestStatus(playerID .. ":shadowsGuardDetailWaypointID")
  end
end

