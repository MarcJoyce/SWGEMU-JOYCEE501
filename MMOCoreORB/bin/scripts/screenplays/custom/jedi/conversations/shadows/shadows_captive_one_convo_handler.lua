shadowsCaptiveOneConvoHandler = conv_handler:new {}

function shadowsCaptiveOneConvoHandler:getInitialScreen(pPlayer, nNpc, pConvTemplate)
  local convoTemplate = LuaConversationTemplate(pConvTemplate)

  if (CreatureObject(pPlayer):hasScreenPlayState(2, "shadows_one")) then
    return convoTemplate:getScreen("screen_four")
  end

  return convoTemplate:getScreen("screen_one")
end

function shadowsCaptiveOneConvoHandler:runScreenHandlers(pConvTemplate, pPlayer, pNpc, selectedOption, pConvScreen)
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

  if (screenID == "screen_four") then
    if (not CreatureObject(pPlayer):hasScreenPlayState(2, "shadows_one"))  then
      CreatureObject(pPlayer):setScreenPlayState(2, "shadows_one")
      CreatureObject(pPlayer):setScreenPlayState(1, "shadows_two")
      ShadowsScreenPlay:endShadowsIntroTheatre(pPlayer)
      ShadowsScreenPlay:startShadowsGuardDetail(pPlayer)
    end
  end

  return pConvScreen
end