Arena = ScreenPlay:new
{
	numberOfActs = 1,
  AdminPlayerID = 281474993547517,
	screenplayName = "Arena",
  playerCooldown = 4 * 60 * 60, -- 4 hours
  -- playerCooldown = 10 * 60, -- 10 minutes
  waveTimer = 45000, -- 45 seconds
  minWaveTimer = 15000, -- 15 seconds
  leaderboardCooldown = 7 * 24 * 60 * 60, -- 7 days
  -- leaderboardCooldown = 30 * 60, -- 30 minutes
  eventName = "ArenaLeaderboard",
  spectatorMoods = {
    "amazed",
    "brave",
    "angry",
    "annoyed",
    "approving",
    "bloodthirsty",
    "callous",
    "careless",
    "cruel",
    "devious",
    "disgusted",
    "enraged",
    "fanatical",
    "joyful",
    "entertained",
  },
  spectatorTemplates = {
    "devaronian_male",
    "chiss_male",
    "chiss_female",
    "ithorian_male",
    "quarren",
    "ishitib_male",
    "bandit",
    "bith_sniper",
    "assassin",
    "gambler",
    "highwayman",
    "outlaw",
    "outrider",
    "pirate_leader",
    "smuggler",
    "terrorist",
    "slicer",
    "warder"
  },
  enemyTemplates = {
    "arena_gladiator_basic",
    "arena_gladiator_basic",
    "arena_gladiator_basic",
    "arena_gladiator_basic",
    "arena_gladiator_elite",
    "arena_gladiator_basic",
    "arena_gladiator_elite",
    "arena_gladiator_basic",
    "arena_gladiator_elite",
    "arena_gladiator_elite",
    "arena_gladiator_elite",
    "arena_gladiator_elite",
    "arena_gladiator_elite",
    "arena_gladiator_master",
    "arena_gladiator_elite",
    "arena_gladiator_master",
    "arena_gladiator_elite",
    "arena_gladiator_master",
  },
}

registerScreenPlay("Arena", true)

function Arena:start()
	if (isZoneEnabled("lok")) then
		self:spawnMobiles()
    self:spawnObjects()
    self:resetArena()
    self:validateEvent()

    local pNpc = spawnMobile("lok", "battle_coordinator", 0, -3042, 66, 500, 0, 0)
    
    CreatureObject(pNpc):setPvpStatusBitmask(0)
    CreatureObject(pNpc):setMoodString("happy")

    local buffTerminal
	end
end

function Arena:validateEvent()
  if (hasServerEvent(self.eventName)) then
    local eventID = getServerEventID(self.eventName)
    local timeLeft = getServerEventTimeLeft(eventID)

    logToFile("Arena: validateEvent - timeLeft is " .. timeLeft, "log/arena/troubleshoot.log")

    if (timeLeft < 0 or timeLeft > self.leaderboardCooldown * 1000) then
      logToFile("Arena: validateEvent - creating event", "log/arena/troubleshoot.log")
      rescheduleServerEvent(self.eventName, 10000)
    end
  else
    logToFile("Arena: validateEvent - event does not exist, creating event", "log/arena/troubleshoot.log")
    createServerEvent(10000, "Arena", "startArenaLeaderboard", self.eventName)
  end
end

function Arena:startArenaLeaderboard()
  local pAdminPlayer = getCreatureObject(self.AdminPlayerID)
  if pAdminPlayer ~= nil then
    local pLeader = Arena:getPosition(1)
    local pSecond = Arena:getPosition(2)
    local pThird = Arena:getPosition(3)
    if (pLeader ~= nil) then 
      logToFile("Arena: Leaderboard - Leader is " .. CreatureObject(pLeader):getFirstName(), "log/arena/troubleshoot.log")
      RewardFirst:startStepDelay(pLeader, 1)
      CreatureObject(pLeader):setScreenPlayState(1, "ArenaRewardFirst")
    end
    if (pSecond ~= nil) then 
      logToFile("Arena: Leaderboard - Second place is " .. CreatureObject(pSecond):getFirstName(), "log/arena/troubleshoot.log")
      RewardSecond:startStepDelay(pSecond, 1)
      CreatureObject(pSecond):setScreenPlayState(1, "ArenaRewardSecond")
    end
    if (pThird ~= nil) then
      logToFile("Arena: Leaderboard - Third place is " .. CreatureObject(pThird):getFirstName(), "log/arena/troubleshoot.log")
      RewardThird:startStepDelay(pThird, 1)
      CreatureObject(pThird):setScreenPlayState(1, "ArenaRewardThird")
    end
    -- Reset leaderboard
    local playersStr =
    readScreenPlayData(pAdminPlayer, "Arena", "players") or ""
    local players = HelperFuncs:split(playersStr, ",")
    for _, id in ipairs(players) do
      local key = "player_" .. id .. "_score"
      deleteScreenPlayData(pAdminPlayer, "Arena", key)
    end
    writeScreenPlayData(pAdminPlayer, "Arena", "players", "")
    logToFile("Arena: Leaderboard has been reset", "log/arena/troubleshoot.log")
  end
  createServerEvent(self.leaderboardCooldown * 1000, "Arena", "startArenaLeaderboard", self.eventName)
