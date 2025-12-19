local ObjectManager = require("managers.object.object_manager")
local Logger = require("utils.logger")

BountyHunterGuildScreenPlay = ScreenPlay:new {}

registerScreenPlay("BountyHunterGuildScreenPlay", true)

function BountyHunterGuildScreenPlay:start()
  if (isZoneEnabled("tatooine")) then
    self:spawnMobiles()
  end
end

function BountyHunterGuildScreenPlay:spawnMobiles() 
  local pNpc = spawnMobile("tatooine", "shae_torrvek", 60, 9.78, 2, 39.9067, 270.845, 1177487)
  self:setMoodString(pNpc, "npc_sitting_chair")
end

function BountyHunterGuildScreenPlay:setCurrentTrial(pPlayer, num)
	writeScreenPlayData(pPlayer, "BountyHunterGuildScreenPlay", "currentTrial", num)
end

function BountyHunterGuildScreenPlay:getCurrentTrial(pPlayer)
	return tonumber(readScreenPlayData(pPlayer, "BountyHunterGuildScreenPlay", "currentTrial"))
end

function BountyHunterGuildScreenPlay:getTrialsCompleted(pPlayer) 
  local completed = tonumber(readScreenPlayData(pPlayer, "BountyHunterTrials", "trialsCompleted"))

		if (completed == nil) then
			writeScreenPlayData(pPlayer, "BountyHunterTrials", "trialsCompleted", 0)
			return 0
		else
			return completed
		end
end

function BountyHunterGuildScreenPlay:setTrialsCompleted(pPlayer, num)
  writeScreenPlayData(pPlayer, "BountyHunterTrials", "trialsCompleted", num)
end

