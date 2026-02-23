local QuestManager = require("managers.quest.quest_manager")

rewardThirdConvoHandler = conv_handler:new {}

function rewardThirdConvoHandler:getInitialScreen(pPlayer, pNpc, pConvTemplate)
  local convoTemplate = LuaConversationTemplate(pConvTemplate)

	local playerID = SceneObject(pPlayer):getObjectID()

	if (RewardThirdEncounter:doesRewarderBelongToThePlayer(pPlayer, pNpc) and CreatureObject(pPlayer):hasScreenPlayState(1, "ArenaRewardThird")) then
		return convoTemplate:getScreen("greeting")
	end

	return convoTemplate:getScreen("nothing_to_discuss")
end

function rewardThirdConvoHandler:runScreenHandlers(pConvTemplate, pPlayer, pNpc, selectedOption, pConvScreen)
	local screen = LuaConversationScreen(pConvScreen)

	local convoTemplate = LuaConversationTemplate(pConvTemplate)
	local pConvScreen = screen:cloneScreen()
	local clonedConversation = LuaConversationScreen(pConvScreen)

	local screenID = screen:getScreenID()
	local playerID = SceneObject(pPlayer):getObjectID()
	local npcID = SceneObject(pNpc):getObjectID()

	local pGhost = CreatureObject(pPlayer):getPlayerObject()

	if (screenID == "greeting") then
		CreatureObject(pPlayer):addCashCredits(100000, true)
		CreatureObject(pPlayer):sendSystemMessage("You have received 100,000 credits for your third place finish in the arena!")
		CreatureObject(pPlayer):awardExperience("combat_gladiator", 500, true)
		-- CreatureObject(pPlayer):addCashCredits(2, true)
		-- CreatureObject(pPlayer):sendSystemMessage("You have received 2 credits for your third place finish in the arena!")
		-- CreatureObject(pPlayer):awardExperience("combat_gladiator", 2, true)
		CreatureObject(pPlayer):removeScreenPlayState(1, "ArenaRewardThird")
		RewardThirdEncounter:handleDespawnEvent(pPlayer)
	end
	
	return pConvScreen
end

