local QuestManager = require("managers.quest.quest_manager")

rewardSecondConvoHandler = conv_handler:new {}

function rewardSecondConvoHandler:getInitialScreen(pPlayer, pNpc, pConvTemplate)
  local convoTemplate = LuaConversationTemplate(pConvTemplate)

	local playerID = SceneObject(pPlayer):getObjectID()

	if (RewardSecondEncounter:doesRewarderBelongToThePlayer(pPlayer, pNpc) and CreatureObject(pPlayer):hasScreenPlayState(1, "ArenaRewardSecond")) then
		return convoTemplate:getScreen("greeting")
	end

    return convoTemplate:getScreen("nothing_to_discuss")  
end

function rewardSecondConvoHandler:runScreenHandlers(pConvTemplate, pPlayer, pNpc, selectedOption, pConvScreen)
	local screen = LuaConversationScreen(pConvScreen)

	local convoTemplate = LuaConversationTemplate(pConvTemplate)
	local pConvScreen = screen:cloneScreen()
	local clonedConversation = LuaConversationScreen(pConvScreen)

	local screenID = screen:getScreenID()
	local playerID = SceneObject(pPlayer):getObjectID()
	local npcID = SceneObject(pNpc):getObjectID()

	local pGhost = CreatureObject(pPlayer):getPlayerObject()

	if (screenID == "greeting") then
		CreatureObject(pPlayer):addCashCredits(500000, true)
		CreatureObject(pPlayer):sendSystemMessage("You have received 500,000 credits for your second place finish in the arena!")
		CreatureObject(pPlayer):awardExperience("combat_gladiator", 2500, true)
		-- CreatureObject(pPlayer):addCashCredits(5, true)
		-- CreatureObject(pPlayer):sendSystemMessage("You have received 5 credits for your second place finish in the arena!")
		-- CreatureObject(pPlayer):awardExperience("combat_gladiator", 5, true)
		CreatureObject(pPlayer):removeScreenPlayState(1, "ArenaRewardSecond")
		RewardSecondEncounter:handleDespawnEvent(pPlayer)
	end
	
	return pConvScreen
end

