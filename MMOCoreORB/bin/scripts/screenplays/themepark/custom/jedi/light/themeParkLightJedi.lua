local ObjectManager = require("managers.object.object_manager")

LightJediScreenPlay = ScreenPlay:new {
	numberOfActs = 1,

	screenplayName = "LightJediScreenPlay",
}

registerScreenPlay("LightJediScreenPlay", true)

function LightJediScreenPlay:start()
	if (isZoneEnabled("yavin4")) then
		self:spawnMobiles()
	end
end

function LightJediScreenPlay:retreatPatrolDestReached(pMobile)
	if (pMobile == nil) then
		return 0
	end

	local curLoc = readData(SceneObject(pMobile):getObjectID() .. ":currentLoc")

	if (curLoc == 1) then
		writeData(SceneObject(pMobile):getObjectID() .. ":currentLoc", 2)
	else
		writeData(SceneObject(pMobile):getObjectID() .. ":currentLoc", 1)
	end

	createEvent(getRandomNumber(350,450) * 100, "LightJediScreenPlay", "droidPatrol", pMobile, "")

	return 0
end

function LightJediScreenPlay:droidPatrol(pMobile)
	if (pMobile == nil) then
		return
	end
	local name = readStringData(SceneObject(pMobile):getObjectID() .. ":name")
	local curLoc = readData(SceneObject(pMobile):getObjectID() .. ":currentLoc")
	local nextLoc

	if (name == "droid1") then
		if (curLoc == 1) then

			nextLoc = { -3.81335, -15.1, 24.9568, 8525418}
		else
			nextLoc = { -18.6888, -15.1, -17.5874, 8525418 }
		end
	end

	if (name == "droid2") then
		if (curLoc == 1) then

			nextLoc = { -18.6888, -15.1, -17.5874, 8525418 }
		else
			nextLoc = { 24.0452, -15.1, 9.06116, 8525418 }
		end
	end

	if (name == "droid3") then
		if (curLoc == 1) then

			nextLoc = { 24.0452, -15.1, 9.06116, 8525418 }
		else
			nextLoc = { -3.81335, -15.1, 24.9568, 8525418}
		end
	end

    if (name == "droid4") then
        if (curLoc == 1) then

            nextLoc = { -12.0362, -18.8883, -23.0001, 8525436}
        else
            nextLoc = { -16.6321, -18.8883, 21.2009, 8525434}
        end
    end

    if (name == "droid5") then
        if (curLoc == 1) then

            nextLoc = { -16.6321, -18.8883, 21.2009, 8525434}
        else
            nextLoc = { 20.686, -18.8883, 17.8614, 8525438}
        end
    end

    if (name == "droid6") then
        if (curLoc == 1) then

            nextLoc = { 20.686, -18.8883, 17.8614, 8525438}
        else
            nextLoc = { 12.8025, -18.8883, -24.1243, 8525436}
        end
    end

    if (name == "droid7") then
        if (curLoc == 1) then

            nextLoc = { 12.8025, -18.8883, -24.1243, 8525436}
        else
            nextLoc = { -12.0362, -18.8883, -23.0001, 8525436}
        end
    end

	AiAgent(pMobile):stopWaiting()
	AiAgent(pMobile):setNextPosition(nextLoc[1], nextLoc[2], nextLoc[3], nextLoc[4])
	AiAgent(pMobile):executeBehavior()

end

