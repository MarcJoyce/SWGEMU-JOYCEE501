GCWEncounters = ScreenPlay:new {
	BOUNTYHUNTERS = 1,
	TROOPERS = 2,
	ELITE = 3,
	MASTER = 4,
	-- BOSS = 5,

	stepDelay = {
		-- [1] = { 30, 31 },
		-- [2] = { 30, 31 },
		-- [3] = { 30, 31 },
		-- [4] = { 30, 31 },
		-- [5] = { 30, 31 }
		[1] = { 86400, 259200 },
		[2] = { 86400, 259200 },
		[3] = { 86400 , 345600 },
		[4] = { 86400 , 345600 },
		-- [5] = { 86400 , 432000 }
	}
}

function GCWEncounters:isEligible(pPlayer) 
	return CreatureObject(pPlayer):isCovert() or CreatureObject(pPlayer):isOvert();
end

function GCWEncounters:getCurrentStep(pPlayer)
	local curStep = readScreenPlayData(pPlayer, "GCWEncounters", "EncounterStep")

	if (curStep == "") then
		curStep = 1
		self:setCurrentStep(pPlayer, self.BOUNTYHUNTERS)
	end

	return tonumber(curStep)
end

function GCWEncounters:setCurrentStep(pPlayer, step) 
	writeScreenPlayData(pPlayer, "GCWEncounters", "EncounterStep", step)
end

function GCWEncounters:hasDelayPassed(pPlayer)
	local stepDelay = tonumber(readScreenPlayData(pPlayer, "GCWEncounters", "EncounterDelay"))

	if (stepDelay == nil or stepDelay == 0) then
		return true
	end

	return os.time() >= stepDelay
end

function GCWEncounters:startStepDelay(pPlayer, step)
	local stepData = self.stepDelay[step]

	if (stepData == nil) then
		printLuaError("GCWEncounters:startStepDelay, invalid step data.")
		return
	end

	self:setCurrentStep(pPlayer, step)
	local stepDelay = getRandomNumber(stepData[1], stepData[2])

	self:log("StartStepDelay: for " .. CreatureObject(pPlayer):getFirstName() .. "StepDelay: " .. stepDelay .. ", os.time(): " .. os.time() .. ", os.time() + stepDelay: " .. stepDelay + os.time())
	writeScreenPlayData(pPlayer, "GCWEncounters", "EncounterDelay", stepDelay + os.time())
	createEvent(stepDelay * 1000, "GCWEncounters", "doDelayedStep", pPlayer, "")
end

function GCWEncounters:doDelayedStep(pPlayer)
	if (pPlayer == nil) then
		return
	end

	local pGhost = CreatureObject(pPlayer):getPlayerObject()

	if (pGhost == nil or not PlayerObject(pGhost):isOnline()) then
		return
	end

	if (CreatureObject(pPlayer):isDead() or CreatureObject(pPlayer):isIncapacitated() or not Encounter:isPlayerInPositionForEncounter(pPlayer)) then
		createEvent(getRandomNumber(300, 900) * 1000, "GCWEncounters", "doDelayedStep", pPlayer, "")
		return
	end

	local curStep = self:getCurrentStep(pPlayer)

	local encounterResult = true

  local isImperial = CreatureObject(pPlayer):isImperial();

	if (curStep == self.BOUNTYHUNTERS) then
		encounterResult = EncounterGCWBountyHunters:start(pPlayer)
	elseif (curStep == self.TROOPERS) then
    if (isImperial) then
      encounterResult = EncounterGCWTroopersImperial:start(pPlayer);
    else
      encounterResult = EncounterGCWTroopersRebel:start(pPlayer)
		end
	elseif (curStep == self.ELITE) then
    if (isImperial) then
      encounterResult = EncounterGCWTEliteImperial:start(pPlayer);
    else
      encounterResult = EncounterGCWTEliteRebel:start(pPlayer)
		end
	elseif (curStep == self.MASTER) then
    if (isImperial) then
      encounterResult = EncounterGCWMasterImperial:start(pPlayer);
    else
      encounterResult = EncounterGCWMasterRebel:start(pPlayer)
		end
	-- elseif (curStep == self.BOSS) then
  --   if (isImperial) then
  --     encounterResult = EncounterGCWBossImperial:start(pPlayer);
  --   else
  --     encounterResult = EncounterGCWBossRebel:start(pPlayer)
	-- 	end
	end

	if (not encounterResult) then
		local rescheduleDelay = getRandomNumber(300, 900) * 60 * 1000
		createEvent(rescheduleDelay, "GCWEncounters", "doDelayedStep", pPlayer, "")
	end
end

function GCWEncounters:onPlayerLoggedIn(pPlayer)
	if (not self:isEligible(pPlayer)) then
		return
	end

	if (self:hasDelayPassed(pPlayer)) then
		createEvent(getRandomNumber(300, 900) * 1000, "GCWEncounters", "doDelayedStep", pPlayer, "")
	end

end

function GCWEncounters:log(message)
	local outputFile = "log/GCWEncounters.log"
	logToFile(message, outputFile)
end