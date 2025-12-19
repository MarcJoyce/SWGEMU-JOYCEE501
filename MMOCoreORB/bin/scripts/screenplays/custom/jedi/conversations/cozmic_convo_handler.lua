cozmicConvoHandler = conv_handler:new {}

function cozmicConvoHandler:getInitialScreen(pPlayer, nNpc, pConvTemplate)
  local convoTemplate = LuaConversationTemplate(pConvTemplate)

  if (CreatureObject(pPlayer):hasScreenPlayState(2, "cozmic")) then
    return convoTemplate:getScreen("quest_complete")
  elseif (CreatureObject(pPlayer):hasScreenPlayState(2, "sap")) then
    return convoTemplate:getScreen("allied_with_enemy")
  elseif (CreatureObject(pPlayer):hasScreenPlayState(1, "cozmic")) then
    return convoTemplate:getScreen("quest_ongoing")
  elseif (CreatureObject(pPlayer):hasScreenPlayState(1, "glowy_trial_5")) then
    return convoTemplate:getScreen("first_screen")
  else
    return convoTemplate:getScreen("not_ready")
  end
end

function cozmicConvoHandler:runScreenHandlers(pConvTemplate, pPlayer, pNpc, selectedOption, pConvScreen)
  local screen = LuaConversationScreen(pConvScreen)

	local convoTemplate = LuaConversationTemplate(pConvTemplate)
	local pConvScreen = screen:cloneScreen()
	local clonedConversation = LuaConversationScreen(pConvScreen)

	local screenID = screen:getScreenID()
	local playerID = SceneObject(pPlayer):getObjectID()
	local npcID = SceneObject(pNpc):getObjectID()

  local pGhost = CreatureObject(pPlayer):getPlayerObject()

  if (screenID == "quest_accept") then
    CreatureObject(pPlayer):setScreenPlayState(1, "cozmic")
    PlayerObject(pGhost):addWaypoint("endor", "Trandoshan slave leader", "", 4490.2, 30.1, -2415.9, WAYPOINT_YELLOW, true, true, 0)
    createObserver(KILLEDCREATURE, "CustomGlowingScreenPlay", "notifyKilledCreatureTrialFiveTrandoshan", pPlayer)
    return pConvScreen
  elseif (screenID == "quest_complete") then
    if (not CreatureObject(pPlayer):hasScreenPlayState(2, "glowy_trial_5")) then
      CreatureObject(pPlayer):addCashCredits(100000)
      CreatureObject(pPlayer):setScreenPlayState(2, "glowy_trial_5")
      return pConvScreen
    end
  end

  return pConvScreen
end