function LightJediScreenPlay:spawnMobiles()

	-- Inside
    local pNpc = spawnMobile("yavin4", "light_jedi_padawan", 1, -12.6816, -19.25, 39.1917, 113, 8525439)
    self:setMoodString(pNpc, "conversation")
    pNpc = spawnMobile("yavin4", "light_jedi_padawan", 1, -11.7754, -19.25, 37.6555, 323, 8525439)
    self:setMoodString(pNpc, "conversation")
    pNpc = spawnMobile("yavin4", "light_jedi_padawan", 1, -10.5667, -19.25, 38.6833, 281, 8525439)
    self:setMoodString(pNpc, "conversation")
    pNpc = spawnMobile("yavin4", "light_jedi_padawan", 1, 10.9068, -18.9527, 33.084, 289, 8525439)
    self:setMoodString(pNpc, "conversation")
    pNpc = spawnMobile("yavin4", "light_jedi_padawan", 1, 9.99927, -19.188, 35.1376, 162, 8525439)
    self:setMoodString(pNpc, "conversation")
    pNpc = spawnMobile("yavin4", "light_jedi_padawan", 1, -13.554, -15.1, 18.9498, 140, 8525418)
    self:setMoodString(pNpc, "conversation")
    pNpc = spawnMobile("yavin4", "light_jedi_padawan", 1, -25.3605, -15.1, 9.29179, 92, 8525418)
    self:setMoodString(pNpc, "conversation")
    pNpc = spawnMobile("yavin4", "light_jedi_padawan", 1, -21.6432, -15.1, -5.59427, 113, 8525418)
    self:setMoodString(pNpc, "conversation")
    pNpc = spawnMobile("yavin4", "light_jedi_padawan", 1, -21.0489, -15.1, -8.30842, 31, 8525418)
    self:setMoodString(pNpc, "conversation")
    pNpc = spawnMobile("yavin4", "light_jedi_padawan", 1, -13.3812, -15.1, -17.7548, 36, 8525418)
    self:setMoodString(pNpc, "conversation")
    pNpc = spawnMobile("yavin4", "light_jedi_padawan", 1, 5.86529, -15.1, -21.9555, 5, 8525418)
    self:setMoodString(pNpc, "conversation")
    pNpc = spawnMobile("yavin4", "light_jedi_padawan", 1, 8.19517, -15.1, -21.2002, 310, 8525418)
    self:setMoodString(pNpc, "conversation")
    pNpc = spawnMobile("yavin4", "light_jedi_padawan", 1, 22.2519, -15.1, -0.980868, 277, 8525418)
    self:setMoodString(pNpc, "conversation")

    pNpc = spawnMobile("yavin4", "jedi_shop_keeper", 1, -2.55, -18.88, 31.51, 314, 8525439)
    self:setMoodString(pNpc, "conversation")
    pNpc = spawnMobile("yavin4", "jedi_quest_giver", 1, 2.49, -18.88, 31.33, 42, 8525439)
    self:setMoodString(pNpc, "conversation")

    
	pNpc = spawnMobile("yavin4", "mouse_droid", 1, -3.81335, -15.1, 24.9568, 254, 8525418)

	if (pNpc ~= nil) then
		writeData(SceneObject(pNpc):getObjectID() .. ":currentLoc", 1)
		writeStringData(SceneObject(pNpc):getObjectID() .. ":name", "droid1")
		createEvent(1000, "LightJediScreenPlay", "setupDroidPatrol", pNpc, "")
	end

	pNpc = spawnMobile("yavin4", "mouse_droid", 1, -18.6888, -15.1, -17.5874, 143, 8525418)
    
	if (pNpc ~= nil) then
		writeData(SceneObject(pNpc):getObjectID() .. ":currentLoc", 1)
		writeStringData(SceneObject(pNpc):getObjectID() .. ":name", "droid2")
		createEvent(1000, "LightJediScreenPlay", "setupDroidPatrol", pNpc, "")
	end
    
    pNpc = spawnMobile("yavin4", "mouse_droid", 1, 24.0452, -15.1, 9.06116, 341, 8525418)

	if (pNpc ~= nil) then
		writeData(SceneObject(pNpc):getObjectID() .. ":currentLoc", 1)
		writeStringData(SceneObject(pNpc):getObjectID() .. ":name", "droid3")
		createEvent(1000, "LightJediScreenPlay", "setupDroidPatrol", pNpc, "")
	end

    pNpc = spawnMobile("yavin4", "mouse_droid", 1, -12.0362, -18.8883, -23.0001, 113, 8525436)

    if (pNpc ~= nil) then
        writeData(SceneObject(pNpc):getObjectID() .. ":currentLoc", 1)
        writeStringData(SceneObject(pNpc):getObjectID() .. ":name", "droid4")
        createEvent(1000, "LightJediScreenPlay", "setupDroidPatrol", pNpc, "")
    end

    pNpc = spawnMobile("yavin4", "mouse_droid", 1, -16.6321, -18.8883, 21.2009, 143, 8525434)

    if (pNpc ~= nil) then
        writeData(SceneObject(pNpc):getObjectID() .. ":currentLoc", 1)
        writeStringData(SceneObject(pNpc):getObjectID() .. ":name", "droid5")
        createEvent(1000, "LightJediScreenPlay", "setupDroidPatrol", pNpc, "")
    end

    pNpc = spawnMobile("yavin4", "mouse_droid", 1, 20.686, -18.8883, 17.8614, 143, 8525438)

    if (pNpc ~= nil) then
        writeData(SceneObject(pNpc):getObjectID() .. ":currentLoc", 1)
        writeStringData(SceneObject(pNpc):getObjectID() .. ":name", "droid6")
        createEvent(1000, "LightJediScreenPlay", "setupDroidPatrol", pNpc, "")
    end

    pNpc = spawnMobile("yavin4", "mouse_droid", 1, 12.8025, -18.8883, -24.1243, 143, 8525436)

    if (pNpc ~= nil) then
        writeData(SceneObject(pNpc):getObjectID() .. ":currentLoc", 1)
        writeStringData(SceneObject(pNpc):getObjectID() .. ":name", "droid7")
        createEvent(1000, "LightJediScreenPlay", "setupDroidPatrol", pNpc, "")
    end
end

function LightJediScreenPlay:setupDroidPatrol(pDroid)
	createEvent(getRandomNumber(350,450) * 100, "LightJediScreenPlay", "droidPatrol", pDroid, "")
	createObserver(DESTINATIONREACHED, "LightJediScreenPlay", "retreatPatrolDestReached", pDroid)
	AiAgent(pDroid):setMovementState(AI_PATROLLING)
end