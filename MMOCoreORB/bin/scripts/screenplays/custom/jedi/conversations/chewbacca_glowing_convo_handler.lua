chewbaccaConvoHandler = conv_handler:new {}

function chewbaccaConvoHandler:getInitialScreen(pPlayer, nNpc, pConvTemplate)
  local convoTemplate = LuaConversationTemplate(pConvTemplate)

  if (CreatureObject(pPlayer):hasScreenPlayState(1, "han_solo_glowing") or CreatureObject(pPlayer):hasScreenPlayState(1, "piece_of_eight_four")) then
    return convoTemplate:getScreen("friendly")
  else 
    return convoTemplate:getScreen("cautious")
  end
end

function chewbaccaConvoHandler:runScreenHandlers(pConvTemplate, pPlayer, pNpc, selectedOption, pConvScreen)
  local screen = LuaConversationScreen(pConvScreen)

	local convoTemplate = LuaConversationTemplate(pConvTemplate)
	local pConvScreen = screen:cloneScreen()
	local clonedConversation = LuaConversationScreen(pConvScreen)

	local screenID = screen:getScreenID()
	local playerID = SceneObject(pPlayer):getObjectID()
	local npcID = SceneObject(pNpc):getObjectID()

  local pGhost = CreatureObject(pPlayer):getPlayerObject()

	if (pGhost == nil) then
		return pConvScreen
	end

	local ghost = LuaPlayerObject(pGhost)

  local canSpeakWookie = CreatureObject(pPlayer):hasSkill("social_language_wookiee_comprehend")

  if (screenID == "friendly") then
    if (canSpeakWookie) then
      clonedConversation:setCustomDialogText("Friend! It is good to see you again!")
    else
      clonedConversation:setCustomDialogText("Raaaargh! Wyaaaaaa anaaa wyaaaaaa ruuuurgh!")
    end
  else 
    if (canSpeakWookie) then
      clonedConversation:setCustomDialogText("Why are you here?")
    else
      clonedConversation:setCustomDialogText("Ruurgh huuurrr aaanachoo?")
    end
  end

  return pConvScreen
end
