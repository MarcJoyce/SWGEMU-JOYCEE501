ArenaInvite = ScreenPlay:new {
    INVITE = 1,
    stepDelay = {
        -- [1] = { 300, 600 }
        [1] = { 5, 10 }
    },
		testingList = {
			"281475001698996", -- Cander -- JoyceeTT
			"281474993627424", -- Ekree  -- Ekree
			"281474993603702", -- Lore   -- Krey
			"281474993622243", -- Nissin -- Nissin
			"281474993605522", -- Tarwin -- Girgi
			"281474994006800", -- Acko   -- Admin
			"281474993547517", -- Stan   -- Admin
			"281474993911974", -- Pork   -- Lore
		}
}
function ArenaInvite:isEligible(pPlayer)
	local pGhost = CreatureObject(pPlayer):getPlayerObject()
	-- if (HelperFuncs:tableContainsValue(self.testingList, tostring(CreatureObject(pPlayer):getObjectID()))) then
	if (self:hasCombatProficiency(pPlayer)) then
		if (not CreatureObject(pPlayer):hasScreenPlayState(1, "arena")) then
			return true
		end
	end
	-- end
	return false
end

function ArenaInvite:hasCombatProficiency(pPlayer)
	local pGhost = CreatureObject(pPlayer):getPlayerObject()
	return CreatureObject(pPlayer):hasSkill("combat_bountyhunter_master") or CreatureObject(pPlayer):hasSkill("combat_brawler_master") or CreatureObject(pPlayer):hasSkill("combat_carbine_master") or CreatureObject(pPlayer):hasSkill("combat_commando_master") or CreatureObject(pPlayer):hasSkill("combat_1hsword_master") or CreatureObject(pPlayer):hasSkill("combat_marksman_master") or CreatureObject(pPlayer):hasSkill("combat_polearm_master") or CreatureObject(pPlayer):hasSkill("combat_pistol_master") or CreatureObject(pPlayer):hasSkill("combat_rifleman_master") or CreatureObject(pPlayer):hasSkill("combat_smuggler_master") or CreatureObject(pPlayer):hasSkill("combat_2hsword_master") or CreatureObject(pPlayer):hasSkill("combat_unarmed_master") or PlayerObject(pGhost):isJedi()
end

function ArenaInvite:hasDelayPassed(pPlayer)
	local stepDelay = tonumber(readScreenPlayData(pPlayer, "ArenaInvite", "EncounterDelay"))

	if (stepDelay == nil or stepDelay == 0) then
		return true
	end

	return os.time() >= stepDelay
end

function ArenaInvite:startStepDelay(pPlayer, step)
	local stepData = self.stepDelay[step]

	if (stepData == nil) then
		printLuaError("ArenaInvite:startStepDelay, invalid step data.")
		return
	end

	self:setCurrentStep(pPlayer, step)
	local stepDelay = getRandomNumber(stepData[1], stepData[2])

	writeScreenPlayData(pPlayer, "ArenaInvite", "EncounterDelay", stepDelay + os.time())
	createEvent(stepDelay * 1000, "ArenaInvite", "doDelayedStep", pPlayer, "")
end

function ArenaInvite:doDelayedStep(pPlayer)
	if (pPlayer == nil) then
		return
	end

	local pGhost = CreatureObject(pPlayer):getPlayerObject()

	if (pGhost == nil or not PlayerObject(pGhost):isOnline()) then
		return
	end

	if (CreatureObject(pPlayer):isDead() or CreatureObject(pPlayer):isIncapacitated() or not Encounter:isPlayerInPositionForEncounter(pPlayer)) then
		createEvent(getRandomNumber(300, 900) * 1000, "ArenaInvite", "doDelayedStep", pPlayer, "")
		return
	end

	local curStep = self.INVITE

	local encounterResult = true

	if (curStep == self.INVITE) then
		encounterResult = EncounterArenaInvite:start(pPlayer)
	end

	if (not encounterResult) then
		local rescheduleDelay = getRandomNumber(300, 900) * 60 * 1000
		createEvent(rescheduleDelay, "ArenaInvite", "doDelayedStep", pPlayer, "")
	end
end

function ArenaInvite:onPlayerLoggedIn(pPlayer)
	if (not self:isEligible(pPlayer)) then
		return
	end

	if (self:hasDelayPassed(pPlayer)) then
		createEvent(getRandomNumber(5, 10) * 1000, "ArenaInvite", "doDelayedStep", pPlayer, "")
	end

	return 0
end
