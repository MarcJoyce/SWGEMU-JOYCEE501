thalosKrennConvoHandler = conv_handler:new {}

function thalosKrennConvoHandler:getInitialScreen(pPlayer, nNpc, pConvTemplate)
  local convoTemplate = LuaConversationTemplate(pConvTemplate)

  if (CreatureObject(pPlayer):hasScreenPlayState(1, "piece_of_eight_seven")) then
    return convoTemplate:getScreen("complete")
  elseif (not CreatureObject(pPlayer):hasScreenPlayState(1, "glowy_trial_1")) then
    return convoTemplate:getScreen("not_ready")
  else
    return convoTemplate:getScreen("first_screen")
  end
end

function thalosKrennConvoHandler:runScreenHandlers(pConvTemplate, pPlayer, pNpc, selectedOption, pConvScreen)
  local screen = LuaConversationScreen(pConvScreen)

	local convoTemplate = LuaConversationTemplate(pConvTemplate)
	local pConvScreen = screen:cloneScreen()
	local clonedConversation = LuaConversationScreen(pConvScreen)

	local screenID = screen:getScreenID()
	local playerID = SceneObject(pPlayer):getObjectID()
	local npcID = SceneObject(pNpc):getObjectID()

  if (screenID == "reward") then
    CreatureObject(pPlayer):setScreenPlayState(1, "piece_of_eight_seven")
    CreatureObject(pPlayer):sendSystemMessage("Thalos Krenn hands you a piece of the orb")
  end

  return pConvScreen
end
