JediEncounters = ScreenPlay:new {
	BOUNTYHUNTERS = 1,
	PADAWAN = 2,
	KNIGHT = 3,
	MASTER = 4,
	DARTHVADER = 5,

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
		[5] = { 86400 , 432000 }
	}
}

function JediEncounters:isEligible(pPlayer) 
	return CreatureObject(pPlayer):hasSkill("force_title_jedi_rank_03")
end

function JediEncounters:getCurrentStep(pPlayer)
	local curStep = readScreenPlayData(pPlayer, "JediEncounters", "EncounterStep")

	if (curStep == "") then
		curStep = 1
		self:setCurrentStep(pPlayer, self.BOUNTYHUNTERS)
	end

	return tonumber(curStep)
end

function JediEncounters:setCurrentStep(pPlayer, step) 
	writeScreenPlayData(pPlayer, "JediEncounters", "EncounterStep", step)
end

function JediEncounters:hasDelayPassed(pPlayer)
	local stepDelay = tonumber(readScreenPlayData(pPlayer, "JediEncounters", "EncounterDelay"))

	if (stepDelay == nil or stepDelay == 0) then
		return true
	end

	return os.time() >= stepDelay
end

function JediEncounters:startStepDelay(pPlayer, step)
	local stepData = self.stepDelay[step]

	if (stepData == nil) then
		printLuaError("JediEncounters:startStepDelay, invalid step data.")
		return
	end

	self:setCurrentStep(pPlayer, step)
	local stepDelay = getRandomNumber(stepData[1], stepData[2])

	self:log("StartStepDelay: StepDelay: " .. stepDelay .. ", os.time(): " .. os.time() .. ", os.time() + stepDelay: " .. stepDelay + os.time())
	writeScreenPlayData(pPlayer, "JediEncounters", "EncounterDelay", stepDelay + os.time())
	createEvent(stepDelay * 1000, "JediEncounters", "doDelayedStep", pPlayer, "")
end

function JediEncounters:doDelayedStep(pPlayer)
	if (pPlayer == nil) then
		return
	end

	local pGhost = CreatureObject(pPlayer):getPlayerObject()

	if (pGhost == nil or not PlayerObject(pGhost):isOnline()) then
		return
	end

	if (CreatureObject(pPlayer):isDead() or CreatureObject(pPlayer):isIncapacitated() or not Encounter:isPlayerInPositionForEncounter(pPlayer)) then
		createEvent(getRandomNumber(300, 900) * 1000, "JediEncounters", "doDelayedStep", pPlayer, "")
		return
	end

	local curStep = self:getCurrentStep(pPlayer)

	local encounterResult = true

	if (curStep == self.BOUNTYHUNTERS) then
		encounterResult = EncounterBountyHunters:start(pPlayer)
	elseif (curStep == self.PADAWAN) then
		encounterResult = EncounterPadawan:start(pPlayer)
	elseif (curStep == self.KNIGHT) then
		encounterResult = EncounterKnight:start(pPlayer)
	elseif (curStep == self.MASTER) then
		encounterResult = EncounterMaster:start(pPlayer)
	elseif (curStep == self.DARTHVADER) then
		encounterResult = EncounterVader:start(pPlayer)
	end

	if (not encounterResult) then
		local rescheduleDelay = getRandomNumber(15, 30) * 60 * 1000
		createEvent(rescheduleDelay, "JediEncounters", "doDelayedStep", pPlayer, "")
	end
end

function JediEncounters:onPlayerLoggedIn(pPlayer)
	if (not self:isEligible(pPlayer)) then
		return
	end

	if (self:hasDelayPassed(pPlayer)) then
		createEvent(getRandomNumber(300, 900) * 1000, "JediEncounters", "doDelayedStep", pPlayer, "")
	end

end

function JediEncounters:log(message)
	local outputFile = "log/JediEncounters.log"
	logToFile(message, outputFile)
end