local ObjectManager = require("managers.object.object_manager")
local SpawnMobiles = require("utils.spawn_mobiles")
local Logger = require("utils.logger")

EncounterVader = Encounter:new {
  taskName = "EncounterVader",
  -- Encounter properties
  encounterDespawnTime = 2 * 60 * 1000,
  spawnObjectList = {
    { template = "encounter_vader", minimumDistance = 96, maximumDistance = 128, referencePoint = 0, followPlayer = true, setNotAttackable = false, runOnDespawn = true },
    { template = "encounter_stormtrooper", minimumDistance = 2, maximumDistance = 4, referencePoint = 1, followPlayer = true, setNotAttackable = false, runOnDespawn = true },
    { template = "encounter_stormtrooper", minimumDistance = 2, maximumDistance = 4, referencePoint = 2, followPlayer = true, setNotAttackable = false, runOnDespawn = true },
    { template = "encounter_stormtrooper", minimumDistance = 2, maximumDistance = 4, referencePoint = 3, followPlayer = true, setNotAttackable = false, runOnDespawn = true },
    { template = "encounter_stormtrooper", minimumDistance = 2, maximumDistance = 4, referencePoint = 4, followPlayer = true, setNotAttackable = false, runOnDespawn = true },
    { template = "encounter_stormtrooper", minimumDistance = 2, maximumDistance = 4, referencePoint = 5, followPlayer = true, setNotAttackable = false, runOnDespawn = true },
    { template = "encounter_stormtrooper", minimumDistance = 2, maximumDistance = 4, referencePoint = 6, followPlayer = true, setNotAttackable = false, runOnDespawn = true },
    { template = "encounter_stormtrooper", minimumDistance = 2, maximumDistance = 4, referencePoint = 7, followPlayer = true, setNotAttackable = false, runOnDespawn = true },
    { template = "encounter_stormtrooper", minimumDistance = 2, maximumDistance = 4, referencePoint = 8, followPlayer = true, setNotAttackable = false, runOnDespawn = true },
  },
  onEncounterSpawned = nil,
  isEncounterFinished = nil,
  onEncounterInRange = nil,
  inRangeValue = 26,
}

function EncounterVader:isTheFirstMobOfThePlayer(pMob, pPlayer)
  local spawnedMobiles = SpawnMobiles.getSpawnedMobiles(pPlayer, self.taskName)
  return spawnedMobiles ~= nil and spawnedMobiles[1] ~= nil and CreatureObject(spawnedMobiles[1]):getObjectID() == CreatureObject(pMob):getObjectID()
end

function EncounterVader:onPlayerKilled(pPlayer, pKiller, nothing)
  if (pPlayer == nil or pKiller == nil) then
    return 0
  end

  Logger:log("Player was killed.", LT_INFO)
  if SpawnMobiles.isFromSpawn(pPlayer, EncounterVader.taskName, pKiller) then
    -- spatialChat(pKiller, "")
    JediEncounters:startStepDelay(pPlayer, 1)
    createEvent(10 * 1000, "EncounterVader", "handleDespawnEvent", pPlayer, "")
		return 1
  end

  return 0
end

function EncounterVader:onEncounterSpawned(pPlayer, spawnedObjects)
  if (pPlayer == nil or spawnedObjects == nil or spawnedObjects[1] == nil) then
    return
  end

  createObserver(OBJECTDESTRUCTION, self.taskName, "onPlayerKilled", pPlayer)

  local playerID = SceneObject(pPlayer):getObjectID()
  for i = 1, #spawnedObjects, 1 do
    local pMob = spawnedObjects[i]
    if (pMob ~= nil and SceneObject(pMob):isCreatureObject()) then
      writeData(SceneObject(pMob):getObjectID() .. ":encounterOwner", playerID)
      createObserver(OBJECTDESTRUCTION, self.taskName, "onMobDestroyed", pMob)
    end
  end
end

function EncounterVader:onEncounterInRange(pPlayer, spawnedObjects)
  if (pPlayer == nil or spawnedObjects == nil or spawnedObjects[1] == nil) then
    return
  end

  foreach(spawnedObjects, function(pMobile)
    if (pMobile ~= nil) then
      AiAgent(pMobile):removeObjectFlag(AI_ESCORT)
      AiAgent(pMobile):removeObjectFlag(AI_FOLLOW)

      AiAgent(pMobile):setAITemplate()

      AiAgent(pMobile):addDefender(pPlayer)
    end
  end)
end

function EncounterVader:onMobDestroyed(pVictim, pAttacker)
  if (pVictim == nil) then
    return 0
  end

  local victimID = SceneObject(pVictim):getObjectID()
  local ownerID = readData(victimID .. ":encounterOwner")
  if (ownerID == nil or ownerID == 0) then
    return 0
  end

  local pPlayer = getCreatureObject(ownerID)
  if (pPlayer == nil) then
    return 0
  end

  local spawned = SpawnMobiles.getSpawnedMobiles(pPlayer, self.taskName)
  if (spawned == nil) then
    return 1
  end

  for i = 1, #spawned, 1 do
    local p = spawned[i]
    if SpawnMobiles.isValidMobile(p) and not CreatureObject(p):isDead() then
      return 1
    end
  end
  JediEncounters:startStepDelay(pPlayer, 5)
  -- createEvent(1000, self.taskName, "handleDespawnEvent", pPlayer, "")
  return 1
end

function EncounterVader:isEncounterFinished(pPlayer)
  if (pPlayer == nil) then
    return false
  end

  return false
end

function EncounterVader:taskFinish(pPlayer)
  if (pPlayer == nil) then
    return true
  end

  return true
end

return EncounterVader