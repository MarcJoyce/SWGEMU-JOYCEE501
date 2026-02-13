local ObjectManager = require("managers.object.object_manager")

selogelConvoHandler = conv_handler:new {}

function selogelConvoHandler:getInitialScreen(pPlayer, pNpc, pConvTemplate)
	local convoTemplate = LuaConversationTemplate(pConvTemplate)

	local playerID = SceneObject(pPlayer):getObjectID()

	local accountID = 0
	local pGhost = CreatureObject(pPlayer):getPlayerObject()
		
	if (CreatureObject(pPlayer):hasScreenPlayState(1, "glowy_trial_8")) then	
		return convoTemplate:getScreen("hello_friend")
	elseif (CreatureObject(pPlayer):hasScreenPlayState(1, "glowy_trial_7") and BestineElection:hasItemInInventory(pPlayer, "object/tangible/jedi/jedi_holocron_dark.iff") and BestineElection:hasItemInInventory(pPlayer, "object/tangible/jedi/jedi_holocron_light.iff")) then
		return convoTemplate:getScreen("trial_7_complete")
	elseif (CreatureObject(pPlayer):hasScreenPlayState(1, "glowy_trial_7")) then
		return convoTemplate:getScreen("trial_7_ongoing")
	elseif (CreatureObject(pPlayer):hasScreenPlayState(2, "glowy_trial_6")) then
		logToFile(CreatureObject(pPlayer):getFirstName() .. " completed trial 6", "log/custom_glowing/" .. CreatureObject(pPlayer):getFirstName() .. ".log")
		return convoTemplate:getScreen("trial_6_complete")
	elseif (tonumber(readScreenPlayData(pPlayer, "DecipherQuest", "trialsCompleted")) == 4) then
		return convoTemplate:getScreen("trial_6_complete_decipher")
	elseif (CreatureObject(pPlayer):hasScreenPlayState(1, "trial_6_decipher")) then
		return convoTemplate:getScreen("trial_6_ongoing_decipher")
	elseif (CreatureObject(pPlayer):hasScreenPlayState(2, "lazarus")) then
		return convoTemplate:getScreen("completed_lazarus")
	elseif (CreatureObject(pPlayer):hasScreenPlayState(1, "glowy_trial_6")) then	
		return convoTemplate:getScreen("trial_6_ongoing")
	elseif (CreatureObject(pPlayer):hasScreenPlayState(2, "glowy_trial_5")) then	
		return convoTemplate:getScreen("trial_5_complete")
	elseif (CreatureObject(pPlayer):hasScreenPlayState(1, "glowy_trial_5")) then	
		return convoTemplate:getScreen("trial_5_ongoing")
	elseif (CreatureObject(pPlayer):hasScreenPlayState(2, "glowy_trial_4")) then	
		return convoTemplate:getScreen("trial_4_complete")
	elseif (CreatureObject(pPlayer):hasScreenPlayState(1, "glowy_trial_4")) then	
		local playerHasProfession = self:doesPlayerHaveProfession(pPlayer, "support", "Trial4")
		if (playerHasProfession) then
			return convoTemplate:getScreen("trial_4_complete")
		end
		return convoTemplate:getScreen("trial_4_ongoing")
	elseif (CreatureObject(pPlayer):hasScreenPlayState(2, "glowy_trial_3")) then	
		return convoTemplate:getScreen("trial_3_complete")
	elseif (CreatureObject(pPlayer):hasScreenPlayState(1, "glowy_trial_3")) then	
		return convoTemplate:getScreen("trial_3_ongoing")
	elseif (CreatureObject(pPlayer):hasScreenPlayState(2, "glowy_trial_2")) then	
		return convoTemplate:getScreen("trial_2_complete")
	elseif (CreatureObject(pPlayer):hasScreenPlayState(1, "glowy_trial_2")) then	
		local playerHasProfession = self:doesPlayerHaveProfession(pPlayer, "combat", "Trial2")
		if (playerHasProfession) then
			return convoTemplate:getScreen("trial_2_complete")
		end
		return convoTemplate:getScreen("trial_2_ongoing")
	elseif (CreatureObject(pPlayer):hasScreenPlayState(2, "glowy_trial_1")) then	
		return convoTemplate:getScreen("trial_1_complete")
	-- PLAYER HAS COLLECTED ALL 8 PIECES OF THE ORB
	elseif (self:collectedHowManyTrial1Pieces(pPlayer) == 8) then
		return convoTemplate:getScreen("trial_1_complete")
	elseif (CreatureObject(pPlayer):hasScreenPlayState(1, "glowy_trial_1")) then
		return convoTemplate:getScreen("trial_1_ongoing")
	end

  return convoTemplate:getScreen("init_screen")
end

