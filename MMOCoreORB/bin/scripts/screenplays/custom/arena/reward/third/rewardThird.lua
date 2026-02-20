RewardThird = ScreenPlay:new {
    REWARD = 1,
    stepDelay = {
        [1] = {5, 10}
    }
}

function RewardThird:isEligible(pPlayer)
    if (CreatureObject(pPlayer):hasScreenPlayState(1, "ArenaRewardThird")) then
        return true
    end

    return false
end

function RewardThird:hasDelayPassed(pPlayer)
    local stepDelay = tonumber(readScreenPlayData(pPlayer, "RewardThird", "RewardDelay"))

    if (stepDelay == nil or stepDelay == 0) then
        return true
    end

    return os.time() >= stepDelay
end

function RewardThird:startStepDelay(pPlayer, step)
    local stepData = self.stepDelay[step]

    if (stepData == nil) then
        printLuaError("RewardThird:startStepDelay, invalid step data.")
        return
    end

    local stepDelay = getRandomNumber(stepData[1], stepData[2])

    writeScreenPlayData(pPlayer, "RewardThird", "RewardDelay", stepDelay + os.time())
    createEvent(stepDelay * 1000, "RewardThird", "doDelayedStep", pPlayer, "")
end

function RewardThird:doDelayedStep(pPlayer)
    if (pPlayer == nil) then
        return
    end

    local pGhost = CreatureObject(pPlayer):getPlayerObject()

    if (pGhost == nil or not PlayerObject(pGhost):isOnline()) then
        return
    end

    if (CreatureObject(pPlayer):isDead() or CreatureObject(pPlayer):isIncapacitated()) then
        createEvent(getRandomNumber(300, 900) * 1000, "RewardThird", "doDelayedStep", pPlayer, "")
        return
    end

    local curStep = self.REWARD

    local encounterResult = true

    if (curStep == self.REWARD) then
        encounterResult = RewardThirdEncounter:start(pPlayer)
    end

    if (not encounterResult) then
        local rescheduleDelay = getRandomNumber(300, 900) * 60 * 1000
        createEvent(rescheduleDelay, "RewardThird", "doDelayedStep", pPlayer, "")
    end
end

function RewardThird:onPlayerLoggedIn(pPlayer)
    if (not self:isEligible(pPlayer)) then
        return
    end

    if (self:hasDelayPassed(pPlayer)) then
        createEvent(getRandomNumber(5, 10) * 1000, "RewardThird", "doDelayedStep", pPlayer, "")
    end

    return 0
end

