hanSoloConvoHandler = conv_handler:new {}

function hanSoloConvoHandler:getInitialScreen(pPlayer, nNpc, pConvTemplate)
  local convoTemplate = LuaConversationTemplate(pConvTemplate)

  if (not CreatureObject(pPlayer):hasScreenPlayState(1, "glowy_trial_1")) then
    return convoTemplate:getScreen("not_ready")
  elseif (CreatureObject(pPlayer):hasScreenPlayState(1, "piece_of_eight_four")) then
    return convoTemplate:getScreen("quest_complete_return")
  elseif (CreatureObject(pPlayer):hasScreenPlayState(2, "han_solo_glowing")) then
    return convoTemplate:getScreen("quest_complete")
  elseif (CreatureObject(pPlayer):hasScreenPlayState(1, "han_solo_glowing")) then
    return convoTemplate:getScreen("accept_quest_active")
  else
    return convoTemplate:getScreen("first_screen")
  end

end

function hanSoloConvoHandler:runScreenHandlers(pConvTemplate, pPlayer, pNpc, selectedOption, pConvScreen)
  local screen = LuaConversationScreen(pConvScreen)

	local convoTemplate = LuaConversationTemplate(pConvTemplate)
	local pConvScreen = screen:cloneScreen()
	local clonedConversation = LuaConversationScreen(pConvScreen)

	local screenID = screen:getScreenID()
	local playerID = SceneObject(pPlayer):getObjectID()
	local npcID = SceneObject(pNpc):getObjectID()

  local pGhost = CreatureObject(pPlayer):getPlayerObject()

	if (pGhost == nil) then
		return pClonedScreen
	end

	local ghost = LuaPlayerObject(pGhost)

  local isImperial = CreatureObject(pPlayer):isImperial()

  if (screenID == "quest_complete") then
    CreatureObject(pPlayer):addCashCredits(10000, true)
    CreatureObject(pPlayer):sendSystemMessage("Han Solo hands you a piece of the orb")
    CreatureObject(pPlayer):setScreenPlayState(1, "piece_of_eight_four")
  elseif (screenID == "accept_quest") then
    CreatureObject(pPlayer):setScreenPlayState(1, "han_solo_glowing")
  elseif (screenID == "first_screen") then
    if (isImperial) then
      clonedConversation:addOption("Wait, aren't you Han Solo? You're under arrest for crimes against the Empire!", "imperial")
    end
  end

  return pConvScreen
end

