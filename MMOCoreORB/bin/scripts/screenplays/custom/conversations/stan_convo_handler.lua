local QuestManager = require("managers.quest.quest_manager")

stanConvoHandler = conv_handler:new {}

function stanConvoHandler:getInitialScreen(pPlayer, pNpc, pConvTemplate)
  local convoTemplate = LuaConversationTemplate(pConvTemplate)

	local playerID = SceneObject(pPlayer):getObjectID()

	local accountID = 0
	local pAdminPlayer = getCreatureObject(281474993547517)

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

	local pAdminPlayer = getCreatureObject(281474993547517)

	local cooldown = tonumber(readScreenPlayData(pPlayer, "StanMeatlump", "cooldown")) or 0
	local randomNumber = getRandomNumber(100)

	local planet = tostring(readScreenPlayData(pAdminPlayer, "MeatlumpKingTheatre", "planet"))
	local x = tonumber(readScreenPlayData(pAdminPlayer, "MeatlumpKingTheatre", "x"))
	local y = tonumber(readScreenPlayData(pAdminPlayer, "MeatlumpKingTheatre", "y"))

	if (screenID == "what_do_you_sell") then
		if (CreatureObject(pPlayer):hasScreenPlayState(1, "glowy_trial_1") and not CreatureObject(pPlayer):hasScreenPlayState(2, "glowy_trial_1")) then
			clonedConversation:addOption("I'm looking for something  related to the ancient force mystics, have you heard anything about that?", "glowy_trial_1_rumour")
		end
		if (randomNumber > 15 and cooldown <= os.time()) then
			clonedConversation:addOption("Have you heard anything about a Meatlump King?", "meatlump_king_location")
		else 
			writeScreenPlayData(pPlayer, "StanMeatlump", "cooldown", os.time() + (30 * 60))
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
	elseif (screenID == "meatlump_king_location") then
		clonedConversation:setCustomDialogText("Ah, the false royal, claiming domain over all the galaxy. He's worse than the Hutt that one. Yes, I know where he is. Head to " .. planet .. ". I have marked the exact coordinates in your datapad. Do the galaxy a favour and get rid of him. But hurry, he rarely stays in one place for long.")

		PlayerObject(pGhost):addWaypoint(planet, "The false royal.", "", x, 0, y, WAYPOINT_YELLOW, true, true, WAYPOINTQUESTTASK)
	end

	return pConvScreen
end

