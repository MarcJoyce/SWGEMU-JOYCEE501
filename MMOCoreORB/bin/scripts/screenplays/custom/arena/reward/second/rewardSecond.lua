RewardSecond = ScreenPlay:new {
    REWARD = 1,
    stepDelay = {
        [1] = {5, 10}
    }
}

function RewardSecond:isEligible(pPlayer)
    if (CreatureObject(pPlayer):hasScreenPlayState(1, "ArenaRewardSecond")) then
        return true
    end

    return false
end

function RewardSecond:hasDelayPassed(pPlayer)
    local stepDelay = tonumber(readScreenPlayData(pPlayer, "RewardSecond", "RewardDelay"))

    if (stepDelay == nil or stepDelay == 0) then
        return true
    end

    return os.time() >= stepDelay
end

function RewardSecond:startStepDelay(pPlayer, step)
    local stepData = self.stepDelay[step]

    if (stepData == nil) then
        printLuaError("RewardSecond:startStepDelay, invalid step data.")
        return
    end

    local stepDelay = getRandomNumber(stepData[1], stepData[2])

    writeScreenPlayData(pPlayer, "RewardSecond", "RewardDelay", stepDelay + os.time())
    createEvent(stepDelay * 1000, "RewardSecond", "doDelayedStep", pPlayer, "")
end

function RewardSecond:doDelayedStep(pPlayer)
    if (pPlayer == nil) then
        return
    end

    if (not self:isEligible(pPlayer)) then
        return
    end

    local pGhost = CreatureObject(pPlayer):getPlayerObject()

    if (pGhost == nil or not PlayerObject(pGhost):isOnline()) then
        return
    end

    if (CreatureObject(pPlayer):isDead() or CreatureObject(pPlayer):isIncapacitated()) then
        createEvent(getRandomNumber(300, 900) * 1000, "RewardSecond", "doDelayedStep", pPlayer, "")
        return
    end

    local curStep = self.REWARD

    local encounterResult = true

    if (curStep == self.REWARD) then
        encounterResult = RewardSecondEncounter:start(pPlayer)
    end

    if (not encounterResult) then
        local rescheduleDelay = getRandomNumber(300, 900) * 60 * 1000
        createEvent(rescheduleDelay, "RewardSecond", "doDelayedStep", pPlayer, "")
    end
end

function RewardSecond:onPlayerLoggedIn(pPlayer)
    if (not self:isEligible(pPlayer)) then
        return
    end

    if (self:hasDelayPassed(pPlayer)) then
        createEvent(getRandomNumber(5, 10) * 1000, "RewardSecond", "doDelayedStep", pPlayer, "")
    end

    return 0
end

