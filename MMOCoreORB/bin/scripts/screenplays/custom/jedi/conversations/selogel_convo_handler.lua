local ObjectManager = require("managers.object.object_manager")

selogelConvoHandler = conv_handler:new {}

-- trials = {
	-- 	1 = {
	-- 		states = {
	-- 			1, -- Quest accepted
	-- 			2, -- Quest complete but not turned in
	-- 			4  -- Quest complete and turned in
	-- 		}
	-- 	},
	-- 	2 = {
	-- 		options = {
	-- 			{ "combat_brawler_master"},
	-- 			{ "combat_carbine_master"},
	-- 			{ "combat_commando_master"},
	-- 			{ "combat_1hsword_master"},
	-- 			{ "combat_marksman_master"},
	-- 			{ "combat_polearm_master"},
	-- 			{ "combat_pistol_master"},
	-- 			{ "combat_rifleman_master"},
	-- 			{ "combat_smuggler_master"},
	-- 			{ "combat_2hsword_master"},
	-- 			{ "combat_unarmed_master"}
	-- 		},
	-- 		states = {
	-- 			1, -- Quest accepted
	-- 			2, -- Quest complete but not turned in
	-- 			4  -- Quest complete and turned in
	-- 		}
	-- 	},
	-- 	3 = {
	-- 		states = {
	-- 			1, -- Quest accepted
	-- 			2, -- Quest complete but not turned in
	-- 			4  -- Quest complete and turned in
	-- 		}
	-- 	},
	-- 	4 = {
	-- 		options = {
	-- 			{ "crafting_architect_master"},
	-- 			{ "crafting_armorsmith_master"},
	-- 			{ "crafting_artisan_master"},
	-- 			{ "outdoors_bio_engineer_master"},
	-- 			{ "crafting_chef_master"},
	-- 			{ "science_combatmedic_master"},
	-- 			{ "outdoors_creaturehandler_master"},
	-- 			{ "social_dancer_master"},
	-- 			{ "science_doctor_master"},
	-- 			{ "crafting_droidengineer_master"},
	-- 			{ "social_entertainer_master"},
	-- 			{ "social_imagedesigner_master"},
	-- 			{ "science_medic_master"},
	-- 			{ "crafting_merchant_master"},
	-- 			{ "social_musician_master"},
	-- 			{ "outdoors_ranger_master"},
	-- 			{ "outdoors_scout_master"},
	-- 			{ "outdoors_squadleader_master"},
	-- 			{ "crafting_tailor_master"},
	-- 			{ "crafting_weaponsmith_master"},
	-- 		},
	-- 		states = {
	-- 			1, -- Quest accepted
	-- 			2, -- Quest complete but not turned in
	-- 			4  -- Quest complete and turned in
	-- 		}
	-- 	},
	-- 	5 = {
	-- 		states = {
	-- 			1, -- Quest accepted
	-- 			2, -- Quest complete but not turned in
	-- 			4  -- Quest complete and turned in
	-- 		}
	-- 	},
	-- 	6 = {
	-- 		states = {
	-- 			1, -- Quest accepted
	-- 			2, -- Quest complete but not turned in
	-- 			4  -- Quest complete and turned in
	-- 		}
	-- 	},
	-- 	7 = {
	-- 		states = {
	-- 			1, -- Quest accepted
	-- 			2, -- Quest complete but not turned in
	-- 			4  -- Quest complete and turned in
	-- 		}
	-- 	},
	-- 	8 = {
	-- 		states = {
	-- 			1, -- Quest accepted
	-- 			2, -- Quest complete but not turned in
	-- 			4  -- Quest complete and turned in
	-- 		}
	-- 	},
	-- }

function selogelConvoHandler:getInitialScreen(pPlayer, pNpc, pConvTemplate)
	local convoTemplate = LuaConversationTemplate(pConvTemplate)

	local playerID = SceneObject(pPlayer):getObjectID()

	local accountID = 0
	local pGhost = CreatureObject(pPlayer):getPlayerObject()

	if pGhost == nil then
		
	else
		accountID = PlayerObject(pGhost):getAccountID()
	end

	if (not accountID == 17) then
		return convoTemplate:getScreen("hello_friend")
	elseif (CreatureObject(pPlayer):hasScreenPlayState(2, "glowy_trial_8")) then	
		return convoTemplate:getScreen("trial_8_complete")
	elseif (CreatureObject(pPlayer):hasScreenPlayState(1, "glowy_trial_8")) then	
		return convoTemplate:getScreen("trial_8_ongoing")
	elseif (CreatureObject(pPlayer):hasScreenPlayState(2, "glowy_trial_7")) then	
		return convoTemplate:getScreen("trial_7_complete")
	elseif (CreatureObject(pPlayer):hasScreenPlayState(1, "glowy_trial_7")) then	
		return convoTemplate:getScreen("trial_7_ongoing")
	elseif (CreatureObject(pPlayer):hasScreenPlayState(2, "glowy_trial_6")) then	
		return convoTemplate:getScreen("trial_6_complete")
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
	elseif (CreatureObject(pPlayer):hasScreenPlayState(1, "piece_of_eight_one") and CreatureObject(pPlayer):hasScreenPlayState(1, "piece_of_eight_two") and CreatureObject(pPlayer):hasScreenPlayState(1, "piece_of_eight_three") and CreatureObject(pPlayer):hasScreenPlayState(1, "piece_of_eight_four") and CreatureObject(pPlayer):hasScreenPlayState(1, "piece_of_eight_five") and CreatureObject(pPlayer):hasScreenPlayState(1, "piece_of_eight_six") and CreatureObject(pPlayer):hasScreenPlayState(1, "piece_of_eight_seven") and CreatureObject(pPlayer):hasScreenPlayState(1, "piece_of_eight_eight")) then
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
		
		createObserver(KILLEDCREATURE, "CustomGlowingScreenPlay", "notifyKilledCreatureTrialOnePieceTwo", pPlayer)

	elseif screenID == "trial_2_start" then
		CreatureObject(pPlayer):setScreenPlayState(1, "glowy_trial_2");
		local professionString = self:getAndSetProfession(pPlayer, "combat", "Trial2")
		CreatureObject(pPlayer):sendSystemMessage(professionString)
	elseif screenID == "trial_2_ongoing" then
		CreatureObject(pPlayer):sendSystemMessage(self:getProfessionString(pPlayer, "combat", "Trial2"))
	elseif screenID == "trial_3_start" then
		CreatureObject(pPlayer):setScreenPlayState(1, "glowy_trial_3");
		CreatureObject(pPlayer):setScreenPlayState(1, "shadows_one");
		ShadowsIntroTheatre:start(pPlayer)
	elseif screenID == "trial_4_start" then
		CreatureObject(pPlayer):setScreenPlayState(1, "glowy_trial_4");
		local professionString = self:getAndSetProfession(pPlayer, "support", "Trial4")
		CreatureObject(pPlayer):sendSystemMessage(professionString)
	elseif screenID == "trial_4_ongoing" then
		CreatureObject(pPlayer):sendSystemMessage(self:getProfessionString(pPlayer, "support", "Trial4"))
	elseif screenID == "trial_5_start" then
		CreatureObject(pPlayer):setScreenPlayState(1, "glowy_trial_5");
	elseif screenID == "trial_6_start" then
		CreatureObject(pPlayer):setScreenPlayState(1, "glowy_trial_6");
	elseif screenID == "trial_7_start" then
		CreatureObject(pPlayer):setScreenPlayState(1, "glowy_trial_7");
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
