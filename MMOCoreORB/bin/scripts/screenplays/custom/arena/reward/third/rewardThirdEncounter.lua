local ObjectManager = require("managers.object.object_manager")
local SpawnMobiles = require("utils.spawn_mobiles")
local Logger = require("utils.logger")

local INVITE_DESPAWN_TIME = 10 * 1000;

RewardThirdEncounter = Encounter:new {
    taskName = "RewardThirdEncounter",
   	encounterDespawnTime = 5 * 60 * 1000,
    spawnObjectList = {
        { template = "reward_third", minimumDistance = 64, maximumDistance = 96, referencePoint = 0, followPlayer = true, setNotAttackable = true, runOnDespawn = true }
	},
	onEncounterSpawned = nil,
	isEncounterFinished = nil,
	onEncounterInRange = nil,
	inRangeValue = 16,
}

function RewardThirdEncounter:onEncounterInRange(pPlayer, mobilePointerList)
	if (pPlayer == nil or mobilePointerList == nil or mobilePointerList[1] == nil) then
		return
	end

	spatialChat(mobilePointerList[1], CreatureObject(pPlayer):getFirstName() .. ", a word.")
end

function RewardThirdEncounter:handleScheduledDespawn(pPlayer)
	if (pPlayer == nil) then
		return
	end

	self:handleDespawnEvent(pPlayer)
end

function RewardThirdEncounter:scheduleDespawnOfInviter(pPlayer)
	if (pPlayer == nil) then
		return
	end

	createEvent(INVITE_DESPAWN_TIME, "RewardThirdEncounter", "handleScheduledDespawn", pPlayer, "")
end

function RewardThirdEncounter:doesRewarderBelongToThePlayer(pPlayer, pMobile)
	if (pPlayer == nil or pMobile == nil) then
		return false
	end

	local playerInviter = SpawnMobiles.getSpawnedMobiles(pPlayer, RewardThirdEncounter.taskName)

	if playerInviter ~= nil and playerInviter[1] ~= nil and #playerInviter == 1 then
		return SceneObject(pMobile):getObjectID() == SceneObject(playerInviter[1]):getObjectID()
	else
		return false
	end
end

function RewardThirdEncounter:isEncounterFinished(pPlayer)
  if (pPlayer == nil) then
    return true
  end

  return false
end

function RewardThirdEncounter:taskFinish(pPlayer)
	if (pPlayer == nil) then
		return true
	end
	
    return true
end

return RewardThirdEncounter