local QuestManager = require("managers.quest.quest_manager")

stanConvoHandler = conv_handler:new {}

function stanConvoHandler:getInitialScreen(pPlayer, pNpc, pConvTemplate)
  local convoTemplate = LuaConversationTemplate(pConvTemplate)

	local playerID = SceneObject(pPlayer):getObjectID()

	local accountID = 0

  return convoTemplate:getScreen("hello")
end

function stanConvoHandler:runScreenHandlers(pConvTemplate, pPlayer, pNpc, selectedOption, pConvScreen)
	local screen = LuaConversationScreen(pConvScreen)

	local convoTemplate = LuaConversationTemplate(pConvTemplate)
	local pConvScreen = screen:cloneScreen()
	local clonedConversation = LuaConversationScreen(pConvScreen)

	local screenID = screen:getScreenID()
	-- local playerID = SceneObject(pPlayer):getObjectID()
	-- local npcID = SceneObject(pNpc):getObjectID()

	-- local pGhost = CreatureObject(pPlayer):getPlayerObject()

	if (screenID == "what_do_you_sell") then
		if (CreatureObject(pPlayer):hasScreenPlayState(1, "glowy_trial_1") and not CreatureObject(pPlayer):hasScreenPlayState(2, "glowy_trial_1")) then
			clonedConversation:addOption("I'm looking for something  related to the ancient force mystics, have you heard anything about that?", "glowy_trial_1_rumour")
		end
	elseif (screenID == "glowy_trial_1_rumour") then
		if (selogelConvoHandler:collectedHowManyTrial1Pieces(pPlayer) > 6 and not CreatureObject(pPlayer):hasScreenPlayState(1, "piece_of_eight_seven")) then
			clonedConversation:addOption("Is there anything else you know? I am willing to pay for this information.", "glowy_trial_1_rumour_two")
		end
		clonedConversation:addOption("Thanks for the tip!", "goodbye")
	end

	return pConvScreen
end

