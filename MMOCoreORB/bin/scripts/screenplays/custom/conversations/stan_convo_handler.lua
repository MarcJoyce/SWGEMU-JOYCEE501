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
	local playerID = SceneObject(pPlayer):getObjectID()
	local npcID = SceneObject(pNpc):getObjectID()

	local pGhost = CreatureObject(pPlayer):getPlayerObject()

	if (screenID == "what_do_you_sell") then
		if (CreatureObject(pPlayer):hasScreenPlayState(1, "glowy_trial_1") and not CreatureObject(pPlayer):hasScreenPlayState(2, "glowy_trial_1")) then
			clonedConversation:addOption("I'm looking for something  related to the ancient force mystics, have you heard anything about that?", "glowy_trial_1_rumour")
		end
	elseif (screenID == "glowy_trial_1_rumour") then
		if (selogelConvoHandler:collectedHowManyTrial1Pieces(pPlayer) > 6 and not CreatureObject(pPlayer):hasScreenPlayState(1, "piece_of_eight_seven")) then
			clonedConversation:addOption("Is there anything else you know? I am willing to pay for this information.", "glowy_trial_1_rumour_two")
		end
		clonedConversation:addOption("Thanks for the tip!", "goodbye")
	elseif (screenID == "what_else") then
		awardSkill(pPlayer, "social_language_basic_speak");
		awardSkill(pPlayer, "social_language_basic_comprehend");
		awardSkill(pPlayer, "social_language_rodian_speak");
		awardSkill(pPlayer, "social_language_rodian_comprehend");
		awardSkill(pPlayer, "social_language_trandoshan_speak");
		awardSkill(pPlayer, "social_language_trandoshan_comprehend");
		awardSkill(pPlayer, "social_language_moncalamari_speak");
		awardSkill(pPlayer, "social_language_moncalamari_comprehend");
		awardSkill(pPlayer, "social_language_wookiee_speak");
		awardSkill(pPlayer, "social_language_wookiee_comprehend");
		awardSkill(pPlayer, "social_language_bothan_speak");
		awardSkill(pPlayer, "social_language_bothan_comprehend");
		awardSkill(pPlayer, "social_language_twilek_speak");
		awardSkill(pPlayer, "social_language_twilek_comprehend");
		awardSkill(pPlayer, "social_language_zabrak_speak");
		awardSkill(pPlayer, "social_language_zabrak_comprehend");
		awardSkill(pPlayer, "social_language_lekku_speak");
		awardSkill(pPlayer, "social_language_lekku_comprehend");
		awardSkill(pPlayer, "social_language_ithorian_speak");
		awardSkill(pPlayer, "social_language_ithorian_comprehend");
		awardSkill(pPlayer, "social_language_sullustan_speak");
		awardSkill(pPlayer, "social_language_sullustan_comprehend");
	end

	return pConvScreen
end

