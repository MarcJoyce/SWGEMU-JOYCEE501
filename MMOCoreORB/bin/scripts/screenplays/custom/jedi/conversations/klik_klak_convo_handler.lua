klikKlakConvoHandler = conv_handler:new {}

-- ScreenPlay state (tusken_queen_head): 1 - Accepted Tusken Queen, 2 - Killed Tusken Queen
-- ScreenPlay state (glowy_trial_1): 1 - Pieces of Eight ongoing
-- ScreenPlay state (piece_of_eight_one): 1 - Completed Jawa Piece of Eight

function klikKlakConvoHandler:getInitialScreen(pPlayer, nNpc, pConvTemplate)
  local convoTemplate = LuaConversationTemplate(pConvTemplate)

  if (CreatureObject(pPlayer):hasScreenPlayState(1, "piece_of_eight_one")) then
    return convoTemplate:getScreen("go_away")
  elseif (not CreatureObject(pPlayer):hasScreenPlayState(1, "glowy_trial_1")) then
    return convoTemplate:getScreen("go_away")
  elseif (CreatureObject(pPlayer):hasScreenPlayState(2, "tusken_queen_head")) then
    return convoTemplate:getScreen("success_kill")
  elseif (CreatureObject(pPlayer):hasScreenPlayState(1, "tusken_queen_head")) then
    return convoTemplate:getScreen("no_head")
  else
    return convoTemplate:getScreen("first_screen")
  end
end

function klikKlakConvoHandler:runScreenHandlers(pConvTemplate, pPlayer, pNpc, selectedOption, pConvScreen)
  local screen = LuaConversationScreen(pConvScreen)

	local convoTemplate = LuaConversationTemplate(pConvTemplate)
	local pConvScreen = screen:cloneScreen()
	local clonedConversation = LuaConversationScreen(pConvScreen)

	local screenID = screen:getScreenID()
	local playerID = SceneObject(pPlayer):getObjectID()
	local npcID = SceneObject(pNpc):getObjectID()


  if (screenID == "klik_klak_offer_two") then
    local playerCredits = CreatureObject(pPlayer):getCashCredits()

    if (playerCredits > 9999999) then
      clonedConversation:addOption("Ok, here you go Klik Klak", "success_paid")
    else
      clonedConversation:addOption("Ok, here you go Klik Klak", "failed_payment")
    end
  elseif (screenID == "accept_kill") then
    if (not CreatureObject(pPlayer):hasScreenPlayState(1, "tusken_queen_head")) then
      CreatureObject(pPlayer):setScreenPlayState(1, "tusken_queen_head")
      createObserver(KILLEDCREATURE, "CustomGlowingScreenPlay", "notifyKilledCreatureTrialOnePieceOne", pPlayer)
    end
  elseif (screenID == "success_paid") then
    CreatureObject(pPlayer):subtractCashCredits(10000000)
    CreatureObject(pPlayer):setScreenPlayState(1, "piece_of_eight_one")
    logToFile(CreatureObject(pPlayer):getFirstName() .. " received piece_of_eight_one", "log/custom_glowing/" .. CreatureObject(pPlayer):getFirstName() .. ".log")
    CreatureObject(pPlayer):setScreenPlayState(4, "tusken_queen_head")
    CreatureObject(pPlayer):sendSystemMessage("Klik Klak hands you a piece of the orb")
  elseif (screenID == "success_kill") then
    CreatureObject(pPlayer):setScreenPlayState(1, "piece_of_eight_one")
    logToFile(CreatureObject(pPlayer):getFirstName() .. " received piece_of_eight_one", "log/custom_glowing/" .. CreatureObject(pPlayer):getFirstName() .. ".log")
    CreatureObject(pPlayer):setScreenPlayState(4, "tusken_queen_head")
    CreatureObject(pPlayer):sendSystemMessage("Klik Klak hands you a piece of the orb")
  end

  return pConvScreen
end