function BountyHunterGuildScreenPlay:startNextTrial(pPlayer)
  if (pPlayer == nil) then
    return
  end
  
  local trialsCompleted = self:getTrialsCompleted(pPlayer)

  if (trialsCompleted == 4 or trialsCompleted == 8 or trialsCompleted == 12) then
    CreatureObject(pPlayer):sendSystemMessage(" \\#FFFF00\\<Communicator>  \\#FFFFFF\\Checking progress... You are eligible for further training. Return to the guild.")
  end

  if (trialsCompleted >= #bhTrials) then
    CreatureObject(pPlayer):sendSystemMessage(" \\#FFFF00\\<Communicator>  \\#FFFFFF\\Checking progress.. You have completed your trials. Return to the guild for your final training.")
    dropObserver(KILLEDCREATURE, "BountyHunterGuildScreenPlay", notifyKilledHuntTarget, pPlayer)
    deleteScreenPlayData(pPlayer, "BountyHunterGuildScreenPlay", "huntTarget")
    deleteScreenPlayData(pPlayer, "BountyHunterGuildScreenPlay", "huntTargetCount")
    deleteScreenPlayData(pPlayer, "BountyHunterGuildScreenPlay", "huntTargetGoal")
  end
  
  local currentTrial = trialsCompleted + 1
  BountyHunterGuildScreenPlay:setCurrentTrial(pPlayer, currentTrial)
  
  local trialData = bhTrials[currentTrial]

  CreatureObject(pPlayer):sendSystemMessage(" \\#FFFF00\\<Communicator>  \\#FFFFFF\\Your next trial: " .. trialData.trialName .. " (" .. trialData.huntGoal .. "). Good hunting.")

  writeScreenPlayData(pPlayer, "BountyHunterGuildScreenPlay", "huntTarget", trialData.huntTarget)
  writeScreenPlayData(pPlayer, "BountyHunterGuildScreenPlay", "huntTargetGoal", trialData.huntGoal)
  writeScreenPlayData(pPlayer, "BountyHunterGuildScreenPlay", "huntTargetCount", 0)
  createObserver(KILLEDCREATURE, "BountyHunterGuildScreenPlay", "notifyKilledHuntTarget", pPlayer)
end

function BountyHunterGuildScreenPlay:notifyKilledHuntTarget(pPlayer, pVictim) 
  if (pVictim == nil) then
    return 0
  end

  if (pPlayer == nil) then
    return 1
  end

  local trialNumber = BountyHunterGuildScreenPlay:getCurrentTrial(pPlayer)

  if (trialNumber <= 0) then
    return 1
  end

  local trialData = bhTrials[trialNumber]

  if (trialData.trialType ~= TRIAL_HUNT) then
		return 1
	end

  local huntTarget = readScreenPlayData(pPlayer, "BountyHunterGuildScreenPlay", "huntTarget")
	local targetCount = tonumber(readScreenPlayData(pPlayer, "BountyHunterGuildScreenPlay", "huntTargetCount"))
	local targetGoal = tonumber(readScreenPlayData(pPlayer, "BountyHunterGuildScreenPlay", "huntTargetGoal"))


  if (targetCount == nil) then
		printLuaError("BhTrials:notifyKilledHuntTarget, nil targetCount for player: " .. SceneObject(pPlayer):getCustomObjectName() .. " on trial " .. trialNumber .. " (player killed target: " .. SceneObject(pVictim):getObjectName() .. "). Setting to 0.")
		writeScreenPlayData(pPlayer, "BountyHunterGuildScreenPlay", "huntTargetCount", 0)
		targetCount = 0
	end

	if (targetGoal == nil) then
		printLuaError("BhTrials:notifyKilledHuntTarget, nil targetGoal for player: " .. SceneObject(pPlayer):getCustomObjectName() .. " on trial " .. trialNumber .. " (player killed target: " .. SceneObject(pVictim):getObjectName() .. "). Setting to " .. trialData.huntGoal .. ".")
		writeScreenPlayData(pPlayer, "BountyHunterGuildScreenPlay", "huntTargetGoal", trialData.huntGoal)
		targetGoal = trialData.huntGoal
	end

	if (huntTarget == nil or huntTarget == "") then
		local newTarget = trialData.huntTarget
    printLuaError("BhTrials:notifyKilledHuntTarget, nil huntTarget for player: " .. SceneObject(pPlayer):getCustomObjectName() .. " on trial " .. trialNumber .. " (player killed target: " .. SceneObject(pVictim):getObjectName() .. "). Setting to " .. newTarget .. ".")
    writeScreenPlayData(pPlayer, "BountyHunterGuildScreenPlay", "huntTarget", trialData.huntTarget)
		huntTarget = newTarget
	end

  if (SceneObject(pVictim):getZoneName() ~= SceneObject(pPlayer):getZoneName() or not CreatureObject(pPlayer):isInRangeWithObject(pVictim, 80)) then
		return 0
	end

  local targetList = HelperFuncs:splitString(huntTarget, ";")

  if (huntTarget == SceneObject(pVictim):getObjectName() or HelperFuncs:tableContainsValue(targetList, SceneObject(pVictim):getObjectName())) then
		targetCount = targetCount + 1
		writeScreenPlayData(pPlayer, "BountyHunterGuildScreenPlay", "huntTargetCount", targetCount)
  
    CreatureObject(pPlayer):sendSystemMessage(" \\#FFFF00\\<Communicator>  \\#FFFFFF\\Tracking a kill, you have now dispatched " .. targetCount .. " out of " .. targetGoal .. ". You have been transferred " .. trialData.reward .. " credits.")

    CreatureObject(pPlayer):addBankCredits(trialData.reward, true)
    
		if (targetCount >= targetGoal) then
			local trialsCompleted = self:getTrialsCompleted(pPlayer) + 1
			self:setTrialsCompleted(pPlayer, trialsCompleted)
      deleteScreenPlayData(pPlayer, "BountyHunterGuildScreenPlay", "huntTarget")
      deleteScreenPlayData(pPlayer, "BountyHunterGuildScreenPlay", "huntTargetCount")
      deleteScreenPlayData(pPlayer, "BountyHunterGuildScreenPlay", "huntTargetGoal")
			self:startNextTrial(pPlayer)
			return 1
		end
	end

	return 0
end

function BountyHunterGuildScreenPlay:log(message)
  local outputFile = "log/bountyhunterguild.log"
  logToFile(message, outputFile)
end