end

function Arena:spawnMobiles()
  local count = 0;
  local spectatorMax = 30;
  local spawnY = 475;

  while(spawnY < 530) do
    local template = self.spectatorTemplates[getRandomNumber(1, #self.spectatorTemplates)]
    local spawnX = -3038 + getRandomNumber(0, 2)
    local spawnZ = 66
    local heading = 90 + getRandomNumber(0, 2)

    local pMobile = spawnMobile("lok", template, 0, spawnX, spawnZ, spawnY, heading, 0)
    
    if pMobile ~= nil then
      AiAgent(pMobile):addObjectFlag(AI_STATIC)
      CreatureObject(pMobile):setPvpStatusBitmask(0)
      CreatureObject(pMobile):setMoodString(self.spectatorMoods[getRandomNumber(1, #self.spectatorMoods)])
    end
    
    spawnY = spawnY + getRandomNumber(4, 10);
  end
end

function Arena:spawnObjects()
  spawnSceneObject("lok", "object/installation/battlefield/destructible/bfield_wall_barbed.iff", -3024, 66, 468, 0, 0);
  spawnSceneObject("lok", "object/installation/battlefield/destructible/bfield_wall_barbed.iff", -3008, 66, 468, 0, 0);
  spawnSceneObject("lok", "object/installation/battlefield/destructible/bfield_wall_barbed.iff", -2992, 66, 468, 0, 0);
  spawnSceneObject("lok", "object/installation/battlefield/destructible/bfield_wall_barbed.iff", -2976, 66, 468, 0, 0);
  spawnSceneObject("lok", "object/installation/battlefield/destructible/bfield_wall_barbed.iff", -2968, 66, 476, 0, math.rad(90));
  spawnSceneObject("lok", "object/installation/battlefield/destructible/bfield_wall_barbed.iff", -2968, 66, 492, 0, math.rad(90));
  spawnSceneObject("lok", "object/installation/battlefield/destructible/bfield_wall_barbed.iff", -2968, 66, 508, 0, math.rad(90));
  spawnSceneObject("lok", "object/installation/battlefield/destructible/bfield_wall_barbed.iff", -2968, 66, 524, 0, math.rad(90));
  spawnSceneObject("lok", "object/installation/battlefield/destructible/bfield_wall_barbed.iff", -3032, 66, 524, 0, math.rad(90));
  spawnSceneObject("lok", "object/installation/battlefield/destructible/bfield_wall_barbed.iff", -3032, 66, 508, 0, math.rad(90));
  spawnSceneObject("lok", "object/installation/battlefield/destructible/bfield_wall_barbed.iff", -3032, 66, 492, 0, math.rad(90));
  spawnSceneObject("lok", "object/installation/battlefield/destructible/bfield_wall_barbed.iff", -3032, 66, 476, 0, math.rad(90));
  spawnSceneObject("lok", "object/installation/battlefield/destructible/bfield_wall_barbed.iff", -2976, 66, 532, 0, 0);
  spawnSceneObject("lok", "object/installation/battlefield/destructible/bfield_wall_barbed.iff", -2992, 66, 532, 0, 0);
  spawnSceneObject("lok", "object/installation/battlefield/destructible/bfield_wall_barbed.iff", -3008, 66, 532, 0, 0);
  spawnSceneObject("lok", "object/installation/battlefield/destructible/bfield_wall_barbed.iff", -3024, 66, 532, 0, 0);

  spawnSceneObject("lok", "object/tangible/furniture/all/frn_all_tiki_torch_s1.iff", -2950, 66, 500, 0, 0);
  spawnSceneObject("lok", "object/tangible/furniture/all/frn_all_tiki_torch_s1.iff", -2951.70370868555, 66, 512.940952255126, 0, 0);
  spawnSceneObject("lok", "object/tangible/furniture/all/frn_all_tiki_torch_s1.iff", -2956.69872981078, 66, 525, 0, 0);
  spawnSceneObject("lok", "object/tangible/furniture/all/frn_all_tiki_torch_s1.iff", -2964.64466094067, 66, 535.355339059327, 0, 0);
  spawnSceneObject("lok", "object/tangible/furniture/all/frn_all_tiki_torch_s1.iff", -2975, 66, 543.301270189222, 0, 0);
  spawnSceneObject("lok", "object/tangible/furniture/all/frn_all_tiki_torch_s1.iff", -2987.05904774487, 66, 548.296291314453, 0, 0);
  spawnSceneObject("lok", "object/tangible/furniture/all/frn_all_tiki_torch_s1.iff", -3000, 66, 550, 0, 0);
  spawnSceneObject("lok", "object/tangible/furniture/all/frn_all_tiki_torch_s1.iff", -3012.94095225513, 66, 548.296291314453, 0, 0);
  spawnSceneObject("lok", "object/tangible/furniture/all/frn_all_tiki_torch_s1.iff", -3025, 66, 543.301270189222, 0, 0);
  spawnSceneObject("lok", "object/tangible/furniture/all/frn_all_tiki_torch_s1.iff", -3035.35533905933, 66, 535.355339059327, 0, 0);
  spawnSceneObject("lok", "object/tangible/furniture/all/frn_all_tiki_torch_s1.iff", -3043.30127018922, 66, 525, 0, 0);
  spawnSceneObject("lok", "object/tangible/furniture/all/frn_all_tiki_torch_s1.iff", -3048.29629131445, 66, 512.940952255126, 0, 0);
  spawnSceneObject("lok", "object/tangible/furniture/all/frn_all_tiki_torch_s1.iff", -3050, 66, 500, 0, 0);
  spawnSceneObject("lok", "object/tangible/furniture/all/frn_all_tiki_torch_s1.iff", -3048.29629131445, 66, 487.059047744874, 0, 0);
  spawnSceneObject("lok", "object/tangible/furniture/all/frn_all_tiki_torch_s1.iff", -3043.30127018922, 66, 475, 0, 0);
  spawnSceneObject("lok", "object/tangible/furniture/all/frn_all_tiki_torch_s1.iff", -3035.35533905933, 66, 464.644660940673, 0, 0);
  spawnSceneObject("lok", "object/tangible/furniture/all/frn_all_tiki_torch_s1.iff", -3025, 66, 456.698729810778, 0, 0);
  spawnSceneObject("lok", "object/tangible/furniture/all/frn_all_tiki_torch_s1.iff", -3012.94095225513, 66, 451.703708685547, 0, 0);
  spawnSceneObject("lok", "object/tangible/furniture/all/frn_all_tiki_torch_s1.iff", -3000, 66, 450, 0, 0);
  spawnSceneObject("lok", "object/tangible/furniture/all/frn_all_tiki_torch_s1.iff", -2987.05904774487, 66, 451.703708685547, 0, 0);
  spawnSceneObject("lok", "object/tangible/furniture/all/frn_all_tiki_torch_s1.iff", -2975, 66, 456.698729810778, 0, 0);
  spawnSceneObject("lok", "object/tangible/furniture/all/frn_all_tiki_torch_s1.iff", -2964.64466094067, 66, 464.644660940673, 0, 0);
  spawnSceneObject("lok", "object/tangible/furniture/all/frn_all_tiki_torch_s1.iff", -2956.69872981078, 66, 475, 0, 0);
  spawnSceneObject("lok", "object/tangible/furniture/all/frn_all_tiki_torch_s1.iff", -2951.70370868555, 66, 487.059047744874, 0, 0);
end

function Arena:isArenaOccupied() 
  local pAdminPlayer = getCreatureObject(self.AdminPlayerID)
  
  return tonumber(readScreenPlayData(pAdminPlayer, "Arena", "occupied")) == 1
end

function Arena:resetArena()
  local pAdminPlayer = getCreatureObject(self.AdminPlayerID)
  writeScreenPlayData(pAdminPlayer, "Arena", "occupied", 0)
end

function Arena:beginArena(pPlayer)
  logToFile(CreatureObject(pPlayer):getFirstName() .. " entered the arena.", "log/arena/troubleshoot.log")
  local pAdminPlayer = getCreatureObject(self.AdminPlayerID)
  writeScreenPlayData(pAdminPlayer, "Arena", "occupied", 1)

  -- Teleport Player in
  SceneObject(pPlayer):switchZone("lok", -3000, 66, 500, 0)
  -- Set Observer on Player Death
  createObserver(OBJECTDESTRUCTION, "Arena", "notifyPlayerKilled", pPlayer)

  local playerID = SceneObject(pPlayer):getObjectID()
  -- Initialize arena for this player 
  writeScreenPlayData(pPlayer, "Arena", ":arenaWaveCount", 0)
  writeScreenPlayData(pPlayer, "Arena", ":arenaEnemyList", "")
  writeScreenPlayData(pPlayer, "Arena", ":arenaStartTime", os.time())
  writeScreenPlayData(pPlayer, "Arena", ":arenaActive", 1)

  writeScreenPlayData(pPlayer, "NonEncounterEvent", "inEvent", 1)

  CreatureObject(pPlayer):sendSystemMessage(" \\#FF0000\\ The Arena will begin in 30s")

  -- Start spawning creatures
  createEvent(30000, "Arena", "spawnArenaMobs", pPlayer, "")
  return 0
end

function Arena:stopArena(pPlayer)
  -- Stop spawning enemies & kill them
  createEvent(5000, "Arena", "killAllEnemies", pPlayer, "")

  local playerID = SceneObject(pPlayer):getObjectID()
  deleteScreenPlayData(pPlayer, "Arena", ":arenaActive")

  -- Work out score 
  local startTime = tonumber(readScreenPlayData(pPlayer, "Arena", ":arenaStartTime")) or 0
  local elapsed = 0
  if startTime > 0 then
    elapsed = (os.time() - startTime) - 30
  end

  local score = HelperFuncs:round(elapsed * 3.14 * 501 / 69)
  local experience = HelperFuncs:round(score * 0.261365)
  CreatureObject(pPlayer):awardExperience("combat_gladiator", experience, true)

  local pAdminPlayer = getCreatureObject(self.AdminPlayerID)
  if pAdminPlayer ~= nil then
    self:addOrUpdateScore(pAdminPlayer, pPlayer, score)
    CreatureObject(pPlayer):sendSystemMessage("Your score was " .. score)
  end

  deleteScreenPlayData(pPlayer, "Arena", ":arenaStartTime")
  deleteScreenPlayData(pPlayer, "Arena", ":arenaWaveCount")
  writeScreenPlayData(pAdminPlayer, "Arena", "occupied", 0)

  writeScreenPlayData(pPlayer, "NonEncounterEvent", "inEvent", 0)

  createEvent(2500, "Arena", "resetPlayer", pPlayer, "")
  return 0
end

function Arena:resetPlayer(pPlayer)
  SceneObject(pPlayer):switchZone("lok", -3042, 66, 502, 0)
  CreatureObject(pPlayer):revivePatient()
  writeScreenPlayData(pPlayer, "Arena", ":arenaCooldown", os.time() + self.playerCooldown)

end

function Arena:notifyPlayerKilled(pPlayer, pVictim, nothing)
  if pPlayer == nil then
    return 0
  end

  dropObserver(OBJECTDESTRUCTION, "Arena", "notifyPlayerKilled", pPlayer)
  self:stopArena(pPlayer)
  return 0
end

function Arena:getEnemyTemplate(waveCount)
  local maxIndex = #self.enemyTemplates

  if waveCount >= maxIndex then
    return self.enemyTemplates[maxIndex]
  end

  return self.enemyTemplates[waveCount]
end

function Arena:spawnArenaMobs(pPlayer)
  if pPlayer == nil then 
    return
  end

  local playerID = SceneObject(pPlayer):getObjectID()

  local active = tonumber(readScreenPlayData(pPlayer, "Arena", ":arenaActive")) or 0
  if active ~= 1 then
    return
  end

  local waveCount = tonumber(readScreenPlayData(pPlayer, "Arena", ":arenaWaveCount")) or 0
  waveCount = waveCount + 1
  writeScreenPlayData(pPlayer, "Arena", ":arenaWaveCount", waveCount)

  local enemyTemplate = self:getEnemyTemplate(waveCount)

  local spawnX = -2995 + getRandomNumber(0, 10)
  local spawnY = 495 + getRandomNumber(0, 10)
  local spawnZ = 66

  local pMobile = spawnMobile("lok", enemyTemplate, 0, spawnX, spawnZ, spawnY, 0, 0)

  if pMobile ~= nil then
    local enemyList = readScreenPlayData(pPlayer, "Arena", ":arenaEnemyList")
    if enemyList == "" then
      enemyList = tostring(SceneObject(pMobile):getObjectID())
    else
      enemyList = enemyList .. "," .. tostring(SceneObject(pMobile):getObjectID())
    end
    writeScreenPlayData(pPlayer, "Arena", ":arenaEnemyList", enemyList)

    AiAgent(pMobile):setAITemplate()
    AiAgent(pMobile):addDefender(pPlayer)
  end

  local newWaveTimer = self.waveTimer - (waveCount * 2500)

  createEvent(math.max(self.minWaveTimer, newWaveTimer), "Arena", "spawnArenaMobs", pPlayer, "")
  return 1
end

function Arena:killAllEnemies(pPlayer)
  if pPlayer == nil then
    return
  end

  local playerID = SceneObject(pPlayer):getObjectID()

  local enemyList = readScreenPlayData(pPlayer, "Arena", ":arenaEnemyList")

  if enemyList == "" or enemyList == nil then
    return
  end

  for enemyID in string.gmatch(enemyList, "[^,]+") do
    local pEnemy = getSceneObject(tonumber(enemyID))

    if pEnemy ~= nil then
      SceneObject(pEnemy):destroyObjectFromWorld()
    end
  end

  deleteScreenPlayData(pPlayer, "Arena", ":arenaEnemyList")
end

function Arena:addOrUpdateScore(pAdminPlayer, pPlayer, score)
    local screenplay = "Arena"
    local objectID = tostring(SceneObject(pPlayer):getObjectID())

    local playersStr =
        readScreenPlayData(pAdminPlayer, screenplay, "players") or ""
    local players = {}

    if playersStr ~= "" then
        players = HelperFuncs:split(playersStr, ",")
    end

    local key = "player_" .. objectID .. "_score"
    local oldScore =
        tonumber(readScreenPlayData(pAdminPlayer, screenplay, key)) or 0

    if score <= oldScore then
        return
    end

    writeScreenPlayData(pAdminPlayer, screenplay, key, score)

    local exists = false
    for _, n in ipairs(players) do
      if n == objectID then
        exists = true
            break
        end
    end

    if not exists then
        table.insert(players, objectID)
        writeScreenPlayData(
            pAdminPlayer,
            screenplay,
            "players",
            HelperFuncs:join(players, ",")
        )
    end
  logToFile("addOrUpdateScore - player: " .. CreatureObject(pPlayer):getFirstName() .. " score: " .. score, "log/arena/troubleshoot.log")
end

function Arena:getPosition(position)
  local pAdminPlayer = getCreatureObject(self.AdminPlayerID)
  local screenplay = "Arena"
  local results = {}

  local playersStr =
      readScreenPlayData(pAdminPlayer, screenplay, "players") or ""
  local players = HelperFuncs:split(playersStr, ",")

  for _, id in ipairs(players) do
      local score =
          tonumber(readScreenPlayData(
              pAdminPlayer,
              screenplay,
              "player_" .. id .. "_score"
          ))

      if score ~= nil then
          table.insert(results, {
              id = id,
              score = score
          })
      end
  end

  table.sort(results, function(a, b)
      return a.score > b.score
  end)

  for index, entry in ipairs(results) do
      if index == position then
          local pPlayer = getCreatureObject(tonumber(entry.id))
          if pPlayer ~= nil then
              return pPlayer
          else
              return "Unknown Player with a score of " .. entry.score
          end
      end
  end

  return nil
end

function Arena:getPlayerPosition(playerID)
  local pAdminPlayer = getCreatureObject(self.AdminPlayerID)
  local screenplay = "Arena"
  local results = {}

  local playersStr =
      readScreenPlayData(pAdminPlayer, screenplay, "players") or ""
  local players = HelperFuncs:split(playersStr, ",")

  for _, id in ipairs(players) do
      local score =
          tonumber(readScreenPlayData(
              pAdminPlayer,
              screenplay,
              "player_" .. id .. "_score"
          ))

      if score ~= nil then
          table.insert(results, {
              id = id,
              score = score
          })
      end
  end

  table.sort(results, function(a, b)
      return a.score > b.score
  end)

  for index, entry in ipairs(results) do
      if tonumber(entry.id) == playerID then
          return index
      end
  end

  return nil
end
