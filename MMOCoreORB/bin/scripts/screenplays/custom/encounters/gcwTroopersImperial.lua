local ObjectManager = require("managers.object.object_manager")
local SpawnMobiles = require("utils.spawn_mobiles")
local Logger = require("utils.logger")

EncounterGCWTroopersImperial = Encounter:new {
  taskName = "EncounterGCWTroopersImperial",
  -- Encounter properties
  encounterDespawnTime = 2 * 60 * 1000,
  spawnObjectList = {
    { template = "fbase_rebel_colonel_hard", minimumDistance = 32, maximumDistance = 64, referencePoint = 0, followPlayer = true, setNotAttackable = false, runOnDespawn = true },
    { template = "fbase_rebel_guardsman_hard", minimumDistance = 2, maximumDistance = 4, referencePoint = 1, followPlayer = true, setNotAttackable = false, runOnDespawn = true },
    { template = "fbase_rebel_guardsman_hard", minimumDistance = 2, maximumDistance = 4, referencePoint = 2, followPlayer = true, setNotAttackable = false, runOnDespawn = true },
    { template = "fbase_rebel_guardsman_hard", minimumDistance = 2, maximumDistance = 4, referencePoint = 3, followPlayer = true, setNotAttackable = false, runOnDespawn = true },
    { template = "fbase_rebel_guardsman_hard", minimumDistance = 2, maximumDistance = 4, referencePoint = 4, followPlayer = true, setNotAttackable = false, runOnDespawn = true },
  },
  onEncounterSpawned = nil,
  isEncounterFinished = nil,
  onEncounterInRange = nil,
  inRangeValue = 26,
}

function EncounterGCWTroopersImperial:isTheFirstMobOfThePlayer(pMob, pPlayer)
  local spawnedMobiles = SpawnMobiles.getSpawnedMobiles(pPlayer, self.taskName)
  return spawnedMobiles ~= nil and spawnedMobiles[1] ~= nil and CreatureObject(spawnedMobiles[1]):getObjectID() == CreatureObject(pMob):getObjectID()
end

function EncounterGCWTroopersImperial:onPlayerKilled(pPlayer, pKiller, nothing)
  if (pPlayer == nil or pKiller == nil) then
    return 0
  end

  Logger:log("Player was killed.", LT_INFO)
  if SpawnMobiles.isFromSpawn(pPlayer, EncounterGCWTroopersImperial.taskName, pKiller) then
    -- spatialChat(pKiller, "")
    createEvent(10 * 1000, "EncounterGCWTroopersImperial", "handleDespawnEvent", pPlayer, "")
    GCWEncounters:startStepDelay(pPlayer, 1)
    return 1
  end

  return 0
end

function EncounterGCWTroopersImperial:onEncounterSpawned(pPlayer, spawnedObjects)
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

function EncounterGCWTroopersImperial:onEncounterInRange(pPlayer, spawnedObjects)
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

function EncounterGCWTroopersImperial:onMobDestroyed(pVictim, pAttacker)
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

  createEvent(1000, self.taskName, "handleDespawnEvent", pPlayer, "")
  return 1
end

function EncounterGCWTroopersImperial:isEncounterFinished(pPlayer)
  if (pPlayer == nil) then
    return false
  end

  return false
end

function EncounterGCWTroopersImperial:taskFinish(pPlayer)
  if (pPlayer == nil) then
    return true
  end

  GCWEncounters:startStepDelay(pPlayer, 3)
  return true
end

return EncounterGCWTroopersImperial