function selogelConvoHandler:runScreenHandlers(pConvTemplate, pPlayer, pNpc, selectedOption, pConvScreen)
	local screen = LuaConversationScreen(pConvScreen)
	local screenID = screen:getScreenID()
	local pConvScreen = screen:cloneScreen()
	local clonedConversation = LuaConversationScreen(pConvScreen)

	local playerID = CreatureObject(pPlayer):getObjectID()
	local pGhost = CreatureObject(pPlayer):getPlayerObject()

	if (pGhost == nil) then
		return pConvScreen
	end

	if screenID == "trial_1_start" then
		CreatureObject(pPlayer):setScreenPlayState(1, "glowy_trial_1");
		logToFile(CreatureObject(pPlayer):getFirstName() .. " has started the glowing unlock journey", "log/custom_glowing/" .. CreatureObject(pPlayer):getFirstName() .. ".log")
		createObserver(KILLEDCREATURE, "CustomGlowingScreenPlay", "notifyKilledCreatureTrialOnePieceTwo", pPlayer)
	elseif screenID == "trial_1_ongoing" then
		local piecesCollected = self:collectedHowManyTrial1Pieces(pPlayer)
		clonedConversation:setCustomDialogText("Back already? Do you have all the pieces? Let's see, you have... " .. piecesCollected .. " of 8 so far. Do you need me to remind you of the information I have?")
	elseif screenID == "trial_1_complete" then
		CreatureObject(pPlayer):setScreenPlayState(2, "glowy_trial_1")
		logToFile(CreatureObject(pPlayer):getFirstName() .. " completed trial 1", "log/custom_glowing/" .. CreatureObject(pPlayer):getFirstName() .. ".log")
	elseif screenID == "trial_2_start" then
		CreatureObject(pPlayer):setScreenPlayState(1, "glowy_trial_2");
		local professionString = self:getAndSetProfession(pPlayer, "combat", "Trial2")
		logToFile(CreatureObject(pPlayer):getFirstName() .. " combat profession: " .. professionString, "log/custom_glowing/" .. CreatureObject(pPlayer):getFirstName() .. ".log");
		CreatureObject(pPlayer):sendSystemMessage(professionString)
	elseif screenID == "trial_2_ongoing" then
		CreatureObject(pPlayer):sendSystemMessage(self:getProfessionString(pPlayer, "combat", "Trial2"))
	elseif screenID == "trial_2_complete" then
		CreatureObject(pPlayer):setScreenPlayState(2, "glowy_trial_2")
		logToFile(CreatureObject(pPlayer):getFirstName() .. " completed trial 2", "log/custom_glowing/" .. CreatureObject(pPlayer):getFirstName() .. ".log")
	elseif screenID == "trial_3_start" then
		CreatureObject(pPlayer):setScreenPlayState(1, "glowy_trial_3");
		local waypointId = PlayerObject(pGhost):addWaypoint("tatooine", "Vessa Kael", "", -1148, 98, -3893, WAYPOINT_YELLOW, true, true, 0)
		setQuestStatus(playerID .. ":vessa_kael_glowing", waypointId)
	elseif screenID == "trial_4_start" then
		CreatureObject(pPlayer):setScreenPlayState(1, "glowy_trial_4");
		local professionString = self:getAndSetProfession(pPlayer, "support", "Trial4")
		logToFile(CreatureObject(pPlayer):getFirstName() .. " support profession: " .. professionString, "log/custom_glowing/" .. CreatureObject(pPlayer):getFirstName() .. ".log");
		CreatureObject(pPlayer):sendSystemMessage(professionString)
	elseif screenID == "trial_4_ongoing" then
		CreatureObject(pPlayer):sendSystemMessage(self:getProfessionString(pPlayer, "support", "Trial4"))
	elseif screenID == "trial_4_complete" then
		CreatureObject(pPlayer):setScreenPlayState(2, "glowy_trial_4")
		logToFile(CreatureObject(pPlayer):getFirstName() .. " completed trial 4", "log/custom_glowing/" .. CreatureObject(pPlayer):getFirstName() .. ".log")
	elseif screenID == "trial_5_start" then
		CreatureObject(pPlayer):setScreenPlayState(1, "glowy_trial_5");
	elseif (screenID == "trial_5_complete") then
		local decipherTrial = getRandomNumber(1, #trialSixRiddles)
		logToFile(CreatureObject(pPlayer):getFirstName() .. " received trial number " .. tonumber(decipherTrial), "log/custom_glowing/" .. CreatureObject(pPlayer):getFirstName() .. ".log")
		writeScreenPlayData(pPlayer, "DecipherQuest", "trial", decipherTrial)
	elseif (screenID == "trial_6_explain_two") then
		local decipherQuestsCompleted = tonumber(readScreenPlayData(pPlayer, "DecipherQuest", "trialsCompleted")) or 0
		CreatureObject(pPlayer):sendSystemMessage(" \\#FFFF00\\" .. self:getTrialSixString(pPlayer, decipherQuestsCompleted))
	elseif (screenID == "completed_lazarus") then
		local decipherQuestsCompleted = tonumber(readScreenPlayData(pPlayer, "DecipherQuest", "trialsCompleted")) or 0
		CreatureObject(pPlayer):sendSystemMessage(" \\#FFFF00\\" .. self:getTrialSixString(pPlayer, decipherQuestsCompleted))
	elseif screenID == "trial_6_start" then
		CreatureObject(pPlayer):setScreenPlayState(1, "glowy_trial_6");
	elseif (screenID == "trial_6_decipher_start" ) then
		CreatureObject(pPlayer):setScreenPlayState(1, "trial_6_decipher");
		createObserver(KILLEDCREATURE, "CustomGlowingScreenPlay", "notifyKilledCreatureTrialSixKrayt", pPlayer)
		createObserver(OBJECTDESTRUCTION, "CustomGlowingScreenPlay", "notifyKilledPlayerTrialSix", pPlayer)
	elseif (screenID == "trial_6_ongoing_decipher") then
		local decipherQuestsCompleted = tonumber(readScreenPlayData(pPlayer, "DecipherQuest", "trialsCompleted")) or 0
		CreatureObject(pPlayer):sendSystemMessage(" \\#FFFF00\\" .. self:getTrialSixString(pPlayer, decipherQuestsCompleted))
	elseif (screenID == "trial_6_complete_decipher") then
		local decipherQuestsCompleted = tonumber(readScreenPlayData(pPlayer, "DecipherQuest", "trialsCompleted")) or 0
		CreatureObject(pPlayer):sendSystemMessage(" \\#FFFF00\\" .. self:getTrialSixString(pPlayer, decipherQuestsCompleted))
		createObserver(SPATIALCHATSENT, "CustomGlowingScreenPlay", "notifyChatSent", pPlayer)
	elseif screenID == "trial_7_start" then
		CreatureObject(pPlayer):setScreenPlayState(1, "glowy_trial_7");
	elseif screenID == "trial_7_complete" then
		CreatureObject(pPlayer):setScreenPlayState(2, "glowy_trial_7")
		logToFile(CreatureObject(pPlayer):getFirstName() .. " completed trial 7", "log/custom_glowing/" .. CreatureObject(pPlayer):getFirstName() .. ".log")
	elseif screenID == "trial_8_start" then
		CreatureObject(pPlayer):setScreenPlayState(1, "glowy_trial_8");
	end

	return pConvScreen
end

function selogelConvoHandler:getCombatProfessionList()
	local list = {
		-- { "combat_bountyhunter_master", "Master Bounty Hunter" },
		{ "combat_brawler_master", "Master Brawler" },
		{ "combat_carbine_master", "Master Carbineer" },
		{ "combat_commando_master", "Master Commando" },
		{ "combat_1hsword_master", "Master Fencer" },
		{ "combat_marksman_master", "Master Marksman" },
		{ "combat_polearm_master", "Master Pikeman" },
		{ "combat_pistol_master", "Master Pistoleer" },
		{ "combat_rifleman_master", "Master Rifleman" },
		{ "combat_smuggler_master", "Master Smuggler" },
		{ "combat_2hsword_master", "Master Swordsman" },
		{ "combat_unarmed_master", "Teras Kasi Master" }
	}
	return list
end

function selogelConvoHandler:getSupportProfessionList()
	local list = {
		{ "crafting_architect_master", "Master Architect" },
		{ "crafting_armorsmith_master", "Master Armorsmith" },
		{ "crafting_artisan_master", "Master Artisan" },
		{ "outdoors_bio_engineer_master", "Master BioEngineer" },
		{ "crafting_chef_master", "Master Chef" },
		{ "science_combatmedic_master", "Master Combat Medic" },
		{ "outdoors_creaturehandler_master", "Master Creature Handler" },
		{ "social_dancer_master", "Master Dancer" },
		{ "science_doctor_master", "Master Doctor" },
		{ "crafting_droidengineer_master", "Master DroidEngineer" },
		{ "social_entertainer_master", "Master Entertainer" },
		-- { "social_imagedesigner_master", "Master Image Designer" },
		{ "science_medic_master", "Master Medic" },
		-- { "crafting_merchant_master", "Master Merchant" },
		{ "social_musician_master", "Master Musician" },
		{ "outdoors_ranger_master", "Master Ranger" },
		{ "outdoors_scout_master", "Master Scout" },
		{ "outdoors_squadleader_master", "Master Squad Leader" },
		{ "crafting_tailor_master", "Master Tailor" },
		{ "crafting_weaponsmith_master", "Master Weaponsmith" },
	}
	return list
end

function selogelConvoHandler:getAndSetProfession(pPlayer, professionType, trialNumber)
	local skillList

	if (professionType == "combat") then
		skillList = self:getCombatProfessionList()
	else 
		skillList = self:getSupportProfessionList()
	end

	for i = 1, #skillList, 1 do
		local numberOfSkillsInList = #skillList
		local skillNumber = getRandomNumber(1, numberOfSkillsInList)
		
		if (not CreatureObject(pPlayer):hasSkill(skillList[skillNumber][1])) then
			writeScreenPlayData(pPlayer, "CustomGlowyScreenPlay", trialNumber, skillNumber)
			return skillList[skillNumber][2]
		end
	end

	return
end

function selogelConvoHandler:getProfessionString(pPlayer, professionType, trialNumber)
	local skillList

	if (professionType == "combat") then
		skillList = self:getCombatProfessionList()
	else 
		skillList = self:getSupportProfessionList()
	end

	if (tonumber(readScreenPlayData(pPlayer, "CustomGlowyScreenPlay", trialNumber)) > 0) then
		return skillList[tonumber(readScreenPlayData(pPlayer, "CustomGlowyScreenPlay", trialNumber))][2]
	end
end

function selogelConvoHandler:doesPlayerHaveProfession(pPlayer, professionType, trialNumber)
	local skillList

	if (professionType == "combat") then
		skillList = self:getCombatProfessionList()
	else 
		skillList = self:getSupportProfessionList()
	end

	if (tonumber(readScreenPlayData(pPlayer, "CustomGlowyScreenPlay", trialNumber)) > 0) then
		return CreatureObject(pPlayer):hasSkill(skillList[tonumber(readScreenPlayData(pPlayer, "CustomGlowyScreenPlay", trialNumber))][1])
	end
end

function selogelConvoHandler:getTrialSixString(pPlayer, num) 
	local trialNumber = tonumber(readScreenPlayData(pPlayer, "DecipherQuest", "trial"))

	local trialData = trialSixRiddles[trialNumber]

	return self:jumbleString(trialData.line, num)
end

function selogelConvoHandler:log(message)
  local outputFile = "log/selogel.log"
  logToFile(message, outputFile)
end

function selogelConvoHandler:jumbleString(str, intensity)
    math.randomseed(os.time())

    local jumbleFraction = (4- intensity) * 0.25

    local chars = {}
    for c in str:gmatch(".") do
        table.insert(chars, c)
    end

    local letterIndices = {}
    for i, c in ipairs(chars) do
        if c:match("%a") then
            table.insert(letterIndices, i)
        end
    end

    local jumbleCount = math.floor(#letterIndices * jumbleFraction + 0.5)
    if jumbleCount == 0 then return str end

    local selectedIndices = {}
    local temp = {table.unpack(letterIndices)}
    for i = 1, jumbleCount do
        local idx = math.random(#temp)
        table.insert(selectedIndices, temp[idx])
        table.remove(temp, idx)
    end

    local lettersToJumble = {}
    for _, idx in ipairs(selectedIndices) do
        table.insert(lettersToJumble, chars[idx])
    end

    for i = #lettersToJumble, 2, -1 do
        local j = math.random(i)
        lettersToJumble[i], lettersToJumble[j] = lettersToJumble[j], lettersToJumble[i]
    end

    for i, idx in ipairs(selectedIndices) do
        chars[idx] = lettersToJumble[i]
    end

    return table.concat(chars)
end

function selogelConvoHandler:collectedHowManyTrial1Pieces(pPlayer)
	local num = 0

	if (CreatureObject(pPlayer):hasScreenPlayState(1, "piece_of_eight_one")) then
		num = num + 1	
	end
	if (CreatureObject(pPlayer):hasScreenPlayState(1, "piece_of_eight_two")) then
		num = num + 1	
	end
	if (CreatureObject(pPlayer):hasScreenPlayState(1, "piece_of_eight_three")) then
		num = num + 1	
	end
	if (CreatureObject(pPlayer):hasScreenPlayState(1, "piece_of_eight_four")) then
		num = num + 1	
	end
	if (CreatureObject(pPlayer):hasScreenPlayState(1, "piece_of_eight_five")) then
		num = num + 1	
	end
	if (CreatureObject(pPlayer):hasScreenPlayState(1, "piece_of_eight_six")) then
		num = num + 1	
	end
	if (CreatureObject(pPlayer):hasScreenPlayState(1, "piece_of_eight_seven")) then
		num = num + 1	
	end
	if (CreatureObject(pPlayer):hasScreenPlayState(1, "piece_of_eight_eight")) then
		num = num + 1	
	end

	return num
		
end
