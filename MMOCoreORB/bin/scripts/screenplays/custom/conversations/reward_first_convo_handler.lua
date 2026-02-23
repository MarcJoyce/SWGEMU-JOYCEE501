local QuestManager = require("managers.quest.quest_manager")

rewardFirstConvoHandler = conv_handler:new {}

function rewardFirstConvoHandler:getInitialScreen(pPlayer, pNpc, pConvTemplate)
  local convoTemplate = LuaConversationTemplate(pConvTemplate)

	local playerID = SceneObject(pPlayer):getObjectID()

	if (RewardFirstEncounter:doesRewarderBelongToThePlayer(pPlayer, pNpc) and CreatureObject(pPlayer):hasScreenPlayState(1, "ArenaRewardFirst")) then
		return convoTemplate:getScreen("greeting")
	end

    return convoTemplate:getScreen("nothing_to_discuss")    
end

function rewardFirstConvoHandler:runScreenHandlers(pConvTemplate, pPlayer, pNpc, selectedOption, pConvScreen)
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
		CreatureObject(pPlayer):sendSystemMessage("You have received 500,000 credits for your first place finish in the arena!")
		CreatureObject(pPlayer):awardExperience("combat_gladiator", 2500, true)
		-- CreatureObject(pPlayer):addCashCredits(10, true)
		-- CreatureObject(pPlayer):sendSystemMessage("You have received 10 credits for your first place finish in the arena!")
		-- CreatureObject(pPlayer):awardExperience("combat_gladiator", 10, true)
		CreatureObject(pPlayer):removeScreenPlayState(1, "ArenaRewardFirst")
		RewardFirstEncounter:handleDespawnEvent(pPlayer)
	end
	
	return pConvScreen
end

